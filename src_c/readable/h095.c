/* H095: module data (tables of words). */
#include "init_data.h"
#include "h095.h"
#include "globals.h"
#include "h003_exec.h"
#include "h008.h"
#include "h011.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h035.h"
#include "h048.h"
#include "h053.h"
#include "h062.h"
#include "h063.h"
#include "h096.h"
#include <string.h>

/* Module data below a4: g_h095_bss[0x342 - off] is -off(a4). */
u8 g_h095_bss[0x342];

#include "h095_init_data.h"

/* PORT H095+$0384 */
void h095_init(void)
{
    INIT_APPLY(s_init_2670, g_h095_bss, sizeof(g_h095_bss));
}

/*
 * Module data: -$332/-$334 row and column (in blocks) of the dungeon
 * square being examined, -$335..-$338 its walls (0 north, 6 west, 2
 * east, 4 south: 0 open, 1 wall, 3 door), -$341 outdoor square
 * (bit 6 of GEO plane 2), -$342 forest, -$339 side, -$340 set loaded.
 */
#define H095_B(off)     g_h095_bss[0x342 - (off)]
#define H095_W(off)     ((s16)COK_GET16(&g_h095_bss[0x342 - (off)]))
#define H095_SETW(off, v) COK_PUT16(&g_h095_bss[0x342 - (off)], (u16)(v))
#define PLACE_TABLE(side, set, r, c) \
    g_h095_bss[0x342 - 0x320 + (side) * 0x120 + (set) * 0x48 + (r) * 0x0C + (c)]

#define WALL_N  H095_B(0x335)
#define WALL_W  H095_B(0x336)
#define WALL_E  H095_B(0x337)
#define WALL_S  H095_B(0x338)

static u8 *map_cell(s16 x, s16 y)
{
    return g_combat_area + 0x0A + (s32)y * 0x64 + x * 2;
}

static u8 tile_frame(u8 t)
{
    return H005_B(0x3EF4 + (t - 1) * 4 + 3); /* $3EF7: terrain +3: graphic frame of the tile */
}

static u8 in_map(s16 x, s16 y)
{
    return (u8)(x >= 0 && x <= 0x31 && y >= 0 && y <= 0x18);
}

/*
 * PORT H095+$0392: upper part of the square (dx, dy) of the 7x5 block being
 * examined (column $15 + 6*col + 5*row, row $A + 5*row) = tile + 1.
 */
static void set_block_cell(s16 dx, s16 dy, u16 tile)
{
    s16 x;                              /* -$2(a5) */
    s16 y;                              /* -$4(a5) */

    /* H095_bss+$10: (word) column (in blocks) of the dungeon square being examined; H095_bss+$E:
     * (word) row (in blocks) of the dungeon square being examined */
    x = (s16)(H095_W(0x332) * 6 + H095_W(0x334) * 5 + 0x15 + dx);
    /* H095_bss+$E: (word) row (in blocks) of the dungeon square being examined */
    y = (s16)(H095_W(0x334) * 5 + 0x0A + dy);
    if (in_map(x, y)) {
        map_cell(x, y)[1] = (u8)(tile + 1);
    }
}

/*
 * PORT H095+$0422: forest: in a block with suitable walls (no door,
 * not two opposite sides closed without the other two) and outdoors, the
 * free squares ($16) become trees ($1A, 50%) with bushes ($1B,
 * 90%) around them.
 */
static void plant_trees(void)
{
    static const s16 dxs[4] = { 0, 1, 0, -1 };     /* -$8(a5) */
    static const s16 dys[4] = { -1, 0, 1, 0 };     /* -$10(a5) */
    s16 i;                              /* -$12(a5) */
    s16 j;                              /* -$14(a5) */
    s16 x;                              /* -$16(a5) */
    s16 y;                              /* -$18(a5) */
    s16 nx;                             /* -$1A(a5) */
    s16 ny;                             /* -$1C(a5) */
    u16 k;                              /* -$1E(a5) */
    u8 ok = 0;

    /* H095_bss+$D: north wall of the block (0 open, 1 wall, 3 door); H095_bss+$B: east wall of the
     * block (0 open, 1 wall, 3 door); H095_bss+$A: south wall of the block (0 open, 1 wall, 3
     * door); H095_bss+$C: west wall of the block (0 open, 1 wall, 3 door) */
    if (WALL_N == 1 || WALL_E == 1 || WALL_S == 1 || WALL_W == 1) {
        ok = 1;
        /* H095_bss+$D: north wall of the block (0 open, 1 wall, 3 door); H095_bss+$A: south wall of the
         * block (0 open, 1 wall, 3 door); H095_bss+$B: east wall of the block (0 open, 1 wall, 3
         * door); H095_bss+$C: west wall of the block (0 open, 1 wall, 3 door) */
        if (WALL_N == 1 && WALL_S == 1 && !(WALL_E == 1 && WALL_W == 1)) {
            ok = 0;
        /* H095_bss+$B: east wall of the block (0 open, 1 wall, 3 door); H095_bss+$C: west wall
         * of the block (0 open, 1 wall, 3 door) */
        } else if (WALL_E == 1 && WALL_W == 1 &&
                   /* H095_bss+$D: north wall of the block (0 open, 1 wall, 3 door); H095_bss+$A: south wall
                    * of the block (0 open, 1 wall, 3 door) */
                   !(WALL_N == 1 && WALL_S == 1)) {
            ok = 0;
        /* H095_bss+$D: north wall of the block (0 open, 1 wall, 3 door); H095_bss+$B: east wall of the
         * block (0 open, 1 wall, 3 door); H095_bss+$A: south wall of the block (0 open, 1 wall, 3
         * door); H095_bss+$C: west wall of the block (0 open, 1 wall, 3 door) */
        } else if (WALL_N == 3 || WALL_E == 3 || WALL_S == 3 || WALL_W == 3) {
            ok = 0;
        }
    }
    H095_B(0x342) = ok; /* H095_bss+$0: square suitable for the forest flag (walls without doors) */
    for (i = 2; i <= 3; ++i) {
        for (j = 2; j <= 4; ++j) {
            /* H095_bss+$10: (word) column (in blocks) of the dungeon square being examined;
             * H095_bss+$E: (word) row (in blocks) of the dungeon square being examined */
            x = (s16)(H095_W(0x332) * 6 + H095_W(0x334) * 5 + 0x15 + i + j);
            /* H095_bss+$E: (word) row (in blocks) of the dungeon square being examined */
            y = (s16)(H095_W(0x334) * 5 + 0x0A + j);
            if (!in_map(x, y) || tile_frame(map_cell(x, y)[1]) != 0x16 ||
                /* H095_bss+$1: outdoor square: bit 6 of the map flags; H095_bss+$0: square
                 * suitable for the forest flag (walls without doors) */
                !H095_B(0x341) || !H095_B(0x342) || roll_dice(1, 0x0A) > 5) {
                continue;
            }
            map_cell(x, y)[1] = 0x1A;
            for (k = 1; k <= 4; ++k) {
                nx = (s16)(dxs[k - 1] + x);
                ny = (s16)(dys[k - 1] + y);
                if (in_map(nx, ny) && tile_frame(map_cell(nx, ny)[1]) == 0x16 &&
                    roll_dice(1, 0x0A) <= 9) {
                    map_cell(nx, ny)[1] = 0x1B;
                }
            }
        }
    }
}

