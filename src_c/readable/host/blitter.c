/*
 * Host build: emulator of the Amiga blitter (registers $DFF040..$DFF074),
 * for the game code that programs it directly.
 *
 * Emulates area mode: channels A, B, C, D, minterm (BLTCON0), shift of A
 * and B, first/last word masks on A, modulo, descending mode.  Writing
 * BLTSIZE runs the blit at once (the host has no parallelism: WaitBlit
 * does not need to wait).  Line and fill modes are not emulated: if
 * requested the program stops.
 */
#include <stdio.h>
#include <stdlib.h>
#include "../custom.h"

static u16 s_reg[0x100];                /* word registers, by offset/2 */
static u8 *s_ptr[4];                    /* A, B, C, D */

static int ptr_index(unsigned reg)
{
    switch (reg) {
    case BLTAPT: return 0;
    case BLTBPT: return 1;
    case BLTCPT: return 2;
    case BLTDPT: return 3;
    default: return -1;
    }
}

void host_custom_pointer(unsigned reg, void *p)
{
    int i = ptr_index(reg);

    if (i < 0) {
        fprintf(stderr, "blitter: pointer register $%03X not handled\n", reg);
        exit(20);
    }
    s_ptr[i] = (u8 *)p;
}

static u16 get_word(const u8 *p)
{
    return (u16)(p[0] << 8 | p[1]);
}

static void blit(u16 size)
{
    u16 con0 = s_reg[BLTCON0 / 2];
    u16 con1 = s_reg[BLTCON1 / 2];
    unsigned height = (unsigned)(size >> 6) ? (unsigned)(size >> 6) : 1024;
    unsigned width = (size & 0x3F) ? (unsigned)(size & 0x3F) : 64;
    int desc = (con1 & 0x0002) != 0;
    int step = desc ? -2 : 2;
    unsigned ash = con0 >> 12;
    unsigned bsh = con1 >> 12;
    u8 minterm = (u8)con0;
    int use_a = (con0 & 0x0800) != 0;
    int use_b = (con0 & 0x0400) != 0;
    int use_c = (con0 & 0x0200) != 0;
    int use_d = (con0 & 0x0100) != 0;
    s16 mod_a = (s16)s_reg[BLTAMOD / 2];
    s16 mod_b = (s16)s_reg[BLTBMOD / 2];
    s16 mod_c = (s16)s_reg[BLTCMOD / 2];
    s16 mod_d = (s16)s_reg[BLTDMOD / 2];
    u16 prev_a = 0;
    u16 prev_b = 0;
    unsigned x;
    unsigned y;

    if (con1 & 0x0001) {
        fprintf(stderr, "blitter: line mode not emulated\n");
        exit(20);
    }
    if (con1 & 0x0018) {
        fprintf(stderr, "blitter: fill mode not emulated\n");
        exit(20);
    }
    for (y = 0; y < height; ++y) {
        for (x = 0; x < width; ++x) {
            u16 a = use_a ? get_word(s_ptr[0]) : s_reg[BLTADAT / 2];
            u16 b = use_b ? get_word(s_ptr[1]) : s_reg[BLTBDAT / 2];
            u16 c = use_c ? get_word(s_ptr[2]) : s_reg[BLTCDAT / 2];
            u16 am = a;
            u16 as;
            u16 bs;
            u16 d = 0;
            int bit;

            if (x == 0) {
                am &= s_reg[BLTAFWM / 2];
            }
            if (x == width - 1) {
                am &= s_reg[BLTALWM / 2];
            }
            /* Shift: to the left when descending, otherwise to the right. */
            if (desc) {
                as = (u16)(((u32)am << 16 | prev_a) >> (16 - ash));
                bs = (u16)(((u32)b << 16 | prev_b) >> (16 - bsh));
            } else {
                as = (u16)(((u32)prev_a << 16 | am) >> ash);
                bs = (u16)(((u32)prev_b << 16 | b) >> bsh);
            }
            prev_a = am;
            prev_b = b;
            for (bit = 0; bit < 8; ++bit) {
                if (minterm & (1 << bit)) {
                    u16 ta = (bit & 4) ? as : (u16)~as;
                    u16 tb = (bit & 2) ? bs : (u16)~bs;
                    u16 tc = (bit & 1) ? c : (u16)~c;

                    d |= (u16)(ta & tb & tc);
                }
            }
            if (use_d) {
                s_ptr[3][0] = (u8)(d >> 8);
                s_ptr[3][1] = (u8)d;
            }
            if (use_a) {
                s_ptr[0] += step;
            }
            if (use_b) {
                s_ptr[1] += step;
            }
            if (use_c) {
                s_ptr[2] += step;
            }
            if (use_d) {
                s_ptr[3] += step;
            }
        }
        if (use_a) {
            s_ptr[0] += desc ? -mod_a : mod_a;
        }
        if (use_b) {
            s_ptr[1] += desc ? -mod_b : mod_b;
        }
        if (use_c) {
            s_ptr[2] += desc ? -mod_c : mod_c;
        }
        if (use_d) {
            s_ptr[3] += desc ? -mod_d : mod_d;
        }
    }
    host_display_changed();
}

void host_custom_write(unsigned reg, u16 value)
{
    if (reg >= 0x200 || (reg & 1) != 0) {
        fprintf(stderr, "custom: invalid register $%03X\n", reg);
        exit(20);
    }
    s_reg[reg / 2] = value;
    if (reg == BLTSIZE) {
        blit(value);
    }
}

/* graphics.library: with the blitter emulated synchronously there is no wait. */
void OwnBlitter(void)
{
}

void DisownBlitter(void)
{
}

void WaitBlit(void)
{
}
