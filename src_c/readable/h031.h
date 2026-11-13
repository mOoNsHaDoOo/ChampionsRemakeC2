/* H031: byte order conversions and on-disk format values. */
#ifndef COK_H031_H
#define COK_H031_H

#include "cok.h"

void h031_swap_word(u8 *word);          /* H031+$0012 */
void h031_swap_long(u8 *value);         /* H031+$003E */
s16  h031_signed_byte(u8 b);            /* H031+$008A */

#endif
