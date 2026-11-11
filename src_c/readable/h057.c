/*
 * H057: l'accampamento (Encamp) con i suoi menu (Magic, Alter, Fix),
 * il lancio degli incantesimi fuori dal combattimento (Cast), la
 * memorizzazione e la trascrizione delle pergamene.
 */
#include "h057.h"
#include "init_data.h"
#include "globals.h"
#include "character.h"
#include "h003_exec.h"
#include "h008.h"
#include "h010_input.h"
#include "h026_string.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h033.h"
#include "h042_seq.h"
#include "h044_tiles.h"
#include "h045.h"
#include "h047.h"
#include "h053.h"
#include "h058.h"
#include "h062.h"
#include "h063.h"
#include "h065.h"
#include "h066.h"

/* Dati del modulo sotto a4: g_h057_bss[0xA8 - off] e' -off(a4). */
u8 g_h057_bss[0xA8];
#define CAMP_MENU   ((const char *)&g_h057_bss[0xA8 - 0xA8])  /* -$A8(a4) */
#define MAGIC_MENU  ((const char *)&g_h057_bss[0xA8 - 0x7E])  /* -$7E(a4) */
#define ALTER_MENU  ((const char *)&g_h057_bss[0xA8 - 0x54])  /* -$54(a4) */
#define LEVEL_MENU  ((const char *)&g_h057_bss[0xA8 - 0x2A])  /* -$2A(a4) */

#include "h057_init_data.h"

/* Tabella degli incantesimi ($66, 16 byte): +0 classe, +1 livello, +$A effetto. */
#define SPELL_B(s, k)   H005_B(0x66 + ((int)(s) - 1) * 16 + (k))
#define SPELL_NAME(s)   ((const char *)&H005_B(0x716 + ((int)(s) - 1) * 32))
#define TEXT_BUF        ((char *)&g_h005[0x3C82])   /* $3C82, 80 caratteri */
#define CHOICE_SELECTED H005_B(0x2483)
#define BONUS_SPELLS    H005_B(0x247D)
#define CUR             g_current_char

/* Copia come move.b (a3)+,(a2)+ / dbeq: al massimo max+1 byte, NUL compreso. */
static void copy_dbeq(char *dst, const char *src, u16 max)
{
    u16 n;

    for (n = 0; n <= max; ++n) {
        dst[n] = src[n];
        if (src[n] == 0) {
            break;
        }
    }
}

/* Tempo di riposo in ore, decine di minuti e minuti ($24FA/$24F8/$24F6). */
static void set_rest_time(u16 minutes)
{
    H005_SET_W(0x24FA, (u16)(minutes / 0x3C));
    H005_SET_W(0x24F8, (u16)((u16)(minutes - H005_W(0x24FA) * 0x3C) / 0x0A));
    H005_SET_W(0x24F6, (u16)(minutes % 0x0A));
}

/* PORT H057+$05A6 */
void h057_init(void)
{
    INIT_APPLY(s_init_3202, g_h057_bss, sizeof(g_h057_bss));
}

/*
 * PORT H057+$05B4: minuti per memorizzare e trascrivere quanto e' in
 * attesa (bit 7): 15 per livello (il livello 0 vale 1 fra gli
 * incantesimi), piu' 4 ore se c'e' qualcosa, 6 se oltre il livello 2.
 * Le ore iniziali vanno anche in +$58.
 */
static u16 study_time(Character *c)
{
    u16 max_mem = 0;                    /* -$2(a5) */
    u16 max_scr = 0;                    /* -$4(a5) */
    u16 sum_mem = 0;                    /* -$6(a5) */
    u16 sum_scr = 0;                    /* -$8(a5) */
    CokItem *it;                        /* -$C(a5) */
    u16 i;                              /* -$E(a5) */
    u16 level;                          /* -$10(a5) */
    u16 hours;                          /* -$12(a5) */
    u16 s;

    for (i = 0; i <= 0x39; ++i) {
        if (c->b[0x1E + i] > 0x7F) {
            s = mask_byte(c->b[0x1E + i], 0x7F);
            level = SPELL_B(s, 1);
            if (level == 0) {
                level = 1;
            }
            if (level > max_mem) {
                max_mem = level;
            }
            sum_mem = (u16)(sum_mem + level);
        }
    }
    for (it = c->items; it != NULL; it = it->next) {
        if (!is_scroll(it)) {
            continue;
        }
        for (i = 1; i <= 3; ++i) {
            if (it->b[0x44 + i - 1] > 0x7F) {
                s = mask_byte(it->b[0x44 + i - 1], 0x7F);
                level = SPELL_B(s, 1);
                if (level > max_scr) {
                    max_scr = level;
                }
                sum_scr = (u16)(sum_scr + level);
            }
        }
    }
    hours = 0;
    if (sum_mem > 0 || sum_scr > 0) {
        hours = 4;
    }
    if (max_mem > 2 || max_scr > 2) {
        hours = 6;
    }
    COK_PUT16(&c->b[0x58], hours);
    return (u16)(hours * 0x3C + sum_mem * 0x0F + sum_scr * 0x0F);
}

/* PORT H057+$0778: sempre 1. */
static u8 camp_save_ok(void)
{
    return 1;
}

/* PORT H057+$078E: annulla gli incantesimi in attesa di memorizzazione. */
static void cancel_memorize(Character *c)
{
    u16 i;                              /* -$2(a5) */

    for (i = 0; i <= 0x39; ++i) {
        if (c->b[0x1E + i] > 0x7F) {
            c->b[0x1E + i] = 0;
        }
    }
    COK_PUT16(&c->b[0x58], 0);
}

/* PORT H057+$07E8: annulla le trascrizioni in attesa sulle pergamene. */
static void cancel_scribe(Character *c)
{
    u16 k;                              /* -$2(a5) */
    CokItem *it;                        /* -$6(a5) */

    for (it = c->items; it != NULL; it = it->next) {
        if (!is_scroll(it)) {
            continue;
        }
        for (k = 1; k <= 3; ++k) {
            it->b[0x44 + k - 1] = mask_byte(it->b[0x44 + k - 1], 0x7F);
        }
    }
}

