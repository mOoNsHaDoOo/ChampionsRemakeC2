/* H052: inizializzazione di uno slot di stato. */
#include "cok.h"

/* H052+$0000: struttura di $1C byte (tipo non ancora identificato), BE. */
u8 g_h052_0000[0x1C];

/* PORT H052+$0024 */
void h052_init(void)
{
    COK_PUT16(&g_h052_0000[0x0E], 2);
    COK_PUT16(&g_h052_0000[0x10], 0x0001);
    COK_PUT16(&g_h052_0000[0x12], 0x0001);   /* long $00010001 */
    COK_PUT16(&g_h052_0000[0x14], 0x0000);
    COK_PUT16(&g_h052_0000[0x16], 0x005C);   /* long $0000005C */
    COK_PUT16(&g_h052_0000[0x18], 0x0001);
    COK_PUT16(&g_h052_0000[0x1A], 0x0000);   /* long $00010000 */
}
