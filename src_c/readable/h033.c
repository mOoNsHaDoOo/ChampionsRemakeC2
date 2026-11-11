/* H033: Vettori e servizi condivisi di azioni/oggetti; dettaglio parziale. */
#include <string.h>

#include "h033.h"
#include "globals.h"
#include "h003_exec.h"
#include "h008.h"
#include "h026_string.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h045.h"
#include "h062.h"
#include "h063.h"
#include "h085.h"
#include "unported.h"
#include "h077.h"
#include "h048.h"

/* Tabella degli incantesimi H005+$66: 16 byte per incantesimo (1..). */
#define SPELL_B(s, k)   H005_B(0x66 + ((int)(s) - 1) * 16 + (k))
/* Nomi degli incantesimi H005+$716: 32 byte per incantesimo. */
#define SPELL_NAME(s)   ((const char *)&H005_B(0x716 + ((int)(s) - 1) * 32))

static CokMenuItem *new_menu_item(void)
{
    /* AllocMem($30, MEMF_CLEAR) */
    return (CokMenuItem *)exec_alloc_mem(sizeof(CokMenuItem), COK_MEMF_CLEAR);
}

/*
 * PORT H033+$00EE: menu degli incantesimi dell'elenco H085+$1B2.  mode
 * 1 Cast, 2 Memorize, 3 Scribe, 4 Learn.  Restituisce l'incantesimo scelto
 * (0 con Exit); con Scribe la pergamena della riga va in $2770.  L'elenco
 * viene liberato.
 */
u16 choose_spell(u16 mode, s16 *index)
{
    char command[0x2A];                 /* -$5c(a5) */
    char prompt[0x2A];                  /* -$32(a5) */
    u8 redraw;                          /* -$67(a5) */
    u8 with_exit;                       /* -$66(a5) */
    u8 key;                             /* -$65(a5) */
    u16 result;                         /* -$64(a5) */
    u16 last_row;                       /* -$62(a5) */
    u16 count;                          /* -$60(a5) */
    CokMenuItem *node;                  /* -$8(a5) */
    CokMenuItem *chosen;                /* -$4(a5) */

    switch (mode) {
    case 1:  strcpy(command, "Cast");     break;
    case 2:  strcpy(command, "Memorize"); break;
    case 3:  strcpy(command, "Scribe");   break;
    case 4:  strcpy(command, "Learn");    break;
    default: strcpy(command, "");         break;
    }
    redraw = 0;
    if (mode == 1 || mode == 2 || mode == 3 || mode == 4) {
        strcpy(prompt, "Choose Spell :  ");
    } else {
        strcpy(prompt, "");
    }
    if (mode == 2) {
        last_row = 0x0F;
        redraw = H005_B(0x24DD);
    } else {
        last_row = 0x16;
    }
    with_exit = (u8)(mode != 4);
    if (*index < 0) {
        redraw = 1;
        *index = 0;
    }
    if (mode == 4 || mode == 1) {
        redraw = 1;
    }
    chosen = NULL;
    do {
        key = list_menu(0x28, prompt, 0x28, command, 0x0D, 0x0A, 0x0F, 1, 5,
                        0x26, last_row, g_h085_spell_list, with_exit, &redraw,
                        (u16 *)index, &chosen);
    } while (key != 'E' && key != 0 && key != '\r' && key != 'C' &&
             key != 'M' && key != 'S' && key != 'L');
    node = g_h085_spell_list;
    count = 0;
    while (node != chosen) {
        if (!node->header) {
            ++count;
        }
        node = node->next;
    }
    if (key == 'E' || key == 0) {
        result = 0;
    } else {
        result = g_h085_spell_ids[count];
    }
    if (mode == 3) {
        g_scroll_item = g_h085_scroll_items[count];
    }
    menu_free(&g_h085_spell_list);
    return result;
}

/*
 * PORT H033+$0366: accoda all'elenco la riga della pergamena per spell (bit
 * 7: " *"), preceduta dal nome del livello quando il livello cambia.
 */