/* PORT H057+$0878: annulla tutto quanto e' in attesa nel party. */
static void cancel_all_study(void)
{
    Character *p;                       /* -$4(a5) */

    for (p = g_party_head; p != NULL; p = p->next) {
        cancel_memorize(p);
        cancel_scribe(p);
    }
}

/*
 * PORT H057+$08B4: posti liberi del personaggio corrente per classe kind
 * e livello level (in *count quelli occupati).  La classe 2 (speciali)
 * non dipende dal livello: 3 per il tipo +$5E 4, 0 per il 6, 1 altrimenti
 * (se +$FE), meno quelli $65..$6B gia' memorizzati; *count non cambia.
 */
static u16 free_slots(u8 level, u8 kind, u16 *count)
{
    u16 result;                         /* -$2(a5) */
    s16 n = 0;                          /* -$4(a5) */
    u16 i;                              /* -$6(a5) */
    u16 s;
    u16 max;

    if (kind == 2) {
        if (CUR->b[0xFE] > 0) {
            switch (CUR->b[0x5E]) {
            case 4:
                n = 3;
                break;
            case 6:
                n = 0;
                break;
            default:
                n = 1;
                break;
            }
        }
        for (i = 0; i <= 0x39; ++i) {
            s = mask_byte(CUR->b[0x1E + i], 0x7F);
            if (s > 0x64 && s < 0x6C) {
                --n;
            }
        }
        result = (u16)n;
    } else {
        n = 0;
        for (i = 0; i <= 0x39; ++i) {
            if (CUR->b[0x1E + i] > 0) {
                s = mask_byte(CUR->b[0x1E + i], 0x7F);
                if (SPELL_B(s, 1) == level && SPELL_B(s, 0) == kind) {
                    ++n;
                }
            }
        }
        *count = (u16)n;
        max = CUR->b[0x124 + kind * 6 + level - 1];
        if ((u16)n > max) {
            n = (s16)max;
        }
        result = (u16)(max - (u16)n);
    }
    return result;
}

/*
 * PORT H057+$0AE0: il personaggio corrente puo' usare la magia per
 * what (1 lanciare, 2 memorizzare, 3 trascrivere)?  Altrimenti il
 * messaggio.
 */
static u8 can_use_magic(u16 what)
{
    char buf[0x2A];                     /* -$2A(a5) */

    copy_dbeq(buf, "", 0x28);
    if (what == 1 && COK_GET16(g_state_a + 0x1CA) > 0) {
        copy_dbeq(buf, "cannot cast spells in this area", 0x28);
    } else if (CUR->b[0x197] == 1 || CUR->b[0x198] == 0) {
        copy_dbeq(buf, "is in no condition to ", 0x28);
        switch (what) {
        case 1:
            h026_append(0x28, buf, 0x0F, "cast any spells");
            break;
        case 2:
            h026_append(0x28, buf, 0x0F, "memorize spells");
            break;
        case 3:
            h026_append(0x28, buf, 0x12, "scribe any scrolls");
            break;
        default:
            break;
        }
    }
    if (buf[0] == 0) {
        return 1;
    }
    show_char_message(CUR, 0x28, buf, 0x0A, 1);
    return 0;
}

/* PORT H057+$0C04: Cast, lancia gli incantesimi memorizzati. */
void cast_spells(void)
{
    s16 spell = -1;                     /* -$2(a5) */
    u8 found;                           /* -$3(a5) */
    u8 redraw = 0;                      /* -$4(a5) */
    u8 tmp;                             /* -$5(a5) */
    u16 n;                              /* -$8(a5) */

    g_spell_target = NULL;
    CHOICE_SELECTED = 1;
    if (can_use_magic(1)) {
        do {
            n = choose_spell_of_kind(0, 1, &spell, &found);
            if (n != 0) {
                redraw = 1;
                clear_text_cells(1, 0x11, 0x26, 0x16);
                cast_spell(n, 0, 1, &tmp);
            } else if (found) {
                redraw = 1;
            } else {
                show_char_message(CUR, 0x17, "has no spells memorized",
                                  0x0A, 1);
            }
        } while (n != 0);
    }
    if (redraw) {
        redraw_game_screen();
    }
}

/*
 * PORT H057+$0CD4: tabella dei posti liberi per classe e livello del
 * personaggio corrente (righe $12.., colonne $14..) e gli incantesimi
 * bonus ($247D, da g_state_a +$3F0 + 2 * +$5F).  1 se c'e' qualcosa.
 */