/*
 * PORT H095+$0700 (nested in $06F2): side dir of the dungeon square (x, y):
 * inside the map 1 without a wall, 0 wall, 3 door; outside 0
 * for the east/west sides on the party row, otherwise 1.
 */
static u8 wall_side(s16 x, s16 y, u16 dir)
{
    if (x >= 0 && x <= 0x0F && y >= 0 && y <= 0x0F) {
        if (map_door(x, y, dir) == 0) {
            return 1;
        }
        if (map_wall(x, y, dir) == 0) {
            return 0;
        }
        return 3;
    }
    /* $281E: (word) party y on the 16x16 area map */
    if (y == (s16)H005_W(0x281E) && (dir == 2 || dir == 6)) {
        return 0;
    }
    return 1;
}

/* PORT H095+$06F2: side dir between (x, y) and the neighbouring square (OR of the two). */
static u8 wall_between(s16 x, s16 y, u16 dir)
{
    u16 opposite;                       /* -$4(a5) */
    u8 a;                               /* -$1(a5) */
    u8 b;                               /* -$2(a5) */

    opposite = (u16)((dir + 4) & 7);
    a = wall_side(x, y, dir);
    /* $3EE2: (word) x offset for direction d (step 2) */
    b = wall_side((s16)(x + H005_W(0x3EE2 + dir * 2)),
                  /* $3ED0: (word) y offset for direction d (step 2) */
                  (s16)(y + H005_W(0x3ED0 + dir * 2)), opposite);
    return or_byte(a, b);
}

/* PORT H095+$0848 (nested in $083A): floor and west wall of the block. */
static void block_floor_and_west(void)
{
    s16 i;                              /* -$2(a5) */
    s16 j;                              /* -$4(a5) */

    for (j = 2; j <= 4; ++j) {
        for (i = 0; i <= 5; ++i) {
            set_block_cell(i, j, 0x16);
        }
    }
    if (WALL_W == 1) { /* H095_bss+$C: west wall of the block (0 open, 1 wall, 3 door) */
        for (j = 2; j <= 4; ++j) {
            set_block_cell((s16)(j - 1), j, 4);
            set_block_cell(j, j, 3);
            set_block_cell((s16)(j + 1), j, 0x0D);
        }
    } else if (WALL_W == 3) { /* H095_bss+$C: west wall of the block (0 open, 1 wall, 3 door) */
        set_block_cell(1, 2, 8);
        set_block_cell(5, 4, 0);
    }
}

/* PORT H095+$0912 (nested in $083A): north side in the middle of the block. */
static void block_north_middle(void)
{
    u16 t = (WALL_N == 1) ? 5 : 0x16; /* H095_bss+$D: north wall of the block (0 open, 1 wall, 3 door) */
    /* H095_bss+$D: north wall of the block (0 open, 1 wall, 3 door) */
    u16 b = (WALL_N == 1) ? 0x0A : 0x16;

    set_block_cell(3, 0, t);
    set_block_cell(4, 0, t);
    set_block_cell(3, 1, b);
    set_block_cell(4, 1, b);
}

/*
 * PORT H095+$09A4 (nested in $083A): north-west corner of the block
 * (squares 1..2 x 0..1) according to the walls; corner = no wall between
 * the block to the north and the one to the west.  In the cases without a value the original
 * uses uninitialised words: here 0.
 */
static void block_north_west(s16 x, s16 y)
{
    s16 t1 = 0;                         /* -$4(a5) */
    s16 t3 = 0;                         /* -$6(a5) */
    s16 t2 = 0;                         /* -$8(a5) */
    s16 t4 = 0;                         /* -$A(a5) */
    u8 corner;                          /* -$B(a5) */

    corner = (u8)(!wall_between(x, (s16)(y - 1), 6) &&
                  !wall_between((s16)(x - 1), y, 0));
    /* k = 1 */
    switch (WALL_N) { /* H095_bss+$D: north wall of the block (0 open, 1 wall, 3 door) */
    case 0:
        switch (WALL_W) { /* H095_bss+$C: west wall of the block (0 open, 1 wall, 3 door) */
        case 0: t1 = 0x16; break;
        case 1: t1 = corner ? 0 : 0x0D; break;
        case 3: t1 = 0x0D; break;
        default: break;
        }
        break;
    case 1:
    case 3:
        if (WALL_W == 0) { /* H095_bss+$C: west wall of the block (0 open, 1 wall, 3 door) */
            t1 = corner ? 0x0F : 5;
        } else {
            t1 = corner ? 0x12 : 2;
        }
        break;
    default:
        break;
    }
    /* k = 2 */
    switch (WALL_N) { /* H095_bss+$D: north wall of the block (0 open, 1 wall, 3 door) */
    case 0: t2 = 0x16; break;
    case 1: t2 = 5; break;
    case 3: t2 = 0x11; break;
    default: break;
    }
    /* k = 3 */
    switch (WALL_W) { /* H095_bss+$C: west wall of the block (0 open, 1 wall, 3 door) */
    case 0:
        if (WALL_N == 0) { /* H095_bss+$D: north wall of the block (0 open, 1 wall, 3 door) */
            t3 = 0x16;
        } else {
            t3 = corner ? 0x10 : 0x0A;
        }
        break;
    case 1: t3 = corner ? 1 : 3; break;
    case 3: t3 = corner ? 0x14 : 7; break;
    default: break;
    }
    /* k = 4 */
    switch (WALL_W) { /* H095_bss+$C: west wall of the block (0 open, 1 wall, 3 door) */
    case 0:
    case 3:
        switch (WALL_N) { /* H095_bss+$D: north wall of the block (0 open, 1 wall, 3 door) */
        case 0: t4 = 0x16; break;
        case 1: t4 = 0x0A; break;
        case 3: t4 = 0x17; break;
        default: break;
        }
        break;
    case 1:
        switch (WALL_N) { /* H095_bss+$D: north wall of the block (0 open, 1 wall, 3 door) */
        case 0: t4 = 0x0D; break;
        case 1: t4 = 6; break;
        case 3: t4 = 0x15; break;
        default: break;
        }
        break;
    default:
        break;
    }
    set_block_cell(1, 0, (u16)t1);
    set_block_cell(2, 0, (u16)t2);
    set_block_cell(1, 1, (u16)t3);
    set_block_cell(2, 1, (u16)t4);
}

