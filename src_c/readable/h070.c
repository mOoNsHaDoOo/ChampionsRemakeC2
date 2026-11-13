/* H070: combat outcome, experience and treasure. */
#include <string.h>
#include "cok.h"
#include "h070.h"
#include "globals.h"
#include "unported.h"
#include "h003_exec.h"
#include "h008.h"
#include "h015_runtime.h"
#include "h026_string.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h033.h"
#include "h044_tiles.h"
#include "h045.h"
#include "h053.h"
#include "h061.h"
#include "h062.h"
#include "h063.h"
#include "h065.h"
#include "h067.h"
#include "h071.h"

/* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
#define POOL(k)         H005_L(0x2A1E + (k) * 4)
/* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
#define SET_POOL(k, v)  H005_SET_L(0x2A1E + (k) * 4, (v))
#define TURN(c)         ((c)->block_192)

static u8 s_enemies;                    /* -$1(a4): there were enemies */
static u8 s_fled;                       /* -$2(a4): the party fled */

/* PORT H070+$0272: link/unlk, no effect. */
void h070_init(void)
{
}

/* Frees the treasure list ($2A3A). */
static void free_treasure(void)
{
    CokItem *it = g_treasure_items;     /* -$4(a5) */
    CokItem *n;                         /* -$8(a5) */

    while (it != NULL) {
        n = it;
        it = it->next;
        exec_free_mem(n, sizeof(CokItem));
    }
    g_treasure_items = NULL;
}

/*
 * PORT H070+$0280: experience per character: for every defeated enemy
 * (side 1, status not 0 nor 3) its value (+$13C plus +$13E for the hit
 * dice +$123), its coins (if +$15 of the turn = 1) into the pool and its
 * items into the treasure (unless $3E00+$5C6 = 1); then the value of the pool and
 * of the magic items of the treasure; divided by the remaining characters
 * ($3E00+$67C - $2499).  With divisor 0 the original raises an exception: here
 * the total.
 */
static void compute_experience(u32 *out)
{
    u32 xp = 0;                         /* -$A(a5) */
    Character *p;                       /* -$4(a5) */
    CokItem *it;                        /* -$12(a5) */
    CokItem *n;                         /* -$E(a5) */
    u16 count = 0;                      /* -$14(a5) */
    u8 k;                               /* -$5(a5) */
    s32 div;

    for (p = g_party_head; p != NULL; p = p->next) {
        it = p->items;
        /* ch+$199: side in combat (0 party, 1 opponents); ch+$197: status: 0 ok, 4
         * unconscious, 5 dying, 6-8 dead, $0A down */
        if (p->b[0x199] != 1 || p->b[0x197] == 0 || p->b[0x197] == 3) {
            continue;
        }
        s_enemies = 1;
        /* turn+$15: 1 = combatant beyond the party members, leaves it at the end of the fight */
        if (TURN(p)->b[0x15] == 1) {
            for (k = 0; k <= 6; ++k) {
                /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel); ch+$F0: coins, 7 words step 2 (0..4
                 * coins, 4 steel, 5 gems, 6 jewellery); $2A20: low word of the pool long for coin
                 * type 0 */
                SET_POOL(k, POOL(k) + CH_W(p, 0xF0 + k * 2));
            }
        }
        /* ch+$13C: experience given by the defeated monster (word); ch+$13E: experience of the monster
         * per hit point (multiplies +$123); ch+$123: maximum HP without constitution; base -1
         * of the spell slots +$124 */
        xp = xp + CH_W(p, 0x13C) + h015_mulu32(p->b[0x13E], p->b[0x123]);
        /* B+$5C6: (word) 1: the enemies' items do not go into the treasure */
        if (COK_GET16(g_state_b + 0x5C6) == 1) {
            continue;
        }
        for (; it != NULL; it = it->next) {
            ++count;
            n = (CokItem *)exec_alloc_mem(sizeof(CokItem), COK_MEMF_CLEAR);
            build_item_name(p, it, 0, 0, 0, 0);
            memcpy(n->b, it->b, 0x48);
            n->b[0x3A] = 0; /* item+$3A: item readied flag (Ready) */
            n->next = g_treasure_items;
            g_treasure_items = n;
        }
    }
    (void)count;
    /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
    xp += (u32)h015_divs32((s32)POOL(0), 0x64, NULL);
    /* $2A22: (long) pool, coins of type 1 (xp: amount / 20) */
    xp += (u32)h015_divs32((s32)POOL(1), 0x14, NULL);
    /* $2A26: (long) pool, coins of type 2 (xp: amount / 10) */
    xp += (u32)h015_divs32((s32)POOL(2), 0x0A, NULL);
    xp += POOL(3); /* $2A2A: (long) pool, coins of type 3 (xp: amount x 1) */
    xp += POOL(4) << 1; /* $2A2E: (long) pool, steel pieces (type 4; xp: amount x 2) */
    xp += h015_mulu32(POOL(5), 0xFA); /* $2A32: (long) pool, coins of type 5 (xp: amount x 250) */
    xp += h015_mulu32(POOL(6), 0x898); /* $2A36: (long) pool, coins of type 6 (xp: amount x 2200) */
    for (it = g_treasure_items; it != NULL && it != g_thrown_tail;
         it = it->next) {
        /* item+$36: (word) magic bonus (+n) of the item, signed */
        if ((s16)COK_GET16(it->b + 0x36) > 0) {
            /* item+$36: (word) magic bonus (+n) of the item, signed */
            xp += (u32)((s32)(s16)COK_GET16(it->b + 0x36) * 0x190);
        }
    }
    /* B+$67C: (word) number of party members (max 8); $2499: characters fallen at the end
     * of the combat (removed from the XP divisor) */
    div = (s32)COK_GET16(g_state_b + 0x67C) - (s32)H005_B(0x2499);
    *out = div != 0 ? (u32)h015_divs32((s32)xp, div, NULL) : xp;
}

