/* Build host: graphics.library emulata (solo quanto usa il port). */
#include <stdlib.h>
#include <string.h>
#include "ndk.h"

/*
 * View di Intuition (GfxBase->ActiView all'avvio): niente ViewPort (il
 * display mostra lo schermo) e una lista Copper con le MOVE COLOR00..31
 * dello schermo in primo piano, che il gioco legge (H029+$1718).
 */
static UWORD s_intui_copper[32 * 2 + 2];
static struct cprlist s_intui_cpr = { NULL, s_intui_copper, 32 + 1 };
static struct View s_intui_view = { NULL, &s_intui_cpr, 0, 0, 0 };

void host_screen_colors_changed(struct ViewPort *vp)
{
    struct Screen *s = host_first_screen();
    int i;

    if (s == NULL || vp != &s->ViewPort || vp->ColorMap == NULL) {
        return;
    }
    for (i = 0; i < 32; ++i) {
        s_intui_copper[i * 2] = (UWORD)(0x0180 + i * 2);
        s_intui_copper[i * 2 + 1] =
            i < vp->ColorMap->Count ? vp->ColorMap->ColorTable[i] : 0;
    }
    s_intui_copper[64] = 0xFFFF;            /* WAIT finale */
    s_intui_copper[65] = 0xFFFE;
}

/*
 * I colori arrivano dai dati del gioco (H005), quindi sono word
 * big-endian: si leggono a byte.
 */
void LoadRGB4(struct ViewPort *vp, const UWORD *colors, LONG count)
{
    const UBYTE *p = (const UBYTE *)colors;
    LONG i;

    if (vp->ColorMap == NULL) {
        return;
    }
    for (i = 0; i < count && i < vp->ColorMap->Count; ++i) {
        vp->ColorMap->ColorTable[i] =
            (UWORD)((p[i * 2] << 8 | p[i * 2 + 1]) & 0x0FFF);
    }
    host_screen_colors_changed(vp);
    host_display_changed();
}

void InitBitMap(struct BitMap *bm, LONG depth, LONG width, LONG height)
{
    bm->BytesPerRow = (UWORD)(((width + 15) >> 3) & 0xFFFE);
    bm->Rows = (UWORD)height;
    bm->Flags = 0;
    bm->Depth = (UBYTE)depth;
    bm->pad = 0;
}

/*
 * Memoria chip: sull'host memoria normale, non azzerata come sull'Amiga.
 * Due word in piu' in coda: il blitter, con una sorgente non allineata alla
 * word, legge una word oltre la fine della riga (sull'ultima riga, oltre
 * il piano); sull'Amiga e' una lettura innocua, qui deve restare nel blocco.
 */
PLANEPTR AllocRaster(ULONG width, ULONG height)
{
    PLANEPTR p = (PLANEPTR)malloc(RASSIZE(width, height) + 4);

    if (p != NULL) {
        memset((UBYTE *)p + RASSIZE(width, height), 0, 4);
    }
    return p;
}

void FreeRaster(PLANEPTR p, ULONG width, ULONG height)
{
    (void)width;
    (void)height;
    free(p);
}

/*
 * flags bit 1 = 0: count e' un numero di byte; bit 1 = 1: count e'
 * righe << 16 | byte per riga.  Il bit 0 (attesa del blitter) non conta.
 */
void BltClear(void *memory, ULONG count, ULONG flags)
{
    if (flags & 2) {
        count = (count >> 16) * (count & 0xFFFF);
    }
    memset(memory, 0, count);
    host_display_changed();
}

static struct GfxBase s_gfx = { { "graphics.library", 34 }, &s_intui_view };

struct Library *host_graphics_base(void)
{
    return &s_gfx.LibNode;
}

void InitView(struct View *view)
{
    memset(view, 0, sizeof(*view));
}

void InitVPort(struct ViewPort *vp)
{
    memset(vp, 0, sizeof(*vp));
}

struct ColorMap *GetColorMap(LONG entries)
{
    struct ColorMap *cm = (struct ColorMap *)calloc(1, sizeof(*cm));

    if (cm == NULL) {
        return NULL;
    }
    cm->Count = (UWORD)entries;
    cm->ColorTable = (UWORD *)calloc((size_t)entries, sizeof(UWORD));
    if (cm->ColorTable == NULL) {
        free(cm);
        return NULL;
    }
    return cm;
}

void FreeColorMap(struct ColorMap *cm)
{
    if (cm != NULL) {
        free(cm->ColorTable);
        free(cm);
    }
}

