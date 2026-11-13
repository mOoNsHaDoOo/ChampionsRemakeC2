/* H049: Text/glyph drawing, direct blitter and QBSBlit nodes. */
#include "h049.h"
#include "custom.h"

#if COK_AMIGA
#include <proto/graphics.h>
#endif

/*
 * PORT H049+$0008: copies GfxBase of the H015 runtime into the module cell.
 * In C the library base is already global: nothing to do.
 */
void h049_init(void)
{
}

/*
 * State of the text drawing (structure in the code at H049+$09BC).
 */
static struct {
    u16 first_mask;             /* +$00: BLTAFWM */
    u16 last_mask;              /* +$02: BLTALWM */
    u16 offset;                 /* +$04: byte of the area in the plane */
    u16 width;                  /* +$06: width in bytes (even) */
    u16 size;                   /* +$08: BLTSIZE (8 rows) */
    u16 count;                  /* +$0A: characters to draw */
    u8 *glyphs;                 /* +$0C: font plane (128x32) */
    struct BitMap *dest;        /* +$10: destination bitmap */
    u16 rendered;               /* +$14: glyphs already drawn in a plane */
    u16 rendered_plane;         /* +$16: that plane */
    u16 rendered_xor;           /* +$18: and its inversion (0/$FFFF) */
} s_text;

/*
 * PORT H049+$0438: registers the glyph source and the destination
 * bitmap.  Assembly routine with arguments on the stack:
 * $8(a7) (first argument) = glyphs, $4(a7) = destination.
 */
void h049_set_glyph_planes(u8 *glyphs, struct BitMap *dest)
{
    s_text.glyphs = glyphs;
    s_text.dest = dest;
}

/* PORT H049+$044E: length of the string up to the NUL (long). */
static u32 text_length(const char *text)
{
    u32 n = 0;

    while (*text++ != 0) {
        ++n;
    }
    return n;
}

/*
 * PORT H049+$045A (Draw_GlyphRowsCPU): count 8x8 characters from the font
 * (16 characters per row of 16 bytes, codes from $20; from $60 up another
 * $20 is subtracted) into dest, one row every modulo bytes, each byte xored with
 * invert (0 or $FF).  The comparison with $60 is signed: codes from $80
 * up are not reduced.
 */
static void draw_glyph_rows(s16 count, const char *text, u8 *dest,
                            u16 modulo, u8 invert)
{
    const u8 *font = s_text.glyphs;

    while (--count >= 0) {
        s8 c = (s8)*text++;
        u16 index;
        u16 row;
        u16 at = 0;

        if (c >= 0x60) {
            c = (s8)(c - 0x20);
        }
        c = (s8)(c - 0x20);
        index = (u16)(((u8)c & 0x0F) + (((u8)c & 0x30) << 3));
        for (row = 0; row < 8; ++row) {
            dest[at] = (u8)(font[index] ^ invert);
            index = (u16)(index + 0x10);
            at = (u16)(at + modulo);
        }
        ++dest;
    }
}

/* Address of the text area in plane plane of the destination. */
static u8 *text_area(u16 plane)
{
    return (u8 *)s_text.dest->Planes[plane] + s_text.offset;
}

/*
 * PORT H049+$0224 (Draw_TextWithBlitter): writes text (at most up to
 * column 40) into the 40x25 grid of 8x8 cells of the destination,
 * with pen fg on background bg.  For each plane (from 4 down to 0): if the bits of
 * fg and bg are the same it fills the area with 0 or 1 (blitter, minterm $CA with
 * constant A and masks on the odd columns); otherwise the first of
 * these planes gets the glyphs from the CPU (inverted if the bit is bg's) and
 * the others copy them with the blitter (straight or inverted, minterm $CA/$3A).
 * len is not used: the NUL counts.
 */
