/*
 * H015: runtime del compilatore.
 *
 * L'avvio originale (H015+$0196) apre le librerie, divide la riga di
 * comando (da CLI) oppure gestisce il messaggio del Workbench (CurrentDir
 * sulla directory del programma e console "RAW:10/10/320/80/<nome>"), poi
 * continua nel chiamante.  In C la riga di comando e il messaggio del
 * Workbench li gestisce il runtime del compilatore (c.o di SAS/C): qui
 * restano l'apertura e la chiusura delle librerie.
 * PORT H015+$0196 (Runtime_Start): sostituita dall'avvio del compilatore
 * C; le librerie si aprono in h015_runtime_init.
 * PORT H015+$033E (Runtime_Cleanup): vedi h015_runtime_exit.
 */
#include <stdlib.h>

#include "h015_runtime.h"

#if COK_AMIGA
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/layers.h>

/* Basi aperte da H015+$01B0..$01F2 (versione 0). */
struct GfxBase       *GfxBase;
struct IntuitionBase *IntuitionBase;
struct Library       *LayersBase;
struct Library       *MathBase;
#endif

/* PORT H015+$0042 */
void h015_runtime_start(void)
{
#if COK_AMIGA
    /* dos.library e' gia' aperta da c.o. */
    GfxBase = (struct GfxBase *)OpenLibrary((STRPTR)"graphics.library", 0);
    IntuitionBase = (struct IntuitionBase *)
        OpenLibrary((STRPTR)"intuition.library", 0);
    LayersBase = OpenLibrary((STRPTR)"layers.library", 0);
    MathBase = OpenLibrary((STRPTR)"mathffp.library", 0);
#endif
}

/*
 * PORT H015+$0046: H015+$033E chiude la console del Workbench, risponde al
 * messaggio, chiude le librerie e restituisce il codice d'uscita.
 */
void h015_runtime_exit(s32 code)
{
#if COK_AMIGA
    if (MathBase != NULL) CloseLibrary(MathBase);
    if (LayersBase != NULL) CloseLibrary(LayersBase);
    if (IntuitionBase != NULL) CloseLibrary((struct Library *)IntuitionBase);
    if (GfxBase != NULL) CloseLibrary((struct Library *)GfxBase);
#endif
    exit((int)code);
}

/* PORT H015+$004A: prodotto a 32 bit (i 32 bit bassi). */
u32 h015_mulu32(u32 a, u32 b)
{
    return (u32)(a * b);
}

/* PORT H015+$006E: d0 = quoziente, d1 = resto, senza segno. */
u32 h015_divu32(u32 dividend, u32 divisor, u32 *remainder)
{
    if (remainder != NULL) {
        *remainder = dividend % divisor;
    }
    return dividend / divisor;
}

/*
 * PORT H015+$00BC: divisione con segno.  Il quoziente prende il segno
 * (troncamento verso zero), il resto resta quello dei valori assoluti.
 */
s32 h015_divs32(s32 dividend, s32 divisor, u32 *remainder)
{
    int negative = (dividend < 0) != (divisor < 0);
    u32 a = dividend < 0 ? (u32)0 - (u32)dividend : (u32)dividend;
    u32 b = divisor < 0 ? (u32)0 - (u32)divisor : (u32)divisor;
    u32 q = h015_divu32(a, b, remainder);

    return negative ? -(s32)q : (s32)q;
}

#if COK_AMIGA
/*
 * Su Amiga si chiama mathffp.library come l'originale (MathBase sopra).
 * Prototipi e pragma propri con LONG al posto di FLOAT, agli stessi
 * offset e registri del NDK (SPFix -$1E, SPFlt -$24, SPMul -$4E, SPDiv
 * -$54): nessun tipo float nel C, quindi SAS/C non chiede una libreria
 * matematica (warning 625).
 */
