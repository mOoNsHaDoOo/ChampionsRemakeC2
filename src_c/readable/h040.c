/*
 * H040: ILBM picture reader on top of the IFF parser (Electronic Arts'
 * readpict.c).
 *
 * Module data (in the code):
 *   $000 $200-byte buffer for reading the BODY
 *   $200 frame of the caller, filled at the end
 *   $204 destination BitMap
 *   $208 plane allocator
 */
#include "h040.h"
#include "h015_runtime.h"
#include "h037.h"

static u8 s_body_buffer[0x200];         /* H040+$0000 */
static ILBMFrame *s_frame;              /* H040+$0200 */
static struct BitMap *s_bitmap;         /* H040+$0204 */
static IlbmAllocFn s_alloc;             /* H040+$0208 */

/* PORT H040+$0210: link/unlk, no effect. */
void h040_init(void)
{
}

/*
 * PORT H040+$0218 (GetFoILBM): FORM callback.  A non-ILBM FORM is
 * traversed (nested groups).  In an ILBM FORM: BMHD and CMAP go into
 * a local copy of the frame; at the BODY the bitmap has at most 5 planes,
 * all in a single block from the allocator, and the caller's frame
 * receives the local copy.  As in the original, a BODY without BMHD and
 * errors exit without CloseRGroup.
 */
static s32 get_form_ilbm(GroupContext *parent)
{
    GroupContext form_context;                  /* -$28 */
    ILBMFrame ilbm_frame;                       /* -$8E */
    s32 iffp;
    u8 n_planes;                                /* -$95 */
    u32 plane_size;                             /* -$94 */
    s16 i;

    if (parent->subtype != ID_ILBM) {
        iffp = iff_open_rgroup(parent, &form_context);
        if (iffp != IFF_OKAY) {
            return iffp;
        }
        do {
            iffp = iff_get_f1chunk_hdr(&form_context);
        } while (iffp >= IFF_OKAY);
        if (iffp == END_MARK) {
            iffp = IFF_OKAY;
        }
        (void)iff_close_rgroup(&form_context);
        return iffp;
    }

    ilbm_frame = *(ILBMFrame *)parent->client_frame;
    iffp = iff_open_rgroup(parent, &form_context);
    if (iffp != IFF_OKAY) {
        return iffp;
    }
    do {
        iffp = iff_get_fchunk_hdr(&form_context);
        if (iffp == ID_BMHD) {
            ilbm_frame.found_bmhd = 1;
            iffp = ilbm_get_bmhd(&form_context, &ilbm_frame.bm_hdr);
        } else if (iffp == ID_CMAP) {
            ilbm_frame.n_color_regs = 32;
            iffp = ilbm_get_cmap(&form_context, ilbm_frame.color_map,
                                 &ilbm_frame.n_color_regs);
        } else if (iffp == ID_BODY) {
            if (!ilbm_frame.found_bmhd) {
                return BAD_FORM;
            }
            n_planes = ilbm_frame.bm_hdr.n_planes < 5 ?
                       ilbm_frame.bm_hdr.n_planes : 5;
            graphics_init_bitmap(s_bitmap, n_planes, ilbm_frame.bm_hdr.w,
                                 ilbm_frame.bm_hdr.h);
            plane_size = (u32)ilbm_row_bytes(ilbm_frame.bm_hdr.w) *
                         ilbm_frame.bm_hdr.h;
            s_bitmap->Planes[0] =
                (PLANEPTR)s_alloc(h015_mulu32(n_planes, plane_size));
            if (s_bitmap->Planes[0] != NULL) {
                for (i = 1; i < (s16)n_planes; ++i) {
                    s_bitmap->Planes[i] = s_bitmap->Planes[0] +
                                          h015_mulu32((u32)i, plane_size);
                }
                iffp = ilbm_get_body(&form_context, s_bitmap, NULL,
                                     &ilbm_frame.bm_hdr, s_body_buffer,
                                     sizeof(s_body_buffer));
                if (iffp == IFF_OKAY) {
                    iffp = IFF_DONE;
                }
                *s_frame = ilbm_frame;
            } else {
                iffp = CLIENT_ERROR;
            }
        } else if (iffp == END_MARK) {
            iffp = BAD_FORM;
        }
    } while (iffp >= IFF_OKAY);

    if (iffp != IFF_DONE) {
        return iffp;
    }
    (void)iff_close_rgroup(&form_context);
    return iffp;
}

/*
 * PORT H040+$04B6 (GetPrILBM): callback of the ILBM PROPs: BMHD and CMAP go
 * straight into the frame of the group (inherited by the FORMs of the LIST).
 */
static s32 get_prop_ilbm(GroupContext *parent)
{
    ILBMFrame *ilbm_frame = (ILBMFrame *)parent->client_frame;
    GroupContext prop_context;
    s32 iffp;

    if (parent->subtype != ID_ILBM) {
        return IFF_OKAY;
    }
    iffp = iff_open_rgroup(parent, &prop_context);
    if (iffp != IFF_OKAY) {
        return iffp;
    }
    do {
        iffp = iff_get_pchunk_hdr(&prop_context);
        if (iffp == ID_BMHD) {
            ilbm_frame->found_bmhd = 1;
            iffp = ilbm_get_bmhd(&prop_context, &ilbm_frame->bm_hdr);
        } else if (iffp == ID_CMAP) {
            ilbm_frame->n_color_regs = 32;
            iffp = ilbm_get_cmap(&prop_context, ilbm_frame->color_map,
                                 &ilbm_frame->n_color_regs);
        }
    } while (iffp >= IFF_OKAY);
    (void)iff_close_rgroup(&prop_context);
    return iffp == END_MARK ? IFF_OKAY : iffp;
}

/* PORT H040+$05AA (GetLiILBM): a LIST works on a copy of the frame. */
static s32 get_list_ilbm(GroupContext *parent)
{
    ILBMFrame new_frame = *(ILBMFrame *)parent->client_frame;

    return iff_read_ilist(parent, &new_frame.client_frame);
}

/*
 * PORT H040+$05E4 (Read_ILBM): reads an ILBM file into the bitmap (planes
 * from the allocator) and into the frame (BMHD, colours).  Returns IFF_DONE
 * if the picture was read, otherwise an error IFFP.
 */
s32 read_ilbm(cok_bptr file, struct BitMap *bitmap, ILBMFrame *frame,
              IlbmAllocFn alloc)
{
    frame->client_frame.get_list = get_list_ilbm;
    frame->client_frame.get_prop = get_prop_ilbm;
    frame->client_frame.get_form = get_form_ilbm;
    frame->client_frame.get_cat = iff_read_icat;
    frame->found_bmhd = 0;
    frame->n_color_regs = 0;
    s_alloc = alloc;
    s_bitmap = bitmap;
    s_frame = frame;
    return iff_read_iff(file, &frame->client_frame);
}
