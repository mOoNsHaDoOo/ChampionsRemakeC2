/* H097: AI of the computer-controlled combatants. */
#ifndef COK_H097_H
#define COK_H097_H
#include "character.h"
void h097_init(void);                   /* H097+$00A2 */
void monster_turn(Character *c);        /* H097+$1D68 */
#endif
