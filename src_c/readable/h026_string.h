/* H026: funzioni su stringhe e buffer con limiti passati dai chiamanti. */
#ifndef COK_H026_STRING_H
#define COK_H026_STRING_H

#include "cok.h"

u16  h026_strlen(u16 len, const char *s);                   /* H026+$000C */
void h026_upcase(u16 len, char *s);                         /* H026+$003A */
void h026_copy(u16 dst_max, char *dst, u16 src_len, const char *src);
                                                            /* H026+$0188 */
void h026_append(u16 dst_max, char *dst, u16 src_len, const char *src);
                                                            /* H026+$01E0 */
void h026_insert(u16 dst_max, char *dst, u16 src_len, const char *src,
                 u16 pos);                                  /* H026+$0254 */
void h026_delete(u16 len, char *s, u16 start, u16 count);   /* H026+$03F6 */
void h026_substr(u16 dst_max, char *dst, u16 src_len, const char *src,
                 u16 start, u16 count);                     /* H026+$0452 */
s16  h026_find_char(u16 len, const char *s, u8 ch, u16 start, u16 last);
                                                            /* H026+$054E */
u8   h026_compare(u16 len_a, const char *a, u16 len_b, const char *b);
                                                            /* H026+$0088 */
u8   h026_compare_nocase(u16 len_a, const char *a, u16 len_b,
                         const char *b);                    /* H026+$0106 */

#endif
