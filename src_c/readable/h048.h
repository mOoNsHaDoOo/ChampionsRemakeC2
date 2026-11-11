/* H048: mappa e figure del combattimento. */
#ifndef COK_H048_H
#define COK_H048_H
#include "character.h"
void combat_map_cell(s16 x, s16 y, u16 *value, u16 *tile);  /* H048+$0154 */
u8   shape_cell(u16 size, u16 i, s16 *dx, s16 *dy);         /* H048+$0044 */
void update_view_positions(void);                           /* H048+$00C2 */
u8   in_view(s16 x, s16 y);                                 /* H048+$01E8 */
u8   combatant_visible(Character *c, u8 all);               /* H048+$0230 */
void draw_combat_cell(s16 x, s16 y);                        /* H048+$0334 */
void redraw_ground(s16 sx, s16 sy, u16 who);                /* H048+$0588 */
void redraw_combat_cell(s16 x, s16 y);                      /* H048+$0884 */
void rebuild_occupancy(void);                               /* H048+$0956 */
u16  combatant_index(Character *c);                         /* H048+$0AA8 */
u8   scroll_view_to(s16 x, s16 y, u8 margin);               /* H048+$0B1A */
void center_view(s16 x, s16 y, u16 margin, u16 dir);        /* H048+$0DF2 */
u16  combatant_x(Character *c);                             /* H048+$0F88 */
u16  combatant_y(Character *c);                             /* H048+$0FBA */
void set_combatant_frame(Character *c, u8 frame, u8 which, u8 skip);
                                                            /* H048+$0FEC */
u8   combatant_size(Character *c);                          /* H048+$110C */
void probe_move(Character *c, u16 dir, u16 *blocker, u16 *tile, u8 *in_cloud,
                u8 *in_acid);                               /* H048+$113E */
void combatant_falls(Character *c);                         /* H048+$12F4 */
u8   place_combatant(Character *c, u8 x, u8 y, u8 restore); /* H048+$16D4 */
void show_combatant_cursor(Character *c, u16 margin, u8 flag); /* H048+$195E */
#endif