static void add_scroll_line(u16 spell)
{
    CokMenuItem *node = g_h085_spell_list;      /* -$4(a5) */
    u16 lines;                                  /* -$6(a5) */
    u8 level;                                   /* -$7(a5) */

    if (g_h085_spell_list == NULL) {
        node = new_menu_item();
        g_h085_spell_list = node;
        level = 0;
        lines = 0;
    } else {
        lines = 1;
        while (node->next != NULL) {
            if (!node->header) {
                ++lines;
            }
            node = node->next;
        }
        level = SPELL_B(g_h085_spell_ids[lines - 1], 1);
        node->next = new_menu_item();
        node = node->next;
    }
    node->next = NULL;
    if (level != SPELL_B(mask_byte((u8)spell, 0x7F), 1)) {
        h026_copy(0x28, node->text, 0x14,
                  H085_LEVEL_NAME(SPELL_B(mask_byte((u8)spell, 0x7F), 1)));
        node->header = 1;
        node->next = new_menu_item();
        node = node->next;
        node->next = NULL;
    }
    if (spell > 0x7F) {
        strcpy(node->text, " *");
    } else {
        strcpy(node->text, "  ");
    }
    h026_append(0x28, node->text, 0x1F,
                SPELL_NAME(mask_byte((u8)spell, 0x7F)));
    node->header = 0;
    g_h085_spell_ids[lines] = mask_byte((u8)spell, 0x7F);
}

/*
 * PORT H033+$056E: righe degli incantesimi della pergamena $2770 (+$44..
 * +$46); usable: solo quelli con il bit 7 (> $80).
 */
static void scroll_item_spells(u8 usable)
{
    CokEffect *effect;                  /* -$6(a5) */
    Character *c = g_current_char;
    CokItem *it;
    u16 k;                              /* -$2(a5) */
    u8 v;

    if (find_effect(c, 0x10, &effect) ||
        ((c->b[0xFE] > 0 || c->b[0x106] > c->b[0xDC]) &&
         H005_B(0x336C + g_scroll_item->b[0x30] * 0x12) == 0x0C)) {
        g_scroll_item->b[0x3B] = mask_byte(g_scroll_item->b[0x3B], 0xF8);
    }
    it = g_scroll_item;
    if (mask_byte(it->b[0x3B], 7) != 0) {
        return;
    }
    for (k = 1; k <= 3; ++k) {
        v = it->b[0x44 + k - 1];
        if ((usable && v > 0x80) || (!usable && v > 0)) {
            add_scroll_line(v);
            /*
             * Nell'originale il contatore non ha limite e oltre $31 voci
             * scrive sulle tabelle seguenti di H085; qui la scrittura si
             * ferma alla fine della tabella.
             */
            if (g_h085_scroll_count < 0x31) {
                g_h085_scroll_items[g_h085_scroll_count] = g_scroll_item;
            }
            ++g_h085_scroll_count;
        }
    }
}

/*
 * PORT H033+$06C0: righe di tutte le pergamene del personaggio corrente
 * leggibili dalla sua classe di incantesimi (+$5F: 1 bit $20, 2 bit $10).
 */
static void collect_scroll_spells(u8 usable)
{
    u16 i;

    for (i = 0; i <= 0x30; ++i) {
        g_h085_scroll_items[i] = NULL;
    }
    g_h085_scroll_count = 0;
    for (g_scroll_item = g_current_char->items; g_scroll_item != NULL;
         g_scroll_item = g_scroll_item->next) {
        if (is_scroll(g_scroll_item) &&
            ((g_current_char->b[0x5F] == 1 &&
              mask_byte(g_scroll_item->b[0x3B], 0x20)) ||
             (g_current_char->b[0x5F] == 2 &&
              mask_byte(g_scroll_item->b[0x3B], 0x10)))) {
            scroll_item_spells(usable);
        }
    }
}

/*
 * PORT H033+$07A4: per un incantesimo della classe 2, e' gia' fra quelli
 * in memoria (+$1F..+$57)?
 */
static u8 spell_in_memory(Character *c, u16 spell)
{
    u16 i;                              /* -$2(a5) */
    u8 found;                           /* -$3(a5) */
    u8 result;                          /* -$4(a5) */

    spell = mask_byte((u8)spell, 0x7F);
    result = 0;
    if (SPELL_B(spell, 0) == 2) {
        i = 1;
        found = 0;
        while (!found && i <= 0x39) {
            if (mask_byte(c->b[0x1E + i], 0x7F) == spell) {
                found = 1;
            }
            ++i;
        }
        result = found;
    }
    return result;
}

/*
 * PORT H033+$084C: inserisce spell nell'elenco ordinato per livello; se
 * c'e' gia' ne conta le copie (" (n)").
 */
