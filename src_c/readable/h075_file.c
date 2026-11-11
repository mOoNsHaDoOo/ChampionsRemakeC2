/* H075: apertura e lettura dei file. */
#include "cok.h"

/*
 * Runtime di scrittura del compilatore, sostituito da stdio:
 * PORT H075+$00FE: scrive un carattere (H075+$01CC).
 * PORT H075+$0124: scrive un a capo (H075+$00FE con $0A).
 * PORT H075+$0132: scrive un blocco (Write).
 */

/* PORT H075+$0008: link/unlk, nessun effetto. */
void h075_init(void)
{
}