void draw_text_blitter(u16 col, u16 row, u16 fg, u16 bg, u16 len,
                       const char *text)
{
    s16 count;
    s16 limit;
    u16 bytes;
    u16 first;
    s16 plane;
    u16 invert;

    (void)len;
    s_text.rendered = 0;
    count = (s16)text_length(text);
    if ((u8)count == 0) {
        return;
    }
    limit = (s16)(0x28 - col);
    if (!(count < limit)) {
        count = limit;
    }
    s_text.count = (u16)count;
    s_text.first_mask = (col & 1) ? 0x00FF : 0xFFFF;
    bytes = (u16)(col + s_text.count);
    s_text.last_mask = (bytes & 1) ? 0xFF00 : 0xFFFF;
    first = (u16)(col & ~1u);
    bytes = (u16)(((u16)(bytes + 1) & ~1u) - first);
    s_text.width = bytes;
    s_text.size = (u16)(((s16)bytes >> 1) + 0x200);
    s_text.offset = (u16)((u16)((row << 3) * 0x28) + first);

    OwnBlitter();            /* direct calls to graphics.library */
    for (plane = 4; plane >= 0; --plane) {
        int fg_bit = (fg >> plane) & 1;
        int bg_bit = (bg >> plane) & 1;

        invert = (fg_bit == bg_bit) ? (fg_bit ? 0xFFFF : 0) :
                 (bg_bit ? 0xFFFF : 0);
        if (fg_bit == bg_bit) {
            /* Full area: D = B (constant) inside the masks, C outside. */
            WaitBlit();
            CUSTOM_W(BLTCMOD, 0x28 - s_text.width);
            CUSTOM_W(BLTDMOD, 0x28 - s_text.width);
            CUSTOM_W(BLTAFWM, s_text.first_mask);
            CUSTOM_W(BLTALWM, s_text.last_mask);
            CUSTOM_W(BLTCON0, 0x03CA);
            CUSTOM_W(BLTCON1, 0);
            CUSTOM_W(BLTADAT, 0xFFFF);
            CUSTOM_W(BLTBDAT, invert);
            CUSTOM_P(BLTCPT, text_area((u16)plane));
            CUSTOM_P(BLTDPT, text_area((u16)plane));
            CUSTOM_W(BLTSIZE, s_text.size);
        } else if (s_text.rendered) {
            /* Copy from the plane already drawn, inverted if needed. */
            WaitBlit();
            CUSTOM_W(BLTBMOD, 0x28 - s_text.width);
            CUSTOM_W(BLTCMOD, 0x28 - s_text.width);
            CUSTOM_W(BLTDMOD, 0x28 - s_text.width);
            CUSTOM_W(BLTAFWM, s_text.first_mask);
            CUSTOM_W(BLTALWM, s_text.last_mask);
            CUSTOM_W(BLTCON0, (invert ^ s_text.rendered_xor) ? 0x073A : 0x07CA);
            CUSTOM_W(BLTCON1, 0);
            CUSTOM_W(BLTADAT, 0xFFFF);
            CUSTOM_P(BLTCPT, text_area((u16)plane));
            CUSTOM_P(BLTDPT, text_area((u16)plane));
            CUSTOM_P(BLTBPT, text_area(s_text.rendered_plane));
            CUSTOM_W(BLTSIZE, s_text.size);
        } else {
            u8 *dest = text_area((u16)plane);

            s_text.rendered_plane = (u16)plane;
            s_text.rendered = 1;
            s_text.rendered_xor = invert;
            if (col & 1) {
                ++dest;
            }
            draw_glyph_rows((s16)s_text.count, text, dest, 0x28, (u8)invert);
        }
    }
    DisownBlitter();
}

/*
 * PORT H049+$012A: copies the 8x8 tile id (from the five sets: ids 1..$2D in set
 * 0, then $2E.., $74.., $BA.., $100..$127) into the cell (x, row) of the
 * 40x25 grid of the bitmap dest, plane by plane (from 4 down to 0).  The
 * number of the tile in the set is the 8-pixel column in the picture.
 */
void draw_8x8_tile_raw(u16 x, u16 row, u16 id, struct BitMap *dest,
                       struct GfxRecord **sets)
{
    struct GfxRecord *set;
    struct BitMap *src;
    s16 tile = (s16)id;
    u16 src_bpr;
    u16 dst_bpr;
    u16 dst_off;
    int n;
    int plane;
    int r;

