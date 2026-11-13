/* H067: Coins, gems, jewellery and sharing of money. */
#include <string.h>

#include "h067.h"
#include "globals.h"
#include "h010_input.h"
#include "h026_string.h"
#include "h030.h"
#include "h045.h"
#include "h063.h"
#include "h008.h"
#include "h029_gfx.h"
#include "h044_tiles.h"
#include "h003_exec.h"
#include "h015_runtime.h"
#include "h062.h"
#include "h023_shared.h"
#include "h065.h"

/* PORT H067+$01BA: link/unlk, no effect. */
void h067_init(void)
{
}

/* PORT H067+$01C8: maximum load: $5DC plus the strength bonus. */
u16 max_carry(Character *c)
{
    return (u16)(str_weight_allowance(c) + 0x5DC);
}

/* PORT H067+$01F2: removes amount from the weight carried (+$18C). */
static void sub_weight(Character *c, u16 amount)
{
    /* ch+$18C: encumbrance: weight of items and coins (word) */
    CH_PUTW(c, 0x18C, (u16)(CH_W(c, 0x18C) - amount));
}

/* PORT H067+$0212: adds amount to the weight carried (+$18C). */
static void add_weight(Character *c, u16 amount)
{
    /* ch+$18C: encumbrance: weight of items and coins (word) */
    CH_PUTW(c, 0x18C, (u16)(CH_W(c, 0x18C) + amount));
}

/*
 * PORT H067+$044E: asks for a number from 0 to max on row $18 after the
 * text prompt (pen pen): digits, Backspace, Enter; Esc gives 0.  A digit
 * that goes beyond max replaces the number with max.
 */
u16 input_amount(u16 max, u16 len, const char *prompt, u16 pen)
{
    char tmp[2];                        /* -$22(a5) */
    char input[8];                      /* -$14(a5) */
    char top[6];                        /* -$c(a5) */
    s32 value;                          /* -$1a(a5) */
    s32 result;                         /* -$20(a5) */
    u16 start;                          /* -$6(a5) */
    u16 cur;                            /* -$2(a5) */
    u8 key;                             /* -$15(a5) */
    u8 ok;                              /* -$1b(a5) */

    fill_text_cells(0, 0x18, 0, 0x28);
    ui_draw_text(0, 0x18, pen, 0, len, prompt);
    start = h026_strlen(len, prompt);
    cur = start;
    format_number(5, top, max, 0, 0x0A, 4, ' ');
    trim_leading_spaces(5, top);
    input[0] = 0;
    do {
        wait_for_key();
        key = G_KEY; /* $5305: key/action pending from the input (G_KEY) */
        if (key >= '0' && key <= '9') {
            tmp[0] = (char)key;
            tmp[1] = 0;
            h026_append(6, input, 1, tmp);
            ok = parse_number(6, input, &value, 0, 0x0A);
            if ((u16)value > max) {
                h026_copy(6, input, 5, top);
                cur = (u16)(h026_strlen(5, top) + start);
            } else {
                ++cur;
            }
            ui_draw_text(start, 0x18, 0x0F, 0, 6, input);
        } else if (key == 0x08) {
            if (h026_strlen(6, input) > 0) {
                input[h026_strlen(6, input) - 1] = 0;
                --cur;
                fill_text_cells(cur, 0x18, 0, 1);
            }
        }
    } while (key != '\r' && key != 0x1B);
    fill_text_cells(0, 0x18, 0, 0x28);
    if (key == 0x1B) {
        result = 0;
    } else if (input[0] != 0) {
        ok = parse_number(6, input, &result, 0, 0x0A);
    } else {
        result = 0;
    }
    (void)ok;
    return (u16)result;
}

/*
 * PORT H067+$06F8: moves amount coins of type coin from *from to *to if
 * *to can carry them, otherwise "Overloaded".
 */
void transfer_money(u8 coin, u16 amount, Character **to, Character **from)
{
    /* ch+$18C: encumbrance: weight of items and coins (word) */
    if ((u16)(CH_W(*to, 0x18C) + amount) > max_carry(*to)) {
        show_message_line(0x0A, "Overloaded");
        return;
    }
    /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
    CH_PUTW(*from, 0xF0 + coin * 2, (u16)(CH_W(*from, 0xF0 + coin * 2) -
                                          amount));
    sub_weight(*from, amount);
    /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
    CH_PUTW(*to, 0xF0 + coin * 2, (u16)(CH_W(*to, 0xF0 + coin * 2) + amount));
    add_weight(*to, amount);
}

/*
 * PORT H067+$0C8C: c drops amount coins of type coin; in the camp or in a
 * shop ($3DE3 = 6 or 1) they end up in the pool H005+$2A1E.
 */
void drop_money(u8 coin, u16 amount, Character *c)
{
    /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
    CH_PUTW(c, 0xF0 + coin * 2, (u16)(CH_W(c, 0xF0 + coin * 2) - amount));
    sub_weight(c, amount);
    /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    if (H005_B(0x3DE3) == 6 || H005_B(0x3DE3) == 1) {
        H005_SET_L(0x2A1E + coin * 4, /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
                   (u16)(H005_L(0x2A1E + coin * 4) + amount));
    }
}

/*
 * PORT H067+$0DCA: coin type from the name at the start of text (after the
 * spaces) and the name in out: 0 silver, 1 Copper, 2 bronze, 3 platinum,
 * 4 steel, 5 Gems, 6 Jewelry.  For an unknown initial the original
 * returns the uninitialised byte of the frame; here 0.
 */