static u8 show_spell_slots(void)
{
    char buf[0x2A];                     /* -$2A(a5) */
    char cell[5][4][4];                 /* -$7A(a5): [livello-1][classe] */
    u8 has[4];                          /* -$7E(a5) */
    u8 kind;                            /* -$7F(a5) */
    u8 level;                           /* -$80(a5) */
    u16 col;                            /* -$82(a5) */
    u16 row;                            /* -$84(a5) */
    u16 n;                              /* -$86(a5) */
    u8 any;                             /* -$87(a5) */
    u16 avail;                          /* -$8A(a5) */
    u16 used;                           /* -$8C(a5) */
    u16 count;                          /* -$8E(a5) */

    BONUS_SPELLS = 0;
    any = 0;
    for (kind = 0; kind <= 3; ++kind) {
        has[kind] = 0;
        if (kind == 2) {
            if (CUR->b[0xFE] > 0 && CUR->b[0x5E] != 6) {
                has[2] = 1;
                any = 1;
            }
            for (level = 2; level <= 5; ++level) {
                h026_copy(2, cell[level - 1][2], 1, " ");
            }
            n = free_slots(0, 2, &count);
            if (n > 0 || any) {
                format_number(2, cell[0][2], (s32)n, 0, 0x0A, 2, ' ');
            } else {
                h026_copy(2, cell[0][2], 1, " ");
            }
        } else {
            for (level = 1; level <= 5; ++level) {
                format_number(2, cell[level - 1][kind],
                              (s32)free_slots(level, kind, &count), 0,
                              0x0A, 2, ' ');
                if (CUR->b[0x124 + kind * 6 + level - 1] == 0) {
                    memcpy(cell[level - 1][kind], " \0", 3);
                } else {
                    has[kind] = 1;
                    any = 1;
                }
            }
        }
    }
    if (CUR->b[0x103] > 0 && CUR->b[0x5F] > 0) {
        switch (COK_GET16(g_state_a + (0x1F8 + CUR->b[0x5F]) * 2)) {
        case 1:
            BONUS_SPELLS = 1;
            break;
        case 2:
            BONUS_SPELLS = 2;
            break;
        default:
            BONUS_SPELLS = 0;
            break;
        }
        if (BONUS_SPELLS > 0) {
            for (level = 1; level <= 5; ++level) {
                avail = CUR->b[0x136 + level - 1];
                count = free_slots(level, 3, &used);
                if (avail < used) {
                    if ((u16)(used - avail) > BONUS_SPELLS) {
                        BONUS_SPELLS = 0;
                    } else {
                        add_to_byte(&BONUS_SPELLS, (u16)(avail - used));
                    }
                }
            }
        }
        if (BONUS_SPELLS > 0) {
            any = 1;
        }
    }
    if (any) {
        show_char_message(CUR, 0, "", 0x0A, 0);
        row = 1;
        for (kind = 0; kind <= 3; ++kind) {
            if (!has[kind]) {
                continue;
            }
            switch (kind) {
            case 0:
                copy_dbeq(buf, "    Cleric Spells:", 0x28);
                break;
            case 1:
                copy_dbeq(buf, "     Druid Spells:", 0x28);
                break;
            case 2:
                copy_dbeq(buf, "   Special Spells:", 0x28);
                break;
            case 3:
                copy_dbeq(buf, "Magic-User Spells:", 0x28);
                break;
            default:
                break;
            }
            ui_draw_text(1, (u16)(row + 0x11), 0x0A, 0, 0x28, buf);
            col = 0x13;
            for (level = 1; level <= 5; ++level) {
                ui_draw_text((u16)(col + 1), (u16)(row + 0x11), 0x0A, 0, 2,
                             cell[level - 1][kind]);
                col = (u16)(col + 3);
            }
            ++row;
        }
        if (BONUS_SPELLS > 0) {
            ui_draw_text(1, (u16)(row + 0x11), 0x0A, 0, 0x11,
                         "     Bonus Spells");
            format_number(0x50, TEXT_BUF, (s32)BONUS_SPELLS, 0, 0x0A, 2, ' ');
            ui_draw_text(0x14, (u16)(row + 0x11), 0x0A, 0, 0x50, TEXT_BUF);
        }
    }
    return any;
}

/*
 * PORT H057+$11AC: Rest dal campo: il tempo e' quello del personaggio
 * piu' lento a studiare; *result = 1 se il riposo e' stato interrotto.
 */
static void camp_rest(u8 *result)
{
    Character *p;                       /* -$4(a5) */
    u16 longest = 0;                    /* -$6(a5) */
    u16 t;                              /* -$8(a5) */

    for (p = g_party_head; p != NULL; p = p->next) {
        t = study_time(p);
        if (longest < t) {
            longest = t;
        }
    }
    set_rest_time(longest);
    *result = rest_party(1);
    h029_fill_bytes(0x0D, &g_h005[0x24F4], 0x0E, 0);
    draw_status_line();
}

/* PORT H057+$126C: ordina gli incantesimi del personaggio corrente. */
static void sort_spells(void)
{
    u16 i;                              /* -$2(a5) */
    u16 j;                              /* -$4(a5) */
    u8 t;                               /* -$5(a5) */

    for (i = 0; i <= 0x38; ++i) {
        for (j = i; j <= 0x39; ++j) {
            if (mask_byte(CUR->b[0x1E + i], 0x7F) >
                mask_byte(CUR->b[0x1E + j], 0x7F)) {
                t = CUR->b[0x1E + i];
                CUR->b[0x1E + i] = CUR->b[0x1E + j];
                CUR->b[0x1E + j] = t;
            }
        }
    }
}

/* PORT H057+$1342: Memorize. */
static void memorize_spells(void)
{
    u8 done;                            /* -$1(a5) */
    u8 found;                           /* -$2(a5) */
    u8 redraw;                          /* -$3(a5) */
    u16 n;                              /* -$6(a5) */
    u16 i;                              /* -$8(a5) */
    s16 spell;                          /* -$A(a5) */
    u16 count;                          /* -$C(a5) */

    if (!can_use_magic(2)) {
        return;
    }
    done = 0;
    spell = -1;
    CHOICE_SELECTED = 1;
    n = choose_spell_of_kind(5, 0, &spell, &found);
    redraw = 1;
    if (found) {
        CHOICE_SELECTED = 1;
        if (ask_yes_no(0x17, "Memorize These Spells? ", 0x0E, 0x0A, 0x0F)
            == 'N') {
            cancel_memorize(CUR);
        } else {
            done = 1;
        }
    } else {
        redraw = 0;
    }
    spell = -1;
    while (!done) {
        done = (u8)!show_spell_slots();
        if (done) {
            show_char_message(CUR, 0x1A, "cannot memorize any spells",
                              0x0A, 1);
            continue;
        }
        n = choose_spell_of_kind(1, 2, &spell, &found);
        redraw = 1;
        if (n == 0) {
            done = 1;
            continue;
        }
        if (free_slots(SPELL_B(n, 1), SPELL_B(n, 0), &count) > 0 ||
            (SPELL_B(n, 0) == 3 && BONUS_SPELLS > 0)) {
            H005_B(0x24DD) = (u8)(SPELL_B(n, 0) == 2 ? 1 : 0);
            i = 0;
            while (CUR->b[0x1E + i] != 0) {
                ++i;
            }
            CUR->b[0x1E + i] = (u8)(n + 0x80);
            sort_spells();
        }
    }
    if (spell != -1) {
        spell = -1;
        n = choose_spell_of_kind(5, 0, &spell, &found);
        if (found &&
            ask_yes_no(0x17, "Memorize these spells? ", 0x0E, 0x0A, 0x0F)
            == 'N') {
            cancel_memorize(CUR);
        }
    }
    if (redraw) {
        redraw_game_screen();
    }
}