    if (tile < 0x2E) {
        n = 0;
        tile = (s16)(tile - 1);
    } else if (tile < 0x74) {
        n = 1;
        tile = (s16)(tile - 0x2E);
    } else if (tile < 0xBA) {
        n = 2;
        tile = (s16)(tile - 0x74);
    } else if (tile < 0x100) {
        n = 3;
        tile = (s16)(tile - 0xBA);
    } else if (tile < 0x128) {
        n = 4;
        tile = (s16)(tile - 0x100);
    } else {
        return;
    }
    set = sets[n];
    if (set == NULL) {
        return;
    }
    src = set->image;
    src_bpr = src->BytesPerRow;
    dst_bpr = dest->BytesPerRow;
    dst_off = (u16)((u16)(dst_bpr * (u16)(row << 3)) + x);
    for (plane = 4; plane >= 0; --plane) {
        const u8 *s = (const u8 *)src->Planes[plane] + (s16)tile;
        u8 *d = (u8 *)dest->Planes[plane] + dst_off;
        u16 so = 0;
        u16 dof = 0;

        for (r = 0; r < 8; ++r) {
            d[dof] = s[so];
            so = (u16)(so + src_bpr);
            dof = (u16)(dof + dst_bpr);
        }
    }
    #if !COK_AMIGA
    host_display_changed();
#endif
}

/*
 * Questions of the manual check (data in the code, H049+$07F0..$09B2):
 * encoded answers and 50 entries of 5 bytes (page, line, word,
 * length, position of the answer).  H009+$007E decodes an
 * answer: character = byte + $46 + length.
 */
static const u8 s_quiz_answers[0xC9] = {
    0x0F, 0xFD, 0x01, 0xF7, 0x08, 0x02, 0xF9, 0x0B, 0x07, 0xFE, 0x0A, 0x00,
    0x09, 0xF9, 0x0B, 0xF9, 0x05, 0xFF, 0x06, 0x0E, 0x06, 0x02, 0xF7, 0x04,
    0xFB, 0xF9, 0x02, 0xFD, 0x09, 0x07, 0x06, 0x0C, 0x0B, 0x05, 0x04, 0xF9,
    0xFB, 0xF6, 0xF7, 0x04, 0x0A, 0x09, 0x01, 0xFB, 0x06, 0x0A, 0xFC, 0x05,
    0x0B, 0x08, 0x0C, 0x07, 0xFF, 0xFA, 0x01, 0xFA, 0x00, 0x05, 0xF6, 0x07,
    0x09, 0x0E, 0x06, 0x05, 0x05, 0x08, 0x01, 0xFE, 0x08, 0x09, 0x08, 0xF6,
    0x07, 0x02, 0x04, 0x07, 0x09, 0xFC, 0xFB, 0x04, 0xFC, 0x07, 0xFA, 0x08,
    0xF6, 0xF4, 0x05, 0xF4, 0x00, 0x02, 0x01, 0x0A, 0xF7, 0x02, 0xFB, 0xFF,
    0xFC, 0x10, 0xFA, 0xF8, 0x05, 0xF9, 0x04, 0x04, 0x07, 0x08, 0xFB, 0x04,
    0x01, 0x00, 0x08, 0xFD, 0x05, 0x05, 0xFA, 0x05, 0x0C, 0xFB, 0x08, 0x07,
    0xF7, 0x03, 0x09, 0x08, 0x07, 0xFF, 0xFC, 0x09, 0x08, 0xFC, 0x06, 0x03,
    0x08, 0x00, 0x0C, 0xFA, 0xFE, 0x07, 0xF9, 0xFC, 0x07, 0x0B, 0x06, 0x06,
    0xF7, 0xFD, 0x08, 0xFD, 0xF9, 0x07, 0xFC, 0x07, 0xF6, 0x0B, 0xFA, 0x07,
    0xFD, 0x00, 0x0A, 0xF9, 0x06, 0xF7, 0x07, 0xF6, 0x0B, 0xFA, 0xF8, 0xFB,
    0xFB, 0x08, 0x07, 0x06, 0xFC, 0x0A, 0xF6, 0x07, 0xF9, 0x0D, 0xFF, 0x0A,
    0xFE, 0x0A, 0xFF, 0x03, 0xFB, 0x02, 0xFE, 0x01, 0xFA, 0x08, 0xF9, 0xF8,
    0xFB, 0x08, 0x09, 0xFE, 0x01, 0x01, 0x0E, 0xFF, 0x06,
};

