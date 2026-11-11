/* H018: adattatori exec.library per apertura e chiusura delle librerie. */
#ifndef COK_H018_LIBS_H
#define COK_H018_LIBS_H

#include "cok.h"

void            exec_close_library(struct Library *library);   /* H018+$0018 */
struct Library *exec_open_library(const char *name, u32 version); /* H018+$006A */

#endif