LONG cok_spfix(LONG fnum);
LONG cok_spflt(LONG inum);
LONG cok_spmul(LONG fnum1, LONG fnum2);
LONG cok_spdiv(LONG fnum1, LONG fnum2);
#pragma libcall MathBase cok_spfix 1e 001
#pragma libcall MathBase cok_spflt 24 001
#pragma libcall MathBase cok_spmul 4e 0102
#pragma libcall MathBase cok_spdiv 54 0102

/* PORT H015+$010C: SPMul(d1, d0); d0 = primo argomento sulla pila. */
CokReal h015_spmul(CokReal a, CokReal b)
{
    return (CokReal)cok_spmul((LONG)b, (LONG)a);
}

/* PORT H015+$0122: SPDiv(d1 divisore, d0 dividendo) = dividend / divisor. */
CokReal h015_spdiv(CokReal dividend, CokReal divisor)
{
    return (CokReal)cok_spdiv((LONG)divisor, (LONG)dividend);
}

/* PORT H015+$0172: SPFlt, da intero con segno. */
CokReal h015_spflt(s32 n)
{
    return (CokReal)cok_spflt((LONG)n);
}

/* PORT H015+$0184: SPFix, parte intera troncata. */
s32 h015_spfix(CokReal f)
{
    return (s32)cok_spfix((LONG)f);
}
#else
/*
 * Sull'host non c'e' mathffp: i numeri FFP si convertono in double, il
 * risultato si arrotonda alla singola precisione IEEE (stessi 24 bit di
 * mantissa di FFP) e si riconverte.  Un'eventuale differenza dalla
 * libreria Amiga e' solo nell'arrotondamento dell'ultimo bit.
 */
static double ffp_value(CokReal f)
{
    double v;
    int e;

    if ((f & 0xFFFFFF00UL) == 0) {
        return 0.0;
    }
    v = (double)(f >> 8);               /* mantissa intera, 24 bit */
    e = (int)(f & 0x7F) - 64 - 24;
    while (e > 0) {
        v *= 2.0;
        --e;
    }
    while (e < 0) {
        v /= 2.0;
        ++e;
    }
    return (f & 0x80) ? -v : v;
}

static CokReal ffp_make(double d)
{
    volatile float f = (float)d;        /* singola precisione */
    double v = f;
    u32 sign = 0;
    int e = 64 + 24;

    if (v == 0.0) {
        return 0;
    }
    if (v < 0) {
        sign = 0x80;
        v = -v;
    }
    while (v >= 16777216.0) {           /* 2^24 */
        v /= 2.0;
        ++e;
    }
    while (v < 8388608.0) {             /* 2^23 */
        v *= 2.0;
        --e;
    }
    if (e > 0x7F) {
        return 0xFFFFFF7FUL | sign;     /* il massimo */
    }
    if (e < 0) {
        return 0;
    }
    return ((u32)v << 8) | sign | (u32)e;
}

/* PORT H015+$010C (SPMul) */
CokReal h015_spmul(CokReal a, CokReal b)
{
    return ffp_make(ffp_value(a) * ffp_value(b));
}

/* PORT H015+$0122 (SPDiv): dividend / divisor; divisore 0, il massimo. */
CokReal h015_spdiv(CokReal dividend, CokReal divisor)
{
    double b = ffp_value(divisor);

    if (b == 0.0) {
        return 0xFFFFFF7FUL | ((dividend ^ divisor) & 0x80);
    }
    return ffp_make(ffp_value(dividend) / b);
}

/* PORT H015+$0172 (SPFlt) */
CokReal h015_spflt(s32 n)
{
    return ffp_make((double)n);
}

/* PORT H015+$0184 (SPFix): troncamento verso zero. */
s32 h015_spfix(CokReal f)
{
    double v = ffp_value(f);

    if (v >= 2147483647.0) {
        return 0x7FFFFFFFL;
    }
    if (v <= -2147483648.0) {
        return (s32)(-0x7FFFFFFFL - 1);
    }
    return (s32)v;
}
#endif