u8 coin_type(u16 len, const char *text, u16 out_max, char *out)
{
    u16 pos = 0;                        /* -$2(a5) */
    u8 type = 0;                        /* -$3(a5) */
    u8 next;

    (void)len;
    while (text[pos] == ' ') {
        ++pos;
    }
    switch ((u8)text[pos]) {
    case 'G':
        type = 5;
        h026_copy(out_max, out, 5, "Gems ");
        break;
    case 'P':
        h026_copy(out_max, out, 9, "platinum ");
        type = 3;
        break;
    case 'B':
        h026_copy(out_max, out, 7, "bronze ");
        type = 2;
        break;
    case 'S':
        next = (u8)text[pos + 1];
        if (next >= 'a' && next <= 'z') {
            next &= 0x5F;
        }
        if (next == 'I') {
            h026_copy(out_max, out, 7, "silver ");
            type = 0;
        } else {
            h026_copy(out_max, out, 6, "steel ");
            type = 4;
        }
        break;
    case 'C':
        h026_copy(out_max, out, 7, "Copper ");
        type = 1;
        break;
    case 'J':
        h026_copy(out_max, out, 8, "Jewelry ");
        type = 6;
        break;
    default:
        break;
    }
    return type;
}

/*
 * PORT H067+$0232: would amount overload c?  In *room how much still
 * fits (0 if nothing or if there is no overload).
 */
u8 would_overload(Character *c, u16 amount, u16 *room)
{
    u16 limit = max_carry(c);           /* -$4(a5) */
    u8 over;                            /* -$1(a5) */

    if ((u16)(CH_W(c, 0x18C) + amount) > limit) { /* ch+$18C: encumbrance: weight of items and coins (word) */
        over = 1;
        if (CH_W(c, 0x18C) > limit) { /* ch+$18C: encumbrance: weight of items and coins (word) */
            *room = 0;
        } else {
            *room = (u16)(limit - CH_W(c, 0x18C)); /* ch+$18C: encumbrance: weight of items and coins (word) */
        }
    } else {
        over = 0;
        *room = 0;
    }
    return over;
}

/*
 * PORT H067+$02AE: value in steel of the pool ($2A1E, 5 coin
 * types): sum of the values H005+$0.. divided by H005+$10.
 */
u32 pool_value(void)
{
    u32 sum = 0;                        /* -$4(a5) */
    u8 k;                               /* -$9(a5) */

    for (k = 0; k <= 4; ++k) {
        /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
        sum += h015_mulu32(H005_L(k * 4), H005_L(0x2A1E + k * 4));
    }
    /* $10: value of coin 5 (long, 50): divisor for the wealth in steel */
    return (u32)h015_divs32((s32)sum, (s32)H005_L(0x10), NULL);
}

/* PORT H067+$032A: clears the coins 0..4 and leaves steel pieces of steel. */
void set_steel_only(u16 steel)
{
    u8 k;

    for (k = 0; k <= 4; ++k) {
        /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
        CH_PUTW(g_current_char, 0xF0 + k * 2, 0);
    }
    CH_PUTW(g_current_char, 0xF8, steel); /* ch+$F8: steel pieces (coin type 4) (word) */
}

/* PORT H067+$0374: clears the pool (types 0..4) and puts steel into it. */
void set_pool_steel(u16 steel)
{
    u8 k;

    for (k = 0; k <= 4; ++k) {
        /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
        H005_SET_L(0x2A1E + k * 4, 0);
    }
    H005_SET_L(0x2A2E, steel); /* $2A2E: (long) pool, steel pieces (type 4; xp: amount x 2) */
}

/*
 * PORT H067+$03BC: the current character receives amount steel pieces;
 * if they overload it, it takes what fits and the rest goes into the pool.
 */
static void receive_steel(u16 amount)
{
    u16 room;                           /* -$2(a5) */

    if (would_overload(g_current_char, amount, &room)) {
        show_message_line(0x27, "Overloaded.  Money will be put in Pool.");
        /* ch+$F8: steel pieces (coin type 4) (word) */
        CH_PUTW(g_current_char, 0xF8, (u16)(CH_W(g_current_char, 0xF8) + room));
        add_weight(g_current_char, room);
        /* $2A2E: (long) pool, steel pieces (type 4; xp: amount x 2) */
        H005_SET_L(0x2A2E, H005_L(0x2A2E) + amount - room);
    } else {
        CH_PUTW(g_current_char, 0xF8, /* ch+$F8: steel pieces (coin type 4) (word) */
                (u16)(CH_W(g_current_char, 0xF8) + amount));
        add_weight(g_current_char, amount);
    }
}

/* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
#define POOL(k)         H005_L(0x2A1E + (k) * 4)
/* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
#define SET_POOL(k, v)  H005_SET_L(0x2A1E + (k) * 4, (v))
#define COINS(c, k)     CH_W((c), 0xF0 + (k) * 2)
#define SET_COINS(c, k, v) CH_PUTW((c), 0xF0 + (k) * 2, (v))

/* The party controlled by the player: +$EC zero or $B3. */
static u8 is_player(Character *p)
{
    /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
    return (u8)(p->b[0xEC] == 0 || p->b[0xEC] == 0xB3);
}

/*
 * PORT H067+$0794 (Pool): the player characters put all their
 * coins into the pool ($2A1E) and their weight drops.
 */
void pool_party_money(void)
{
    Character *p;                       /* -$4(a5) */
    u8 k;                               /* -$7(a5) */

    H005_B(0x24E3) = 1; /* $24E3: use: 1 if the shared pool has coins (Pool/Share/Take), never read */
    for (p = g_party_head; p != NULL; p = p->next) {
        if (!is_player(p)) {
            continue;
        }
        for (k = 0; k <= 6; ++k) {
            /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel); ch+$F0: coins, 7 words step 2
             * (0..4 coins, 4 steel, 5 gems, 6 jewellery); $2A20: low word of the pool long for
             * coin type 0 */
            SET_POOL(k, POOL(k) + COINS(p, k));
            /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
            sub_weight(p, COINS(p, k));
        }
        /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
        h029_fill_bytes(0x0D, &p->b[0xF0], 0x0E, 0);
    }
}

/* PORT H067+$086E: how many player characters. */
static u16 count_players(void)
{
    Character *p;                       /* -$4(a5) */
    u16 n = 0;                          /* -$6(a5) */

    for (p = g_party_head; p != NULL; p = p->next) {
        if (is_player(p)) {
            ++n;
        }
    }
    return n;
}

