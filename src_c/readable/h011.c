/* H011: module data (tables of words and bytes). */
#include "init_data.h"
#include "h011.h"
#include "h003_exec.h"
#include "h022_view.h"
#include "globals.h"
#include "h029_gfx.h"
#include "h010_input.h"
#include "h016_gfx.h"
#include "h026_string.h"
#include "h028_files.h"
#include "h034.h"
#include "h038.h"
#include "h045.h"
#include "h049.h"
#include <string.h>

/* Module data below a4: g_h011_bss[0xAC - off] is -off(a4). */
u8 g_h011_bss[0xAC];

#include "h011_init_data.h"

/* PORT H011+$00FE */
void h011_init(void)
{
    INIT_APPLY(s_init_1a02, g_h011_bss, sizeof(g_h011_bss));
}

/*
 * PORT H011+$010C: copies the palette of H005+$52AE into -$AC(a4), sets the
 * colours 17..19 to $AAA, $555, $FFF and loads the first 20 colours.
 */
void load_game_palette(void)
{
    /* $52AE: current screen palette, RGB4 (16 or 32 colours) */
    exec_copy_mem(&g_h005[0x52AE], g_h011_bss, 0x40);
    /* H011_bss+$22: (word) colour 17 of the game palette ($AAA) */
    COK_PUT16(&g_h011_bss[0xAC - 0x8A], 0x0AAA);
    /* H011_bss+$24: (word) colour 18 of the game palette ($555) */
    COK_PUT16(&g_h011_bss[0xAC - 0x88], 0x0555);
    /* H011_bss+$26: (word) colour 19 of the game palette ($FFF) */
    COK_PUT16(&g_h011_bss[0xAC - 0x86], 0x0FFF);
    graphics_load_rgb4(&g_screen->ViewPort, g_h011_bss, 0x14);
}

/* PORT H011+$0162: is (x, y) inside the 16x16 map? */
static u8 map_inside(s16 x, s16 y)
{
    if (x > 0x0F || x < 0 || y > 0x0F || y < 0) {
        return 0;
    }
    return 1;
}

/*
 * Common prologue of H011+$01AA/$04E2/$09C8: outside the map, with
 * $2498 = 0 or $A, 0; otherwise the coordinates wrap around (16 -> 0,
 * -1 -> 15).
 */
static u8 map_wrap(s16 *x, s16 *y)
{
    /* $2498: id of the ECL program of the current area ($24 initial, $39 demo) */
    if (!map_inside(*x, *y) && (H005_B(0x2498) == 0 || H005_B(0x2498) == 0x0A)) {
        return 0;
    }
    if (*x > 0x0F) {
        *x = 0;
    } else if (*x < 0) {
        *x = 0x0F;
    }
    if (*y > 0x0F) {
        *y = 0;
    } else if (*y < 0) {
        *y = 0x0F;
    }
    return 1;
}

/*
 * PORT H011+$01AA (Map_QueryWall): wall on side dir (0, 2, 4, 6) of the
 * square (x, y): nibbles of GEO planes 0 and 1.  With an odd dir
 * the original returns an uninitialised word: here 0.
 */
u16 map_wall(s16 x, s16 y, u16 dir)
{
    u16 r = 0;                          /* -$2(a5) */
    u8 b;

    if (!map_wrap(&x, &y)) {
        return 0;
    }
    switch (dir) {
    case 0:
        b = g_geo_planes[y * 16 + x];
        r = (u8)(mask_byte(b, 0xF0) >> 4);
        break;
    case 2:
        b = g_geo_planes[y * 16 + x];
        r = mask_byte(b, 0x0F);
        break;
    case 4:
        b = g_geo_planes[0x100 + y * 16 + x];
        r = (u8)(mask_byte(b, 0xF0) >> 4);
        break;
    case 6:
        b = g_geo_planes[0x100 + y * 16 + x];
        r = mask_byte(b, 0x0F);
        break;
    default:
        break;
    }
    return r;
}

/* PORT H011+$04E2: byte of GEO plane 2 of the square (x, y). */
u8 map_flags(s16 x, s16 y)
{
    if (!map_wrap(&x, &y)) {
        return 0;
    }
    return g_geo_planes[0x200 + y * 16 + x];
}