/*
 * PORT H095+$0CD4 (nested in $083A): north-east corner of the block
 * (squares 5..6 x 0..1); ne = wall to the north of the block to the east, en =
 * wall to the east of the block to the north.  Uninitialised values: 0.
 */
static void block_north_east(s16 x, s16 y)
{
    s16 t1 = 0;                         /* -$4(a5) */
    s16 t3 = 0;                         /* -$6(a5) */
    s16 t2 = 0;                         /* -$8(a5) */
    s16 t4 = 0;                         /* -$A(a5) */
    u8 corner;                          /* -$B(a5) */
    u8 ne;                              /* -$C(a5) */
    u8 en;                              /* -$D(a5) */

    ne = wall_between(x, (s16)(y - 1), 2);
    en = wall_between((s16)(x + 1), y, 0);
    corner = (u8)(!ne && !en);
    /* k = 1 */
    switch (WALL_N) { /* H095_bss+$D: north wall of the block (0 open, 1 wall, 3 door) */
    case 0: t1 = (ne == 1) ? 4 : 0x16; break;
    case 1: t1 = 5; break;
    case 3: t1 = 0x0F; break;
    default: break;
    }
    /* k = 2 */
    if (WALL_N == 0) { /* H095_bss+$D: north wall of the block (0 open, 1 wall, 3 door) */
        switch (ne) {
        case 0: t2 = 0x16; break;
        case 1:
            if (WALL_E != 0) { /* H095_bss+$B: east wall of the block (0 open, 1 wall, 3 door) */
                t2 = 3;
            } else {
                t2 = en ? 0x0B : 7;
            }
            break;
        /* H095_bss+$B: east wall of the block (0 open, 1 wall, 3 door) */
        case 3: t2 = (WALL_E == 0 && en) ? 0x18 : 1; break;
        default: break;
        }
    } else if (WALL_E) { /* H095_bss+$B: east wall of the block (0 open, 1 wall, 3 door) */
        t2 = 9;
    } else if (en) {
        t2 = 5;
    } else if (corner) {
        t2 = 0x11;
    } else {
        t2 = 0x13;
    }
    /* k = 3 */
    switch (WALL_N) { /* H095_bss+$D: north wall of the block (0 open, 1 wall, 3 door) */
    case 0: t3 = 0x16; break;
    case 1: t3 = 0x0A; break;
    case 3: t3 = 0x10; break;
    default: break;
    }
    /* k = 4 */
    if (WALL_N == 0) { /* H095_bss+$D: north wall of the block (0 open, 1 wall, 3 door) */
        if (ne == 0) {
            t4 = 0x16;
        } else if (WALL_E) { /* H095_bss+$B: east wall of the block (0 open, 1 wall, 3 door) */
            t4 = 4;
        } else if (en == 0) {
            t4 = 8;
        } else {
            t4 = 0x0C;
        }
    } else if (WALL_E) { /* H095_bss+$B: east wall of the block (0 open, 1 wall, 3 door) */
        t4 = 0x0E;
    } else if (en == 0) {
        t4 = 0x17;
    } else {
        t4 = 0x0A;
    }
    set_block_cell(5, 0, (u16)t1);
    set_block_cell(6, 0, (u16)t2);
    set_block_cell(5, 1, (u16)t3);
    set_block_cell(6, 1, (u16)t4);
}

/*
 * PORT H095+$083A: combat map in the dungeon: for every square
 * around the party (columns -6..6, rows -2..2) a block with floor,
 * walls and doors of the dungeon, and trees if outdoors.
 */
static void build_dungeon_map(void)
{
    s16 x;                              /* -$2(a5) */
    s16 y;                              /* -$4(a5) */
    s16 row;                            /* -$334(a4) */
    s16 col;                            /* -$332(a4) */

    for (row = -2; row <= 2; ++row) {
        H095_SETW(0x334, row); /* H095_bss+$E: (word) row (in blocks) of the dungeon square being examined */
        for (col = -6; col <= 6; ++col) {
            /* H095_bss+$10: (word) column (in blocks) of the dungeon square being examined */
            H095_SETW(0x332, col);
            /* $281C: (word) party x on the 16x16 area map; H095_bss+$10: (word) column (in
             * blocks) of the dungeon square being examined */
            x = (s16)(H005_W(0x281C) + H095_W(0x332));
            /* $281E: (word) party y on the 16x16 area map; H095_bss+$E: (word) row (in blocks) of
             * the dungeon square being examined */
            y = (s16)(H005_W(0x281E) + H095_W(0x334));
            /* H095_bss+$C: west wall of the block (0 open, 1 wall, 3 door) */
            WALL_W = wall_between(x, y, 6);
            /* H095_bss+$D: north wall of the block (0 open, 1 wall, 3 door) */
            WALL_N = wall_between(x, y, 0);
            /* H095_bss+$B: east wall of the block (0 open, 1 wall, 3 door) */
            WALL_E = wall_between(x, y, 2);
            /* H095_bss+$A: south wall of the block (0 open, 1 wall, 3 door) */
            WALL_S = wall_between(x, y, 4);
            block_floor_and_west();
            block_north_middle();
            block_north_west(x, y);
            block_north_east(x, y);
            /* H095_bss+$1: outdoor square: bit 6 of the map flags */
            H095_B(0x341) = mask_byte(map_flags(x, y), 0x40);
            plant_trees();
        }
    }
}

/*
 * PORT H095+$1076: outdoors, on the pairs of free squares one above
 * the other, with 8% probability: an object ($2A..$2B) or, with another
 * missed 8%, a tall tree (top $20..$25, trunk $26..$29).
 */
