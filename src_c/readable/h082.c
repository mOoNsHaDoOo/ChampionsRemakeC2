/* H082: Adattatore graphics.library/FreeCprList. */
#include "h082.h"

/*
 * PORT H082+$0008: copies GfxBase of the H015 runtime into the module cell.
 * In C the library base is already global: nothing to do.
 */
void h082_init(void)
{
}

#if COK_AMIGA
#include <proto/graphics.h>
#endif

/* PORT H082+$0074 */
void graphics_free_cpr_list(struct cprlist *list)
{
    FreeCprList(list);
}
