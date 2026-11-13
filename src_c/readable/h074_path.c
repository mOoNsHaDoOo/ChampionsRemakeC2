/* H074: functions for paths and file names. */
#include "cok.h"

u32 g_h074_0000;                /* H074+$0000 */

/*
 * File writing runtime of the compiler, replaced by stdio:
 * PORT H074+$0010: writes a block to a file (Seek, Write, IoErr).
 * PORT H074+$009A: runtime file handling used by H074+$0450.
 * PORT H074+$0450: writes a character to the console (H020+$085A).
 */

/* PORT H074+$0008 */
void h074_init(void)
{
    g_h074_0000 = 0x400;
}
