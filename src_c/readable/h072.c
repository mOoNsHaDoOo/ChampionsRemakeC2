/* H072: il tempio, cure a pagamento per il personaggio corrente. */
#include <string.h>
#include "h072.h"
#include "init_data.h"
#include "globals.h"
#include "character.h"
#include "h008.h"
#include "h026_string.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h044_tiles.h"
#include "h045.h"
#include "h061.h"
#include "h062.h"
#include "h063.h"
#include "h065.h"
#include "h067.h"

/* Dati del modulo sotto a4: g_h072_bss[0xC - off] e' -off(a4). */
u8 g_h072_bss[0xC];

#include "h072_init_data.h"

/* Tipi di effetto delle malattie (-$C(a4), 6 word). */
#define DISEASE(i)      COK_GET16(&g_h072_bss[((i) - 1) * 2])
#define CUR             g_current_char
#define TEXT_BUF        ((char *)&g_h005[0x3C82])  /* $3C82: buffer di testo generico di 80 caratteri (TEXT_BUF) */

/* PORT H072+$0304 */
void h072_init(void)
{
    INIT_APPLY(s_init_14f2, g_h072_bss, sizeof(g_h072_bss));
}

/*
 * PORT H072+$0312: il personaggio corrente non ne ha bisogno (text, per
 * valore): chiede "cast cure anyway: ".
 */
static u8 cure_anyway(const char *text)
{
    char t[0x52];                       /* $C(a5), per valore */
    u8 key;                             /* -$1(a5) */

    h026_copy(0x50, t, 0x50, text);
    show_char_message(CUR, 0x50, t, 0, 0);
    key = ask_yes_no(0x12, "cast cure anyway: ", 0x0D, 0x0A, 0x0F);
    clear_message_area();
    return key;
}

/*
 * PORT H072+$036C: "<cura> will only cost <cost> steel pieces." e la
 * domanda "pay for cure"; paga il personaggio (tutto in acciaio) o la
 * cassa, altrimenti "not enough money." e 'N'.  Con 'Y' "is cured.".
 */
static u8 pay_for_cure(u16 cost, const char *name)
{
    char text[0x52];                    /* $E(a5), per valore */
    u8 key;                             /* -$1(a5) */
    u16 money;                          /* -$4(a5) */
    u32 pool;                           /* -$8(a5) */

    h026_copy(0x50, text, 0x50, name);
    h026_append(0x50, text, 0x10, " will only cost ");
    /* $3C82: buffer di testo generico di 80 caratteri (TEXT_BUF) */
    format_number(0x50, TEXT_BUF, (s32)cost, 0, 0x0A, 0x0A, ' ');
    trim_leading_spaces(0x50, TEXT_BUF); /* $3C82: buffer di testo generico di 80 caratteri (TEXT_BUF) */
    h026_append(0x50, text, 0x50, TEXT_BUF); /* $3C82: buffer di testo generico di 80 caratteri (TEXT_BUF) */
    h026_append(0x50, text, 0x0E, " steel pieces.");
    word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 1, 0x50, text);
    key = ask_yes_no(0x0D, "pay for cure ", 0x0D, 0x0A, 0x0F);
    if (key == 'Y') {
        money = (u16)wealth_in_steel(CUR);
        if (cost <= money) {
            money = (u16)(money - cost);
            set_steel_only(money);
        } else {
            pool = pool_value();
            if ((s32)cost <= (s32)pool) {
                pool -= cost;
                set_pool_steel((u16)pool);
            } else {
                show_message_line(0x11, "not enough money.");
                key = 'N';
            }
        }
    }
    if (key == 'Y') {
        clear_message_area();
        show_char_message(CUR, 9, "is cured.", 0, 1);
    }
    return key;
}

/* PORT H072+$050A: Cure Blindness (effetto $21), 500. */
static void cure_blindness(void)
{
    u8 key = 'Y';                       /* -$57(a5) */
    CokEffect *e;                       /* -$4(a5) */

    if (!find_effect(CUR, 0x21, &e)) {
        key = cure_anyway("is not blind.");
    }
    if (key == 'Y') {
        key = pay_for_cure(0x1F4, "Cure Blindness");
        if (key == 'Y') {
            remove_effect(CUR, 0x21, NULL);
        }
    }
}

