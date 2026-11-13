/* H047: module data. */
#include "h047.h"
#include "character.h"
#include "gfx_record.h"
#include "globals.h"
#include "h008.h"
#include "h016_gfx.h"
#include "h022_view.h"
#include "h026_string.h"
#include "h028_files.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h035.h"
#include "h044_tiles.h"
#include "h066.h"

u8 g_h047_0001;                 /* -$1(a4) */

/* PORT H047+$00D8 */
void h047_init(void)
{
    g_h047_0001 = 0;
}

/* State of H047+$00E6 shared with the nested procedures. */
typedef struct IconEditor {
    s16 cur;                            /* -$128(a5): current part */
    s16 count;                          /* -$126(a5): number of parts */
    u8 mode;                            /* -$25(a5): 'H' head, otherwise body */
} IconEditor;

/*
 * PORT H047+$00F4: nested procedure: the two poses of the icon (slot $0C)
 * over the background (slot $19) at the cells (col, row) and (col + 3, row).
 */
static void draw_icon_pair(u16 col, u16 row)
{
    draw_sprite_set(col, row, 0, 0, 0x19);
    draw_sprite_set((u16)(col + 3), row, 0, 0, 0x19);
    draw_sprite_set(col, row, 0, 0, 0x0C);
    draw_sprite_set((u16)(col + 3), row, 0, 1, 0x0C);
}

/*
 * PORT H047+$0162: nested procedure: current part and number of parts:
 * heads (+$141, $0B or $0D depending on +$144) or bodies (+$142, $24 or $28).
 */
static void set_part_range(IconEditor *e)
{
    Character *c = g_current_char;

    if (e->mode == 'H') {
        e->cur = c->b[0x141]; /* ch+$141: head part of the icon (0..$0B) */
        /* ch+$144: icon size (1 small, 2 large) */
        e->count = (s16)(c->b[0x144] == 1 ? 0x0B : 0x0D);
    } else {
        /* ch+$144: icon size (1 small, 2 large) */
        e->count = (s16)(c->b[0x144] == 1 ? 0x24 : 0x28);
        e->cur = c->b[0x142]; /* ch+$142: body figure of the icon (>31: special icons) */
    }
}

/*
 * PORT H047+$01EE: nested procedure: cell of the 7x7 grid (from
 * column 6 and row 1, 24x24 cells) under the mouse, as an offset
 * from the current part; *done if it is the current part itself.
 */
static void pick_by_mouse(IconEditor *e, s16 *x, s16 *y, u8 *done)
{
    s16 n;                              /* -$6(a5) */

    *x = (s16)((s16)H005_W(0x2356) / 0x18 - 6); /* $2356: mouse X (word, initial $A0) */
    *y = (s16)((s16)H005_W(0x2354) / 0x18 - 1); /* $2354: mouse Y (word, initial $64) */
    set_part_range(e);
    if (*x < 0 || *x > 6 || *y < 0 || *y > 6) {
        *x = 0;
        *y = 0;
        *done = 0;
        return;
    }
    n = (s16)(*y * 7 + *x + 1);
    if (n > e->count) {
        *x = 0;
        *y = 0;
        *done = 0;
        return;
    }
    *x = (s16)(*x - (e->cur - 1) % 7);
    *y = (s16)(*y - (e->cur - 1) / 7);
    *done = (u8)(n == e->cur);
}

/*
 * PORT H047+$02FE: nested procedure: draws cell n in the grid
 * with the icon made of head head and body body (slot $0C); with
 * highlight over the background $19, otherwise on a square of colour 8.
 */