/*
 * PORT H011+$09C8: door on side dir of the square (x, y): pair of
 * bits of GEO plane 3 if there is a wall, otherwise 1.
 */
u16 map_door(s16 x, s16 y, u16 dir)
{
    u16 r = 1;                          /* -$2(a5) */
    u8 b;

    if (!map_wrap(&x, &y)) {
        return 0;
    }
    if (map_wall(x, y, dir) > 0) {
        b = g_geo_planes[0x300 + y * 16 + x];
        switch (dir) {
        case 0:
            r = mask_byte(b, 3);
            break;
        case 2:
            r = (u8)(mask_byte(b, 0x0C) >> 2);
            break;
        case 4:
            r = (u8)(mask_byte(b, 0x30) >> 4);
            break;
        case 6:
            r = (u8)(mask_byte(b, 0xC0) >> 6);
            break;
        default:
            break;
        }
    }
    return r;
}

/*
 * PORT H011+$04A6: stores the four view start bytes
 * ($2829..$2826, first argument in $2829).
 */
void set_view_start(u16 a, u16 b, u16 c, u16 d)
{
    H005_B(0x2829) = (u8)a; /* $2829: sky colour of the view (1st view start byte) */
    H005_B(0x2828) = (u8)b; /* $2828: use: 2nd view start byte (arg b of H011+$04A6) */
    H005_B(0x2827) = (u8)c; /* $2827: use: 3rd view start byte (arg c of H011+$04A6) */
    H005_B(0x2826) = (u8)d; /* $2826: use: 4th view start byte (arg d of H011+$04A6), 8 in the dungeon */
}

/* Word tables of the module: H011_W(-off) is -off(a4). */
#define H011_W(off) ((s16)COK_GET16(&g_h011_bss[0xAC - (off)]))
#define VIEW_X(k)   H011_W(0x58 - (k) * 2)  /* column of piece k */
#define VIEW_Y(k)   H011_W(0x6C - (k) * 2)  /* row of piece k */
#define DX(d)       ((s16)H005_W(0x3EE2 + (d) * 2))  /* $3EE2: (word) x offset for direction d (step 2) */
#define DY(d)       ((s16)H005_W(0x3ED0 + (d) * 2))  /* $3ED0: (word) y offset for direction d (step 2) */

/*
 * PORT H011+$14EA (Load_WallDefinitions): loads block id of
 * WALLDEFn.dax into the positions from slot (1..3) of the buffer $282E (blocks
 * of $30C bytes: five walls of $9C tiles); the tiles from $3EBC up
 * are moved to the set of the position and the 8x8 sets are loaded
 * (id*10+k if the block contains more than one).  $2810 remembers id and
 * position.
 */
