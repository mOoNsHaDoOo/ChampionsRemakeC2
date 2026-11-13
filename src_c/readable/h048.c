/* H048: module data. */
#include "h048.h"
#include "globals.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h035.h"
#include "h036.h"
#include "unported.h"

u32 g_h048_0004;                /* -$4(a4) */

/* PORT H048+$0008 */
void h048_init(void)
{
    g_h048_0004 = 0;
}

/*
 * PORT H048+$0154: square (x, y) of the combat map: in *tile
 * the byte $2ADE+$A+y*100+x*2+1, in *value H005+$2BD2+y*$32+x; off the
 * map 0.  Without a map (outside combat the original reads from
 * $2ADE = 0, that is low memory) it is 0 here.
 */
void combat_map_cell(s16 x, s16 y, u16 *value, u16 *tile)
{
    if (x >= 0 && x <= 0x31 && y >= 0 && y <= 0x18) {
        if (g_combat_area != NULL) {
            *tile = g_combat_area[0x0A + y * 100 + x * 2 + 1];
        } else {
            *tile = 0;
        }
        /* $2BD2: combat map occupancy 50x25 bytes: combatant no. or 0 */
        *value = H005_B(0x2BD2 + y * 0x32 + x);
    } else {
        *value = 0;
        *tile = 0;
    }
}

/*
 * Combat map (H005+$2ADE): $A-byte header (+$2/+$4
 * corner of the 7x7 view, +$6 cursor on, +$7 its shape, +$8 no
 * height check) and 25 rows of 50 2-byte squares (ground,
 * upper part).  H005+$3154: 6 bytes per combatant (x, y, +$5 shape); $3104 and
 * $30B4 its coordinates in the view.
 */
#define AREA_X0         ((s16)COK_GET16(g_combat_area + 2))
#define AREA_Y0         ((s16)COK_GET16(g_combat_area + 4))
/* $3154: combatant positions, 6 bytes per n (from 1): +0 column (word) */
#define POS_X(n)        ((s16)H005_W(0x3154 + ((n) - 1) * 6))
/* $3156: combatant positions +2: row on the map (word) */
#define POS_Y(n)        ((s16)H005_W(0x3154 + ((n) - 1) * 6 + 2))
/* $3159: combatant positions +5: shape/size (0 = off the map) */
#define POS_SIZE(n)     H005_B(0x3154 + ((n) - 1) * 6 + 5)
/* $3104: (word) column in the view for combatant n (step 2, from 1) */
#define VIEW_X(n)       ((s16)H005_W(0x3104 + ((n) - 1) * 2))
/* $30B4: (word) row in the view for combatant n (step 2, from 1) */
#define VIEW_Y(n)       ((s16)H005_W(0x30B4 + ((n) - 1) * 2))
/* $3EF7: terrain +3, graphic frame of tile t ($41 entries of 4 bytes, from 1) */
#define TILE_FRAME(t)   H005_B(0x3EF4 + ((t) - 1) * 4 + 3)

static u8 *map_cell(s16 x, s16 y)
{
    return g_combat_area + 0x0A + (s32)y * 0x64 + x * 2;
}

/* Ground and, if different, the upper part of the square (x, y) in the cell (col, row). */
static void draw_map_cell(s16 col, s16 row, s16 x, s16 y)
{
    u8 *cell = map_cell(x, y);

    draw_map_tile(col, row, TILE_FRAME(cell[0]), 0); /* $3EF7: terrain +3: graphic frame of the tile */
    if (cell[0] != cell[1]) {
        /* $3EF7: terrain +3: graphic frame of the tile */
        draw_map_tile(col, row, TILE_FRAME(cell[1]), 1);
    }
}

/* The figure of combatant n in its cell of the view. */
static void draw_combatant(u16 n)
{
    Character *c = g_combatants[n - 1];

    /* $3104: (word) column in the view for combatant n (step 2, from 1); $30B4: (word) row in the
     * view for combatant n (step 2, from 1); turn+$B: facing/frame of the combatant (direction
     * 0..7) */
    draw_sprite_set((u16)VIEW_X(n), (u16)VIEW_Y(n), c->block_192->b[0x0B], 0,
                    /* pg+$143: slot of the 24x24 icons (0..7 in the party; $0A creation, $0C editor) */
                    c->b[0x143]);
}