/* PORT H057+$1590: Scribe, trascrive le pergamene. */
static void scribe_scrolls(void)
{
    u8 done;                            /* -$1(a5) */
    u8 found;                           /* -$2(a5) */
    u8 redraw;                          /* -$3(a5) */
    u16 n;                              /* -$6(a5) */
    u16 k;                              /* -$A(a5) */
    s16 spell;                          /* -$C(a5) */
    CokItem *it;                        /* -$10(a5) */
    u8 dup;                             /* -$11(a5) */

    if (!can_use_magic(3)) {
        return;
    }
    done = 0;
    spell = -1;
    n = choose_spell_of_kind(6, 0, &spell, &found);
    redraw = 1;
    if (found) {
        if (ask_yes_no(0x15, "Scribe These Spells? ", 0x0E, 0x0A, 0x0F)
            == 'N') {
            cancel_scribe(CUR);
        } else {
            done = 1;
        }
    } else {
        redraw = 0;
    }
    spell = -1;
    while (!done) {
        n = choose_spell_of_kind(3, 3, &spell, &found);
        if (n == 0) {
            done = 1;
            if (!found) {
                show_char_message(CUR, 0x17, "has no copyable scrolls",
                                  0x0A, 1);
            } else {
                redraw = 1;
            }
            continue;
        }
        redraw = 1;
        if (CUR->b[0x66 + n - 1]) {
            show_message_line(0x1B, "You already know that spell");
            continue;
        }
        dup = 0;
        for (it = CUR->items; it != NULL && !dup; it = it->next) {
            if (!is_scroll(it)) {
                continue;
            }
            for (k = 1; k <= 3; ++k) {
                if (it->b[0x44 + k - 1] > 0x7F &&
                    mask_byte(it->b[0x44 + k - 1], 0x7F) == n) {
                    show_message_line(0x23,
                                      "You are already scribing that spell");
                    dup = 1;
                }
            }
        }
        if (dup) {
            show_message_line(0x1E, "You can not scribe that spell.");
        } else if (CUR->b[0x124 + SPELL_B(n, 0) * 6 + SPELL_B(n, 1) - 1] > 0) {
            for (it = CUR->items; it != NULL && !dup; it = it->next) {
                k = 1;
                do {
                    if (it->b[0x44 + k - 1] == n) {
                        it->b[0x44 + k - 1] = or_byte(it->b[0x44 + k - 1],
                                                      0x80);
                        dup = 1;
                    }
                    ++k;
                } while (k <= 3 && !dup);
            }
        }
    }
    if (spell != -1) {
        spell = -1;
        n = choose_spell_of_kind(6, 0, &spell, &found);
        if (found &&
            ask_yes_no(0x15, "Scribe these spells? ", 0x0E, 0x0A, 0x0F)
            == 'N') {
            cancel_scribe(CUR);
        }
    }
    if (redraw) {
        redraw_game_screen();
    }
}

/* Frame di H057+$18D6 visto dalla procedura annidata $18E4. */
typedef struct EffectList {
    CokMenuItem *head;                  /* -$8(a5) */
    CokMenuItem *tail;                  /* -$C(a5) */
} EffectList;

/* PORT H057+$18E4 (annidata in $18D6): accoda una riga all'elenco. */
static void effect_line(EffectList *f, u16 len, const char *text, u8 header)
{
    f->tail->next = (CokMenuItem *)exec_alloc_mem(sizeof(CokMenuItem),
                                                  COK_MEMF_CLEAR);
    f->tail = f->tail->next;
    f->tail->next = NULL;
    h026_copy(0x28, f->tail->text, len, text);
    f->tail->header = header;
}

/*
 * PORT H057+$18D6: Display, elenco degli effetti magici di ogni
 * personaggio (nome dall'incantesimo con quel tipo d'effetto o un nome
 * fisso; i tipi senza nome non compaiono).
 */
