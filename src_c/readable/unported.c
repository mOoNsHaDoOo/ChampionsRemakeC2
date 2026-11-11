/*
 * Segnaposto delle routine non ancora portate (vedi unported.h).
 * Non sono marcati PORT: fermano il programma indicando l'indirizzo.
 */
#include <stdio.h>
#include <stdlib.h>

#include "unported.h"
#include "globals.h"

void cok_unported_skip(const char *where)
{
    static const char *s_reported[32];
    static int s_count;
    int i;

    for (i = 0; i < s_count; ++i) {
        if (s_reported[i] == where) {
            return;
        }
    }
    if (s_count < 32) {
        s_reported[s_count++] = where;
    }
    fprintf(stderr, "routine non ancora portata (saltata): %s\n", where);
}

void cok_unported(const char *where)
{
    printf("routine non ancora portata: %s\n", where);
    fflush(stdout);
    exit(20);
}


/* Chiamate da H006+$01AE. */

/* Gestori delle tabelle H005+$25C0 e H005+$2832 (H027+$4276, H033+$1A50). */
/*
 * Audio (H043/H094): portato in h043_audio.c e h094.c ma compilato solo
 * con COK_AUDIO (smake AUDIO, make AUDIO=1); senza, i comandi audio si
 * saltano per far proseguire il gioco.
 */
#ifndef COK_AUDIO
static const char s_h043_0584[] = "H043+$0584";
static const char s_h043_190e[] = "H043+$190E";
void h043_0584(void) { cok_unported_skip(s_h043_0584); }
void h043_190e(u16 command) { (void)command; cok_unported_skip(s_h043_190e); }
void h043_0840(void) { cok_unported_skip("H043+$0840"); }
#endif



/* Dipendenze del lancio degli incantesimi (H033+$1426, H065+$2F82). */

/* Parti solo da combattimento del motore degli effetti. */






