/* H011: dati del modulo (tabelle di word e byte). */
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

/* Dati del modulo sotto a4: g_h011_bss[0xAC - off] e' -off(a4). */
u8 g_h011_bss[0xAC];

#include "h011_init_data.h"

/* PORT H011+$00FE */
void h011_init(void)
{
    INIT_APPLY(s_init_1a02, g_h011_bss, sizeof(g_h011_bss));
}

/*
 * PORT H011+$010C: copia la palette di H005+$52AE in -$AC(a4), imposta i
 * colori 17..19 a $AAA, $555, $FFF e carica i primi 20 colori.
 */
void load_game_palette(void)
{
    /* $52AE: palette corrente dello schermo, RGB4 (16 o 32 colori) */
    exec_copy_mem(&g_h005[0x52AE], g_h011_bss, 0x40);
    /* H011_bss+$22: (word) colore 17 della palette di gioco ($AAA) */
    COK_PUT16(&g_h011_bss[0xAC - 0x8A], 0x0AAA);
    /* H011_bss+$24: (word) colore 18 della palette di gioco ($555) */
    COK_PUT16(&g_h011_bss[0xAC - 0x88], 0x0555);
    /* H011_bss+$26: (word) colore 19 della palette di gioco ($FFF) */
    COK_PUT16(&g_h011_bss[0xAC - 0x86], 0x0FFF);
    graphics_load_rgb4(&g_screen->ViewPort, g_h011_bss, 0x14);
}

/* PORT H011+$0162: (x, y) e' dentro la mappa 16x16? */
static u8 map_inside(s16 x, s16 y)
{
    if (x > 0x0F || x < 0 || y > 0x0F || y < 0) {
        return 0;
    }
    return 1;
}

/*
 * Prologo comune di H011+$01AA/$04E2/$09C8: fuori dalla mappa, con
 * $2498 = 0 o $A, 0; altrimenti le coordinate fanno il giro (16 -> 0,
 * -1 -> 15).
 */
