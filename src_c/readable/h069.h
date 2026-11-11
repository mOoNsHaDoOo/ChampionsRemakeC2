/* H069: segno del party sulla mappa all'aperto. */
#ifndef COK_H069_H
#define COK_H069_H
#include "cok.h"
void h069_init(void);                   /* H069+$0004 */
void h069_draw_marker(void);            /* H069+$0012 */
void h069_restore_marker(void);         /* H069+$00A8 */
#endif