static void draw_part_cell(s16 n, s16 head, s16 body, u8 highlight)
{
    Character *c = g_current_char;
    s16 cx = (s16)((n - 1) % 7 + 6);    /* -$6(a5) */
    s16 cy = (s16)((n - 1) / 7 + 1);    /* -$8(a5) */
    /* pg+$143: slot of the 24x24 icons (0..7 in the party; $0A creation, $0C editor) */
    u8 old_143 = c->b[0x143];
    u8 old_141 = c->b[0x141]; /* ch+$141: head part of the icon (0..$0B) */
    u8 old_142 = c->b[0x142]; /* ch+$142: body figure of the icon (>31: special icons) */

    c->b[0x143] = 0x0C; /* pg+$143: slot of the 24x24 icons (0..7 in the party; $0A creation, $0C editor) */
    c->b[0x141] = (u8)head; /* ch+$141: head part of the icon (0..$0B) */
    c->b[0x142] = (u8)body; /* ch+$142: body figure of the icon (>31: special icons) */
    if (highlight) {
        draw_sprite_set((u16)cx, (u16)cy, 0, 0, 0x19);
    } else {
        fill_cells((u16)(cx * 3), (u16)(cy * 3), 3, 3, 8, g_gfx_3d8e);
    }
    build_char_icon(0);
    draw_sprite_set((u16)cx, (u16)cy, 0, 0, 0x0C);
    c->b[0x143] = old_143; /* pg+$143: slot of the 24x24 icons (0..7 in the party; $0A creation, $0C editor) */
    c->b[0x141] = old_141; /* ch+$141: head part of the icon (0..$0B) */
    c->b[0x142] = old_142; /* ch+$142: body figure of the icon (>31: special icons) */
}

/*
 * PORT H047+$03EE: nested procedure: moves the chosen part by (dx, dy)
 * in the grid (wrapping at the edges and at the last incomplete row),
 * stores it in +$141 or +$142 and redraws the two changed cells or, with
 * redraw_all, the whole grid.
 */
static void move_part_cursor(IconEditor *e, s16 dx, s16 dy, u8 redraw_all)
{
    Character *c = g_current_char;
    s16 col;                            /* -$2(a5) */
    s16 row;                            /* -$4(a5) */
    s16 i;                              /* -$6(a5) */
    s16 head;                           /* -$8(a5) */
    s16 body;                           /* -$a(a5) */
    s16 n;                              /* -$c(a5) */
    s16 last_row;                       /* -$e(a5) */
    s16 last_col;                       /* -$10(a5) */
    u8 highlight;                       /* -$11(a5) */

    set_part_range(e);
    col = (s16)((e->cur - 1) % 7 + dx);
    row = (s16)((e->cur - 1) / 7 + dy);
    last_row = (s16)((e->count - 1) / 7);
    last_col = (s16)((e->count - 1) % 7);
    if (col < 0) {
        col = 6;
    }
    if (col > 6) {
        col = 0;
    }
    if (row < 0) {
        row = last_row;
    }
    if (row > last_row) {
        row = 0;
    }
    if (row == last_row && col > last_col) {
        if (dy < 0) {
            --row;
        } else if (dy > 0) {
            row = 0;
        } else if (dx < 0) {
            col = last_col;
        } else if (dx > 0) {
            col = 0;
        }
    }
    n = (s16)(row * 7 + col + 1);
    if (e->mode == 'H') {
        c->b[0x141] = (u8)n; /* ch+$141: head part of the icon (0..$0B) */
    } else {
        c->b[0x142] = (u8)n; /* ch+$142: body figure of the icon (>31: special icons) */
    }
    body = c->b[0x142]; /* ch+$142: body figure of the icon (>31: special icons) */
    head = c->b[0x141]; /* ch+$141: head part of the icon (0..$0B) */
    if (redraw_all) {
        fill_cells(0x12, 3, 0x15, 0x12, 0, g_gfx_3d8e);
        for (i = 1; i <= e->count; ++i) {
            if (e->mode == 'H') {
                head = i;
                highlight = (u8)(c->b[0x141] == i); /* ch+$141: head part of the icon (0..$0B) */
            } else {
                body = i;
                /* ch+$142: body figure of the icon (>31: special icons) */
                highlight = (u8)(c->b[0x142] == i);
            }
            draw_part_cell(i, head, body, highlight);
        }
    } else if (e->mode == 'H') {
        draw_part_cell(e->cur, e->cur, body, 0);
        draw_part_cell(n, n, body, 1);
    } else {
        draw_part_cell(e->cur, head, e->cur, 0);
        draw_part_cell(n, head, n, 1);
    }
}

