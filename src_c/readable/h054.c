/* H054: Computation of the raster space per row. */
#include "h087.h"

/* PORT H054+$0004: link/unlk, no effect. */
void h054_init(void)
{
}

/* PORT H054+$000C (RowBytes): bytes per row, in whole words. */
u16 ilbm_row_bytes(u16 width)
{
    return (u16)(((u16)(width + 0x0F) >> 4) << 1);
}