/*
 * PORT H048+$0044: square i (0..3) of shape size (table H005+$5048,
 * 16 bytes per shape): offset in *dx, *dy; true if *dx >= 0.  With
 * size = 0 no square.
 */
u8 shape_cell(u16 size, u16 i, s16 *dx, s16 *dy)
{
    if (size == 0) {
        return 0;
    }
    /* $5048: cells of the shapes: 16 bytes per shape, 4 cells; +0 dx (word) */
    *dx = (s16)H005_W(0x5048 + (size - 1) * 16 + i * 4);
    *dy = (s16)H005_W(0x5048 + (size - 1) * 16 + i * 4 + 2); /* $504A: cells of the shapes +2: dy (word) */
    return (u8)(*dx >= 0);
}

/* PORT H048+$00C2: view coordinates ($3104/$30B4) of all the combatants. */
void update_view_positions(void)
{
    u16 i;

    /* $247B: number of combatants in the table +$2B32 (+1 after deployment) */
    for (i = 1; i <= H005_B(0x247B); ++i) {
        /* $3154: combatant positions, 6 bytes per n (from 1): +0 column (word); $3104: (word)
         * column in the view for combatant n (step 2, from 1) */
        H005_SET_W(0x3104 + (i - 1) * 2, (u16)(POS_X(i) - AREA_X0));
        /* $3156: combatant positions +2: row on the map (word); $30B4: (word) row in the view for
         * combatant n (step 2, from 1) */
        H005_SET_W(0x30B4 + (i - 1) * 2, (u16)(POS_Y(i) - AREA_Y0));
    }
}

/* PORT H048+$01E8: is (x, y) inside the 7x7 view? */
u8 in_view(s16 x, s16 y)
{
    if (x < 0 || x > 6 || y < 0 || y > 6) {
        return 0;
    }
    return 1;
}

/*
 * PORT H048+$0230: combatant c is in the view: with all, all its
 * squares, otherwise at least one.  Without a shape (+$5 = 0) no.
 */
u8 combatant_visible(Character *c, u8 all)
{
    u8 r = 1;                           /* -$D(a5) */
    u16 n;                              /* -$4(a5) */
    u16 i;                              /* -$2(a5) */
    s16 dx;                             /* -$6(a5) */
    s16 dy;                             /* -$8(a5) */

    n = combatant_index(c);
    if (POS_SIZE(n) == 0) { /* $3159: combatant positions +5: shape/size (0 = off the map) */
        return 0;
    }
    for (i = 0; i <= 3; ++i) {
        /* $3159: combatant positions +5: shape/size (0 = off the map) */
        if (!shape_cell(POS_SIZE(n), i, &dx, &dy)) {
            continue;
        }
        /* $3104: (word) column in the view for combatant n (step 2, from 1); $30B4: (word) row in
         * the view for combatant n (step 2, from 1) */
        if (!in_view((s16)(VIEW_X(n) + dx), (s16)(VIEW_Y(n) + dy))) {
            r = 0;
            if (all) {
                return r;
            }
        } else {
            r = 1;
            if (!all) {
                return r;
            }
        }
    }
    return r;
}

/*
 * PORT H048+$0334: redraws the square (x, y) of the map with the shape
 * of the cursor (+$7), the cursor itself (set $19) if on (+$6) and the
 * combatant occupying it.
 */
