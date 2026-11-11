/* H021: adattatori intuition.library. */
#ifndef COK_H021_INTUITION_H
#define COK_H021_INTUITION_H

#include "cok.h"

void intuition_current_time(u32 *seconds, u32 *micros);   /* H021+$0030 */
void intuition_close_screen(struct Screen *screen);       /* H021+$010C */
u32  intuition_close_workbench(void);                     /* H021+$011E */
struct Screen *intuition_open_screen(struct NewScreen *ns); /* H021+$0184 */
u32  intuition_open_workbench(void);                      /* H021+$0196 */
void intuition_show_title(struct Screen *screen, u8 show); /* H021+$01D2 */
void intuition_activate_window(struct Window *window);    /* H021+$01FA */
void intuition_clear_pointer(struct Window *window);      /* H021+$0230 */
void intuition_close_window(struct Window *window);       /* H021+$0242 */
struct Window *intuition_open_window(struct NewWindow *nw); /* H021+$029C */
void intuition_modify_idcmp(struct Window *window, u32 flags); /* H021+$026C */
void intuition_set_pointer(struct Window *window, u8 *data, u16 height,
                           u16 width, u16 x_offset, u16 y_offset);
                                                          /* H021+$02EE */
u32  intuition_auto_request(struct Window *window, struct IntuiText *body,
                            struct IntuiText *pos, struct IntuiText *neg,
                            u32 pos_flags, u32 neg_flags, u16 width,
                            u16 height);                  /* H021+$03AE */

#endif