static void add_spell(u16 spell)
{
    CokMenuItem *node = g_h085_spell_list;      /* -$5a(a5) */
    CokMenuItem *prev;                          /* -$5e(a5) */
    CokMenuItem *fresh;                         /* -$62(a5) */
    char number[0x52];                          /* -$52(a5) */
    u16 carry;                                  /* -$54(a5) */
    u16 saved;                                  /* -$56(a5) */
    u16 i;                                      /* -$64(a5) */
    u16 j;                                      /* -$66(a5) */
    u8 found = 0;                               /* -$67(a5) */
    u8 level = SPELL_B(mask_byte((u8)spell, 0x7F), 1);  /* -$68(a5) */
    u16 masked;

    if (g_h085_spell_list == NULL) {
        h029_fill_bytes(0x73, (u8 *)g_h085_spell_counts, 0x74, 0);
        node = new_menu_item();
        node->next = NULL;
        g_h085_spell_list = node;
        i = 0;
        g_h085_spell_counts[i] = 1;
    } else {
        i = 0;
        while (node != NULL && !found) {
            if (!node->header) {
                if (level < SPELL_B(g_h085_spell_ids[i], 1) ||
                    g_h085_spell_ids[i] == mask_byte((u8)spell, 0x7F)) {
                    found = 1;
                } else {
                    ++i;
                    node = node->next;
                }
            } else {
                node = node->next;
                ++i;
            }
        }
        if (g_h085_spell_ids[i] != mask_byte((u8)spell, 0x7F)) {
            prev = g_h085_spell_list;
            if (prev != node) {
                while (prev->next != node) {
                    prev = prev->next;
                }
                fresh = new_menu_item();
                fresh->next = prev->next;
                prev->next = fresh;
                node = fresh;
            } else {
                fresh = new_menu_item();
                fresh->next = node;
                g_h085_spell_list = fresh;
                node = fresh;
            }
            carry = 1;
            for (j = i; j <= 0x39; ++j) {
                saved = g_h085_spell_counts[j];
                g_h085_spell_counts[j] = carry;
                carry = saved;
            }
        } else {
            ++g_h085_spell_counts[i];
        }
    }
    if (spell > 0x7F) {
        strcpy(node->text, " *");
    } else {
        strcpy(node->text, "  ");
    }
    h026_append(0x28, node->text, 0x1F,
                SPELL_NAME(mask_byte((u8)spell, 0x7F)));
    node->header = 0;
    if (g_h085_spell_counts[i] > 1) {
        format_number(0x50, number, g_h085_spell_counts[i], 0, 0x0A, 2, ' ');
        h026_append(0x28, node->text, 2, " (");
        h026_append(0x28, node->text, 0x50, number);
        h026_append(0x28, node->text, 1, ")");
    }
    masked = mask_byte((u8)spell, 0x7F);
    if (g_h085_spell_ids[i] != masked) {
        carry = g_h085_spell_ids[i];
        g_h085_spell_ids[i] = masked;
        for (j = (u16)(i + 1); j <= 0x39; ++j) {
            saved = g_h085_spell_ids[j];
            g_h085_spell_ids[j] = carry;
            carry = saved;
        }
    }
}

/*
 * PORT H033+$0C64: la classe dell'incantesimo (byte 0 della tabella) e'
 * utilizzabile dal personaggio?
 */
static u8 spell_class_usable(Character *c, u16 spell)
{
    u8 result = 0;                      /* -$1(a5) */

    spell = mask_byte((u8)spell, 0x7F);
    switch (SPELL_B(spell, 0)) {
    case 0:
    case 2:
        result = (u8)(c->b[0x15] > 8 &&
                      (c->b[0xFE] > 0 || c->b[0x105] > 5));
        break;
    case 1:
        result = 0;
        break;
    case 3:
        if (c->b[0x13] > 8 &&
            !(c->b[0x5B] == 6 && c->readied[2] != NULL &&
              H005_B(0x3DE3) == 5)) {
            result = (u8)(c->b[0x102] > 8 || c->b[0x103] > 0);
        } else {
            result = 0;
        }
        break;
    case 4:
        result = 0;
        break;
    default:
        break;
    }
    return result;
}

/*
 * PORT H033+$0D7C: costruisce in H085+$1B2 l'elenco degli incantesimi del
 * personaggio corrente: kind 0 in memoria, 1 nel grimorio, 2 sulla
 * pergamena $2770, 3 su tutte le pergamene, 4 da scegliere, 5 da
 * memorizzare, 6 sulle pergamene leggibili.  Tranne che per le pergamene
 * aggiunge le intestazioni dei livelli.  Restituisce 1 se l'elenco non e'
 * vuoto.
 */
