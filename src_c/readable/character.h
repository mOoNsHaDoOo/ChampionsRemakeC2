/*
 * Record del personaggio ($1AA byte, AllocMem MEMF_CLEAR) e nodi collegati.
 *
 * I campi dati restano un blocco di byte con gli offset dell'originale
 * (word e long big-endian, come in H005 e nei file): CH_W/CH_L li leggono.
 * I campi puntatore dell'originale (4 byte nel blocco) sono membri a parte,
 * perche' sull'host i puntatori sono di 8 byte; i loro 4 byte nel blocco
 * restano inutilizzati.
 */
#ifndef COK_CHARACTER_H
#define COK_CHARACTER_H

#include "cok.h"

/* Oggetto posseduto ($48 byte): successivo a +$2C. */
typedef struct CokItem {
    u8 b[0x48];
    struct CokItem *next;       /* +$2C */
} CokItem;

/* Effetto/abilita' ($0A byte, H062+$15F2): successivo a +$06. */
typedef struct CokEffect {
    u8 b[0x0A];
    struct CokEffect *next;     /* +$06 */
} CokEffect;

/*
 * Blocco del turno di combattimento (+$192, $18 byte allocati a parte).
 * L'unico campo longword e' +$0C, un puntatore a personaggio (il
 * bersaglio): sull'host sta in target; i 4 byte in b[$0C..$0F] restano
 * inutilizzati.  Tutti gli altri campi sono byte o word in b.
 */
typedef struct CokTurn {
    u8 b[0x18];
    struct Character *target;   /* +$0C */
} CokTurn;

typedef struct Character {
    u8 b[0x1AA];
    CokEffect *effects;         /* +$0E8 */
    CokItem *items;             /* +$150 */
    CokItem *readied[13];       /* +$154..+$184: oggetti pronti all'uso */
    struct Character *next;     /* +$18E: personaggio seguente nel party */
    CokTurn *block_192;         /* +$192: blocco del turno ($18 byte) */
} Character;

#define CH_W(c, o)        COK_GET16((c)->b + (o))
#define CH_PUTW(c, o, v)  COK_PUT16((c)->b + (o), (v))
#define CH_L(c, o)        COK_GET32((c)->b + (o))
#define CH_PUTL(c, o, v)  COK_PUT32((c)->b + (o), (v))

#endif
