/* H032: inizializzazione di una tabella di H005 da $66. */
#include "init_data.h"

#include "h032_init_data.h"

/* PORT H032+$0004 */
void h032_init(void)
{
    INIT_APPLY(s_init_0028, 0, 0);
}
