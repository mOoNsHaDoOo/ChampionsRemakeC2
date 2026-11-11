/* H074: funzioni per percorsi e nomi di file. */
#include "cok.h"

u32 g_h074_0000;                /* H074+$0000 */

/* PORT H074+$0008 */
void h074_init(void)
{
    g_h074_0000 = 0x400;
}