static const u8 s_quiz_entries[50 * 5] = {
    0x05, 0x01, 0x1A, 0x02, 0x00, 0x09, 0x02, 0x1A, 0x04, 0x02,
    0x07, 0x03, 0x1A, 0x02, 0x06, 0x09, 0x06, 0x1A, 0x02, 0x08,
    0x02, 0x07, 0x1B, 0x03, 0x0A, 0x01, 0x08, 0x1B, 0x02, 0x0D,
    0x07, 0x0C, 0x1C, 0x02, 0x0F, 0x07, 0x0E, 0x1D, 0x03, 0x11,
    0x02, 0x10, 0x1D, 0x04, 0x14, 0x07, 0x13, 0x1E, 0x06, 0x18,
    0x07, 0x14, 0x1E, 0x03, 0x1E, 0x06, 0x18, 0x1F, 0x04, 0x21,
    0x04, 0x1A, 0x1F, 0x05, 0x25, 0x03, 0x1C, 0x1F, 0x04, 0x2A,
    0x02, 0x1D, 0x1F, 0x04, 0x2E, 0x06, 0x1E, 0x20, 0x02, 0x32,
    0x07, 0x21, 0x20, 0x05, 0x34, 0x05, 0x23, 0x20, 0x05, 0x39,
    0x09, 0x24, 0x20, 0x04, 0x3E, 0x04, 0x27, 0x21, 0x05, 0x42,
    0x04, 0x34, 0x23, 0x05, 0x47, 0x01, 0x39, 0x24, 0x03, 0x4C,
    0x02, 0x42, 0x26, 0x05, 0x4F, 0x08, 0x43, 0x26, 0x07, 0x54,
    0x02, 0x4A, 0x28, 0x04, 0x5B, 0x01, 0x01, 0x2C, 0x03, 0x5F,
    0x02, 0x03, 0x2C, 0x03, 0x62, 0x04, 0x05, 0x2C, 0x05, 0x65,
    0x04, 0x09, 0x2C, 0x05, 0x6A, 0x02, 0x0B, 0x2C, 0x04, 0x6F,
    0x06, 0x0E, 0x2D, 0x04, 0x73, 0x02, 0x0F, 0x2D, 0x06, 0x77,
    0x05, 0x11, 0x2D, 0x03, 0x7D, 0x06, 0x13, 0x2D, 0x06, 0x80,
    0x03, 0x14, 0x2D, 0x05, 0x86, 0x08, 0x15, 0x2D, 0x02, 0x8B,
    0x03, 0x17, 0x2D, 0x03, 0x8D, 0x07, 0x19, 0x2D, 0x06, 0x90,
    0x05, 0x1F, 0x2E, 0x05, 0x96, 0x02, 0x20, 0x2E, 0x06, 0x9B,
    0x09, 0x24, 0x2F, 0x05, 0xA1, 0x04, 0x28, 0x2F, 0x04, 0xA6,
    0x08, 0x29, 0x2F, 0x02, 0xAA, 0x04, 0x2B, 0x2F, 0x05, 0xAC,
    0x04, 0x2C, 0x2F, 0x04, 0xB1, 0x08, 0x2F, 0x30, 0x04, 0xB5,
    0x06, 0x32, 0x30, 0x05, 0xB9, 0x02, 0x34, 0x30, 0x03, 0xBE,
    0x04, 0x35, 0x30, 0x05, 0xC1, 0x02, 0x36, 0x30, 0x03, 0xC6,
};

static QuizEntry s_quiz_result;         /* H049+$07E4 */

/*
 * PORT H049+$079E: entry index of the question table (in a fixed
 * area, as the original).
 */
QuizEntry *quiz_entry(u16 index)
{
    const u8 *e = &s_quiz_entries[(u16)(index * 5)];

    s_quiz_result.page = e[0];
    s_quiz_result.line = e[1];
    s_quiz_result.word = e[2];
    s_quiz_result.length = e[3];
    s_quiz_result.answer = &s_quiz_answers[e[4]];
    return &s_quiz_result;
}

/*
 * PORT H049+$04AE (Queue_BitplaneBlit): copies w x h pixels from src (sx, sy)
 * into the destination (dx, dy), one plane at a time (from the highest), with
 * the given minterm.  With mask (one plane with the geometry of src) dest is a
 * RastPort and the blitter uses A = mask, B = source, C/D = destination
 * ($F00); without it, dest is already the BitMap and A is the constant $FFFF ($700).
 * The original queues a bltnode ($4A bytes) with QBSBlit and the blitter is
 * programmed as the beam passes; here there is no node and the blits
 * start at once, plane by plane, in the same order and with the same
 * register values.  It returned the node (unused): here NULL.
 * PORT H049+$06EC (QueuedBlit_Callback): programmed the blitter for one
 * plane of the node at every pass; here it is the loop over the planes above.
 * PORT H049+$0782 (QueuedBlit_Cleanup): freed the node ($4A bytes); here
 * there is no node to free.
 */
