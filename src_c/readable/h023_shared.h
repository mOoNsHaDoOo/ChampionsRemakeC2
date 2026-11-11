/* H023: servizi condivisi (seme casuale). */
#ifndef COK_H023_SHARED_H
#define COK_H023_SHARED_H

#include "cok.h"

extern u32 g_h023_0000;                 /* H023+$0000: seme casuale */
u32 random_below(u32 n);                /* H023+$0010 */

#endif