void load_wall_defs(u16 id, u16 slot)
{
    char num[0x12];                     /* -$18(a5) */
    char name[0x52];                    /* -$6A(a5) */
    char err[0x52];                     /* -$BC(a5) */
    u16 size = 0;                       /* -$2(a5) */
    u8 *buf = NULL;                     /* -$6(a5) */
    u16 pos;                            /* -$8(a5) */
    s16 base;                           /* -$A(a5) */
    u16 j;                              /* -$C(a5) */
    u16 k;                              /* -$E(a5) */
    u16 t;                              /* -$10(a5) */
    u16 n;                              /* -$12(a5) */
    u16 s;
    u8 *b;

    if (slot < 1 || slot > 3) {
        return;
    }
    /* $246E: data disk / current resource group (G_RESOURCE_GROUP) */
    format_number(4, num, (s32)H005_B(0x246E), 0, 0x0A, 1, '0');
    strcpy(name, "WALLDEF");
    h026_append(0x50, name, 4, num);
    dax_load_block(0x50, name, 4, ".dax", id, &size, &buf);
    if (size == 0 || (u16)(size / 0x30C + slot) > 4) {
        strcpy(err, "Unable to load ");
        format_number(4, num, (s32)id, 0, 0x0A, 4, '0');
        h026_append(0x50, err, 4, num);
        h026_append(0x50, err, 6, " from ");
        h026_append(0x50, err, 0x50, name);
        console_writeln(0x50, err);
        wait_for_key();
        quit_game();
    }
    /* $3EC6: (word) tile base per wall slot (slot 1..3, step 2); $3EC8: (word) tile base of wall
     * slot 1 (subtracted from the others) */
    base = (s16)(H005_W(0x3EC6 + slot * 2) - H005_W(0x3EC8));
    pos = 0;
    k = 1;
    do {
        exec_copy_mem(buf + pos,
                      g_h005_282e + (s32)(s16)(slot + k - 2) * 0x30C, 0x30C);
        pos = (u16)(pos + 0x30C);
        ++k;
    } while (pos < (u16)(size - 0x100));
    exec_free_mem(buf, size);
    n = (u16)(k - 1);
    for (k = 1; k <= n; ++k) {
        s = (u16)(k + slot - 1);
        if (s == 0 || s >= 4) {
            continue;
        }
        /* $2810: tab. of 3 4-byte entries of the wall sets: word WALLDEF id, $FFFF empty */
        H005_SET_W(0x2810 + (s - 1) * 4, 0xFFFF);
        /* $2812: word +2 of the $2810 entries: position (slot 1..3), $FFFF empty */
        H005_SET_W(0x2812 + (s - 1) * 4, 0xFFFF);
        for (j = 1; j <= 5; ++j) {
            for (t = 0; t <= 0x9B; ++t) {
                b = &g_h005_282e[(s - 1) * 0x30C + (j - 1) * 0x9C + t];
                /* $3EBC: (word) first wall tile to move to the set of the slot */
                if (*b >= H005_W(0x3EBC)) {
                    *b = (u8)(*b + base);
                }
            }
        }
        if (n > 1) {
            load_8x8_set((u8)(id * 10 + k), (u8)s);
        } else {
            load_8x8_set((u8)id, (u8)s);
        }
    }
    /* $2810: tab. of 3 4-byte entries of the wall sets: word WALLDEF id, $FFFF empty */
    H005_SET_W(0x2810 + (slot - 1) * 4, id);
    /* $2812: word +2 of the $2810 entries: position (slot 1..3), $FFFF empty */
    H005_SET_W(0x2812 + (slot - 1) * 4, slot);
}

/*
 * PORT H011+$1876 (Load3DMap_GEO): loads map id of GEOn.dax: the
 * four planes of $100 bytes (after 2 header bytes) into $282A, and
 * records it in $3E04+$18A.
 */
void load_geo_map(u16 id)
{
    char num[0x0A];                     /* -$5C(a5) */
    char name[0x52];                    /* -$52(a5) */
    u16 size = 0;                       /* -$54(a5) */
    u8 *buf = NULL;                     /* -$58(a5) */
    u16 pos;                            /* -$5A(a5) */

    /* $246E: data disk / current resource group (G_RESOURCE_GROUP) */
    format_number(1, num, (s32)H005_B(0x246E), 0, 0x0A, 1, '0');
    strcpy(name, "GEO");
    h026_append(0x50, name, 1, num);
    dax_load_block(0x50, name, 4, ".dax", id, &size, &buf);
    if (size == 0) {
        console_writeln(0x20, "Unable to load geo in Load3DMap.");
        wait_for_key();
        quit_game();
    }
    pos = 2;
    exec_copy_mem(buf + pos, g_geo_planes, 0x100);
    pos = (u16)(pos + 0x100);
    exec_copy_mem(buf + pos, g_geo_planes + 0x100, 0x100);
    pos = (u16)(pos + 0x100);
    exec_copy_mem(buf + pos, g_geo_planes + 0x200, 0x100);
    pos = (u16)(pos + 0x100);
    exec_copy_mem(buf + pos, g_geo_planes + 0x300, 0x100);
    exec_free_mem(buf, size);
    COK_PUT16(g_state_a + 0x18A, id); /* A+$18A: (word) id of the loaded GEO map (reloaded on Load) */
}