u8 build_spell_list(u16 kind)
{
    Character *c = g_current_char;
    CokMenuItem *node;                  /* -$c(a5) */
    CokMenuItem *p;                     /* -$8(a5) */
    u16 i;                              /* -$2(a5) */
    u16 s;                              /* -$4(a5) */
    u16 row;                            /* -$12(a5) */
    u8 level;                           /* -$e(a5) */
    u8 prev_level;                      /* -$d(a5) */
    u8 headers = 1;                     /* -$f(a5) */
    u8 result = 0;                      /* -$10(a5) */

    g_h085_spell_list = NULL;
    for (i = 0; i <= 0x39; ++i) {
        g_h085_spell_ids[i] = 0;
    }
    switch (kind) {
    case 0:                             /* $0DC2 */
        for (i = 0; i <= 0x39; ++i) {
            if (c->b[0x1E + i] > 0 &&
                spell_class_usable(c, mask_byte(c->b[0x1E + i], 0x7F)) &&
                c->b[0x1E + i] < 0x80) {
                add_spell(c->b[0x1E + i]);
            }
        }
        break;
    case 1:                             /* $0EE2 */
        for (i = 1; i <= 0x6B; ++i) {
            if (c->b[0x66 + i - 1] && spell_class_usable(c, i) &&
                !spell_in_memory(c, i)) {
                add_spell(i);
            }
        }
        break;
    case 2:                             /* $0F46 */
        scroll_item_spells(0);
        headers = 0;
        break;
    case 3:                             /* $0F52 */
        collect_scroll_spells(0);
        headers = 0;
        break;
    case 4:                             /* $0F6C */
        row = (c->b[0x5F] == 1) ? 2 : 3;
        for (level = 1; level <= 4; ++level) {
            if (c->b[0x136 + level - 1] > 0) {
                i = 1;
                s = 0xFF;
                while (i <= 0x0A && s != 0) {
                    s = H005_W(0x1476 + (row - 1) * 0x50 +
                               (level - 1) * 0x14 + (i - 1) * 2);
                    if (s != 0 && c->b[0x66 + s - 1] == 0) {
                        add_spell(s);
                    }
                    ++i;
                }
            }
        }
        break;
    case 5:                             /* $0E60 */
        for (i = 0; i <= 0x39; ++i) {
            if (c->b[0x1E + i] > 0x7F &&
                spell_class_usable(c, mask_byte(c->b[0x1E + i], 0x7F))) {
                add_spell(c->b[0x1E + i]);
            }
        }
        break;
    case 6:                             /* $0F5E */
        collect_scroll_spells(1);
        headers = 0;
        break;
    default:
        break;
    }
    if (g_h085_spell_list != NULL) {
        if (headers) {
            i = 0;
            level = SPELL_B(g_h085_spell_ids[i], 1);
            node = new_menu_item();
            node->next = g_h085_spell_list;
            g_h085_spell_list = node;
            h026_copy(0x28, g_h085_spell_list->text, 0x14,
                      H085_LEVEL_NAME(SPELL_B(g_h085_spell_ids[i], 1)));
            g_h085_spell_list->header = 1;
            p = g_h085_spell_list;
            do {
                prev_level = level;
                if (g_h085_spell_ids[i] != 0) {
                    level = SPELL_B(g_h085_spell_ids[i], 1);
                }
                if (prev_level < level) {
                    node = new_menu_item();
                    node->next = p->next;
                    p->next = node;
                    p = p->next;
                    h026_copy(0x28, p->text, 0x14, H085_LEVEL_NAME(level));
                    p->header = 1;
                }
                ++i;
                p = p->next;
            } while (p != NULL);
        }
        result = 1;
    }
    return result;
}

/* PORT H033+$00E0: link/unlk, nessun effetto. */
void h033_init(void)
{
}

/*
 * PORT H033+$1A50: installa i gestori delle azioni (tabella H005+$25C0) e
 * le voci di H033/H085 della tabella degli effetti (H005+$2832); azzera
 * alcuni stati.
 */