/*
 * PORT H047+$0688: nested procedure: copies pictures and masks of the two
 * 24x24 sets of slot src into slot dst; with recolor, if +$142 < 32,
 * applies the character's colours (+$146.., low nibble on the
 * register H005+$5228[i], high nibble on the register + 8) to the two sets of dst.
 */
static void copy_icon_set(u16 src, u16 dst, u8 recolor)
{
    Character *c;
    u8 from[16];                        /* -$14(a5) */
    u8 to[16];                          /* -$24(a5) */
    u16 i;                              /* -$4(a5), -$2(a5) */

    for (i = 0; i <= 1; ++i) {
        (void)graphics_blt_bitmap(g_sprite_sets[src][i]->image, 0, 0,
                                  g_sprite_sets[dst][i]->image, 0, 0, 0x18,
                                  0x18, 0xC0, 0xFF, NULL);
        (void)graphics_blt_bitmap(g_sprite_sets[src][i]->mask, 0, 0,
                                  g_sprite_sets[dst][i]->mask, 0, 0, 0x18,
                                  0x18, 0xC0, 0xFF, NULL);
    }
    if (!recolor) {
        return;
    }
    c = g_current_char;
    for (i = 0; i <= 0x0F; ++i) {
        from[i] = (u8)i;
        to[i] = (u8)i;
    }
    for (i = 1; i <= 6; ++i) {
        /* $5227: i-1 base of the 6 colour registers of the icons ($5228); ch+$145: base -1
         * of the icon colours +$146..+$14B */
        to[H005_B(0x5228 + i - 1)] = mask_byte(c->b[0x146 + i - 1], 0x0F);
        to[H005_B(0x5228 + i - 1) + 8] = /* $5227: i-1 base of the 6 colour registers of the icons ($5228) */
            /* ch+$145: base -1 of the icon colours +$146..+$14B */
            (u8)(mask_byte(c->b[0x146 + i - 1], 0xF0) >> 4);
    }
    if (c->b[0x142] < 0x20) { /* ch+$142: body figure of the icon (>31: special icons) */
        remap_gfx_colors(from, to, 0, g_sprite_sets[dst][0]);
        remap_gfx_colors(from, to, 0, g_sprite_sets[dst][1]);
    }
}

/* Copy with dbeq $28: at most 41 bytes, NUL included. */
static void copy_menu(char *dst, const char *src)
{
    u16 i;

    for (i = 0; i <= 0x28; ++i) {
        dst[i] = src[i];
        if (src[i] == 0) {
            break;
        }
    }
}

/*
 * PORT H047+$00E6 (body at $08D6): icon editor of the current
 * character.  Six states with their own menu: 1 parts/colours/size,
 * 2 head or weapon, 3 part to colour, 4 size, 5 next or previous
 * colour, 6 choice of the part in the grid (keyboard, keypad
 * or mouse).  "Exit" from the first state confirms; then "Is this icon ok?".
 */
