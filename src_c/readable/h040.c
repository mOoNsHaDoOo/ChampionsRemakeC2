/*
 * H040: lettore di immagini ILBM sopra il parser IFF (readpict.c di
 * Electronic Arts).
 *
 * Dati del modulo (nel codice):
 *   $000 buffer di $200 byte per la lettura del BODY
 *   $200 frame del chiamante, riempito al termine
 *   $204 BitMap di destinazione
 *   $208 allocatore dei piani
 */
#include "h040.h"
#include "h015_runtime.h"
#include "h037.h"

static u8 s_body_buffer[0x200];         /* H040+$0000 */
static ILBMFrame *s_frame;              /* H040+$0200 */
static struct BitMap *s_bitmap;         /* H040+$0204 */
static IlbmAllocFn s_alloc;             /* H040+$0208 */

/* PORT H040+$0210: link/unlk, nessun effetto. */
void h040_init(void)
{
}

/*
 * PORT H040+$0218 (GetFoILBM): callback dei FORM.  Un FORM non ILBM viene
 * attraversato (gruppi annidati).  In un FORM ILBM: BMHD e CMAP vanno in
 * una copia locale del frame; al BODY la bitmap ha al massimo 5 piani,
 * tutti in un unico blocco dall'allocatore, e il frame del chiamante
 * riceve la copia locale.  Come nell'originale, BODY senza BMHD e gli
 * errori escono senza CloseRGroup.
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
 * PORT H040+$04B6 (GetPrILBM): callback dei PROP ILBM: BMHD e CMAP vanno
 * direttamente nel frame del gruppo (ereditati dai FORM del LIST).
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

/* PORT H040+$05AA (GetLiILBM): un LIST lavora su una copia del frame. */
static s32 get_list_ilbm(GroupContext *parent)
{
    ILBMFrame new_frame = *(ILBMFrame *)parent->client_frame;

    return iff_read_ilist(parent, &new_frame.client_frame);
}

/*
 * PORT H040+$05E4 (Read_ILBM): legge un file ILBM nella bitmap (piani
 * dall'allocatore) e nel frame (BMHD, colori).  Restituisce IFF_DONE se
 * l'immagine e' stata letta, altrimenti un IFFP di errore.
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
