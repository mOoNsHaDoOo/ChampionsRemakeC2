/*
 * H015: compiler runtime.
 *
 * The original start-up (H015+$0196) opens the libraries, splits the command
 * line (from CLI) or handles the Workbench message (CurrentDir
 * on the program directory and console "RAW:10/10/320/80/<name>"), then
 * continues into the caller.  In C the command line and the Workbench
 * message are handled by the compiler runtime (SAS/C's c.o): here
 * only the opening and closing of the libraries remain.
 * PORT H015+$0196 (Runtime_Start): replaced by the start-up of the C
 * compiler; the libraries are opened in h015_runtime_init.
 * PORT H015+$033E (Runtime_Cleanup): see h015_runtime_exit.
 */
#include <stdlib.h>

#include "h015_runtime.h"

#if COK_AMIGA
#include <proto/graphics.h>
#include <proto/intuition.h>
#include <proto/layers.h>

/* Bases opened by H015+$01B0..$01F2 (version 0). */
struct GfxBase       *GfxBase;
struct IntuitionBase *IntuitionBase;
struct Library       *LayersBase;
struct Library       *MathBase;
#endif

/* PORT H015+$0042 */
void h015_runtime_start(void)
{
#if COK_AMIGA
    /* dos.library is already open from c.o. */
    GfxBase = (struct GfxBase *)OpenLibrary((STRPTR)"graphics.library", 0);
    IntuitionBase = (struct IntuitionBase *)
        OpenLibrary((STRPTR)"intuition.library", 0);
    LayersBase = OpenLibrary((STRPTR)"layers.library", 0);
    MathBase = OpenLibrary((STRPTR)"mathffp.library", 0);
#endif
}

/*
 * PORT H015+$0046: H015+$033E closes the Workbench console, replies to the
 * message, closes the libraries and returns the exit code.
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

/* PORT H015+$004A: 32-bit product (the low 32 bits). */
u32 h015_mulu32(u32 a, u32 b)
{
    return (u32)(a * b);
}

/* PORT H015+$006E: d0 = quotient, d1 = remainder, unsigned. */
u32 h015_divu32(u32 dividend, u32 divisor, u32 *remainder)
{
    if (remainder != NULL) {
        *remainder = dividend % divisor;
    }
    return dividend / divisor;
}

/*
 * PORT H015+$00BC: signed division.  The quotient takes the sign
 * (truncation towards zero), the remainder stays the one of the absolute values.
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
 * On the Amiga mathffp.library is called like the original (MathBase above).
 * Own prototypes and pragmas with LONG instead of FLOAT, at the same
 * offsets and registers as the NDK (SPFix -$1E, SPFlt -$24, SPMul -$4E, SPDiv
 * -$54): no float type in the C, so SAS/C does not ask for a maths
 * library (warning 625).
 */
LONG cok_spfix(LONG fnum);
LONG cok_spflt(LONG inum);
LONG cok_spmul(LONG fnum1, LONG fnum2);
LONG cok_spdiv(LONG fnum1, LONG fnum2);
#pragma libcall MathBase cok_spfix 1e 001
#pragma libcall MathBase cok_spflt 24 001
#pragma libcall MathBase cok_spmul 4e 0102
#pragma libcall MathBase cok_spdiv 54 0102

/* PORT H015+$010C: SPMul(d1, d0); d0 = first argument on the stack. */
CokReal h015_spmul(CokReal a, CokReal b)
{
    return (CokReal)cok_spmul((LONG)b, (LONG)a);
}

/* PORT H015+$0122: SPDiv(d1 divisor, d0 dividend) = dividend / divisor. */
CokReal h015_spdiv(CokReal dividend, CokReal divisor)
{
    return (CokReal)cok_spdiv((LONG)divisor, (LONG)dividend);
}

/* PORT H015+$0172: SPFlt, from a signed integer. */
CokReal h015_spflt(s32 n)
{
    return (CokReal)cok_spflt((LONG)n);
}

/* PORT H015+$0184: SPFix, truncated integer part. */
s32 h015_spfix(CokReal f)
{
    return (s32)cok_spfix((LONG)f);
}
#else
/*
 * On the host there is no mathffp: the FFP numbers are converted to double, the
 * result is rounded to IEEE single precision (the same 24 bits of
 * mantissa as FFP) and converted back.  Any difference from the
 * Amiga library is only in the rounding of the last bit.
 */
static double ffp_value(CokReal f)
{
    double v;
    int e;

    if ((f & 0xFFFFFF00UL) == 0) {
        return 0.0;
    }
    v = (double)(f >> 8);               /* integer mantissa, 24 bits */
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
    volatile float f = (float)d;        /* single precision */
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
        return 0xFFFFFF7FUL | sign;     /* the maximum */
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

/* PORT H015+$0122 (SPDiv): dividend / divisor; divisor 0, the maximum. */
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

/* PORT H015+$0184 (SPFix): truncation towards zero. */
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
