/*
 * Placeholders of the routines not ported yet (see unported.h).
 * They are not marked PORT: they stop the program reporting the address.
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
    fprintf(stderr, "routine not ported yet (skipped): %s\n", where);
}

void cok_unported(const char *where)
{
    printf("routine not ported yet: %s\n", where);
    fflush(stdout);
    exit(20);
}


/* Chiamate da H006+$01AE. */

/* Handlers of the tables H005+$25C0 and H005+$2832 (H027+$4276, H033+$1A50). */
/*
 * Audio (H043/H094): ported in h043_audio.c and h094.c but compiled only
 * with COK_AUDIO (smake AUDIO, make AUDIO=1); without it the audio commands
 * are skipped so that the game can go on.
 */
#ifndef COK_AUDIO
static const char s_h043_0584[] = "H043+$0584";
static const char s_h043_190e[] = "H043+$190E";
void h043_0584(void) { cok_unported_skip(s_h043_0584); }
void h043_190e(u16 command) { (void)command; cok_unported_skip(s_h043_190e); }
void h043_0840(void) { cok_unported_skip("H043+$0840"); }
#endif



/* Dependencies of spell casting (H033+$1426, H065+$2F82). */

/* Combat-only parts of the effect engine. */






