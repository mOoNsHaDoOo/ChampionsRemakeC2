/* H025: costruzione di NewWindow e OpenWindow. */
#ifndef COK_H025_WINDOW_H
#define COK_H025_WINDOW_H

#include "cok.h"

struct Window *open_game_window(u16 left, u16 top, u16 width, u16 height,
                                u32 idcmp, u32 flags, struct Gadget *gadgets,
                                struct Screen *screen, const char *title);
                                                        /* H025+$0028 */
#endif
