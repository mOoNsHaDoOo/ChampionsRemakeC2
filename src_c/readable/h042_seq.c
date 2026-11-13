/* H042: graphic sequences, cache, HEAD/BODY and BIGPIC. */
#include "h042_seq.h"
#include "h003_exec.h"
#include "h029_gfx.h"
#include "globals.h"
#include <string.h>
#include "h002_dos.h"
#include "h010_input.h"
#include "h016_gfx.h"
#include "h020_io.h"
#include "h022_view.h"
#include "h023_shared.h"
#include "h026_string.h"
#include "h028_files.h"
#include "h030.h"
#include "h036.h"
#include "h044_tiles.h"
#include "h045.h"
#include "h049.h"
#include "h087.h"

u8 g_h042_m1;                   /* -$1(a4) */
u8 g_h042_m2;                   /* -$2(a4) */

/* PORT H042+$0146 */
void h042_init(void)
{
    g_h042_m1 = 0;
    g_h042_m2 = 0;
}

/*
 * PORT H042+$0300: frees the picture set of H005+$27BC (always
 * that one: the argument of the original is always H005+$27BC).  The two
 * pictures, the blocks 2..count (sizes at $27DA), clears the
 * count, empties the name at $27A6 and puts $FF in $2486.
 */
void release_picture_set(void)
{
    u16 i;

    g_h042_m1 = 0;
    free_gfx_record(&g_pic_rec_27c2);
    free_gfx_record(&g_pic_rec_27c6);
    /* $27BC: (word) frames of the loaded sequence (max 6), base of the block */
    for (i = 2; i <= H005_W(0x27BC); ++i) {
        if (g_pic_buffers[i - 2] != NULL) {
            /* $27DA: tab. of 7 words: compressed size of frames 2..n (idx frame-2) */
            exec_free_mem(g_pic_buffers[i - 2], H005_W(0x27DA + (i - 2) * 2));
            g_pic_buffers[i - 2] = NULL;
        }
    }
    H005_SET_W(0x27BC, 0); /* $27BC: (word) frames of the loaded sequence (max 6), base of the block */
    /* $27A6: name (8 chars) of the loaded picture sequence, empty if none */
    H005_B(0x27A6) = 0;                 /* empty string (dbeq with $8) */
    H005_B(0x2486) = 0xFF; /* $2486: id of the sequence loaded at $27BC (name at $27A6), $FF none */
}

#define SEQ_COUNT   0x27BC              /* +$0: frames */
#define SEQ_CURRENT 0x27BE              /* +$2: current frame */
#define SEQ_LAST    0x27C0              /* +$4: frame in g_pic_rec_27c6 */
#define SEQ_EXTRA   0x27CA              /* +$E: two bytes per frame */
#define SEQ_PSIZE   0x27DA              /* +$1E: compressed sizes 2.. */

/*
 * PORT H042+$01AE: replaces the record with its horizontally mirrored
 * copy (H049+$09D6), with the mask if there was one.
 */
static void mirror_record(struct GfxRecord **rec)
{
    struct GfxRecord *copy = NULL;      /* -$4(a5) */
    u16 with_mask;                      /* -$6(a5) */

    if (*rec == NULL) {
        return;
    }
    with_mask = (u16)((*rec)->mask != NULL ? 1 : 0);
    allocate_gfx_record((*rec)->rows, (*rec)->count, (*rec)->width8,
                        with_mask, &copy);
    copy->w4 = (*rec)->w4;
    copy->w6 = (*rec)->w6;
    mirror_gfx_record(*rec, copy);
    free_gfx_record(rec);
    *rec = copy;
}

/*
 * PORT H042+$0254: shows the record at the cell (x, y) with the palette of
 * $52AE.  flag is not used.
 */
