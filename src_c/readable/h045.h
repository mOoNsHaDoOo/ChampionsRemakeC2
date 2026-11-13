/* H045: shared arithmetic and support helpers. */
#ifndef COK_H045_H
#define COK_H045_H

#include "cok.h"

void format_number(u16 max_len, char *out, s32 value, u8 is_signed,
                   u16 base, u16 width, u8 pad);        /* H045+$01D6 */

u8   parse_number(u16 len, const char *s, s32 *out, u8 is_signed,
                  u16 base);                            /* H045+$000C */

#endif
