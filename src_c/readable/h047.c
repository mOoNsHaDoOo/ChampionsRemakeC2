/* H047: dati del modulo. */
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

/* Stato di H047+$00E6 condiviso con le procedure annidate. */
typedef struct IconEditor {
    s16 cur;                            /* -$128(a5): parte attuale */
    s16 count;                          /* -$126(a5): numero di parti */
    u8 mode;                            /* -$25(a5): 'H' testa, altro corpo */
} IconEditor;

/*
 * PORT H047+$00F4: procedura annidata: le due pose dell'icona (posto $0C)
 * sopra lo sfondo (posto $19) alle celle (col, row) e (col + 3, row).
 */
static void draw_icon_pair(u16 col, u16 row)
{
    draw_sprite_set(col, row, 0, 0, 0x19);
    draw_sprite_set((u16)(col + 3), row, 0, 0, 0x19);
    draw_sprite_set(col, row, 0, 0, 0x0C);
    draw_sprite_set((u16)(col + 3), row, 0, 1, 0x0C);
}

/*
 * PORT H047+$0162: procedura annidata: parte attuale e numero di parti:
 * teste (+$141, $0B o $0D secondo +$144) o corpi (+$142, $24 o $28).
 */
static void set_part_range(IconEditor *e)
{
    Character *c = g_current_char;

    if (e->mode == 'H') {
        e->cur = c->b[0x141];
        e->count = (s16)(c->b[0x144] == 1 ? 0x0B : 0x0D);
    } else {
        e->count = (s16)(c->b[0x144] == 1 ? 0x24 : 0x28);
        e->cur = c->b[0x142];
    }
}

/*
 * PORT H047+$01EE: procedura annidata: cella della griglia 7x7 (da
 * colonna 6 e riga 1, celle 24x24) sotto il mouse, come spostamento
 * rispetto alla parte attuale; *done se e' la parte attuale stessa.
 */
