/* H071: Shop and buying of items. */
#include <string.h>
#include "cok.h"
#include "h071.h"
#include "globals.h"
#include "h003_exec.h"
#include "h063.h"
#include "h065.h"
#include "h008.h"
#include "h026_string.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h044_tiles.h"
#include "h045.h"
#include "h061.h"
#include "h067.h"

/* PORT H071+$011C: link/unlk, no effect. */
void h071_init(void)
{
}

/*
 * PORT H071+$047C: the current character takes a copy of it at the
 * end of its items, if it does not overload it ("OverLoaded", *fail).
 */
void take_item(CokItem *it, u8 *fail)
{
    CokItem *p;                         /* -$4(a5) */
    CokItem *n;                         /* -$8(a5) */

    if (item_overloads(g_current_char, it)) {
        show_message_line(0x0A, "OverLoaded");
        *fail = 1;
        return;
    }
    *fail = 0;
    n = (CokItem *)exec_alloc_mem(sizeof(CokItem), COK_MEMF_CLEAR);
    memcpy(n->b, it->b, 0x48);
    n->next = NULL;
    p = g_current_char->items;
    if (p == NULL) {
        g_current_char->items = n;
    } else {
        while (p->next != NULL) {
            p = p->next;
        }
        p->next = n;
    }
    recompute_stats(g_current_char);
}

/* Module data below a4: -$1(a4), redraw the shop list. */
static u8 s_list_redraw;

#define TEXT_BUF ((char *)&g_h005[0x3C82]) /* $3C82: generic 80-character text buffer (TEXT_BUF) */

/*
 * In the original the item list ($2A3A) is passed to the list menu;
 * here a list of entries with the same names, and the item in the
 * same position as the chosen entry.
 */
static CokMenuItem *s_shop_menu;

static CokMenuItem *shop_as_menu(void)
{
    CokItem *it;
    CokMenuItem *tail = NULL;

    menu_free(&s_shop_menu);
    for (it = g_treasure_items; it != NULL; it = it->next) {
        CokMenuItem *n = (CokMenuItem *)exec_alloc_mem(sizeof(CokMenuItem),
                                                       COK_MEMF_CLEAR);

        memcpy(n->text, it->b, 0x2A);
        n->header = it->b[0x2A]; /* ogg+$2A: header flag: copied into the header of the menu entry */
        if (tail == NULL) {
            s_shop_menu = n;
        } else {
            tail->next = n;
        }
        tail = n;
    }
    return s_shop_menu;
}