static void scatter_wild_objects(void)
{
    s16 x;                              /* -$4(a5) */
    s16 y;                              /* -$6(a5) */
    u16 p = 8;                          /* -$8(a5) */

    for (x = 0; x <= 0x31; ++x) {
        for (y = 1; y <= 0x18; ++y) {
            if (tile_frame(map_cell(x, y)[1]) != 0x16 ||
                tile_frame(map_cell(x, (s16)(y - 1))[1]) != 0x16 ||
                roll_dice(1, 0x64) > p) {
                continue;
            }
            if (roll_dice(1, 0x64) <= p) {
                map_cell(x, y)[1] = (u8)(roll_dice(1, 2) + 0x29);
            } else {
                map_cell(x, (s16)(y - 1))[1] = (u8)(roll_dice(1, 6) + 0x1F);
                map_cell(x, y)[1] = (u8)(roll_dice(1, 4) + 0x25);
            }
        }
    }
}

/*
 * PORT H095+$1228 (annidata in $121A): d100 sulle soglie a, a+b, ...:
 * erba $3A..$3B, $30..$31, $2C..$2F, $37..$39 o $32..$35.
 */
static void place_ground(s16 x, s16 y, u16 a, u16 b, u16 c, u16 d, u16 e)
{
    u16 r;                              /* -$2(a5) */

    r = roll_dice(1, 0x64);
    if (r <= a) {
        map_cell(x, y)[1] = (u8)(roll_dice(1, 2) + 0x39);
    } else if (r <= (u16)(a + b)) {
        map_cell(x, y)[1] = (u8)(roll_dice(1, 2) + 0x2F);
    } else if (r <= (u16)(a + b + c)) {
        map_cell(x, y)[1] = (u8)(roll_dice(1, 4) + 0x2B);
    } else if (r <= (u16)(a + b + c + d)) {
        map_cell(x, y)[1] = (u8)(roll_dice(1, 3) + 0x36);
    } else if (r <= (u16)(a + b + c + d + e)) {
        map_cell(x, y)[1] = (u8)(roll_dice(1, 4) + 0x31);
    }
}

/*
 * PORT H095+$121A: decorates the free squares outdoors; the terrain is
 * fixed at $28 in the original, so the third table is always used.
 */
static void decorate_wild_ground(void)
{
    s16 x;                              /* -$2(a5) */
    s16 y;                              /* -$4(a5) */
    s16 terrain = 0x28;                 /* -$6(a5) */

    for (x = 0; x <= 0x31; ++x) {
        for (y = 0; y <= 0x18; ++y) {
            if (tile_frame(map_cell(x, y)[1]) != 0x16) {
                continue;
            }
            if (terrain >= -0x1E && terrain <= 9) {
                place_ground(x, y, 0, 0, 0, 0x1E, 0x0F);
            } else if (terrain >= 0x0A && terrain <= 0x1D) {
                place_ground(x, y, 0, 1, 5, 0x14, 0x0A);
            } else if (terrain >= 0x1E && terrain <= 0x45) {
                place_ground(x, y, 0, 2, 5, 0x0A, 5);
            } else if (terrain >= 0x46 && terrain <= 0x59) {
                place_ground(x, y, 0x0A, 2, 0x0A, 0x0A, 1);
            } else if (terrain >= 0x5A && terrain <= 0x6E) {
                place_ground(x, y, 0x0F, 5, 0x0F, 0x0A, 1);
            }
        }
    }
}

/*
 * PORT H095+$1576: outdoor map: everything free ($17, $9C3 bytes as
 * the original), then objects and terrain.  The coordinates +$186/+$188 of the
 * state are read but not used.
 */
static void build_wild_map(void)
{
    h029_fill_bytes(0x9C3, g_combat_area + 0x0A, 0x9C3, 0x17);
    H095_SETW(0x33E, 0x0F); /* H095_bss+$4: use: (word) set to $0F when building the outdoor map */
    scatter_wild_objects();
    decorate_wild_ground();
}

/*
 * PORT H095+$1630: loads the tile sets (dungeon: DungCom, outdoors:
 * WildCom, plus RandCom) if different from the ones already loaded (-$340),
 * allocates the map ($9CE bytes) and builds it; the ground of every square
 * takes the value of the upper part.
 */
static void build_combat_map(void)
{
    u16 y;                              /* -$4(a5) */
    u16 x;                              /* -$6(a5) */

    if (COK_GET16(g_state_a + 0x1CC)) { /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
        if (H095_W(0x340) != 1) { /* H095_bss+$2: (word) tile set loaded: 1 dungeon, 2 outdoors */
            load_24x24_set(7, "DungCom", 1, 0, 0x19);
            load_24x24_set(7, "RandCom", 1, 0x22, 6);
            H095_SETW(0x340, 1); /* H095_bss+$2: (word) tile set loaded: 1 dungeon, 2 outdoors */
        }
    } else if (H095_W(0x340) != 2) { /* H095_bss+$2: (word) tile set loaded: 1 dungeon, 2 outdoors */
        load_24x24_set(7, "WildCom", 1, 0, 0x21);
        load_24x24_set(7, "RandCom", 1, 0x22, 6);
        H095_SETW(0x340, 2); /* H095_bss+$2: (word) tile set loaded: 1 dungeon, 2 outdoors */
    }
    g_combat_area = (u8 *)exec_alloc_mem(0x9CE, COK_MEMF_CLEAR);
    g_combat_area[6] = 0;
    g_combat_area[7] = 1;
    g_combat_area[8] = 0;
    if (COK_GET16(g_state_a + 0x1CC)) { /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
        build_dungeon_map();
    } else {
        build_wild_map();
    }
    for (y = 0; y <= 0x18; ++y) {
        for (x = 0; x <= 0x31; ++x) {
            map_cell((s16)x, (s16)y)[0] = map_cell((s16)x, (s16)y)[1];
        }
    }
}

/*
 * PORT H095+$1790: for every character: statistics, turn block
 * ($18 bytes), beyond the number in $3E00+$67C out of combat (+$15);
 * initial direction from the table -$48 (opposite for side 1); the
 * party characters out of combat without a valid AI take
 * the one of $3E00+$58C + $80.
 */