/*
 * PORT H011+$0330: top-down 11x11 map around the party (the window
 * stays inside the 16x16 map): for every square tile $104 + the walls
 * (N 1, E 2, S 4, W 8), then the party with tile $100 + dir/2.
 */
static void draw_area_map(s16 x, s16 y, u16 dir)
{
    s16 left;                           /* -$A(a5) */
    s16 top;                            /* -$C(a5) */
    s16 px;                             /* -$2(a5) */
    s16 py;                             /* -$4(a5) */
    s16 row;                            /* -$8(a5) */
    s16 col;                            /* -$6(a5) */
    u16 id;                             /* -$12(a5) */

    left = (s16)(x - 5);
    if (left < 0) left = 0;
    if (left > 5) left = 5;
    px = (s16)(x - left);
    top = (s16)(y - 5);
    if (top < 0) top = 0;
    if (top > 5) top = 5;
    py = (s16)(y - top);
    for (row = 0; row <= 0x0A; ++row) {
        for (col = 0; col <= 0x0A; ++col) {
            s16 mx = (s16)(col + left);  /* -$E(a5) */
            s16 my = (s16)(row + top);   /* -$10(a5) */

            id = 0x104;
            if (map_wall(mx, my, 0) > 0) id = (u16)(id + 1);
            if (map_wall(mx, my, 2) > 0) id = (u16)(id + 2);
            if (map_wall(mx, my, 4) > 0) id = (u16)(id + 4);
            if (map_wall(mx, my, 6) > 0) id = (u16)(id + 8);
            draw_8x8_tile((u16)(col + 3), (u16)(row + 3), id, 0, 0);
        }
    }
    draw_8x8_tile((u16)(px + 3), (u16)(py + 3), (u16)((dir >> 1) + 0x100),
                  0, 0);
}

/* Draws one of the "sky" pictures masked in the cell (cx, cy). */
static void blit_sky(struct GfxRecord *rec, s16 cx, s16 cy)
{
    graphics_blt_mask_bitmap_rastport(rec->image, 0, 0, &g_screen->RastPort,
                                      (u16)(cx * 8 + 0x18),
                                      (u16)(cy * 8 + 0x18),
                                      (u16)(rec->count * 8), rec->rows, 0xE0,
                                      (u8 *)rec->mask->Planes[0]);
}

/*
 * PORT H011+$058E: background of the view: sky of colour $2829; outdoors
 * by day (colour $B, square without bit 7) the sun according to the hour
 * ($3E04+$192) and the direction, and towards north the picture $280C; finally the
 * floor ($2804).
 */
static void draw_view_background(void)
{
    s16 e = 0x3E7;                      /* -$E(a5) */
    s16 f = 0;                          /* -$10(a5) */
    s16 h;                              /* -$2(a5) */

    /* $2829: sky colour of the view (1st view start byte) */
    graphics_set_apen(g_rastport, H005_B(0x2829));
    graphics_rect_fill(g_rastport, 0x17, 0x17, 0x70, 0x50);
    /* $281C: (word) party x on the 16x16 area map; $281E: (word) party y on the 16x16 area map */
    if (map_flags((s16)H005_W(0x281C), (s16)H005_W(0x281E)) < 0x80 &&
        H005_B(0x2829) == 0x0B) { /* $2829: sky colour of the view (1st view start byte) */
        h = (s16)COK_GET16(g_state_a + 0x192); /* A+$192: (word) hours of the game time */
        switch (h) {
        case 1: case 2: case 3: case 4: case 5:
            switch (H005_B(0x2820)) { /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
            case 2:
                e = (s16)(0x0A - 3);
                f = (s16)(2 + 5 - h);
                break;
            case 4:
                if (h > 2) {
                    e = (s16)(0 + h - 3);
                    f = (s16)(2 + 5 - h);
                }
                break;
            default:
                break;
            }
            break;
        case 0x0D: case 0x0E: case 0x0F: case 0x10: case 0x11: case 0x12:
            switch (H005_B(0x2820)) { /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
            case 6:
                e = 0;
                f = (s16)(2 + h - 0x0D);
                break;
            case 4:
                if (h < 0x10) {
                    e = (s16)(0 + h - 8);
                    f = (s16)(2 + h - 0x0D);
                }
                break;
            default:
                break;
            }
            break;
        default:
            break;
        }
        if (e != 0x3E7) {
            blit_sky(g_gfx_sky_2808, e, f);
        }
        if (H005_B(0x2820) == 0) { /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
            blit_sky(g_gfx_sky_280c, 0, 2);
        }
    }
    (void)graphics_blt_bitmap(g_gfx_sky_2804->image, 0, 3,
                              g_screen->RastPort.BitMap, 0x18, 0x43, 0x58,
                              0x2D, 0xC0, 0xFF, NULL);
}

