/* H011: palette e servizi del modulo. */
#ifndef COK_H011_H
#define COK_H011_H

#include "cok.h"
void load_game_palette(void);           /* H011+$010C */
u16  map_wall(s16 x, s16 y, u16 dir);   /* H011+$01AA */
u8   map_flags(s16 x, s16 y);           /* H011+$04E2 */
u16  map_door(s16 x, s16 y, u16 dir);   /* H011+$09C8 */

void set_view_start(u16 a, u16 b, u16 c, u16 d); /* H011+$04A6 */
void load_wall_defs(u16 id, u16 slot);  /* H011+$14EA */
void load_geo_map(u16 id);              /* H011+$1876 */
void draw_3d_view(s16 x, s16 y, u16 dir); /* H011+$0B78 */
#endif
