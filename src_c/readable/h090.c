/* H090: Exec adapters for OpenDevice/CloseDevice. */
#include "h090.h"

/* PORT H090+$0004: rts. */
void h090_init(void)
{
}

#ifdef COK_AUDIO
#if COK_AMIGA
#include <proto/exec.h>
#endif

/* PORT H090+$0018: CloseDevice(io). */
void exec_close_device(struct IORequest *io)
{
    CloseDevice(io);
}

/* PORT H090+$002A: OpenDevice(name, unit, io, flags). */
s32 exec_open_device(const char *name, u32 unit, struct IORequest *io,
                     u32 flags)
{
    return (s32)OpenDevice((STRPTR)name, unit, io, flags);
}
#endif