/*
 * PORT H070+$0558: gives xp experience points to whoever is standing: 10%
 * more to those whose prime requisite of the class is above 15 (14
 * for the cleric's wisdom), half or a third to multi-class characters.
 */
static void award_experience(u32 xp)
{
    Character *p;                       /* -$4(a5) */
    u32 v;                              /* -$8(a5) */
    u8 bonus;

    if (COK_GET16(g_state_a + 0x3EA)) { /* A+$3EA: (word) outcome is a bank withdrawal: no experience */
        return;
    }
    for (p = g_party_head; p != NULL; p = p->next) {
        /* ch+$198: active/standing (0 down or out of the combat); ch+$197: status: 0 ok, 4
         * unconscious, 5 dying, 6-8 dead, $0A down */
        if (!p->b[0x198] || p->b[0x197] == 1) {
            continue;
        }
        v = xp;
        bonus = 0;
        switch (p->b[0x5C]) { /* ch+$5C: class or class combination (0..16, names H005+$4D84) */
        case 0: bonus = (u8)(p->b[0x15] > 0x0E); break; /* ch+$15: current wisdom */
        /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength */
        case 2: bonus = (u8)(p->b[0x11] > 0x0F); break;
        /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength; ch+$15:
         * current wisdom */
        case 3: bonus = (u8)(p->b[0x11] > 0x0F && p->b[0x15] > 0x0F); break;
        case 4:
            /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength; ch+$13:
             * current intelligence */
            bonus = (u8)(p->b[0x11] > 0x0F && p->b[0x13] > 0x0F &&
                         p->b[0x15] > 0x0F); /* ch+$15: current wisdom */
            break;
        case 5: bonus = (u8)(p->b[0x13] > 0x0F); break; /* ch+$13: current intelligence */
        case 6: bonus = (u8)(p->b[0x17] > 0x0F); break; /* ch+$17: current dexterity */
        case 8: case 0x0A: case 0x0B: case 0x0C: case 0x0D: case 0x0E:
        case 0x10:
            v = (u32)h015_divs32((s32)xp, 2, NULL);
            break;
        case 9: case 0x0F:
            v = (u32)h015_divs32((s32)xp, 3, NULL);
            break;
        default:
            break;
        }
        if (bonus) {
            v = (u32)h015_divs32((s32)xp, 0x0A, NULL) + xp;
        }
        CH_PUTL(p, 0x11E, CH_L(p, 0x11E) + v); /* ch+$11E: experience points (long) */
    }
}

/*
 * PORT H070+$0778: outcome of the combat: the party has lost ($24D0)
 * except whoever stayed (or comes back with $3E00+$5CC); fled ($-2(a4)) if
 * someone fled and nobody won; victory ($24C0) if someone is
 * still standing.  Removes the combat effects, gives
 * the experience, stands up whoever had fled or fainted and removes from the
 * party whoever is no longer there.  Where the original reads the next one of a
 * character already removed, here it reads it before.
 */
