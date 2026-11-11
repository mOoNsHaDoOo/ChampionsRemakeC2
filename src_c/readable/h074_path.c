/* H074: funzioni per percorsi e nomi di file. */
#include "cok.h"

u32 g_h074_0000;                /* H074+$0000 */

/*
 * Runtime di scrittura su file del compilatore, sostituito da stdio:
 * PORT H074+$0010: scrive un blocco su un file (Seek, Write, IoErr).
 * PORT H074+$009A: gestione del file del runtime usata da H074+$0450.
 * PORT H074+$0450: scrive un carattere sulla console (H020+$085A).
 */

/* PORT H074+$0008 */
void h074_init(void)
{
    g_h074_0000 = 0x400;
}