void show_picture(u16 x, u16 y, u8 flag, struct GfxRecord *rec)
{
    (void)flag;
    if (rec == NULL) {
        return;
    }
    copy_intuition_colors();
    begin_screen_update();
    /* $52AE: current screen palette, RGB4 (16 or 32 colours) */
    graphics_load_rgb4(&g_screen->ViewPort, &g_h005[0x52AE], 0x20);
    restore_screen_cell(x, y, rec);
    end_screen_update();
}

/* PORT H042+$02B2: the head at the cell (x, y). */
static void show_head(struct GfxRecord *rec, u16 x, u16 y)
{
    show_picture(x, y, 0, rec);
}

/* PORT H042+$02D6: the body, 5 cells below the head. */
static void show_body(struct GfxRecord *rec, u16 x, u16 y)
{
    show_picture(x, (u16)(y + 5), 0, rec);
}

/* PORT H042+$03BC: dst = src XOR dst (frames saved as a difference). */
static void xor_bitmap(struct BitMap *src, struct BitMap *dst)
{
    (void)graphics_blt_bitmap(src, 0, 0, dst, 0, 0,
                              (u16)(dst->BytesPerRow << 3), dst->Rows, 0x60,
                              0xFF, NULL);
}

/*
 * PORT H042+$0406 (Load_Sequence): loads sequence id of name+disk.daa
 * into the set $27BC (the argument of the original is always that one), if
 * different from the current one.  Directory: size word, 6-byte entries
 * (id, one byte, long offset).  Block: compressed header
 * (rows, units, w4, w6, frames, palette of 32 colours for $52AE,
 * compressed sizes), then every ByteRun1 frame followed by two
 * bytes.  The first one becomes g_pic_rec_27c2; with two frames the second one
 * is already decoded into g_pic_rec_27c6 (saved as XOR with the first),
 * with more frames they stay compressed in g_pic_buffers.  The PIC and
 * FINAL pictures have no transparency and, without $24D4, a single frame.
 * At random (H023+$0010) the pictures are mirrored.  More than 6
 * frames would read past the header: here at most 6.
 */