static void combat_outcome(void)
{
    static const u16 effects[11] = {
        3, 0x0B, 0x15, 0x17, 0x1B, 0x23, 0x28, 0x33, 0x34, 0x35, 0x1F
    };
    Character *p;                       /* -$1A(a5) */
    Character *n;
    u8 alive = 0;                       /* -$1F(a5) */
    u8 stop;                            /* -$1B(a5) */
    u16 k;                              /* -$1E(a5) */

    H005_B(0x2499) = 0; /* $2499: characters fallen at the end of the combat (removed from the XP divisor) */
    H005_B(0x24D0) = 1; /* $24D0: 1 party lost or gone out: stops ECL and the exploration loop */
    s_fled = 0;
    /* turn+$15: 1 = combatant beyond the party members, leaves it at the end of the fight */
    for (p = g_party_head; p != NULL && TURN(p)->b[0x15] != 1; p = p->next) {
        if (p->b[0x197] == 3) { /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
            s_fled = 1;
        }
    }
    for (p = g_party_head; p != NULL && !alive; p = p->next) {
        /* ch+$198: active/standing (0 down or out of the combat); ch+$197: status: 0 ok, 4
         * unconscious, 5 dying, 6-8 dead, $0A down */
        if (p->b[0x198] || p->b[0x197] == 4 || p->b[0x197] == 3 ||
            p->b[0x197] == 5) { /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
            alive = 1;
        }
    }
    /* B+$5CC: (word) non-fatal defeat: the fallen get up with 1 HP */
    if (COK_GET16(g_state_b + 0x5CC) && alive) {
        H005_B(0x24D0) = 0; /* $24D0: 1 party lost or gone out: stops ECL and the exploration loop */
    }
    H005_B(0x24C0) = 0; /* $24C0: 1 if the party won the last combat */
    if (H005_B(0x24D7)) { /* $24D7: 1 if the demonstration (Demo) was chosen */
        return;
    }
    /* turn+$15: 1 = combatant beyond the party members, leaves it at the end of the fight */
    for (p = g_party_head; p != NULL && TURN(p)->b[0x15] != 1; p = p->next) {
        /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
        if ((p->b[0x197] == 3 || p->b[0x197] == 1 || p->b[0x197] == 0) &&
            /* ch+$199: side in combat (0 party, 1 opponents); ch+$EC: control: <$80 PC, >$7F
             * NPC/AI ($B3 = charmed or confused) */
            p->b[0x199] == 0 && p->b[0xEC] < 0x80) {
            H005_B(0x24D0) = 0; /* $24D0: 1 party lost or gone out: stops ECL and the exploration loop */
        }
        /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
        if (p->b[0x197] == 1 || p->b[0x197] == 0) {
            H005_B(0x24C0) = 1; /* $24C0: 1 if the party won the last combat */
            s_fled = 0;
        }
        /* ch+$198: active/standing (0 down or out of the combat); ch+$197: status: 0 ok, 4
         * unconscious, 5 dying, 6-8 dead, $0A down */
        if (!p->b[0x198] || p->b[0x197] == 1) {
            /* $2499: characters fallen at the end of the combat (removed from the XP divisor) */
            add_to_byte(&H005_B(0x2499), 1);
        }
        for (k = 1; k <= 0x0B; ++k) {
            remove_effect(p, effects[k - 1], NULL);
        }
    }
    if (H005_B(0x24C0)) { /* $24C0: 1 if the party won the last combat */
        u32 xp = 0;

        compute_experience(&xp);
        H005_SET_L(0x236E, xp); /* $236E: experience gained in the combat (long) */
        award_experience(H005_L(0x236E)); /* $236E: experience gained in the combat (long) */
    }
    p = g_party_head;
    if (!H005_B(0x24D0)) { /* $24D0: 1 party lost or gone out: stops ECL and the exploration loop */
        /* turn+$15: 1 = combatant beyond the party members, leaves it at the end of the fight */
        while (p != NULL && TURN(p)->b[0x15] != 1) {
            if (!s_fled) {
                /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
                switch (p->b[0x197]) {
                case 3:
                    /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
                    p->b[0x197] = 0;
                    p->b[0x198] = 1; /* ch+$198: active/standing (0 down or out of the combat) */
                    break;
                case 4:
                    /* B+$5CC: (word) non-fatal defeat: the fallen get up with 1 HP */
                    if (COK_GET16(g_state_b + 0x5CC)) {
                        /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
                        p->b[0x197] = 0;
                        p->b[0x198] = 1; /* ch+$198: active/standing (0 down or out of the combat) */
                        p->b[0x1A8] = 1; /* ch+$1A8: current hit points */
                    } else {
                        /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
                        p->b[0x197] = 4;
                    }
                    break;
                case 5:
                    if (p->b[0x1A8] > 0) { /* ch+$1A8: current hit points */
                        /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
                        p->b[0x197] = 0;
                        p->b[0x198] = 1; /* ch+$198: active/standing (0 down or out of the combat) */
                    /* B+$5CC: (word) non-fatal defeat: the fallen get up with 1 HP */
                    } else if (COK_GET16(g_state_b + 0x5CC)) {
                        /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
                        p->b[0x197] = 0;
                        p->b[0x198] = 1; /* ch+$198: active/standing (0 down or out of the combat) */
                        p->b[0x1A8] = 1; /* ch+$1A8: current hit points */
                    }
                    break;
                default:
                    break;
                }
                p = p->next;
            } else {
                /* B+$58E: (word) fight outcome: 1 someone fled, $80 defeat, $81 party fled */
                COK_PUT16(g_state_b + 0x58E, 0x81);
                /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
                if (p->b[0x197] == 3) {
                    /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
                    p->b[0x197] = 0;
                    p->b[0x198] = 1; /* ch+$198: active/standing (0 down or out of the combat) */
                    p = p->next;
                } else {
                    g_current_char = p;
                    p = p->next;
                    remove_from_party(0, 1);
                }
            }
        }
    } else {
        stop = 0;
        while (p != NULL && !stop) {
            n = p->next;
            /* turn+$15: 1 = combatant beyond the party members, leaves it at the end of the fight */
            if (TURN(p)->b[0x15] != 1) {
                g_current_char = p;
                remove_from_party(0, 1);
            } else {
                stop = 1;
            }
            p = n;
        }
        COK_PUT16(g_state_b + 0x67C, 0); /* B+$67C: (word) number of party members (max 8) */
    }
}