/*
 * PORT H067+$08CC (Share): divides the pool among the player
 * characters (from the low word of each type, the remainder one by one), within the
 * limits of the load; what does not fit goes to whoever has room.  The
 * leftover stays in the pool.  Without characters the original divides by 0:
 * here no division.
 */
void share_money(void)
{
    Character *p;                       /* -$4(a5) */
    u16 n;                              /* -$A(a5) */
    u16 share[7];                       /* -$1C(a5) */
    u16 rest[7];                        /* -$2A(a5) */
    u16 room;                           /* -$E(a5) */
    s16 k;                              /* -$2B(a5) */

    n = count_players();
    memset(share, 0, sizeof share);
    memset(rest, 0, sizeof rest);
    for (k = 0; k <= 6; ++k) {
        /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
        if ((u16)POOL(k) > 0 && n > 0) {
            /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
            share[k] = (u16)((u16)POOL(k) / n);
            /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
            rest[k] = (u16)((u16)POOL(k) % n);
        } else {
            share[k] = 0;
            rest[k] = 0;
        }
    }
    for (p = g_party_head; p != NULL; p = p->next) {
        if (p->b[0xEC] >= 0x80) { /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
            continue;
        }
        for (k = 6; k >= 0; --k) {
            if (!would_overload(p, share[k], &room)) {
                /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
                SET_COINS(p, k, (u16)(COINS(p, k) + share[k]));
                add_weight(p, share[k]);
                if (rest[k] > 0 && !would_overload(p, 1, &room)) {
                    /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
                    SET_COINS(p, k, (u16)(COINS(p, k) + 1));
                    add_weight(p, 1);
                    --rest[k];
                }
            } else {
                /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
                SET_COINS(p, k, (u16)(COINS(p, k) + room));
                rest[k] = (u16)(rest[k] + share[k] - room);
                add_weight(p, room);
            }
        }
    }
    for (k = 6; k >= 0; --k) {
        if (rest[k] == 0) {
            continue;
        }
        for (p = g_party_head; p != NULL; p = p->next) {
            /* ch+$18C: encumbrance: weight of items and coins (word) */
            room = (u16)(max_carry(p) - CH_W(p, 0x18C));
            if (room == 0) {
                continue;
            }
            if (room < rest[k]) {
                /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
                SET_COINS(p, k, (u16)(COINS(p, k) + room));
                add_weight(p, room);
                rest[k] = (u16)(rest[k] - room);
            } else {
                /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
                SET_COINS(p, k, (u16)(COINS(p, k) + rest[k]));
                add_weight(p, rest[k]);
                rest[k] = 0;
            }
        }
    }
    H005_B(0x24E3) = 0; /* $24E3: use: 1 if the shared pool has coins (Pool/Share/Take), never read */
    for (k = 0; k <= 6; ++k) {
        /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel); $2A20: low word of the pool
         * long for coin type 0 */
        SET_POOL(k, rest[k]);
        if ((u16)POOL(k) != 0) { /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
            H005_B(0x24E3) = 1; /* $24E3: use: 1 if the shared pool has coins (Pool/Share/Take), never read */
        }
    }
}

/*
 * PORT H067+$0D0A: c takes amount coins of type coin from the pool
 * (no more than there are, in the low word), if they do not
 * overload it ("Overloaded").
 */
static void take_pool_money(Character *c, u16 amount, u8 coin)
{
    u16 room;                           /* -$2(a5) */

    if (would_overload(c, amount, &room)) {
        show_message_line(0x0A, "Overloaded");
        return;
    }
    if (amount > (u16)POOL(coin)) { /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
        amount = (u16)POOL(coin); /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
    }
    /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel); $2A20: low word of the pool
     * long for coin type 0 */
    SET_POOL(coin, POOL(coin) - amount);
    /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
    SET_COINS(c, coin, (u16)(COINS(c, coin) + amount));
    add_weight(c, amount);
}

/*
 * PORT H067+$0F72 (Take Money): list of the coin types in the pool
 * (name from the table $4B7E and quantity), asks how many to take for the
 * current character, while money remains or until exit.  The original
 * frees the list only after a choice; here also on exit.
 */
void take_money_menu(void)
{
    CokMenuItem *list;                  /* -$A(a5) */
    CokMenuItem *head;                  /* -$12(a5) */
    CokMenuItem *chosen;                /* -$E(a5) */
    CokMenuItem *old;
    char text[0x52];                    /* -$68(a5) */
    u16 index = 0;                      /* -$16(a5) */
    u16 amount;                         /* -$6A(a5) */
    u8 redraw = 1;                      /* -$6C(a5) */
    u8 key;                             /* -$6D(a5) */
    u8 done;                            /* -$6B(a5) */
    u8 coin;                            /* -$2(a5) */
    u8 k;                               /* -$1(a5) */

    draw_screen_frame(0);
    index = 0;
    do {
        redraw = 1;
        list = NULL;
        for (k = 0; k <= 6; ++k) {
            if ((u16)POOL(k) == 0) { /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
                continue;
            }
            old = list;
            list = (CokMenuItem *)exec_alloc_mem(sizeof(CokMenuItem),
                                                 COK_MEMF_CLEAR);
            list->next = old;
            /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
            format_number(0x50, text, (s32)POOL(k), 0, 0x0A, 5, ' ');
            h026_copy(0x28, list->text, 0x0A,
                      /* $4B7E: names of the coin types, $0C bytes per type */
                      (const char *)&g_h005[0x4B7E + k * 0x0C]);
            h026_append(0x28, list->text, 1, " ");
            h026_append(0x28, list->text, 0x50, text);
            list->header = 0;
        }
        chosen = list;
        head = list;
        H005_B(0x2483) = 1; /* $2483: index of the selected option in the row menus (persistent) */
        key = list_menu(0x14, "Select type of coin ", 6, "Select", 0x0D,
                        0x0A, 0x0F, 2, 2, 0x0F, 8, list, 1, &redraw, &index,
                        &chosen);
        if (chosen == NULL || key == 0) {
            done = 1;
        } else {
            coin = coin_type(0x28, chosen->text, 0x50, text);
            h026_insert(0x50, text, 9, "How much ", 0);
            h026_append(0x50, text, 0x10, " will you take? ");
            /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
            amount = input_amount((u16)POOL(coin), 0x50, text, 0x0A);
            take_pool_money(g_current_char, amount, coin);
            menu_free(&head);
            head = NULL;
            H005_B(0x24E3) = 0; /* $24E3: use: 1 if the shared pool has coins (Pool/Share/Take), never read */
            done = 1;
            for (k = 0; k <= 6; ++k) {
                /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
                if ((u16)POOL(k) > 0) {
                    /* $24E3: use: 1 if the shared pool has coins (Pool/Share/Take), never read */
                    H005_B(0x24E3) = 1;
                    done = 0;
                }
            }
        }
        if (head != NULL) {
            menu_free(&head);
        }
    } while (!done);
}

