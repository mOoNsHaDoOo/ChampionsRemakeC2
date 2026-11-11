/* H059: ciclo del combattimento tattico. */
#ifndef COK_H059_H
#define COK_H059_H
#include "character.h"
extern Character *g_turn_order[0x48];   /* $2392 */
void combat_main_loop(void);            /* H059+$1782 */
#endif