static void prepare_turn_blocks(void)
{
    Character *p;                       /* -$4(a5) */
    u16 n = 0;                          /* -$6(a5) */
    u16 ai;                             /* -$8(a5) */

    for (p = g_party_head; p != NULL; p = p->next) {
        recompute_stats(p);
        ++n;
        p->block_192 = (CokTurn *)exec_alloc_mem(sizeof(CokTurn),
                                                 COK_MEMF_CLEAR);
        if (n > COK_GET16(g_state_b + 0x67C)) { /* B+$67C: (word) number of party members (max 8) */
            /* turn+$15: 1 = combatant beyond the party members, leaves it at the end of the fight */
            p->block_192->b[0x15] = 1;
        }
        /* turn+$B: facing/frame of the combatant (direction 0..7); H095_bss+$2FA: 4 words: direction 0..7
         * per quarter 0..3 (also facing); $2820: party direction (0 north, 2 east, 4 south, 6
         * west) */
        p->block_192->b[0x0B] = (u8)H095_W(0x48 - (H005_B(0x2820) >> 1) * 2);
        if (p->b[0x199] == 1) { /* ch+$199: side in combat (0 party, 1 opponents) */
            /* turn+$B: facing/frame of the combatant (direction 0..7) */
            p->block_192->b[0x0B] = (u8)((p->block_192->b[0x0B] + 4) & 7);
        }
        /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
        ai = mask_byte(p->b[0xEC], 0x7F);
        /* ch+$199: side in combat (0 party, 1 opponents); turn+$15: 1 = combatant beyond the party
         * members, leaves it at the end of the fight */
        if (p->b[0x199] == 0 && p->block_192->b[0x15] == 1 &&
            (ai == 0 || ai > 0x66)) {
            /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused); B+$58C: use:
             * AI ($80+v) of the NPCs out of the fight; subtracted from 100 in the
             * flee test */
            p->b[0xEC] = (u8)(COK_GET16(g_state_b + 0x58C) + 0x80);
        }
    }
}

/* PORT H095+$18CC: (x, y) outside the 11x6 deployment grid? */
static u8 outside_grid(s16 x, s16 y)
{
    if (x >= 0 && x < 0x0B) {
        return 0;
    }
    if (y >= 0 && y < 6) {
        return 0;
    }
    return 1;
}

/*
 * PORT H095+$1914: tries to put combatant n in the square (cx,
 * cy) of the grid of the group (gx, gy) of deployment set: if the
 * grid allows it and the squares are free and passable, it occupies it.
 */
static u8 try_place(u16 n, s16 cx, s16 cy, s16 gx, s16 gy, u16 set)
{
    u16 blocker;                        /* -$2(a5) */
    u16 tile;                           /* -$4(a5) */
    u8 in_cloud;                        /* -$5(a5) */
    u8 in_acid;                         /* -$6(a5) */

    if (cx < 0 || cy < 0 || cx > 0x0A || cy > 5 ||
        /* H095_bss+$22: deployment grids: side*$120+set*$48+row*$C+col, 1=free; H095_bss+$9: side
         * being examined (0 party, 1 enemies): index into GROUP_* */
        !PLACE_TABLE(H095_B(0x339), set, cy, cx)) {
        return 0;
    }
    /* $3154: combatant positions, 6 bytes per n (from 1): +0 column (word) */
    H005_SET_W(0x3154 + (n - 1) * 6, (u16)(gx * 6 + cx + gy * 5 + 0x16));
    /* $3156: combatant positions +2: row on the map (word) */
    H005_SET_W(0x3154 + (n - 1) * 6 + 2, (u16)(gy * 5 + cy + 0x0A));
    probe_move(g_combatants[n - 1], 8, &blocker, &tile, &in_cloud, &in_acid);
    /* $3EF4: terrain, $41 entries of 4 bytes (from 1): +0 cost ($FF impassable) */
    if (blocker == 0 && tile > 0 && H005_B(0x3EF4 + (tile - 1) * 4) < 0xFF) {
        /* H095_bss+$22: deployment grids: side*$120+set*$48+row*$C+col, 1=free; H095_bss+$9: side
         * being examined (0 party, 1 enemies): index into GROUP_* */
        PLACE_TABLE(H095_B(0x339), set, cy, cx) = 0;
        return 1;
    }
    return 0;
}

/* Dungeon square of the group of the side being examined. */
#define GROUP_X()   H095_W(0x324 - H095_B(0x339) * 2)
#define GROUP_Y()   H095_W(0x328 - H095_B(0x339) * 2)
#define GROUP_DIR() H095_W(0x330 - H095_B(0x339) * 2)

/*
 * PORT H095+$1A7A: looks for a place for combatant n in a spiral around
 * the starting point of its side, ring after ring; when it leaves
 * the grid it moves to the next deployment (up to 3) towards a
 * direction without a wall.  0 if it finds no place.  Leaving the grid
 * without changing it the original checks an uninitialised byte: here 0.
 */