static void display_effects(void)
{
    EffectList f;
    CokEffect *e;                       /* -$4(a5) */
    Character *p;                       /* -$10(a5) */
    u16 type;                           /* -$12(a5) */
    u16 i;                              /* -$14(a5) */
    u16 count;                          /* -$16(a5) */
    u8 found;                           /* -$18(a5) */
    u8 show;                            /* -$19(a5) */
    u8 redraw;                          /* -$1A(a5) */
    char name[0x2A];                    /* -$44(a5) */
    u16 index;                          /* -$46(a5) */
    const char *fixed;

    f.head = (CokMenuItem *)exec_alloc_mem(sizeof(CokMenuItem),
                                           COK_MEMF_CLEAR);
    f.tail = f.head;
    f.tail->header = 0;
    copy_dbeq(f.tail->text, " ", 0x28);
    f.tail->next = NULL;
    for (p = g_party_head; p != NULL; p = p->next) {
        count = 0;
        effect_line(&f, 0x0F, (const char *)p->b, 1);
        for (e = p->effects; e != NULL; e = e->next) {
            show = 1;
            type = e->b[0];
            fixed = NULL;
            switch (type) {
            case 0x01: case 0x02: case 0x05: case 0x08: case 0x09:
            case 0x0A: case 0x0B: case 0x0C: case 0x0E: case 0x10:
            case 0x11: case 0x13: case 0x14: case 0x15: case 0x16:
            case 0x17: case 0x18: case 0x19: case 0x1C: case 0x1D:
            case 0x20: case 0x21: case 0x22: case 0x24: case 0x25:
            case 0x26: case 0x27: case 0x29: case 0x2A: case 0x2D:
            case 0x2E: case 0x31: case 0x33: case 0x34: case 0x35:
                i = 1;
                found = 0;
                while (i <= 0x38 && !found) {
                    if (SPELL_B(i, 0x0A) == type) {
                        h026_copy(0x28, name, 0x1F, SPELL_NAME(i));
                        found = 1;
                    } else {
                        ++i;
                    }
                }
                if (!found) {
                    copy_dbeq(name, "Funky--", 0x28);
                    format_number(0x50, TEXT_BUF, (s32)type, 0, 0x0A, 3, ' ');
                    h026_append(0x28, name, 0x50, TEXT_BUF);
                }
                break;
            case 0x04: fixed = "Dispel Evil"; break;
            case 0x1B: fixed = "Fumbling"; break;
            case 0x1F: fixed = "Helpless"; break;
            case 0x23: fixed = "Confused"; break;
            case 0x2C: fixed = "Cause Disease"; break;
            case 0x32: fixed = "Hot Fire Shield"; break;
            case 0x36: fixed = "Cold Fire Shield"; break;
            case 0x37: fixed = "Poisoned"; break;
            case 0x3B: fixed = "Regenerating"; break;
            case 0x3D: fixed = "Fire Resistance"; break;
            case 0x3F: fixed = "Minor Globe of Invulnerability"; break;
            case 0x44: fixed = "enfeebled"; break;
            case 0x45: fixed = "invisible to animals"; break;
            case 0x47: fixed = "Invisible"; break;
            case 0x48: fixed = "Camouflaged"; break;
            case 0x49: fixed = "protected from dragon breath"; break;
            case 0x4D: fixed = "berserk"; break;
            case 0x59: fixed = "Displaced"; break;
            default:
                show = 0;
                break;
            }
            if (fixed != NULL) {
                copy_dbeq(name, fixed, 0x28);
            }
            if (show) {
                ++count;
                copy_dbeq(TEXT_BUF, " ", 0x50);
                h026_append(0x50, TEXT_BUF, 0x28, name);
                effect_line(&f, 0x50, TEXT_BUF, 0);
            }
        }
        if (count == 0) {
            effect_line(&f, 0x13, " <No Spell Effects>", 0);
        }
        effect_line(&f, 1, " ", 0);
    }
    redraw = 1;
    index = 0;
    draw_screen_frame(1);
    (void)list_menu(0, "", 0, "", 0x0B, 0x0A, 0x0F, 1, 4, 0x26, 0x16,
                    f.head, 1, &redraw, &index, &f.tail);
    menu_free(&f.head);
    redraw_game_screen();
}

/* PORT H057+$1DD8: menu Magic del campo. */
static void magic_menu(u8 *result)
{
    u8 key = ' ';                       /* -$1(a5) */
    u8 special;                         /* -$2(a5) */
    u8 saved;                           /* -$3(a5) */

    while (!*result && key != 'E' && key != 0) {
        key = ui_request_choice(0, "", 0x28, MAGIC_MENU, 0x0D, 0x0A, 0x0F,
                                1, 1, &special);
        if (special) {
            select_party_member(key);
            draw_party(CUR);
            continue;
        }
        saved = CHOICE_SELECTED;
        switch (key) {
        case 'C':
            cast_spells();
            break;
        case 'M':
            memorize_spells();
            break;
        case 'S':
            scribe_scrolls();
            break;
        case 'D':
            display_effects();
            break;
        case 'R':
            camp_rest(result);
            break;
        default:
            break;
        }
        CHOICE_SELECTED = saved;
    }
}

/* PORT H057+$1EE0: sposta il personaggio corrente in su (dalla testa in coda). */
static void order_up(void)
{
    Character *before = NULL;           /* -$4(a5) */
    Character *p = g_party_head;        /* -$8(a5) */
    Character *next;                    /* -$C(a5) */

    if (p == CUR) {
        while (p->next != NULL) {
            p = p->next;
        }
    } else {
        while (p->next != CUR) {
            before = p;
            p = p->next;
        }
    }
    next = CUR->next;
    if (g_party_head == CUR) {
        if (next != NULL) {
            g_party_head = next;
        }
        p->next = CUR;
        CUR->next = NULL;
    } else {
        p->next = next;
        CUR->next = p;
        if (p == g_party_head || before == NULL) {
            g_party_head = CUR;
        } else {
            before->next = CUR;
        }
    }
}

/* PORT H057+$1FD6: sposta il personaggio corrente in giu' (dalla coda in testa). */
static void order_down(void)
{
    Character *p = g_party_head;        /* -$4(a5) */
    Character *next;                    /* -$8(a5) */

    if (p != CUR) {
        while (p->next != CUR) {
            p = p->next;
        }
    }
    next = CUR->next;
    if (next == NULL) {
        CUR->next = g_party_head;
        g_party_head = CUR;
        p->next = next;
    } else {
        CUR->next = next->next;
        if (g_party_head == CUR) {
            g_party_head = next;
        }
        if (p != CUR) {
            p->next = next;
        }
        next->next = CUR;
    }
}

/*
 * PORT H057+$20A0: col mouse, sposta il personaggio corrente accanto a
 * quello cliccato ($2508): dopo se lo seguiva, altrimenti prima.
 */
