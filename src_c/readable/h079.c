/* H079: Adattatori Exec per interrupt e abilitazione/disabilitazione. */
#include "h079.h"

/* PORT H079+$0004: rts. */
void h079_init(void)
{
}

#ifdef COK_AUDIO
#if COK_AMIGA
#include <proto/exec.h>
#endif

/* PORT H079+$0006: AddIntServer(intnum, interrupt). */
void exec_add_int_server(u16 intnum, struct Interrupt *interrupt)
{
    AddIntServer((LONG)intnum, interrupt);
}

/* PORT H079+$002E: Disable. */
void exec_disable(void)
{
    Disable();
}

/* PORT H079+$0036: Enable. */
void exec_enable(void)
{
    Enable();
}

/* PORT H079+$004E: RemIntServer(intnum, interrupt). */
void exec_rem_int_server(u16 intnum, struct Interrupt *interrupt)
{
    RemIntServer((LONG)intnum, interrupt);
}
#endif