static void pick_by_mouse(IconEditor *e, s16 *x, s16 *y, u8 *done)
{
    s16 n;                              /* -$6(a5) */

    *x = (s16)((s16)H005_W(0x2356) / 0x18 - 6);
    *y = (s16)((s16)H005_W(0x2354) / 0x18 - 1);
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
 * PORT H047+$02FE: procedura annidata: disegna nella griglia la cella n
 * con l'icona composta da testa head e corpo body (posto $0C); con
 * highlight sopra lo sfondo $19, altrimenti su un quadrato di colore 8.
 */
static void draw_part_cell(s16 n, s16 head, s16 body, u8 highlight)
{
    Character *c = g_current_char;
    s16 cx = (s16)((n - 1) % 7 + 6);    /* -$6(a5) */
    s16 cy = (s16)((n - 1) / 7 + 1);    /* -$8(a5) */
    u8 old_143 = c->b[0x143];
    u8 old_141 = c->b[0x141];
    u8 old_142 = c->b[0x142];

    c->b[0x143] = 0x0C;
    c->b[0x141] = (u8)head;
    c->b[0x142] = (u8)body;
    if (highlight) {
        draw_sprite_set((u16)cx, (u16)cy, 0, 0, 0x19);
    } else {
        fill_cells((u16)(cx * 3), (u16)(cy * 3), 3, 3, 8, g_gfx_3d8e);
    }
    build_char_icon(0);
    draw_sprite_set((u16)cx, (u16)cy, 0, 0, 0x0C);
    c->b[0x143] = old_143;
    c->b[0x141] = old_141;
    c->b[0x142] = old_142;
}

/*
 * PORT H047+$03EE: procedura annidata: sposta la parte scelta di (dx, dy)
 * nella griglia (con giro ai bordi e all'ultima riga incompleta), la
 * memorizza in +$141 o +$142 e ridisegna le due celle cambiate o, con
 * redraw_all, tutta la griglia.
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
        c->b[0x141] = (u8)n;
    } else {
        c->b[0x142] = (u8)n;
    }
    body = c->b[0x142];
    head = c->b[0x141];
    if (redraw_all) {
        fill_cells(0x12, 3, 0x15, 0x12, 0, g_gfx_3d8e);
        for (i = 1; i <= e->count; ++i) {
            if (e->mode == 'H') {
                head = i;
                highlight = (u8)(c->b[0x141] == i);
            } else {
                body = i;
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
 * PORT H047+$0688: procedura annidata: copia immagini e maschere dei due
 * set 24x24 del posto src nel posto dst; con recolor, se +$142 < 32,
 * applica ai due set di dst i colori del personaggio (+$146.., nibble
 * basso sul registro H005+$5228[i], alto sul registro + 8).
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
        to[H005_B(0x5228 + i - 1)] = mask_byte(c->b[0x146 + i - 1], 0x0F);
        to[H005_B(0x5228 + i - 1) + 8] =
            (u8)(mask_byte(c->b[0x146 + i - 1], 0xF0) >> 4);
    }
    if (c->b[0x142] < 0x20) {
        remap_gfx_colors(from, to, 0, g_sprite_sets[dst][0]);
        remap_gfx_colors(from, to, 0, g_sprite_sets[dst][1]);
    }
}

/* Copia con dbeq $28: al massimo 41 byte, NUL compreso. */
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
 * PORT H047+$00E6 (corpo a $08D6): editor dell'icona del personaggio
 * corrente.  Sei stati con il proprio menu: 1 parti/colori/dimensione,
 * 2 testa o arma, 3 parte da colorare, 4 dimensione, 5 colore successivo
 * o precedente, 6 scelta della parte nella griglia (tastiera, tastierino
 * o mouse).  "Exit" dal primo stato conferma; poi "Is this icon ok?".
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
    s16 back = 0;                       /* -$24(a5): nell'originale non
                                         * inizializzata prima del primo
                                         * stato; qui 0 */
    s16 mx;                             /* -$6(a5) */
    s16 my;                             /* -$8(a5) */

    e.cur = 0;
    e.count = 0;
    e.mode = 0;
    saved_3de3 = H005_B(0x3DE3);
    H005_B(0x3DE3) = 0;
    copy_menu(menus[1], "Head Weapon Exit");
    copy_menu(menus[2], "Weapon Body xxxx Shield Arm Leg Exit");
    copy_menu(menus[3], " Keep Exit");
    copy_menu(menus[4], "Next Prev Keep Exit");
    copy_menu(menus[5], "Done");
    draw_screen_frame(1);
    load_char_screens();
    graphics_load_rgb4(&g_screen->ViewPort, &g_h005[0x522E], 0x20);
    build_char_icon(0);

    for (;;) {                          /* H047+$0960 */
        c = g_current_char;
        state = 1;
        memcpy(saved_colors, &c->b[0x146], 6);
        saved_143 = c->b[0x143];
        c->b[0x143] = 0x0C;
        build_char_icon(0);
        c->b[0x143] = (u8)saved_143;
        head = c->b[0x141];
        body = c->b[0x142];
        size = c->b[0x144];
        copy_icon_set(c->b[0x143], 0x0C, 1);
        draw_icon_pair(1, 2);
        ui_draw_text(8, 6, 0x0F, 0, 3, "old");
        ui_draw_text(3, 0x0A, 0x0F, 0, 0x0E, "ready   action");
        ui_draw_text(8, 0x0C, 0x0F, 0, 3, "new");
        ui_draw_text(3, 0x10, 0x0F, 0, 0x0E, "ready   action");
        do {                            /* H047+$0A70 */
            draw_icon_pair(1, 4);
            in_grid = (u8)(state == 6);
            if (c->b[0x142] >= 0x20) {
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
                        if (c->b[0x144] == 2) {
                            c->b[0x144] = 1;
                            if (c->b[0x142] >= 0x24) {
                                c->b[0x142] = 0x24;
                            }
                            if (c->b[0x141] >= 0x0B) {
                                c->b[0x141] = 0x0B;
                            }
                        } else {
                            c->b[0x144] = 2;
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
                        c->b[0x144] = 2;
                        build_char_icon(0);
                        break;
                    case 'S':
                        c->b[0x144] = 1;
                        build_char_icon(0);
                        break;
                    case 'K':
                        size = c->b[0x144];
                        state = 1;
                        key = ' ';
                        break;
                    case 0: case 'E':
                        c->b[0x144] = (u8)size;
                        state = 1;
                        key = ' ';
                        break;
                    default:
                        break;
                    }
                    build_char_icon(0);
                    break;
                case 5:             /* H047+$0ED4 */
                    lo = mask_byte(c->b[0x146 + color_part - 1], 0x0F);
                    hi = (s16)(mask_byte(c->b[0x146 + color_part - 1],
                                         0xF0) >> 4);
                    switch (key) {
                    case 'N':
                        if (second) {
                            hi = (s16)((hi + 1) & 0x0F);
                        } else {
                            lo = (s16)((lo + 1) & 0x0F);
                        }
                        c->b[0x146 + color_part - 1] = (u8)((hi << 4) + lo);
                        break;
                    case 'P':
                        if (second) {
                            hi = mask_byte((u8)(hi - 1), 0x0F);
                        } else {
                            lo = mask_byte((u8)(lo - 1), 0x0F);
                        }
                        c->b[0x146 + color_part - 1] = (u8)((hi << 4) + lo);
                        break;
                    case 'K':
                        memcpy(saved_colors, &c->b[0x146], 6);
                        state = back;
                        key = ' ';
                        break;
                    case 0: case 'E':
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
                            c->b[0x141] = (u8)head;
                        } else {
                            c->b[0x142] = (u8)body;
                        }
                        state = 0;
                        break;
                    case 0x0D: case 'D':        /* H047+$1188 */
                        if (G_MOUSE_CLICK) {
                            if ((s16)H005_W(0x2356) < 0x28 &&
                                (s16)H005_W(0x2354) >= 0xC0) {
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
                                head = c->b[0x141];
                            } else {
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
                        state = (s16)(c->b[0x142] >= 0x20 ? 1 : 2);
                        key = ' ';
                    }
                    break;
                default:
                    break;
                }
            }
            copy_icon_set(c->b[0x143], 0x0C, 1);        /* H047+$1386 */
        } while (!(back == 1 && (key == 'E' || key == 0)));

        c->b[0x141] = (u8)head;
        c->b[0x142] = (u8)body;
        c->b[0x144] = (u8)size;
        memcpy(&c->b[0x146], saved_colors, 6);
        copy_icon_set(c->b[0x143], 0x0C, 1);
        copy_icon_set(0x0C, c->b[0x143], 0);
        clear_message_line();
        free_sprite_set(0x0C);
        if (ask_yes_no(0x11, "Is this icon ok? ", 0x0D, 0x0A, 0x0F) == 'Y') {
            break;
        }
    }
    H005_B(0x3DE3) = saved_3de3;
    g_h047_0001 = 0;
}