void load_sequence(u16 name_len, const char *name, u16 id, u16 with_mask)
{
    char local[0x52];                   /* -$52(a5) */
    char num[2];                        /* -$62(a5) */
    u8 dir_raw[2];                      /* -$72(a5) */
    u16 dir_size;
    cok_bptr file;                      /* -$70(a5) */
    u8 entry[6];                        /* -$68(a5) */
    u8 head_size_raw[2];                /* -$CC(a5) */
    u16 head_size;
    u8 head[0x56];                      /* -$CA(a5) */
    u8 *packed;                         /* -$5A(a5) */
    u8 *planes = NULL;                  /* -$56(a5) */
    u8 *src;                            /* -$D6(a5) */
    u8 *dst;                            /* -$DA(a5) */
    struct BitMap *saved_mask;          /* -$DE(a5) */
    u16 plane_bytes = 0;                /* -$5E(a5) */
    u16 frames;                         /* -$C2(a5) */
    u16 k;                              /* -$5C(a5) */
    u8 color;                           /* -$D0(a5) */
    u8 is_pic;                          /* -$5F(a5) */
    s32 pos;

    h026_copy(0x50, local, name_len, name);
    /* $27A6: name (8 chars) of the loaded picture sequence, empty if none */
    if ((h026_compare_nocase(0x50, local, 8, (const char *)&g_h005[0x27A6]) == 1 &&
         /* $2486: id of the sequence loaded at $27BC (name at $27A6), $FF none */
         H005_B(0x2486) == id) || id == 0xFF) {
        return;
    }
    g_h042_m2 = (u8)(random_below(2) == 1);
    if (H005_B(0x24D4)) { /* $24D4: Animation on/off (Alter): more frames and "Loading..." */
        fill_text_cells(0, 0x18, 0, 0x28);
        ui_draw_text(0, 0x18, 0x0A, 0, 0x15, "Loading...Please Wait");
    }
    /* $27A6: name (8 chars) of the loaded picture sequence, empty if none */
    h026_copy(8, (char *)&g_h005[0x27A6], 0x50, local);
    H005_B(0x2486) = (u8)id; /* $2486: id of the sequence loaded at $27BC (name at $27A6), $FF none */
    is_pic = (u8)(h026_compare_nocase(0x50, local, 3, "PIC") == 1 ||
                  h026_compare_nocase(0x50, local, 5, "FINAL") == 1);
    /* $246E: data disk / current resource group (G_RESOURCE_GROUP) */
    format_number(1, num, (s32)H005_B(0x246E), 0, 0x0A, 1, '0');
    h026_append(0x50, local, 1, num);
    if (!dax_open(0x50, local, 4, ".daa", dir_raw, &file)) {
        console_write(0x2D, "Could not open indexed file in loadsequence!\n");
        return;
    }
    dir_size = COK_GET16(dir_raw);
    do {
        (void)dos_read(file, entry, 6);
        if (entry[0] == id) {
            break;
        }
        pos = dos_seek(file, 0, OFFSET_CURRENT);
    } while (pos < (s32)dir_size);
    if (entry[0] != id) {
        dos_close(file);
        return;
    }
    release_picture_set();
    /* $27A6: name (8 chars) of the loaded picture sequence, empty if none */
    h026_copy(8, (char *)&g_h005[0x27A6], name_len, name);
    H005_B(0x2486) = (u8)id; /* $2486: id of the sequence loaded at $27BC (name at $27A6), $FF none */
    (void)dos_seek(file, (s32)dir_size + (s32)COK_GET32(entry + 2),
                   OFFSET_BEGINNING);

    /* Intestazione. */
    (void)dos_read(file, head_size_raw, 2);
    head_size = COK_GET16(head_size_raw);
    packed = (u8 *)exec_alloc_mem(head_size, 0);
    (void)dos_read(file, packed, head_size);
    src = packed;
    dst = head;
    if (ilbm_unpack_row(&src, &dst, (s16)head_size, 0x56)) {
        console_write(0x25, "Error unpacking row in LoadSequence!\n");
    }
    exec_free_mem(packed, head_size);
    /* $52AE: current screen palette, RGB4 (16 or 32 colours) */
    exec_copy_mem(head + 0x0A, &g_h005[0x52AE], 0x40);
    H005_SET_W(0x52AE, 0); /* $52AE: current screen palette, RGB4 (16 or 32 colours) */

    /* First frame. */
    packed = (u8 *)exec_alloc_mem(COK_GET16(head + 0x4A), 0);
    (void)dos_read(file, packed, COK_GET16(head + 0x4A));
    /* $27CA: tab. of words per frame (idx frame-1): duration in 1/10 s */
    (void)dos_read(file, &g_h005[SEQ_EXTRA], 2);
    g_pic_rec_27c6 = NULL;
    allocate_gfx_record(COK_GET16(head), COK_GET16(head + 2), 1, with_mask,
                        &g_pic_rec_27c2);
    g_pic_rec_27c2->w4 = COK_GET16(head + 4);
    g_pic_rec_27c2->w6 = COK_GET16(head + 6);
    plane_bytes = g_pic_rec_27c2->plane_bytes;
    planes = (u8 *)exec_alloc_mem(plane_bytes, 0);
    src = packed;
    dst = planes;
    if (ilbm_unpack_row(&src, &dst, (s16)COK_GET16(head + 0x4A),
                        (s16)plane_bytes)) {
        console_write(0x29, "Error calling UnPackRow in LoadSequence!\n");
    }
    exec_free_mem(packed, COK_GET16(head + 0x4A));
    color = (u8)(is_pic ? 0 : 0x0D);
    transfer_gfx_planes(planes, 0, 4, color, &g_pic_rec_27c2);
    g_h042_m1 = g_h042_m2;
    if (g_h042_m2) {
        mirror_record(&g_pic_rec_27c2);
    }
    frames = COK_GET16(head + 8);
    if (!H005_B(0x24D4) && is_pic) { /* $24D4: Animation on/off (Alter): more frames and "Loading..." */
        frames = 1;
    }
    if (frames > 6) {
        frames = 6;
    }
    /* $27BC: (word) frames of the loaded sequence (max 6), base of the block */
    H005_SET_W(SEQ_COUNT, frames);
    H005_SET_W(SEQ_CURRENT, 1); /* $27BE: (word) current frame of the sequence animation (1..n) */
    H005_SET_W(SEQ_LAST, 0); /* $27C0: (word) frame currently in g_pic_rec_27c6 (0 none) */
    if (frames >= 2) {
        allocate_gfx_record(COK_GET16(head), COK_GET16(head + 2), 1,
                            with_mask, &g_pic_rec_27c6);
        g_pic_rec_27c6->w4 = COK_GET16(head + 4);
        g_pic_rec_27c6->w6 = COK_GET16(head + 6);
        if (frames == 2) {
            packed = (u8 *)exec_alloc_mem(COK_GET16(head + 0x4C), 0);
            (void)dos_read(file, packed, COK_GET16(head + 0x4C));
            /* $27CC: (word) duration of the 2nd frame (entry 2 of the table $27CA) */
            (void)dos_read(file, &g_h005[SEQ_EXTRA + 2], 2);
            src = packed;
            dst = planes;
            (void)ilbm_unpack_row(&src, &dst, (s16)COK_GET16(head + 0x4C),
                                  (s16)plane_bytes);
            exec_free_mem(packed, COK_GET16(head + 0x4C));
            saved_mask = g_pic_rec_27c6->mask;
            g_pic_rec_27c6->mask = NULL;
            transfer_gfx_planes(planes, 0, 4, color, &g_pic_rec_27c6);
            if (g_h042_m2) {
                mirror_record(&g_pic_rec_27c6);
            }
            xor_bitmap(g_pic_rec_27c2->image, g_pic_rec_27c6->image);
            if (saved_mask != NULL) {
                g_pic_rec_27c6->mask = saved_mask;
                build_gfx_mask(color, g_pic_rec_27c6);
            }
            H005_SET_W(SEQ_LAST, 2); /* $27C0: (word) frame currently in g_pic_rec_27c6 (0 none) */
        } else {
            for (k = 2; k <= frames; ++k) {
                u16 size = COK_GET16(head + 0x4A + (k - 1) * 2);

                g_pic_buffers[k - 2] = (u8 *)exec_alloc_mem(size, 0);
                (void)dos_read(file, g_pic_buffers[k - 2], size);
                /* $27CA: tab. of words per frame (idx frame-1): duration in 1/10 s */
                (void)dos_read(file, &g_h005[SEQ_EXTRA + (k - 1) * 2], 2);
                /* $27DA: tab. of 7 words: compressed size of frames 2..n (idx frame-2) */
                H005_SET_W(SEQ_PSIZE + (k - 2) * 2, size);
            }
        }
    }
    if (planes != NULL) {
        exec_free_mem(planes, plane_bytes);
    }
    dos_close(file);
    if (H005_B(0x24D4)) { /* $24D4: Animation on/off (Alter): more frames and "Loading..." */
        fill_text_cells(0, 0x18, 0, 0x28);
    }
}

