/* H029: record grafici, bitplane, maschere e disegno dei tile. */
#include "h029_gfx.h"
#include "h038.h"
#include "h002_dos.h"
#include "h003_exec.h"
#include "h021_intuition.h"
#include "h022_view.h"
#include "h024_screen.h"
#include "h025_window.h"
#include "h051.h"
#include "h026_string.h"
#include "h028_files.h"
#include "h018_libs.h"
#include "h084.h"
#include "h082.h"
#include "h016_gfx.h"
#include "h037.h"
#include "h055.h"
#include "unported.h"
#include "h014.h"
#include "globals.h"
#include "h010_input.h"
#include "h049.h"

/* Dati del modulo (offset rispetto ad a4). */
struct RastPort *g_offscreen_rp;   /* -$4: RastPort sulla bitmap di $3D8E */
u8  g_h029_m5;                  /* -$5 */
u8  g_h029_m6;                  /* -$6 */
u8  g_h029_m9;                  /* -$9 */
u16 g_h029_m10;                 /* -$10 */
u8 *g_pointer_data;             /* -$14: contenuto di pointers.daa */
u32 g_pointer_size;             /* -$18: sua dimensione */
struct Task *g_h029_task;       /* -$20: task del gioco */
struct View *g_saved_view;      /* -$24: GfxBase->ActiView all'avvio */
struct View g_offscreen_view;   /* -$36: View della bitmap di $3D8E */
struct ViewPort g_offscreen_vp; /* -$5E */
struct RasInfo g_offscreen_ri;  /* -$6A */
struct Library *g_h029_intuition; /* -$E: intuition.library aperta qui */
u16 g_h029_m1a;                 /* -$1A: profondita' del disegno fuori schermo */
u16 g_h029_m8;                  /* -$8: View mostrata da H029+$1576 */
u16 g_h029_m1c;                 /* -$1C */

/* PORT H029+$0118 */
void h029_init(void)
{
    g_h029_m10 = 0xFFFF;
    g_pointer_data = NULL;
    g_offscreen_rp = NULL;
    g_h029_m1a = 0;
    g_h029_m1c = 0;
    g_h029_m5 = 0;
    g_h029_m6 = 0;
    g_h029_m9 = 0;
}

/*
 * PORT H029+$0312: scrive value in dst[0..count-1].  Il primo argomento non
 * e' letto.  Il ciclo confronta l'indice (word) con count-1 senza segno:
 * con count = 0 riempie 65536 byte, come l'originale.
 */
void h029_fill_bytes(u16 unused, u8 *dst, u16 count, u8 value)
{
    u16 last = (u16)(count - 1);
    u16 i = 0;

    (void)unused;
    for (;;) {
        dst[i] = value;
        if (i == last) {
            break;
        }
        ++i;
    }
}

/*
 * Le 12 voci da $A byte all'inizio di pointers.daa iniziano con l'offset
 * (long) dei dati del puntatore.  L'originale lo trasforma sul posto in un
 * indirizzo assoluto (offset + base); qui l'indirizzo va in questa tabella,
 * perche' sull'host un puntatore non sta in 32 bit, e il buffer resta come
 * e' stato letto.  Chi legge la voce i usa g_pointer_image[i].
 */
u8 *g_pointer_image[12];

/* PORT H029+$0180: libera pointers.daa e toglie il puntatore del mouse. */
void free_pointer_data(void)
{
    if (g_pointer_data != NULL) {
        exec_free_mem(g_pointer_data, g_pointer_size);
        g_pointer_data = NULL;
        intuition_clear_pointer(g_window);
    }
}

