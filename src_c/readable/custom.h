/*
 * Access to the custom chip registers ($DFF000) written directly by the
 * game (blitter).  On the Amiga they are memory writes; on the host they go
 * to the blitter emulator in host/blitter.c.  The pointer registers
 * (BLTxPT) take a C pointer.
 */
#ifndef COK_CUSTOM_H
#define COK_CUSTOM_H

#include "cok.h"

/* Offsets of the blitter registers. */
#define BLTCON0  0x040
#define BLTCON1  0x042
#define BLTAFWM  0x044
#define BLTALWM  0x046
#define BLTCPT   0x048
#define BLTBPT   0x04C
#define BLTAPT   0x050
#define BLTDPT   0x054
#define BLTSIZE  0x058
#define BLTCMOD  0x060
#define BLTBMOD  0x062
#define BLTAMOD  0x064
#define BLTDMOD  0x066
#define BLTCDAT  0x070
#define BLTBDAT  0x072
#define BLTADAT  0x074

extern volatile u8 *g_custom;           /* H100+$0000 */

#if COK_AMIGA
#define CUSTOM_W(reg, v) \
    (*(volatile u16 *)(g_custom + (reg)) = (u16)(v))
#define CUSTOM_P(reg, p) \
    (*(volatile u32 *)(g_custom + (reg)) = (u32)(p))
#else
void host_custom_write(unsigned reg, u16 value);
void host_custom_pointer(unsigned reg, void *p);
#define CUSTOM_W(reg, v) host_custom_write((reg), (u16)(v))
#define CUSTOM_P(reg, p) host_custom_pointer((reg), (void *)(p))
#endif

#endif
