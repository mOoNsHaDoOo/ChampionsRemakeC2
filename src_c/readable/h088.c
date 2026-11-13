/* H088: ByteRun1 UnPackRow with pointer update. */
#include "h087.h"

/* PORT H088+$0004: link/unlk, no effect. */
void h088_init(void)
{
}

/*
 * PORT H088+$000C (UnPackRow, ByteRun1): decodes dst_bytes bytes from
 * *source to *dest using at most src_bytes bytes; updates both
 * pointers.  Returns 1 if the data is too short or too long, 0 if the row
 * is complete.  n >= 0: n+1 literal bytes; -127..-1: the next byte
 * repeated 1-n times; -128: no operation.
 */
u8 ilbm_unpack_row(u8 **source, u8 **dest, s16 src_bytes, s16 dst_bytes)
{
    u8 *s = *source;
    u8 *d = *dest;
    u8 error = 1;
    s16 n;
    u8 c;

    for (;;) {
        if (!(dst_bytes > 0)) {
            error = 0;
            break;
        }
        if ((src_bytes = (s16)(src_bytes - 1)) < 0) {
            break;
        }
        n = (s16)*s++;
        if (n > 0x7F) {
            n = (s16)(n - 0x100);
        }
        if (n >= 0) {
            n = (s16)(n + 1);
            if ((src_bytes = (s16)(src_bytes - n)) < 0) {
                break;
            }
            if ((dst_bytes = (s16)(dst_bytes - n)) < 0) {
                break;
            }
            do {
                *d++ = *s++;
            } while ((n = (s16)(n - 1)) > 0);
        } else if (n != -128) {
            n = (s16)(-n + 1);
            if ((src_bytes = (s16)(src_bytes - 1)) < 0) {
                break;
            }
            if ((dst_bytes = (s16)(dst_bytes - n)) < 0) {
                break;
            }
            c = *s++;
            do {
                *d++ = c;
            } while ((n = (s16)(n - 1)) > 0);
        }
    }
    *source = s;
    *dest = d;
    return error;
}