void draw_combat_cell(s16 x, s16 y)
{
    s16 sx;                             /* -$2(a5) */
    s16 sy;                             /* -$4(a5) */
    s16 dx;                             /* -$6(a5) */
    s16 dy;                             /* -$8(a5) */
    u16 i;                              /* -$A(a5) */
    u16 who;                            /* -$C(a5) */
    u16 tile;                           /* -$E(a5) */

    begin_screen_update();
    sx = (s16)(x - AREA_X0);
    sy = (s16)(y - AREA_Y0);
    for (i = 0; i <= 3; ++i) {
        if (!shape_cell(g_combat_area[7], i, &dx, &dy) ||
            !in_view((s16)(sx + dx), (s16)(sy + dy))) {
            continue;
        }
        draw_map_cell((s16)(sx + dx), (s16)(sy + dy), (s16)(x + dx),
                      (s16)(y + dy));
        if (g_combat_area[6]) {
            draw_sprite_set((u16)(sx + dx), (u16)(sy + dy), 0, 0, 0x19);
        }
    }
    combat_map_cell(x, y, &who, &tile);
    if (who > 0) {
        draw_combatant(who);
    }
    end_screen_update();
}

/*
 * PORT H048+$0588: redraws the terrain under combatant who (all
 * its squares in the view); with who = 0 the one of the square (sx, sy)
 * of the view, or of the combatant occupying it.
 */
void redraw_ground(s16 sx, s16 sy, u16 who)
{
    s16 x = 0;                          /* -$2(a5) */
    s16 y = 0;                          /* -$4(a5) */
    s16 dx;                             /* -$6(a5) */
    s16 dy;                             /* -$8(a5) */
    u16 i;                              /* -$A(a5) */
    u16 tile;                           /* -$C(a5) */
    u16 size;                           /* -$E(a5) */

    if (who == 0) {
        x = (s16)(sx + AREA_X0);
        y = (s16)(sy + AREA_Y0);
        combat_map_cell(x, y, &who, &tile);
    }
    if (who > 0) {
        sx = VIEW_X(who); /* $3104: (word) column in the view for combatant n (step 2, from 1) */
        sy = VIEW_Y(who); /* $30B4: (word) row in the view for combatant n (step 2, from 1) */
        x = (s16)(sx + AREA_X0);
        y = (s16)(sy + AREA_Y0);
        size = POS_SIZE(who); /* $3159: combatant positions +5: shape/size (0 = off the map) */
        for (i = 0; i <= 3; ++i) {
            if (shape_cell(size, i, &dx, &dy) &&
                in_view((s16)(sx + dx), (s16)(sy + dy))) {
                draw_map_cell((s16)(sx + dx), (s16)(sy + dy),
                              (s16)(x + dx), (s16)(y + dy));
            }
        }
    } else if (in_view(sx, sy)) {
        draw_map_cell(sx, sy, x, y);
    }
}

/* PORT H048+$0884: redraws the square (x, y) and whoever occupies it. */
void redraw_combat_cell(s16 x, s16 y)
{
    s16 sx;                             /* -$2(a5) */
    s16 sy;                             /* -$4(a5) */
    u16 who;                            /* -$6(a5) */
    u16 tile;                           /* -$8(a5) */

    begin_screen_update();
    sx = (s16)(x - AREA_X0);
    sy = (s16)(y - AREA_Y0);
    redraw_ground(sx, sy, 0);
    combat_map_cell(x, y, &who, &tile);
    if (who > 0) {
        draw_combatant(who);
    }
    end_screen_update();
}

/*
 * PORT H048+$0956: rebuilds the occupancy table H005+$2BD2 (50x25 bytes,
 * combatant number) and the view coordinates of whoever has a shape.
 */