/* PORT H029+$0234: carica pointers.daa (memoria chip). */
static void load_pointer_data(void)
{
    cok_bptr file;
    s16 i;

    file = dos_open("pointers.daa", MODE_OLDFILE);
    if (file == 0) {
        return;
    }
    /* Seek restituisce la posizione precedente: la seconda da' la lunghezza. */
    g_pointer_size = (u32)dos_seek(file, 0, OFFSET_END);
    g_pointer_size = (u32)dos_seek(file, 0, OFFSET_BEGINNING);
    g_pointer_data = (u8 *)exec_alloc_mem(g_pointer_size, COK_MEMF_CHIP);
    if (g_pointer_data != NULL) {
        if ((u32)dos_read(file, g_pointer_data, (s32)g_pointer_size) ==
            g_pointer_size) {
            for (i = 0; i <= 0x0B; ++i) {
                g_pointer_image[i] = g_pointer_data +
                                     COK_GET32(g_pointer_data + i * 0x0A);
            }
        } else {
            free_pointer_data();
        }
    }
    dos_close(file);
}

/* PORT H029+$115C: palette iniziale di 16 colori RGB4 in H005+$52AE. */
static void set_game_palette(void)
{
    static const u16 colors[16] = {
        0x000, 0x00A, 0x0A0, 0x0AA, 0xA00, 0xA0A, 0xA50, 0xAAA,
        0x555, 0x55F, 0x5F5, 0x5FF, 0xF55, 0xF5F, 0xFF5, 0xFFF
    };
    unsigned i;

    for (i = 0; i < 16; ++i) {
        H005_SET_W(0x52AE + i * 2, colors[i]);
    }
    graphics_load_rgb4(&g_screen->ViewPort, &g_h005[0x52AE], 0x10);
}

/*
 * PORT H029+$1206: apre lo schermo 320x200 a 5 piani senza titolo e la
 * finestra a schermo intero (BACKDROP|BORDERLESS|ACTIVATE|RMBTRAP, IDCMP
 * MOUSEBUTTONS|RAWKEY), indirizza le richieste di sistema alla finestra,
 * imposta la palette e carica i puntatori del mouse.
 */
void open_game_display(void)
{
    H005_SET_W(0x0004, 0x010F);
    g_screen = open_game_screen(0x140, 0xC8, 5, NULL);
    intuition_show_title(g_screen, 0);
    g_window = open_game_window(0, 0, 0x140, 0xC8, 0x408, 0x11900, NULL,
                                g_screen, NULL);
    g_rastport = g_window->RPort;
    if ((u8)intuition_close_workbench() != 0) {
        intuition_activate_window(g_window);
    }
    g_h029_task = exec_find_task(NULL);
    ((struct Process *)g_h029_task)->pr_WindowPtr = (APTR)g_window;
    set_game_palette();
    load_pointer_data();
}

/* PORT H029+$12BC: chiude finestra e schermo e riapre il Workbench. */
void close_game_display(void)
{
    free_pointer_data();
    g_h029_task = exec_find_task(NULL);
    ((struct Process *)g_h029_task)->pr_WindowPtr = NULL;
    intuition_close_window(g_window);
    intuition_close_screen(g_screen);
    g_screen = (struct Screen *)(size_t)intuition_open_workbench();
}

/*
 * PORT H029+$0408 (Allocate_GraphicRecord): larghezza = width8 * 8 * count
 * pixel, allineata a 16; record e BitMap a 5 piani, ogni piano allocato e
 * azzerato.  Con with_mask = 1 anche una BitMap di maschera con un solo
 * raster, ripetuto nei 5 piani.  Gli errori di allocazione vanno a
 * H014+$0018 con il numero del piano e "plane alloc problem".
 */
void allocate_gfx_record(u16 rows, u16 count, u16 width8, u16 with_mask,
                         struct GfxRecord **rec)
{
    static const char plane_error[] = "plane alloc problem";
    u16 width = (u16)((u16)(width8 << 3) * count);
    u16 bytes;
    struct GfxRecord *r;
    struct BitMap *bm;
    u16 i;

    if ((width & 0x0F) > 0) {
        width = (u16)(width + (0x10 - (width & 0x0F)));
    }
    bytes = (u16)((u32)(width >> 3) * rows * 5);

