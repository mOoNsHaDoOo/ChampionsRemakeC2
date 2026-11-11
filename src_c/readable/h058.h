/* H058: riposo e scorrere del tempo. */
#ifndef COK_H058_H
#define COK_H058_H
#include "cok.h"
void advance_time(u16 amount, u8 unit); /* H058+$064A */
u8   rest_party(u8 interactive);   /* H058+$1014 */
#endif
