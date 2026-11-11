/* H026: funzioni su stringhe e buffer con limiti passati dai chiamanti. */
#include "h026_string.h"
#include "h003_exec.h"

/* PORT H026+$0004: link/unlk, nessun effetto. */
void h026_init(void)
{
}

/*
 * PORT H026+$003A: porta in maiuscolo ('a'..'z' and $5F) fino al NUL.  Il
 * limite len e' passato ma non usato.
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
 * PORT H026+$0088: confronto byte per byte (senza segno) fino al NUL di a.
 * Restituisce 1 se uguali, 2 se a > b, 0 se a < b.  I limiti non sono usati.
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

/* Copia locale di H026+$0106: (len + 1) arrotondato a pari, dbra. */
static char *copy_arg(u16 len, const char *src, u16 *size)
{
    u16 n = (u16)(len + 1);
    char *copy;
    u16 i;

    if (n & 1) {
        ++n;
    }
    *size = (u16)(n + 1);       /* + un NUL garantito, vedi sotto */
    copy = (char *)exec_alloc_mem(*size, COK_MEMF_CLEAR);
    /*
     * L'originale copia sempre n byte dalla sorgente; qui la copia si ferma
     * al NUL (i byte dopo non cambiano il risultato: maiuscolo e confronto
     * si fermano al NUL) per non leggere oltre gli oggetti C; il byte in
     * piu' azzerato termina anche una sorgente senza NUL entro n byte.
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
 * PORT H026+$0106: confronto senza distinzione di maiuscole.  Copia le due
 * stringhe (nell'originale sullo stack), le porta in maiuscolo con
 * H026+$003A e le confronta con H026+$0088.
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
 * Nelle funzioni seguenti gli argomenti "len" sono i limiti che i chiamanti
 * passano per la stringa sorgente: l'originale non li usa (salvo dove
 * detto), si ferma al NUL.
 */

/* PORT H026+$000C: lunghezza fino al NUL (word). */
u16 h026_strlen(u16 len, const char *s)
{
    u16 i = 0;

    (void)len;
    while (s[i] != 0) {
        ++i;
    }
    return i;
}

/* PORT H026+$0188: copia al massimo dst_max byte, poi il NUL. */
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
 * PORT H026+$01E0: accoda src a dst finche' la lunghezza di dst resta
 * minore di dst_max, poi il NUL.
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

/* PORT H026+$03F6: toglie count caratteri da start (sul posto). */
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
 * PORT H026+$0452: al massimo count caratteri di src da start, non oltre il
 * NUL di src ne' dst_max byte, poi il NUL.
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
 * PORT H026+$054E: indice del primo ch tra start e last (compreso) prima del
 * NUL, altrimenti -1.
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
 * PORT H026+$0254: inserisce src in dst alla posizione pos, senza superare
 * dst_max caratteri (cio' che non ci sta viene tagliato).
 */
void h026_insert(u16 dst_max, char *dst, u16 src_len, const char *src,
                 u16 pos)
{
    u16 ls = h026_strlen(src_len, src);     /* -$2 */
    u16 ld = h026_strlen(dst_max, dst);     /* -$4 */
    u16 max = dst_max;                      /* -$6 */
    u16 count = (u16)(ld - pos + 1);        /* -$8: coda con il NUL */
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