/*
 * PORT H067+$11F4: are there coins (low words) / items
 * ($2A3A) in the pool?
 */
void has_treasure(u8 *money, u8 *items)
{
    u8 k;                               /* -$1(a5) */

    *money = 0;
    *items = 0;
    for (k = 0; k <= 6; ++k) {
        if ((u16)POOL(k) != 0) { /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
            *money = 1;
        }
    }
    if (g_treasure_items != NULL) {
        *items = 1;
    }
}

/* PORT H067+$125A: magic bonus of a random item, +1 (90%) or +2. */
static u16 random_bonus(void)
{
    if (roll_dice(1, 0x0A) < 0x0A) {
        return 1;
    }
    return 2;
}

/* Reading/writing of the item words (+$36 bonus, +$3E weight, ...). */
#define IT_W(it, o)         COK_GET16(&(it)->b[(o)])
#define IT_SET_W(it, o, v)  COK_PUT16(&(it)->b[(o)], (u16)(v))

/*
 * Templates of the special items (-$7C(a5), 7 records of 8 words): name
 * (3 bytes +$32..+$34), weight (+$3E), value (+$42), properties (+$44..+$46).
 * They are chosen with the number of the initial word + 1 (1, 9, $11, ...).
 */
static const u16 s_special_items[56] = {
    0x5F, 0x5E, 0x35, 0x0001, 0x0190, 0x03, 0x63, 0x00,
    0x50, 0x5A, 0x35, 0x0001, 0x0226, 0x01, 0x3B, 0x00,
    0x5F, 0x5A, 0x35, 0x0001, 0x00C8, 0x01, 0x03, 0x00,
    0x5C, 0x5A, 0x35, 0x0001, 0x00E1, 0x01, 0x30, 0x00,
    0x62, 0x5A, 0x33, 0x0001, 0x157C, 0x1E, 0x41, 0x00,
    0x4E, 0x5A, 0x48, 0x000A, 0x1D4C, 0x00, 0x26, 0x83,
    0x58, 0x5A, 0x07, 0x0014, 0x05DC, 0x01, 0x33, 0x00
};

/* Word table of H005 (spells of the wands and scrolls). */
static u16 spell_pick(u16 table, u16 sides)
{
    u16 r = roll_dice(1, sides);

    return H005_W(table + (r - 1) * 2);
}

/*
 * PORT H067+$1292 (part $144E): magic weapon, armour or other item
 * of type +$30 with bonus +$36: name, weight (+$3E) and value (+$42).
 */
