/* H092: Exec lists (used by the audio). */
#ifndef COK_H092_H
#define COK_H092_H
#include "cok.h"
void h092_init(void);
#ifdef COK_AUDIO
#if COK_AMIGA
#include <exec/lists.h>
#else
#include "host/ndk.h"
#endif
void exec_new_list(struct List *list);                  /* H092+$007A */
#endif
#endif