void rebuild_occupancy(void)
{
    u16 n;                              /* -$2(a5) */
    u16 i;                              /* -$4(a5) */
    s16 dx;                             /* -$6(a5) */
    s16 dy;                             /* -$8(a5) */

    /* $2BD2: combat map occupancy 50x25 bytes: combatant no. or 0 */
    h029_fill_bytes(0x4E1, &H005_B(0x2BD2), 0x4E2, 0);
    /* $247B: number of combatants in the table +$2B32 (+1 after deployment) */
    for (n = 1; n <= H005_B(0x247B); ++n) {
        if (POS_SIZE(n) == 0) { /* $3159: combatant positions +5: shape/size (0 = off the map) */
            continue;
        }
        for (i = 0; i <= 3; ++i) {
            /* $3159: combatant positions +5: shape/size (0 = off the map) */
            if (shape_cell(POS_SIZE(n), i, &dx, &dy)) {
                /* $2BD2: combat map occupancy 50x25 bytes: combatant no. or 0; $3156: combatant positions +2: row
                 * on the map (word); $3154: combatant positions, 6 bytes per n (from 1): +0 column
                 * (word) */
                H005_B(0x2BD2 + (s32)(POS_Y(n) + dy) * 0x32 + POS_X(n) + dx) =
                    (u8)n;
            }
        }
        /* $3154: combatant positions, 6 bytes per n (from 1): +0 column (word); $3104: (word)
         * column in the view for combatant n (step 2, from 1) */
        H005_SET_W(0x3104 + (n - 1) * 2, (u16)(POS_X(n) - AREA_X0));
        /* $3156: combatant positions +2: row on the map (word); $30B4: (word) row in the view for
         * combatant n (step 2, from 1) */
        H005_SET_W(0x30B4 + (n - 1) * 2, (u16)(POS_Y(n) - AREA_Y0));
    }
}

/*
 * PORT H048+$0AA8: number (1..) of combatant c in the table $2B32, 0
 * if it is not there.  With $247B = 0 the original continues past the table; here
 * the search stops at the 40 entries.
 */
u16 combatant_index(Character *c)
{
    u8 found = 0;                       /* -$1(a5) */
    u16 i = 0;                          /* -$4(a5) */

    do {
        ++i;
        if (g_combatants[i - 1] == c) {
            found = 1;
        }
    /* $247B: number of combatants in the table +$2B32 (+1 after deployment) */
    } while (!found && i != H005_B(0x247B) && i < 40);
    return (u16)(found ? i : 0);
}

/*
 * PORT H048+$0B1A: brings (x, y) into the view: if it is already within margin
 * squares of the centre (margin = $FF: always) it does nothing and returns
 * 0; otherwise it moves the centre (3..$2E, 3..$15) towards (x, y), redraws
 * the 7x7 view and returns 1.
 */
u8 scroll_view_to(s16 x, s16 y, u8 margin)
{
    s16 m;                              /* -$2(a5) */
    s16 cx;                             /* -$C(a5) */
    s16 cy;                             /* -$E(a5) */
    s16 lo_x;                           /* -$10(a5) */
    s16 hi_x;                           /* -$12(a5) */
    s16 lo_y;                           /* -$14(a5) */
    s16 hi_y;                           /* -$16(a5) */
    s16 col;                            /* -$4(a5) */
    s16 row;                            /* -$6(a5) */
    s16 i;                              /* -$8(a5) */
    s16 j;                              /* -$A(a5) */

    cx = (s16)(AREA_X0 + 3);
    cy = (s16)(AREA_Y0 + 3);
    m = margin;
    if (margin == 0xFF) {
        m = 0;
    }
    lo_x = (s16)(cx - m);
    hi_x = (s16)(cx + m);
    lo_y = (s16)(cy - m);
    hi_y = (s16)(cy + m);
    if (margin != 0xFF && x >= lo_x && x <= hi_x && y >= lo_y && y <= hi_y) {
        return 0;
    }
    begin_screen_update();
    if (x < lo_x) {
        while (x < cx && cx > 3) {
            --cx;
        }
    } else if (x > hi_x) {
        while (x > cx && cx < 0x2E) {
            ++cx;
        }
    }
    if (y < lo_y) {
        while (y < cy && cy > 3) {
            --cy;
        }
    } else if (y > hi_y) {
        while (y > cy && cy < 0x15) {
            ++cy;
        }
    }
    COK_PUT16(g_combat_area + 2, (u16)(cx - 3));
    COK_PUT16(g_combat_area + 4, (u16)(cy - 3));
    row = 0;
    cy = AREA_Y0;
    for (j = 0; j <= 6; ++j) {
        col = 0;
        cx = AREA_X0;
        for (i = 0; i <= 6; ++i) {
            draw_map_cell(col, row, cx, cy);
            ++col;
            ++cx;
        }
        ++row;
        ++cy;
    }
    update_view_positions();
    end_screen_update();
    return 1;
}