    *rec = r = (struct GfxRecord *)exec_alloc_mem(sizeof(struct GfxRecord),
                                                  COK_MEMF_CLEAR);
    r->image = bm = (struct BitMap *)exec_alloc_mem(sizeof(struct BitMap),
                                                    COK_MEMF_CLEAR);
    graphics_init_bitmap(bm, 5, width, rows);
    for (i = 0; i <= 4; ++i) {
        bm->Planes[i] = graphics_alloc_raster(width, rows);
        if (bm->Planes[i] == NULL) {
            error_message(0x13, plane_error, i);
        } else {
            graphics_blt_clear(bm->Planes[i], (u32)(width >> 3) * rows, 0);
        }
    }

    if (with_mask == 1) {
        r->mask = bm = (struct BitMap *)exec_alloc_mem(sizeof(struct BitMap),
                                                       COK_MEMF_CLEAR);
        graphics_init_bitmap(bm, 5, width, rows);
        bm->Planes[0] = graphics_alloc_raster(width, rows);
        if (bm->Planes[0] == NULL) {
            error_message(0x13, plane_error, 0);
        } else {
            graphics_blt_clear(bm->Planes[0], (u32)(width >> 3) * rows, 0);
        }
        for (i = 1; i <= 4; ++i) {
            bm->Planes[i] = bm->Planes[0];
        }
    } else {
        r->mask = NULL;
    }
    r->rows = rows;
    r->count = count;
    r->plane_bytes = bytes;
    r->width8 = width8;
}

/* PORT H029+$1308: byte con segno esteso a word. */
static s16 signed_byte(u8 b)
{
    s16 v = (s16)b;

    if (b >= 0x80) {
        v = (s16)(v - 0x100);
    }
    return v;
}

/*
 * PORT H029+$1346 (Prepare_DisplayResources), solo la prima volta
 * ($3D8E nullo): record grafico 320x200 a 5 piani in $3D8E con un suo
 * RastPort, una View con un ViewPort che lo mostra (spostamenti presi
 * dalle Preferences, ColorMap da 32 colori, liste Copper costruite),
 * apertura di intuition.library e salvataggio di GfxBase->ActiView.
 */
void prepare_display_resources(void)
{
    struct Preferences prefs;
    struct Library *gfx;

    if (g_gfx_3d8e != NULL) {
        return;
    }
    allocate_gfx_record(0xC8, 0x28, 1, 0, &g_gfx_3d8e);
    g_offscreen_rp = (struct RastPort *)exec_alloc_mem(sizeof(struct RastPort),
                                                       COK_MEMF_CLEAR);
    graphics_init_rastport(g_offscreen_rp);
    g_offscreen_rp->BitMap = g_gfx_3d8e->image;

    graphics_init_view(&g_offscreen_view);
    (void)intuition_get_prefs(&prefs, 0x7C);
    g_offscreen_view.DxOffset = (WORD)(signed_byte((u8)prefs.ViewXOffset) +
                                       prefs.ViewInitX);
    g_offscreen_view.DyOffset = (WORD)(signed_byte((u8)prefs.ViewYOffset) +
                                       prefs.ViewInitY);
    g_offscreen_view.ViewPort = &g_offscreen_vp;
    graphics_init_vport(&g_offscreen_vp);
    g_offscreen_ri.BitMap = g_gfx_3d8e->image;
    g_offscreen_ri.RxOffset = 0;
    g_offscreen_ri.RyOffset = 0;
    g_offscreen_ri.Next = NULL;
    g_offscreen_vp.DWidth = 0x140;
    g_offscreen_vp.DHeight = 0xC8;
    g_offscreen_vp.RasInfo = &g_offscreen_ri;
    g_offscreen_vp.ColorMap = graphics_get_color_map(0x20);
    graphics_make_vport(&g_offscreen_view, &g_offscreen_vp);
    graphics_mrg_cop(&g_offscreen_view);

    g_h029_intuition = exec_open_library("intuition.library", 0);
    gfx = exec_open_library("graphics.library", 0);
    g_saved_view = ((struct GfxBase *)gfx)->ActiView;
    exec_close_library(gfx);
}

