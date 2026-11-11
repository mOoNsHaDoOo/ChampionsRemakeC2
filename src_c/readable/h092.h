/* H092: liste Exec (usate dall'audio). */
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
