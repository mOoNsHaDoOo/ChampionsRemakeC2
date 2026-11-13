/*
 * H086: generic IFF parser (Electronic Arts' "IFF85" iff.c, 1985).
 *
 * Difference from the original: chunk headers and subtypes are read
 * into a byte buffer and converted from big-endian (COK_GET32), instead of
 * being read straight into the LONG fields; on the Amiga the result is the
 * same, on the host (little-endian) it is the correct one.
 */
#include "h086.h"
#include "h098.h"

/* PORT H086+$0004: link/unlk, no effect. */
void h086_init(void)
{
}

/*
 * PORT H086+$000C (FileLength): goes to the end of the file; the second GSeek
 * (offset 0 from OFFSET_CURRENT) returns that position, that is the
 * length.  The file stays at the end: OpenRIFF rewinds it.
 */
s32 iff_file_length(cok_bptr file)
{
    s32 length = NO_FILE;

    /* tst.l / bls: with file 0 it stays NO_FILE (unsigned comparison). */
    if (file != 0) {
        (void)gio_seek(file, 0, OFFSET_END);
        length = gio_seek(file, 0, OFFSET_CURRENT);
        if (length < 0) {
            length = DOS_ERROR;
        }
    }
    return length;
}

/* PORT H086+$0068 (SkipFwd) */
s32 iff_skip_fwd(GroupContext *context, s32 bytes)
{
    s32 iffp = IFF_OKAY;

    if (bytes > 0) {
        if (gio_seek(context->file, bytes, OFFSET_CURRENT) == -1) {
            iffp = BAD_IFF;
        } else {
            context->position += bytes;
        }
    }
    return iffp;
}

/* PORT H086+$00C0 (OpenRIFF): context of the whole file. */
s32 iff_open_riff(cok_bptr file, GroupContext *new_ctx,
                  ClientFrame *client_frame)
{
    s32 iffp = IFF_OKAY;

    new_ctx->parent = NULL;
    new_ctx->client_frame = client_frame;
    new_ctx->file = file;
    new_ctx->position = 0;
    new_ctx->subtype = 0;
    new_ctx->bytes_so_far = 0;
    new_ctx->ck_id = 0;
    new_ctx->ck_size = 0;
    new_ctx->bound = iff_file_length(file);
    if (new_ctx->bound < 0) {
        iffp = new_ctx->bound;
    } else if (new_ctx->bound < 8) {
        iffp = NOT_IFF;
    } else {
        (void)gio_seek(file, 0, OFFSET_BEGINNING);
    }
    return iffp;
}

/* PORT H086+$015C (OpenRGroup): context of the group in the current chunk. */
s32 iff_open_rgroup(GroupContext *parent, GroupContext *new_ctx)
{
    s32 iffp = IFF_OKAY;

    new_ctx->parent = parent;
    new_ctx->client_frame = parent->client_frame;
    new_ctx->file = parent->file;
    new_ctx->position = parent->position;
    new_ctx->bound = iff_chunk_more_bytes(parent) + parent->position;
    new_ctx->subtype = 0;
    new_ctx->bytes_so_far = 0;
    new_ctx->ck_id = 0;
    new_ctx->ck_size = 0;
    if (new_ctx->bound > parent->bound || (new_ctx->bound & 1) != 0) {
        iffp = BAD_IFF;
    }
    return iffp;
}

/* PORT H086+$01F8 (CloseRGroup): moves the position back in the parent. */
s32 iff_close_rgroup(GroupContext *context)
{
    s32 position;

    if (context->parent != NULL) {
        position = context->position;
        context->parent->bytes_so_far += position - context->parent->position;
        context->parent->position = position;
    }
    return IFF_OKAY;
}

/*
 * PORT H086+$022E (GetChunkHdr): skips the rest of the current chunk (with the
 * pad byte) and reads the header of the next one.  Returns
 * the chunk ID or a negative IFFP, which is also left in ck_id.
 */
s32 iff_get_chunk_hdr(GroupContext *context)
{
    s32 remaining;
    s32 result;
    u8 header[8];
    u8 subtype[4];

    result = iff_skip_fwd(context, iff_chunk_more_bytes(context) +
                                   (context->ck_size & 1));
    if (result != 0) {
        return result;
    }
    context->ck_id = BAD_IFF;
    context->subtype = 0;
    context->bytes_so_far = 0;
    remaining = context->bound - context->position;
    if (remaining == 0) {
        context->ck_size = 0;
        context->ck_id = END_MARK;
    } else if (remaining < 8) {
        context->ck_size = remaining;
    } else {
        result = gio_read(context->file, header, 8);
        if (result == -1) {
            context->ck_id = DOS_ERROR;
            return DOS_ERROR;
        }
        if (result == 0) {
            context->ck_id = BAD_IFF;
            return BAD_IFF;
        }
        context->ck_id = (s32)COK_GET32(header);
        context->ck_size = (s32)COK_GET32(header + 4);
        if (context->parent == NULL && context->ck_id != ID_FORM &&
            context->ck_id != ID_LIST && context->ck_id != ID_CAT) {
            context->ck_id = NOT_IFF;
            return NOT_IFF;
        }
        context->position += 8;
        remaining -= 8;
        if (context->ck_id <= 0) {
            context->ck_id = BAD_IFF;
        } else if (context->ck_size < 0 || context->ck_size > remaining) {
            context->ck_size = remaining;
            context->ck_id = BAD_IFF;
        } else if (context->ck_id == ID_LIST || context->ck_id == ID_FORM ||
                   context->ck_id == ID_PROP || context->ck_id == ID_CAT) {
            result = iff_read_bytes(context, subtype, 4);
            if (result != 0) {
                context->ck_id = result;
            } else {
                context->subtype = (s32)COK_GET32(subtype);
            }
        }
    }
    return context->ck_id;
}

