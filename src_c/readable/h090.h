/* H090: Exec adapters for devices (used by the audio). */
#ifndef COK_H090_H
#define COK_H090_H
#include "cok.h"
void h090_init(void);
#ifdef COK_AUDIO
#if COK_AMIGA
#include <exec/io.h>
#else
#include "host/ndk.h"
#endif
void exec_close_device(struct IORequest *io);           /* H090+$0018 */
s32  exec_open_device(const char *name, u32 unit, struct IORequest *io,
                      u32 flags);                       /* H090+$002A */
#endif
#endif
