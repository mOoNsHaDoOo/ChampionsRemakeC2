/* H031: Byte order conversions and on-disk format values. */
#include "h031.h"

/* PORT H031+$0004: link/unlk, no effect. */
void h031_init(void)
{
}

/*
 * PORT H031+$0012: swaps the two bytes of the word pointed to (disk data in
 * little-endian).  The word is in memory as in the original (big-endian),
 * so swapping the two bytes is the same as (w >> 8) + (w << 8).
 */
void h031_swap_word(u8 *word)
{
    u8 hi = word[0];

    word[0] = word[1];
    word[1] = hi;
}

/*
 * PORT H031+$003E: reverses the four bytes of the long (swaps the two words
 * and the bytes of each).  As for H031+$0012 the long is big-endian in
 * memory, so the byte operation is the one of the original.
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

/* PORT H031+$008A: signed byte (from disk) to word. */
s16 h031_signed_byte(u8 b)
{
    if (b < 0x80) {
        return b;
    }
    return (s16)(b - 0x100);
}