void *queue_bitplane_blit(struct BitMap *src, u16 sx, u16 sy, void *dest,
                          u16 dx, u16 dy, u16 w, u16 h, u8 minterm, u8 *mask)
{
    struct BitMap *dst;                 /* node +$16 */
    s16 planes;                         /* +$20 */
    u8 shifted_left = 0;                /* +$22 bit 0 */
    s16 width;                          /* +$24: width in bytes */
    s16 dst_col;                        /* +$34 */
    s32 dst_off;                        /* +$36 */
    s16 dst_bytes;                      /* +$30 */
    s16 dst_shift;                      /* +$32 */
    s16 src_col;                        /* +$26 */
    s32 src_off;                        /* +$28 */
    s16 src_bytes;                      /* +$2C */
    s16 src_shift;                      /* +$2E */
    u16 fwm;                            /* +$3E */
    u16 lwm;                            /* +$40 */
    u16 con0;                           /* +$3A */
    u16 con1;                           /* +$3C */
    u16 size;                           /* +$42 */
    s16 src_mod;                        /* +$44/+$46 */
    s16 dst_mod;                        /* +$48 */

    if (mask != NULL) {
        dst = ((struct RastPort *)dest)->BitMap;
    } else {
        dst = (struct BitMap *)dest;
    }
    planes = dst->Depth;
    dst_col = (s16)(((s16)dx >> 3) & ~1);
    dst_off = (s32)(s16)dst->BytesPerRow * (s16)dy + dst_col;
    dst_bytes = (s16)(((((s16)(dx + w - 1)) >> 3) & ~1) - dst_col + 2);
    width = dst_bytes;
    dst_shift = (s16)(dx & 0x0F);
    src_col = (s16)(((s16)sx >> 3) & ~1);
    src_off = (s32)(s16)src->BytesPerRow * (s16)sy + src_col;
    src_bytes = (s16)(((((s16)(sx + w - 1)) >> 3) & ~1) - src_col + 2);
    if (src_bytes > width) {
        width = src_bytes;
    }
    src_shift = (s16)(sx & 0x0F);
    if (src_shift > dst_shift) {
        shifted_left = 1;
    }
    fwm = (u16)(0xFFFFu >> src_shift);
    lwm = (u16)(0xFFFFu << ((u16)(-(s16)w - (s16)sx) & 0x0F));
    con1 = (u16)(((dst_shift - src_shift) & 0x0F) << 12);
    con0 = (u16)(con1 | minterm | (mask != NULL ? 0x0F00 : 0x0700));
    if (shifted_left) {
        dst_off -= 2;
        if (dst_bytes == width) {
            width = (s16)(width + 2);
        }
    }
    size = (u16)((h << 6) + (width >> 1));
    src_mod = (s16)(src->BytesPerRow - width);
    dst_mod = (s16)(dst->BytesPerRow - width);
    if (src_bytes < width) {
        lwm = 0;                /* with +$22 and +$2E > +$32 always, the other branch */
    }

    OwnBlitter();
    while (--planes >= 0) {
        WaitBlit();
        CUSTOM_W(BLTBMOD, src_mod);
        CUSTOM_W(BLTCMOD, dst_mod);
        CUSTOM_W(BLTAMOD, src_mod);
        CUSTOM_W(BLTDMOD, dst_mod);
        CUSTOM_W(BLTAFWM, fwm);
        CUSTOM_W(BLTALWM, lwm);
        CUSTOM_W(BLTCON0, con0);
        CUSTOM_W(BLTCON1, con1);
        if (mask == NULL) {
            CUSTOM_W(BLTADAT, 0xFFFF);
        } else {
            CUSTOM_P(BLTAPT, mask + src_off);
        }
        CUSTOM_P(BLTBPT, (u8 *)src->Planes[planes] + src_off);
        CUSTOM_P(BLTCPT, (u8 *)dst->Planes[planes] + dst_off);
        CUSTOM_P(BLTDPT, (u8 *)dst->Planes[planes] + dst_off);
        CUSTOM_W(BLTSIZE, size);
    }
    WaitBlit();
    DisownBlitter();
    return NULL;
}

