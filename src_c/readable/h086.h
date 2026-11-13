/*
 * H086: generic IFF parser (Electronic Arts' "IFF85" iff.c, 1985):
 * FORM/LIST/PROP/CAT groups, chunk headers, reading of bytes.
 */
#ifndef COK_H086_H
#define COK_H086_H

#include "h002_dos.h"

/* IFFP values returned by the routines (negative = end or error). */
#define IFF_OKAY      0
#define END_MARK     (-1)       /* end of the group */
#define IFF_DONE     (-2)       /* the client is done */
#define DOS_ERROR    (-3)
#define NOT_IFF      (-4)
#define NO_FILE      (-5)
#define CLIENT_ERROR (-6)
#define BAD_FORM     (-7)
#define SHORT_CHUNK  (-8)
#define BAD_IFF      (-9)

#define COK_MAKE_ID(a, b, c, d) \
    ((s32)((u32)(a) << 24 | (u32)(b) << 16 | (u32)(c) << 8 | (u32)(d)))
#define ID_FORM COK_MAKE_ID('F', 'O', 'R', 'M')
#define ID_LIST COK_MAKE_ID('L', 'I', 'S', 'T')
#define ID_PROP COK_MAKE_ID('P', 'R', 'O', 'P')
#define ID_CAT  COK_MAKE_ID('C', 'A', 'T', ' ')

struct GroupContext;
typedef s32 (*IffGroupFn)(struct GroupContext *parent);

/* ClientFrame: callbacks for the groups (16 bytes in the original). */
typedef struct ClientFrame {
    IffGroupFn get_list;        /* +$00 */
    IffGroupFn get_prop;        /* +$04 */
    IffGroupFn get_form;        /* +$08 */
    IffGroupFn get_cat;         /* +$0C */
} ClientFrame;

/*
 * GroupContext ($24 bytes in the original).  ck_id, ck_size and subtype are
 * read big-endian from the file and kept here as numeric values.
 */
typedef struct GroupContext {
    struct GroupContext *parent; /* +$00: NULL at file level */
    ClientFrame *client_frame;  /* +$04 */
    cok_bptr file;              /* +$08 */
    s32 position;               /* +$0C: position in the file */
    s32 bound;                  /* +$10: end of the group */
    s32 ck_id;                  /* +$14: chunk corrente (o IFFP) */
    s32 ck_size;                /* +$18 */
    s32 subtype;                /* +$1C: subtype of FORM/LIST/PROP/CAT */
    s32 bytes_so_far;           /* +$20: chunk bytes already read */
} GroupContext;

s32 iff_file_length(cok_bptr file);                          /* H086+$000C */
s32 iff_skip_fwd(GroupContext *context, s32 bytes);          /* H086+$0068 */
s32 iff_open_riff(cok_bptr file, GroupContext *new_ctx,
                  ClientFrame *client_frame);                 /* H086+$00C0 */
s32 iff_open_rgroup(GroupContext *parent, GroupContext *new_ctx);
                                                              /* H086+$015C */
s32 iff_close_rgroup(GroupContext *context);                 /* H086+$01F8 */
s32 iff_get_chunk_hdr(GroupContext *context);                /* H086+$022E */
s32 iff_read_bytes(GroupContext *context, void *buffer, s32 n_bytes);
                                                              /* H086+$03F2 */
s32 iff_read_iff(cok_bptr file, ClientFrame *client_frame);  /* H086+$04BA */
s32 iff_read_ilist(GroupContext *parent, ClientFrame *client_frame);
                                                              /* H086+$0578 */
s32 iff_read_icat(GroupContext *parent);                     /* H086+$06BC */
s32 iff_get_fchunk_hdr(GroupContext *context);               /* H086+$06D6 */
s32 iff_get_f1chunk_hdr(GroupContext *context);              /* H086+$0714 */
s32 iff_get_pchunk_hdr(GroupContext *context);               /* H086+$07C0 */

s32 iff_chunk_more_bytes(GroupContext *context);             /* H039+$000C */

#endif