static u8 map_wrap(s16 *x, s16 *y)
{
    /* $2498: id del programma ECL dell'area corrente ($24 iniziale, $39 demo) */
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
 * PORT H011+$01AA (Map_QueryWall): parete del lato dir (0, 2, 4, 6) della
 * casella (x, y): nibble dei piani GEO 0 e 1.  Con dir dispari
 * l'originale restituisce una word non inizializzata: qui 0.
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

/* PORT H011+$04E2: byte del piano GEO 2 della casella (x, y). */
u8 map_flags(s16 x, s16 y)
{
    if (!map_wrap(&x, &y)) {
        return 0;
    }
    return g_geo_planes[0x200 + y * 16 + x];
}

/*
 * PORT H011+$09C8: porta del lato dir della casella (x, y): coppia di
 * bit del piano GEO 3 se c'e' una parete, altrimenti 1.
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
 * PORT H011+$04A6: memorizza i quattro byte di partenza della vista
 * ($2829..$2826, primo argomento in $2829).
 */
void set_view_start(u16 a, u16 b, u16 c, u16 d)
{
    H005_B(0x2829) = (u8)a; /* $2829: colore del cielo della vista (1o byte di partenza vista) */
    H005_B(0x2828) = (u8)b; /* $2828: uso: 2o byte di partenza vista (arg b di H011+$04A6) */
    H005_B(0x2827) = (u8)c; /* $2827: uso: 3o byte di partenza vista (arg c di H011+$04A6) */
    H005_B(0x2826) = (u8)d; /* $2826: uso: 4o byte di partenza vista (arg d di H011+$04A6), 8 nel dungeon */
}

/* Tabelle di word del modulo: H011_W(-off) e' -off(a4). */
#define H011_W(off) ((s16)COK_GET16(&g_h011_bss[0xAC - (off)]))
#define VIEW_X(k)   H011_W(0x58 - (k) * 2)  /* colonna del pezzo k */
#define VIEW_Y(k)   H011_W(0x6C - (k) * 2)  /* riga del pezzo k */
#define DX(d)       ((s16)H005_W(0x3EE2 + (d) * 2))  /* $3EE2: (word) spostamento x per direzione d (passo 2) */
#define DY(d)       ((s16)H005_W(0x3ED0 + (d) * 2))  /* $3ED0: (word) spostamento y per direzione d (passo 2) */

/*
 * PORT H011+$14EA (Load_WallDefinitions): carica il blocco id di
 * WALLDEFn.dax nelle posizioni da slot (1..3) del buffer $282E (blocchi
 * di $30C byte: cinque muri da $9C tessere); le tessere da $3EBC in su
 * vengono spostate al set della posizione e si caricano i set 8x8
 * (id*10+k se il blocco ne contiene piu' d'uno).  $2810 ricorda id e
 * posizione.
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
    /* $246E: disco dei dati / gruppo di risorse corrente (G_RESOURCE_GROUP) */
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
    /* $3EC6: (word) base tessere per posto muri (slot 1..3, passo 2); $3EC8: (word) base tessere
     * del posto muri 1 (sottratta alle altre) */
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
        /* $2810: tab. 3 voci da 4 byte dei set di muri: word id WALLDEF, $FFFF vuoto */
        H005_SET_W(0x2810 + (s - 1) * 4, 0xFFFF);
        /* $2812: word +2 delle voci $2810: posizione (slot 1..3), $FFFF vuoto */
        H005_SET_W(0x2812 + (s - 1) * 4, 0xFFFF);
        for (j = 1; j <= 5; ++j) {
            for (t = 0; t <= 0x9B; ++t) {
                b = &g_h005_282e[(s - 1) * 0x30C + (j - 1) * 0x9C + t];
                /* $3EBC: (word) prima tessera dei muri da spostare al set del posto */
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
    /* $2810: tab. 3 voci da 4 byte dei set di muri: word id WALLDEF, $FFFF vuoto */
    H005_SET_W(0x2810 + (slot - 1) * 4, id);
    /* $2812: word +2 delle voci $2810: posizione (slot 1..3), $FFFF vuoto */
    H005_SET_W(0x2812 + (slot - 1) * 4, slot);
}

/*
 * PORT H011+$1876 (Load3DMap_GEO): carica la mappa id di GEOn.dax: i
 * quattro piani da $100 byte (dopo 2 byte di intestazione) in $282A, e
 * la registra in $3E04+$18A.
 */
void load_geo_map(u16 id)
{
    char num[0x0A];                     /* -$5C(a5) */
    char name[0x52];                    /* -$52(a5) */
    u16 size = 0;                       /* -$54(a5) */
    u8 *buf = NULL;                     /* -$58(a5) */
    u16 pos;                            /* -$5A(a5) */

    /* $246E: disco dei dati / gruppo di risorse corrente (G_RESOURCE_GROUP) */
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
    COK_PUT16(g_state_a + 0x18A, id); /* A+$18A: (word) id della mappa GEO caricata (ricaricata al Load) */
}

/*
 * PORT H011+$0330: mappa dall'alto 11x11 attorno al party (la finestra
 * resta nella mappa 16x16): per ogni casella la tessera $104 + le pareti
 * (N 1, E 2, S 4, O 8), poi il party con la tessera $100 + dir/2.
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

/* Disegna una delle immagini "sky" mascherata nella cella (cx, cy). */
static void blit_sky(struct GfxRecord *rec, s16 cx, s16 cy)
{
    graphics_blt_mask_bitmap_rastport(rec->image, 0, 0, &g_screen->RastPort,
                                      (u16)(cx * 8 + 0x18),
                                      (u16)(cy * 8 + 0x18),
                                      (u16)(rec->count * 8), rec->rows, 0xE0,
                                      (u8 *)rec->mask->Planes[0]);
}

/*
 * PORT H011+$058E: sfondo della vista: cielo del colore $2829; all'aperto
 * di giorno (colore $B, casella senza bit 7) il sole secondo l'ora
 * ($3E04+$192) e la direzione, e verso nord l'immagine $280C; infine il
 * pavimento ($2804).
 */
static void draw_view_background(void)
{
    s16 e = 0x3E7;                      /* -$E(a5) */
    s16 f = 0;                          /* -$10(a5) */
    s16 h;                              /* -$2(a5) */

    /* $2829: colore del cielo della vista (1o byte di partenza vista) */
    graphics_set_apen(g_rastport, H005_B(0x2829));
    graphics_rect_fill(g_rastport, 0x17, 0x17, 0x70, 0x50);
    /* $281C: (word) x del party sulla mappa dell'area 16x16; $281E: (word) y del party sulla mappa
     * dell'area 16x16 */
    if (map_flags((s16)H005_W(0x281C), (s16)H005_W(0x281E)) < 0x80 &&
        H005_B(0x2829) == 0x0B) { /* $2829: colore del cielo della vista (1o byte di partenza vista) */
        h = (s16)COK_GET16(g_state_a + 0x192); /* A+$192: (word) ore del tempo di gioco */
        switch (h) {
        case 1: case 2: case 3: case 4: case 5:
            switch (H005_B(0x2820)) { /* $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
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
            switch (H005_B(0x2820)) { /* $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
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
        if (H005_B(0x2820) == 0) { /* $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
            blit_sky(g_gfx_sky_280c, 0, 2);
        }
    }
    (void)graphics_blt_bitmap(g_gfx_sky_2804->image, 0, 3,
                              g_screen->RastPort.BitMap, 0x18, 0x43, 0x58,
                              0x2D, 0xC0, 0xFF, NULL);
}

/*
 * PORT H011+$0868: pezzo kind (0..9) del muro wall alla cella (x, y)
 * della vista 11x11: le tessere del muro (blocchi di $9C da $282E, dalla
 * posizione della tabella -$1C) per un rettangolo largo -$30[kind] e alto
 * -$44[kind]; le celle fuori dalla vista si saltano, la tessera 0 e'
 * trasparente.
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

    tile = H011_W(0x1C - kind * 2); /* H011_bss+$90: tabella 10 word: tile iniziale del pezzo kind 0..9 */
    /* H011_bss+$7C: tabella 10 word: larghezza in tile del pezzo kind 0..9 */
    x_end = (s16)(H011_W(0x30 - kind * 2) + x - 1);
    /* H011_bss+$68: tabella 10 word: altezza in tile del pezzo kind 0..9 */
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

/* Celle a distanza 2: muri frontali, giunti (9) e lati (1, 2). */
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
                /* H011_bss+$66: (word) VIEW_X(9): colonna del pezzo di muro 9 nella vista;
                 * H011_bss+$52: (word) VIEW_Y(9): riga del pezzo di muro 9 nella vista */
                draw_wall_piece((s16)(VIEW_X(9) + off + 1), VIEW_Y(9), prev, 9);
            }
            prev = w;
            /* H011_bss+$54: (word) VIEW_X(0): colonna del pezzo di muro 0 nella vista;
             * H011_bss+$40: (word) VIEW_Y(0): riga del pezzo di muro 0 nella vista */
            draw_wall_piece((s16)(VIEW_X(0) + off), VIEW_Y(0), w, 0);
        } else {
            if (prev > 0 &&
                /* $3EE2: (word) spostamento x per direzione d (passo 2); $3ED0: (word) spostamento
                 * y per direzione d (passo 2) */
                map_wall((s16)(px - DX(left)), (s16)(py - DY(left)), left)) {
                /* H011_bss+$66: (word) VIEW_X(9): colonna del pezzo di muro 9 nella vista;
                 * H011_bss+$52: (word) VIEW_Y(9): riga del pezzo di muro 9 nella vista */
                draw_wall_piece((s16)(VIEW_X(9) + off + 1), VIEW_Y(9), prev, 9);
            }
            prev = 0;
        }
        ++i;
        off = (s16)(off - 2);
        px = (s16)(px + DX(left)); /* $3EE2: (word) spostamento x per direzione d (passo 2) */
        py = (s16)(py + DY(left)); /* $3ED0: (word) spostamento y per direzione d (passo 2) */
    }
    px = vx; py = vy; i = 0; off = 0; prev = 0;
    while (i < 4) {
        w = map_wall(px, py, dir);
        if (!map_inside(px, py) && map_wall(px, py, left) == 0) {
            prev = 0;
        }
        if (w) {
            if (prev > 0) {
                /* H011_bss+$66: (word) VIEW_X(9): colonna del pezzo di muro 9 nella vista;
                 * H011_bss+$52: (word) VIEW_Y(9): riga del pezzo di muro 9 nella vista */
                draw_wall_piece((s16)(VIEW_X(9) + off - 1), VIEW_Y(9), prev, 9);
            }
            prev = w;
            /* H011_bss+$54: (word) VIEW_X(0): colonna del pezzo di muro 0 nella vista;
             * H011_bss+$40: (word) VIEW_Y(0): riga del pezzo di muro 0 nella vista */
            draw_wall_piece((s16)(VIEW_X(0) + off), VIEW_Y(0), w, 0);
        } else {
            if (prev > 0 &&
                /* $3EE2: (word) spostamento x per direzione d (passo 2); $3ED0: (word) spostamento
                 * y per direzione d (passo 2) */
                map_wall((s16)(px - DX(right)), (s16)(py - DY(right)), right)) {
                /* H011_bss+$66: (word) VIEW_X(9): colonna del pezzo di muro 9 nella vista;
                 * H011_bss+$52: (word) VIEW_Y(9): riga del pezzo di muro 9 nella vista */
                draw_wall_piece((s16)(VIEW_X(9) + off - 1), VIEW_Y(9), prev, 9);
            }
            prev = 0;
        }
        ++i;
        off = (s16)(off + 2);
        px = (s16)(px + DX(right)); /* $3EE2: (word) spostamento x per direzione d (passo 2) */
        py = (s16)(py + DY(right)); /* $3ED0: (word) spostamento y per direzione d (passo 2) */
    }
    px = vx; py = vy; i = 0; off = 0;
    while (i < 3) {
        w = map_wall(px, py, left);
        if (w) {
            if (i == 0) {
                /* H011_bss+$56: (word) VIEW_X(1): colonna del pezzo di muro 1 nella vista;
                 * H011_bss+$42: (word) VIEW_Y(1): riga del pezzo di muro 1 nella vista */
                draw_wall_piece((s16)(VIEW_X(1) + off), VIEW_Y(1), w, 1);
            } else {
                /* H011_bss+$56: (word) VIEW_X(1): colonna del pezzo di muro 1 nella vista;
                 * H011_bss+$42: (word) VIEW_Y(1): riga del pezzo di muro 1 nella vista */
                draw_wall_piece((s16)(VIEW_X(1) + off - 1), VIEW_Y(1), w, 1);
            }
        }
        ++i;
        off = (s16)(off - 2);
        px = (s16)(px + DX(left)); /* $3EE2: (word) spostamento x per direzione d (passo 2) */
        py = (s16)(py + DY(left)); /* $3ED0: (word) spostamento y per direzione d (passo 2) */
    }
    px = vx; py = vy; i = 0; off = 0;
    while (i < 3) {
        w = map_wall(px, py, right);
        if (w) {
            if (i == 0) {
                /* H011_bss+$58: (word) VIEW_X(2): colonna del pezzo di muro 2 nella vista;
                 * H011_bss+$44: (word) VIEW_Y(2): riga del pezzo di muro 2 nella vista */
                draw_wall_piece((s16)(VIEW_X(2) + off), VIEW_Y(2), w, 2);
            } else {
                /* H011_bss+$58: (word) VIEW_X(2): colonna del pezzo di muro 2 nella vista;
                 * H011_bss+$44: (word) VIEW_Y(2): riga del pezzo di muro 2 nella vista */
                draw_wall_piece((s16)(VIEW_X(2) + off + 1), VIEW_Y(2), w, 2);
            }
        }
        ++i;
        off = (s16)(off + 2);
        px = (s16)(px + DX(right)); /* $3EE2: (word) spostamento x per direzione d (passo 2) */
        py = (s16)(py + DY(right)); /* $3ED0: (word) spostamento y per direzione d (passo 2) */
    }
}

/* Celle a distanza 1: muri frontali (3) e lati (4, 5). */
static void draw_view_mid(s16 vx, s16 vy, u16 dir, u16 left, u16 right)
{
    s16 px;
    s16 py;
    u16 i;
    s16 off;
    u16 w;
    u16 w2;

    px = (s16)(vx + DX(left) + DX(left)); /* $3EE2: (word) spostamento x per direzione d (passo 2) */
    py = (s16)(vy + DY(left) + DY(left)); /* $3ED0: (word) spostamento y per direzione d (passo 2) */
    i = 0;
    off = -6;
    while (i < 3) {
        w = map_wall(px, py, dir);
        if (w) {
            /* H011_bss+$5A: (word) VIEW_X(3): colonna del pezzo di muro 3 nella vista;
             * H011_bss+$46: (word) VIEW_Y(3): riga del pezzo di muro 3 nella vista */
            draw_wall_piece((s16)(VIEW_X(3) + off), VIEW_Y(3), w, 3);
        }
        w2 = map_wall(px, py, left);
        if (w2) {
            /* H011_bss+$5C: (word) VIEW_X(4): colonna del pezzo di muro 4 nella vista;
             * H011_bss+$48: (word) VIEW_Y(4): riga del pezzo di muro 4 nella vista */
            draw_wall_piece((s16)(VIEW_X(4) + off), VIEW_Y(4), w2, 4);
        }
        ++i;
        off = (s16)(off + 3);
        px = (s16)(px + DX(right)); /* $3EE2: (word) spostamento x per direzione d (passo 2) */
        py = (s16)(py + DY(right)); /* $3ED0: (word) spostamento y per direzione d (passo 2) */
    }
    px = (s16)(vx + DX(right) + DX(right)); /* $3EE2: (word) spostamento x per direzione d (passo 2) */
    py = (s16)(vy + DY(right) + DY(right)); /* $3ED0: (word) spostamento y per direzione d (passo 2) */
    i = 0;
    off = 6;
    while (i < 3) {
        w = map_wall(px, py, dir);
        if (w) {
            /* H011_bss+$5A: (word) VIEW_X(3): colonna del pezzo di muro 3 nella vista;
             * H011_bss+$46: (word) VIEW_Y(3): riga del pezzo di muro 3 nella vista */
            draw_wall_piece((s16)(VIEW_X(3) + off), VIEW_Y(3), w, 3);
        }
        w2 = map_wall(px, py, right);
        if (w2) {
            /* H011_bss+$5E: (word) VIEW_X(5): colonna del pezzo di muro 5 nella vista;
             * H011_bss+$4A: (word) VIEW_Y(5): riga del pezzo di muro 5 nella vista */
            draw_wall_piece((s16)(VIEW_X(5) + off), VIEW_Y(5), w2, 5);
        }
        ++i;
        off = (s16)(off - 3);
        px = (s16)(px + DX(left)); /* $3EE2: (word) spostamento x per direzione d (passo 2) */
        py = (s16)(py + DY(left)); /* $3ED0: (word) spostamento y per direzione d (passo 2) */
    }
}

/* Celle a distanza 0: muri frontali (6) e lati (7, 8). */
static void draw_view_near(s16 vx, s16 vy, u16 dir, u16 left, u16 right)
{
    s16 px;
    s16 py;
    u16 i;
    s16 off;
    u16 w;
    u16 w2;

    px = (s16)(vx + DX(left)); /* $3EE2: (word) spostamento x per direzione d (passo 2) */
    py = (s16)(vy + DY(left)); /* $3ED0: (word) spostamento y per direzione d (passo 2) */
    i = 0;
    off = -7;
    while (i < 2) {
        w = map_wall(px, py, dir);
        if (w) {
            /* H011_bss+$60: (word) VIEW_X(6): colonna del pezzo di muro 6 nella vista;
             * H011_bss+$4C: (word) VIEW_Y(6): riga del pezzo di muro 6 nella vista */
            draw_wall_piece((s16)(VIEW_X(6) + off), VIEW_Y(6), w, 6);
        }
        w2 = map_wall(px, py, left);
        if (w2) {
            /* H011_bss+$62: (word) VIEW_X(7): colonna del pezzo di muro 7 nella vista;
             * H011_bss+$4E: (word) VIEW_Y(7): riga del pezzo di muro 7 nella vista */
            draw_wall_piece((s16)(VIEW_X(7) + off), VIEW_Y(7), w2, 7);
        }
        ++i;
        off = (s16)(off + 7);
        px = (s16)(px + DX(right)); /* $3EE2: (word) spostamento x per direzione d (passo 2) */
        py = (s16)(py + DY(right)); /* $3ED0: (word) spostamento y per direzione d (passo 2) */
    }
    px = (s16)(vx + DX(right)); /* $3EE2: (word) spostamento x per direzione d (passo 2) */
    py = (s16)(vy + DY(right)); /* $3ED0: (word) spostamento y per direzione d (passo 2) */
    i = 0;
    off = 7;
    while (i < 2) {
        w = map_wall(px, py, dir);
        if (w) {
            /* H011_bss+$60: (word) VIEW_X(6): colonna del pezzo di muro 6 nella vista;
             * H011_bss+$4C: (word) VIEW_Y(6): riga del pezzo di muro 6 nella vista */
            draw_wall_piece((s16)(VIEW_X(6) + off), VIEW_Y(6), w, 6);
        }
        w2 = map_wall(px, py, right);
        if (w2) {
            /* H011_bss+$64: (word) VIEW_X(8): colonna del pezzo di muro 8 nella vista;
             * H011_bss+$50: (word) VIEW_Y(8): riga del pezzo di muro 8 nella vista */
            draw_wall_piece((s16)(VIEW_X(8) + off), VIEW_Y(8), w2, 8);
        }
        ++i;
        off = (s16)(off - 7);
        px = (s16)(px + DX(left)); /* $3EE2: (word) spostamento x per direzione d (passo 2) */
        py = (s16)(py + DY(left)); /* $3ED0: (word) spostamento y per direzione d (passo 2) */
    }
}

/*
 * PORT H011+$0B78: vista 3D del dungeon dalla casella (x, y) verso dir:
 * con la mappa attiva ($2825) la mappa dall'alto; altrimenti lo sfondo e
 * i muri dalle celle a distanza 2 fino a quella del party, dal fondo
 * verso l'osservatore.  Poi mostra il buffer e ricarica la palette.
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
    if (H005_B(0x2825)) { /* $2825: flag mappa dall'alto attiva al posto della vista 3D */
        draw_area_map(x, y, dir);
    } else {
        H005_B(0x2486) = 0xFF; /* $2486: id della sequenza caricata in $27BC (nome a $27A6), $FF nessuna */
        draw_view_background();
        left = (u16)((dir + 6) & 7);
        back = (u16)((dir + 4) & 7);
        right = (u16)((dir + 2) & 7);
        vx = x;
        vy = y;
        dist = 2;
        vx = (s16)(vx + DX(dir) * dist); /* $3EE2: (word) spostamento x per direzione d (passo 2) */
        vy = (s16)(vy + DY(dir) * dist); /* $3ED0: (word) spostamento y per direzione d (passo 2) */
        do {
            switch (dist) {
            case 2: draw_view_far(vx, vy, dir, left, right); break;
            case 1: draw_view_mid(vx, vy, dir, left, right); break;
            case 0: draw_view_near(vx, vy, dir, left, right); break;
            default: break;
            }
            vx = (s16)(vx + DX(back)); /* $3EE2: (word) spostamento x per direzione d (passo 2) */
            vy = (s16)(vy + DY(back)); /* $3ED0: (word) spostamento y per direzione d (passo 2) */
            --dist;
        } while (dist > -1);
    }
    end_screen_update();
    load_game_palette();
}