/*
 * PORT H042+$0B80: the record of frame frame (1..count) of the
 * sequence $27BC.  The first one and the one already in g_pic_rec_27c6 with a pause
 * of 11 ticks; the others are decompressed into g_pic_rec_27c6 as XOR with the
 * first.  Outside the range NULL.  The first time, if the sequence has to be
 * mirrored, it mirrors the records already prepared.
 */
struct GfxRecord *sequence_frame(u16 frame)
{
    u8 *buf;                            /* -$4(a5) */
    u16 n;                              /* -$6(a5) */
    u8 *src;                            /* -$C(a5) */
    u8 *dst;                            /* -$10(a5) */
    struct BitMap *saved_mask;          /* -$14(a5) */

    if (g_h042_m2 && !g_h042_m1) {
        g_h042_m1 = 1;
        mirror_record(&g_pic_rec_27c2);
        /* $27BC: (word) frames of the loaded sequence (max 6), base of the block */
        if (H005_W(SEQ_COUNT) == 2) {
            mirror_record(&g_pic_rec_27c6);
        }
    }
    /* $27BC: (word) frames of the loaded sequence (max 6), base of the block */
    if (frame < 1 || frame > H005_W(SEQ_COUNT)) {
        return NULL;
    }
    /* $27C0: (word) frame currently in g_pic_rec_27c6 (0 none) */
    if (frame == 1 || frame == H005_W(SEQ_LAST)) {
        dos_delay(0x0B);
        return frame == 1 ? g_pic_rec_27c2 : g_pic_rec_27c6;
    }
    n = g_pic_rec_27c6->plane_bytes;
    buf = (u8 *)exec_alloc_mem(n, 0);
    src = g_pic_buffers[frame - 2];
    dst = buf;
    /* $27DA: tab. of 7 words: compressed size of frames 2..n (idx frame-2) */
    if (ilbm_unpack_row(&src, &dst, (s16)H005_W(SEQ_PSIZE + (frame - 2) * 2),
                        (s16)n)) {
        console_write(0x24, "Error in UnPackRow in loadSequence!\n");
    }
    saved_mask = g_pic_rec_27c6->mask;
    g_pic_rec_27c6->mask = NULL;
    transfer_gfx_planes(buf, 0, 4, 0, &g_pic_rec_27c6);
    if (g_h042_m1) {
        mirror_record(&g_pic_rec_27c6);
    }
    xor_bitmap(g_pic_rec_27c2->image, g_pic_rec_27c6->image);
    if (saved_mask != NULL) {
        g_pic_rec_27c6->mask = saved_mask;
        build_gfx_mask(0x0D, g_pic_rec_27c6);
    }
    H005_SET_W(SEQ_LAST, frame); /* $27C0: (word) frame currently in g_pic_rec_27c6 (0 none) */
    exec_free_mem(buf, n);
    return g_pic_rec_27c6;
}