/* Larghezza in pixel del record (unita' * 8 * byte), allineata a 16. */
static u16 gfx_record_width(const struct GfxRecord *r)
{
    u16 width = (u16)((u16)(r->count << 3) * r->width8);

    if ((width & 0x0F) > 0) {
        width = (u16)(width + (0x10 - (width & 0x0F)));
    }
    return width;
}

/*
 * PORT H029+$067A (Free_GraphicRecord): libera raster, maschera, BitMap e
 * record; *rec diventa NULL.
 */
void free_gfx_record(struct GfxRecord **rec)
{
    struct GfxRecord *r = *rec;
    u16 width;
    u16 i;

    if (r == NULL) {
        return;
    }
    width = gfx_record_width(r);
    for (i = 0; i <= 4; ++i) {
        graphics_free_raster(r->image->Planes[i], width, r->rows);
    }
    if (r->mask != NULL) {
        graphics_free_raster(r->mask->Planes[0], width, r->rows);
        exec_free_mem(r->mask, sizeof(struct BitMap));
    }
    exec_free_mem(r->image, sizeof(struct BitMap));
    exec_free_mem(*rec, sizeof(struct GfxRecord));
    *rec = NULL;
}

/* PORT H029+$0354: value AND mask (byte); usata anche come test di bit. */
u8 mask_byte(u8 value, u16 mask)
{
    return (u8)(mask & value);
}

/* PORT H029+$0376: value XOR mask (byte). */
u8 xor_byte(u8 value, u16 mask)
{
    return (u8)(mask ^ value);
}

/* PORT H029+$039A: value OR mask (byte). */
u8 or_byte(u8 value, u16 mask)
{
    return (u8)(mask | value);
}

/*
 * PORT H029+$0766: costruisce la maschera (un solo raster ripetuto nei 5
 * piani) dell'immagine.  Con un colore trasparente: per ogni piano OR
 * ($E0) del piano dove il bit del colore e' 0, OR del complemento ($B0)
 * dove e' 1, cioe' maschera = pixel diversi dal colore; con meno di 3
 * unita' l'immagine viene poi ridotta alla maschera (AND, $80).  Senza
 * colore (0): maschera = OR di tutti i piani.
 */
void build_gfx_mask(u8 color, struct GfxRecord *r)
{
    u16 width = gfx_record_width(r);
    u16 i;
    u8 minterm;

    if (color != 0) {
        graphics_blt_clear(r->mask->Planes[0],
                           (u32)(width >> 3) * r->rows, 1);
        for (i = 0; i <= 4; ++i) {
            minterm = mask_byte(color, (u16)(1u << i)) ? 0xB0 : 0xE0;
            (void)graphics_blt_bitmap(r->image, 0, 0, r->mask, 0, 0,
                                      (u16)((u16)(r->count * r->width8) << 3),
                                      r->rows, minterm, (u8)(1u << i), NULL);
        }
        if (r->count < 3) {
            (void)graphics_blt_bitmap(r->mask, 0, 0, r->image, 0, 0,
                                      (u16)((u16)(r->count * r->width8) << 3),
                                      r->rows, 0x80, 0xFF, NULL);
        }
    } else {
        graphics_blt_clear(r->mask->Planes[0],
                           (u32)(width >> 3) * r->rows, 1);
        (void)graphics_blt_bitmap(r->image, 0, 0, r->mask, 0, 0,
                                  (u16)((u16)(r->count * r->width8) << 3),
                                  r->rows, 0xE0, 0xFF, NULL);
    }
}

/*
 * PORT H029+$091E: copia i piani 0..last_plane dal blocco caricato
 * (a partire da offset, un piano dopo l'altro) nell'immagine, poi
 * costruisce la maschera se il record ne ha una.
 */
