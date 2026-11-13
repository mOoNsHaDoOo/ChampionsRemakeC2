/* H039: callback/initialisation services for the IFF parser. */
#include "h086.h"

/* PORT H039+$0004: link/unlk, no effect. */
void h039_init(void)
{
}

/* PORT H039+$000C (ChunkMoreBytes): chunk bytes not read yet. */
s32 iff_chunk_more_bytes(GroupContext *context)
{
    return context->ck_size - context->bytes_so_far;
}
