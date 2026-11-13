/* H037: Adattatore graphics.library/InitBitMap. */
#include "h037.h"

/*
 * PORT H037+$0008: copies GfxBase of the H015 runtime into the module cell.
 * In C the library base is already global: nothing to do.
 */
void h037_init(void)
{
}

#if COK_AMIGA
#include <proto/graphics.h>
#endif

/* PORT H037+$0014 */
void graphics_init_bitmap(struct BitMap *bm, u16 depth, u16 width, u16 height)
{
    InitBitMap(bm, (LONG)depth, (LONG)width, (LONG)height);
}
