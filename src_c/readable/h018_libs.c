/* H018: adattatori exec.library per apertura e chiusura delle librerie. */
#include "h018_libs.h"

/* PORT H018+$0004: rts. */
void h018_init(void)
{
}

/* PORT H018+$0018 */
void exec_close_library(struct Library *library)
{
    CloseLibrary(library);
}

/* PORT H018+$006A */
struct Library *exec_open_library(const char *name, u32 version)
{
    return OpenLibrary((STRPTR)name, version);
}