/*
 * PORT H042+$0D70 (Load_HeadBody): loads head and body (HEADn/BODYn.daa)
 * if different from the ones already loaded ($27B0, $27B6); $FF leaves them.
 */
void load_head_body(u16 head, u16 body)
{
    char num[2];                        /* -$2(a5) */
    char name[0x2A];                    /* -$2C(a5) */

    /* $246E: data disk / current resource group (G_RESOURCE_GROUP) */
    format_number(1, num, (s32)H005_B(0x246E), 0, 0x0A, 1, '0');
    /* $27B0: 2 entries of 6 bytes (id + long gfx at +2): loaded HEAD id, $FF none */
    if (head != 0xFF && (H005_B(0x27B0) == 0xFF || H005_B(0x27B0) != head)) {
        strcpy(name, "HEAD");
        h026_append(0x28, name, 1, num);
        load_indexed_gfx_record(0x28, name, head, 0, 0, &g_gfx_27b0[0]);
        if (g_gfx_27b0[0] == NULL) {
            show_message_wait(0x0E, 0, 0x0E, "head NOT found");
        }
        /* $27B0: 2 entries of 6 bytes (id + long gfx at +2): loaded HEAD id, $FF none */
        H005_B(0x27B0) = (u8)head;
    }
    /* $27B6: id of the loaded BODY (2nd 6-byte entry of $27B0), $FF none */
    if (body != 0xFF && (H005_B(0x27B6) == 0xFF || H005_B(0x27B6) != body)) {
        strcpy(name, "BODY");
        h026_append(0x28, name, 1, num);
        load_indexed_gfx_record(0x28, name, body, 0, 0, &g_gfx_27b0[1]);
        if (g_gfx_27b0[1] == NULL) {
            show_message_wait(0x0E, 0, 0x0E, "head not found");
        }
        H005_B(0x27B6) = (u8)body; /* $27B6: id of the loaded BODY (2nd 6-byte entry of $27B0), $FF none */
    }
}