/*
 * PORT H011+$0868: piece kind (0..9) of wall wall at the cell (x, y)
 * of the 11x11 view: the wall tiles (blocks of $9C from $282E, from the
 * position of the table -$1C) for a rectangle -$30[kind] wide and
 * -$44[kind] high; the cells outside the view are skipped, tile 0 is
 * transparent.
 */
static void draw_wall_piece(s16 x, s16 y, u16 wall, u16 kind)
{
    s16 tile;                           /* -$A(a5) */
    s16 x_end;                          /* -$2(a5) */
    s16 y_end;                          /* -$4(a5) */
    s16 set;                            /* -$C(a5) */
    s16 sub;                            /* -$E(a5) */
    s16 r;                              /* -$8(a5) */
    s16 c;                              /* -$6(a5) */
    u8 b;

    tile = H011_W(0x1C - kind * 2); /* H011_bss+$90: table of 10 words: first tile of piece kind 0..9 */
    /* H011_bss+$7C: table of 10 words: width in tiles of piece kind 0..9 */
    x_end = (s16)(H011_W(0x30 - kind * 2) + x - 1);
    /* H011_bss+$68: table of 10 words: height in tiles of piece kind 0..9 */
    y_end = (s16)(H011_W(0x44 - kind * 2) + y - 1);
    set = (s16)(wall / 5 + 1);
    sub = (s16)(wall % 5);
    for (r = y; r <= y_end; ++r) {
        for (c = x; c <= x_end; ++c) {
            if (r >= 0 && r <= 0x0A && c >= 0 && c <= 0x0A) {
                b = g_h005_282e[(s32)(set - 1) * 0x30C + (s32)(sub - 1) * 0x9C +
                                tile];
                if (b > 0) {
                    draw_8x8_tile_masked((u16)(c + 3), (u16)(r + 3), b,
                                         g_screen->RastPort.BitMap,
                                         g_8x8_sets);
                }
            }
            ++tile;
        }
    }
}

