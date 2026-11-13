/* H010: Intuition input, event conversion, exit and errors. */
#ifndef COK_H010_INPUT_H
#define COK_H010_INPUT_H

#include "cok.h"

void poll_intuition_events(void);       /* H010+$042E (body at $0882) */
void wait_for_key(void);                /* H010+$0974 */
void quit_game(void);                   /* H010+$0332 */
void console_writeln(u16 len, const char *text); /* H010+$0360 */

#endif
