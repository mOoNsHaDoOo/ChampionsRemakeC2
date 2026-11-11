/* H068: esplorazione, menu dei comandi, movimento e porte. */
#ifndef COK_H068_H
#define COK_H068_H
#include "cok.h"
void h068_init(void);                   /* H068+$00A4 */
u8   explore_command_menu(void);        /* H068+$0C0E */
void explore_move_or_door(void);        /* H068+$122E */
#endif
