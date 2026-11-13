/* H087: Reading of BMHD, palette and BODY of ILBM pictures. */
#include "h087.h"
#include "h003_exec.h"
#include "h015_runtime.h"

/* PORT H087+$0004: link/unlk, no effect. */
void h087_init(void)
{
}

/*
 * PORT H087+$000C (GetBMHD): 20 bytes of the BMHD chunk.  The original reads
 * them straight into the structure; here into a buffer, converted from big-endian.
 */
s32 ilbm_get_bmhd(GroupContext *context, BitMapHeader *bm_hdr)
{
    u8 raw[20];
    s32 iffp = iff_read_bytes(context, raw, 20);

    if (iffp == IFF_OKAY) {
        bm_hdr->w = COK_GET16(raw);
        bm_hdr->h = COK_GET16(raw + 2);
        bm_hdr->x = (s16)COK_GET16(raw + 4);
        bm_hdr->y = (s16)COK_GET16(raw + 6);
        bm_hdr->n_planes = raw[8];
        bm_hdr->masking = raw[9];
        bm_hdr->compression = raw[0x0A];
        bm_hdr->pad1 = raw[0x0B];
        bm_hdr->transparent_color = COK_GET16(raw + 0x0C);
        bm_hdr->x_aspect = raw[0x0E];
        bm_hdr->y_aspect = raw[0x0F];
        bm_hdr->page_width = (s16)COK_GET16(raw + 0x10);
        bm_hdr->page_height = (s16)COK_GET16(raw + 0x12);
    }
    return iffp;
}

/*
 * PORT H087+$009C (GetCMAP): at most *n_color_regs colours (8-bit RGB
 * triples reduced to RGB4); *n_color_regs becomes the number read.
 */
s32 ilbm_get_cmap(GroupContext *context, u16 *color_map, u8 *n_color_regs)
{
    u8 n = (u8)h015_divs32(context->ck_size, 3, NULL);
    u8 rgb[3];
    s32 iffp;

    if (*n_color_regs < n) {
        n = *n_color_regs;
    }
    *n_color_regs = n;
    while (n > 0) {
        iffp = iff_read_bytes(context, rgb, 3);
        if (iffp != IFF_OKAY) {
            return iffp;
        }
        *color_map++ = (u16)(((rgb[0] >> 4) << 8) + ((rgb[1] >> 4) << 4) +
                             (rgb[2] >> 4));
        --n;
    }
    return IFF_OKAY;
}

/*
 * PORT H087+$0166 (GetBODY): reads the BODY row by row into the planes of
 * the bitmap (extra planes of the file and a mask without a destination go
 * into the first block of the buffer, which acts as a bin).  buffer/buf_size
 * are the read buffer of the chunk; at least two compressed rows are needed.
 */
s32 ilbm_get_body(GroupContext *context, struct BitMap *bitmap, u8 *mask,
                  BitMapHeader *bm_hdr, u8 *buffer, s32 buf_size)
{
    u16 src_plane_cnt = bm_hdr->n_planes;           /* -$6 */
    u16 src_row_bytes = ilbm_row_bytes(bm_hdr->w);  /* -$8 */
    s32 buf_row_bytes = (s32)ilbm_max_packed_size(src_row_bytes); /* -$C */
    u16 n_rows = bm_hdr->h;                         /* -$E */
    u8 compression = bm_hdr->compression;           /* -$F */
    u8 *planes[MAX_SRC_PLANES];                     /* -$6C */
    u8 *null_dest;                                  /* -$20 */
    u8 *null_buf;                                   /* -$24 */
    u8 **p_dest;                                    /* -$28 */
    u8 *buf;                                        /* -$1C */
    u16 n_empty;                                    /* -$16 */
    u16 n_filled;                                   /* -$18 */
    u16 i_plane;                                    /* -$12 */
    s32 iffp;

    if (compression > CMP_BYTE_RUN1) {
        return CLIENT_ERROR;
    }
    if (src_row_bytes != bitmap->BytesPerRow ||
        buf_size < buf_row_bytes * 2 || src_plane_cnt > MAX_SRC_PLANES) {
        return CLIENT_ERROR;
    }
    if (n_rows > bitmap->Rows) {
        n_rows = bitmap->Rows;
    }
    for (i_plane = 0; i_plane < bitmap->Depth; ++i_plane) {
        planes[i_plane] = (u8 *)bitmap->Planes[i_plane];
    }
    for (; i_plane < MAX_SRC_PLANES; ++i_plane) {
        planes[i_plane] = NULL;
    }
    if (bm_hdr->masking == MSK_HAS_MASK) {
        planes[src_plane_cnt] = mask;   /* NULL if not requested */
        ++src_plane_cnt;
    }

    null_dest = buffer;
    buffer += src_row_bytes;
    buf_size -= src_row_bytes;
    buf = buffer + buf_size;

    for (; n_rows != 0; --n_rows) {
        for (i_plane = 0; i_plane < src_plane_cnt; ++i_plane) {
            p_dest = &planes[i_plane];
            if (*p_dest == NULL) {
                null_buf = null_dest;
                p_dest = &null_buf;
            }
            n_empty = (u16)(buf - buffer);
            n_filled = (u16)(buf_size - n_empty);
            if ((s32)n_filled < buf_row_bytes) {
                /* Moves the remaining data to the start and fills the rest. */
                exec_copy_mem(buf, buffer, n_filled);
                if ((s32)n_empty > iff_chunk_more_bytes(context)) {
                    n_empty = (u16)iff_chunk_more_bytes(context);
                    buf_size = (s32)(u16)(n_filled + n_empty);
                }
                iffp = iff_read_bytes(context, buffer + n_filled, n_empty);
                if (iffp != IFF_OKAY) {
                    return iffp;
                }
                buf = buffer;
                n_filled = (u16)buf_size;
                n_empty = 0;
            }
            if (compression == 0) {
                if (n_filled < src_row_bytes) {
                    return BAD_FORM;
                }
                exec_copy_mem(buf, *p_dest, src_row_bytes);
                buf += src_row_bytes;
                *p_dest += src_row_bytes;
            } else if (ilbm_unpack_row(&buf, p_dest, (s16)n_filled,
                                       (s16)src_row_bytes)) {
                return BAD_FORM;
            }
        }
    }
    return IFF_OKAY;
}
