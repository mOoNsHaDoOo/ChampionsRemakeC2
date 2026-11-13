/*
 * Routines called by the ported code but not ported yet.  Each one lives in
 * unported.c and stops the program with its address: when it is ported,
 * the declaration moves to the header of its module.
 */
#ifndef COK_UNPORTED_H
#define COK_UNPORTED_H

#include "cok.h"
#include "gfx_record.h"
#include "character.h"

void h043_0584(void);
void h043_190e(u16 command);

/* Handlers of the tables H005+$25C0 and H005+$2832. */

/* Functions of the main menu (H013+$4BFC). */
void h043_0840(void);



                                        /* Load_Sequence */


/* Dependencies of spell casting (H033+$1426, H065+$2F82). */

/* Loading for the adventure after Load Saved Game (H066+$291E). */

/* Combat-only parts of the effect engine. */


/*
 * H048+$16D4: places c on the combat map; outside combat it returns 1
 * (that branch is ported), the rest is not ported.
 */

#endif





/* Used by the ECL commands of H012. */
