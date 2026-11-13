/* H084: Adattatore intuition.library/GetPrefs. */
#include "h084.h"

/*
 * PORT H084+$0008: copies IntuitionBase of the H015 runtime into the module cell.
 * In C the library base is already global: nothing to do.
 */
void h084_init(void)
{
}

#if COK_AMIGA
#include <proto/intuition.h>
#endif

/* PORT H084+$002A */
struct Preferences *intuition_get_prefs(struct Preferences *prefs, u16 size)
{
    return GetPrefs(prefs, (LONG)size);
}
