/*
 * Champions of Krynn - C port from the 68000 assembly (rebuild/source).
 *
 * Rules of the port:
 *   - every ported function has the marker  PORT Hnnn+$XXXX  above it with
 *     the address of the original routine (see scripts/port_status.py);
 *   - the behaviour follows the assembly; where the C has to differ (host,
 *     64-bit pointers, out-of-bounds accesses) the comment says so;
 *   - the routines not ported yet live in unported.c and stop the
 *     program reporting their address.
 *
 * Original calling convention: arguments on the stack in declaration
 * order (the first one is at the highest offset), removed by the callee.
 * In C the arguments follow the same order.
 */
#ifndef COK_H
#define COK_H

#include <stddef.h>
#include <string.h>

/* Platform: SAS/C (or another Amiga compiler) or host. */
#if defined(__SASC) || defined(__AMIGA__) || defined(AMIGA)
#define COK_AMIGA 1
#else
#define COK_AMIGA 0
#endif

#if COK_AMIGA
#include <exec/types.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <intuition/intuition.h>
#include <intuition/intuitionbase.h>
#include <graphics/gfx.h>
#include <graphics/gfxbase.h>
#include <graphics/view.h>
#include <intuition/preferences.h>
#include <dos/dosextens.h>
typedef unsigned char  u8;
typedef signed char    s8;
typedef unsigned short u16;
typedef signed short   s16;
typedef unsigned long  u32;
typedef signed long    s32;
#else
#include <stdint.h>
#include "host/ndk.h"
typedef uint8_t  u8;
typedef int8_t   s8;
typedef uint16_t u16;
typedef int16_t  s16;
typedef uint32_t u32;
typedef int32_t  s32;
#endif

/* Big-endian words and longs inside byte blocks (file format). */
#define COK_GET16(p)  ((u16)(((const u8 *)(p))[0] << 8 | ((const u8 *)(p))[1]))
#define COK_GET32(p)  ((u32)COK_GET16(p) << 16 | COK_GET16((const u8 *)(p) + 2))
/* Argument evaluated only once (it may be a call). */
#define COK_PUT16(p, v) do { u16 cok_w_ = (u16)(v); \
                             u8 *cok_p_ = (u8 *)(p); \
                             cok_p_[0] = (u8)(cok_w_ >> 8); \
                             cok_p_[1] = (u8)cok_w_; } while (0)
#define COK_PUT32(p, v) do { u32 cok_l_ = (u32)(v); \
                             u8 *cok_q_ = (u8 *)(p); \
                             cok_q_[0] = (u8)(cok_l_ >> 24); \
                             cok_q_[1] = (u8)(cok_l_ >> 16); \
                             cok_q_[2] = (u8)(cok_l_ >> 8); \
                             cok_q_[3] = (u8)cok_l_; } while (0)

/* Stops the program on a routine not ported yet (unported.c). */
void cok_unported(const char *where);
/*
 * Routine not ported yet that can be skipped without stopping the game
 * (audio only): prints a warning the first time and goes on.
 */
void cok_unported_skip(const char *where);

#endif