/* Le liste Copper non esistono sull'host: MakeVPort e MrgCop non fanno nulla. */
void MakeVPort(struct View *view, struct ViewPort *vp)
{
    (void)view;
    (void)vp;
}

void MrgCop(struct View *view)
{
    (void)view;
}

void LoadView(struct View *view)
{
    s_gfx.ActiView = view;
    host_display_view(view);
}

void InitRastPort(struct RastPort *rp)
{
    memset(rp, 0, sizeof(*rp));
    rp->FgPen = -1;             /* come InitRastPort di AmigaOS: FgPen e */
    rp->AOlPen = -1;            /* AOlPen a -1, DrawMode JAM2 */
    rp->DrawMode = 1;
}

void SetAPen(struct RastPort *rp, ULONG pen)
{
    rp->FgPen = (BYTE)pen;
}

void SetBPen(struct RastPort *rp, ULONG pen)
{
    rp->BgPen = (BYTE)pen;
}

/*
 * Riempie il rettangolo (estremi compresi) con FgPen, tagliato ai bordi
 * della bitmap; in COMPLEMENT inverte i bit dei piani.  Con AREAOUTLINE
 * (SetOPen) il bordo del rettangolo e' poi ridisegnato con AOlPen, come
 * fa graphics.library: il segno del party sulla mappa all'aperto
 * (H069+$0012, APen $E, OPen 0) e' un quadrato col bordo nero.
 */
static void outline_pixel(struct BitMap *bm, LONG x, LONG y, UBYTE pen,
                          UBYTE mode)
{
    int i;

    for (i = 0; i < bm->Depth; ++i) {
        UBYTE *plane = bm->Planes[i];
        UBYTE *p;
        UBYTE mask;

        if (plane == NULL) {
            continue;
        }
        p = plane + (size_t)y * bm->BytesPerRow + (x >> 3);
        mask = (UBYTE)(0x80 >> (x & 7));
        if (mode & COMPLEMENT) {
            *p ^= mask;
        } else if ((pen >> i) & 1) {
            *p |= mask;
        } else {
            *p &= (UBYTE)~mask;
        }
    }
}

void RectFill(struct RastPort *rp, LONG xmin, LONG ymin, LONG xmax, LONG ymax)
{
    struct BitMap *bm = rp->BitMap;
    LONG x;
    LONG y;
    int i;
    LONG oxmin = xmin;
    LONG oymin = ymin;
    LONG oxmax = xmax;
    LONG oymax = ymax;

    if (bm == NULL) {
        return;
    }
    if (xmin < 0) {
        xmin = 0;
    }
    if (ymin < 0) {
        ymin = 0;
    }
    if (xmax >= (LONG)bm->BytesPerRow * 8) {
        xmax = (LONG)bm->BytesPerRow * 8 - 1;
    }
    if (ymax >= (LONG)bm->Rows) {
        ymax = (LONG)bm->Rows - 1;
    }
    for (i = 0; i < bm->Depth; ++i) {
        UBYTE *plane = bm->Planes[i];
        int set = ((UBYTE)rp->FgPen >> i) & 1;

        if (plane == NULL) {
            continue;
        }
        for (y = ymin; y <= ymax; ++y) {
            for (x = xmin; x <= xmax; ++x) {
                UBYTE *p = plane + (size_t)y * bm->BytesPerRow + (x >> 3);
                UBYTE mask = (UBYTE)(0x80 >> (x & 7));

                if (rp->DrawMode & COMPLEMENT) {
                    *p ^= mask;
                } else if (set) {
                    *p |= mask;
                } else {
                    *p &= (UBYTE)~mask;
                }
            }
        }
    }
    if ((rp->Flags & AREAOUTLINE) && xmin <= xmax && ymin <= ymax) {
        UBYTE pen = (UBYTE)rp->AOlPen;

        for (x = xmin; x <= xmax; ++x) {
            if (oymin == ymin) {
                outline_pixel(bm, x, ymin, pen, rp->DrawMode);
            }
            if (oymax == ymax && ymax != ymin) {
                outline_pixel(bm, x, ymax, pen, rp->DrawMode);
            }
        }
        for (y = ymin + 1; y < ymax; ++y) {
            if (oxmin == xmin) {
                outline_pixel(bm, xmin, y, pen, rp->DrawMode);
            }
            if (oxmax == xmax && xmax != xmin) {
                outline_pixel(bm, xmax, y, pen, rp->DrawMode);
            }
        }
    }
    host_display_changed();
}

static int get_pixel_bit(const UBYTE *plane, UWORD bpr, LONG x, LONG y)
{
    return (plane[(size_t)y * bpr + (x >> 3)] >> (7 - (x & 7))) & 1;
}