static CokItem *shop_menu_item(CokMenuItem *node)
{
    CokMenuItem *m = s_shop_menu;
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
 * PORT H071+$012A: list of the items for sale ("Items:", Buy): next to
 * each name goes the price (value +$42, at least 1, scaled by the
 * price level of g_state_b +$6DA) right-aligned on 30
 * columns; then the names are restored.  Returns key and item.
 * An empty name would copy 64K bytes in the original; here nothing.
 */
static void shop_list(u16 *index, CokMenuItem **cursor, CokItem **item,
                      u8 *key)
{
    CokItem *it;                        /* -$8(a5) */
    char buf[0x28];                     /* -$28(a5) */
    u16 len;                            /* -$2A(a5) */
    u16 k;                              /* -$2C(a5) */
    u16 level;                          /* -$2E(a5) */
    u16 price;

    for (it = g_treasure_items; it != NULL; it = it->next) {
        if (COK_GET16(&it->b[0x42]) == 0) { /* item+$42: (word) value in coins (Sell offers half) */
            COK_PUT16(&it->b[0x42], 1); /* item+$42: (word) value in coins (Sell offers half) */
        }
        /* B+$6DA: (word) shop price level: highest bit of the low byte */
        level = (u16)(COK_GET16(g_state_b + 0x6DA) >> 1);
        if (level > 2) {
            if (level == 4) {
                level = 3;
            } else if (level == 0x10) {
                level = 4;
            } else if (level == 0x20) {
                level = 5;
            } else if (level == 0x40) {
                level = 6;
            }
        }
        price = COK_GET16(&it->b[0x42]); /* item+$42: (word) value in coins (Sell offers half) */
        switch (level) {
        case 0: price = (u16)(price >> 4); break;
        case 1: price = (u16)(price >> 3); break;
        case 2: price = (u16)(price >> 2); break;
        case 3: price = (u16)(price >> 1); break;
        case 4: price = (u16)(price << 1); break;
        case 5: price = (u16)(price << 2); break;
        case 6: price = (u16)(price << 3); break;
        default: break;
        }
        format_number(0x1E, buf, (s32)price, 0, 0x0A, 0x1E, ' ');
        len = h026_strlen(0x28, (const char *)it->b);
        for (k = 0; len > 0 && k <= (u16)(len - 1); ++k) {
            buf[k] = (char)it->b[k];
        }
        h026_copy(0x28, (char *)it->b, 0x1E, buf);
    }
    H005_B(0x2483) = 0; /* $2483: index of the selected option in the row menus (persistent) */
    *key = list_menu(7, "Items: ", 3, "Buy", 0x0D, 0x0A, 0x0F, 1, 1, 0x26,
                     0x16, shop_as_menu(), 1, &s_list_redraw, index, cursor);
    *item = shop_menu_item(*cursor);
    for (it = g_treasure_items; it != NULL; it = it->next) {
        build_item_name(NULL, it, 0, 0, 0, 0);
    }
}

/* Message "<name> buys <item>" (plural: +$40, quantity). */
static void buys_message(CokItem *it)
{
    /* $3C82: generic 80-character text buffer (TEXT_BUF) */
    h026_copy(0x50, TEXT_BUF, 0x0F, (const char *)g_current_char->b);
    if (it->b[0x40] > 0) { /* item+$40: quantity (identical pieces grouped, max 255) */
        /* $3C82: generic 80-character text buffer (TEXT_BUF) */
        h026_append(0x50, TEXT_BUF, 6, " buys ");
    } else {
        /* $3C82: generic 80-character text buffer (TEXT_BUF) */
        h026_append(0x50, TEXT_BUF, 8, " buys a ");
    }
    /* $3C82: generic 80-character text buffer (TEXT_BUF) */
    h026_append(0x50, TEXT_BUF, 0x28, (const char *)it->b);
    show_message_line(0x50, TEXT_BUF); /* $3C82: generic 80-character text buffer (TEXT_BUF) */
}

/*
 * PORT H071+$0572: Buy.  The price is the value scaled by the highest bit
 * (low byte) of g_state_b +$6DA; payment is with the character's money (all in
 * steel) or, if that is not enough, with the pool.  The uninitialised bit
 * of the original (no bit set) is 0 here.
 */
static void shop_buy(void)
{
    CokItem *it = NULL;                 /* -$4(a5) */
    u8 key;                             /* -$5(a5) */
    u8 done;                            /* -$6(a5) */
    u16 price = 0;                      /* -$8(a5) */
    u16 money;                          /* -$A(a5) */
    u16 bit = 0;                        /* -$C(a5) */
    u16 i;                              /* -$E(a5) */
    u32 pool;                           /* -$12(a5) */
    u8 fail;                            /* -$13(a5) */
    CokMenuItem *cursor = NULL;         /* -$18(a5) */
    u16 index = 0;                      /* -$1A(a5) */
    u16 v;

    draw_screen_frame(1);
    s_list_redraw = 1;
    do {
        shop_list(&index, &cursor, &it, &key);
        if (key != 'B' && key != 0x0D) {
            done = 1;
            continue;
        }
        done = 0;
        for (i = 0; i <= 7; ++i) {
            /* B+$6DA: (word) shop price level: highest bit of the low byte */
            if (mask_byte((u8)((u8)COK_GET16(g_state_b + 0x6DA) >> i), 1) > 0) {
                bit = i;
            }
        }
        v = COK_GET16(&it->b[0x42]); /* item+$42: (word) value in coins (Sell offers half) */
        switch (bit) {
        case 0: price = (u16)(v >> 4); break;
        case 1: price = (u16)(v >> 3); break;
        case 2: price = (u16)(v >> 2); break;
        case 3: price = (u16)(v >> 1); break;
        case 4: price = v; break;
        case 5: price = (u16)(v << 1); break;
        case 6: price = (u16)(v << 2); break;
        case 7: price = (u16)(v << 3); break;
        default: break;
        }
        money = (u16)wealth_in_steel(g_current_char);
        if (price <= money) {
            take_item(it, &fail);
            if (!fail) {
                money = (u16)(money - price);
                set_steel_only(money);
                buys_message(it);
            }
        } else {
            pool = pool_value();
            if ((s32)price <= (s32)pool) {
                take_item(it, &fail);
                if (!fail) {
                    pool = pool - price;
                    set_pool_steel((u16)pool);
                    buys_message(it);
                }
            } else {
                show_message_line(0x11, "Not enough Money.");
            }
        }
    } while (!done);
}

/*
 * PORT H071+$092C: the shop (context 1): Buy, View, Take, Pool, Share,
 * Appraise, Exit.  When leaving with money left in the pool the shopkeeper
 * asks whether to come back for it.
 */
void shop(void)
{
    char menu[0x2A];                    /* -$2A(a5) */
    char title[2];                      /* -$2C(a5) */
    u8 special;                         /* -$2D(a5) */
    u8 done;                            /* -$2E(a5) */
    u8 key;                             /* -$2F(a5) */
    u8 money;                           /* -$30(a5) */
    u8 items;                           /* -$31(a5) */
    u8 redraw;                          /* -$33(a5) */
    CokItem *it;                        /* -$38(a5) */

    H005_B(0x3DE3) = 1; /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    H005_B(0x24C2) = 0; /* $24C2: 1: in context 1 the redraw includes the exploration frame */
    redraw_game_screen();
    H005_B(0x24C2) = 1; /* $24C2: 1: in context 1 the redraw includes the exploration frame */
    draw_party(g_current_char);
    /* $2A1E: party pool: 7 longs, coins per type 0..6 (4 = steel) */
    h029_fill_bytes(0x1B, &g_h005[0x2A1E], 0x1C, 0);
    title[0] = 0;
    title[1] = 0;
    H005_B(0x24E3) = 0; /* $24E3: use: 1 if the shared pool has coins (Pool/Share/Take), never read */
    done = 0;
    for (it = g_treasure_items; it != NULL; it = it->next) {
        build_item_name(NULL, it, 0, 0, 0, 0);
    }
    do {
        has_treasure(&money, &items);
        if (money) {
            h026_copy(0x28, menu, 0x26,
                      "Buy View Take Pool Share Appraise Exit");
        } else {
            h026_copy(0x28, menu, 0x1B, "Buy View Pool Appraise Exit");
        }
        key = ui_request_choice(1, title, 0x28, menu, 0x0D, 0x0A, 0x0F, 1, 0,
                                &special);
        switch (key) {
        case 'B':
            shop_buy();
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
                word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 1, 0x52,
                               "As you Leave the Shopkeeper says, 'Excuse me "
                               "but you have Left Some Money here.'  ");
                word_wrap_text(1, 0x11, 0x26, 0x16, 0x0F, 0, 0, 0x2A,
                               "Do you want to go back and get your Money?");
                if ((u8)ecl_menu(1, title, 0x28, menu, 0x0D, 0x0A, 0x0F, 0, 0)
                    == 1) {
                    done = 1;
                } else {
                    clear_text_cells(1, 0x11, 0x26, 0x16);
                }
            } else {
                done = 1;
            }
            break;
        case 'H':
            select_party_member(key);
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
        draw_party(g_current_char);
    } while (!done);
}