void transfer_gfx_planes(const u8 *data, u16 offset, u16 last_plane,
                                u8 mask_color, struct GfxRecord **rec)
{
    struct GfxRecord *r = *rec;
    u16 plane_bytes;
    u16 i;

    if (r == NULL) {
        error_message(0x0B, "thegrafrec-", 0);
        return;
    }
    plane_bytes = (u16)((u16)(r->rows * gfx_record_width(r)) >> 3);
    for (i = 0; i <= last_plane; ++i) {
        exec_copy_mem(data + (u16)(plane_bytes * i + offset),
                      r->image->Planes[i], plane_bytes);
    }
    if ((*rec)->mask != NULL) {
        build_gfx_mask(mask_color, *rec);
    }
}

/*
 * PORT H029+$0A0E (Load_IndexedGraphicRecord): carica il blocco id di
 * name.daa e ne fa un record grafico in *rec (liberando il precedente).
 * Intestazione di 9 byte: righe, unita', due word, larghezza unitaria;
 * i set "8x8..." hanno 4 piani dopo l'intestazione, gli altri una palette
 * di 32 colori (copiata in H005+$522E) e 5 piani.
 */
void load_indexed_gfx_record(u16 name_len, const char *name, u16 id,
                             u16 with_mask, u8 mask_color,
                             struct GfxRecord **rec)
{
    char prefix[0x52];          /* -$5C */
    u16 last_plane;             /* -$62 */
    u16 offset;                 /* -$60 */
    u16 size;                   /* -$5E */
    u8 *data;                   /* -$66 */
    u8 header[9];               /* -$A */

    if (*rec != NULL) {
        free_gfx_record(rec);
    }
    h026_substr(0x50, prefix, name_len, name, 0, 3);
    if (h026_compare_nocase(0x50, prefix, 3, "8x8") == 1) {
        last_plane = 3;
        offset = 9;
    } else {
        last_plane = 4;
        offset = 0x49;
    }
    dax_load_block(name_len, name, 4, ".daa", id, &size, &data);
    if (size == 0) {
        error_message(0x14, "loadgrafrec:tbufsize", 0);
        error_message(name_len, name, id);
        return;
    }
    exec_copy_mem(data, header, 9);
    if (last_plane == 4) {
        exec_copy_mem(data + 9, &g_h005[0x522E], 0x40);
    }
    allocate_gfx_record(COK_GET16(header), COK_GET16(header + 2), header[8],
                        with_mask, rec);
    /* Come l'originale: entrambe le word vanno nel campo +$04. */
    (*rec)->w4 = COK_GET16(header + 4);
    (*rec)->w4 = COK_GET16(header + 6);
    transfer_gfx_planes(data, offset, last_plane, mask_color, rec);
    exec_free_mem(data, size);
}

/*
 * PORT H029+$0EFE: ricolora il record: ogni colore from[i] diverso da
 * to[i] diventa to[i].  frame < 0: tutto il record; altrimenti la colonna
 * di unita' frame (larghezza count*8 + 1, come nell'originale).  Lavora su
 * una copia temporanea con maschera: per ogni colore, maschera dei pixel
 * di quel colore (H029+$0766) e inversione ($90) dei piani in cui from e
 * to differiscono.  Le due tabelle sono passate per valore (16 byte sullo
 * stack ciascuna); qui si copiano.
 */
void remap_gfx_colors(const u8 from[16], const u8 to[16], s16 frame,
                      struct GfxRecord *rec)
{
    u8 from_copy[16];           /* $22(a5) */
    u8 to_copy[16];             /* $12(a5) */
    struct GfxRecord *temp = NULL;      /* -$14 */
    u16 x0;                     /* -$A */
    u16 x1;                     /* -$C */
    u16 width;                  /* -$E */
    u16 i;                      /* -$10 */
    s16 p;                      /* -$8 */
    u8 bit;                     /* -$15 */