static void order_place(void)
{
    Character *p;                       /* -$4(a5) */
    Character *next;                    /* -$8(a5) */
    Character *sel = g_h005_2508;

    if (CUR == sel) {
        return;
    }
    next = CUR->next;
    if (CUR == g_party_head) {
        p = NULL;
    } else {
        for (p = g_party_head; p != NULL && p->next != CUR; p = p->next) {
        }
        if (p == NULL) {
            return;
        }
    }
    if (p != NULL) {
        p->next = next;
    } else {
        g_party_head = CUR->next;
    }
    if (sel == g_party_head) {
        p = NULL;
    } else {
        for (p = g_party_head; p != NULL && p->next != sel; p = p->next) {
        }
        if (p == NULL) {
            return;
        }
    }
    if (CUR->next == sel) {
        CUR->next = sel->next;
        sel->next = CUR;
    } else if (p != NULL) {
        CUR->next = sel;
        p->next = CUR;
    } else {
        CUR->next = sel;
        g_party_head = CUR;
    }
}

/* PORT H057+$220E: Order, riordina il party. */
static void party_order(void)
{
    char menus[2][0x2A];                /* -$54(a5), -$2A(a5) */
    u8 placing = 0;                     /* -$55(a5) */
    u8 special;                         /* -$56(a5) */
    u8 key = ' ';                       /* -$57(a5) */

    copy_dbeq(menus[0], "Select Exit", 0x28);
    copy_dbeq(menus[1], "Place Exit", 0x28);
    while (key != 'E' && key != 0) {
        H005_B(0x24D8) = placing;
        key = ui_request_choice(0x0D, "Party Order: ", 0x28, menus[placing],
                                0x0D, 0x0A, 0x0F, 1, 1, &special);
        if (special) {
            if (!placing) {
                select_party_member(key);
                draw_party(CUR);
            } else {
                if (G_MOUSE_CLICK) {
                    order_place();
                } else if (key == 'H') {
                    order_up();
                } else if (key == 'P') {
                    order_down();
                }
                draw_party(CUR);
            }
        } else if (key == 'S' || key == 'P' || key == 0x0D) {
            placing = (u8)(placing == 0);
            if (placing) {
                show_char_message(CUR, 0x11, "has been selected", 0x0A, 0);
            } else {
                clear_message_area();
            }
        }
    }
}

/* PORT H057+$2368: Drop, toglie dal party il personaggio corrente. */
static void drop_member(void)
{
    if (CUR->next == NULL && CUR == g_party_head) {
        if (ask_yes_no(0x13, "exit to workbench: ", 0x0E, 0x0A, 0x0F) == 'Y') {
            remove_from_party(0, 1);
            quit_game();
        }
        return;
    }
    show_char_message(CUR, 0x0C, "will be gone", 0x0A, 0);
    if (ask_yes_no(0x11, "Drop from party? ", 0x0E, 0x0A, 0x0F) == 'Y') {
        if (CUR->b[0x198]) {
            show_char_message(CUR, 0x11, "bids you farewell", 0x0A, 1);
        } else {
            show_char_message(CUR, 0x14, "is dumped in a ditch", 0x0A, 1);
        }
        remove_from_party(0, 1);
        clear_text_cells(0x11, 1, 0x26, 0x0B);
        draw_party(CUR);
    } else {
        show_char_message(CUR, 0x19, "Breathes A sigh of relief", 0x0A, 1);
    }
}

/* PORT H057+$24AE: Level, livello di difficolta' (g_state_a +$3E8). */
static void set_difficulty(void)
{
    u8 key;                             /* -$1(a5) */
    u8 special;                         /* -$2(a5) */
    u16 level;                          /* -$4(a5) */

    level = COK_GET16(g_state_a + 0x3E8);
    CHOICE_SELECTED = (u8)level;
    key = ui_request_choice(0, "", 0x28, LEVEL_MENU, 0x0D, 0x0A, 0x0F, 1, 1,
                            &special);
    if (special) {
        select_party_member(key);
        draw_party(CUR);
    } else {
        switch (key) {
        case 'N':
            level = 1;
            break;
        case 'S':
            level = 2;
            break;
        case 'V':
            level = 3;
            break;
        case 'A':
            level = 4;
            break;
        case 'C':
            level = 5;
            break;
        default:
            break;
        }
    }
    COK_PUT16(g_state_a + 0x3E8, level);
}

/* PORT H057+$25AE: Speed, velocita' del gioco ($3DF6, 0..9). */
static void set_speed(void)
{
    u8 key;                             /* -$1(a5) */
    u8 special;                         /* -$2(a5) */
    char buf[0x2A];                     /* -$2C(a5) */

    do {
        copy_dbeq(buf, "Game Speed = ", 0x28);
        format_number(0x50, TEXT_BUF, (s32)H005_W(0x3DF6), 0, 0x0A, 1, '0');
        h026_append(0x28, buf, 0x50, TEXT_BUF);
        h026_append(0x28, buf, 0x16, " (0=fastest 9=slowest)");
        ui_draw_text(1, 0x12, 0x0A, 0, 0x28, buf);
        copy_dbeq(buf, "", 0x28);
        if (H005_W(0x3DF6) > 0) {
            h026_append(0x28, buf, 7, " Faster");
        }
        if (H005_W(0x3DF6) < 9) {
            h026_append(0x28, buf, 7, " Slower");
        }
        h026_append(0x28, buf, 5, " Exit");
        key = ui_request_choice(0x0B, "Game Speed:", 0x28, buf, 0x0D, 0x0A,
                                0x0F, 1, 1, &special);
        if (special) {
            switch (key) {
            case 'P':
                if (H005_W(0x3DF6) > 0) {
                    H005_SET_W(0x3DF6, H005_W(0x3DF6) - 1);
                }
                break;
            case 'H':
                if (H005_W(0x3DF6) < 9) {
                    H005_SET_W(0x3DF6, H005_W(0x3DF6) + 1);
                }
                break;
            default:
                break;
            }
        } else {
            switch (key) {
            case 'F':
                H005_SET_W(0x3DF6, H005_W(0x3DF6) - 1);
                break;
            case 'S':
                H005_SET_W(0x3DF6, H005_W(0x3DF6) + 1);
                break;
            default:
                break;
            }
        }
    } while (key != 'E' && key != 0);
    clear_message_area();
}