/*
 * PORT H070+$0B9E: outcome screen: "The party has fled." (treasure and
 * pool lost), "You have lost the fight.", "The party has won.", or without
 * enemies "The party has found Treasure!" (or the bank withdrawal); then
 * the experience per character.
 */
static void show_outcome(u32 xp)
{
    char num[0x0C];                     /* -$C(a5) */
    char line[0x52];                    /* -$5E(a5) */
    u8 special;                         /* -$65(a5) */

    draw_screen_frame(1);
    if (s_enemies) {
        if (s_fled) {
            ui_draw_text(1, 3, 0x0A, 0, 0x13, "The party has fled.");
            xp = 0;
            free_treasure();
            /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
            h029_fill_bytes(0x1B, &H005_B(0x2A1E), 0x1C, 0);
        /* $24C0: 1 if the party won the last combat; B+$5CC: (word) non-fatal defeat: the
         * fallen get up with 1 HP */
        } else if (!H005_B(0x24C0) && COK_GET16(g_state_b + 0x5CC)) {
            /* B+$58E: (word) fight outcome: 1 someone fled, $80 defeat, $81 party fled */
            COK_PUT16(g_state_b + 0x58E, 0x80);
            ui_draw_text(1, 3, 0x0A, 0, 0x18, "You have lost the fight.");
            xp = 0;
        } else {
            ui_draw_text(1, 3, 0x0A, 0, 0x12, "The party has won.");
        }
    /* A+$3EA: (word) outcome is a bank withdrawal: no experience */
    } else if (COK_GET16(g_state_a + 0x3EA)) {
        ui_draw_text(1, 5, 0x0A, 0, 0x25,
                     "The party makes a withdrawl.  A small");
        ui_draw_text(1, 7, 0x0A, 0, 0x22,
                     "fee has been assessed by the bank.");
    } else {
        ui_draw_text(1, 3, 0x0A, 0, 0x1D, "The party has found Treasure!");
    }
    format_number(0x0A, num, (s32)xp, 0, 0x0A, 6, ' ');
    trim_leading_spaces(0x0A, num);
    strcpy(line, "Each character receives ");
    h026_append(0x50, line, 0x0A, num);
    if (!COK_GET16(g_state_a + 0x3EA)) { /* A+$3EA: (word) outcome is a bank withdrawal: no experience */
        ui_draw_text(1, 5, 0x0A, 0, 0x50, line);
        ui_draw_text(1, 7, 0x0A, 0, 0x12, "experience points.");
    }
    (void)ui_request_choice(2, "", 0x22, "press <enter>/<return> to continue",
                            0x0F, 0x0F, 0x0F, 1, 0, &special);
}

