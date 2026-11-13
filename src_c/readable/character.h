/*
 * Character record ($1AA bytes, AllocMem MEMF_CLEAR) and linked nodes.
 *
 * The data fields stay a block of bytes with the offsets of the original
 * (big-endian words and longs, as in H005 and in the files): CH_W/CH_L read them.
 * The pointer fields of the original (4 bytes in the block) are separate
 * members, because on the host pointers are 8 bytes; their 4 bytes in the
 * block stay unused.
 */
#ifndef COK_CHARACTER_H
#define COK_CHARACTER_H

#include "cok.h"

/* Owned item ($48 bytes): next one at +$2C. */
typedef struct CokItem {
    u8 b[0x48];
    struct CokItem *next;       /* +$2C */
} CokItem;

/* Effect/ability ($0A bytes, H062+$15F2): next one at +$06. */
typedef struct CokEffect {
    u8 b[0x0A];
    struct CokEffect *next;     /* +$06 */
} CokEffect;

/*
 * Combat turn block (+$192, $18 bytes allocated separately).
 * The only longword field is +$0C, a pointer to a character (the
 * target): on the host it lives in target; the 4 bytes in b[$0C..$0F] stay
 * unused.  All the other fields are bytes or words in b.
 */
typedef struct CokTurn {
    u8 b[0x18];
    struct Character *target;   /* +$0C */
} CokTurn;

typedef struct Character {
    u8 b[0x1AA];
    CokEffect *effects;         /* +$0E8 */
    CokItem *items;             /* +$150 */
    CokItem *readied[13];       /* +$154..+$184: readied items */
    struct Character *next;     /* +$18E: next character in the party */
    CokTurn *block_192;         /* +$192: turn block ($18 bytes) */
} Character;

#define CH_W(c, o)        COK_GET16((c)->b + (o))
#define CH_PUTW(c, o, v)  COK_PUT16((c)->b + (o), (v))
#define CH_L(c, o)        COK_GET32((c)->b + (o))
#define CH_PUTL(c, o, v)  COK_PUT32((c)->b + (o), (v))

#endif