/* PORT H072+$05AA: Cure Disease (i 6 effetti di -$C(a4)), 500. */
static void cure_disease(void)
{
    u8 key = 'Y';                       /* -$57(a5) */
    u16 i;                              /* -$5A(a5) */
    u8 diseased = 0;                    /* -$5B(a5) */
    CokEffect *e;                       /* -$4(a5) */

    for (i = 1; i <= 6; ++i) {
        if (find_effect(CUR, DISEASE(i), &e)) {
            diseased = 1;
        }
    }
    if (!diseased) {
        key = cure_anyway("is not Diseased.");
    }
    if (key == 'Y') {
        key = pay_for_cure(0x1F4, "Cure Disease");
        if (key == 'Y') {
            H005_B(0x24AA) = 1; /* $24AA: 1 durante le cure: i gestori non riaggiungono effetti */
            for (i = 1; i <= 6; ++i) {
                remove_effect(CUR, DISEASE(i), NULL);
            }
            recompute_stat(CUR, 0);
            H005_B(0x24AA) = 0; /* $24AA: 1 durante le cure: i gestori non riaggiungono effetti */
        }
    }
}

/*
 * PORT H072+$06BC: cure delle ferite: 1 leggere (50, 1d8), 2 gravi
 * (175, 2d8+1), 3 critiche (300, 3d8+3), 4 Heal (2500: tutti i punti
 * ferita meno 1d4, e toglie cecita', malattie e l'effetto $44).
 * In Heal l'originale tira 1d4 solo se si paga, ma la cura segue
 * comunque con la variabile -$2(a5) non inizializzata; qui 0.
 */
static void cure_wounds(u16 kind)
{
    u16 amount = 0;                     /* -$2(a5) */
    u16 i;                              /* -$4(a5) */
    u8 key;                             /* -$5(a5) */

    switch (kind) {
    case 1:
        key = pay_for_cure(0x32, "Cure Light Wounds");
        if (key == 'Y') {
            amount = roll_dice(1, 8);
            (void)heal_character(CUR, amount, 0);
        }
        break;
    case 2:
        key = pay_for_cure(0xAF, "Cure Serious Wounds");
        if (key == 'Y') {
            amount = (u16)(roll_dice(2, 8) + 1);
            (void)heal_character(CUR, amount, 0);
        }
        break;
    case 3:
        key = pay_for_cure(0x12C, "Cure Critical Wounds");
        if (key == 'Y') {
            amount = (u16)(roll_dice(3, 8) + 3);
            (void)heal_character(CUR, amount, 0);
        }
        break;
    case 4:
        key = pay_for_cure(0x9C4, "Heal");
        if (key == 'Y') {
            amount = roll_dice(1, 4);
        }
        /* pg+$1A8: punti ferita correnti; pg+$64: punti ferita massimi */
        if ((u16)(CUR->b[0x1A8] + amount) > CUR->b[0x64]) {
            amount = 0;
            break;
        }
        /* pg+$64: punti ferita massimi; pg+$1A8: punti ferita correnti */
        amount = (u16)(CUR->b[0x64] - CUR->b[0x1A8] - amount);
        (void)heal_character(CUR, amount, 0);
        remove_effect(CUR, 0x21, NULL);
        for (i = 1; i <= 6; ++i) {
            remove_effect(CUR, DISEASE(i), NULL);
            remove_effect(CUR, 0x44, NULL);
            recompute_stat(CUR, 1);
            recompute_stat(CUR, 2);
        }
        break;
    default:
        break;
    }
}

/*
 * PORT H072+$0910: Raise Dead (2750).  Solo i morti (+$197 = 6 o 1) con
 * +$5B almeno 2 e +$19 almeno 1; il risorto perde un punto di +$19 e,
 * con +$19 da $E in su, punti ferita massimi divisi per i livelli delle
 * classi (calcolo e sottrazione ripetuti per ogni classe, come
 * nell'originale).
 */