/*
 * PORT H048+$0DF2: brings into the view the square next to (x, y) in
 * direction dir (8 = the same one) with margin margin; if the view
 * moved it redraws the active combatants; then redraws (x, y) and the
 * neighbouring square (limited to the map if out of view).
 */
void center_view(s16 x, s16 y, u16 margin, u16 dir)
{
    u16 n;                              /* -$6(a5) */
    s16 nx;                             /* -$8(a5) */
    s16 ny;                             /* -$A(a5) */
    Character *c;                       /* -$4(a5) */

    begin_screen_update();
    nx = (s16)(x + H005_W(0x3EE2 + dir * 2)); /* $3EE2: (word) x offset for direction d (step 2) */
    ny = (s16)(y + H005_W(0x3ED0 + dir * 2)); /* $3ED0: (word) y offset for direction d (step 2) */
    if (scroll_view_to(nx, ny, (u8)margin)) {
        /* $247B: number of combatants in the table +$2B32 (+1 after deployment) */
        for (n = 1; n <= H005_B(0x247B); ++n) {
            c = g_combatants[n - 1];
            /*
             * The last entry ($247B, after the deployment of H095) is empty:
             * the original reads +$198 from low memory and discards it for
             * shape 0; here the NULL entry is skipped.
             */
            /* ch+$198: active/standing (0 down or out of the combat); $3159: combatant
             * positions +5: shape/size (0 = off the map) */
            if (c != NULL && c->b[0x198] && POS_SIZE(n) > 0) {
                draw_combatant(n);
            }
        }
    }
    redraw_combat_cell(x, y);
    if (!in_view((s16)(nx - AREA_X0), (s16)(ny - AREA_Y0))) {
        if (nx > 0x31) {
            nx = 0x31;
        } else if (nx < 0) {
            nx = 0;
        }
        if (ny > 0x18) {
            ny = 0x18;
        } else if (ny < 0) {
            ny = 0;
        }
    }
    draw_combat_cell(nx, ny);
    end_screen_update();
}

/* PORT H048+$0F88: column of c on the map (H005+$3154). */
u16 combatant_x(Character *c)
{
    s16 i = (s16)combatant_index(c);

    return (u16)POS_X(i); /* $3154: combatant positions, 6 bytes per n (from 1): +0 column (word) */
}

/* PORT H048+$0FBA: row of c on the map. */
u16 combatant_y(Character *c)
{
    s16 i = (s16)combatant_index(c);

    return (u16)POS_Y(i); /* $3156: combatant positions +2: row on the map (word) */
}

/*
 * PORT H048+$0FEC: changes the figure of c (frame frame, set which): if
 * it is not all in the view it centres it; with $24C6 redraws the terrain if
 * the direction changes (frame/4), with which or with skip; then, without skip,
 * draws the figure.
 */
void set_combatant_frame(Character *c, u8 frame, u8 which, u8 skip)
{
    u16 n;                              /* -$2(a5) */

    begin_screen_update();
    n = combatant_index(c);
    /* $24C6: 1 if the combatant's actions must be drawn (visible) */
    if (!combatant_visible(c, 1) && H005_B(0x24C6)) {
        center_view((s16)combatant_x(c), (s16)combatant_y(c), 3, 8);
    }
    /* turn+$B: facing/frame of the combatant (direction 0..7) */
    if (((c->block_192->b[0x0B] >> 2) != (frame >> 2) || which || skip) &&
        H005_B(0x24C6)) { /* $24C6: 1 if the combatant's actions must be drawn (visible) */
        redraw_ground(0, 0, n);
    }
    c->block_192->b[0x0B] = frame; /* turn+$B: facing/frame of the combatant (direction 0..7) */
    if (!skip && H005_B(0x24C6)) { /* $24C6: 1 if the combatant's actions must be drawn (visible) */
        /* $3104: (word) column in the view for combatant n (step 2, from 1); $30B4: (word) row in
         * the view for combatant n (step 2, from 1) */
        draw_sprite_set((u16)VIEW_X(n), (u16)VIEW_Y(n), frame, which,
                        /* ch+$143: slot of the 24x24 icons (0..7 in the party; $0A creation,
                         * $0C editor) */
                        c->b[0x143]);
    }
    end_screen_update();
}

