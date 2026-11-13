/* H065: character, item and equipment screens. */
#ifndef COK_H065_H
#define COK_H065_H

#include "cok.h"

void draw_character_sheet(void);        /* H065+$04B8 */
void draw_character_money(void);        /* H065+$0ADE */
void draw_combat_values(void);          /* H065+$0BE6 */
void draw_stat_value(u8 stat, u8 highlight);            /* H065+$10DE */
u8   pick_character(void);              /* H065+$3702 */
void view_character(u8 *redraw);        /* H065+$196E */
void show_items(u8 *redraw);            /* H065+$255A */
u16  choose_spell_of_kind(u16 kind, u16 mode, s16 *spell, u8 *found);
                                        /* H065+$34FC */

#include "character.h"
void ready_item(CokItem *it);           /* H065+$2C04 */

void select_party_member(u8 key);       /* H065+$3390 */
void use_item(CokItem *it, u8 *redraw);  /* H065+$2F82 */
u8   item_overloads(Character *c, CokItem *it); /* H065+$32F6 */
u32  wealth_in_steel(Character *c);      /* H065+$347E */
#endif
