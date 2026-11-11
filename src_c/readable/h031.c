/* H031: Conversioni dell’ordine dei byte e valori del formato su disco. */
#include "h031.h"

/* PORT H031+$0004: link/unlk, nessun effetto. */
void h031_init(void)
{
}

/*
 * PORT H031+$0012: scambia i due byte della word puntata (dati su disco in
 * little-endian).  La word e' in memoria come nell'originale (big-endian),
 * quindi lo scambio dei due byte e' identico a (w >> 8) + (w << 8).
 */
void h031_swap_word(u8 *word)
{
    u8 hi = word[0];

    word[0] = word[1];
    word[1] = hi;
}

/*
 * PORT H031+$003E: inverte i quattro byte del long (scambia le due word e
 * i byte di ciascuna).  Come per H031+$0012 il long e' in memoria
 * big-endian, quindi l'operazione sui byte e' quella dell'originale.
 */
void h031_swap_long(u8 *value)
{
    u8 t = value[0];

    value[0] = value[3];
    value[3] = t;
    t = value[1];
    value[1] = value[2];
    value[2] = t;
}

/* PORT H031+$008A: byte con segno (da disco) in word. */
s16 h031_signed_byte(u8 b)
{
    if (b < 0x80) {
        return b;
    }
    return (s16)(b - 0x100);
}
