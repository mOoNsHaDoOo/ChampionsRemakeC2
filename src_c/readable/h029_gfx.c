/* H029: graphic records, bitplanes, masks and tile drawing. */
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

/* Module data (offsets from a4). */
struct RastPort *g_offscreen_rp;   /* -$4: RastPort on the bitmap of $3D8E */
u8  g_h029_m5;                  /* -$5 */
u8  g_h029_m6;                  /* -$6 */
u8  g_h029_m9;                  /* -$9 */
u16 g_h029_m10;                 /* -$10 */
u8 *g_pointer_data;             /* -$14: contents of pointers.daa */
u32 g_pointer_size;             /* -$18: its size */
struct Task *g_h029_task;       /* -$20: task of the game */
struct View *g_saved_view;      /* -$24: GfxBase->ActiView at start-up */
struct View g_offscreen_view;   /* -$36: View of the bitmap of $3D8E */
struct ViewPort g_offscreen_vp; /* -$5E */
struct RasInfo g_offscreen_ri;  /* -$6A */
struct Library *g_h029_intuition; /* -$E: intuition.library opened here */
u16 g_h029_m1a;                 /* -$1A: depth of the off-screen drawing */
u16 g_h029_m8;                  /* -$8: View shown by H029+$1576 */
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
 * PORT H029+$0312: writes value into dst[0..count-1].  The first argument is not
 * read.  The loop compares the index (word) with count-1 unsigned:
 * with count = 0 it fills 65536 bytes, like the original.
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
 * The 12 entries of $A bytes at the start of pointers.daa begin with the offset
 * (long) of the pointer data.  The original turns it in place into an
 * absolute address (offset + base); here the address goes into this table,
 * because on the host a pointer does not fit in 32 bits, and the buffer stays as
 * it was read.  Whoever reads entry i uses g_pointer_image[i].
 */
u8 *g_pointer_image[12];

/* PORT H029+$0180: frees pointers.daa and removes the mouse pointer. */
void free_pointer_data(void)
{
    if (g_pointer_data != NULL) {
        exec_free_mem(g_pointer_data, g_pointer_size);
        g_pointer_data = NULL;
        intuition_clear_pointer(g_window);
    }
}