static void random_magic_item(CokItem *it, u16 *special)
{
    u16 r;                              /* -$2(a5) */
    u16 type = it->b[0x30]; /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */

    IT_SET_W(it, 0x36, random_bonus()); /* item+$36: (word) magic bonus (+n) of the item, signed */
    switch (type) {
    case 0x07:
        r = roll_dice(1, 5);
        if (r == 5) {
            *special = 0x31;
        }
        it->b[0x34] = 7; /* item+$34: name word 3 (index into H005+$406E); base name of the type */
        /* item+$33: name word 2 (1-based index into H005+$406E, $16 bytes); item+$36: (word)
         * magic bonus (+n) of the item, signed */
        it->b[0x33] = (u8)(IT_W(it, 0x36) + 0x6E);
        break;
    case 0x0C:
        it->b[0x34] = 0x0C; /* item+$34: name word 3 (index into H005+$406E); base name of the type */
        /* item+$33: name word 2 (1-based index into H005+$406E, $16 bytes); item+$36: (word)
         * magic bonus (+n) of the item, signed */
        it->b[0x33] = (u8)(IT_W(it, 0x36) + 0x6E);
        break;
    case 0x1F:
        /* item+$34: name word 3 (index into H005+$406E); base name of the type; ogg+$30: type
         * of the item (index into the table H005+$336C, $12 bytes per entry) */
        it->b[0x34] = it->b[0x30];
        it->b[0x33] = 0x30; /* item+$33: name word 2 (1-based index into H005+$406E, $16 bytes) */
        /* item+$32: name word 1 (1-based index into H005+$406E, $16 bytes); item+$36: (word)
         * magic bonus (+n) of the item, signed */
        it->b[0x32] = (u8)(IT_W(it, 0x36) + 0x6E);
        it->b[0x3B] = 4; /* item+$3B: bits 0..2 unidentified name words; bit 5/4 scroll cl.1/2 */
        break;
    case 0x20: case 0x21: case 0x22: case 0x23: case 0x24:
        /* item+$34: name word 3 (index into H005+$406E); base name of the type; ogg+$30: type
         * of the item (index into the table H005+$336C, $12 bytes per entry) */
        it->b[0x34] = it->b[0x30];
        it->b[0x33] = 0x2F; /* item+$33: name word 2 (1-based index into H005+$406E, $16 bytes) */
        /* item+$32: name word 1 (1-based index into H005+$406E, $16 bytes); item+$36: (word)
         * magic bonus (+n) of the item, signed */
        it->b[0x32] = (u8)(IT_W(it, 0x36) + 0x6E);
        it->b[0x3B] = 4; /* item+$3B: bits 0..2 unidentified name words; bit 5/4 scroll cl.1/2 */
        break;
    case 0x1E:
        it->b[0x34] = 0x1E; /* item+$34: name word 3 (index into H005+$406E); base name of the type */
        /* item+$33: name word 2 (1-based index into H005+$406E, $16 bytes); item+$36: (word)
         * magic bonus (+n) of the item, signed */
        it->b[0x33] = (u8)(IT_W(it, 0x36) + 0x6E);
        break;
    case 0x32:
        it->b[0x34] = 0x32; /* item+$34: name word 3 (index into H005+$406E); base name of the type */
        it->b[0x33] = 0x5A; /* item+$33: name word 2 (1-based index into H005+$406E, $16 bytes) */
        IT_SET_W(it, 0x36, 4); /* item+$36: (word) magic bonus (+n) of the item, signed */
        it->b[0x32] = 0x6B; /* item+$32: name word 1 (1-based index into H005+$406E, $16 bytes) */
        break;
    case 0x3B:
        it->b[0x34] = 0x2E; /* item+$34: name word 3 (index into H005+$406E); base name of the type */
        it->b[0x33] = 0x31; /* item+$33: name word 2 (1-based index into H005+$406E, $16 bytes) */
        /* item+$32: name word 1 (1-based index into H005+$406E, $16 bytes); item+$36: (word)
         * magic bonus (+n) of the item, signed */
        it->b[0x32] = (u8)(IT_W(it, 0x36) + 0x6E);
        break;
    default:
        /* item+$34: name word 3 (index into H005+$406E); base name of the type; ogg+$30: type
         * of the item (index into the table H005+$336C, $12 bytes per entry) */
        it->b[0x34] = it->b[0x30];
        /* item+$33: name word 2 (1-based index into H005+$406E, $16 bytes); item+$36: (word)
         * magic bonus (+n) of the item, signed */
        it->b[0x33] = (u8)(IT_W(it, 0x36) + 0x6E);
        break;
    }
    IT_SET_W(it, 0x38, 0); /* item+$38: (word) second bonus, added to CH +$18A when readied */
    it->b[0x40] = 0; /* item+$40: quantity (identical pieces grouped, max 255) */
    switch (it->b[0x30]) { /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
    case 0x01: case 0x11:
        IT_SET_W(it, 0x3E, 0x4B); /* item+$3E: (word) unit weight of the item */
        break;
    case 0x06: case 0x0E: case 0x0F: case 0x17: case 0x19: case 0x1D:
    case 0x25: case 0x43:
        IT_SET_W(it, 0x3E, 0x32); /* item+$3E: (word) unit weight of the item */
        break;
    case 0x09:
        IT_SET_W(it, 0x3E, 0x7D); /* item+$3E: (word) unit weight of the item */
        break;
    case 0x08: case 0x10: case 0x18:
        IT_SET_W(it, 0x3E, 0x64); /* item+$3E: (word) unit weight of the item */
        break;
    case 0x1F: case 0x46:
        IT_SET_W(it, 0x3E, 0x96); /* item+$3E: (word) unit weight of the item */
        break;
    case 0x47:
        IT_SET_W(it, 0x3E, 0xAF); /* item+$3E: (word) unit weight of the item */
        break;
    case 0x04: case 0x32:
        IT_SET_W(it, 0x3E, 0x0A); /* item+$3E: (word) unit weight of the item */
        break;
    case 0x05:
        IT_SET_W(it, 0x3E, 5); /* item+$3E: (word) unit weight of the item */
        it->b[0x40] = 0x14; /* item+$40: quantity (identical pieces grouped, max 255) */
        break;
    case 0x0A: case 0x12:
        IT_SET_W(it, 0x3E, 0x3C); /* item+$3E: (word) unit weight of the item */
        break;
    case 0x16:
        IT_SET_W(it, 0x3E, 0x50); /* item+$3E: (word) unit weight of the item */
        break;
    case 0x07:
        IT_SET_W(it, 0x3E, 0x14); /* item+$3E: (word) unit weight of the item */
        break;
    case 0x0D:
        IT_SET_W(it, 0x3E, 0x28); /* item+$3E: (word) unit weight of the item */
        break;
    case 0x13:
        IT_SET_W(it, 0x3E, 0x23); /* item+$3E: (word) unit weight of the item */
        break;
    case 0x14: case 0x20:
        IT_SET_W(it, 0x3E, 0xFA); /* item+$3E: (word) unit weight of the item */
        break;
    case 0x21:
        IT_SET_W(it, 0x3E, 0x190); /* item+$3E: (word) unit weight of the item */
        break;
    case 0x22:
        IT_SET_W(it, 0x3E, 0x12C); /* item+$3E: (word) unit weight of the item */
        break;
    case 0x23:
        IT_SET_W(it, 0x3E, 0x15E); /* item+$3E: (word) unit weight of the item */
        break;
    case 0x24:
        IT_SET_W(it, 0x3E, 0x1C2); /* item+$3E: (word) unit weight of the item */
        break;
    case 0x1C: case 0x3B:
        IT_SET_W(it, 0x3E, 1); /* item+$3E: (word) unit weight of the item */
        break;
    default:
        IT_SET_W(it, 0x3E, 4); /* item+$3E: (word) unit weight of the item */
        it->b[0x40] = 0x14; /* item+$40: quantity (identical pieces grouped, max 255) */
        break;
    }
    switch (it->b[0x30]) { /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
    case 0x25:
        /* item+$36: (word) magic bonus (+n) of the item, signed; item+$42: (word) value in
         * coins (Sell offers half) */
        IT_SET_W(it, 0x42, IT_W(it, 0x36) * 0x4E2);
        break;
    case 0x1E:
        /* item+$36: (word) magic bonus (+n) of the item, signed; item+$42: (word) value in
         * coins (Sell offers half) */
        IT_SET_W(it, 0x42, IT_W(it, 0x36) * 0x4B);
        break;
    case 0x20: case 0x21: case 0x32:
        /* item+$36: (word) magic bonus (+n) of the item, signed; item+$42: (word) value in
         * coins (Sell offers half) */
        IT_SET_W(it, 0x42, IT_W(it, 0x36) * 0x5DC);
        break;
    case 0x22:
        /* item+$36: (word) magic bonus (+n) of the item, signed; item+$42: (word) value in
         * coins (Sell offers half) */
        IT_SET_W(it, 0x42, IT_W(it, 0x36) * 0x6D6);
        break;
    case 0x23:
        /* item+$36: (word) magic bonus (+n) of the item, signed; item+$42: (word) value in
         * coins (Sell offers half) */
        IT_SET_W(it, 0x42, IT_W(it, 0x36) * 0x7D0);
        break;
    case 0x24:
        /* item+$36: (word) magic bonus (+n) of the item, signed; item+$42: (word) value in
         * coins (Sell offers half) */
        IT_SET_W(it, 0x42, IT_W(it, 0x36) * 0x9C4);
        break;
    default:
        /* item+$36: (word) magic bonus (+n) of the item, signed; item+$42: (word) value in
         * coins (Sell offers half) */
        IT_SET_W(it, 0x42, IT_W(it, 0x36) * 0x3E8);
        break;
    }
}