void edit_character_icon(void)
{
    char menus[6][0x2A];                /* -$122(a5) .. -$50(a5) */
    IconEditor e;
    Character *c;
    u8 saved_colors[6];                 /* -$1a(a5) */
    u8 saved_3de3;                      /* -$1(a5) */
    u8 key = 0;                         /* -$9(a5) */
    u8 special = 0;                     /* -$a(a5) */
    u8 done;                            /* -$129(a5) */
    u8 in_grid;                         /* -$123(a5) */
    u8 second = 0;                      /* -$1d(a5) */
    s16 head;                           /* -$c(a5) */
    s16 body;                           /* -$e(a5) */
    s16 size;                           /* -$10(a5) */
    s16 saved_143;                      /* -$12(a5) */
    s16 state;                          /* -$14(a5) */
    s16 color_part = 1;                 /* -$1c(a5) */
    s16 lo;                             /* -$20(a5) */
    s16 hi;                             /* -$22(a5) */
    s16 back = 0;                       /* -$24(a5): in the original not
                                         * initialised before the first
                                         * state; here 0 */
    s16 mx;                             /* -$6(a5) */
    s16 my;                             /* -$8(a5) */

    e.cur = 0;
    e.count = 0;
    e.mode = 0;
    /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    saved_3de3 = H005_B(0x3DE3);
    H005_B(0x3DE3) = 0; /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    copy_menu(menus[1], "Head Weapon Exit");
    copy_menu(menus[2], "Weapon Body xxxx Shield Arm Leg Exit");
    copy_menu(menus[3], " Keep Exit");
    copy_menu(menus[4], "Next Prev Keep Exit");
    copy_menu(menus[5], "Done");
    draw_screen_frame(1);
    load_char_screens();
    /* $522E: palette of the loaded picture, 32 RGB4 colours ($40 bytes) */
    graphics_load_rgb4(&g_screen->ViewPort, &g_h005[0x522E], 0x20);
    build_char_icon(0);

    for (;;) {                          /* H047+$0960 */
        c = g_current_char;
        state = 1;
        /* ch+$146: icon colours, 6 bytes (two nibbles per register H005+$5228) */
        memcpy(saved_colors, &c->b[0x146], 6);
        /* pg+$143: slot of the 24x24 icons (0..7 in the party; $0A creation, $0C editor) */
        saved_143 = c->b[0x143];
        c->b[0x143] = 0x0C; /* pg+$143: slot of the 24x24 icons (0..7 in the party; $0A creation, $0C editor) */
        build_char_icon(0);
        /* pg+$143: slot of the 24x24 icons (0..7 in the party; $0A creation, $0C editor) */
        c->b[0x143] = (u8)saved_143;
        head = c->b[0x141]; /* ch+$141: head part of the icon (0..$0B) */
        body = c->b[0x142]; /* ch+$142: body figure of the icon (>31: special icons) */
        size = c->b[0x144]; /* ch+$144: icon size (1 small, 2 large) */
        /* pg+$143: slot of the 24x24 icons (0..7 in the party; $0A creation, $0C editor) */
        copy_icon_set(c->b[0x143], 0x0C, 1);
        draw_icon_pair(1, 2);
        ui_draw_text(8, 6, 0x0F, 0, 3, "old");
        ui_draw_text(3, 0x0A, 0x0F, 0, 0x0E, "ready   action");
        ui_draw_text(8, 0x0C, 0x0F, 0, 3, "new");
        ui_draw_text(3, 0x10, 0x0F, 0, 0x0E, "ready   action");
        do {                            /* H047+$0A70 */
            draw_icon_pair(1, 4);
            in_grid = (u8)(state == 6);
            if (c->b[0x142] >= 0x20) { /* ch+$142: body figure of the icon (>31: special icons) */
                copy_menu(menus[0], "Body Size Exit");
            } else {
                copy_menu(menus[0], "Parts 1st-color 2nd-color Size Exit");
            }
            g_h047_0001 = (u8)(state == 6);
            key = ui_request_choice(0, "", 0x28, menus[state - 1], 0x0D,
                                    0x0A, 0x0F, in_grid, 0, &special);
            if (in_grid || !special) {
                switch (state) {
                case 1:             /* H047+$0B28 */
                    back = 1;
                    switch (key) {
                    case 'B':
                        e.mode = 'W';
                        move_part_cursor(&e, 0, 0, 1);
                        state = 6;
                        break;
                    case 'P':
                        state = 2;
                        break;
                    case '1':
                    case '2':
                        state = 3;
                        second = (u8)(key == '2');
                        h026_delete(0x28, menus[2], 0x0C, 4);
                        h026_insert(0x28, menus[2], 4,
                                    key == '1' ? "Hair" : "Face", 0x0C);
                        break;
                    case 'S':
                        if (c->b[0x144] == 2) { /* ch+$144: icon size (1 small, 2 large) */
                            c->b[0x144] = 1; /* ch+$144: icon size (1 small, 2 large) */
                            /* ch+$142: body figure of the icon (>31: special icons) */
                            if (c->b[0x142] >= 0x24) {
                                /* ch+$142: body figure of the icon (>31: special icons) */
                                c->b[0x142] = 0x24;
                            }
                            if (c->b[0x141] >= 0x0B) { /* ch+$141: head part of the icon (0..$0B) */
                                c->b[0x141] = 0x0B; /* ch+$141: head part of the icon (0..$0B) */
                            }
                        } else {
                            c->b[0x144] = 2; /* ch+$144: icon size (1 small, 2 large) */
                        }
                        build_char_icon(0);
                        break;
                    default:
                        break;
                    }
                    break;
                case 2:             /* H047+$0CA4 */
                    back = 2;
                    if (key == 'E' || key == 0) {
                        state = 1;
                    } else {
                        e.mode = key;
                        move_part_cursor(&e, 0, 0, 1);
                        state = 6;
                    }
                    break;
                case 3:             /* H047+$0CE6 */
                    back = 3;
                    switch (key) {
                    case 'W':
                        color_part = 6;
                        break;
                    case 'B':
                        color_part = 1;
                        break;
                    case 'H': case 'F':
                        color_part = 4;
                        break;
                    case 'S':
                        color_part = 5;
                        break;
                    case 'A':
                        color_part = 2;
                        break;
                    case 'L':
                        color_part = 3;
                        break;
                    default:
                        color_part = 1;
                        break;
                    }
                    state = (s16)(key == 'E' || key == 0 ? 1 : 5);
                    break;
                case 4:             /* H047+$0DA4 */
                    switch (key) {
                    case 'L':
                        c->b[0x144] = 2; /* ch+$144: icon size (1 small, 2 large) */
                        build_char_icon(0);
                        break;
                    case 'S':
                        c->b[0x144] = 1; /* ch+$144: icon size (1 small, 2 large) */
                        build_char_icon(0);
                        break;
                    case 'K':
                        size = c->b[0x144]; /* ch+$144: icon size (1 small, 2 large) */
                        state = 1;
                        key = ' ';
                        break;
                    case 0: case 'E':
                        c->b[0x144] = (u8)size; /* ch+$144: icon size (1 small, 2 large) */
                        state = 1;
                        key = ' ';
                        break;
                    default:
                        break;
                    }
                    build_char_icon(0);
                    break;
                case 5:             /* H047+$0ED4 */
                    /* ch+$145: base -1 of the icon colours +$146..+$14B */
                    lo = mask_byte(c->b[0x146 + color_part - 1], 0x0F);
                    /* ch+$145: base -1 of the icon colours +$146..+$14B */
                    hi = (s16)(mask_byte(c->b[0x146 + color_part - 1],
                                         0xF0) >> 4);
                    switch (key) {
                    case 'N':
                        if (second) {
                            hi = (s16)((hi + 1) & 0x0F);
                        } else {
                            lo = (s16)((lo + 1) & 0x0F);
                        }
                        /* ch+$145: base -1 of the icon colours +$146..+$14B */
                        c->b[0x146 + color_part - 1] = (u8)((hi << 4) + lo);
                        break;
                    case 'P':
                        if (second) {
                            hi = mask_byte((u8)(hi - 1), 0x0F);
                        } else {
                            lo = mask_byte((u8)(lo - 1), 0x0F);
                        }
                        /* ch+$145: base -1 of the icon colours +$146..+$14B */
                        c->b[0x146 + color_part - 1] = (u8)((hi << 4) + lo);
                        break;
                    case 'K':
                        /* ch+$146: icon colours, 6 bytes (two nibbles per register H005+$5228) */
                        memcpy(saved_colors, &c->b[0x146], 6);
                        state = back;
                        key = ' ';
                        break;
                    case 0: case 'E':
                        /* ch+$146: icon colours, 6 bytes (two nibbles per register H005+$5228) */
                        memcpy(&c->b[0x146], saved_colors, 6);
                        state = back;
                        key = ' ';
                        break;
                    default:
                        break;
                    }
                    break;
                case 6:             /* H047+$10D6 */
                    switch (key) {
                    case 0:         /* H047+$1220 */
                        if (e.mode == 'H') {
                            c->b[0x141] = (u8)head; /* ch+$141: head part of the icon (0..$0B) */
                        } else {
                            /* ch+$142: body figure of the icon (>31: special icons) */
                            c->b[0x142] = (u8)body;
                        }
                        state = 0;
                        break;
                    case 0x0D: case 'D':        /* H047+$1188 */
                        if (G_MOUSE_CLICK) { /* $249E: 1 if the key comes from the mouse (click) */
                            if ((s16)H005_W(0x2356) < 0x28 && /* $2356: mouse X (word, initial $A0) */
                                (s16)H005_W(0x2354) >= 0xC0) { /* $2354: mouse Y (word, initial $64) */
                                done = 1;
                            } else {
                                pick_by_mouse(&e, &mx, &my, &done);
                                if (!done) {
                                    move_part_cursor(&e, mx, my, 0);
                                }
                            }
                        } else {
                            done = 1;
                        }
                        if (done) {
                            if (e.mode == 'H') {
                                head = c->b[0x141]; /* ch+$141: head part of the icon (0..$0B) */
                            } else {
                                /* ch+$142: body figure of the icon (>31: special icons) */
                                body = c->b[0x142];
                            }
                            state = 0;
                        }
                        break;
                    case 'G':
                        move_part_cursor(&e, -1, -1, 0);
                        break;
                    case 'H':
                        move_part_cursor(&e, 0, -1, 0);
                        break;
                    case 'I':
                        move_part_cursor(&e, 1, -1, 0);
                        break;
                    case 'K':
                        move_part_cursor(&e, -1, 0, 0);
                        break;
                    case 'M':
                        move_part_cursor(&e, 1, 0, 0);
                        break;
                    case 'O':
                        move_part_cursor(&e, -1, 1, 0);
                        break;
                    case 'P':
                        move_part_cursor(&e, 0, 1, 0);
                        break;
                    case 'Q':
                        move_part_cursor(&e, 1, 1, 0);
                        break;
                    default:
                        break;
                    }
                    build_char_icon(0);
                    if (state == 0) {
                        fill_cells(0x12, 3, 0x15, 0x12, 0, g_gfx_3d8e);
                        /* ch+$142: body figure of the icon (>31: special icons) */
                        state = (s16)(c->b[0x142] >= 0x20 ? 1 : 2);
                        key = ' ';
                    }
                    break;
                default:
                    break;
                }
            }
            /* pg+$143: slot of the 24x24 icons (0..7 in the party; $0A creation, $0C editor) */
            copy_icon_set(c->b[0x143], 0x0C, 1);        /* H047+$1386 */
        } while (!(back == 1 && (key == 'E' || key == 0)));

        c->b[0x141] = (u8)head; /* ch+$141: head part of the icon (0..$0B) */
        c->b[0x142] = (u8)body; /* ch+$142: body figure of the icon (>31: special icons) */
        c->b[0x144] = (u8)size; /* ch+$144: icon size (1 small, 2 large) */
        /* ch+$146: icon colours, 6 bytes (two nibbles per register H005+$5228) */
        memcpy(&c->b[0x146], saved_colors, 6);
        /* pg+$143: slot of the 24x24 icons (0..7 in the party; $0A creation, $0C editor) */
        copy_icon_set(c->b[0x143], 0x0C, 1);
        /* pg+$143: slot of the 24x24 icons (0..7 in the party; $0A creation, $0C editor) */
        copy_icon_set(0x0C, c->b[0x143], 0);
        clear_message_line();
        free_sprite_set(0x0C);
        if (ask_yes_no(0x11, "Is this icon ok? ", 0x0D, 0x0A, 0x0F) == 'Y') {
            break;
        }
    }
    /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    H005_B(0x3DE3) = saved_3de3;
    g_h047_0001 = 0;
}