static u8 place_in_spiral(u16 n)
{
    u8 placed = 0;                      /* -$1(a5) */
    u8 first = 1;                       /* -$2(a5) */
    u8 failed = 0;                      /* -$3(a5) */
    u8 out;                             /* -$4(a5) */
    u8 blocked;                         /* -$5(a5) */
    u16 state = 1;                      /* -$8(a5) */
    s16 d;                              /* -$A(a5) */
    u16 dir;                            /* -$C(a5) */
    u16 k;                              /* -$E(a5) */
    s16 dx = 0;                         /* -$10(a5) */
    s16 dy = 0;                         /* -$12(a5) */
    s16 mx;                             /* -$14(a5) */
    s16 my;                             /* -$16(a5) */
    s16 ring = 0;                       /* -$18(a5) */
    s16 step = 0;                       /* -$1A(a5) */
    s16 gx;                             /* -$1C(a5) */
    s16 gy;                             /* -$1E(a5) */
    u16 side = 0;                       /* -$20(a5) */
    u16 set = 0;                        /* -$22(a5) */
    s16 bx = 0;                         /* -$24(a5) */
    s16 by = 0;                         /* -$26(a5) */
    s16 cx = 0;                         /* -$28(a5) */
    s16 cy = 0;                         /* -$2A(a5) */
    u16 sel;
    u16 e;

    /* H095_bss+$1E: (word) GROUP_X side 0: x of the party starting point; H095_bss+$9: side being
     * examined (0 party, 1 enemies): index into GROUP_* */
    gx = GROUP_X();
    /* H095_bss+$1A: (word) GROUP_Y side 0: y of the party starting point; H095_bss+$9: side being
     * examined (0 party, 1 enemies): index into GROUP_* */
    gy = GROUP_Y();
    do {
        /* H095_bss+$302: (word) dir*2 of the deployment: gdir 0..3 (step 8), set (step 2); H095_bss+$12:
         * (word) GROUP_DIR side 0: quarter of the party direction; H095_bss+$9: side being
         * examined (0 party, 1 enemies): index into GROUP_* */
        dir = (u16)((u16)H095_W(0x40 - GROUP_DIR() * 8 - set * 2) >> 1);
        switch (state) {
        case 1:
            /* H095_bss+$2FA: 4 words: direction 0..7 per quarter 0..3 (also facing) */
            e = (u16)H095_W(0x48 - ((dir + 2) & 3) * 2);
            dx = (s16)H005_W(0x3EE2 + e * 2); /* $3EE2: (word) x offset for direction d (step 2) */
            dy = (s16)H005_W(0x3ED0 + e * 2); /* $3ED0: (word) y offset for direction d (step 2) */
            sel = set > 0 ? 1 : 0;
            /* H095_bss+$2EA: (word) base x of the spiral: sel 0..1 (step 8), dir 0..3 (step 2) */
            bx = (s16)(H095_W(0x58 - sel * 8 - dir * 2) + dx * ring);
            /* H095_bss+$2DA: (word) base y of the spiral: sel 0..1 (step 8), dir 0..3 (step 2) */
            by = (s16)(H095_W(0x68 - sel * 8 - dir * 2) + dy * ring);
            cx = bx;
            cy = by;
            step = 1;
            state = 2;
            side = 1;
            break;
        case 2:
            /* H095_bss+$2FA: 4 words: direction 0..7 per quarter 0..3 (also facing) */
            e = (u16)H095_W(0x48 - ((dir + 1) & 3) * 2);
            dx = (s16)H005_W(0x3EE2 + e * 2); /* $3EE2: (word) x offset for direction d (step 2) */
            dy = (s16)H005_W(0x3ED0 + e * 2); /* $3ED0: (word) y offset for direction d (step 2) */
            cx = (s16)(dx * step + bx);
            cy = (s16)(dy * step + by);
            state = 3;
            ++side;
            break;
        case 3:
            /* H095_bss+$2FA: 4 words: direction 0..7 per quarter 0..3 (also facing) */
            e = (u16)H095_W(0x48 - ((dir + 3) & 3) * 2);
            dx = (s16)H005_W(0x3EE2 + e * 2); /* $3EE2: (word) x offset for direction d (step 2) */
            dy = (s16)H005_W(0x3ED0 + e * 2); /* $3ED0: (word) y offset for direction d (step 2) */
            cx = (s16)(dx * step + bx);
            cy = (s16)(dy * step + by);
            state = 2;
            ++step;
            ++side;
            break;
        default:
            break;
        }
        out = (u8)(cx < 0 || cy < 0 || cx > 0x0A || cy > 5);
        if (state > 1) {
            u8 next_ring;

            if (out && !outside_grid(cx, cy)) {
                next_ring = 1;
            } else if (first) {
                /* H095_bss+$16: 2 words per side: (combatants of the side+1)/2, first ring;
                 * H095_bss+$9: side being examined (0 party, 1 enemies): index into
                 * GROUP_* */
                next_ring = (u8)(side >= (u16)H095_W(0x32C - H095_B(0x339) * 2));
            } else {
                next_ring = (u8)(side > 0x0B);
            }
            if (next_ring) {
                ++ring;
                /* H095_bss+$9: side being examined (0 party, 1 enemies): index into GROUP_*;
                 * H095_bss+$12: (word) GROUP_DIR side 0: quarter of the party
                 * direction */
                if (H095_B(0x339) == 0 && (H095_W(0x330) & 1) && set == 0 &&
                    ring == 1) {
                    /* H095_bss+$1E: (word) GROUP_X side 0: x of the party starting point; H095_bss+$9: side being
                     * examined (0 party, 1 enemies): index into GROUP_*; $281C: (word) party x
                     * on the 16x16 area map */
                    mx = (s16)(GROUP_X() + H005_W(0x281C));
                    /* H095_bss+$1A: (word) GROUP_Y side 0: y of the party starting point; H095_bss+$9: side being
                     * examined (0 party, 1 enemies): index into GROUP_*; $281E: (word) party y
                     * on the 16x16 area map */
                    my = (s16)(GROUP_Y() + H005_W(0x281E));
                    blocked = 0;
                    for (k = 1; k <= 3; ++k) {
                        /* H095_bss+$322: (word) direction 0..7 of deployment k=1..3 per gdir (step 8); H095_bss+$12: (word)
                         * GROUP_DIR side 0: quarter of the party direction; H095_bss+$9: side being
                         * examined (0 party, 1 enemies): index into GROUP_* */
                        d = H095_W(0x20 - GROUP_DIR() * 8 - k * 2);
                        /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
                        if (H005_B(0x3DE3) == 3 ||
                            wall_between(mx, my, (u16)d) != 1) {
                            blocked = 1;
                        }
                    }
                    if (blocked) {
                        ++ring;
                    }
                }
                state = 1;
                first = 0;
            }
        }
        if (out && outside_grid(cx, cy)) {
            placed = 0;
            state = 0;
            while (set < 3 && state != 1) {
                ++set;
                /* H095_bss+$1E: (word) GROUP_X side 0: x of the party starting point; H095_bss+$9: side being
                 * examined (0 party, 1 enemies): index into GROUP_*; $281C: (word) party x on the
                 * 16x16 area map */
                mx = (s16)(GROUP_X() + H005_W(0x281C));
                /* H095_bss+$1A: (word) GROUP_Y side 0: y of the party starting point; H095_bss+$9: side being
                 * examined (0 party, 1 enemies): index into GROUP_*; $281E: (word) party y on the
                 * 16x16 area map */
                my = (s16)(GROUP_Y() + H005_W(0x281E));
                /* H095_bss+$322: (word) direction 0..7 of deployment k=1..3 per gdir (step 8);
                 * H095_bss+$12: (word) GROUP_DIR side 0: quarter of the party direction;
                 * H095_bss+$9: side being examined (0 party, 1 enemies): index into GROUP_* */
                d = H095_W(0x20 - GROUP_DIR() * 8 - set * 2);
                /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
                if (H005_B(0x3DE3) == 3 || wall_between(mx, my, (u16)d) != 1) {
                    /* H095_bss+$1E: (word) GROUP_X side 0: x of the party starting point; H095_bss+$9: side being
                     * examined (0 party, 1 enemies): index into GROUP_*; $3EE2: (word) x offset
                     * for direction d (step 2) */
                    gx = (s16)(GROUP_X() + H005_W(0x3EE2 + d * 2));
                    /* H095_bss+$1A: (word) GROUP_Y side 0: y of the party starting point; H095_bss+$9: side being
                     * examined (0 party, 1 enemies): index into GROUP_*; $3ED0: (word) y offset
                     * for direction d (step 2) */
                    gy = (s16)(GROUP_Y() + H005_W(0x3ED0 + d * 2));
                    ring = 0;
                    state = 1;
                }
            }
            if (state != 1) {
                failed = 1;
            }
        }
        if (!out) {
            placed = try_place(n, cx, cy, gx, gy, set);
        }
    } while (!placed && !failed);
    return (u8)(failed ? 0 : 1);
}