/* Cells at distance 2: front walls, joints (9) and sides (1, 2). */
static void draw_view_far(s16 vx, s16 vy, u16 dir, u16 left, u16 right)
{
    s16 px;                             /* -$12(a5) */
    s16 py;                             /* -$14(a5) */
    u16 i;                              /* -$16(a5) */
    s16 off;                            /* -$18(a5) */
    u16 prev;                           /* -$20(a5) */
    u16 w;                              /* -$1A(a5) */

    px = vx; py = vy; i = 0; off = 0; prev = 0;
    while (i < 4) {
        w = map_wall(px, py, dir);
        if (!map_inside(px, py) && map_wall(px, py, right) == 0) {
            prev = 0;
        }
        if (w) {
            if (prev > 0) {
                /* H011_bss+$66: (word) VIEW_X(9): column of wall piece 9 in the view; H011_bss+$52:
                 * (word) VIEW_Y(9): row of wall piece 9 in the view */
                draw_wall_piece((s16)(VIEW_X(9) + off + 1), VIEW_Y(9), prev, 9);
            }
            prev = w;
            /* H011_bss+$54: (word) VIEW_X(0): column of wall piece 0 in the view; H011_bss+$40:
             * (word) VIEW_Y(0): row of wall piece 0 in the view */
            draw_wall_piece((s16)(VIEW_X(0) + off), VIEW_Y(0), w, 0);
        } else {
            if (prev > 0 &&
                /* $3EE2: (word) x offset for direction d (step 2); $3ED0: (word) y offset for
                 * direction d (step 2) */
                map_wall((s16)(px - DX(left)), (s16)(py - DY(left)), left)) {
                /* H011_bss+$66: (word) VIEW_X(9): column of wall piece 9 in the view; H011_bss+$52:
                 * (word) VIEW_Y(9): row of wall piece 9 in the view */
                draw_wall_piece((s16)(VIEW_X(9) + off + 1), VIEW_Y(9), prev, 9);
            }
            prev = 0;
        }
        ++i;
        off = (s16)(off - 2);
        px = (s16)(px + DX(left)); /* $3EE2: (word) x offset for direction d (step 2) */
        py = (s16)(py + DY(left)); /* $3ED0: (word) y offset for direction d (step 2) */
    }
    px = vx; py = vy; i = 0; off = 0; prev = 0;
    while (i < 4) {
        w = map_wall(px, py, dir);
        if (!map_inside(px, py) && map_wall(px, py, left) == 0) {
            prev = 0;
        }
        if (w) {
            if (prev > 0) {
                /* H011_bss+$66: (word) VIEW_X(9): column of wall piece 9 in the view; H011_bss+$52:
                 * (word) VIEW_Y(9): row of wall piece 9 in the view */
                draw_wall_piece((s16)(VIEW_X(9) + off - 1), VIEW_Y(9), prev, 9);
            }
            prev = w;
            /* H011_bss+$54: (word) VIEW_X(0): column of wall piece 0 in the view; H011_bss+$40:
             * (word) VIEW_Y(0): row of wall piece 0 in the view */
            draw_wall_piece((s16)(VIEW_X(0) + off), VIEW_Y(0), w, 0);
        } else {
            if (prev > 0 &&
                /* $3EE2: (word) x offset for direction d (step 2); $3ED0: (word) y offset for
                 * direction d (step 2) */
                map_wall((s16)(px - DX(right)), (s16)(py - DY(right)), right)) {
                /* H011_bss+$66: (word) VIEW_X(9): column of wall piece 9 in the view; H011_bss+$52:
                 * (word) VIEW_Y(9): row of wall piece 9 in the view */
                draw_wall_piece((s16)(VIEW_X(9) + off - 1), VIEW_Y(9), prev, 9);
            }
            prev = 0;
        }
        ++i;
        off = (s16)(off + 2);
        px = (s16)(px + DX(right)); /* $3EE2: (word) x offset for direction d (step 2) */
        py = (s16)(py + DY(right)); /* $3ED0: (word) y offset for direction d (step 2) */
    }
    px = vx; py = vy; i = 0; off = 0;
    while (i < 3) {
        w = map_wall(px, py, left);
        if (w) {
            if (i == 0) {
                /* H011_bss+$56: (word) VIEW_X(1): column of wall piece 1 in the view; H011_bss+$42:
                 * (word) VIEW_Y(1): row of wall piece 1 in the view */
                draw_wall_piece((s16)(VIEW_X(1) + off), VIEW_Y(1), w, 1);
            } else {
                /* H011_bss+$56: (word) VIEW_X(1): column of wall piece 1 in the view; H011_bss+$42:
                 * (word) VIEW_Y(1): row of wall piece 1 in the view */
                draw_wall_piece((s16)(VIEW_X(1) + off - 1), VIEW_Y(1), w, 1);
            }
        }
        ++i;
        off = (s16)(off - 2);
        px = (s16)(px + DX(left)); /* $3EE2: (word) x offset for direction d (step 2) */
        py = (s16)(py + DY(left)); /* $3ED0: (word) y offset for direction d (step 2) */
    }
    px = vx; py = vy; i = 0; off = 0;
    while (i < 3) {
        w = map_wall(px, py, right);
        if (w) {
            if (i == 0) {
                /* H011_bss+$58: (word) VIEW_X(2): column of wall piece 2 in the view; H011_bss+$44:
                 * (word) VIEW_Y(2): row of wall piece 2 in the view */
                draw_wall_piece((s16)(VIEW_X(2) + off), VIEW_Y(2), w, 2);
            } else {
                /* H011_bss+$58: (word) VIEW_X(2): column of wall piece 2 in the view; H011_bss+$44:
                 * (word) VIEW_Y(2): row of wall piece 2 in the view */
                draw_wall_piece((s16)(VIEW_X(2) + off + 1), VIEW_Y(2), w, 2);
            }
        }
        ++i;
        off = (s16)(off + 2);
        px = (s16)(px + DX(right)); /* $3EE2: (word) x offset for direction d (step 2) */
        py = (s16)(py + DY(right)); /* $3ED0: (word) y offset for direction d (step 2) */
    }
}

