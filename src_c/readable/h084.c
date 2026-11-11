/* H084: Adattatore intuition.library/GetPrefs. */
#include "h084.h"

/*
 * PORT H084+$0008: copia IntuitionBase del runtime H015 nella cella del modulo.
 * In C la base della libreria e' gia' globale: niente da fare.
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