/* PORT H029+$0234: loads pointers.daa (chip memory). */
static void load_pointer_data(void)
{
    cok_bptr file;
    s16 i;

    file = dos_open("pointers.daa", MODE_OLDFILE);
    if (file == 0) {
        return;
    }
    /* Seek returns the previous position: the second one gives the length. */
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

/* PORT H029+$115C: initial palette of 16 RGB4 colours in H005+$52AE. */
static void set_game_palette(void)
{
    static const u16 colors[16] = {
        0x000, 0x00A, 0x0A0, 0x0AA, 0xA00, 0xA0A, 0xA50, 0xAAA,
        0x555, 0x55F, 0x5F5, 0x5FF, 0xF55, 0xF5F, 0xFF5, 0xFFF
    };
    unsigned i;

    for (i = 0; i < 16; ++i) {
        /* $52AE: current screen palette, RGB4 (16 or 32 colours) */
        H005_SET_W(0x52AE + i * 2, colors[i]);
    }
    /* $52AE: current screen palette, RGB4 (16 or 32 colours) */
    graphics_load_rgb4(&g_screen->ViewPort, &g_h005[0x52AE], 0x10);
}

/*
 * PORT H029+$1206: opens the 320x200 5-plane screen without a title and the
 * full-screen window (BACKDROP|BORDERLESS|ACTIVATE|RMBTRAP, IDCMP
 * MOUSEBUTTONS|RAWKEY), routes the system requests to the window,
 * sets the palette and loads the mouse pointers.  The first write
 * goes to H024+$4 (move.w #$10F, (H024+$4).l), the Type of the NewScreen:
 * CUSTOMSCREEN | SCREENQUIET ($100), the screen without title bar
 * or gadgets.
 */
void open_game_display(void)
{
    g_h024_m14 = 0x010F;    /* H024+$4: Type = CUSTOMSCREEN | SCREENQUIET */
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

/* PORT H029+$12BC: closes window and screen and reopens the Workbench. */
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
 * PORT H029+$0408 (Allocate_GraphicRecord): width = width8 * 8 * count
 * pixels, aligned to 16; record and 5-plane BitMap, every plane allocated and
 * cleared.  With with_mask = 1 also a mask BitMap with a single
 * raster, repeated in the 5 planes.  Allocation errors go to
 * H014+$0018 with the plane number and "plane alloc problem".
 *
 * Different from the original: BltClear with flags = 1 (waits for the end of
 * the blit).  The original passes 0 and the caller writes the planes right
 * away with the CPU (CopyMem in transfer_gfx_planes): with a fast CPU (68040,
 * or FS-UAE with cpu_speed=max) the last BltClear finishes after the copy and
 * clears the 5th plane, and the picture takes colours 0..15.
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
            graphics_blt_clear(bm->Planes[i], (u32)(width >> 3) * rows, 1);
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
            graphics_blt_clear(bm->Planes[0], (u32)(width >> 3) * rows, 1);
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

/* PORT H029+$1308: signed byte extended to a word. */
static s16 signed_byte(u8 b)
{
    s16 v = (s16)b;

    if (b >= 0x80) {
        v = (s16)(v - 0x100);
    }
    return v;
}

/*
 * PORT H029+$1346 (Prepare_DisplayResources), only the first time
 * ($3D8E null): 320x200 5-plane graphic record in $3D8E with its own
 * RastPort, a View with a ViewPort that shows it (offsets taken
 * from the Preferences, 32-colour ColorMap, Copper lists built),
 * opening of intuition.library and saving of GfxBase->ActiView.
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
    /* Not in the original: same monitor as the screen (see H022). */
    graphics_attach_view_mode(&g_offscreen_view, &g_offscreen_vp,
                              &g_screen->ViewPort);
    graphics_make_vport(&g_offscreen_view, &g_offscreen_vp);
    graphics_mrg_cop(&g_offscreen_view);

    g_h029_intuition = exec_open_library("intuition.library", 0);
    gfx = exec_open_library("graphics.library", 0);
    g_saved_view = ((struct GfxBase *)gfx)->ActiView;
    exec_close_library(gfx);
}

/* Width in pixels of the record (units * 8 * bytes), aligned to 16. */
static u16 gfx_record_width(const struct GfxRecord *r)
{
    u16 width = (u16)((u16)(r->count << 3) * r->width8);

    if ((width & 0x0F) > 0) {
        width = (u16)(width + (0x10 - (width & 0x0F)));
    }
    return width;
}

/*
 * PORT H029+$067A (Free_GraphicRecord): frees raster, mask, BitMap and
 * record; *rec becomes NULL.
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

/* PORT H029+$0354: value AND mask (byte); also used as a bit test. */
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
 * PORT H029+$0766: builds the mask (a single raster repeated in the 5
 * planes) of the picture.  With a transparent colour: for every plane OR
 * ($E0) of the plane where the colour bit is 0, OR of the complement ($B0)
 * where it is 1, that is mask = pixels different from the colour; with fewer than 3
 * units the picture is then reduced to the mask (AND, $80).  Without a
 * colour (0): mask = OR of all the planes.
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
 * PORT H029+$091E: copies the planes 0..last_plane from the loaded block
 * (starting at offset, one plane after the other) into the picture, then
 * builds the mask if the record has one.
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
 * PORT H029+$0A0E (Load_IndexedGraphicRecord): loads block id of
 * name.daa and makes a graphic record of it in *rec (freeing the previous one).
 * 9-byte header: rows, units, two words, unit width;
 * the "8x8..." sets have 4 planes after the header, the others a palette
 * of 32 colours (copied into H005+$522E) and 5 planes.
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
        /* $522E: palette of the loaded picture, 32 RGB4 colours ($40 bytes) */
        exec_copy_mem(data + 9, &g_h005[0x522E], 0x40);
    }
    allocate_gfx_record(COK_GET16(header), COK_GET16(header + 2), header[8],
                        with_mask, rec);
    /* As in the original: both words go into the +$04 field. */
    (*rec)->w4 = COK_GET16(header + 4);
    (*rec)->w4 = COK_GET16(header + 6);
    transfer_gfx_planes(data, offset, last_plane, mask_color, rec);
    exec_free_mem(data, size);
}

