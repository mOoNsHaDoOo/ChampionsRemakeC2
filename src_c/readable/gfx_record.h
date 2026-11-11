/* Record grafico di H029 (struct GfxRecord), usato da piu' moduli. */
#ifndef COK_GFX_RECORD_H
#define COK_GFX_RECORD_H

#include "cok.h"

/*
 * Record grafico (20 byte nell'originale, MEMF_CLEAR): un'immagine a 5
 * piani e la sua eventuale maschera.  Sull'host i puntatori sono a 64 bit,
 * quindi la struttura e' piu' grande, con gli stessi campi.
 */
struct GfxRecord {
    u16 rows;                   /* +$00: righe */
    u16 count;                  /* +$02: unita' in larghezza (2o argomento) */
    u16 w4;                     /* +$04 */
    u16 w6;                     /* +$06 */
    u16 width8;                 /* +$08: larghezza unitaria in byte (8 px) */
    u16 plane_bytes;            /* +$0A: byte dei 5 piani (word) */
    struct BitMap *mask;        /* +$0C: maschera, un piano ripetuto 5 volte */
    struct BitMap *image;       /* +$10: immagine a 5 piani */
};

#endif
