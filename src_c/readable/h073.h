/* H073: derived character values (saving throws, abilities, spells). */
#ifndef COK_H073_H
#define COK_H073_H

#include "character.h"

void cleric_spell_slots(Character *c);  /* H073+$09BA */
void saving_throws(Character *c);       /* H073+$0BA8 */
void thief_skills(Character *c);        /* H073+$0FC8 */
u8   h073_1294(Character *c);           /* H073+$1294 */
u8   h073_12ae(Character *c);           /* H073+$12AE */
u8   h073_12c8(Character *c);           /* H073+$12C8 */
u8   h073_130a(Character *c);           /* H073+$130A */
void level_derived_values(Character *c); /* H073+$05AE */

#endif
