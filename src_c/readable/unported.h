/*
 * Routine chiamate dal codice portato ma non ancora portate.  Ognuna sta in
 * unported.c e ferma il programma con il suo indirizzo: quando viene
 * portata, la dichiarazione passa all'header del suo modulo.
 */
#ifndef COK_UNPORTED_H
#define COK_UNPORTED_H

#include "cok.h"
#include "gfx_record.h"
#include "character.h"

void h043_0584(void);
void h043_190e(u16 command);

/* Gestori delle tabelle H005+$25C0 e H005+$2832. */

/* Funzioni del menu principale (H013+$4BFC). */
void h043_0840(void);



                                        /* Load_Sequence */


/* Dipendenze del lancio degli incantesimi (H033+$1426, H065+$2F82). */

/* Caricamenti per l'avventura dopo Load Saved Game (H066+$291E). */

/* Parti solo da combattimento del motore degli effetti. */


/*
 * H048+$16D4: posiziona c sulla mappa del combattimento; fuori dal
 * combattimento restituisce 1 (portato quel ramo), il resto non e' portato.
 */

#endif





/* Usati dai comandi ECL di H012. */