/*
 * PORT H042+$0ED2: shows the head (and with flag the body below) at the cell
 * (x, y), with the loaded palette ($522E -> $52AE).
 */
void draw_head_body(u16 x, u16 y, u8 flag)
{
    /* $522E: palette of the loaded picture, 32 RGB4 colours ($40 bytes); $52AE: current screen
     * palette, RGB4 (16 or 32 colours) */
    exec_copy_mem(&g_h005[0x522E], &g_h005[0x52AE], 0x40);
    copy_intuition_colors();
    begin_screen_update();
    if (flag) {
        show_head(g_gfx_27b0[0], x, y);
        show_body(g_gfx_27b0[1], x, y);
    } else {
        show_picture(x, y, 0, g_gfx_27b0[0]);
    }
    end_screen_update();
}

/*
 * PORT H042+$0F50 (Show3DSprite): frame 1..3 of the sequence
 * (sprite of the distant encounter) masked into the view.
 */
void show_3d_sprite(u16 frame)
{
    struct GfxRecord *rec;              /* -$6(a5) */

    if (frame < 1 || frame > 3) {
        console_writeln(0x1E, "Illegal range in Show3DSprite.");
        quit_game();
    }
    rec = sequence_frame(frame);
    if (rec != NULL) {
        /* $52AE: current screen palette, RGB4 (16 or 32 colours) */
        graphics_load_rgb4(&g_screen->ViewPort, &g_h005[0x52AE], 0x20);
        (void)queue_bitplane_blit(rec->image, 0, 0, &g_screen->RastPort,
                                  0x18, 0x18, 0x58, 0x58, 0xCA,
                                  (u8 *)rec->mask->Planes[0]);
    }
}

/*
 * PORT H042+$1006 (Load_BigPicture): frees the sequence and, if different from
 * the loaded one ($2484), loads the big picture id of BIGPICn.daa into
 * $2798 with its palette ($522E -> $526E).
 */
void load_big_picture(u16 id)
{
    char name[0x2A];                    /* -$2C(a5) */
    char num[2];                        /* -$2E(a5) */
    u16 i;                              /* -$2(a5) */

    release_picture_set();
    if (H005_B(0x2484) == id) { /* $2484: id of the loaded BIGPIC big picture ($FF none) */
        return;
    }
    strcpy(name, "BIGPIC");
    /* $246E: data disk / current resource group (G_RESOURCE_GROUP) */
    format_number(1, num, (s32)H005_B(0x246E), 0, 0x0A, 1, '0');
    h026_append(0x28, name, 1, num);
    load_indexed_gfx_record(0x28, name, id, 0, 0, &g_gfx_2798);
    for (i = 0; i <= 0x1F; ++i) {
        /* $522E: palette of the loaded picture, 32 RGB4 colours ($40 bytes); $526E:
         * palette of the big picture (outdoor map), 32 colours */
        H005_SET_W(0x526E + i * 2, H005_W(0x522E + i * 2));
    }
    H005_B(0x2484) = (u8)id; /* $2484: id of the loaded BIGPIC big picture ($FF none) */
}

/*
 * PORT H042+$10DC: shows the big picture (outdoor map) in the
 * outdoor frame, with its palette.
 */
void show_big_picture(void)
{
    copy_intuition_colors();
    begin_screen_update();
    draw_wild_frame();
    /* $526E: palette of the big picture (outdoor map), 32 colours */
    graphics_load_rgb4(&g_screen->ViewPort, &g_h005[0x526E], 0x20);
    restore_screen_cell(1, 1, g_gfx_2798);
    end_screen_update();
}