void install_action_handlers(void)
{
    g_handlers_25c0[107] = (CokHandler)select_spell_target;   /* $276C */
    H005_B(0x24AA) = 0;
    H005_B(0x24D9) = 0;
    g_spell_target = NULL;              /* $251C */
    H005_B(0x24A8) = 1;
    g_handlers_25c0[0] = spell_bless;   /* $25C0 */
    g_handlers_25c0[1] = spell_curse;   /* $25C4 */
    g_handlers_25c0[2] = cure_light_wounds;   /* $25C8 */
    g_handlers_25c0[3] = spell_cause_light_wounds;   /* $25CC */
    g_handlers_25c0[4] = spell_affected;   /* $25D0 */
    g_handlers_25c0[5] = spell_protected;   /* $25D4 */
    g_handlers_25c0[6] = spell_protected;   /* $25D8 */
    g_handlers_25c0[7] = spell_resist_cold;   /* $25DC */
    g_handlers_25c0[8] = spell_burning_hands;   /* $25E0 */
    g_handlers_25c0[9] = spell_charm_person;   /* $25E4 */
    g_handlers_25c0[10] = spell_affected;   /* $25E8 */
    g_handlers_25c0[11] = enlarge;   /* $25EC */
    g_handlers_25c0[12] = spell_reduce;   /* $25F0 */
    g_handlers_25c0[13] = spell_friends;   /* $25F4 */
    g_handlers_25c0[14] = spell_magic_missile;   /* $25F8 */
    g_handlers_25c0[15] = spell_protected;   /* $25FC */
    g_handlers_25c0[16] = spell_protected;   /* $2600 */
    g_handlers_25c0[17] = spell_affected;   /* $2604 */
    g_handlers_25c0[18] = spell_shield;   /* $2608 */
    g_handlers_25c0[19] = spell_shocking_grasp;   /* $260C */
    g_handlers_25c0[20] = spell_sleep;   /* $2610 */
    g_handlers_25c0[21] = spell_affected;   /* $2614 */
    g_handlers_25c0[22] = spell_hold_person;   /* $2618 */
    g_handlers_25c0[23] = spell_resist_fire;   /* $261C */
    g_handlers_25c0[24] = spell_silence;   /* $2620 */
    g_handlers_25c0[25] = spell_slow_poison;   /* $2624 */
    g_handlers_25c0[26] = spell_snake_charm;   /* $2628 */
    g_handlers_25c0[27] = spell_spiritual_hammer;   /* $262C */
    g_handlers_25c0[28] = spell_affected;   /* $2630 */
    g_handlers_25c0[29] = spell_invisibility;   /* $2634 */
    g_handlers_25c0[30] = spell_knock;   /* $2638 */
    g_handlers_25c0[31] = spell_mirror_image;   /* $263C */
    g_handlers_25c0[32] = spell_ray_of_enfeeblement;   /* $2640 */
    g_handlers_25c0[33] = spell_stinking_cloud;   /* $2644 */
    g_handlers_25c0[34] = strength_spell;   /* $2648 */
    g_handlers_25c0[35] = spell_no_effect;   /* $264C */
    g_handlers_25c0[36] = spell_cure_blindness;   /* $2650 */
    g_handlers_25c0[37] = spell_cause_blindness;   /* $2654 */
    g_handlers_25c0[38] = cure_disease;   /* $2658 */
    g_handlers_25c0[39] = spell_cause_disease;   /* $265C */
    g_handlers_25c0[40] = spell_dispel_magic;   /* $2660 */
    g_handlers_25c0[41] = spell_prayer;   /* $2664 */
    g_handlers_25c0[42] = spell_remove_curse;   /* $2668 */
    g_handlers_25c0[43] = spell_bestow_curse;   /* $266C */
    g_handlers_25c0[44] = spell_blink;   /* $2670 */
    g_handlers_25c0[45] = spell_dispel_magic;   /* $2674 */
    g_handlers_25c0[46] = spell_fireball;   /* $2678 */
    g_handlers_25c0[47] = spell_haste;   /* $267C */
    g_handlers_25c0[48] = spell_hold_person;   /* $2680 */
    g_handlers_25c0[49] = spell_invisibility;   /* $2684 */
    g_handlers_25c0[50] = spell_lightning_bolt;   /* $2688 */
    g_handlers_25c0[51] = spell_protected;   /* $268C */
    g_handlers_25c0[52] = spell_protected;   /* $2690 */
    g_handlers_25c0[53] = spell_protected;   /* $2694 */
    g_handlers_25c0[54] = spell_slow;   /* $2698 */
    g_handlers_25c0[55] = spell_no_effect;   /* $269C */
    g_handlers_25c0[56] = spell_speedy;   /* $26A0 */
    g_handlers_25c0[57] = cure_serious_wounds;   /* $26A4 */
    g_handlers_25c0[58] = spell_strength_21;   /* $26A8 */
    g_handlers_25c0[59] = spell_bolt_20;   /* $26AC */
    g_handlers_25c0[60] = spell_paralyze;   /* $26B0 */
    g_handlers_25c0[61] = spell_heal_3430;   /* $26B4 */
    g_handlers_25c0[62] = spell_invisible;   /* $26B8 */
    g_handlers_25c0[63] = spell_fireball;   /* $26BC */
    g_handlers_25c0[64] = spell_damage_2d4;   /* $26C0 */
    g_handlers_25c0[65] = spell_cause_serious_wounds;   /* $26C4 */
    g_handlers_25c0[66] = neutralize_poison;   /* $26C8 */
    g_handlers_25c0[67] = spell_event_9;   /* $26CC */
    g_handlers_25c0[68] = spell_protected;   /* $26D0 */
    g_handlers_25c0[69] = spell_sticks_to_snakes;   /* $26D4 */
    g_handlers_25c0[70] = spell_no_effect;   /* $26D8 */
    g_handlers_25c0[71] = spell_no_effect;   /* $26DC */
    g_handlers_25c0[72] = spell_no_effect;   /* $26E0 */
    g_handlers_25c0[73] = spell_no_effect;   /* $26E4 */
    g_handlers_25c0[74] = spell_no_effect;   /* $26E8 */
    g_handlers_25c0[75] = spell_no_effect;   /* $26EC */
    g_handlers_25c0[76] = spell_no_effect;   /* $26F0 */
    g_handlers_25c0[77] = spell_no_effect;   /* $26F4 */
    g_handlers_25c0[78] = spell_no_effect;   /* $26F8 */
    g_handlers_25c0[79] = spell_no_effect;   /* $26FC */
    g_handlers_25c0[80] = spell_charm_monster;   /* $2700 */
    g_handlers_25c0[81] = spell_confusion;   /* $2704 */
    g_handlers_25c0[82] = spell_teleport;   /* $2708 */
    g_handlers_25c0[83] = spell_fear;   /* $270C */
    g_handlers_25c0[84] = spell_fire_shield;   /* $2710 */
    g_handlers_25c0[85] = spell_fumble;   /* $2714 */
    g_handlers_25c0[86] = spell_ice_storm;   /* $2718 */
    g_handlers_25c0[87] = spell_minor_globe;   /* $271C */
    g_handlers_25c0[88] = spell_remove_curse;   /* $2720 */
    g_handlers_25c0[89] = spell_no_effect;   /* $2724 */
    g_handlers_25c0[90] = spell_no_effect;   /* $2728 */
    g_handlers_25c0[91] = spell_no_effect;   /* $272C */
    g_handlers_25c0[92] = spell_no_effect;   /* $2730 */
    g_handlers_25c0[93] = spell_no_effect;   /* $2734 */
    g_handlers_25c0[94] = spell_silent_3d74;   /* $2738 */
    g_handlers_25c0[95] = spell_silent_3da0;   /* $273C */
    g_handlers_25c0[96] = spell_silent_3dcc;   /* $2740 */
    g_handlers_25c0[97] = spell_no_effect;   /* $2744 */
    g_handlers_25c0[98] = spell_heal_3df8;   /* $2748 */
    g_handlers_25c0[99] = spell_bestow_curse;   /* $274C */
    g_handlers_25c0[100] = spell_protected;   /* $2750 */
    g_handlers_25c0[101] = spell_silence;   /* $2754 */
    g_handlers_25c0[102] = spell_affected;   /* $2758 */
    g_handlers_25c0[103] = spell_remove_curse;   /* $275C */
    g_handlers_25c0[104] = spell_bless;   /* $2760 */
    g_handlers_25c0[105] = spell_charm_person;   /* $2764 */
    g_handlers_25c0[106] = spell_burning_hands;   /* $2768 */
    g_handlers_2832[3] = (CokHandler)effect_eye_attack;   /* $283E */
    g_handlers_2832[5] = (CokHandler)effect_breath;   /* $2846 */
    g_handlers_2832[103] = (CokHandler)effect_breath;   /* $29CE */
    g_handlers_2832[82] = (CokHandler)effect_breath;   /* $297A */
    g_handlers_2832[83] = (CokHandler)effect_poison_breath;   /* $297E */
    g_handlers_2832[84] = (CokHandler)effect_lightning_breath;   /* $2982 */
    g_handlers_2832[89] = (CokHandler)effect_acid_breath;   /* $2996 */
    g_handlers_2832[77] = (CokHandler)effect_fireball;   /* $2966 */
}