/* H049+$0AAC: table of the bytes with reversed bits, built on first use. */
static u16 s_reverse_pending = 0x4E71;
static u8 s_reverse[0x100];

/*
 * PORT H049+$0A7A: copies rows rows of bytes bytes from src to dst
 * mirroring them (bytes in reverse order, bits reversed); with an odd
 * number of bytes the row has a pad byte.
 */
static void mirror_rows(const u8 *src, u8 *dst, u16 bytes, u16 rows)
{
    u16 pad = (bytes & 1) ? 1 : 0;
    u16 r;
    u16 i;

    for (r = 0; r < rows; ++r) {
        dst += bytes;
        for (i = 0; i < bytes; ++i) {
            *--dst = s_reverse[*src++];
        }
        src += pad;
        dst += bytes + pad;
    }
}

/*
 * PORT H049+$09D6: dst = src mirrored horizontally (mask, if
 * both have it, and the 5 planes from 4 down to 0); width in bytes = +$02
 * and rows = +$00 of dst.
 */
void mirror_gfx_record(struct GfxRecord *src, struct GfxRecord *dst)
{
    u16 v;
    u16 bit;
    u8 rev = 0;
    s16 plane;

    if (s_reverse_pending) {
        s_reverse_pending = 0;
        for (v = 0; v < 0x100; ++v) {
            for (bit = 0; bit < 8; ++bit) {
                if (v & (1u << bit)) {
                    rev = (u8)(rev | (0x80u >> bit));
                } else {
                    rev = (u8)(rev & ~(0x80u >> bit));
                }
            }
            s_reverse[v] = rev;
        }
    }
    if (src == NULL || dst == NULL) {
        return;
    }
    if (src->mask != NULL && dst->mask != NULL) {
        mirror_rows(src->mask->Planes[0], dst->mask->Planes[0], dst->count,
                    dst->rows);
    }
    for (plane = 4; plane >= 0; --plane) {
        mirror_rows(src->image->Planes[plane], dst->image->Planes[plane],
                    dst->count, dst->rows);
    }
#if !COK_AMIGA
    host_display_changed();
#endif
}

/*
 * PORT H049+$0014: like $012A but with the mask of the set (plane 0 of the
 * BitMap +$0C): the pixels outside the mask stay those of dest.  The
 * mask byte uses the row stride of the picture.
 */
void draw_8x8_tile_masked(u16 x, u16 row, u16 id, struct BitMap *dest,
                          struct GfxRecord **sets)
{
    struct GfxRecord *set;
    struct BitMap *src;
    const u8 *mask;
    s16 tile = (s16)id;
    u16 src_bpr;
    u16 dst_bpr;
    u16 dst_off;
    int n;
    int plane;
    int r;

    if (tile < 0x2E) {
        n = 0;
        tile = (s16)(tile - 1);
    } else if (tile < 0x74) {
        n = 1;
        tile = (s16)(tile - 0x2E);
    } else if (tile < 0xBA) {
        n = 2;
        tile = (s16)(tile - 0x74);
    } else if (tile < 0x100) {
        n = 3;
        tile = (s16)(tile - 0xBA);
    } else if (tile < 0x128) {
        n = 4;
        tile = (s16)(tile - 0x100);
    } else {
        return;
    }
    set = sets[n];
    if (set == NULL) {
        return;
    }
    src = set->image;
    src_bpr = src->BytesPerRow;
    mask = (const u8 *)set->mask->Planes[0] + (s16)tile;
    dst_bpr = dest->BytesPerRow;
    dst_off = (u16)((u16)(dst_bpr * (u16)(row << 3)) + x);
    for (plane = 4; plane >= 0; --plane) {
        const u8 *s = (const u8 *)src->Planes[plane] + (s16)tile;
        u8 *d = (u8 *)dest->Planes[plane] + dst_off;
        u16 so = 0;
        u16 dof = 0;

        for (r = 0; r < 8; ++r) {
            u8 m = mask[so];

            d[dof] = (u8)((s[so] & m) | (d[dof] & (u8)~m));
            so = (u16)(so + src_bpr);
            dof = (u16)(dof + dst_bpr);
        }
    }
}
