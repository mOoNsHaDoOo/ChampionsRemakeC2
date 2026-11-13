/* H035: loading of 24x24 sets and COMSPR resources. */
#ifndef COK_H035_H
#define COK_H035_H

#include "cok.h"

void load_sprite_set(u16 name_len, const char *name, u16 id, u16 slot);
                                                        /* H035+$0246 */
void load_24x24_set(u16 name_len, const char *name, u8 id, u8 first,
                    u8 count);                          /* H035+$0040 */
void draw_map_tile(s16 col, s16 row, u8 frame, u8 masked); /* H035+$019A */
void free_sprite_set(u8 slot);          /* H035+$01DC */
void draw_sprite_set(u16 col, u16 row, u16 scale, u16 which, u16 slot);
                                                        /* H035+$0460 */
#endif