/*
 * PORT H067+$1292 (part $17FA): scroll ($27, cleric or mage)
 * or type $28 with 1..3 random spells from the tables of H005; the value
 * grows by $96 times the number drawn for each spell.
 */
static void random_scroll(CokItem *it)
{
    u16 roll;                           /* -$2(a5) */
    u16 count;                          /* -$4(a5) */
    u16 k;                              /* -$6(a5) */
    u16 spell = 0;                      /* -$A(a5) */
    u16 kind;                           /* -$C(a5) */

    it->b[0x3B] = 4; /* item+$3B: bits 0..2 unidentified name words; bit 5/4 scroll cl.1/2 */
    count = roll_dice(1, 3);
    if (it->b[0x30] == 0x27) { /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
        if (roll_dice(1, 2) == 1) {
            kind = 3;
            it->b[0x34] = 0x78; /* item+$34: name word 3 (index into H005+$406E); base name of the type */
            it->b[0x33] = 0x28; /* item+$33: name word 2 (1-based index into H005+$406E, $16 bytes) */
        } else {
            kind = 2;
            it->b[0x34] = 0x77; /* item+$34: name word 3 (index into H005+$406E); base name of the type */
            it->b[0x33] = 0x28; /* item+$33: name word 2 (1-based index into H005+$406E, $16 bytes) */
        }
    } else {
        kind = 0;
        it->b[0x34] = 0x26; /* item+$34: name word 3 (index into H005+$406E); base name of the type */
        it->b[0x33] = 0x27; /* item+$33: name word 2 (1-based index into H005+$406E, $16 bytes) */
    }
    /* item+$32: name word 1 (1-based index into H005+$406E, $16 bytes) */
    it->b[0x32] = (u8)(count + 0x63);
    IT_SET_W(it, 0x36, 1); /* item+$36: (word) magic bonus (+n) of the item, signed */
    IT_SET_W(it, 0x3E, 0x19); /* item+$3E: (word) unit weight of the item */
    it->b[0x40] = 0; /* item+$40: quantity (identical pieces grouped, max 255) */
    for (k = 1; k <= count; ++k) {
        roll = roll_dice(1, 4);
        /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
        if (it->b[0x30] == 0x27) {
            switch (roll) {
            case 1:
                spell = (kind == 2) ? spell_pick(0x14C6, 8)
                                    : spell_pick(0x1516, 7);
                break;
            case 2:
                spell = (kind == 2) ? spell_pick(0x14DA, 3)
                                    : spell_pick(0x152A, 6);
                break;
            case 3:
                spell = (kind == 2) ? spell_pick(0x14EE, 6)
                                    : spell_pick(0x153E, 6);
                break;
            case 4:
                spell = (kind == 2) ? spell_pick(0x1502, 7)
                                    : spell_pick(0x1552, 4);
                break;
            default:
                break;
            }
        } else {
            switch (roll) {
            case 1:
                spell = spell_pick(0x1476, 4);
                break;
            case 2:
                spell = spell_pick(0x148A, 7);
                break;
            case 3:
                spell = spell_pick(0x149E, 4);
                break;
            case 4:
                spell = spell_pick(0x14B2, 4);
                break;
            default:
                break;
            }
        }
        /* item+$43: base of the table of 3 spells +$44..+$46 (index 1..3, bit7=to be scribed) */
        it->b[0x44 + k - 1] = (u8)spell;
        /* item+$42: (word) value in coins (Sell offers half) */
        IT_SET_W(it, 0x42, IT_W(it, 0x42) + roll * 0x96);
    }
    switch (kind) {
    case 2:
        /* item+$3B: bits 0..2 unidentified name words; bit 5/4 scroll cl.1/2 */
        it->b[0x3B] = or_byte(it->b[0x3B], 0x20);
        break;
    case 3:
        /* item+$3B: bits 0..2 unidentified name words; bit 5/4 scroll cl.1/2 */
        it->b[0x3B] = or_byte(it->b[0x3B], 0x10);
        break;
    default:
        it->b[0x3B] = 0; /* item+$3B: bits 0..2 unidentified name words; bit 5/4 scroll cl.1/2 */
        break;
    }
}

/*
 * PORT H067+$1292: creates in it a random item of type type (random
 * treasure of the ECL commands).  Some types (and sword 7 with 1 in 5)
 * become one of the special items of the local template.
 */
