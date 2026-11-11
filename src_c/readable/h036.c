/* H036: Adattatore dos.library/Delay. */
#include "h036.h"

/*
 * PORT H036+$0008: copia DOSBase del runtime H015 nella cella del modulo.
 * In C la base della libreria e' gia' globale: niente da fare.
 */
void h036_init(void)
{
}

/* PORT H036+$0034 */
void dos_delay(u32 ticks)
{
    Delay((LONG)ticks);
}
