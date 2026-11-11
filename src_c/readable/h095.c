/* H095: dati del modulo (tabelle di word). */
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

/* Dati del modulo sotto a4: g_h095_bss[0x342 - off] e' -off(a4). */
u8 g_h095_bss[0x342];

#include "h095_init_data.h"

/* PORT H095+$0384 */
void h095_init(void)
{
    INIT_APPLY(s_init_2670, g_h095_bss, sizeof(g_h095_bss));
}

/*
 * Dati del modulo: -$332/-$334 riga e colonna (in blocchi) della casella
 * del dungeon in esame, -$335..-$338 le sue pareti (0 nord, 6 ovest, 2
 * est, 4 sud: 0 aperto, 1 parete, 3 porta), -$341 casella all'aperto
 * (bit 6 del piano GEO 2), -$342 bosco, -$339 lato, -$340 set caricato.
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
    return H005_B(0x3EF4 + (t - 1) * 4 + 3); /* $3EF7: terreno +3: fotogramma grafico della tessera */
}

static u8 in_map(s16 x, s16 y)
{
    return (u8)(x >= 0 && x <= 0x31 && y >= 0 && y <= 0x18);
}

/*
 * PORT H095+$0392: parte sopra della casella (dx, dy) del blocco 7x5 in
 * esame (colonna $15 + 6*col + 5*riga, riga $A + 5*riga) = tile + 1.
 */
static void set_block_cell(s16 dx, s16 dy, u16 tile)
{
    s16 x;                              /* -$2(a5) */
    s16 y;                              /* -$4(a5) */

    /* H095_bss+$10: (word) colonna (in blocchi) della casella del dungeon in esame; H095_bss+$E:
     * (word) riga (in blocchi) della casella del dungeon in esame */
    x = (s16)(H095_W(0x332) * 6 + H095_W(0x334) * 5 + 0x15 + dx);
    /* H095_bss+$E: (word) riga (in blocchi) della casella del dungeon in esame */
    y = (s16)(H095_W(0x334) * 5 + 0x0A + dy);
    if (in_map(x, y)) {
        map_cell(x, y)[1] = (u8)(tile + 1);
    }
}