    if (rec == NULL) {
        return;
    }
    memcpy(from_copy, from, 16);
    memcpy(to_copy, to, 16);
    if (frame < 0) {
        x0 = 0;
        x1 = (u16)((u16)(rec->count << 3) * rec->width8 - 1);
    } else {
        x0 = (u16)((u16)(rec->count << 3) * (u16)frame);
        x1 = (u16)((rec->count << 3) + x0);
    }
    width = (u16)(x1 - x0 + 1);
    allocate_gfx_record(rec->rows, (u16)(width >> 3), 1, 1, &temp);
    (void)graphics_blt_bitmap(rec->image, x0, 0, temp->image, 0, 0, width,
                              rec->rows, 0xC0, 0xFF, NULL);
    for (i = 0; i <= 0x0F; ++i) {
        if (from_copy[i] == to_copy[i]) {
            continue;
        }
        build_gfx_mask(from_copy[i], temp);
        for (p = 0; p <= 4; ++p) {
            bit = (u8)(1u << p);
            if ((from_copy[i] & bit) != (to_copy[i] & bit)) {
                (void)graphics_blt_bitmap(temp->mask, 0, 0, rec->image, x0,
                                          0, width, rec->rows, 0x90, bit,
                                          NULL);
            }
        }
    }
    free_gfx_record(&temp);
}

/*
 * PORT H029+$01B6: imposta il puntatore del mouse shape (0..11) da
 * pointers.daa, se diverso da quello attuale (H029 -$10).  Voce di $A
 * byte: dati (g_pointer_image), +4 e +6 punto caldo, +8 altezza;
 * larghezza 16.
 */
void set_pointer_shape(s16 shape)
{
    const u8 *entry;

    if (shape < 0 || shape > 0x0B || shape == (s16)g_h029_m10) {
        return;
    }
    g_h029_m10 = (u16)shape;
    if (g_pointer_data == NULL) {
        return;
    }
    entry = g_pointer_data + shape * 0x0A;
    intuition_set_pointer(g_window, g_pointer_image[shape],
                          COK_GET16(entry + 8), 0x10,
                          (u16)-(s16)COK_GET16(entry + 4),
                          (u16)-(s16)COK_GET16(entry + 6));
}

/* PORT H029+$03E2: *value += delta (byte). */
void add_to_byte(u8 *value, u16 delta)
{
    *value = (u8)(*value + delta);
}

/*
 * PORT H029+$148E: libera la View fuori schermo di H029+$1346 (ColorMap,
 * liste Copper, RastPort), chiude intuition.library aperta li' e libera il
 * record di $3D8E.
 */
void release_display_resources(void)
{
    struct ColorMap *cm;
    struct Library *lib;

    if (g_offscreen_rp != NULL) {
        cm = g_offscreen_vp.ColorMap;
        graphics_free_color_map(cm);
        graphics_free_vport_cop_lists(&g_offscreen_vp);
        graphics_free_cpr_list(g_offscreen_view.LOFCprList);
        exec_free_mem(g_offscreen_rp, sizeof(struct RastPort));
        g_offscreen_rp = NULL;
        lib = g_h029_intuition;
        exec_close_library(lib);
    }
    free_gfx_record(&g_gfx_3d8e);
}

/*
 * PORT H029+$10B8: riempie con pen il rettangolo di celle 8x8 da (col, row)
 * largo width e alto height nella RastPort della finestra.  Il record non
 * e' usato.
 */
void fill_cells(u16 col, u16 row, u16 width, u16 height, u8 pen,
                struct GfxRecord *unused)
{
    (void)unused;
    graphics_set_apen(g_rastport, pen);
    graphics_rect_fill(g_rastport, (u16)(col << 3), (u16)(row << 3),
                       (u16)(((col + width) << 3) - 1),
                       (u16)(((row + height) << 3) - 1));
}

/*
 * PORT H029+$14F6: aspetta (H010+$0974) finche' lo schermo del gioco e'
 * in primo piano (IntuitionBase->FirstScreen).
 */
