/* H100: base dei chip custom. */
#include "cok.h"

/* H100+$0000: indirizzo dei registri custom; sull'host non esistono. */
volatile u8 *g_custom;

/* PORT H100+$0008 */
void h100_init(void)
{
#if COK_AMIGA
    g_custom = (volatile u8 *)0xDFF000UL;
#else
    g_custom = NULL;
#endif
}