/*
 * In the original the item list is passed to the list menu
 * (a shape compatible with the entries); here a list of entries with the same
 * names, and the item in the same position as the chosen entry.
 */
static CokMenuItem *s_treasure_menu;

static CokMenuItem *treasure_as_menu(void)
{
    CokItem *it;
    CokMenuItem *tail = NULL;

    menu_free(&s_treasure_menu);
    for (it = g_treasure_items; it != NULL; it = it->next) {
        CokMenuItem *n = (CokMenuItem *)exec_alloc_mem(sizeof(CokMenuItem),
                                                       COK_MEMF_CLEAR);

        memcpy(n->text, it->b, 0x2A);
        n->header = it->b[0x2A]; /* ogg+$2A: header flag: copied into the header of the menu entry */
        if (tail == NULL) {
            s_treasure_menu = n;
        } else {
            tail->next = n;
        }
        tail = n;
    }
    return s_treasure_menu;
}

static CokItem *treasure_menu_item(CokMenuItem *node)
{
    CokMenuItem *m = s_treasure_menu;
    CokItem *it = g_treasure_items;

    while (m != NULL && it != NULL) {
        if (m == node) {
            return it;
        }
        m = m->next;
        it = it->next;
    }
    return NULL;
}

/*
 * PORT H070+$0DE0: list of the treasure items ("Items:", Take):
 * returns the key and the chosen item.
 */
static void treasure_list(u16 *index, CokMenuItem **cursor, CokItem **out,
                          u8 *key)
{
    CokItem *it;                        /* -$20(a5) */
    u8 redraw = 1;                      /* -$1B(a5) */

    draw_screen_frame(1);
    for (it = g_treasure_items; it != NULL; it = it->next) {
        build_item_name(NULL, it, 0, 0, 0, 0);
    }
    *cursor = NULL;
    *key = list_menu(7, "Items: ", 4, "Take", 0x0D, 0x0A, 0x0F, 1, 1, 0x26,
                     0x16, treasure_as_menu(), 1, &redraw, index, cursor);
    *out = treasure_menu_item(*cursor);
}

/*
 * PORT H070+$0E94 (Take Items): the current character takes items
 * from the treasure (H071+$047C) until it leaves or the treasure is empty.  Index and
 * choice are cleared only once, before the loop (H070+$0E9E/$0EAA):
 * after a Take the selection stays on the same row.
 */
static void take_items(void)
{
    CokItem *chosen;                    /* -$4(a5) */
    CokItem *p;                         /* -$8(a5) */
    CokMenuItem *cursor;                /* -$E(a5) */
    u16 index;                          /* -$10(a5) */
    u8 key;                             /* -$9(a5) */
    u8 done;                            /* -$A(a5) */
    u8 fail;                            /* -$11(a5) */

    chosen = NULL;
    cursor = NULL;
    index = 0;
    do {
        treasure_list(&index, &cursor, &chosen, &key);
        if ((key != 'T' && key != 0x0D) || chosen == NULL) {
            done = 1;
            continue;
        }
        done = 0;
        take_item(chosen, &fail);
        if (fail) {
            continue;
        }
        if (g_treasure_items == chosen) {
            g_treasure_items = chosen->next;
        } else {
            for (p = g_treasure_items; p->next != chosen; p = p->next) {
            }
            p->next = chosen->next;
        }
        chosen->next = NULL;
        exec_free_mem(chosen, sizeof(CokItem));
        if (g_treasure_items == NULL) {
            done = 1;
        }
    } while (!done);
    menu_free(&s_treasure_menu);
    redraw_game_screen();
}

/*
 * PORT H070+$0F8A (Take): with coins and items the menu "Money Items
 * Exit" (H and P change character) while everything remains; coins only
 * H067+$0F72, items only H070+$0E94.
 */