/* Cells at distance 1: front walls (3) and sides (4, 5). */
static void draw_view_mid(s16 vx, s16 vy, u16 dir, u16 left, u16 right)
{
    s16 px;
    s16 py;
    u16 i;
    s16 off;
    u16 w;
    u16 w2;

    px = (s16)(vx + DX(left) + DX(left)); /* $3EE2: (word) x offset for direction d (step 2) */
    py = (s16)(vy + DY(left) + DY(left)); /* $3ED0: (word) y offset for direction d (step 2) */
    i = 0;
    off = -6;
    while (i < 3) {
        w = map_wall(px, py, dir);
        if (w) {
            /* H011_bss+$5A: (word) VIEW_X(3): column of wall piece 3 in the view; H011_bss+$46:
             * (word) VIEW_Y(3): row of wall piece 3 in the view */
            draw_wall_piece((s16)(VIEW_X(3) + off), VIEW_Y(3), w, 3);
        }
        w2 = map_wall(px, py, left);
        if (w2) {
            /* H011_bss+$5C: (word) VIEW_X(4): column of wall piece 4 in the view; H011_bss+$48:
             * (word) VIEW_Y(4): row of wall piece 4 in the view */
            draw_wall_piece((s16)(VIEW_X(4) + off), VIEW_Y(4), w2, 4);
        }
        ++i;
        off = (s16)(off + 3);
        px = (s16)(px + DX(right)); /* $3EE2: (word) x offset for direction d (step 2) */
        py = (s16)(py + DY(right)); /* $3ED0: (word) y offset for direction d (step 2) */
    }
    px = (s16)(vx + DX(right) + DX(right)); /* $3EE2: (word) x offset for direction d (step 2) */
    py = (s16)(vy + DY(right) + DY(right)); /* $3ED0: (word) y offset for direction d (step 2) */
    i = 0;
    off = 6;
    while (i < 3) {
        w = map_wall(px, py, dir);
        if (w) {
            /* H011_bss+$5A: (word) VIEW_X(3): column of wall piece 3 in the view; H011_bss+$46:
             * (word) VIEW_Y(3): row of wall piece 3 in the view */
            draw_wall_piece((s16)(VIEW_X(3) + off), VIEW_Y(3), w, 3);
        }
        w2 = map_wall(px, py, right);
        if (w2) {
            /* H011_bss+$5E: (word) VIEW_X(5): column of wall piece 5 in the view; H011_bss+$4A:
             * (word) VIEW_Y(5): row of wall piece 5 in the view */
            draw_wall_piece((s16)(VIEW_X(5) + off), VIEW_Y(5), w2, 5);
        }
        ++i;
        off = (s16)(off - 3);
        px = (s16)(px + DX(left)); /* $3EE2: (word) x offset for direction d (step 2) */
        py = (s16)(py + DY(left)); /* $3ED0: (word) y offset for direction d (step 2) */
    }
}

