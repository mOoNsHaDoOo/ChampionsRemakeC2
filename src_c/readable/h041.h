/* H041: memory preceded by the allocation size. */
#ifndef COK_H041_H
#define COK_H041_H

#include "cok.h"

u8  *sized_alloc(u32 flags, u32 size);  /* H041+$000C */
u8  *sized_alloc_chip(u32 size);        /* H041+$004A */
void sized_free(void *block);           /* H041+$00BE */

#endif
