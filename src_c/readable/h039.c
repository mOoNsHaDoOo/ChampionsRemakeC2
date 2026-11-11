/* H039: servizi di callback/inizializzazione per il parser IFF. */
#include "h086.h"

/* PORT H039+$0004: link/unlk, nessun effetto. */
void h039_init(void)
{
}

/* PORT H039+$000C (ChunkMoreBytes): byte del chunk non ancora letti. */
s32 iff_chunk_more_bytes(GroupContext *context)
{
    return context->ck_size - context->bytes_so_far;
}
