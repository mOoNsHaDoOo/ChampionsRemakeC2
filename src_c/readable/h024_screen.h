/* H024: costruzione di NewScreen e OpenScreen. */
#ifndef COK_H024_SCREEN_H
#define COK_H024_SCREEN_H

#include "cok.h"

struct Screen *open_game_screen(u16 width, u16 height, u16 depth,
                                const char *title);     /* H024+$002A */

#endif