/* PORT H048+$110C: shape (+$5 in $3154) of combatant c. */
u8 combatant_size(Character *c)
{
    /* $3159: combatant positions +5: shape/size (0 = off the map) */
    return POS_SIZE((s16)combatant_index(c));
}

/*
 * PORT H048+$113E: examines the squares of c moved in direction dir: in
 * *blocker the last other combatant found, in *tile the square with the highest
 * cost (H005+$3EF4) (0 if one is off the map), *in_cloud /
 * *in_acid if there is a cloud ($1E) or a pool ($1D).
 */
void probe_move(Character *c, u16 dir, u16 *blocker, u16 *tile, u8 *in_cloud,
                u8 *in_acid)
{
    u16 n;                              /* -$4(a5) */
    u16 i;                              /* -$2(a5) */
    u16 best = 1;                       /* -$A(a5) */
    s16 x0;                             /* -$10(a5) */
    s16 y0;                             /* -$12(a5) */
    s16 dx;                             /* -$14(a5) */
    s16 dy;                             /* -$16(a5) */
    s16 x;                              /* -$C(a5) */
    s16 y;                              /* -$E(a5) */
    u16 who;                            /* -$6(a5) */
    u16 t;                              /* -$8(a5) */

    *blocker = 0;
    *tile = 0x17;
    *in_cloud = 0;
    *in_acid = 0;
    n = combatant_index(c);
    x0 = POS_X(n); /* $3154: combatant positions, 6 bytes per n (from 1): +0 column (word) */
    y0 = POS_Y(n); /* $3156: combatant positions +2: row on the map (word) */
    for (i = 0; i <= 3; ++i) {
        /* $3159: combatant positions +5: shape/size (0 = off the map) */
        if (!shape_cell(POS_SIZE(n), i, &dx, &dy)) {
            continue;
        }
        /* $3EE2: (word) x offset for direction d (step 2) */
        x = (s16)(x0 + dx + H005_W(0x3EE2 + dir * 2));
        /* $3ED0: (word) y offset for direction d (step 2) */
        y = (s16)(y0 + dy + H005_W(0x3ED0 + dir * 2));
        combat_map_cell(x, y, &who, &t);
        if (who == n) {
            who = 0;
        }
        if (who > 0) {
            *blocker = who;
        }
        if (t == 0 || *tile == 0) {
            *tile = 0;
            continue;
        }
        switch (t) {
        case 0x1E:
            *in_cloud = 1;
            break;
        case 0x1D:
            *in_acid = 1;
            break;
        default:
            /* $3EF4: terrain, $41 entries of 4 bytes (from 1): +0 cost ($FF impassable) */
            if (H005_B(0x3EF4 + (t - 1) * 4) >= best) {
                /* $3EF4: terrain, $41 entries of 4 bytes (from 1): +0 cost ($FF impassable) */
                best = H005_B(0x3EF4 + (t - 1) * 4);
                *tile = t;
            }
            break;
        }
    }
}

/*
 * PORT H048+$12F4: c falls: sound according to shape and status, falling
 * animation ($3304) on its squares and, if it is not a summoned monster
 * (turn +$15), a body in H005+$2AE2 with the square ($1F) saved; then
 * c leaves the map.  Outside combat only sound and pause.  The
 * initial check of the original reads the uninitialised entry -$6(a5)
 * (with 0, outside the table, H005+$2AD8) and never finds c:
 * omitted here.  Beyond 8 entries the original would write over the combatants:
 * here the body is not recorded and the count $247A stays 8.
 */
