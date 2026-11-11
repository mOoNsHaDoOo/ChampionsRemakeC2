/* H048: dati del modulo. */
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
 * PORT H048+$0154: casella (x, y) della mappa del combattimento: in *tile
 * il byte $2ADE+$A+y*100+x*2+1, in *value H005+$2BD2+y*$32+x; fuori dalla
 * mappa 0.  Senza mappa (fuori dal combattimento l'originale legge da
 * $2ADE = 0, cioe' la memoria bassa) qui vale 0.
 */
void combat_map_cell(s16 x, s16 y, u16 *value, u16 *tile)
{
    if (x >= 0 && x <= 0x31 && y >= 0 && y <= 0x18) {
        if (g_combat_area != NULL) {
            *tile = g_combat_area[0x0A + y * 100 + x * 2 + 1];
        } else {
            *tile = 0;
        }
        /* $2BD2: occupazione mappa combattimento 50x25 byte: n. combattente o 0 */
        *value = H005_B(0x2BD2 + y * 0x32 + x);
    } else {
        *value = 0;
        *tile = 0;
    }
}

/*
 * Mappa del combattimento (H005+$2ADE): intestazione di $A byte (+$2/+$4
 * angolo della vista 7x7, +$6 cursore acceso, +$7 sua forma, +$8 senza
 * controllo delle altezze) e 25 righe di 50 caselle da 2 byte (fondo,
 * sopra).  H005+$3154: 6 byte per combattente (x, y, +$5 forma); $3104 e
 * $30B4 le sue coordinate nella vista.
 */
#define AREA_X0         ((s16)COK_GET16(g_combat_area + 2))
#define AREA_Y0         ((s16)COK_GET16(g_combat_area + 4))
/* $3154: posizioni combattenti, 6 byte per n (da 1): +0 colonna (word) */
#define POS_X(n)        ((s16)H005_W(0x3154 + ((n) - 1) * 6))
/* $3156: posizioni combattenti +2: riga sulla mappa (word) */
#define POS_Y(n)        ((s16)H005_W(0x3154 + ((n) - 1) * 6 + 2))
/* $3159: posizioni combattenti +5: forma/taglia (0 = fuori mappa) */
#define POS_SIZE(n)     H005_B(0x3154 + ((n) - 1) * 6 + 5)
/* $3104: (word) colonna nella vista per combattente n (passo 2, da 1) */
#define VIEW_X(n)       ((s16)H005_W(0x3104 + ((n) - 1) * 2))
/* $30B4: (word) riga nella vista per combattente n (passo 2, da 1) */
#define VIEW_Y(n)       ((s16)H005_W(0x30B4 + ((n) - 1) * 2))
/* $3EF7: terreno +3, fotogramma grafico della tessera t ($41 voci da 4 byte, da 1) */
#define TILE_FRAME(t)   H005_B(0x3EF4 + ((t) - 1) * 4 + 3)

static u8 *map_cell(s16 x, s16 y)
{
    return g_combat_area + 0x0A + (s32)y * 0x64 + x * 2;
}

/* Fondo e, se diverso, la parte sopra della casella (x, y) nella cella (col, row). */
static void draw_map_cell(s16 col, s16 row, s16 x, s16 y)
{
    u8 *cell = map_cell(x, y);

    draw_map_tile(col, row, TILE_FRAME(cell[0]), 0); /* $3EF7: terreno +3: fotogramma grafico della tessera */
    if (cell[0] != cell[1]) {
        /* $3EF7: terreno +3: fotogramma grafico della tessera */
        draw_map_tile(col, row, TILE_FRAME(cell[1]), 1);
    }
}

/* La figura del combattente n nella sua cella della vista. */
static void draw_combatant(u16 n)
{
    Character *c = g_combatants[n - 1];

    /* $3104: (word) colonna nella vista per combattente n (passo 2, da 1); $30B4: (word) riga nella
     * vista per combattente n (passo 2, da 1); turno+$B: orientamento/fotogramma del combattente
     * (direzione 0..7) */
    draw_sprite_set((u16)VIEW_X(n), (u16)VIEW_Y(n), c->block_192->b[0x0B], 0,
                    /* pg+$143: posto delle icone 24x24 (0..7 nel party; $0A creazione, $0C editor) */
                    c->b[0x143]);
}

/*
 * PORT H048+$0044: casella i (0..3) della forma size (tabella H005+$5048,
 * 16 byte per forma): spostamento in *dx, *dy; vera se *dx >= 0.  Con
 * size = 0 nessuna casella.
 */
u8 shape_cell(u16 size, u16 i, s16 *dx, s16 *dy)
{
    if (size == 0) {
        return 0;
    }
    /* $5048: celle delle forme: 16 byte per forma, 4 celle; +0 dx (word) */
    *dx = (s16)H005_W(0x5048 + (size - 1) * 16 + i * 4);
    *dy = (s16)H005_W(0x5048 + (size - 1) * 16 + i * 4 + 2); /* $504A: celle delle forme +2: dy (word) */
    return (u8)(*dx >= 0);
}

/* PORT H048+$00C2: coordinate nella vista ($3104/$30B4) di tutti i combattenti. */
void update_view_positions(void)
{
    u16 i;

    /* $247B: numero di combattenti nella tabella +$2B32 (+1 dopo lo schieramento) */
    for (i = 1; i <= H005_B(0x247B); ++i) {
        /* $3154: posizioni combattenti, 6 byte per n (da 1): +0 colonna (word); $3104: (word)
         * colonna nella vista per combattente n (passo 2, da 1) */
        H005_SET_W(0x3104 + (i - 1) * 2, (u16)(POS_X(i) - AREA_X0));
        /* $3156: posizioni combattenti +2: riga sulla mappa (word); $30B4: (word) riga nella vista
         * per combattente n (passo 2, da 1) */
        H005_SET_W(0x30B4 + (i - 1) * 2, (u16)(POS_Y(i) - AREA_Y0));
    }
}

/* PORT H048+$01E8: (x, y) e' dentro la vista 7x7? */
u8 in_view(s16 x, s16 y)
{
    if (x < 0 || x > 6 || y < 0 || y > 6) {
        return 0;
    }
    return 1;
}

/*
 * PORT H048+$0230: il combattente c e' nella vista: con all tutte le sue
 * caselle, altrimenti almeno una.  Senza forma (+$5 = 0) no.
 */
u8 combatant_visible(Character *c, u8 all)
{
    u8 r = 1;                           /* -$D(a5) */
    u16 n;                              /* -$4(a5) */
    u16 i;                              /* -$2(a5) */
    s16 dx;                             /* -$6(a5) */
    s16 dy;                             /* -$8(a5) */

    n = combatant_index(c);
    if (POS_SIZE(n) == 0) { /* $3159: posizioni combattenti +5: forma/taglia (0 = fuori mappa) */
        return 0;
    }
    for (i = 0; i <= 3; ++i) {
        /* $3159: posizioni combattenti +5: forma/taglia (0 = fuori mappa) */
        if (!shape_cell(POS_SIZE(n), i, &dx, &dy)) {
            continue;
        }
        /* $3104: (word) colonna nella vista per combattente n (passo 2, da 1); $30B4: (word) riga
         * nella vista per combattente n (passo 2, da 1) */
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
 * PORT H048+$0334: ridisegna la casella (x, y) della mappa con la forma
 * del cursore (+$7), il cursore stesso (set $19) se acceso (+$6) e il
 * combattente che la occupa.
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
 * PORT H048+$0588: ridisegna il terreno sotto il combattente who (tutte
 * le sue caselle nella vista); con who = 0 quello della casella (sx, sy)
 * della vista, o del combattente che la occupa.
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
        sx = VIEW_X(who); /* $3104: (word) colonna nella vista per combattente n (passo 2, da 1) */
        sy = VIEW_Y(who); /* $30B4: (word) riga nella vista per combattente n (passo 2, da 1) */
        x = (s16)(sx + AREA_X0);
        y = (s16)(sy + AREA_Y0);
        size = POS_SIZE(who); /* $3159: posizioni combattenti +5: forma/taglia (0 = fuori mappa) */
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

/* PORT H048+$0884: ridisegna la casella (x, y) e chi la occupa. */
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
 * PORT H048+$0956: rifa la tabella di occupazione H005+$2BD2 (50x25 byte,
 * numero del combattente) e le coordinate nella vista di chi ha una forma.
 */
void rebuild_occupancy(void)
{
    u16 n;                              /* -$2(a5) */
    u16 i;                              /* -$4(a5) */
    s16 dx;                             /* -$6(a5) */
    s16 dy;                             /* -$8(a5) */

    /* $2BD2: occupazione mappa combattimento 50x25 byte: n. combattente o 0 */
    h029_fill_bytes(0x4E1, &H005_B(0x2BD2), 0x4E2, 0);
    /* $247B: numero di combattenti nella tabella +$2B32 (+1 dopo lo schieramento) */
    for (n = 1; n <= H005_B(0x247B); ++n) {
        if (POS_SIZE(n) == 0) { /* $3159: posizioni combattenti +5: forma/taglia (0 = fuori mappa) */
            continue;
        }
        for (i = 0; i <= 3; ++i) {
            /* $3159: posizioni combattenti +5: forma/taglia (0 = fuori mappa) */
            if (shape_cell(POS_SIZE(n), i, &dx, &dy)) {
                /* $2BD2: occupazione mappa combattimento 50x25 byte: n. combattente o 0; $3156:
                 * posizioni combattenti +2: riga sulla mappa (word); $3154: posizioni combattenti,
                 * 6 byte per n (da 1): +0 colonna (word) */
                H005_B(0x2BD2 + (s32)(POS_Y(n) + dy) * 0x32 + POS_X(n) + dx) =
                    (u8)n;
            }
        }
        /* $3154: posizioni combattenti, 6 byte per n (da 1): +0 colonna (word); $3104: (word)
         * colonna nella vista per combattente n (passo 2, da 1) */
        H005_SET_W(0x3104 + (n - 1) * 2, (u16)(POS_X(n) - AREA_X0));
        /* $3156: posizioni combattenti +2: riga sulla mappa (word); $30B4: (word) riga nella vista
         * per combattente n (passo 2, da 1) */
        H005_SET_W(0x30B4 + (n - 1) * 2, (u16)(POS_Y(n) - AREA_Y0));
    }
}

/*
 * PORT H048+$0AA8: numero (1..) del combattente c nella tabella $2B32, 0
 * se non c'e'.  Con $247B = 0 l'originale continua oltre la tabella; qui
 * la ricerca si ferma alle 40 voci.
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
    /* $247B: numero di combattenti nella tabella +$2B32 (+1 dopo lo schieramento) */
    } while (!found && i != H005_B(0x247B) && i < 40);
    return (u16)(found ? i : 0);
}

/*
 * PORT H048+$0B1A: porta (x, y) nella vista: se e' gia' entro margin
 * caselle dal centro (margin = $FF: sempre) non fa niente e restituisce
 * 0; altrimenti sposta il centro (3..$2E, 3..$15) verso (x, y), ridisegna
 * la vista 7x7 e restituisce 1.
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
 * PORT H048+$0DF2: porta nella vista la casella vicina a (x, y) in
 * direzione dir (8 = la stessa) con il margine margin; se la vista si e'
 * spostata ridisegna i combattenti attivi; poi ridisegna (x, y) e la
 * casella vicina (limitata alla mappa se fuori vista).
 */
void center_view(s16 x, s16 y, u16 margin, u16 dir)
{
    u16 n;                              /* -$6(a5) */
    s16 nx;                             /* -$8(a5) */
    s16 ny;                             /* -$A(a5) */
    Character *c;                       /* -$4(a5) */

    begin_screen_update();
    nx = (s16)(x + H005_W(0x3EE2 + dir * 2)); /* $3EE2: (word) spostamento x per direzione d (passo 2) */
    ny = (s16)(y + H005_W(0x3ED0 + dir * 2)); /* $3ED0: (word) spostamento y per direzione d (passo 2) */
    if (scroll_view_to(nx, ny, (u8)margin)) {
        /* $247B: numero di combattenti nella tabella +$2B32 (+1 dopo lo schieramento) */
        for (n = 1; n <= H005_B(0x247B); ++n) {
            c = g_combatants[n - 1];
            /*
             * L'ultima voce ($247B, dopo lo schieramento di H095) e' vuota:
             * l'originale legge +$198 dalla memoria bassa e la scarta per
             * la forma 0; qui la voce NULL si salta.
             */
            /* pg+$198: attivo/in piedi (0 a terra o fuori combattimento); $3159: posizioni
             * combattenti +5: forma/taglia (0 = fuori mappa) */
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

/* PORT H048+$0F88: colonna di c sulla mappa (H005+$3154). */
u16 combatant_x(Character *c)
{
    s16 i = (s16)combatant_index(c);

    return (u16)POS_X(i); /* $3154: posizioni combattenti, 6 byte per n (da 1): +0 colonna (word) */
}

/* PORT H048+$0FBA: riga di c sulla mappa. */
u16 combatant_y(Character *c)
{
    s16 i = (s16)combatant_index(c);

    return (u16)POS_Y(i); /* $3156: posizioni combattenti +2: riga sulla mappa (word) */
}

/*
 * PORT H048+$0FEC: cambia la figura di c (fotogramma frame, set which): se
 * non e' tutto nella vista la centra; con $24C6 ridisegna il terreno se
 * cambia la direzione (frame/4), con which o con skip; poi, senza skip,
 * disegna la figura.
 */
void set_combatant_frame(Character *c, u8 frame, u8 which, u8 skip)
{
    u16 n;                              /* -$2(a5) */

    begin_screen_update();
    n = combatant_index(c);
    /* $24C6: 1 se le azioni del combattente vanno disegnate (visibile) */
    if (!combatant_visible(c, 1) && H005_B(0x24C6)) {
        center_view((s16)combatant_x(c), (s16)combatant_y(c), 3, 8);
    }
    /* turno+$B: orientamento/fotogramma del combattente (direzione 0..7) */
    if (((c->block_192->b[0x0B] >> 2) != (frame >> 2) || which || skip) &&
        H005_B(0x24C6)) { /* $24C6: 1 se le azioni del combattente vanno disegnate (visibile) */
        redraw_ground(0, 0, n);
    }
    c->block_192->b[0x0B] = frame; /* turno+$B: orientamento/fotogramma del combattente (direzione 0..7) */
    if (!skip && H005_B(0x24C6)) { /* $24C6: 1 se le azioni del combattente vanno disegnate (visibile) */
        /* $3104: (word) colonna nella vista per combattente n (passo 2, da 1); $30B4: (word) riga
         * nella vista per combattente n (passo 2, da 1) */
        draw_sprite_set((u16)VIEW_X(n), (u16)VIEW_Y(n), frame, which,
                        /* pg+$143: posto delle icone 24x24 (0..7 nel party; $0A creazione, $0C
                         * editor) */
                        c->b[0x143]);
    }
    end_screen_update();
}

/* PORT H048+$110C: forma (+$5 in $3154) del combattente c. */
u8 combatant_size(Character *c)
{
    /* $3159: posizioni combattenti +5: forma/taglia (0 = fuori mappa) */
    return POS_SIZE((s16)combatant_index(c));
}

/*
 * PORT H048+$113E: esamina le caselle di c spostate in direzione dir: in
 * *blocker l'ultimo altro combattente trovato, in *tile la casella di
 * costo (H005+$3EF4) piu' alto (0 se una e' fuori mappa), *in_cloud /
 * *in_acid se c'e' una nube ($1E) o una pozza ($1D).
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
    x0 = POS_X(n); /* $3154: posizioni combattenti, 6 byte per n (da 1): +0 colonna (word) */
    y0 = POS_Y(n); /* $3156: posizioni combattenti +2: riga sulla mappa (word) */
    for (i = 0; i <= 3; ++i) {
        /* $3159: posizioni combattenti +5: forma/taglia (0 = fuori mappa) */
        if (!shape_cell(POS_SIZE(n), i, &dx, &dy)) {
            continue;
        }
        /* $3EE2: (word) spostamento x per direzione d (passo 2) */
        x = (s16)(x0 + dx + H005_W(0x3EE2 + dir * 2));
        /* $3ED0: (word) spostamento y per direzione d (passo 2) */
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
            /* $3EF4: terreno, $41 voci da 4 byte (da 1): +0 costo ($FF invalicabile) */
            if (H005_B(0x3EF4 + (t - 1) * 4) >= best) {
                /* $3EF4: terreno, $41 voci da 4 byte (da 1): +0 costo ($FF invalicabile) */
                best = H005_B(0x3EF4 + (t - 1) * 4);
                *tile = t;
            }
            break;
        }
    }
}

/*
 * PORT H048+$12F4: c cade: suono secondo la forma e lo stato, animazione
 * della caduta ($3304) sulle sue caselle e, se non e' un mostro evocato
 * (turno +$15), un corpo in H005+$2AE2 con la casella ($1F) salvata; poi
 * c lascia la mappa.  Fuori dal combattimento solo suono e pausa.  Il
 * controllo iniziale dell'originale legge la voce -$6(a5) non
 * inizializzata (con 0, fuori tabella, H005+$2AD8) e non trova mai c:
 * qui omesso.  Oltre le 8 voci l'originale scriverebbe sui combattenti:
 * qui il corpo non viene registrato e il conteggio $247A resta 8.
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

    if (H005_B(0x3DE3) != 5) { /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
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
    switch (POS_SIZE(n)) { /* $3159: posizioni combattenti +5: forma/taglia (0 = fuori mappa) */
    case 1:
        if (c->b[0xDB] == 0) { /* pg+$DB: livello massimo fra le classi (usato anche come dadi vita) */
            /* pg+$123: PF massimi senza costituzione; base -1 slot incantesimi +$124 */
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
            /* $3159: posizioni combattenti +5: forma/taglia (0 = fuori mappa) */
            if (shape_cell(POS_SIZE(n), i, &dx, &dy) &&
                /* $3104: (word) colonna nella vista per combattente n (passo 2, da 1); $30B4:
                 * (word) riga nella vista per combattente n (passo 2, da 1) */
                in_view((s16)(VIEW_X(n) + dx), (s16)(VIEW_Y(n) + dy))) {
                /* $3304 e' il posto $18 della tabella dei set $3244. */
                /* $3104: (word) colonna nella vista per combattente n (passo 2, da 1) */
                draw_tile24_saving((u16)((VIEW_X(n) + dx) * 0x18),
                                   /* $30B4: (word) riga nella vista per combattente n (passo 2, da
                                    * 1) */
                                   (u16)((VIEW_Y(n) + dy) * 0x18), 0, 5,
                                   g_sprite_sets[0x18][f & 1], g_gfx_3d8e);
            }
        }
        dos_delay(1);
    }
    /* turno+$15: 1 = combattente oltre i membri del party, lo lascia a fine scontro */
    if (c->block_192->b[0x15] == 0) {
        if (H005_B(0x247A) < 8) { /* $247A: numero di corpi nella tabella +$2AE2 (max 8) */
            ++H005_B(0x247A); /* $247A: numero di corpi nella tabella +$2AE2 (max 8) */
            b = &g_bodies[H005_B(0x247A) - 1]; /* $247A: numero di corpi nella tabella +$2AE2 (max 8) */
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
    /* $3159: posizioni combattenti +5: forma/taglia (0 = fuori mappa) */
    H005_B(0x3154 + (combatant_index(c) - 1) * 6 + 5) = 0;
    rebuild_occupancy();
    center_view((s16)(AREA_X0 + 3), (s16)(AREA_Y0 + 3), 3, 8);
    /* turno+$4: (word) iniziativa del round (1d6+destrezza); <=0 turno finito */
    COK_PUT16(&c->block_192->b[4], 0);
    c->block_192->b[8] = 0; /* turno+$8: punti movimento rimasti nel turno */
    c->block_192->b[0] = 0; /* turno+$0: incantesimo in preparazione da lanciare all'inizio del turno */
    c->block_192->b[9] = 0; /* turno+$9: flag in guardia (Guard), attacca chi si avvicina */
}

/*
 * PORT H048+$16D4: mette c in (x, y) con la forma +$D3 & $7F; se le
 * caselle sono occupate o impraticabili (costo $FF) la forma torna 0 e
 * restituisce 0.  Con restore, se c era un corpo sulla mappa, la voce si
 * svuota e la casella riprende il contenuto salvato (finche' nessun altro
 * corpo e' su (x, y)).  Fuori dal combattimento restituisce 1.
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

    if (H005_B(0x3DE3) != 5) { /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
        return 1;
    }
    n = combatant_index(c);
    /* $3159: posizioni combattenti +5: forma/taglia (0 = fuori mappa); pg+$D3: forma/taglia sulla
     * mappa di combattimento (bit 0-2, >1 grande) */
    H005_B(0x3154 + (n - 1) * 6 + 5) = mask_byte(c->b[0xD3], 0x7F);
    /* $3154: posizioni combattenti, 6 byte per n (da 1): +0 colonna (word) */
    H005_SET_W(0x3154 + (n - 1) * 6, x);
    H005_SET_W(0x3154 + (n - 1) * 6 + 2, y); /* $3156: posizioni combattenti +2: riga sulla mappa (word) */
    probe_move(c, 8, &blocker, &tile, &in_cloud, &in_acid);
    if (blocker != 0 || tile == 0 ||
        /* $3EF4: terreno, $41 voci da 4 byte (da 1): +0 costo ($FF invalicabile) */
        H005_B(0x3EF4 + (tile - 1) * 4) == 0xFF) {
        /* $3159: posizioni combattenti +5: forma/taglia (0 = fuori mappa) */
        H005_B(0x3154 + (n - 1) * 6 + 5) = 0;
        return ok;
    }
    ok = 1;
    /* turno+$15: 1 = combattente oltre i membri del party, lo lascia a fine scontro */
    if (restore && c->block_192->b[0x15] == 0) {
        for (i = 1; i <= H005_B(0x247A); ++i) { /* $247A: numero di corpi nella tabella +$2AE2 (max 8) */
            if (g_bodies[i - 1].who == c) {
                if (g_bodies[i - 1].tile != 0x1F) {
                    tile = g_bodies[i - 1].tile;
                }
                /* H029+$0312 sui primi 9 byte della voce. */
                g_bodies[i - 1].who = NULL;
                g_bodies[i - 1].x = 0;
                g_bodies[i - 1].y = 0;
                g_bodies[i - 1].tile = 0;
            }
        }
        found = 0;
        for (i = 1; i <= H005_B(0x247A); ++i) { /* $247A: numero di corpi nella tabella +$2AE2 (max 8) */
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
 * PORT H048+$195E: mostra il cursore (forma di c, acceso se flag) sulla
 * casella di c, centrandola con il margine margin; poi lo spegne.
 */
void show_combatant_cursor(Character *c, u16 margin, u8 flag)
{
    g_combat_area[6] = flag;
    /* $3159: posizioni combattenti +5: forma/taglia (0 = fuori mappa) */
    g_combat_area[7] = POS_SIZE((s16)combatant_index(c));
    if (H005_B(0x24C6)) { /* $24C6: 1 se le azioni del combattente vanno disegnate (visibile) */
        center_view((s16)combatant_x(c), (s16)combatant_y(c), margin, 8);
    }
    g_combat_area[6] = 0;
    g_combat_area[7] = 1;
}
