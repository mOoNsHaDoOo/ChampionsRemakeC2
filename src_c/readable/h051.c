/* H051: Adattatore Exec/FindTask. */
#include "h051.h"

/* PORT H051+$0004: rts. */
void h051_init(void)
{
}

/* PORT H051+$004A */
struct Task *exec_find_task(const char *name)
{
    return FindTask((STRPTR)name);
}
