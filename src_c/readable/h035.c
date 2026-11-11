/* H035: caricamento set 24x24 e risorse COMSPR. */
#include "h035.h"
#include "h026_string.h"
#include "h029_gfx.h"
#include "h045.h"
#include "globals.h"
#include "gfx_record.h"
#include "h016_gfx.h"
#include "unported.h"
#include "h049.h"
#include "h010_input.h"

/* PORT H035+$0032: link/unlk, nessun effetto. */
void h035_init(void)
{
}

/*
 * PORT H035+$0246: carica la coppia di set 24x24 del posto slot: record
 * id e id+$80.  I contenitori "COMSPR" e "ICON" (nome intero, senza
 * distinzione di maiuscole) hanno la maschera (colore trasparente 8); gli
 * altri hanno il gruppo di risorse in coda al nome e vengono ricolorati
 * con le tabelle H005+$3DA2 (da) e H005+$3D92 (a).  Il prefisso di 5
 * caratteri e' calcolato ma non usato, come nell'originale.
 */
void load_sprite_set(u16 name_len, const char *name, u16 id, u16 slot)
{
    char full[0x52];            /* -$62 */
    char prefix[6];             /* -$10 */
    char group[2];              /* -$6 */

    h026_copy(0x50, full, name_len, name);
    h026_substr(6, prefix, 0x50, full, 0, 5);
    if (h026_compare_nocase(0x50, full, 6, "COMSPR") == 1 ||
        h026_compare_nocase(0x50, full, 4, "ICON") == 1) {
        load_indexed_gfx_record(0x50, full, id, 1, 8,
                                &g_sprite_sets[slot][0]);
        load_indexed_gfx_record(0x50, full, (u16)(id + 0x80), 1, 8,
                                &g_sprite_sets[slot][1]);
        return;
    }
    /* $246E: disco dei dati / gruppo di risorse corrente (G_RESOURCE_GROUP) */
    format_number(1, group, (s32)G_RESOURCE_GROUP, 0, 0x0A, 1, '0');
    h026_append(0x50, full, 1, group);
    load_indexed_gfx_record(0x50, full, id, 1, 0, &g_sprite_sets[slot][0]);
    /* $3DA2: ricolorazione dei set grafici: colori di partenza (16 byte); $3D92: ricolorazione dei
     * set grafici: colori di arrivo (16 byte) */
    remap_gfx_colors(&g_h005[0x3DA2], &g_h005[0x3D92], 0,
                     g_sprite_sets[slot][0]);
    load_indexed_gfx_record(0x50, full, (u16)(id + 0x80), 1, 0,
                            &g_sprite_sets[slot][1]);
    /* $3DA2: ricolorazione dei set grafici: colori di partenza (16 byte); $3D92: ricolorazione dei
     * set grafici: colori di arrivo (16 byte) */
    remap_gfx_colors(&g_h005[0x3DA2], &g_h005[0x3D92], 0,
                     g_sprite_sets[slot][1]);
}

/*
 * PORT H035+$0040 (Load24x24Set): carica il record id del contenitore name
 * (con maschera; colore trasparente 8 se first = $22) e ne copia count
 * tile 24x24 nel set $332C dalla tile first; poi lo libera.  Con first
 * oltre $27: "Start range error in Load24x24Set" e uscita (H010+$0360,
 * H010+$0332).
 */
void load_24x24_set(u16 name_len, const char *name, u8 id, u8 first,
                    u8 count)
{
    char copy[0x52];                    /* nome per valore */
    struct GfxRecord *rec = NULL;       /* -$4(a5) */
    u16 dst_x;                          /* -$C(a5) */
    u16 color;                          /* -$10(a5) */

    h026_copy(0x50, copy, name_len, name);
    if (first > 0x27) {
        console_writeln(0x21, "Start range error in Load24x24Set");
        quit_game();
    }
    color = (first == 0x22) ? 8 : 0;
    load_indexed_gfx_record(name_len, copy, id, 1, (u8)color, &rec);
    dst_x = (u16)(first * 0x18);
    if (g_gfx_332c != NULL) {
        (void)graphics_blt_bitmap(rec->image, 0, 0, g_gfx_332c->image, dst_x,
                                  0, (u16)(count * 0x18), 0x18, 0xC0, 0xFF,
                                  NULL);
        (void)graphics_blt_bitmap(rec->mask, 0, 0, g_gfx_332c->mask, dst_x, 0,
                                  (u16)(count * 0x18), 0x18, 0xC0, 0xFF,
                                  NULL);
    }
    free_gfx_record(&rec);
}