/*
 * PORT H029+$0EFE: recolours the record: every colour from[i] different from
 * to[i] becomes to[i].  frame < 0: the whole record; otherwise the column
 * of units frame (width count*8 + 1, as in the original).  It works on
 * a temporary copy with a mask: for every colour, mask of the pixels
 * of that colour (H029+$0766) and inversion ($90) of the planes in which from and
 * to differ.  The two tables are passed by value (16 bytes on the
 * stack each); here they are copied.
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
 * PORT H029+$01B6: sets the mouse pointer shape (0..11) from
 * pointers.daa, if different from the current one (H029 -$10).  Entry of $A
 * bytes: data (g_pointer_image), +4 and +6 hot spot, +8 height;
 * width 16.
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
 * PORT H029+$148E: frees the off-screen View of H029+$1346 (ColorMap,
 * Copper lists, RastPort), closes the intuition.library opened there and frees the
 * record of $3D8E.
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
        graphics_detach_view_mode(&g_offscreen_view); /* not in the original */
        exec_free_mem(g_offscreen_rp, sizeof(struct RastPort));
        g_offscreen_rp = NULL;
        lib = g_h029_intuition;
        exec_close_library(lib);
    }
    free_gfx_record(&g_gfx_3d8e);
}

/*
 * PORT H029+$10B8: fills with pen the rectangle of 8x8 cells from (col, row)
 * width wide and height high in the RastPort of the window.  The record is not
 * used.
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
 * PORT H029+$14F6: waits (H010+$0974) until the game screen is
 * at the front (IntuitionBase->FirstScreen).
 */
void wait_screen_in_front(void)
{
    while (((struct IntuitionBase *)g_h029_intuition)->FirstScreen != g_screen) {
        wait_for_key();
    }
}

/*
 * PORT H029+$1520: copies the screen (320x200) into the off-screen bitmap
 * of $3D8E; the result of BltBitMap goes into H005+$3358.
 */
void copy_screen_to_offscreen(void)
{
    s32 r;

    r = graphics_blt_bitmap(g_screen->RastPort.BitMap, 0, 0,
                            g_gfx_3d8e->image, 0, 0, 0x140, 0xC8, 0xC0, 0xFF,
                            NULL);
    H005_SET_W(0x3358, (u16)r); /* $3358: (word) result of BltBitMap in the screen copy */
    g_h029_m8 = 0;
    g_h029_m9 = 0;
}

/*
 * PORT H029+$1576: swaps the View shown: with -$8 = 0 the off-screen
 * View (and drawing goes to the screen), with 1 the Intuition one (and
 * drawing goes off screen); then waits for the frame.
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
 * PORT H029+$16A2: start of an update: on the first call copies
 * the screen off screen and shows that copy (the View of $3D8E) while
 * drawing on the screen; the calls nest (-$1A).
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
 * PORT H029+$16DE: end of the update: on the last call the Intuition
 * View comes back and drawing passes to the queued blitter (-$6 = 1).
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
 * PORT H029+$0B94 (Draw_GraphicTile24): draws frame frame (24x24,
 * column frame*24) of src at (x, y), moved by 8 pixels in combat.
 * With masked = 1 and a mask it uses the cookie-cut (minterm $CA with the queued
 * blitter, $E0 with BltMaskBitMapRastPort), otherwise it copies.  The RastPort
 * is the off-screen one if active (-$5), otherwise the screen one
 * (-$9 = 1).  unused ($3D8E) is not read.
 */
void draw_tile24(u16 x, u16 y, u8 frame, u8 masked, struct GfxRecord *src,
                 struct GfxRecord *unused)
{
    u16 off;                            /* -$2(a5) */
    u16 src_x;                          /* -$6(a5) */
    struct RastPort *rp;                /* -$E(a5) */

    (void)unused;
    src_x = (u16)(frame * 0x18);
    /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
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
 * PORT H029+$0D58: like H029+$0B94; with mode = 5 it first saves in $3D8A the
 * destination 24x24 square (from the screen or from $3D8E) and draws with
 * the mask.
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
 * PORT H029+$1718: copies into the off-screen View the 32 colours of the
 * Intuition screen, read from its Copper list (start-up View, -$24):
 * from the MOVE COLOR00 = 0 the values of 32 consecutive MOVEs are taken.
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
 * PORT H029+$0E26: copies into the record (BitMap +$10) the screen box
 * at the cell (x, y) of 8 pixels, count*8 wide and rows high.
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

/* PORT H029+$0E92: puts back on the screen the box saved by $0E26. */
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