void wait_screen_in_front(void)
{
    while (((struct IntuitionBase *)g_h029_intuition)->FirstScreen != g_screen) {
        wait_for_key();
    }
}

/*
 * PORT H029+$1520: copia lo schermo (320x200) nella bitmap fuori schermo
 * di $3D8E; il risultato di BltBitMap va in H005+$3358.
 */
void copy_screen_to_offscreen(void)
{
    s32 r;

    r = graphics_blt_bitmap(g_screen->RastPort.BitMap, 0, 0,
                            g_gfx_3d8e->image, 0, 0, 0x140, 0xC8, 0xC0, 0xFF,
                            NULL);
    H005_SET_W(0x3358, (u16)r);
    g_h029_m8 = 0;
    g_h029_m9 = 0;
}

/*
 * PORT H029+$1576: scambia la View mostrata: con -$8 = 0 la View fuori
 * schermo (e si disegna sullo schermo), con 1 quella di Intuition (e si
 * disegna fuori schermo); poi aspetta il quadro.
 */
void swap_display_view(void)
{
    g_h029_m8 = (u16)(1 - g_h029_m8);
    g_h029_m6 = 0;
    if (g_h029_m8 == 0) {
        wait_screen_in_front();
        graphics_load_view(&g_offscreen_view);
        g_h029_m5 = 0;
    } else {
        graphics_load_view(g_saved_view);
        g_h029_m5 = 1;
    }
    graphics_wait_tof();
}

/*
 * PORT H029+$16A2: inizio di un aggiornamento: alla prima chiamata copia
 * lo schermo fuori schermo e mostra quella copia (la View di $3D8E) mentre
 * si disegna sullo schermo; le chiamate si annidano (-$1A).
 */
void begin_screen_update(void)
{
    if (g_h029_m1a == 0) {
        copy_screen_to_offscreen();
        wait_screen_in_front();
        graphics_load_view(&g_offscreen_view);
        graphics_wait_tof();
    }
    ++g_h029_m1a;
    g_h029_m5 = 0;
    g_h029_m6 = 0;
}

/*
 * PORT H029+$16DE: fine dell'aggiornamento: all'ultima chiamata torna la
 * View di Intuition e il disegno passa al blitter in coda (-$6 = 1).
 */
void end_screen_update(void)
{
    --g_h029_m1a;
    if ((s16)g_h029_m1a <= 0) {
        g_h029_m1a = 0;
        graphics_load_view(g_saved_view);
        graphics_wait_tof();
        g_h029_m6 = 1;
    }
    g_h029_m5 = 0;
}

/*
 * PORT H029+$0B94 (Draw_GraphicTile24): disegna il fotogramma frame (24x24,
 * colonna frame*24) di src in (x, y), spostati di 8 pixel in combattimento.
 * Con masked = 1 e una maschera usa il cookie-cut (minterm $CA col blitter
 * in coda, $E0 con BltMaskBitMapRastPort), altrimenti copia.  La RastPort
 * e' quella fuori schermo se attiva (-$5), altrimenti quella dello schermo
 * (-$9 = 1).  unused ($3D8E) non e' letto.
 */
void draw_tile24(u16 x, u16 y, u8 frame, u8 masked, struct GfxRecord *src,
                 struct GfxRecord *unused)
{
    u16 off;                            /* -$2(a5) */
    u16 src_x;                          /* -$6(a5) */
    struct RastPort *rp;                /* -$E(a5) */

