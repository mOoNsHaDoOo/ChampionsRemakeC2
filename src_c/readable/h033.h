/* H033: vettori e servizi condivisi di azioni/oggetti e incantesimi. */
#ifndef COK_H033_H
#define COK_H033_H

#include "character.h"

void install_action_handlers(void);     /* H033+$1A50 */
u8   is_scroll(const CokItem *it);      /* H033+$17E6 */
u16  choose_spell(u16 mode, s16 *index);                /* H033+$00EE */
u8   build_spell_list(u16 kind);                        /* H033+$0D7C */
void select_spell_target(u8 spell, u8 unused, u8 *ok);  /* H033+$12D4 */
void cast_spell(u16 spell, u8 auto_abort, u8 announce, u8 *redraw);
                                                        /* H033+$1426 */
void remove_scroll_spell(Character *c, CokItem *it, u16 spell);
                                                        /* H033+$1836 */
void announce_spell(Character *c, u16 len, const char *text, u16 spell);
                                                        /* H033+$18EE */

u16  spell_range(u16 spell);              /* H033+$11FC */
void spell_no_effect(void);              /* H033+$1A40 */
#endif
