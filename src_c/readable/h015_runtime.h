/* H015: compiler runtime (start-up, exit, 32-bit arithmetic). */
#ifndef COK_H015_RUNTIME_H
#define COK_H015_RUNTIME_H

#include "cok.h"

void h015_runtime_start(void);                    /* H015+$0042 -> $0196 */
void h015_runtime_exit(s32 code);                 /* H015+$0046 -> $033E */
u32  h015_mulu32(u32 a, u32 b);                   /* H015+$004A */
u32  h015_divu32(u32 dividend, u32 divisor, u32 *remainder); /* H015+$006E */
s32  h015_divs32(s32 dividend, s32 divisor, u32 *remainder); /* H015+$00BC */


/*
 * Real number in Motorola Fast Floating Point format (mathffp): bits
 * 31..8 mantissa (24 bits, normalised), bit 7 sign, bits 6..0 exponent
 * in excess 64.  0 is zero.
 */
typedef u32 CokReal;

CokReal h015_spmul(CokReal a, CokReal b);         /* H015+$010C (SPMul) */
CokReal h015_spdiv(CokReal dividend, CokReal divisor); /* H015+$0122 (SPDiv) */
CokReal h015_spflt(s32 n);                        /* H015+$0172 (SPFlt) */
s32  h015_spfix(CokReal f);                       /* H015+$0184 (SPFix) */

#endif
