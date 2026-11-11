/* H054: Calcolo dello spazio raster per riga. */
#include "h087.h"

/* PORT H054+$0004: link/unlk, nessun effetto. */
void h054_init(void)
{
}

/* PORT H054+$000C (RowBytes): byte per riga, a word intere. */
u16 ilbm_row_bytes(u16 width)
{
    return (u16)(((u16)(width + 0x0F) >> 4) << 1);
}