static void put_pixel_bit(UBYTE *plane, UWORD bpr, LONG x, LONG y, int v)
{
    UBYTE *p = plane + (size_t)y * bpr + (x >> 3);
    UBYTE m = (UBYTE)(0x80 >> (x & 7));

    if (v) {
        *p |= m;
    } else {
        *p &= (UBYTE)~m;
    }
}

/*
 * Copia un rettangolo piano per piano (piani con il bit di mask) con la
 * funzione logica minterm su B = sorgente e C = destinazione (A sempre 1,
 * come in BltBitMap: contano i bit 4..7 del minterm).  I piani sono
 * elaborati in ordine: se la destinazione ripete lo stesso raster in piu'
 * piani, ogni piano lavora sul risultato del precedente, come sull'Amiga.
 * La sorgente di ogni riga e' letta prima di scrivere, per le
 * sovrapposizioni.  Restituisce il numero di piani elaborati.
 */
LONG BltBitMap(struct BitMap *src, LONG src_x, LONG src_y,
               struct BitMap *dst, LONG dst_x, LONG dst_y, LONG width,
               LONG height, ULONG minterm, ULONG mask, PLANEPTR temp)
{
    int depth = src->Depth < dst->Depth ? src->Depth : dst->Depth;
    UBYTE row[4096];
    LONG planes = 0;
    LONG x;
    LONG y;
    int p;

    (void)temp;
    if (width <= 0 || height <= 0 || width > (LONG)sizeof(row)) {
        return 0;
    }
    for (p = 0; p < depth; ++p) {
        if (!(mask & (1u << p)) || src->Planes[p] == NULL ||
            dst->Planes[p] == NULL) {
            continue;
        }
        ++planes;
        for (y = 0; y < height; ++y) {
            for (x = 0; x < width; ++x) {
                row[x] = (UBYTE)get_pixel_bit(src->Planes[p], src->BytesPerRow,
                                              src_x + x, src_y + y);
            }
            for (x = 0; x < width; ++x) {
                int b = row[x];
                int c = get_pixel_bit(dst->Planes[p], dst->BytesPerRow,
                                      dst_x + x, dst_y + y);
                int d = (int)(minterm >> (4 + b * 2 + c)) & 1;

                put_pixel_bit(dst->Planes[p], dst->BytesPerRow, dst_x + x,
                              dst_y + y, d);
            }
        }
    }
    host_display_changed();
    return planes;
}

/*
 * Copia attraverso la maschera: dove il bit di mask (un piano largo come
 * src) e' 1 il pixel di src, altrimenti la destinazione resta.  E' l'effetto
 * dei minterm usati dal gioco ($E0, ABC|ABNC|ANBC, e $CA): la ROM ottiene
 * lo stesso risultato con tre BltBitMap (XOR, maschera, XOR).  Tagliato ai
 * bordi della bitmap della RastPort.
 */
void BltMaskBitMapRastPort(struct BitMap *src, LONG src_x, LONG src_y,
                           struct RastPort *dst, LONG dst_x, LONG dst_y,
                           LONG width, LONG height, ULONG minterm,
                           PLANEPTR mask)
{
    struct BitMap *bm = dst->BitMap;
    LONG x;
    LONG y;
    int p;

    (void)minterm;
    if (bm == NULL || mask == NULL || width <= 0 || height <= 0) {
        return;
    }
    for (y = 0; y < height; ++y) {
        LONG ty = dst_y + y;

        if (ty < 0 || ty >= (LONG)bm->Rows) {
            continue;
        }
        for (x = 0; x < width; ++x) {
            LONG tx = dst_x + x;

            if (tx < 0 || tx >= (LONG)bm->BytesPerRow * 8 ||
                !get_pixel_bit(mask, src->BytesPerRow, src_x + x,
                               src_y + y)) {
                continue;
            }
            for (p = 0; p < bm->Depth; ++p) {
                int v = 0;

                if (bm->Planes[p] == NULL) {
                    continue;
                }
                if (p < src->Depth && src->Planes[p] != NULL) {
                    v = get_pixel_bit(src->Planes[p], src->BytesPerRow,
                                      src_x + x, src_y + y);
                }
                put_pixel_bit(bm->Planes[p], bm->BytesPerRow, tx, ty, v);
            }
        }
    }
    host_display_changed();
}

/* Senza liste Copper non c'e' nulla da liberare. */
void FreeVPortCopLists(struct ViewPort *vp)
{
    (void)vp;
}

void FreeCprList(struct cprlist *list)
{
    (void)list;
}
