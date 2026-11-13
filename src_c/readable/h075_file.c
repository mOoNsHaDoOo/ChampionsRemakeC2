/* H075: opening and reading of files. */
#include "cok.h"

/*
 * Writing runtime of the compiler, replaced by stdio:
 * PORT H075+$00FE: writes a character (H075+$01CC).
 * PORT H075+$0124: writes a newline (H075+$00FE with $0A).
 * PORT H075+$0132: writes a block (Write).
 */

/* PORT H075+$0008: link/unlk, no effect. */
void h075_init(void)
{
}
