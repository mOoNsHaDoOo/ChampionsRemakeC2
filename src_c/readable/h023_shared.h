/* H023: shared services (random seed). */
#ifndef COK_H023_SHARED_H
#define COK_H023_SHARED_H

#include "cok.h"

extern u32 g_h023_0000;                 /* H023+$0000: random seed */
u32 random_below(u32 n);                /* H023+$0010 */

#endif
