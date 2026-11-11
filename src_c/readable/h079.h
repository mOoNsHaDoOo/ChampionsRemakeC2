/* H079: adattatori Exec per gli interrupt (usati dall'audio). */
#ifndef COK_H079_H
#define COK_H079_H
#include "cok.h"
void h079_init(void);
#ifdef COK_AUDIO
#if COK_AMIGA
#include <exec/interrupts.h>
#else
#include "host/ndk.h"
#endif
void exec_add_int_server(u16 intnum, struct Interrupt *interrupt); /* H079+$0006 */
void exec_disable(void);                                 /* H079+$002E */
void exec_enable(void);                                  /* H079+$0036 */
void exec_rem_int_server(u16 intnum, struct Interrupt *interrupt); /* H079+$004E */
#endif
#endif