void combatant_falls(Character *c)
{
    u16 n;                              /* -$2(a5) */
    u16 i;                              /* -$4(a5) */
    u16 f;                              /* -$6(a5) */
    s16 dx;                             /* -$8(a5) */
    s16 dy;                             /* -$A(a5) */
    s16 x;                              /* -$C(a5) */
    s16 y;                              /* -$E(a5) */
    CokBody *b;

    if (H005_B(0x3DE3) != 5) { /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
        h043_190e(0x0A);
        message_delay();
        return;
    }
    n = combatant_index(c);
    x = (s16)combatant_x(c);
    y = (s16)combatant_y(c);
    if (!combatant_visible(c, 1)) {
        center_view(x, y, 3, 8);
    }
    redraw_ground(0, 0, n);
    switch (POS_SIZE(n)) { /* $3159: combatant positions +5: shape/size (0 = off the map) */
    case 1:
        if (c->b[0xDB] == 0) { /* ch+$DB: highest level among the classes (also used as hit dice) */
            /* ch+$123: maximum HP without constitution; base -1 of the spell slots +$124 */
            if (c->b[0x123] < 3) {
                h043_190e(8);
            } else {
                h043_190e(9);
            }
        } else {
            h043_190e(0x0A);
        }
        break;
    case 2:
    case 3:
        h043_190e(0x0B);
        break;
    case 4:
        h043_190e(0x0C);
        break;
    default:
        break;
    }
    for (f = 0; f <= 8; ++f) {
        for (i = 0; i <= 3; ++i) {
            /* $3159: combatant positions +5: shape/size (0 = off the map) */
            if (shape_cell(POS_SIZE(n), i, &dx, &dy) &&
                /* $3104: (word) column in the view for combatant n (step 2, from 1); $30B4:
                 * (word) row in the view for combatant n (step 2, from 1) */
                in_view((s16)(VIEW_X(n) + dx), (s16)(VIEW_Y(n) + dy))) {
                /* $3304 is slot $18 of the set table $3244. */
                /* $3104: (word) column in the view for combatant n (step 2, from 1) */
                draw_tile24_saving((u16)((VIEW_X(n) + dx) * 0x18),
                                   /* $30B4: (word) row in the view for combatant n (step 2, from
                                    * 1) */
                                   (u16)((VIEW_Y(n) + dy) * 0x18), 0, 5,
                                   g_sprite_sets[0x18][f & 1], g_gfx_3d8e);
            }
        }
        dos_delay(1);
    }
    /* turn+$15: 1 = combatant beyond the party members, leaves it at the end of the fight */
    if (c->block_192->b[0x15] == 0) {
        if (H005_B(0x247A) < 8) { /* $247A: number of bodies in the table +$2AE2 (max 8) */
            ++H005_B(0x247A); /* $247A: number of bodies in the table +$2AE2 (max 8) */
            b = &g_bodies[H005_B(0x247A) - 1]; /* $247A: number of bodies in the table +$2AE2 (max 8) */
            b->tile = map_cell(x, y)[1];
            if (map_cell(x, y)[1] != 0x1E) {
                map_cell(x, y)[1] = 0x1F;
            }
            b->who = c;
            b->x = (u16)x;
            b->y = (u16)y;
        }
    }
    message_delay();
    redraw_ground(0, 0, n);
    /* $3159: combatant positions +5: shape/size (0 = off the map) */
    H005_B(0x3154 + (combatant_index(c) - 1) * 6 + 5) = 0;
    rebuild_occupancy();
    center_view((s16)(AREA_X0 + 3), (s16)(AREA_Y0 + 3), 3, 8);
    /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
    COK_PUT16(&c->block_192->b[4], 0);
    c->block_192->b[8] = 0; /* turn+$8: movement points left in the turn */
    c->block_192->b[0] = 0; /* turn+$0: spell being prepared, cast at the start of the turn */
    c->block_192->b[9] = 0; /* turn+$9: on guard flag (Guard), attacks whoever comes close */
}

