/* H045: shared arithmetic and support helpers. */
#include "h045.h"
#include "h015_runtime.h"

/* PORT H045+$0004: link/unlk, no effect. */
void h045_init(void)
{
}

/*
 * PORT H045+$01D6: writes value in base into the buffer out (at most max_len
 * characters before the NUL), with the '-' sign if is_signed and negative.
 * The digits are padded on the left with pad up to width; digits and
 * padding together do not exceed width (the extra least significant
 * digits are cut).
 */
void format_number(u16 max_len, char *out, s32 value, u8 is_signed,
                   u16 base, u16 width, u8 pad)
{
    char digits[0x50];          /* -$50 */
    s16 n = 0;                  /* -$58 */
    u16 j = 0;                  /* -$5A */
    u16 written = 0;            /* -$5E */
    u16 fill;                   /* -$5C */
    u32 v = (u32)value;         /* -$56 */
    u32 rem;

    if (is_signed && value < 0) {
        out[j++] = '-';
        v = (u32)-value;
    }
    do {
        (void)h015_divu32(v, base, &rem);
        digits[n] = (char)((u16)rem < 10 ? '0' + (u16)rem
                                         : 'A' + (u16)rem - 10);
        ++n;
        v = h015_divu32(v, base, NULL);
    } while (v != 0);

    if (width > (u16)n) {
        fill = (u16)(width - n);
        while (j < max_len && fill > 0) {
            out[j++] = (char)pad;
            --fill;
            ++written;
        }
    }
    while (--n >= 0 && written < width && j < max_len) {
        out[j++] = digits[n];
        ++written;
    }
    out[j] = 0;
}

/*
 * PORT H045+$000C (body at $0068): reads from s a number in base base
 * (digits 0-9 and A-Z), skipping leading spaces; with is_signed it accepts
 * a sign.  Returns 0 (without writing *out) if there is no number or
 * a digit is not valid.
 */
u8 parse_number(u16 len, const char *s, s32 *out, u8 is_signed, u16 base)
{
    u16 pos = 0;                        /* -$2(a5) */
    u16 digit;                          /* -$4(a5) */
    u8 ch;                              /* -$5(a5) */
    s32 value;                          /* -$a(a5) */
    u8 negative = 0;                    /* -$b(a5) */

    (void)len;
    /* PORT H045+$0014 (nested): skips spaces; 0 at the end of the string. */
    while (s[pos] != 0 && s[pos] == ' ') {
        ++pos;
    }
    if (s[pos] == 0) {
        return 0;
    }
    if (is_signed) {
        negative = 0;
        if (s[pos] == '-' || s[pos] == '+') {
            negative = (u8)(s[pos] == '-');
            ++pos;
            while (s[pos] != 0 && s[pos] == ' ') {
                ++pos;
            }
            if (s[pos] == 0) {
                return 0;
            }
        }
    }
    value = 0;
    while ((u8)s[pos] > ' ') {
        ch = (u8)s[pos];
        if (ch >= 'a' && ch <= 'z') {
            ch &= 0x5F;
        }
        if (ch >= '0' && ch <= '9') {
            digit = (u16)(ch - '0');
        } else if (ch >= 'A' && ch <= 'Z') {
            digit = (u16)(ch - 'A' + 10);
        } else {
            return 0;
        }
        if (digit >= base) {
            return 0;
        }
        value = (s32)((u32)base * (u32)value) + digit;
        ++pos;
    }
    if (is_signed && negative) {
        value = -value;
    }
    *out = value;
    return 1;
}
