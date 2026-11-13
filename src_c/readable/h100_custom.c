/* H100: base of the custom chips. */
#include "cok.h"

/* H100+$0000: address of the custom registers; they do not exist on the host. */
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