/* PORT H057+$27B2: menu Alter del campo. */
static void alter_menu(void)
{
    u8 key = ' ';                       /* -$1(a5) */
    u8 key2;                            /* -$2(a5) */
    u8 special;                         /* -$3(a5) */
    char buf[0x2A];                     /* -$2E(a5) */
    u8 saved;                           /* -$2F(a5) */

    while (key != 'E' && key != 0) {
        key = ui_request_choice(0, "", 0x28, ALTER_MENU, 0x0D, 0x0A, 0x0F,
                                1, 1, &special);
        if (special) {
            select_party_member(key);
            draw_party(CUR);
            continue;
        }
        saved = CHOICE_SELECTED;
        switch (key) {
        case 'L':
            set_difficulty();
            break;
        case 'O':
            party_order();
            break;
        case 'D':
            drop_member();
            break;
        case 'S':
            set_speed();
            break;
        case 'I':
            edit_character_icon();
            redraw_game_screen();
            break;
        case 'P':
            do {
                if (H005_B(0x24D5)) {
                    copy_dbeq(buf, "Pics on  ", 0x28);
                    if (H005_B(0x24D4)) {
                        h026_append(0x28, buf, 0x0E, "Animation on  ");
                    } else {
                        h026_append(0x28, buf, 0x0F, "Animation off  ");
                    }
                } else {
                    copy_dbeq(buf, "Pics off  ", 0x28);
                }
                h026_append(0x28, buf, 4, "Exit");
                key2 = ui_request_choice(0, "", 0x28, buf, 0x0D, 0x0A, 0x0F,
                                         0, 1, &special);
                switch (key2) {
                case 'P':
                    H005_B(0x24D5) = (u8)(H005_B(0x24D5) == 0);
                    break;
                case 'A':
                    H005_B(0x24D4) = (u8)(H005_B(0x24D4) == 0);
                    break;
                default:
                    break;
                }
            } while (key2 != 'E' && key2 != 0);
            break;
        default:
            break;
        }
        CHOICE_SELECTED = saved;
    }
}

/* Frame di H057+$29DA visto dalle procedure annidate. */
typedef struct FixFrame {
    u16 pool;                           /* -$2(a5): punti di cura */
    u16 light;                          /* -$4(a5): cure leggere */
    u16 serious;                        /* -$6(a5): cure gravi */
    u16 critical;                       /* -$8(a5): cure critiche */
} FixFrame;

/* PORT H057+$29E8 (annidata): il personaggio puo' curare? */
static u8 fix_can_heal(Character *c)
{
    return (u8)(c->b[0x197] == 0);
}

/*
 * PORT H057+$2A06 (annidata): le cure gia' memorizzate ($03 1d8,
 * $3A 2d8+1, $47 3d8+3) di chi puo' curare.
 */
static void fix_memorized(FixFrame *f)
{
    u16 sum = 0;                        /* -$2(a5) */
    u16 i;                              /* -$4(a5) */
    Character *p;                       /* -$8(a5) */

    for (p = g_party_head; p != NULL; p = p->next) {
        if (!fix_can_heal(p)) {
            continue;
        }
        for (i = 0; i <= 0x39; ++i) {
            if (p->b[0x1E + i] == 0x03) {
                sum = (u16)(sum + roll_dice(1, 8));
            } else if (p->b[0x1E + i] == 0x3A) {
                sum = (u16)(sum + roll_dice(2, 8) + 1);
            } else if (p->b[0x1E + i] == 0x47) {
                sum = (u16)(sum + roll_dice(3, 8) + 3);
            }
        }
    }
    f->pool = (u16)(f->pool + sum);
}

/* PORT H057+$2AFE (annidata): le cure dei posti contati da fix_time. */
static void fix_slots(FixFrame *f)
{
    u16 sum = 0;                        /* -$2(a5) */
    u16 k;                              /* -$4(a5) */
    u16 last;

    last = f->light;
    for (k = 1; k <= last; ++k) {
        sum = (u16)(sum + roll_dice(1, 8));
    }
    last = f->serious;
    for (k = 1; k <= last; ++k) {
        sum = (u16)(sum + roll_dice(2, 8) + 1);
    }
    last = f->critical;
    for (k = 1; k <= last; ++k) {
        sum = (u16)(sum + roll_dice(3, 8) + 3);
    }
    f->pool = (u16)(f->pool + sum);
}

/* PORT H057+$2BBA (annidata): punti ferita mancanti al party. */
static u16 fix_damage(void)
{
    u16 sum = 0;                        /* -$2(a5) */
    Character *p;                       /* -$6(a5) */

    for (p = g_party_head; p != NULL; p = p->next) {
        sum = (u16)(sum + (u16)(p->b[0x64] - p->b[0x1A8]));
    }
    return sum;
}

/*
 * PORT H057+$2C08 (annidata): tempo per memorizzare le cure dei posti
 * di livello 1 (+$124), 4 (+$127) e 5 (+$128) di chi puo' curare.  Il
 * contatore locale -$2(a5) non e' inizializzato nell'originale (qui 0),
 * e i tempi t1..t3 restano quelli del personaggio precedente per chi
 * non puo' curare, come nell'originale.
 */
