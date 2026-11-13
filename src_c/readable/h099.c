/* H099: Helpers for decompression sizes/buffers. */
#include "h087.h"

/* PORT H099+$010E: link/unlk, no effect. */
void h099_init(void)
{
}

/* PORT H099+$01B0 (MaxPackedSize): worst case of ByteRun1 for one row. */
u16 ilbm_max_packed_size(u16 row_size)
{
    return (u16)(row_size + ((u16)(row_size + 0x7F) >> 7));
}