/*
 * PORT H086+$03F2 (IFFReadBytes): reads from the current chunk without
 * going past its end.
 */
s32 iff_read_bytes(GroupContext *context, void *buffer, s32 n_bytes)
{
    s32 iffp = IFF_OKAY;
    s32 read;

    if (n_bytes < 0) {
        iffp = CLIENT_ERROR;
    } else if (n_bytes > iff_chunk_more_bytes(context)) {
        iffp = SHORT_CHUNK;
    } else if (n_bytes > 0) {
        read = gio_read(context->file, buffer, n_bytes);
        if (read == -1) {
            iffp = DOS_ERROR;
        } else if (read == 0) {
            iffp = BAD_IFF;
        } else {
            context->position += n_bytes;
            context->bytes_so_far += n_bytes;
        }
    }
    return iffp;
}

/* Call of the client callback for the group read. */
static s32 call_group(GroupContext *context, ClientFrame *frame, s32 id)
{
    if (id == ID_FORM) {
        return frame->get_form(context);
    }
    if (id == ID_LIST) {
        return frame->get_list(context);
    }
    if (id == ID_CAT) {
        return frame->get_cat(context);
    }
    return id;
}

/*
 * PORT H086+$04BA (ReadIFF): reads the file as a single FORM, LIST
 * or CAT group calling the matching callback.  A positive result (an ID
 * not handled) becomes NOT_IFF.
 */
s32 iff_read_iff(cok_bptr file, ClientFrame *client_frame)
{
    GroupContext context;
    s32 iffp;

    iffp = iff_open_riff(file, &context, client_frame);
    if (iffp == 0) {
        iffp = iff_get_chunk_hdr(&context);
        iffp = call_group(&context, client_frame, iffp);
    }
    (void)iff_close_rgroup(&context);
    if (iffp > 0) {
        iffp = NOT_IFF;
    }
    return iffp;
}

/*
 * PORT H086+$0578 (ReadIList): reads a LIST (or a CAT with client_frame
 * NULL): PROPs are allowed only at the start of a LIST.
 */
s32 iff_read_ilist(GroupContext *parent, ClientFrame *client_frame)
{
    GroupContext list_context;
    s32 iffp;
    u8 prop_ok = 1;

    iffp = iff_open_rgroup(parent, &list_context);
    if (iffp != 0) {
        return iffp;
    }
    if (parent->ck_id == ID_CAT) {
        prop_ok = 0;
    } else {
        list_context.client_frame = client_frame;
    }
    do {
        iffp = iff_get_chunk_hdr(&list_context);
        if (iffp == ID_PROP) {
            if (prop_ok) {
                iffp = client_frame->get_prop(&list_context);
            } else {
                iffp = BAD_IFF;
            }
        } else {
            iffp = call_group(&list_context, client_frame, iffp);
        }
        if (list_context.ck_id != ID_PROP) {
            prop_ok = 0;
        }
    } while (iffp == IFF_OKAY);
    (void)iff_close_rgroup(&list_context);
    if (iffp > 0) {
        iffp = BAD_IFF;
    }
    if (iffp == END_MARK) {
        iffp = IFF_OKAY;
    }
    return iffp;
}

/* PORT H086+$06BC (ReadICat) */
s32 iff_read_icat(GroupContext *parent)
{
    return iff_read_ilist(parent, NULL);
}

/* PORT H086+$06D6 (GetFChunkHdr): inside a FORM a PROP is an error. */
s32 iff_get_fchunk_hdr(GroupContext *context)
{
    s32 id = iff_get_chunk_hdr(context);

    if (id == ID_PROP) {
        id = BAD_IFF;
        context->ck_id = id;
    }
    return id;
}

/*
 * PORT H086+$0714 (GetF1ChunkHdr): like GetFChunkHdr, but reads the
 * nested groups at once with the client callbacks.
 */
s32 iff_get_f1chunk_hdr(GroupContext *context)
{
    ClientFrame *frame = context->client_frame;
    s32 iffp = iff_get_chunk_hdr(context);

    if (iffp == ID_PROP) {
        iffp = BAD_IFF;
    } else {
        iffp = call_group(context, frame, iffp);
    }
    context->ck_id = iffp;
    return iffp;
}

/* PORT H086+$07C0 (GetPChunkHdr): inside a PROP groups are errors. */
s32 iff_get_pchunk_hdr(GroupContext *context)
{
    s32 id = iff_get_chunk_hdr(context);

    if (id == ID_LIST || id == ID_FORM || id == ID_PROP || id == ID_CAT) {
        id = BAD_IFF;
        context->ck_id = id;
    }
    return id;
}
