/* H023: servizi di inizializzazione condivisi. */
#include "h023_shared.h"
#include "h015_runtime.h"

u32 g_h023_0000;                /* H023+$0000 */

/* PORT H023+$0008 */
void h023_init(void)
{
    g_h023_0000 = 0x0070C4DFUL;
}

/*
 * PORT H023+$0010: generatore congruenziale: seme = (seme * 31415821 + 1)
 * mod 10^8 (moltiplicazione a 32 bit), risultato (seme / 10000) * n / 10000,
 * cioe' 0..n-1.
 */
u32 random_below(u32 n)
{
    u32 next = h015_mulu32(g_h023_0000, 0x01DF5E0DUL) + 1;
    u32 rem;

    (void)h015_divu32(next, 0x05F5E100UL, &rem);
    g_h023_0000 = rem;
    return h015_divu32(h015_mulu32(h015_divu32(g_h023_0000, 0x2710, NULL), n),
                       0x2710, NULL);
}