/*
 * PORT H095+$0422: bosco: in un blocco con pareti adatte (nessuna porta,
 * non due lati opposti chiusi senza gli altri due) e all'aperto, le
 * caselle libere ($16) diventano alberi ($1A, 50%) con cespugli ($1B,
 * 90%) attorno.
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

    /* H095_bss+$D: parete nord del blocco (0 aperto, 1 parete, 3 porta); H095_bss+$B: parete est
     * del blocco (0 aperto, 1 parete, 3 porta); H095_bss+$A: parete sud del blocco (0 aperto, 1
     * parete, 3 porta); H095_bss+$C: parete ovest del blocco (0 aperto, 1 parete, 3 porta) */
    if (WALL_N == 1 || WALL_E == 1 || WALL_S == 1 || WALL_W == 1) {
        ok = 1;
        /* H095_bss+$D: parete nord del blocco (0 aperto, 1 parete, 3 porta); H095_bss+$A: parete
         * sud del blocco (0 aperto, 1 parete, 3 porta); H095_bss+$B: parete est del blocco (0
         * aperto, 1 parete, 3 porta); H095_bss+$C: parete ovest del blocco (0 aperto, 1 parete, 3
         * porta) */
        if (WALL_N == 1 && WALL_S == 1 && !(WALL_E == 1 && WALL_W == 1)) {
            ok = 0;
        /* H095_bss+$B: parete est del blocco (0 aperto, 1 parete, 3 porta); H095_bss+$C: parete
         * ovest del blocco (0 aperto, 1 parete, 3 porta) */
        } else if (WALL_E == 1 && WALL_W == 1 &&
                   /* H095_bss+$D: parete nord del blocco (0 aperto, 1 parete, 3 porta);
                    * H095_bss+$A: parete sud del blocco (0 aperto, 1 parete, 3 porta) */
                   !(WALL_N == 1 && WALL_S == 1)) {
            ok = 0;
        /* H095_bss+$D: parete nord del blocco (0 aperto, 1 parete, 3 porta); H095_bss+$B: parete
         * est del blocco (0 aperto, 1 parete, 3 porta); H095_bss+$A: parete sud del blocco (0
         * aperto, 1 parete, 3 porta); H095_bss+$C: parete ovest del blocco (0 aperto, 1 parete, 3
         * porta) */
        } else if (WALL_N == 3 || WALL_E == 3 || WALL_S == 3 || WALL_W == 3) {
            ok = 0;
        }
    }
    H095_B(0x342) = ok; /* H095_bss+$0: flag casella adatta al bosco (pareti senza porte) */
    for (i = 2; i <= 3; ++i) {
        for (j = 2; j <= 4; ++j) {
            /* H095_bss+$10: (word) colonna (in blocchi) della casella del dungeon in esame;
             * H095_bss+$E: (word) riga (in blocchi) della casella del dungeon in esame */
            x = (s16)(H095_W(0x332) * 6 + H095_W(0x334) * 5 + 0x15 + i + j);
            /* H095_bss+$E: (word) riga (in blocchi) della casella del dungeon in esame */
            y = (s16)(H095_W(0x334) * 5 + 0x0A + j);
            if (!in_map(x, y) || tile_frame(map_cell(x, y)[1]) != 0x16 ||
                /* H095_bss+$1: casella all'aperto: bit 6 dei flag della mappa; H095_bss+$0: flag
                 * casella adatta al bosco (pareti senza porte) */
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
 * PORT H095+$0700 (annidata in $06F2): lato dir della casella (x, y) del
 * dungeon: dentro la mappa 1 senza parete, 0 parete, 3 porta; fuori 0
 * per i lati est/ovest sulla riga del party, altrimenti 1.
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
    /* $281E: (word) y del party sulla mappa dell'area 16x16 */
    if (y == (s16)H005_W(0x281E) && (dir == 2 || dir == 6)) {
        return 0;
    }
    return 1;
}

/* PORT H095+$06F2: lato dir fra (x, y) e la casella vicina (OR dei due). */
static u8 wall_between(s16 x, s16 y, u16 dir)
{
    u16 opposite;                       /* -$4(a5) */
    u8 a;                               /* -$1(a5) */
    u8 b;                               /* -$2(a5) */

    opposite = (u16)((dir + 4) & 7);
    a = wall_side(x, y, dir);
    /* $3EE2: (word) spostamento x per direzione d (passo 2) */
    b = wall_side((s16)(x + H005_W(0x3EE2 + dir * 2)),
                  /* $3ED0: (word) spostamento y per direzione d (passo 2) */
                  (s16)(y + H005_W(0x3ED0 + dir * 2)), opposite);
    return or_byte(a, b);
}

/* PORT H095+$0848 (annidata in $083A): pavimento e parete ovest del blocco. */
static void block_floor_and_west(void)
{
    s16 i;                              /* -$2(a5) */
    s16 j;                              /* -$4(a5) */

    for (j = 2; j <= 4; ++j) {
        for (i = 0; i <= 5; ++i) {
            set_block_cell(i, j, 0x16);
        }
    }
    if (WALL_W == 1) { /* H095_bss+$C: parete ovest del blocco (0 aperto, 1 parete, 3 porta) */
        for (j = 2; j <= 4; ++j) {
            set_block_cell((s16)(j - 1), j, 4);
            set_block_cell(j, j, 3);
            set_block_cell((s16)(j + 1), j, 0x0D);
        }
    } else if (WALL_W == 3) { /* H095_bss+$C: parete ovest del blocco (0 aperto, 1 parete, 3 porta) */
        set_block_cell(1, 2, 8);
        set_block_cell(5, 4, 0);
    }
}

/* PORT H095+$0912 (annidata in $083A): lato nord al centro del blocco. */
static void block_north_middle(void)
{
    u16 t = (WALL_N == 1) ? 5 : 0x16; /* H095_bss+$D: parete nord del blocco (0 aperto, 1 parete, 3 porta) */
    /* H095_bss+$D: parete nord del blocco (0 aperto, 1 parete, 3 porta) */
    u16 b = (WALL_N == 1) ? 0x0A : 0x16;

    set_block_cell(3, 0, t);
    set_block_cell(4, 0, t);
    set_block_cell(3, 1, b);
    set_block_cell(4, 1, b);
}

/*
 * PORT H095+$09A4 (annidata in $083A): angolo nord-ovest del blocco
 * (caselle 1..2 x 0..1) secondo le pareti; corner = nessuna parete fra
 * il blocco a nord e quello a ovest.  Nei casi senza valore l'originale
 * usa word non inizializzate: qui 0.
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
    switch (WALL_N) { /* H095_bss+$D: parete nord del blocco (0 aperto, 1 parete, 3 porta) */
    case 0:
        switch (WALL_W) { /* H095_bss+$C: parete ovest del blocco (0 aperto, 1 parete, 3 porta) */
        case 0: t1 = 0x16; break;
        case 1: t1 = corner ? 0 : 0x0D; break;
        case 3: t1 = 0x0D; break;
        default: break;
        }
        break;
    case 1:
    case 3:
        if (WALL_W == 0) { /* H095_bss+$C: parete ovest del blocco (0 aperto, 1 parete, 3 porta) */
            t1 = corner ? 0x0F : 5;
        } else {
            t1 = corner ? 0x12 : 2;
        }
        break;
    default:
        break;
    }
    /* k = 2 */
    switch (WALL_N) { /* H095_bss+$D: parete nord del blocco (0 aperto, 1 parete, 3 porta) */
    case 0: t2 = 0x16; break;
    case 1: t2 = 5; break;
    case 3: t2 = 0x11; break;
    default: break;
    }
    /* k = 3 */
    switch (WALL_W) { /* H095_bss+$C: parete ovest del blocco (0 aperto, 1 parete, 3 porta) */
    case 0:
        if (WALL_N == 0) { /* H095_bss+$D: parete nord del blocco (0 aperto, 1 parete, 3 porta) */
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
    switch (WALL_W) { /* H095_bss+$C: parete ovest del blocco (0 aperto, 1 parete, 3 porta) */
    case 0:
    case 3:
        switch (WALL_N) { /* H095_bss+$D: parete nord del blocco (0 aperto, 1 parete, 3 porta) */
        case 0: t4 = 0x16; break;
        case 1: t4 = 0x0A; break;
        case 3: t4 = 0x17; break;
        default: break;
        }
        break;
    case 1:
        switch (WALL_N) { /* H095_bss+$D: parete nord del blocco (0 aperto, 1 parete, 3 porta) */
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
 * PORT H095+$0CD4 (annidata in $083A): angolo nord-est del blocco
 * (caselle 5..6 x 0..1); ne = parete a nord del blocco a est, en =
 * parete a est del blocco a nord.  Valori non inizializzati: 0.
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
    switch (WALL_N) { /* H095_bss+$D: parete nord del blocco (0 aperto, 1 parete, 3 porta) */
    case 0: t1 = (ne == 1) ? 4 : 0x16; break;
    case 1: t1 = 5; break;
    case 3: t1 = 0x0F; break;
    default: break;
    }
    /* k = 2 */
    if (WALL_N == 0) { /* H095_bss+$D: parete nord del blocco (0 aperto, 1 parete, 3 porta) */
        switch (ne) {
        case 0: t2 = 0x16; break;
        case 1:
            if (WALL_E != 0) { /* H095_bss+$B: parete est del blocco (0 aperto, 1 parete, 3 porta) */
                t2 = 3;
            } else {
                t2 = en ? 0x0B : 7;
            }
            break;
        /* H095_bss+$B: parete est del blocco (0 aperto, 1 parete, 3 porta) */
        case 3: t2 = (WALL_E == 0 && en) ? 0x18 : 1; break;
        default: break;
        }
    } else if (WALL_E) { /* H095_bss+$B: parete est del blocco (0 aperto, 1 parete, 3 porta) */
        t2 = 9;
    } else if (en) {
        t2 = 5;
    } else if (corner) {
        t2 = 0x11;
    } else {
        t2 = 0x13;
    }
    /* k = 3 */
    switch (WALL_N) { /* H095_bss+$D: parete nord del blocco (0 aperto, 1 parete, 3 porta) */
    case 0: t3 = 0x16; break;
    case 1: t3 = 0x0A; break;
    case 3: t3 = 0x10; break;
    default: break;
    }
    /* k = 4 */
    if (WALL_N == 0) { /* H095_bss+$D: parete nord del blocco (0 aperto, 1 parete, 3 porta) */
        if (ne == 0) {
            t4 = 0x16;
        } else if (WALL_E) { /* H095_bss+$B: parete est del blocco (0 aperto, 1 parete, 3 porta) */
            t4 = 4;
        } else if (en == 0) {
            t4 = 8;
        } else {
            t4 = 0x0C;
        }
    } else if (WALL_E) { /* H095_bss+$B: parete est del blocco (0 aperto, 1 parete, 3 porta) */
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
 * PORT H095+$083A: mappa del combattimento nel dungeon: per ogni casella
 * attorno al party (colonne -6..6, righe -2..2) un blocco con pavimento,
 * pareti e porte del dungeon, e alberi se all'aperto.
 */
static void build_dungeon_map(void)
{
    s16 x;                              /* -$2(a5) */
    s16 y;                              /* -$4(a5) */
    s16 row;                            /* -$334(a4) */
    s16 col;                            /* -$332(a4) */

    for (row = -2; row <= 2; ++row) {
        H095_SETW(0x334, row); /* H095_bss+$E: (word) riga (in blocchi) della casella del dungeon in esame */
        for (col = -6; col <= 6; ++col) {
            /* H095_bss+$10: (word) colonna (in blocchi) della casella del dungeon in esame */
            H095_SETW(0x332, col);
            /* $281C: (word) x del party sulla mappa dell'area 16x16; H095_bss+$10: (word) colonna
             * (in blocchi) della casella del dungeon in esame */
            x = (s16)(H005_W(0x281C) + H095_W(0x332));
            /* $281E: (word) y del party sulla mappa dell'area 16x16; H095_bss+$E: (word) riga (in
             * blocchi) della casella del dungeon in esame */
            y = (s16)(H005_W(0x281E) + H095_W(0x334));
            /* H095_bss+$C: parete ovest del blocco (0 aperto, 1 parete, 3 porta) */
            WALL_W = wall_between(x, y, 6);
            /* H095_bss+$D: parete nord del blocco (0 aperto, 1 parete, 3 porta) */
            WALL_N = wall_between(x, y, 0);
            /* H095_bss+$B: parete est del blocco (0 aperto, 1 parete, 3 porta) */
            WALL_E = wall_between(x, y, 2);
            /* H095_bss+$A: parete sud del blocco (0 aperto, 1 parete, 3 porta) */
            WALL_S = wall_between(x, y, 4);
            block_floor_and_west();
            block_north_middle();
            block_north_west(x, y);
            block_north_east(x, y);
            /* H095_bss+$1: casella all'aperto: bit 6 dei flag della mappa */
            H095_B(0x341) = mask_byte(map_flags(x, y), 0x40);
            plant_trees();
        }
    }
}

/*
 * PORT H095+$1076: all'aperto, sulle coppie di caselle libere una sopra
 * l'altra, con probabilita' 8%: un oggetto ($2A..$2B) o, con un altro
 * 8% mancato, un albero alto (cima $20..$25, tronco $26..$29).
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
 * PORT H095+$121A: decora le caselle libere all'aperto; il terreno e'
 * fisso a $28 nell'originale, quindi si usa sempre la terza tabella.
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
 * PORT H095+$1576: mappa all'aperto: tutto libero ($17, $9C3 byte come
 * l'originale), poi oggetti e terreno.  Le coordinate +$186/+$188 dello
 * stato sono lette ma non usate.
 */
static void build_wild_map(void)
{
    h029_fill_bytes(0x9C3, g_combat_area + 0x0A, 0x9C3, 0x17);
    H095_SETW(0x33E, 0x0F); /* H095_bss+$4: uso: (word) posto a $0F costruendo la mappa all'aperto */
    scatter_wild_objects();
    decorate_wild_ground();
}

/*
 * PORT H095+$1630: carica i set di tile (dungeon: DungCom, all'aperto:
 * WildCom, piu' RandCom) se diversi da quelli gia' caricati (-$340),
 * alloca la mappa ($9CE byte) e la costruisce; il fondo di ogni casella
 * prende il valore della parte sopra.
 */
static void build_combat_map(void)
{
    u16 y;                              /* -$4(a5) */
    u16 x;                              /* -$6(a5) */

    if (COK_GET16(g_state_a + 0x1CC)) { /* A+$1CC: (word) 1 area 3D (mappa 16x16), 0 mappa all'aperto */
        if (H095_W(0x340) != 1) { /* H095_bss+$2: (word) set di tile caricato: 1 dungeon, 2 all'aperto */
            load_24x24_set(7, "DungCom", 1, 0, 0x19);
            load_24x24_set(7, "RandCom", 1, 0x22, 6);
            H095_SETW(0x340, 1); /* H095_bss+$2: (word) set di tile caricato: 1 dungeon, 2 all'aperto */
        }
    } else if (H095_W(0x340) != 2) { /* H095_bss+$2: (word) set di tile caricato: 1 dungeon, 2 all'aperto */
        load_24x24_set(7, "WildCom", 1, 0, 0x21);
        load_24x24_set(7, "RandCom", 1, 0x22, 6);
        H095_SETW(0x340, 2); /* H095_bss+$2: (word) set di tile caricato: 1 dungeon, 2 all'aperto */
    }
    g_combat_area = (u8 *)exec_alloc_mem(0x9CE, COK_MEMF_CLEAR);
    g_combat_area[6] = 0;
    g_combat_area[7] = 1;
    g_combat_area[8] = 0;
    if (COK_GET16(g_state_a + 0x1CC)) { /* A+$1CC: (word) 1 area 3D (mappa 16x16), 0 mappa all'aperto */
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
 * PORT H095+$1790: per ogni personaggio: statistiche, blocco del turno
 * ($18 byte), oltre il numero di $3E00+$67C fuori combattimento (+$15);
 * direzione iniziale dalla tabella -$48 (opposta per il lato 1); i
 * personaggi fuori combattimento del party senza un'IA valida prendono
 * quella di $3E00+$58C + $80.
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
        if (n > COK_GET16(g_state_b + 0x67C)) { /* B+$67C: (word) numero dei membri del party (max 8) */
            /* turno+$15: 1 = combattente oltre i membri del party, lo lascia a fine scontro */
            p->block_192->b[0x15] = 1;
        }
        /* turno+$B: orientamento/fotogramma del combattente (direzione 0..7); H095_bss+$2FA: 4
         * word: direzione 0..7 per quarto 0..3 (anche orientamento); $2820: direzione del party (0
         * nord, 2 est, 4 sud, 6 ovest) */
        p->block_192->b[0x0B] = (u8)H095_W(0x48 - (H005_B(0x2820) >> 1) * 2);
        if (p->b[0x199] == 1) { /* pg+$199: lato in combattimento (0 party, 1 avversari) */
            /* turno+$B: orientamento/fotogramma del combattente (direzione 0..7) */
            p->block_192->b[0x0B] = (u8)((p->block_192->b[0x0B] + 4) & 7);
        }
        /* pg+$EC: controllo: <$80 PG, >$7F PNG/IA ($B3 = charme o confuso) */
        ai = mask_byte(p->b[0xEC], 0x7F);
        /* pg+$199: lato in combattimento (0 party, 1 avversari); turno+$15: 1 = combattente oltre i
         * membri del party, lo lascia a fine scontro */
        if (p->b[0x199] == 0 && p->block_192->b[0x15] == 1 &&
            (ai == 0 || ai > 0x66)) {
            /* pg+$EC: controllo: <$80 PG, >$7F PNG/IA ($B3 = charme o confuso); B+$58C: uso: IA
             * ($80+v) dei PNG fuori lotta; tolto da 100 nel test fuga */
            p->b[0xEC] = (u8)(COK_GET16(g_state_b + 0x58C) + 0x80);
        }
    }
}

/* PORT H095+$18CC: (x, y) fuori dalla griglia 11x6 di schieramento? */
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
 * PORT H095+$1914: prova a mettere il combattente n nella casella (cx,
 * cy) della griglia del gruppo (gx, gy) dello schieramento set: se la
 * griglia la permette e le caselle sono libere e praticabili, la occupa.
 */
static u8 try_place(u16 n, s16 cx, s16 cy, s16 gx, s16 gy, u16 set)
{
    u16 blocker;                        /* -$2(a5) */
    u16 tile;                           /* -$4(a5) */
    u8 in_cloud;                        /* -$5(a5) */
    u8 in_acid;                         /* -$6(a5) */

    if (cx < 0 || cy < 0 || cx > 0x0A || cy > 5 ||
        /* H095_bss+$22: griglie schieramento: lato*$120+set*$48+riga*$C+col, 1=libera; H095_bss+$9:
         * lato in esame (0 party, 1 nemici): indice di GROUP_* */
        !PLACE_TABLE(H095_B(0x339), set, cy, cx)) {
        return 0;
    }
    /* $3154: posizioni combattenti, 6 byte per n (da 1): +0 colonna (word) */
    H005_SET_W(0x3154 + (n - 1) * 6, (u16)(gx * 6 + cx + gy * 5 + 0x16));
    /* $3156: posizioni combattenti +2: riga sulla mappa (word) */
    H005_SET_W(0x3154 + (n - 1) * 6 + 2, (u16)(gy * 5 + cy + 0x0A));
    probe_move(g_combatants[n - 1], 8, &blocker, &tile, &in_cloud, &in_acid);
    /* $3EF4: terreno, $41 voci da 4 byte (da 1): +0 costo ($FF invalicabile) */
    if (blocker == 0 && tile > 0 && H005_B(0x3EF4 + (tile - 1) * 4) < 0xFF) {
        /* H095_bss+$22: griglie schieramento: lato*$120+set*$48+riga*$C+col, 1=libera; H095_bss+$9:
         * lato in esame (0 party, 1 nemici): indice di GROUP_* */
        PLACE_TABLE(H095_B(0x339), set, cy, cx) = 0;
        return 1;
    }
    return 0;
}

/* Casella del dungeon del gruppo del lato in esame. */
#define GROUP_X()   H095_W(0x324 - H095_B(0x339) * 2)
#define GROUP_Y()   H095_W(0x328 - H095_B(0x339) * 2)
#define GROUP_DIR() H095_W(0x330 - H095_B(0x339) * 2)

/*
 * PORT H095+$1A7A: cerca un posto per il combattente n a spirale attorno
 * al punto di partenza del suo lato, anello dopo anello; quando esce
 * dalla griglia passa al prossimo schieramento (fino a 3) verso una
 * direzione senza parete.  0 se non trova posto.  Uscendo dalla griglia
 * senza cambiarla l'originale controlla un byte non inizializzato: qui 0.
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

    /* H095_bss+$1E: (word) GROUP_X lato 0: x del punto di partenza del party; H095_bss+$9: lato in
     * esame (0 party, 1 nemici): indice di GROUP_* */
    gx = GROUP_X();
    /* H095_bss+$1A: (word) GROUP_Y lato 0: y del punto di partenza del party; H095_bss+$9: lato in
     * esame (0 party, 1 nemici): indice di GROUP_* */
    gy = GROUP_Y();
    do {
        /* H095_bss+$302: (word) dir*2 dello schieramento: gdir 0..3 (passo 8), set (passo 2);
         * H095_bss+$12: (word) GROUP_DIR lato 0: quarto di direzione del party; H095_bss+$9: lato
         * in esame (0 party, 1 nemici): indice di GROUP_* */
        dir = (u16)((u16)H095_W(0x40 - GROUP_DIR() * 8 - set * 2) >> 1);
        switch (state) {
        case 1:
            /* H095_bss+$2FA: 4 word: direzione 0..7 per quarto 0..3 (anche orientamento) */
            e = (u16)H095_W(0x48 - ((dir + 2) & 3) * 2);
            dx = (s16)H005_W(0x3EE2 + e * 2); /* $3EE2: (word) spostamento x per direzione d (passo 2) */
            dy = (s16)H005_W(0x3ED0 + e * 2); /* $3ED0: (word) spostamento y per direzione d (passo 2) */
            sel = set > 0 ? 1 : 0;
            /* H095_bss+$2EA: (word) x base della spirale: sel 0..1 (passo 8), dir 0..3 (passo 2) */
            bx = (s16)(H095_W(0x58 - sel * 8 - dir * 2) + dx * ring);
            /* H095_bss+$2DA: (word) y base della spirale: sel 0..1 (passo 8), dir 0..3 (passo 2) */
            by = (s16)(H095_W(0x68 - sel * 8 - dir * 2) + dy * ring);
            cx = bx;
            cy = by;
            step = 1;
            state = 2;
            side = 1;
            break;
        case 2:
            /* H095_bss+$2FA: 4 word: direzione 0..7 per quarto 0..3 (anche orientamento) */
            e = (u16)H095_W(0x48 - ((dir + 1) & 3) * 2);
            dx = (s16)H005_W(0x3EE2 + e * 2); /* $3EE2: (word) spostamento x per direzione d (passo 2) */
            dy = (s16)H005_W(0x3ED0 + e * 2); /* $3ED0: (word) spostamento y per direzione d (passo 2) */
            cx = (s16)(dx * step + bx);
            cy = (s16)(dy * step + by);
            state = 3;
            ++side;
            break;
        case 3:
            /* H095_bss+$2FA: 4 word: direzione 0..7 per quarto 0..3 (anche orientamento) */
            e = (u16)H095_W(0x48 - ((dir + 3) & 3) * 2);
            dx = (s16)H005_W(0x3EE2 + e * 2); /* $3EE2: (word) spostamento x per direzione d (passo 2) */
            dy = (s16)H005_W(0x3ED0 + e * 2); /* $3ED0: (word) spostamento y per direzione d (passo 2) */
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
                /* H095_bss+$16: 2 word per lato: (combattenti del lato+1)/2, primo anello;
                 * H095_bss+$9: lato in esame (0 party, 1 nemici): indice di GROUP_* */
                next_ring = (u8)(side >= (u16)H095_W(0x32C - H095_B(0x339) * 2));
            } else {
                next_ring = (u8)(side > 0x0B);
            }
            if (next_ring) {
                ++ring;
                /* H095_bss+$9: lato in esame (0 party, 1 nemici): indice di GROUP_*; H095_bss+$12:
                 * (word) GROUP_DIR lato 0: quarto di direzione del party */
                if (H095_B(0x339) == 0 && (H095_W(0x330) & 1) && set == 0 &&
                    ring == 1) {
                    /* H095_bss+$1E: (word) GROUP_X lato 0: x del punto di partenza del party;
                     * H095_bss+$9: lato in esame (0 party, 1 nemici): indice di GROUP_*; $281C:
                     * (word) x del party sulla mappa dell'area 16x16 */
                    mx = (s16)(GROUP_X() + H005_W(0x281C));
                    /* H095_bss+$1A: (word) GROUP_Y lato 0: y del punto di partenza del party;
                     * H095_bss+$9: lato in esame (0 party, 1 nemici): indice di GROUP_*; $281E:
                     * (word) y del party sulla mappa dell'area 16x16 */
                    my = (s16)(GROUP_Y() + H005_W(0x281E));
                    blocked = 0;
                    for (k = 1; k <= 3; ++k) {
                        /* H095_bss+$322: (word) direzione 0..7 dello schieramento k=1..3 per gdir
                         * (passo 8); H095_bss+$12: (word) GROUP_DIR lato 0: quarto di direzione del
                         * party; H095_bss+$9: lato in esame (0 party, 1 nemici): indice di GROUP_* */
                        d = H095_W(0x20 - GROUP_DIR() * 8 - k * 2);
                        /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
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
                /* H095_bss+$1E: (word) GROUP_X lato 0: x del punto di partenza del party;
                 * H095_bss+$9: lato in esame (0 party, 1 nemici): indice di GROUP_*; $281C: (word)
                 * x del party sulla mappa dell'area 16x16 */
                mx = (s16)(GROUP_X() + H005_W(0x281C));
                /* H095_bss+$1A: (word) GROUP_Y lato 0: y del punto di partenza del party;
                 * H095_bss+$9: lato in esame (0 party, 1 nemici): indice di GROUP_*; $281E: (word)
                 * y del party sulla mappa dell'area 16x16 */
                my = (s16)(GROUP_Y() + H005_W(0x281E));
                /* H095_bss+$322: (word) direzione 0..7 dello schieramento k=1..3 per gdir (passo
                 * 8); H095_bss+$12: (word) GROUP_DIR lato 0: quarto di direzione del party;
                 * H095_bss+$9: lato in esame (0 party, 1 nemici): indice di GROUP_* */
                d = H095_W(0x20 - GROUP_DIR() * 8 - set * 2);
                /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
                if (H005_B(0x3DE3) == 3 || wall_between(mx, my, (u16)d) != 1) {
                    /* H095_bss+$1E: (word) GROUP_X lato 0: x del punto di partenza del party;
                     * H095_bss+$9: lato in esame (0 party, 1 nemici): indice di GROUP_*; $3EE2:
                     * (word) spostamento x per direzione d (passo 2) */
                    gx = (s16)(GROUP_X() + H005_W(0x3EE2 + d * 2));
                    /* H095_bss+$1A: (word) GROUP_Y lato 0: y del punto di partenza del party;
                     * H095_bss+$9: lato in esame (0 party, 1 nemici): indice di GROUP_*; $3ED0:
                     * (word) spostamento y per direzione d (passo 2) */
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
 * PORT H095+$1FC2: schiera i combattenti: punti di partenza dei due lati
 * (il party dove si trova, i nemici a $3E00+$582 caselle nella direzione
 * del party), griglie di schieramento dalle tabelle -$E0, poi ogni
 * personaggio a spirale.  I caduti lasciano un corpo ($2AE2); chi non
 * trova posto ed e' fuori combattimento (+$15) lascia il party (H053).
 * Oltre 8 corpi non si registrano (l'originale scriverebbe sui
 * combattenti).
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
        /* $3159: posizioni combattenti +5: forma/taglia (0 = fuori mappa) */
        H005_B(0x3154 + (i - 1) * 6 + 5) = 0;
    }
    rebuild_occupancy();
    H095_SETW(0x324, 0); /* H095_bss+$1E: (word) GROUP_X lato 0: x del punto di partenza del party */
    H095_SETW(0x328, 0); /* H095_bss+$1A: (word) GROUP_Y lato 0: y del punto di partenza del party */
    /* $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest); H095_bss+$12: (word) GROUP_DIR
     * lato 0: quarto di direzione del party */
    H095_SETW(0x330, H005_B(0x2820) >> 1);
    /* $3EE2: (word) spostamento x per direzione d (passo 2); $2820: direzione del party (0 nord, 2
     * est, 4 sud, 6 ovest); B+$582: (word) distanza attuale dei nemici, limitata alle caselle
     * libere; H095_bss+$1E: (word) GROUP_X lato 0: x del punto di partenza del party; H095_bss+$20:
     * (word) GROUP_X lato 1: x del punto di partenza dei nemici */
    H095_SETW(0x322, (s16)H005_W(0x3EE2 + H005_B(0x2820) * 2) *
                     (s16)COK_GET16(g_state_b + 0x582) + H095_W(0x324));
    /* $3ED0: (word) spostamento y per direzione d (passo 2); $2820: direzione del party (0 nord, 2
     * est, 4 sud, 6 ovest); B+$582: (word) distanza attuale dei nemici, limitata alle caselle
     * libere; H095_bss+$1A: (word) GROUP_Y lato 0: y del punto di partenza del party; H095_bss+$1C:
     * (word) GROUP_Y lato 1: y del punto di partenza dei nemici */
    H095_SETW(0x326, (s16)H005_W(0x3ED0 + H005_B(0x2820) * 2) *
                     (s16)COK_GET16(g_state_b + 0x582) + H095_W(0x328));
    /* $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest); H095_bss+$14: (word) GROUP_DIR
     * lato 1: quarto di direzione dei nemici */
    H095_SETW(0x32E, ((H005_B(0x2820) + 4) & 7) >> 1);
    /* H095_bss+$9: lato in esame (0 party, 1 nemici): indice di GROUP_* */
    for (H095_B(0x339) = 0; H095_B(0x339) <= 1; ++H095_B(0x339)) {
        /* $2A1C: combattenti attivi del lato 0; tabella byte indicizzata dal lato; H095_bss+$9:
         * lato in esame (0 party, 1 nemici): indice di GROUP_*; H095_bss+$16: 2 word per lato:
         * (combattenti del lato+1)/2, primo anello */
        H095_SETW(0x32C - H095_B(0x339) * 2,
                  (H005_B(0x2A1C + H095_B(0x339)) + 1) >> 1);
    }
    /* H095_bss+$9: lato in esame (0 party, 1 nemici): indice di GROUP_* */
    for (H095_B(0x339) = 0; H095_B(0x339) <= 1; ++H095_B(0x339)) {
        for (set = 0; set <= 3; ++set) {
            /* H095_bss+$12: (word) GROUP_DIR lato 0: quarto di direzione del party; H095_bss+$9:
             * lato in esame (0 party, 1 nemici): indice di GROUP_* */
            shape = (set == 1) ? 4 : (u16)GROUP_DIR();
            for (r = 0; r <= 5; ++r) {
                for (c = 0; c <= 0x0A; ++c) {
                    /* H095_bss+$262: (word) colonna minima: forma 0..4 (passo $18), riga 0..5
                     * (passo 4) */
                    if (c < H095_W(0xE0 - shape * 0x18 - r * 4) ||
                        /* H095_bss+$264: (word) colonna massima: forma 0..4 (passo $18), riga 0..5
                         * (passo 4) */
                        c > H095_W(0xE0 - shape * 0x18 - r * 4 - 2)) {
                        /* H095_bss+$22: griglie schieramento: lato*$120+set*$48+riga*$C+col,
                         * 1=libera; H095_bss+$9: lato in esame (0 party, 1 nemici): indice di
                         * GROUP_* */
                        PLACE_TABLE(H095_B(0x339), set, r, c) = 0;
                    } else {
                        /* H095_bss+$22: griglie schieramento: lato*$120+set*$48+riga*$C+col,
                         * 1=libera; H095_bss+$9: lato in esame (0 party, 1 nemici): indice di
                         * GROUP_* */
                        PLACE_TABLE(H095_B(0x339), set, r, c) = 1;
                    }
                }
            }
        }
    }
    i = 1;
    H005_B(0x247B) = 1; /* $247B: numero di combattenti nella tabella +$2B32 (+1 dopo lo schieramento) */
    prev = g_party_head;
    p = g_party_head;
    while (p != NULL) {
        g_combatants[i - 1] = p;
        /* H095_bss+$9: lato in esame (0 party, 1 nemici): indice di GROUP_*; pg+$199: lato in
         * combattimento (0 party, 1 avversari) */
        H095_B(0x339) = p->b[0x199];
        /* $3158: posizioni combattenti +4: numero del combattente (byte) */
        H005_B(0x3154 + (i - 1) * 6 + 4) = (u8)i;
        /* $3159: posizioni combattenti +5: forma/taglia (0 = fuori mappa); pg+$D3: forma/taglia
         * sulla mappa di combattimento (bit 0-2, >1 grande) */
        H005_B(0x3154 + (i - 1) * 6 + 5) = mask_byte(p->b[0xD3], 7);
        if (place_in_spiral(i)) {
            prev = p;
            if (p->b[0x198] == 0) { /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento) */
                /* $3159: posizioni combattenti +5: forma/taglia (0 = fuori mappa) */
                H005_B(0x3154 + (i - 1) * 6 + 5) = 0;
                /* $24C1: uso: azzerato all'avvio; con 1 esito e caduti trattati diversamente;
                 * turno+$15: 1 = combattente oltre i membri del party, lo lascia a fine scontro */
                if (!H005_B(0x24C1) && p->block_192->b[0x15] == 0) {
                    /* $3154: posizioni combattenti, 6 byte per n (da 1): +0 colonna (word) */
                    x = (s16)H005_W(0x3154 + (i - 1) * 6);
                    /* $3156: posizioni combattenti +2: riga sulla mappa (word) */
                    y = (s16)H005_W(0x3154 + (i - 1) * 6 + 2);
                    if (H005_B(0x247A) < 8) { /* $247A: numero di corpi nella tabella +$2AE2 (max 8) */
                        /* $247A: numero di corpi nella tabella +$2AE2 (max 8) */
                        add_to_byte(&H005_B(0x247A), 1);
                        /* $247A: numero di corpi nella tabella +$2AE2 (max 8) */
                        b = &g_bodies[H005_B(0x247A) - 1];
                        b->tile = map_cell(x, y)[1];
                        map_cell(x, y)[1] = 0x1F;
                        b->who = p;
                        b->x = (u16)x;
                        b->y = (u16)y;
                    }
                }
            }
            /* pg+$197: stato: 0 ok, 4 incosciente, 5 morente, 6-8 morto, $0A a terra */
            if (p->b[0x197] == 9) {
                p->b[0x198] = 0; /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento) */
                /* $3159: posizioni combattenti +5: forma/taglia (0 = fuori mappa) */
                H005_B(0x3154 + (i - 1) * 6 + 5) = 0;
            }
            rebuild_occupancy();
            ++i;
            /* $247B: numero di combattenti nella tabella +$2B32 (+1 dopo lo schieramento) */
            add_to_byte(&H005_B(0x247B), 1);
            ++placed;
        } else {
            /* $3159: posizioni combattenti +5: forma/taglia (0 = fuori mappa) */
            H005_B(0x3154 + (i - 1) * 6 + 5) = 0;
            /* turno+$15: 1 = combattente oltre i membri del party, lo lascia a fine scontro */
            if (p->block_192->b[0x15] == 1) {
                ++skipped;
                g_combatants[i - 1] = NULL;
                g_current_char = p;
                remove_from_party(1, 0);
                p = prev;
            } else {
                prev = p;
                ++i;
                /* $247B: numero di combattenti nella tabella +$2B32 (+1 dopo lo schieramento) */
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
 * PORT H095+$2496: inizio del combattimento: libera le immagini della
 * mappa, "A battle begins...", azzera lo stato del combattimento (nubi,
 * pozze, corpi, armi perse), costruisce la mappa, prepara i turni,
 * schiera i combattenti, alloca le icone ($243A, 4 fotogrammi 24x24),
 * centra la vista sul primo, disegna, copia i colori nella View fuori
 * schermo, eventi 8 e $16 per tutti e forza dei nemici; poi contesto 5.
 */
void start_combat(void)
{
    Character *p;                       /* -$10(a5) */

    H005_B(0x24CE) = 0; /* $24CE: 1: pausa per carattere nella scrittura del testo */
    free_gfx_record(&g_gfx_27b0[0]);
    free_gfx_record(&g_gfx_27b0[1]);
    free_gfx_record(&g_gfx_2798);
    H005_B(0x2484) = 0xFF; /* $2484: id dell'immagine grande BIGPIC caricata ($FF nessuna) */
    H005_B(0x27B0) = 0xFF; /* $27B0: 2 voci da 6 byte (id + long gfx a +2): id HEAD caricato, $FF nessuno */
    H005_B(0x27B6) = 0xFF; /* $27B6: id del BODY caricato (2a voce da 6 byte di $27B0), $FF nessuno */
    clear_message_line();
    message_delay();
    ui_draw_text(0, 0x18, 0x0A, 0, 0x12, "A battle begins...");
    H005_B(0x24A0) = 0; /* $24A0: Magic On/Off (tasto 2): i personaggi in automatico lanciano magie */
    H005_B(0x24AF) = 0; /* $24AF: uso: azzerato a inizio combattimento; se 1 l'effetto $43 non agisce */
    H005_B(0x247C) = 0; /* $247C: numero del round del combattimento (0 all'inizio; bit 0 arrotonda) */
    H005_B(0x2477) = 0x0F; /* $2477: round limite del combattimento (+$247C + 15) */
    H005_SET_W(0x2A1A, 0); /* $2A1A: (word) tiro per colpire: d20 (20 vale 100) + modificatori effetti */
    H005_B(0x247A) = 0; /* $247A: numero di corpi nella tabella +$2AE2 (max 8) */
    g_clouds = NULL;                    /* $2514 */
    g_acid_pools = NULL;                /* $250C */
    H005_SET_L(0x2510, 0); /* $2510: uso: (long) azzerato a inizio combattimento accanto a $250C/$2514 */
    g_h005_2432 = NULL;
    g_thrown_tail = NULL;               /* $335C */
    g_dropped_items = NULL;             /* $3360 */
    memset(g_bodies, 0, sizeof g_bodies);   /* H029+$0312 su $50 byte */
    COK_PUT16(g_state_b + 0x666, 0); /* B+$666: (word) 1 se e' stato confermato l'attacco a un alleato */
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
        p->block_192->b[0x13] = 0; /* turno+$13: Turn Undead gia' usati nel combattimento (max H005+$248F) */
        trigger_event(&p, 8);
        trigger_event(&p, 0x16);
    }
    enemy_strength();
    H005_B(0x24CB) = 0; /* $24CB: 1 nel modo Move/Attack: cursore sulla mappa di combattimento */
    H005_B(0x24CC) = 0; /* $24CC: 1 nel modo Manual: cursore sulla mappa di combattimento */
    H005_B(0x3DE3) = 5; /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
    H005_B(0x24B0) = 0; /* $24B0: modo Move dell'esplorazione: clic sulla vista come movimento */
    memset(g_h005_0016, 0, sizeof g_h005_0016); /* H029+$0312 su $50 byte */
    H005_SET_W(0x14, 0); /* $14: numero di personaggi a terra nella lista +$16 (word, max 20) */
}