void random_item(u16 type, CokItem *it)
{
    u16 roll;                           /* -$2(a5) */
    u16 k;                              /* -$6(a5) */
    u16 special = 0;                    /* -$8(a5) */

    h029_fill_bytes(0x47, it->b, 0x47, 0);
    /* item+$44: charges of the magic item; spell 1 of the scroll */
    h029_fill_bytes(2, &it->b[0x44], 3, 0);
    it->next = NULL;
    it->b[0x3A] = 0; /* item+$3A: item readied flag (Ready) */
    it->b[0x3B] = 6; /* item+$3B: bits 0..2 unidentified name words; bit 5/4 scroll cl.1/2 */
    it->b[0x3C] = 0; /* item+$3C: cursed item flag */
    it->b[0x30] = (u8)type; /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
    /* item+$32: name word 1 (1-based index into H005+$406E, $16 bytes) */
    h029_fill_bytes(2, &it->b[0x32], 3, 0);
    switch (it->b[0x30]) { /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
    case 0x27: case 0x28:
        random_scroll(it);
        break;
    case 0x30:
        roll = roll_dice(1, 8);
        if (roll >= 1 && roll <= 5) {
            special = 0x11;
        } else if (roll >= 6 && roll <= 8) {
            special = 1;
        }
        break;
    case 0x34:
        special = 0x21;
        break;
    case 0x35:
        special = 9;
        break;
    default:
        /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
        if ((it->b[0x30] >= 0x01 && it->b[0x30] <= 0x25) ||
            /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
            it->b[0x30] == 0x32 || it->b[0x30] == 0x3B ||
            /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
            it->b[0x30] == 0x46 || it->b[0x30] == 0x47) {
            random_magic_item(it, &special);
        }
        break;
    }
    if (special == 0) {
        return;
    }
    for (k = 0; k <= 2; ++k) {
        /* item+$32: name word 1 (1-based index into H005+$406E, $16 bytes) */
        it->b[0x32 + k] = (u8)s_special_items[special + k - 1];
    }
    IT_SET_W(it, 0x36, 1); /* item+$36: (word) magic bonus (+n) of the item, signed */
    IT_SET_W(it, 0x38, 1); /* item+$38: (word) second bonus, added to CH +$18A when readied */
    IT_SET_W(it, 0x3E, s_special_items[special + 2]); /* item+$3E: (word) unit weight of the item */
    it->b[0x40] = 0; /* item+$40: quantity (identical pieces grouped, max 255) */
    /* item+$42: (word) value in coins (Sell offers half) */
    IT_SET_W(it, 0x42, s_special_items[special + 3]);
    for (k = 1; k <= 3; ++k) {
        /* item+$43: base of the table of 3 spells +$44..+$46 (index 1..3, bit7=to be scribed) */
        it->b[0x44 + k - 1] = (u8)s_special_items[special + 3 + k];
    }
}

/* Copy like move.b (a3)+,(a2)+ / dbeq: at most 41 bytes, NUL included. */
static void copy_text41(char *dst, const char *src)
{
    u16 n;

    for (n = 0; n <= 0x28; ++n) {
        dst[n] = src[n];
        if (src[n] == 0) {
            break;
        }
    }
}

/*
 * Common part of Gems and Jewelry in H067+$1D7C: Sell or Keep.  Keep (if
 * the character is not overloaded and has fewer than 16 items) appends
 * a gem or a piece of jewellery (name $7A/$7B) of the given value at the end
 * of the items; otherwise it is sold (H067+$03BC).
 */
static void sell_or_keep(u16 value, u8 name)
{
    char menu[0x2A];                    /* -$54(a5) */
    u16 room;                           /* -$B0(a5) */
    CokItem *p;                         /* -$B4(a5) */
    CokItem *n;                         /* -$B8(a5) */
    u8 special;                         /* -$BA(a5) */
    u8 full;                            /* -$BB(a5) */
    u8 key;                             /* -$A9(a5) */

    if (would_overload(g_current_char, 1, &room) ||
        g_current_char->b[0x14F] >= 0x10) { /* ch+$14F: number of items owned (max 16) */
        copy_text41(menu, "Sell");
        full = 1;
    } else {
        copy_text41(menu, "Sell Keep");
        full = 0;
    }
    key = ui_request_choice(0x0C, "You can  :  ", 0x28, menu, 0x0D, 0x0A,
                            0x0F, 1, 0, &special);
    if (key == 'K' && !full) {
        n = (CokItem *)exec_alloc_mem(sizeof(CokItem), COK_MEMF_CLEAR);
        n->next = NULL;
        n->b[0x3A] = 0; /* item+$3A: item readied flag (Ready) */
        n->b[0x34] = name; /* item+$34: name word 3 (index into H005+$406E); base name of the type */
        n->b[0x33] = 0; /* item+$33: name word 2 (1-based index into H005+$406E, $16 bytes) */
        n->b[0x32] = 0; /* item+$32: name word 1 (1-based index into H005+$406E, $16 bytes) */
        n->b[0x30] = 0x2F; /* ogg+$30: type of the item (index into the table H005+$336C, $12 bytes per entry) */
        COK_PUT16(&n->b[0x42], value); /* item+$42: (word) value in coins (Sell offers half) */
        COK_PUT16(&n->b[0x3E], 1); /* item+$3E: (word) unit weight of the item */
        n->b[0x3B] = 0; /* item+$3B: bits 0..2 unidentified name words; bit 5/4 scroll cl.1/2 */
        p = g_current_char->items;
        if (p == NULL) {
            /* As in the original: -$B4 = new, the list stays empty. */
            p = n;
        } else {
            while (p->next != NULL) {
                p = p->next;
            }
            p->next = n;
        }
    } else {
        receive_steel(value);
    }
}

/*
 * PORT H067+$1D7C: Appraise, values one by one the gems (+$FA) and the
 * jewellery (+$FC) of the current character, who sells or keeps them.
 */