/* Cells at distance 0: front walls (6) and sides (7, 8). */
static void draw_view_near(s16 vx, s16 vy, u16 dir, u16 left, u16 right)
{
    s16 px;
    s16 py;
    u16 i;
    s16 off;
    u16 w;
    u16 w2;

    px = (s16)(vx + DX(left)); /* $3EE2: (word) x offset for direction d (step 2) */
    py = (s16)(vy + DY(left)); /* $3ED0: (word) y offset for direction d (step 2) */
    i = 0;
    off = -7;
    while (i < 2) {
        w = map_wall(px, py, dir);
        if (w) {
            /* H011_bss+$60: (word) VIEW_X(6): column of wall piece 6 in the view; H011_bss+$4C:
             * (word) VIEW_Y(6): row of wall piece 6 in the view */
            draw_wall_piece((s16)(VIEW_X(6) + off), VIEW_Y(6), w, 6);
        }
        w2 = map_wall(px, py, left);
        if (w2) {
            /* H011_bss+$62: (word) VIEW_X(7): column of wall piece 7 in the view; H011_bss+$4E:
             * (word) VIEW_Y(7): row of wall piece 7 in the view */
            draw_wall_piece((s16)(VIEW_X(7) + off), VIEW_Y(7), w2, 7);
        }
        ++i;
        off = (s16)(off + 7);
        px = (s16)(px + DX(right)); /* $3EE2: (word) x offset for direction d (step 2) */
        py = (s16)(py + DY(right)); /* $3ED0: (word) y offset for direction d (step 2) */
    }
    px = (s16)(vx + DX(right)); /* $3EE2: (word) x offset for direction d (step 2) */
    py = (s16)(vy + DY(right)); /* $3ED0: (word) y offset for direction d (step 2) */
    i = 0;
    off = 7;
    while (i < 2) {
        w = map_wall(px, py, dir);
        if (w) {
            /* H011_bss+$60: (word) VIEW_X(6): column of wall piece 6 in the view; H011_bss+$4C:
             * (word) VIEW_Y(6): row of wall piece 6 in the view */
            draw_wall_piece((s16)(VIEW_X(6) + off), VIEW_Y(6), w, 6);
        }
        w2 = map_wall(px, py, right);
        if (w2) {
            /* H011_bss+$64: (word) VIEW_X(8): column of wall piece 8 in the view; H011_bss+$50:
             * (word) VIEW_Y(8): row of wall piece 8 in the view */
            draw_wall_piece((s16)(VIEW_X(8) + off), VIEW_Y(8), w2, 8);
        }
        ++i;
        off = (s16)(off - 7);
        px = (s16)(px + DX(left)); /* $3EE2: (word) x offset for direction d (step 2) */
        py = (s16)(py + DY(left)); /* $3ED0: (word) y offset for direction d (step 2) */
    }
}

/*
 * PORT H011+$0B78: 3D view of the dungeon from the square (x, y) towards dir:
 * with the map active ($2825) the top-down map; otherwise the background and
 * the walls from the cells at distance 2 up to the party one, from the back
 * towards the viewer.  Then shows the buffer and reloads the palette.
 */
void draw_3d_view(s16 x, s16 y, u16 dir)
{
    u16 left;                           /* -$2(a5) */
    u16 back;                           /* -$6(a5) */
    u16 right;                          /* -$4(a5) */
    s16 vx;                             /* -$A(a5) */
    s16 vy;                             /* -$C(a5) */
    s16 dist;                           /* -$8(a5) */

    copy_intuition_colors();
    begin_screen_update();
    if (H005_B(0x2825)) { /* $2825: top-down map flag, active instead of the 3D view */
        draw_area_map(x, y, dir);
    } else {
        H005_B(0x2486) = 0xFF; /* $2486: id of the sequence loaded at $27BC (name at $27A6), $FF none */
        draw_view_background();
        left = (u16)((dir + 6) & 7);
        back = (u16)((dir + 4) & 7);
        right = (u16)((dir + 2) & 7);
        vx = x;
        vy = y;
        dist = 2;
        vx = (s16)(vx + DX(dir) * dist); /* $3EE2: (word) x offset for direction d (step 2) */
        vy = (s16)(vy + DY(dir) * dist); /* $3ED0: (word) y offset for direction d (step 2) */
        do {
            switch (dist) {
            case 2: draw_view_far(vx, vy, dir, left, right); break;
            case 1: draw_view_mid(vx, vy, dir, left, right); break;
            case 0: draw_view_near(vx, vy, dir, left, right); break;
            default: break;
            }
            vx = (s16)(vx + DX(back)); /* $3EE2: (word) x offset for direction d (step 2) */
            vy = (s16)(vy + DY(back)); /* $3ED0: (word) y offset for direction d (step 2) */
            --dist;
        } while (dist > -1);
    }
    end_screen_update();
    load_game_palette();
}