/*
 * PORT H095+$1FC2: deploys the combatants: starting points of the two sides
 * (the party where it is, the enemies at $3E00+$582 squares in the direction
 * of the party), deployment grids from the tables -$E0, then every
 * character in a spiral.  The fallen leave a body ($2AE2); whoever finds
 * no place and is out of combat (+$15) leaves the party (H053).
 * Beyond 8 bodies they are not recorded (the original would write over the
 * combatants).
 */
static void deploy_combatants(void)
{
    u16 skipped = 0;                    /* -$16(a5) */
    u16 placed = 0;                     /* -$14(a5) */
    u16 i;                              /* -$E(a5) */
    u16 set;                            /* -$10(a5) */
    u16 shape;                          /* -$12(a5) */
    s16 r;                              /* -$4(a5) */
    s16 c;                              /* -$2(a5) */
    s16 x;
    s16 y;
    Character *prev;                    /* -$8(a5) */
    Character *p;                       /* -$C(a5) */
    CokBody *b;

    count_sides();
    for (i = 1; i <= 0x28; ++i) {
        /* $3159: combatant positions +5: shape/size (0 = off the map) */
        H005_B(0x3154 + (i - 1) * 6 + 5) = 0;
    }
    rebuild_occupancy();
    H095_SETW(0x324, 0); /* H095_bss+$1E: (word) GROUP_X side 0: x of the party starting point */
    H095_SETW(0x328, 0); /* H095_bss+$1A: (word) GROUP_Y side 0: y of the party starting point */
    /* $2820: party direction (0 north, 2 east, 4 south, 6 west); H095_bss+$12: (word) GROUP_DIR
     * side 0: quarter of the party direction */
    H095_SETW(0x330, H005_B(0x2820) >> 1);
    /* $3EE2: (word) x offset for direction d (step 2); $2820: party direction (0 north, 2 east, 4
     * south, 6 west); B+$582: (word) current distance of the enemies, limited to the free squares;
     * H095_bss+$1E: (word) GROUP_X side 0: x of the party starting point; H095_bss+$20: (word)
     * GROUP_X side 1: x of the enemies' starting point */
    H095_SETW(0x322, (s16)H005_W(0x3EE2 + H005_B(0x2820) * 2) *
                     (s16)COK_GET16(g_state_b + 0x582) + H095_W(0x324));
    /* $3ED0: (word) y offset for direction d (step 2); $2820: party direction (0 north, 2 east, 4
     * south, 6 west); B+$582: (word) current distance of the enemies, limited to the free squares;
     * H095_bss+$1A: (word) GROUP_Y side 0: y of the party starting point; H095_bss+$1C: (word)
     * GROUP_Y side 1: y of the enemies' starting point */
    H095_SETW(0x326, (s16)H005_W(0x3ED0 + H005_B(0x2820) * 2) *
                     (s16)COK_GET16(g_state_b + 0x582) + H095_W(0x328));
    /* $2820: party direction (0 north, 2 east, 4 south, 6 west); H095_bss+$14: (word) GROUP_DIR
     * side 1: quarter of the enemies' direction */
    H095_SETW(0x32E, ((H005_B(0x2820) + 4) & 7) >> 1);
    /* H095_bss+$9: side being examined (0 party, 1 enemies): index into GROUP_* */
    for (H095_B(0x339) = 0; H095_B(0x339) <= 1; ++H095_B(0x339)) {
        /* $2A1C: active combatants of side 0; byte table indexed by side; H095_bss+$9: side being
         * examined (0 party, 1 enemies): index into GROUP_*; H095_bss+$16: 2 words per side:
         * (combatants of the side+1)/2, first ring */
        H095_SETW(0x32C - H095_B(0x339) * 2,
                  (H005_B(0x2A1C + H095_B(0x339)) + 1) >> 1);
    }
    /* H095_bss+$9: side being examined (0 party, 1 enemies): index into GROUP_* */
    for (H095_B(0x339) = 0; H095_B(0x339) <= 1; ++H095_B(0x339)) {
        for (set = 0; set <= 3; ++set) {
            /* H095_bss+$12: (word) GROUP_DIR side 0: quarter of the party direction;
             * H095_bss+$9: side being examined (0 party, 1 enemies): index into
             * GROUP_* */
            shape = (set == 1) ? 4 : (u16)GROUP_DIR();
            for (r = 0; r <= 5; ++r) {
                for (c = 0; c <= 0x0A; ++c) {
                    /* H095_bss+$262: (word) minimum column: shape 0..4 (step $18), row 0..5
                     * (step 4) */
                    if (c < H095_W(0xE0 - shape * 0x18 - r * 4) ||
                        /* H095_bss+$264: (word) maximum column: shape 0..4 (step $18), row 0..5
                         * (step 4) */
                        c > H095_W(0xE0 - shape * 0x18 - r * 4 - 2)) {
                        /* H095_bss+$22: deployment grids: side*$120+set*$48+row*$C+col, 1=free; H095_bss+$9: side
                         * being examined (0 party, 1 enemies): index into GROUP_* */
                        PLACE_TABLE(H095_B(0x339), set, r, c) = 0;
                    } else {
                        /* H095_bss+$22: deployment grids: side*$120+set*$48+row*$C+col, 1=free; H095_bss+$9: side
                         * being examined (0 party, 1 enemies): index into GROUP_* */
                        PLACE_TABLE(H095_B(0x339), set, r, c) = 1;
                    }
                }
            }
        }
    }
    i = 1;
    H005_B(0x247B) = 1; /* $247B: number of combatants in the table +$2B32 (+1 after deployment) */
    prev = g_party_head;
    p = g_party_head;
    while (p != NULL) {
        g_combatants[i - 1] = p;
        /* H095_bss+$9: side being examined (0 party, 1 enemies): index into GROUP_*; ch+$199:
         * side in combat (0 party, 1 opponents) */
        H095_B(0x339) = p->b[0x199];
        /* $3158: combatant positions +4: combatant number (byte) */
        H005_B(0x3154 + (i - 1) * 6 + 4) = (u8)i;
        /* $3159: combatant positions +5: shape/size (0 = off the map); ch+$D3: shape/size on
         * the combat map (bits 0-2, >1 large) */
        H005_B(0x3154 + (i - 1) * 6 + 5) = mask_byte(p->b[0xD3], 7);
        if (place_in_spiral(i)) {
            prev = p;
            if (p->b[0x198] == 0) { /* ch+$198: active/standing (0 down or out of the combat) */
                /* $3159: combatant positions +5: shape/size (0 = off the map) */
                H005_B(0x3154 + (i - 1) * 6 + 5) = 0;
                /* $24C1: use: cleared at start-up; with 1 outcome and fallen handled differently; turn+$15: 1 =
                 * combatant beyond the party members, leaves it at the end of the fight */
                if (!H005_B(0x24C1) && p->block_192->b[0x15] == 0) {
                    /* $3154: combatant positions, 6 bytes per n (from 1): +0 column (word) */
                    x = (s16)H005_W(0x3154 + (i - 1) * 6);
                    /* $3156: combatant positions +2: row on the map (word) */
                    y = (s16)H005_W(0x3154 + (i - 1) * 6 + 2);
                    if (H005_B(0x247A) < 8) { /* $247A: number of bodies in the table +$2AE2 (max 8) */
                        /* $247A: number of bodies in the table +$2AE2 (max 8) */
                        add_to_byte(&H005_B(0x247A), 1);
                        /* $247A: number of bodies in the table +$2AE2 (max 8) */
                        b = &g_bodies[H005_B(0x247A) - 1];
                        b->tile = map_cell(x, y)[1];
                        map_cell(x, y)[1] = 0x1F;
                        b->who = p;
                        b->x = (u16)x;
                        b->y = (u16)y;
                    }
                }
            }
            /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
            if (p->b[0x197] == 9) {
                p->b[0x198] = 0; /* ch+$198: active/standing (0 down or out of the combat) */
                /* $3159: combatant positions +5: shape/size (0 = off the map) */
                H005_B(0x3154 + (i - 1) * 6 + 5) = 0;
            }
            rebuild_occupancy();
            ++i;
            /* $247B: number of combatants in the table +$2B32 (+1 after deployment) */
            add_to_byte(&H005_B(0x247B), 1);
            ++placed;
        } else {
            /* $3159: combatant positions +5: shape/size (0 = off the map) */
            H005_B(0x3154 + (i - 1) * 6 + 5) = 0;
            /* turn+$15: 1 = combatant beyond the party members, leaves it at the end of the fight */
            if (p->block_192->b[0x15] == 1) {
                ++skipped;
                g_combatants[i - 1] = NULL;
                g_current_char = p;
                remove_from_party(1, 0);
                p = prev;
            } else {
                prev = p;
                ++i;
                /* $247B: number of combatants in the table +$2B32 (+1 after deployment) */
                add_to_byte(&H005_B(0x247B), 1);
            }
        }
        p = p->next;
    }
    prev->next = NULL;
    (void)skipped;
    (void)placed;
}

