/* H060: redraw of the exploration view. */
#ifndef COK_H060_H
#define COK_H060_H
#include "cok.h"
void h060_init(void);                   /* H060+$000A */
void refresh_view(void);                /* H060+$0018 */
#endif