/*
 * PORT H048+$16D4: puts c at (x, y) with the shape +$D3 & $7F; if the
 * squares are occupied or impassable (cost $FF) the shape goes back to 0 and
 * it returns 0.  With restore, if c was a body on the map, the entry is
 * emptied and the square gets back the saved contents (as long as no other
 * body is on (x, y)).  Outside combat it returns 1.
 */
u8 place_combatant(Character *c, u8 x, u8 y, u8 restore)
{
    u8 ok = 0;                          /* -$C(a5) */
    u16 n;                              /* -$2(a5) */
    u16 i;                              /* -$4(a5) */
    u16 blocker;                        /* -$6(a5) */
    u16 tile;                           /* -$8(a5) */
    u8 in_cloud;                        /* -$A(a5) */
    u8 in_acid;                         /* -$B(a5) */
    u8 found;                           /* -$9(a5) */

    if (H005_B(0x3DE3) != 5) { /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
        return 1;
    }
    n = combatant_index(c);
    /* $3159: combatant positions +5: shape/size (0 = off the map); ch+$D3: shape/size on the
     * combat map (bits 0-2, >1 large) */
    H005_B(0x3154 + (n - 1) * 6 + 5) = mask_byte(c->b[0xD3], 0x7F);
    /* $3154: combatant positions, 6 bytes per n (from 1): +0 column (word) */
    H005_SET_W(0x3154 + (n - 1) * 6, x);
    H005_SET_W(0x3154 + (n - 1) * 6 + 2, y); /* $3156: combatant positions +2: row on the map (word) */
    probe_move(c, 8, &blocker, &tile, &in_cloud, &in_acid);
    if (blocker != 0 || tile == 0 ||
        /* $3EF4: terrain, $41 entries of 4 bytes (from 1): +0 cost ($FF impassable) */
        H005_B(0x3EF4 + (tile - 1) * 4) == 0xFF) {
        /* $3159: combatant positions +5: shape/size (0 = off the map) */
        H005_B(0x3154 + (n - 1) * 6 + 5) = 0;
        return ok;
    }
    ok = 1;
    /* turn+$15: 1 = combatant beyond the party members, leaves it at the end of the fight */
    if (restore && c->block_192->b[0x15] == 0) {
        for (i = 1; i <= H005_B(0x247A); ++i) { /* $247A: number of bodies in the table +$2AE2 (max 8) */
            if (g_bodies[i - 1].who == c) {
                if (g_bodies[i - 1].tile != 0x1F) {
                    tile = g_bodies[i - 1].tile;
                }
                /* H029+$0312 on the first 9 bytes of the entry. */
                g_bodies[i - 1].who = NULL;
                g_bodies[i - 1].x = 0;
                g_bodies[i - 1].y = 0;
                g_bodies[i - 1].tile = 0;
            }
        }
        found = 0;
        for (i = 1; i <= H005_B(0x247A); ++i) { /* $247A: number of bodies in the table +$2AE2 (max 8) */
            if (g_bodies[i - 1].who != NULL && g_bodies[i - 1].x == x &&
                g_bodies[i - 1].y == y) {
                found = 1;
            }
            if (!found) {
                map_cell(x, y)[1] = (u8)tile;
            }
        }
    }
    rebuild_occupancy();
    return ok;
}

/*
 * PORT H048+$195E: shows the cursor (shape of c, on if flag) on the
 * square of c, centring it with margin margin; then turns it off.
 */
void show_combatant_cursor(Character *c, u16 margin, u8 flag)
{
    g_combat_area[6] = flag;
    /* $3159: combatant positions +5: shape/size (0 = off the map) */
    g_combat_area[7] = POS_SIZE((s16)combatant_index(c));
    if (H005_B(0x24C6)) { /* $24C6: 1 if the combatant's actions must be drawn (visible) */
        center_view((s16)combatant_x(c), (s16)combatant_y(c), margin, 8);
    }
    g_combat_area[6] = 0;
    g_combat_area[7] = 1;
}
