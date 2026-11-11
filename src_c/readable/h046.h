/* H046: direzione del cursore. */
#ifndef COK_H046_H
#define COK_H046_H
#include "cok.h"
void h046_init(void);                   /* H046+$0004 */
u8   cursor_direction(u16 px, u16 py, u16 x, u16 y); /* H046+$0012 */
#endif