/*
 * PORT H095+$2496: start of the combat: frees the pictures of the
 * map, "A battle begins...", clears the combat state (clouds,
 * pools, bodies, lost weapons), builds the map, prepares the turns,
 * deploys the combatants, allocates the icons ($243A, 4 frames 24x24),
 * centres the view on the first, draws, copies the colours into the off-screen
 * View, events 8 and $16 for everyone and enemy strength; then context 5.
 */
void start_combat(void)
{
    Character *p;                       /* -$10(a5) */

    H005_B(0x24CE) = 0; /* $24CE: 1: per-character pause when writing text */
    free_gfx_record(&g_gfx_27b0[0]);
    free_gfx_record(&g_gfx_27b0[1]);
    free_gfx_record(&g_gfx_2798);
    H005_B(0x2484) = 0xFF; /* $2484: id of the loaded BIGPIC big picture ($FF none) */
    H005_B(0x27B0) = 0xFF; /* $27B0: 2 entries of 6 bytes (id + long gfx at +2): loaded HEAD id, $FF none */
    H005_B(0x27B6) = 0xFF; /* $27B6: id of the loaded BODY (2nd 6-byte entry of $27B0), $FF none */
    clear_message_line();
    message_delay();
    ui_draw_text(0, 0x18, 0x0A, 0, 0x12, "A battle begins...");
    H005_B(0x24A0) = 0; /* $24A0: Magic On/Off (key 2): characters on automatic cast spells */
    H005_B(0x24AF) = 0; /* $24AF: use: cleared at the start of combat; if 1 effect $43 does not act */
    H005_B(0x247C) = 0; /* $247C: combat round number (0 at the start; bit 0 rounds) */
    H005_B(0x2477) = 0x0F; /* $2477: limit round of the combat (+$247C + 15) */
    H005_SET_W(0x2A1A, 0); /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
    H005_B(0x247A) = 0; /* $247A: number of bodies in the table +$2AE2 (max 8) */
    g_clouds = NULL;                    /* $2514 */
    g_acid_pools = NULL;                /* $250C */
    H005_SET_L(0x2510, 0); /* $2510: use: (long) cleared at the start of combat next to $250C/$2514 */
    g_h005_2432 = NULL;
    g_thrown_tail = NULL;               /* $335C */
    g_dropped_items = NULL;             /* $3360 */
    memset(g_bodies, 0, sizeof g_bodies);   /* H029+$0312 on $50 bytes */
    COK_PUT16(g_state_b + 0x666, 0); /* B+$666: (word) 1 if the attack on an ally was confirmed */
    build_combat_map();
    prepare_turn_blocks();
    p = g_party_head;
    deploy_combatants();
    allocate_gfx_record(0x18, 3, 4, 1, &g_gfx_243a);
    COK_PUT16(g_combat_area + 2, (u16)(combatant_x(g_party_head) - 3));
    COK_PUT16(g_combat_area + 4, (u16)(combatant_y(g_party_head) - 3));
    redraw_combat_screen();
    copy_intuition_colors();
    for (p = g_party_head; p != NULL; p = p->next) {
        p->block_192->b[0x13] = 0; /* turn+$13: Turn Undead already used in the combat (max H005+$248F) */
        trigger_event(&p, 8);
        trigger_event(&p, 0x16);
    }
    enemy_strength();
    H005_B(0x24CB) = 0; /* $24CB: 1 in Move/Attack mode: cursor on the combat map */
    H005_B(0x24CC) = 0; /* $24CC: 1 in Manual mode: cursor on the combat map */
    H005_B(0x3DE3) = 5; /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    H005_B(0x24B0) = 0; /* $24B0: Move mode of the exploration: click on the view as movement */
    memset(g_h005_0016, 0, sizeof g_h005_0016); /* H029+$0312 on $50 bytes */
    H005_SET_W(0x14, 0); /* $14: number of characters on the ground in the list +$16 (word, max 20) */
}