static void raise_dead(void)
{
    char unused[0x52];                  /* -$56(a5) */
    u8 key = 'Y';                       /* -$57(a5) */
    u8 dead = 0;                        /* -$58(a5) */
    u8 weak;                            /* -$59(a5) */
    u16 lost;                           /* -$5C(a5) */
    u16 levels;                         /* -$5E(a5) */
    u8 cls;                             /* -$5F(a5) */
    Character *c = CUR;                 /* -$64(a5) */
    u8 barred = 0;                      /* -$65(a5) */

    (void)unused;
    weak = (u8)(c->b[0x19] < 1 ? 1 : 0); /* pg+$19: costituzione corrente */
    /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
    if (c->b[0x197] == 6 || c->b[0x197] == 1) {
        dead = 1;
    }
    if (c->b[0x5B] < 2) { /* pg+$5B: razza (0..6, nomi H005+$4D04) */
        barred = 1;
    }
    if (!dead || barred || weak) {
        if (barred || weak) {
            key = cure_anyway("cannot be raised");
        } else {
            key = cure_anyway("is not dead.");
        }
    }
    if (key != 'Y') {
        return;
    }
    key = pay_for_cure(0xABE, "Raise Dead");
    if (key != 'Y' || !dead || barred) {
        return;
    }
    H005_B(0x24AA) = 1; /* $24AA: 1 durante le cure: i gestori non riaggiungono effetti */
    remove_effect(c, 0x20, NULL);
    remove_effect(c, 0x37, NULL);
    H005_B(0x24AA) = 0; /* $24AA: 1 durante le cure: i gestori non riaggiungono effetti */
    c->b[0x1A8] = 1; /* pg+$1A8: punti ferita correnti */
    c->b[0x197] = 0; /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
    c->b[0x198] = 1; /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento) */
    if (c->b[0x19] > 0) { /* pg+$19: costituzione corrente */
        add_to_byte(&c->b[0x19], 0xFFFF); /* pg+$19: costituzione corrente */
    }
    /* pg+$64: punti ferita massimi; pg+$123: PF massimi senza costituzione; base -1 slot
     * incantesimi +$124 */
    if (c->b[0x64] > c->b[0x123]) {
        /* pg+$64: punti ferita massimi; pg+$123: PF massimi senza costituzione; base -1 slot
         * incantesimi +$124 */
        lost = (u16)(c->b[0x64] - c->b[0x123]);
    } else {
        lost = 0;
    }
    levels = 0;
    if (c->b[0x19] < 0x0E) { /* pg+$19: costituzione corrente */
        return;
    }
    for (cls = 0; cls <= 7; ++cls) {
        /* pg+$FE: livelli per classe, 8 voci (0 chierico..7 cavaliere); chierico */
        if (c->b[0xFE + cls] == 0) {
            continue;
        }
        if (cls == 2) {
            /* pg+$19: costituzione corrente; pg+$FE: livelli per classe, 8 voci (0 chierico..7
             * cavaliere); chierico */
            levels = (u16)(levels + (u16)(c->b[0x19] - 0x0E) * c->b[0xFE + cls]);
        } else if (c->b[0x19] > 0x0F) { /* pg+$19: costituzione corrente */
            /* pg+$FE: livelli per classe, 8 voci (0 chierico..7 cavaliere); chierico */
            levels = (u16)(levels + c->b[0xFE + cls] * 2);
        } else {
            /* pg+$FE: livelli per classe, 8 voci (0 chierico..7 cavaliere); chierico */
            levels = (u16)(levels + c->b[0xFE + cls]);
        }
        if (levels > 0) {
            lost = (u16)(lost / levels);
        }
        /* pg+$19: costituzione corrente; pg+$100: livello da guerriero */
        if (c->b[0x19] < 0x11 || c->b[0x100] > 0 ||
            /* pg+$100: livello da guerriero; pg+$DC: uso: soglia per i livelli +$106..+$10D e i PF;
             * !=0 vieta Modify */
            c->b[0x100] > c->b[0xDC]) {
            add_to_byte(&c->b[0x64], (u16)(0 - lost)); /* pg+$64: punti ferita massimi */
        }
    }
}

