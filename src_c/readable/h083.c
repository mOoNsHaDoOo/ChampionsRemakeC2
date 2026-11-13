/* H083: initialisation of a global pointer. */
#include "cok.h"

/*
 * PORT H083+$0008: copies IntuitionBase of the H015 runtime into the module cell.
 * In C the library base is already global: nothing to do.
 */
void h083_init(void)
{
}