/*
 * PORT H035+$019A: disegna il fotogramma frame del set di tile $332C nella
 * cella 24x24 (col, row), con la maschera se masked = 1 (H029+$0B94).
 */
void draw_map_tile(s16 col, s16 row, u8 frame, u8 masked)
{
    draw_tile24((u16)(col * 0x18), (u16)(row * 0x18), frame, masked,
                g_gfx_332c, g_gfx_3d8e);
}

/* PORT H035+$01DC: libera i due record del posto slot (se presenti). */
void free_sprite_set(u8 slot)
{
    u16 i;

    for (i = 0; i <= 1; ++i) {
        if (g_sprite_sets[slot][i] != NULL) {
            free_gfx_record(&g_sprite_sets[slot][i]);
        }
    }
}

/*
 * PORT H035+$0460: disegna il set which (0/1) del posto slot alla cella
 * 24x24 (col, row) attraverso la maschera.  In combattimento ($3DE3 != 0)
 * l'origine e' spostata di 8 pixel e il disegno e' tagliato a $A8 pixel;
 * con scale > 3 l'immagine passa da un record temporaneo specchiato
 * (H049+$09D6).  La
 * RastPort e' quella fuori schermo di H029 se attiva (-$5), altrimenti
 * quella dello schermo (e H029 -$9 = 1); con H029 -$6 il disegno usa il
 * blitter (H049+$04AE) invece di BltMaskBitMapRastPort.
 */
void draw_sprite_set(u16 col, u16 row, u16 scale, u16 which, u16 slot)
{
    struct GfxRecord *rec = g_sprite_sets[slot][which];
    struct GfxRecord *temp = NULL;      /* -$14(a5) */
    struct RastPort *rp;                /* -$1c(a5) */
    struct BitMap *image;               /* -$18(a5) */
    u8 *mask;                           /* -$20(a5) */
    s16 x;
    s16 y;
    s16 width;                          /* -$4(a5) */
    s16 height;                         /* -$6(a5) */
    s16 src_x = 0;                      /* -$8(a5) */
    s16 src_y = 0;                      /* -$a(a5) */
    s16 offset;                         /* -$2(a5) */
    s16 over;                           /* -$c(a5) */

    if (rec == NULL) {
        return;
    }
    x = (s16)(col * 0x18);
    y = (s16)(row * 0x18);
    width = (s16)(rec->count << 3);
    height = (s16)rec->rows;
    if (H005_B(0x3DE3) == 0) { /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
        offset = 0;
    } else {
        offset = 8;
        if (x < 0) {
            width = (s16)(width + x);
            src_x = (s16)(src_x - x);
        }
        over = (s16)(x + width - 0xA8);
        if (over > 0) {
            width = (s16)(width - over);
        }
        if (width <= 0) {
            return;
        }
        if (y < 0) {
            height = (s16)(height + y);
            src_y = (s16)(src_y - y);
        }
        over = (s16)(y + height - 0xA8);
        if (over > 0) {
            height = (s16)(height - over);
        }
        if (height <= 0) {
            return;
        }
    }
    if (g_h029_m5) {
        rp = g_offscreen_rp;
    } else {
        rp = &g_screen->RastPort;
        g_h029_m9 = 1;
    }
    if (scale > 3) {
        allocate_gfx_record(rec->rows, rec->count, 1, 1, &temp);
        mirror_gfx_record(rec, temp);
        image = temp->image;
        mask = temp->mask->Planes[0];
    } else {
        image = rec->image;
        mask = rec->mask->Planes[0];
    }
    if (g_h029_m6) {
        (void)queue_bitplane_blit(image, (u16)src_x, (u16)src_y, rp,
                                  (u16)(x + offset + src_x),
                                  (u16)(y + offset + src_y), (u16)width,
                                  (u16)height, 0xCA, mask);
    } else {
        graphics_blt_mask_bitmap_rastport(image, (u16)src_x, (u16)src_y, rp,
                                          (u16)(x + offset + src_x),
                                          (u16)(y + offset + src_y),
                                          (u16)width, (u16)height, 0xE0,
                                          mask);
    }
    if (scale > 3) {
        free_gfx_record(&temp);
    }
}