static void take_menu(u8 *money, u8 *items)
{
    u8 done = 0;                        /* -$2(a5) */
    u8 special;                         /* -$3(a5) */
    u8 key;                             /* -$1(a5) */

    if (!*money) {
        take_items();
        return;
    }
    if (!*items) {
        take_money_menu();
        redraw_game_screen();
        return;
    }
    do {
        key = ui_request_choice(6, "Take: ", 0x10, "Money Items Exit", 0x0D,
                                0x0A, 0x0F, 1, 1, &special);
        switch (key) {
        case 'M':
            take_money_menu();
            redraw_game_screen();
            break;
        case 'I':
            take_items();
            break;
        case 0:
        case 'E':
            done = 1;
            break;
        case 'H':
        case 'P':
            select_party_member(key);
            break;
        default:
            break;
        }
        draw_party(g_current_char);
        has_treasure(money, items);
        if (!*money || !*items) {
            done = 1;
        }
    } while (!done);
}

/*
 * PORT H070+$1136: treasure screen: View, Take, Pool, Share, Detect
 * (if the current one has memorised a detection spell: 5, $B,
 * $4D, $67) and Exit, which asks for confirmation when treasure is left.
 */
static void treasure_screen(void)
{
    char menu[0x52];                    /* -$56(a5) */
    char extra[0x10];                   /* -$76(a5) */
    u8 money = 0;                       /* -$1(a5) */
    u8 items = 0;                       /* -$2(a5) */
    u8 done = 0;                        /* -$58(a5) */
    u8 special;                         /* -$59(a5) */
    u8 key;                             /* -$57(a5) */
    u8 detect;                          /* -$65(a5) */
    u8 saved;                           /* -$77(a5) */
    u16 k;                              /* -$62(a5) */
    u16 spell = 0;                      /* -$64(a5) */
    u8 s;

    redraw_game_screen();
    do {
        money = 0;
        has_treasure(&money, &items);
        strcpy(menu, "View Pool Exit");
        strcpy(extra, " Exit");
        detect = 0;
        if (items) {
            for (k = 0; k <= 0x39 && !detect; ++k) {
                /* ch+$1E: memorised spells, $3A bytes (+$1E..+$57); bit 7 = to be memorised */
                s = g_current_char->b[0x1E + k];
                if ((s == 5 || s == 0x0B || s == 0x4D || s == 0x67) &&
                    /* ch+$198: active/standing (0 down or out of the combat) */
                    g_current_char->b[0x198]) {
                    detect = 1;
                    spell = s;
                }
            }
        }
        if (detect) {
            strcpy(extra, " Detect Exit");
        }
        if (money) {
            strcpy(menu, "View Take Pool Share");
            h026_append(0x50, menu, 0x0F, extra);
        } else if (items) {
            strcpy(menu, "View Take Pool");
            h026_append(0x50, menu, 0x0F, extra);
        }
        key = ui_request_choice(2, "", 0x50, menu, 0x0D, 0x0A, 0x0F, 1, 1,
                                &special);
        if (special) {
            select_party_member(key);
            draw_party(g_current_char);
            continue;
        }
        saved = H005_B(0x2483); /* $2483: index of the selected option in the row menus (persistent) */
        switch (key) {
        case 'V':
            view_character(&special);
            break;
        case 'T':
            take_menu(&money, &items);
            break;
        case 'P':
            if (!special) {
                pool_party_money();
            }
            break;
        case 'S':
            share_money();
            break;
        case 'D':
            cast_spell(spell, 0, 0, &special);
            break;
        case 0:
        case 'E':
            has_treasure(&money, &items);
            if (money || items) {
                word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 1, 0x1F,
                               "There is still treasure left.  ");
                word_wrap_text(1, 0x11, 0x26, 0x16, 0x0F, 0, 0, 0x2F,
                               "Do you want to go back and claim your treasure?");
                strcpy(menu, "~Yes ~No");
                if (ecl_menu(2, "", 0x50, menu, 0x0D, 0x0A, 0x0F, 0, 0) == 1) {
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
        H005_B(0x2483) = saved; /* $2483: index of the selected option in the row menus (persistent) */
    } while (!done);
}

/*
 * PORT H070+$152E: at the end of the combat removes the enemies from the party (+$15
 * of the turn or side 1), counting the fallen ($3E00+$590) and the fled
 * ($3E00+$58E), and frees the turn blocks of the others.
 */
static void remove_combatants(void)
{
    u8 first = 1;                       /* -$9(a5) */
    Character *p;                       /* -$4(a5) */
    Character *n;                       /* -$8(a5) */

    COK_PUT16(g_state_b + 0x590, 0); /* B+$590: (word) fallen enemies counted at the end of the combat */
    p = g_party_head;
    while (p != NULL) {
        /* turn+$15: 1 = combatant beyond the party members, leaves it at the end of the fight;
         * ch+$199: side in combat (0 party, 1 opponents) */
        if (TURN(p)->b[0x15] == 1 || p->b[0x199] == 1) {
            s_enemies = 1;
            if (p->b[0x198] != 1) { /* ch+$198: active/standing (0 down or out of the combat) */
                COK_PUT16(g_state_b + 0x590, /* B+$590: (word) fallen enemies counted at the end of the combat */
                          COK_GET16(g_state_b + 0x590) + 1);
                if (first) {
                    /* A+$3F0: tab. of cycle phase words (idx CH+$5F, 1..3); entry 0 set to 1 by H070 */
                    COK_PUT16(g_state_a + 0x3F0, 1);
                }
            }
            /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down; B+$58E: (word)
             * fight outcome: 1 someone fled, $80 defeat, $81 party fled */
            if (p->b[0x197] == 3 && COK_GET16(g_state_b + 0x58E) == 0) {
                /* B+$58E: (word) fight outcome: 1 someone fled, $80 defeat, $81 party fled */
                COK_PUT16(g_state_b + 0x58E, 1);
            }
            first = 0;
            n = p->next;
            g_current_char = p;
            /* turn+$15: 1 = combatant beyond the party members, leaves it at the end of the fight */
            remove_from_party((u8)(TURN(p)->b[0x15] == 1), 1);
            p = n;
        } else {
            if (p->block_192 != NULL) {
                exec_free_mem(p->block_192, sizeof(CokTurn));
                p->block_192 = NULL;
            }
            p = p->next;
        }
    }
    g_current_char = g_party_head;
}

/*
 * PORT H070+$165C: the non-player characters (+$EC > $7F, standing) with
 * a share (+$ED & 7) take their part of every coin type
 * ("takes and hides his/her share").
 */
static void npc_shares(void)
{
    char text[0x52];                    /* -$6E(a5) */
    Character *p;                       /* -$4(a5) */
    u16 shares = 0;                     /* -$6(a5) */
    u16 total = 0;                      /* -$8(a5) */
    u16 per;                            /* -$A(a5) */
    u16 row;                            /* -$C(a5) */
    u8 hidden = 0;                      /* -$19(a5) */
    u8 special;                         /* -$1A(a5) */
    u8 k;                               /* -$D(a5) */

    for (p = g_party_head; p != NULL; p = p->next) {
        /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused); ch+$197: status: 0 ok,
         * 4 unconscious, 5 dying, 6-8 dead, $0A down */
        if (p->b[0xEC] > 0x7F && p->b[0x197] == 0) {
            /* ch+$ED: share of the NPC in the division (bits 0-2); 1 after Modify */
            shares = (u16)(shares + mask_byte(p->b[0xED], 7));
            /* ch+$ED: share of the NPC in the division (bits 0-2); 1 after Modify */
            total = (u16)(total + mask_byte(p->b[0xED], 7));
        } else {
            ++total;
        }
    }
    if (shares > 0) {
        for (k = 0; k <= 6; ++k) {
            if ((s32)POOL(k) > 0) { /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
                /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
                per = (u16)h015_divs32((s32)POOL(k), (s32)total, NULL);
                /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel); $2A20: low word of
                 * the pool long for coin type 0 */
                SET_POOL(k, POOL(k) - (u32)shares * per);
                hidden = 1;
            }
        }
    }
    if (!hidden) {
        return;
    }
    draw_screen_frame(1);
    row = 0;
    for (p = g_party_head; p != NULL; p = p->next) {
        /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused); ch+$197: status: 0 ok, 4
         * unconscious, 5 dying, 6-8 dead, $0A down; ch+$ED: share of the NPC in the division
         * (bits 0-2); 1 after Modify */
        if (p->b[0xEC] > 0x7F && p->b[0x197] == 0 && p->b[0xED] > 0) {
            h026_copy(0x50, text, 0x0F, (const char *)p->b);
            if (!p->b[0x10E]) { /* ch+$10E: sex (0 male, 1 female; names H005+$4BD2) */
                h026_append(0x50, text, 0x1B, " takes and hides his share.");
            } else {
                h026_append(0x50, text, 0x1B, " takes and hides her share.");
            }
            word_wrap_text(5, (u16)(row + 5), 0x22, 0x16, 0x0A, 0, 1, 0x50,
                           text);
            row = (u16)(row + 2);
        }
    }
    (void)ui_request_choice(0, "", 0x22, "press <enter>/<return> to continue",
                            0x0F, 0x0F, 0x0F, 1, 0, &special);
}