/* PORT H033+$1A40: azione degli incantesimi senza effetto (link/unlk). */
void spell_no_effect(void)
{
}

/* PORT H033+$17E6: l'oggetto e' una pergamena (tipo $27 o $28)? */
u8 is_scroll(const CokItem *it)
{
    if (it != NULL && (it->b[0x30] == 0x27 || it->b[0x30] == 0x28)) {
        return 1;
    }
    return 0;
}

/*
 * PORT H033+$12D4 (vettore $276C): bersagli dell'incantesimo in $2520
 * (quanti in $246C) secondo il byte 7 della tabella: 1 chi lancia, 2 da
 * scegliere, 4 tutto il party; altrimenti *ok = 0.
 */
void select_spell_target(u8 spell, u8 unused, u8 *ok)
{
    (void)unused;
    if (g_spell_target == NULL) {
        g_spell_target = g_current_char;
    }
    g_spell_targets[0] = g_current_char;
    H005_B(0x246C) = 1;
    *ok = 1;
    switch (SPELL_B(spell, 7)) {
    case 1:                             /* $1326 */
        break;
    case 2:                             /* $1328 */
        redraw_game_screen();
        choose_party_member(0x13, "Cast Spell on whom ", 1, 1,
                            &g_spell_target);
        if (g_spell_target == NULL) {
            g_spell_targets[0] = NULL;
            H005_B(0x246C) = 0;
            *ok = 0;
        } else {
            g_spell_targets[0] = g_spell_target;
        }
        break;
    case 4:                             /* $1376 */
        g_spell_targets[H005_B(0x246C) - 1] = g_party_head;
        while (g_spell_targets[H005_B(0x246C) - 1]->next != NULL) {
            g_spell_targets[H005_B(0x246C)] =
                g_spell_targets[H005_B(0x246C) - 1]->next;
            add_to_byte(&H005_B(0x246C), 1);
        }
        break;
    default:                            /* $13F2 */
        *ok = 0;
        break;
    }
}

