/* H082: Adattatore graphics.library/FreeCprList. */
#include "h082.h"

/*
 * PORT H082+$0008: copia GfxBase del runtime H015 nella cella del modulo.
 * In C la base della libreria e' gia' globale: niente da fare.
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