/*
 * PORT H070+$18BE: the items dropped in combat ($3360)
 * go back to whoever had them (H071+$047C).
 */
static void return_dropped_items(void)
{
    CokDropped *d;                      /* -$C(a5) */
    CokDropped *n;                      /* -$10(a5) */
    CokItem *copy;                      /* -$4(a5) */
    u8 fail;                            /* -$11(a5) */

    d = g_dropped_items;
    while (d != NULL) {
        copy = (CokItem *)exec_alloc_mem(sizeof(CokItem), COK_MEMF_CLEAR);
        g_current_char = d->owner;
        memcpy(copy->b, d->b, 0x48);
        copy->next = NULL;
        take_item(copy, &fail);
        exec_free_mem(copy, sizeof(CokItem));
        n = d;
        d = d->next;
        exec_free_mem(n, sizeof(CokDropped));
    }
    g_dropped_items = NULL;
}

/*
 * PORT H070+$1958: end of the combat: dropped items, outcome, enemies
 * removed, values recomputed; if the party is still there NPC shares,
 * outcome, treasure and pool; otherwise "The monsters rejoice for the party
 * has been destroyed.".  In the demonstration ($24D7) it exits at once.
 */
void combat_end(void)
{
    Character *p;                       /* -$C(a5) */

    return_dropped_items();
    /* B+$58E: (word) fight outcome: 1 someone fled, $80 defeat, $81 party fled */
    COK_PUT16(g_state_b + 0x58E, 0);
    s_enemies = 0;
    if (!H005_B(0x24D7)) { /* $24D7: 1 if the demonstration (Demo) was chosen */
        combat_outcome();
    }
    H005_B(0x3DE3) = 6; /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    remove_combatants();
    if (H005_B(0x24D7)) { /* $24D7: 1 if the demonstration (Demo) was chosen */
        return;
    }
    for (p = g_party_head; p != NULL; p = p->next) {
        recompute_stats(p);
    }
    /* $24D0: 1 party lost or gone out: stops ECL and the exploration loop; $24C1: use: cleared
     * at start-up; with 1 outcome and fallen handled differently */
    if (!H005_B(0x24D0) || H005_B(0x24C1)) {
        if (s_fled) {
            free_treasure();
        }
        if (!H005_B(0x24D7)) { /* $24D7: 1 if the demonstration (Demo) was chosen */
            npc_shares();
            show_outcome(H005_L(0x236E)); /* $236E: experience gained in the combat (long) */
            treasure_screen();
        }
        free_treasure();
    } else {
        /* B+$58E: (word) fight outcome: 1 someone fled, $80 defeat, $81 party fled */
        COK_PUT16(g_state_b + 0x58E, 0x80);
        draw_screen_frame(1);
        H005_SET_W(0x334E, 2); /* $334E: (word) text cursor: column */
        H005_SET_W(0x334C, 6); /* $334C: (word) text cursor: row */
        word_wrap_text(2, 5, 0x25, 0x16, 0x0A, 0, 1, 0x36,
                       "The monsters rejoice for the party has been destroyed.");
        show_message_wait(0x0D, 0, 0x19, "Press any key to continue");
    }
    H005_B(0x24CE) = 1; /* $24CE: 1: per-character pause when writing text */
    COK_PUT16(g_state_b + 0x6E0, 0); /* B+$6E0: (word) to-hit bonus of the enemies (side 1) */
    COK_PUT16(g_state_b + 0x6E2, 0); /* B+$6E2: (word) to-hit bonus of the party (side 0) */
    COK_PUT16(g_state_b + 0x6E4, 0); /* B+$6E4: (word) movement bonus of the party in combat */
    COK_PUT16(g_state_b + 0x5C6, 0); /* B+$5C6: (word) 1: the enemies' items do not go into the treasure */
    COK_PUT16(g_state_b + 0x5CC, 0); /* B+$5CC: (word) non-fatal defeat: the fallen get up with 1 HP */
    COK_PUT16(g_state_a + 0x3EA, 0); /* A+$3EA: (word) outcome is a bank withdrawal: no experience */
}
