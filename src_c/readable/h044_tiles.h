/* H044: drawing of 8x8 elements (glyphs or tiles) and graphics/UI services. */
#ifndef COK_H044_TILES_H
#define COK_H044_TILES_H

#include "cok.h"

void draw_screen_frame(u8 mid);         /* H044+$01C2 */
void draw_credits_frame(void);          /* H044+$02D8 */
void draw_character_frame(void);        /* H044+$068E */
void draw_combat_frame(void);            /* H044+$0586 */
void draw_explore_frame(void);           /* H044+$0330 */
void draw_wild_frame(void);              /* H044+$0452 */
void draw_items_frame(void);            /* H044+$07DE */
void draw_memorize_frame(void);         /* H044+$0492 */

#endif