/* PORT H072+$0C04: Neutralize Poison (effetto $37), 500. */
static void neutralize_poison(void)
{
    u8 key = 'Y';                       /* -$57(a5) */
    u8 poisoned = 0;                    /* -$58(a5) */
    CokEffect *e;                       /* -$4(a5) */

    if (find_effect(CUR, 0x37, &e)) {
        poisoned = 1;
    }
    if (!poisoned) {
        key = cure_anyway("is not poisoned.");
    }
    if (key != 'Y') {
        return;
    }
    key = pay_for_cure(0x1F4, "Neutralize Poison");
    if (key != 'Y' || !poisoned) {
        return;
    }
    if (CUR->b[0x1A8] == 0) { /* pg+$1A8: punti ferita correnti */
        CUR->b[0x1A8] = 1; /* pg+$1A8: punti ferita correnti */
    }
    H005_B(0x24AA) = 1; /* $24AA: 1 durante le cure: i gestori non riaggiungono effetti */
    remove_effect(CUR, 0x37, NULL);
    remove_effect(CUR, 0x16, NULL);
    remove_effect(CUR, 0x0F, NULL);
    H005_B(0x24AA) = 0; /* $24AA: 1 durante le cure: i gestori non riaggiungono effetti */
    CUR->b[0x198] = 1; /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento) */
    CUR->b[0x197] = 0; /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
}

/*
 * PORT H072+$0D24: Remove Curse (1750): oggetti maledetti (+$3C) o
 * effetto $24; l'azione dell'incantesimo ($2668) sul personaggio.
 */
static void remove_curse(void)
{
    u8 cursed = 0;                      /* -$1(a5) */
    CokItem *it;                        /* -$6(a5) */
    CokEffect *e;                       /* -$A(a5) */
    u8 key = 'Y';                       /* -$5D(a5) */

    for (it = CUR->items; it != NULL && !cursed; it = it->next) {
        if (it->b[0x3C] != 0) { /* ogg+$3C: flag oggetto maledetto */
            cursed = 1;
        }
    }
    if (!cursed && !find_effect(CUR, 0x24, &e)) {
        key = cure_anyway("is not cursed.");
    }
    if (key != 'Y') {
        return;
    }
    key = pay_for_cure(0x6D6, "Remove Curse");
    if (key == 'Y') {
        g_spell_targets[0] = CUR;
        g_handlers_25c0[42]();
    }
}

/* PORT H072+$0E0A: Stone to Flesh (+$197 = 7), 1000. */
static void stone_to_flesh(void)
{
    u8 key = 'Y';                       /* -$57(a5) */

    if (CUR->b[0x197] != 7) { /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
        key = cure_anyway("is not stoned.");
    }
    if (key != 'Y') {
        return;
    }
    key = pay_for_cure(0x3E8, "Stone to Flesh");
    /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
    if (key == 'Y' && CUR->b[0x197] == 7) {
        CUR->b[0x197] = 0; /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
        CUR->b[0x198] = 1; /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento) */
        CUR->b[0x1A8] = 1; /* pg+$1A8: punti ferita correnti */
    }
}

/* PORT H072+$0EBE: Heal, elenco delle cure ("Heal Exit"). */
static void heal_menu(void)
{
    static const char *const names[11] = {  /* -$1CE(a5).. */
        "cure blindness", "cure disease", "cure light wounds",
        "cure serious wounds", "cure critical wounds", "heal",
        "neutralize poison", "raise dead", "remove curse",
        "stone to flesh", "exit"
    };
    CokMenuItem *list = NULL;           /* -$1D2(a5) */
    CokMenuItem *chosen = NULL;         /* -$1D6(a5) */
    CokMenuItem *node;
    u8 redraw;                          /* -$1D7(a5) */
    u16 i;                              /* -$1DA(a5) */
    u16 index;                          /* -$1DC(a5) */
    u8 done = 0;                        /* -$1DD(a5) */
    char text[0x2A];                    /* -$208(a5) */
    u8 key;                             /* -$209(a5) */

    menu_alloc(0x0A, &list);
    chosen = list;
    i = 1;
    for (node = list; node != NULL; node = node->next) {
        memset(node->text, 0, sizeof(node->text));
        if (i <= 11) {
            h026_copy(0x28, node->text, 0x28, names[i - 1]);
        }
        node->header = 0;
        ++i;
    }
    clear_text_cells(0, 0x18, 0x27, 0x18);
    redraw = 1;
    draw_wild_frame();
    do {
        h026_copy(0x28, text, 0x0F, (const char *)CUR->b);
        h026_append(0x28, text, 0x16, ", how can we help you?");
        ui_draw_text(1, 1, 0x0F, 0, 0x28, text);
        index = 0;
        key = list_menu(0, "", 9, "Heal Exit", 0x0D, 0x0A, 0x0F, 2, 4, 0x26,
                        0x0F, list, 0, &redraw, &index, &chosen);
        switch (key) {
        case 'H':
        case 0x0D:
            switch (index) {
            case 0:  cure_blindness();     break;
            case 1:  cure_disease();       break;
            case 2:  cure_wounds(1);       break;
            case 3:  cure_wounds(2);       break;
            case 4:  cure_wounds(3);       break;
            case 5:  cure_wounds(4);       break;
            case 6:  neutralize_poison();  break;
            case 7:  raise_dead();         break;
            case 8:  remove_curse();       break;
            case 9:  stone_to_flesh();     break;
            case 10: done = 1;             break;
            default: break;
            }
            break;
        case 0:
            done = 1;
            break;
        default:
            break;
        }
    } while (!done);
    menu_free(&list);
    redraw_game_screen();
    draw_party(CUR);
}

