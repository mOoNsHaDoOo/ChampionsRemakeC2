/* H036: Adattatore dos.library/Delay. */
#include "h036.h"

/*
 * PORT H036+$0008: copies DOSBase of the H015 runtime into the module cell.
 * In C the library base is already global: nothing to do.
 */
void h036_init(void)
{
}

/* PORT H036+$0034 */
void dos_delay(u32 ticks)
{
    Delay((LONG)ticks);
}