    (void)unused;
    src_x = (u16)(frame * 0x18);
    off = H005_B(0x3DE3) ? 8 : 0;
    if (g_h029_m5) {
        rp = g_offscreen_rp;
    } else {
        rp = &g_screen->RastPort;
        g_h029_m9 = 1;
    }
    if (g_h029_m6) {
        if (masked == 1 && src->mask != NULL) {
            (void)queue_bitplane_blit(src->image, src_x, 0, rp,
                                      (u16)(x + off), (u16)(y + off), 0x18,
                                      0x18, 0xCA, src->mask->Planes[0]);
        } else {
            (void)queue_bitplane_blit(src->image, src_x, 0, rp->BitMap,
                                      (u16)(x + off), (u16)(y + off), 0x18,
                                      0x18, 0xCA, NULL);
        }
    } else if (masked == 1 && src->mask != NULL) {
        graphics_blt_mask_bitmap_rastport(src->image, src_x, 0, rp,
                                          (u16)(x + off), (u16)(y + off),
                                          0x18, 0x18, 0xE0,
                                          src->mask->Planes[0]);
    } else {
        (void)graphics_blt_bitmap(src->image, src_x, 0, rp->BitMap,
                                  (u16)(x + off), (u16)(y + off), 0x18, 0x18,
                                  0xC0, 0xFF, NULL);
    }
}

/*
 * PORT H029+$0D58: come H029+$0B94; con mode = 5 prima salva in $3D8A la
 * casella 24x24 di destinazione (dallo schermo o da $3D8E) e disegna con
 * la maschera.
 */
void draw_tile24_saving(u16 x, u16 y, u8 frame, u8 mode,
                        struct GfxRecord *src, struct GfxRecord *unused)
{
    struct BitMap *bm;                  /* -$8(a5) */
    u16 off;                            /* -$A(a5) */

    if (mode == 5) {
        if (g_h029_m5) {
            bm = g_gfx_3d8e->image;
        } else {
            bm = &g_screen->BitMap;
        }
        off = 8;
        (void)graphics_blt_bitmap(bm, (u16)(x + off), (u16)(y + off),
                                  g_gfx_3d8a->image, 0, 0, 0x18, 0x18, 0xC0,
                                  0xFF, NULL);
        draw_tile24(x, y, frame, 1, src, unused);
    } else {
        draw_tile24(x, y, frame, 0, src, unused);
    }
}

/*
 * PORT H029+$1718: copia nella View fuori schermo i 32 colori dello
 * schermo di Intuition, letti dalla sua lista Copper (View di avvio, -$24):
 * dalla MOVE COLOR00 = 0 si prendono i valori di 32 MOVE consecutive.
 */
void copy_intuition_colors(void)
{
    UWORD *p;                           /* -$4(a5) */
    UWORD *copper;                      /* -$8(a5) */
    u8 colors[0x40];                    /* -$48(a5): word big-endian */
    s16 i;                              /* -$4A(a5) */

    p = g_saved_view->LOFCprList->start;
    while (!(p[0] == 0x0180 && p[1] == 0x0000)) {
        p += 2;
    }
    copper = p;
    for (i = 0; i <= 0x1F; ++i) {
        COK_PUT16(&colors[i * 2], copper[i * 2 + 1]);
    }
    graphics_load_rgb4(&g_offscreen_vp, colors, 0x20);
}

/*
 * PORT H029+$0E26: copia nel record (BitMap +$10) il riquadro dello
 * schermo alla cella (x, y) da 8 pixel, largo count*8 e alto rows.
 */
void save_screen_cell(u16 x, u16 y, struct GfxRecord *rec)
{
    if (rec == NULL) {
        return;
    }
    (void)graphics_blt_bitmap(&g_screen->BitMap, (u16)(x * 8), (u16)(y * 8),
                              rec->image, 0, 0, (u16)(rec->count * 8),
                              rec->rows, 0xC0, 0xFF, NULL);
}

/* PORT H029+$0E92: rimette sullo schermo il riquadro salvato da $0E26. */
void restore_screen_cell(u16 x, u16 y, struct GfxRecord *rec)
{
    if (rec == NULL) {
        return;
    }
    (void)graphics_blt_bitmap(rec->image, 0, 0, &g_screen->BitMap,
                              (u16)(x * 8), (u16)(y * 8),
                              (u16)(rec->count * 8), rec->rows, 0xC0, 0xFF,
                              NULL);
}