void appraise_gems(u8 *redraw)
{
    char text[0x2A];                    /* -$2A(a5) */
    char gems[0x2A];                    /* -$7E(a5) */
    char jewels[0x2A];                  /* -$A8(a5) */
    u8 key;                             /* -$A9(a5) */
    u16 roll;                           /* -$AC(a5) */
    u16 value;                          /* -$AE(a5) */
    u8 done;                            /* -$B9(a5) */
    u8 special;                         /* -$BA(a5) */

    *redraw = 1;
    /* ch+$FA: gems (coin type 5) (word); ch+$FC: jewellery (coin type 6) (word) */
    if (CH_W(g_current_char, 0xFA) == 0 && CH_W(g_current_char, 0xFC) == 0) {
        show_message_line(0x12, "No Gems or Jewelry");
        *redraw = 0;
        return;
    }
    do {
        if (CH_W(g_current_char, 0xFA) == 0 && /* ch+$FA: gems (coin type 5) (word) */
            CH_W(g_current_char, 0xFC) == 0) { /* ch+$FC: jewellery (coin type 6) (word) */
            done = 1;
            continue;
        }
        done = 0;
        /* ch+$FA: gems (coin type 5) (word) */
        format_number(0x28, gems, (s32)CH_W(g_current_char, 0xFA), 0, 0x0A,
                      4, ' ');
        /* ch+$FC: jewellery (coin type 6) (word) */
        format_number(0x28, jewels, (s32)CH_W(g_current_char, 0xFC), 0, 0x0A,
                      4, ' ');
        switch (CH_W(g_current_char, 0xFA)) { /* ch+$FA: gems (coin type 5) (word) */
        case 0:
            copy_text41(gems, "");
            break;
        case 1:
            h026_append(0x28, gems, 4, " Gem");
            break;
        default:
            h026_append(0x28, gems, 5, " Gems");
            break;
        }
        switch (CH_W(g_current_char, 0xFC)) { /* ch+$FC: jewellery (coin type 6) (word) */
        case 0:
            copy_text41(jewels, "");
            break;
        case 1:
            h026_append(0x28, jewels, 0x11, " piece of Jewelry");
            break;
        default:
            h026_append(0x28, jewels, 0x12, " pieces of Jewelry");
            break;
        }
        clear_text_cells(1, 1, 0x26, 0x16);
        draw_character_name(g_current_char, 1, 1, 0);
        ui_draw_text(1, 7, 0x0F, 0, 0x20, "You have a fine collection of : ");
        ui_draw_text(1, 9, 0x0F, 0, 0x28, gems);
        ui_draw_text(1, 0x0A, 0x0F, 0, 0x28, jewels);
        copy_text41(text, "");
        if (CH_W(g_current_char, 0xFA) != 0) { /* ch+$FA: gems (coin type 5) (word) */
            copy_text41(text, "  Gems");
        }
        if (CH_W(g_current_char, 0xFC) != 0) { /* ch+$FC: jewellery (coin type 6) (word) */
            h026_append(0x28, text, 9, "  Jewelry");
        }
        h026_append(0x28, text, 5, " Exit");
        key = ui_request_choice(0x0D, "Appraise  :  ", 0x28, text, 0x0D, 0x0A,
                                0x0F, 1, 0, &special);
        switch (key) {
        case 0:
        case 'E':
            done = 1;
            break;
        case 'G':
            if (CH_W(g_current_char, 0xFA) == 0) { /* ch+$FA: gems (coin type 5) (word) */
                break;
            }
            /* ch+$FA: gems (coin type 5) (word) */
            CH_PUTW(g_current_char, 0xFA, (u16)(CH_W(g_current_char, 0xFA) - 1));
            roll = roll_dice(1, 0x64);
            if (roll < 0x1A) {
                value = 5;
            } else if (roll < 0x33) {
                value = 0x19;
            } else if (roll < 0x47) {
                value = 0x32;
            } else if (roll < 0x5B) {
                value = 0xFA;
            } else if (roll < 0x64) {
                value = 0x1F4;
            } else {
                value = 0x9C4;
            }
            format_number(0x28, gems, (s32)value, 0, 0x0A, 4, ' ');
            h026_insert(0x28, gems, 0x15, "The Gem is Valued at ", 0);
            h026_append(0x28, gems, 7, " steel.");
            ui_draw_text(1, 0x0C, 0x0F, 0, 0x28, gems);
            sell_or_keep(value, 0x7A);
            break;
        case 'J':
            if (CH_W(g_current_char, 0xFC) == 0) { /* ch+$FC: jewellery (coin type 6) (word) */
                break;
            }
            /* ch+$FC: jewellery (coin type 6) (word) */
            CH_PUTW(g_current_char, 0xFC, (u16)(CH_W(g_current_char, 0xFC) - 1));
            roll = roll_dice(1, 0x0A);
            if (roll == 1) {
                value = (u16)(random_below(0x1C2) + 0x32);
            } else if (roll == 2) {
                value = (u16)(random_below(0x1F4) + 0x64);
            } else if (roll == 3) {
                value = (u16)(random_below(0x2EE) + 0x96);
            } else if (roll == 4) {
                value = (u16)(random_below(0x4E2) + 0xFA);
            } else if (roll < 8) {
                value = (u16)(random_below(0x9C4) + 0x1F4);
            } else if (roll == 9) {
                value = (u16)(random_below(0xBB8) + 0x3E8);
            } else {
                value = (u16)(random_below(0x1388) + 0x3E8);
            }
            format_number(0x28, jewels, (s32)value, 0, 0x0A, 4, ' ');
            copy_text41(gems, "The Jewel is Valued at ");
            h026_append(0x28, gems, 0x28, jewels);
            h026_append(0x28, gems, 7, " steel.");
            ui_draw_text(1, 0x0C, 0x0F, 0, 0x28, gems);
            sell_or_keep(value, 0x7B);
            break;
        default:
            break;
        }
        recompute_stats(g_current_char);
    } while (!done);
}