/*
 * PORT H033+$1426: lancia spell per il personaggio corrente.  Fuori dal
 * combattimento gli incantesimi solo da combattimento (byte 7 = 0) si
 * possono solo perdere (o, da un oggetto, usare comunque).  announce:
 * mostra "casts".  Sceglie i bersagli (vettore $276C) ed esegue il gestore
 * dell'incantesimo ($25C0 + (spell-1)*4); *redraw = bersagli scelti.
 */
void cast_spell(u16 spell, u8 auto_abort, u8 announce, u8 *redraw)
{
    Character *c = g_current_char;      /* -$e(a5) */
    u8 go = 1;                          /* -$1(a5) */
    u16 a;                              /* -$4(a5) */
    u16 b;                              /* -$6(a5) */
    u16 n;                              /* -$8(a5) */

    if (H005_B(0x3DE3) != 5 && SPELL_B(spell, 7) == 0) {
        if (!H005_B(0x24D9)) {
            ui_draw_text(1, 0x13, 0x0A, 0, 0x1F, SPELL_NAME(spell));
            ui_draw_text(1, 0x14, 0x0A, 0, 0x15, "can't be cast here...");
            if (ask_yes_no(9, "Lose it? ", 0x0D, 0x0A, 0x0F) == 'Y') {
                forget_spell(c, spell);
            }
        } else {
            ui_draw_text(1, 0x13, 0x0A, 0, 9, "That Item");
            ui_draw_text(1, 0x14, 0x0A, 0, 0x18, "is a combat-only item...");
            if (ask_yes_no(8, "Use it? ", 0x0D, 0x0A, 0x0F) == 'Y') {
                *redraw = 1;
            }
        }
        announce = 0;
        go = 0;
    }
    if (announce && !H005_B(0x24D9)) {
        announce_spell(c, 5, "casts", spell);
    }
    while (go) {
        ((void (*)(u8, u8, u8 *))g_handlers_25c0[107])((u8)spell, auto_abort,
                                                       redraw);
        if (*redraw) {
            go = 0;
            if (H005_B(0x3DE3) == 5) {
                load_missile_frames(0x12);
                a = combatant_x(c);
                b = combatant_y(c);
                n = 0;
                while (!in_direction((s16)a, (s16)b, (s16)H005_W(0x251A),
                                     (s16)H005_W(0x2518), n)) {
                    ++n;
                }
                H005_B(0x24C6) = 1;
                set_combatant_frame(c, (u8)n, 1, 0);
                switch (spell) {
                case 0x2F:
                    h043_190e(0x13);
                    break;
                case 0x33:
                    h043_190e(0x0F);
                    break;
                default:
                    h043_190e(2);
                    break;
                }
                animate_missile(a, b, H005_W(0x251A), H005_W(0x2518), 4, 1);
                if (combatant_visible(c, 0)) {
                    set_combatant_frame(c, (c->block_192->b)[0x0B], 1, 1);
                    set_combatant_frame(c, (c->block_192->b)[0x0B], 0, 0);
                }
            }
            remove_effects_19(c);
            if (!H005_B(0x24D9)) {
                forget_spell(c, spell);
            }
            H005_B(0x2471) = (u8)spell;
            g_handlers_25c0[H005_B(0x2471) - 1]();
            H005_B(0x2471) = 0;
            H005_B(0x24A9) = 0;
        } else if (H005_B(0x3DE3) != 5) {
            go = 0;
        } else if (auto_abort ||
                   ask_yes_no(0x0D, "Abort Spell? ", 0x0E, 0x0A, 0x0F) ==
                   'Y') {
            show_message_line(0x0D, "Spell Aborted");
            if (!H005_B(0x24D9)) {
                forget_spell(c, spell);
            }
            go = 0;
        }
    }
    clear_message_area();
    if (H005_B(0x3DE3) == 5) {
        clear_text_cells(0, 0x17, 0x27, 0x17);
    }
}