static void fix_time(FixFrame *f)
{
    u16 extra = 0;                      /* -$2(a5) */
    Character *p = g_party_head;        /* -$6(a5) */
    u16 longest;                        /* -$8(a5) */
    u16 t1 = 0;                         /* -$A(a5) */
    u16 t2 = 0;                         /* -$C(a5) */
    u16 t3 = 0;                         /* -$E(a5) */
    u16 t;                              /* -$10(a5) */
    u16 q;                              /* -$12(a5) */

    f->light = 0;
    f->serious = 0;
    f->critical = 0;
    longest = 0;
    for (; p != NULL; p = p->next) {
        t = 0;
        if (fix_can_heal(p)) {
            f->light = (u16)(f->light + p->b[0x124]);
            t1 = (u16)(p->b[0x124] * 0x0F);
            f->serious = (u16)(f->serious + p->b[0x127]);
            t2 = (u16)(p->b[0x127] * 0x3C);
            f->critical = (u16)(f->critical + p->b[0x128]);
            t3 = (u16)(p->b[0x128] * 0x4B);
        }
        if (t1 > 0) {
            t = 0xF0;
            extra = (u16)(extra + 0x1B);
        }
        if ((u16)(t2 + t3) > 0) {
            t = 0x168;
            if (t3 > 0) {
                extra = (u16)(extra + 0x4E);
            } else {
                extra = (u16)(extra + 0x22);
            }
        }
        t = (u16)(t + t1 + t2 + t3);
        if (longest < t) {
            longest = t;
        }
    }
    if (fix_damage() < extra) {
        q = (u16)(extra / fix_damage());
        longest = (u16)(longest / q);
        if (longest < 0x10E) {
            longest = 0x10E;
        }
    }
    set_rest_time(longest);
}

/* PORT H057+$2DC8 (annidata): distribuisce i punti di cura. */
static void fix_apply(FixFrame *f)
{
    Character *p;                       /* -$4(a5) */
    u16 amount;                         /* -$6(a5) */

    for (p = g_party_head; p != NULL; p = p->next) {
        if (p->b[0x64] <= p->b[0x1A8]) {
            continue;
        }
        amount = (u16)(p->b[0x64] - p->b[0x1A8]);
        if (amount > f->pool) {
            amount = f->pool;
        }
        if (amount < 1) {
            amount = 0;
        }
        if (amount > 0 && heal_character(p, amount, 0) && amount <= f->pool) {
            f->pool = (u16)(f->pool - amount);
        }
    }
}

/*
 * PORT H057+$29DA: Fix, il party riposa il tempo necessario a
 * memorizzare le cure e se ne usano i punti; *result = 1 se il riposo
 * e' stato interrotto.
 */
static void fix_party(u8 *result)
{
    FixFrame f;
    u8 saved[0x0E];                     /* -$16(a5) */

    *result = 0;
    f.pool = 0;
    f.light = 0;
    f.serious = 0;
    f.critical = 0;
    if (fix_damage() == 0) {
        return;
    }
    fix_memorized(&f);
    if (fix_damage() == 0) {
        draw_party(CUR);
        draw_status_line();
        return;
    }
    memcpy(saved, &g_h005[0x24F4], 0x0E);
    fix_time(&f);
    *result = rest_party(0);
    if (*result) {
        return;
    }
    fix_slots(&f);
    fix_apply(&f);
    draw_party(CUR);
    draw_status_line();
    memcpy(&g_h005[0x24F4], saved, 0x0E);
}

/*
 * PORT H057+$2F3A: Encamp.  Contesto 2 finche' si resta al campo; *result
 * = 1 se il riposo e' stato interrotto (incontro).  All'uscita si
 * ricarica l'immagine PIC della zona e si annulla lo studio in attesa.
 */
void encamp(u8 *result)
{
    u8 saved_ctx;                       /* -$1(a5) */
    u8 key;                             /* -$2(a5) */
    u8 tmp;                             /* -$3(a5) */
    u8 special;                         /* -$4(a5) */
    u8 saved;                           /* -$5(a5) */

    saved_ctx = H005_B(0x3DE3);
    H005_B(0x3DE3) = 2;
    H005_SET_W(0x24EA, 0);
    h029_fill_bytes(0x0D, &g_h005[0x24F4], 0x0E, 0);
    memcpy(&g_h005[0x279C], &g_h005[0x27A6], 10);
    H005_B(0x2485) = H005_B(0x2486);
    redraw_game_screen();
    clear_text_cells(1, 0x11, 0x26, 0x16);
    ui_draw_text(1, 0x12, 0x0A, 0, 0x17, "The party makes camp...");
    cancel_all_study();
    *result = 0;
    key = ' ';
    while (!*result && key != 'E' && key != 0) {
        key = ui_request_choice(0, "", 0x28, CAMP_MENU, 0x0D, 0x0A, 0x0F,
                                1, 1, &special);
        if (special) {
            select_party_member(key);
            draw_party(CUR);
            continue;
        }
        saved = CHOICE_SELECTED;
        switch (key) {
        case 'S':
            COK_PUT16(g_state_a + 0x278, COK_GET16(g_state_a + 0x278) + 1);
            if (COK_GET16(g_state_a + 0x278) >= 0x0A) {
                if (!camp_save_ok()) {
                    quit_game();
                }
                redraw_game_screen();
                COK_PUT16(g_state_a + 0x278, 0);
            }
            save_game();
            poll_intuition_events();
            if (ask_yes_no(0x12, "exit to workbench ", 0x0E, 0x0A, 0x0F)
                == 'Y') {
                quit_game();
            }
            break;
        case 'V':
            CHOICE_SELECTED = 1;
            view_character(&tmp);
            break;
        case 'M':
            CHOICE_SELECTED = 1;
            magic_menu(result);
            break;
        case 'R':
            CHOICE_SELECTED = 1;
            camp_rest(result);
            break;
        case 'F':
            fix_party(result);
            break;
        case 'A':
            CHOICE_SELECTED = 1;
            alter_menu();
            break;
        default:
            break;
        }
        CHOICE_SELECTED = saved;
    }
    h026_substr(0x50, TEXT_BUF, 8, (const char *)&g_h005[0x279C], 0, 3);
    if (h026_compare_nocase(0x50, TEXT_BUF, 3, "PIC") == 1) {
        load_sequence(8, (const char *)&g_h005[0x279C], H005_B(0x2485), 0);
    }
    cancel_all_study();
    g_spell_target = NULL;
    H005_B(0x3DE3) = saved_ctx;
    draw_status_line();
    clear_message_area();
    clear_message_line();
}