/*
 * PORT H072+$120C: il tempio (contesto 1): Heal, View, Take, Pool, Share,
 * Appraise, Exit.  Uscendo con denaro nella cassa un sacerdote chiede se
 * tornare a prenderlo.
 */
void temple(void)
{
    char poor[0x2A];                    /* -$2A(a5) */
    char rich[0x2A];                    /* -$54(a5) */
    u8 key;                             /* -$55(a5) */
    u8 done;                            /* -$56(a5) */
    u8 special;                         /* -$57(a5) */
    char menu[0x2A];                    /* -$82(a5) */
    u8 money;                           /* -$83(a5) */
    u8 items;                           /* -$84(a5) */
    u16 answer;                         /* -$86(a5) */
    u8 redraw;                          /* -$87(a5) */

    h026_copy(0x28, poor, 0x1C, "Heal View Pool Appraise Exit");
    h026_copy(0x28, rich, 0x27, "Heal View Take Pool Share Appraise Exit");
    H005_B(0x3DE3) = 1; /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
    H005_B(0x24C2) = 0; /* $24C2: 1: nel contesto 1 il ridisegno include la cornice esplorazione */
    redraw_game_screen();
    H005_B(0x24C2) = 1; /* $24C2: 1: nel contesto 1 il ridisegno include la cornice esplorazione */
    draw_party(CUR);
    /* $2A1E: cassa del party: 7 long, monete per tipo 0..6 (4 = acciaio) */
    h029_fill_bytes(0x1B, &g_h005[0x2A1E], 0x1C, 0);
    H005_B(0x24E3) = 0; /* $24E3: uso: 1 se la cassa comune ha monete (Pool/Share/Take), mai letto */
    done = 0;
    do {
        has_treasure(&money, &items);
        if (money) {
            memcpy(menu, rich, sizeof(menu));
        } else {
            memcpy(menu, poor, sizeof(menu));
        }
        key = ui_request_choice(0, "", 0x28, menu, 0x0D, 0x0A, 0x0F, 1, 0,
                                &special);
        switch (key) {
        case 'H':
            if (!special) {
                heal_menu();
            } else {
                select_party_member(key);
            }
            break;
        case 'V':
            view_character(&special);
            break;
        case 'T':
            take_money_menu();
            break;
        case 'P':
            if (!special) {
                pool_party_money();
            } else {
                select_party_member(key);
            }
            break;
        case 'S':
            share_money();
            break;
        case 'A':
            appraise_gems(&redraw);
            break;
        case 'E':
            has_treasure(&money, &items);
            if (money) {
                h026_copy(0x28, menu, 8, "~Yes ~No");
                word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 1, 0x4A,
                               "As you leave a priest says, 'Excuse me but "
                               "you have Left some money here' ");
                word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 1, 0x2F,
                               "Do you want to go back and retrieve your "
                               "money?");
                answer = ecl_menu(0, "", 0x28, menu, 0x0D, 0x0A, 0x0F, 0, 0);
                if (answer == 1) {
                    done = 1;
                } else {
                    clear_text_cells(1, 0x11, 0x26, 0x16);
                }
            } else {
                done = 1;
            }
            break;
        default:
            break;
        }
        switch (key) {
        case 'B':
        case 'T':
            redraw_game_screen();
            break;
        case 'A':
            if (redraw) {
                redraw_game_screen();
            }
            break;
        default:
            break;
        }
        draw_party(CUR);
    } while (!done);
}