/*
 * PORT H033+$1836: toglie spell (l'ultima delle tre posizioni +$44..+$46
 * che lo contiene) dalla pergamena; +$32 cala di 1 e sotto 100 la
 * pergamena viene eliminata.
 */
void remove_scroll_spell(Character *c, CokItem *it, u16 spell)
{
    u16 wanted = spell;                 /* -$2(a5) */
    u16 k;                              /* -$4(a5) */
    u16 slot = 0;                       /* -$6(a5) */

    for (k = 1; k <= 3; ++k) {
        if (mask_byte(it->b[0x44 + k - 1], 0x7F) == wanted) {
            slot = k;
        }
    }
    if (slot == 0) {
        return;
    }
    it->b[0x44 + slot - 1] = 0;
    it->b[0x32] = (u8)(it->b[0x32] - 1);
    if (it->b[0x32] < 0x64) {
        delete_item(c, it);
    }
}

/*
 * PORT H033+$18EE: annuncia l'incantesimo: in combattimento "Casts a
 * Spell" e "Spell  :  nome" in basso; altrimenti nome, testo e nome
 * dell'incantesimo alle righe $13-$14, poi l'attesa.
 */
void announce_spell(Character *c, u16 len, const char *text, u16 spell)
{
    char line[0x52];                    /* -$52(a5) */

    if (H005_B(0x3DE3) == 5) {
        show_char_message(c, 0x0D, "Casts a Spell", 0x0A, 1);
        clear_text_cells(0, 0x17, 0x27, 0x17);
        strcpy(line, "Spell  :  ");
        h026_append(0x50, line, 0x1F, SPELL_NAME(spell));
        ui_draw_text(0, 0x17, 0x0A, 0, 0x50, line);
    } else {
        clear_text_cells(1, 0x12, 0x26, 0x16);
        draw_character_name(c, 1, 0x13, 0);
        ui_draw_text((u16)(h026_strlen(0x0F, (const char *)c->b) + 1 + 1),
                     0x13, 0x0A, 0, len, text);
        ui_draw_text(1, 0x14, 0x0A, 0, 0x1F, SPELL_NAME(spell));
        message_delay();
        clear_message_area();
    }
}

/*
 * PORT H033+$11FC: gittata dell'incantesimo: +$2 + (+$3 / 4) per il
 * livello di chi lancia (H063+$2FAA), o +$2 + 6 * +$3 con $24D9; 0 con
 * +$6 non nullo vale 1, e $FF vale 1.
 */
u16 spell_range(u16 spell)
{
    u16 r;                              /* -$2(a5) */
    const u8 *e = &g_h005[0x66 + (spell - 1) * 16];

    if (!H005_B(0x24D9)) {
        r = (u16)((u16)caster_level(spell) * (u16)(e[3] >> 2) + e[2]);
    } else {
        r = (u16)(e[3] * 6 + e[2]);
    }
    if (r == 0 && e[6] != 0) {
        r = 1;
    }
    if (r == 0xFF) {
        r = 1;
    }
    return r;
}
