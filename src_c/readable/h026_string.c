/* H026: string and buffer functions with limits passed by the callers. */
#include "h026_string.h"
#include "h003_exec.h"

/* PORT H026+$0004: link/unlk, no effect. */
void h026_init(void)
{
}

/*
 * PORT H026+$003A: converts to upper case ('a'..'z' and $5F) up to the NUL.  The
 * limit len is passed but not used.
 */
void h026_upcase(u16 len, char *s)
{
    u16 i;

    (void)len;
    for (i = 0; s[i] != 0; ++i) {
        u8 c = (u8)s[i];

        if (c >= 'a' && c <= 'z') {
            c &= 0x5F;
        }
        s[i] = (char)c;
    }
}

/*
 * PORT H026+$0088: byte by byte comparison (unsigned) up to the NUL of a.
 * Returns 1 if equal, 2 if a > b, 0 if a < b.  The limits are not used.
 */
u8 h026_compare(u16 len_a, const char *a, u16 len_b, const char *b)
{
    u16 i;

    (void)len_a;
    (void)len_b;
    for (i = 0;; ++i) {
        if (a[i] != b[i]) {
            return (u8)((u8)a[i] > (u8)b[i] ? 2 : 0);
        }
        if (a[i] == 0) {
            return 1;
        }
    }
}

/* Local copy of H026+$0106: (len + 1) rounded up to even, dbra. */
static char *copy_arg(u16 len, const char *src, u16 *size)
{
    u16 n = (u16)(len + 1);
    char *copy;
    u16 i;

    if (n & 1) {
        ++n;
    }
    *size = (u16)(n + 1);       /* + a guaranteed NUL, see below */
    copy = (char *)exec_alloc_mem(*size, COK_MEMF_CLEAR);
    /*
     * The original always copies n bytes from the source; here the copy stops
     * at the NUL (the bytes after it do not change the result: upper case and comparison
     * stop at the NUL) so as not to read past the C objects; the extra
     * cleared byte also terminates a source without a NUL within n bytes.
     */
    for (i = 0; i < n; ++i) {
        copy[i] = src[i];
        if (src[i] == 0) {
            break;
        }
    }
    return copy;
}

/*
 * PORT H026+$0106: case-insensitive comparison.  Copies the two
 * strings (on the stack in the original), converts them to upper case with
 * H026+$003A and compares them with H026+$0088.
 */
u8 h026_compare_nocase(u16 len_a, const char *a, u16 len_b, const char *b)
{
    u16 size_a;
    u16 size_b;
    char *ca = copy_arg(len_a, a, &size_a);
    char *cb = copy_arg(len_b, b, &size_b);
    u8 result;

    h026_upcase(len_a, ca);
    h026_upcase(len_b, cb);
    result = h026_compare(len_a, ca, len_b, cb);
    exec_free_mem(cb, size_b);
    exec_free_mem(ca, size_a);
    return result;
}

/*
 * In the following functions the "len" arguments are the limits that the callers
 * pass for the source string: the original does not use them (except where
 * stated), it stops at the NUL.
 */

/* PORT H026+$000C: length up to the NUL (word). */
u16 h026_strlen(u16 len, const char *s)
{
    u16 i = 0;

    (void)len;
    while (s[i] != 0) {
        ++i;
    }
    return i;
}

/* PORT H026+$0188: copies at most dst_max bytes, then the NUL. */
void h026_copy(u16 dst_max, char *dst, u16 src_len, const char *src)
{
    u16 i = 0;

    (void)src_len;
    while (src[i] != 0 && i < dst_max) {
        dst[i] = src[i];
        ++i;
    }
    dst[i] = 0;
}

/*
 * PORT H026+$01E0: appends src to dst while the length of dst stays
 * below dst_max, then the NUL.
 */
void h026_append(u16 dst_max, char *dst, u16 src_len, const char *src)
{
    u16 d = h026_strlen(dst_max, dst);
    u16 i = 0;

    (void)src_len;
    while (src[i] != 0) {
        if (!(dst_max > d)) {
            break;
        }
        dst[d] = src[i];
        ++d;
        ++i;
    }
    dst[d] = 0;
}

/* PORT H026+$03F6: removes count characters from start (in place). */
void h026_delete(u16 len, char *s, u16 start, u16 count)
{
    u16 from = (u16)(start + count);
    u16 to = start;

    (void)len;
    while (s[from] != 0) {
        s[to] = s[from];
        ++from;
        ++to;
    }
    s[to] = 0;
}

/*
 * PORT H026+$0452: at most count characters of src from start, not past the
 * NUL of src nor dst_max bytes, then the NUL.
 */
void h026_substr(u16 dst_max, char *dst, u16 src_len, const char *src,
                 u16 start, u16 count)
{
    u16 i = start;
    u16 j = 0;

    (void)src_len;
    while (count != 0 && src[i] != 0 && j < dst_max) {
        dst[j] = src[i];
        ++i;
        ++j;
        --count;
    }
    dst[j] = 0;
}

/*
 * PORT H026+$054E: index of the first ch between start and last (included) before the
 * NUL, otherwise -1.
 */
s16 h026_find_char(u16 len, const char *s, u8 ch, u16 start, u16 last)
{
    u16 i;

    (void)len;
    for (i = start; i <= last && s[i] != 0; ++i) {
        if ((u8)s[i] == ch) {
            return (s16)i;
        }
        if (i == 0xFFFF) {
            break;
        }
    }
    return -1;
}

/*
 * PORT H026+$0254: inserts src into dst at position pos, without exceeding
 * dst_max characters (what does not fit is cut).
 */
void h026_insert(u16 dst_max, char *dst, u16 src_len, const char *src,
                 u16 pos)
{
    u16 ls = h026_strlen(src_len, src);     /* -$2 */
    u16 ld = h026_strlen(dst_max, dst);     /* -$4 */
    u16 max = dst_max;                      /* -$6 */
    u16 count = (u16)(ld - pos + 1);        /* -$8: tail with the NUL */
    u16 from = ld;                          /* -$A */
    u16 to = (u16)(from + ls);              /* -$C */
    u16 i;
    u16 j;

    if (!((u16)(pos + ls) < max)) {
        ls = (u16)(max - pos);
        dst[max] = 0;
        count = 0;
    } else if (!((u16)(pos + ls + count) < max)) {
        dst[max] = 0;
        count = (u16)(max - (u16)(pos + ls));
        from = (u16)(pos + count - 1);
        to = (u16)(max - 1);
    }
    for (i = from, j = to; count > 0; --i, --j, --count) {
        dst[j] = dst[i];
    }
    for (i = 0, j = pos; ls > 0; ++i, ++j, --ls) {
        dst[j] = src[i];
    }
}
