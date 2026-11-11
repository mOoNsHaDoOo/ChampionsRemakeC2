/* H099: Helper per dimensioni/buffer di decompressione. */
#include "h087.h"

/* PORT H099+$010E: link/unlk, nessun effetto. */
void h099_init(void)
{
}

/* PORT H099+$01B0 (MaxPackedSize): caso peggiore di ByteRun1 per una riga. */
u16 ilbm_max_packed_size(u16 row_size)
{
    return (u16)(row_size + ((u16)(row_size + 0x7F) >> 7));
}
