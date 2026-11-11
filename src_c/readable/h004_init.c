/*
 * H004: inizializzazione dei dati del gioco.
 *
 * H004+$0C1A ($0C38..$5ED4) riempie H005: nomi (classi, razze, ...), tabelle
 * numeriche e alcune tabelle calcolate con dei cicli.  Le costanti sono in
 * h004_init_data.h (generato da scripts/gen_h004_init_data.py, nell'ordine
 * dell'originale); i cicli sono qui sotto, nella stessa posizione.
 */
#include "globals.h"
#include "h004_init.h"

typedef enum H004InitKind {
    H004_STR,     /* dbeq: al massimo value byte, NUL compreso se c'e' */
    H004_BYTES,   /* value byte esatti da text */
    H004_WCOPY,   /* value = sorgente | conteggio << 16: word dentro H005 */
    H004_B,
    H004_W,
    H004_L
} H004InitKind;

typedef struct H004InitOp {
    u8 kind;
    u16 dst;
    u32 value;
    const char *text;
} H004InitOp;

#include "h004_init_data.h"

static void apply(const H004InitOp *op, size_t n)
{
    size_t i;

    for (i = 0; i < n; ++i, ++op) {
        switch (op->kind) {
        case H004_STR: {
            /* move.b (a3)+,(a2)+ / dbeq: si ferma dopo il NUL o al limite. */
            size_t len = strlen(op->text) + 1;
            memcpy(&g_h005[op->dst], op->text,
                   len < op->value ? len : op->value);
            break;
        }
        case H004_BYTES:
            memcpy(&g_h005[op->dst], op->text, op->value);
            break;
        case H004_WCOPY: {
            u16 src = (u16)(op->value & 0xFFFF);
            u16 count = (u16)(op->value >> 16);
            memmove(&g_h005[op->dst], &g_h005[src], (size_t)count * 2);
            break;
        }
        case H004_B:
            H005_B(op->dst) = (u8)op->value;
            break;
        case H004_W:
            H005_SET_W(op->dst, op->value);
            break;
        default:
            H005_SET_L(op->dst, op->value);
            break;
        }
    }
}

#define APPLY(table) apply(table, sizeof(table) / sizeof(table[0]))

/*
 * H004+$3D12..$4502: dieci tabelle per classe, passo $9A byte.  Ognuna:
 *   +$00  11 long: soglie di esperienza (-1 = nessun livello);
 *   +$2C  11 x 5 word per i livelli 2..12, azzerate e poi alcune a 1.
 */
typedef struct ClassTable {
    u16 base;
    u32 xp[11];
    u8 ones[11];          /* offset delle word a 1, 0 = fine */
} ClassTable;

#define NO_LEVEL 0xFFFFFFFFu

static const ClassTable s_class_tables[10] = {
    { 0x1946, { 0xFA0, 0x1D4C, 0x3B92, 0x61A8, 0x9C40, 0x15F90, 0x27100,
                NO_LEVEL, NO_LEVEL, NO_LEVEL, NO_LEVEL },
      { 0x2C, 0x38, 0x42, 0x4A, 0x4C, 0x4E, 0x58, 0x64, 0x6C, 0x6E } },
    { 0x19E0, { 0xBB8, 0x1770, 0x32C8, 0x6B6C, 0xD6D8, 0x1ADB0, 0x36EE8,
                NO_LEVEL, NO_LEVEL, NO_LEVEL, NO_LEVEL },
      { 0x2E, 0x36, 0x38, 0x3A, 0x40, 0x44, 0x4C, 0x5A, 0x60, 0x62, 0x6E } },
    { 0x1A7A, { 0x7D1, 0xFA1, 0x1F41, 0x4651, 0x88B9, 0x11171, 0x1E849,
                NO_LEVEL, NO_LEVEL, NO_LEVEL, NO_LEVEL },
      { 0 } },
    { 0x1B14, { 0x1388, 0x2710, 0x4844, 0x9088, 0x14C08, 0x222E0, 0x35B60,
                NO_LEVEL, NO_LEVEL, NO_LEVEL, NO_LEVEL },
      { 0 } },
    { 0x1BAE, { 0x1388, 0x2EE0, 0x5DC0, 0xAFC8, 0x17318, 0x2AB98, 0x55730,
                NO_LEVEL, NO_LEVEL, NO_LEVEL, NO_LEVEL },
      { 0x54, 0x5E, 0x6A } },
    { 0x1C48, { 0x1388, 0x2EE0, 0x6978, 0xEA60, 0x1E848, 0x30D40, 0x67C28,
                NO_LEVEL, NO_LEVEL, NO_LEVEL, NO_LEVEL },
      { 0x54, 0x5E, 0x6A } },
    { 0x1CE2, { 0x8CB, 0x1195, 0x2711, 0x4E21, 0x9C41, 0x15F91,
                NO_LEVEL, NO_LEVEL, NO_LEVEL, NO_LEVEL, NO_LEVEL },
      { 0 } },
    { 0x1D7C, { 0x1388, 0x2710, 0x4E20, 0x9470, 0xD6D8, 0x186A0, 0x30D40,
                NO_LEVEL, NO_LEVEL, NO_LEVEL, NO_LEVEL },
      { 0x2C, 0x38, 0x40, 0x42, 0x4A, 0x4E, 0x58, 0x60, 0x64, 0x6C, 0x6E } },
    { 0x1E16, { 0x1388, 0x2710, 0x4650, 0x8CA0, 0xC350, 0x15F90, 0x2BF20,
                NO_LEVEL, NO_LEVEL, NO_LEVEL, NO_LEVEL },
      { 0x2C, 0x38, 0x40, 0x42, 0x44, 0x4A, 0x4C, 0x58, 0x64, 0x6C, 0x6E } },
    { 0x1EB0, { 0x4E3, 0x9C5, 0x1389, 0x2711, 0x4E21, 0xA605, 0x11171,
                0x1ADB1, NO_LEVEL, NO_LEVEL, NO_LEVEL },
      { 0 } },
};

static void init_class_tables(void)
{
    unsigned c;

    for (c = 0; c < 10; ++c) {
        const ClassTable *t = &s_class_tables[c];
        unsigned i;
        unsigned level;
        unsigned j;

        for (i = 0; i < 11; ++i) {
            H005_SET_L(t->base + i * 4, t->xp[i]);
        }
        for (level = 2; level <= 12; ++level) {
            for (j = 1; j <= 5; ++j) {
                H005_SET_W(t->base + 0x2C + (level - 2) * 10 + (j - 1) * 2, 0);
            }
        }
        for (i = 0; i < 11 && t->ones[i] != 0; ++i) {
            H005_SET_W(t->base + t->ones[i], 1);
        }
    }
}

/* Voci 1..$41 della tabella a 4 byte di $3EF4 (byte 0 e 2) in un intervallo. */
static void table_3ef4_range(unsigned first, unsigned last, u8 b0)
{
    unsigned i;

    for (i = first; i <= last; ++i) {
        H005_B(0x3EF4 + (i - 1) * 4) = b0;
        H005_B(0x3EF4 + (i - 1) * 4 + 2) = 0;
    }
}

/* PORT H004+$0C1A */
void h004_init(void)
{
    unsigned i;
    unsigned j;
    unsigned k;

    APPLY(s_init_0c38);

    /* H004+$1A10 */
    for (i = 0; i <= 0x0F; ++i) {
        H005_B(0x3DA2 + i) = (u8)i;
        H005_B(0x3D92 + i) = (u8)i;
    }

    APPLY(s_init_1a48);

    /* H004+$1B86: 11 x 5 word a $3FF8. */
    for (i = 9; i <= 0x13; ++i) {
        for (j = 1; j <= 5; ++j) {
            H005_SET_W(0x3FF8 + (i - 9) * 10 + (j - 1) * 2, 0);
        }
    }

    APPLY(s_init_1bd4);

    /* H004+$1CBC: $41 voci da 4 byte a $3EF4. */
    for (i = 1; i <= 0x41; ++i) {
        u16 p = (u16)(0x3EF4 + (i - 1) * 4);

        H005_B(p) = 0xFF;
        H005_B(p + 1) = 1;
        H005_B(p + 2) = 2;
        H005_B(p + 3) = (u8)(i - 1);
        if (i > 0x19) {
            H005_B(p + 3) = (u8)(i + 8);
        }
        if (i > 0x1F) {
            H005_B(p + 3) = (u8)(i - 0x20);
        }
    }

    APPLY(s_init_1d28);

    /* H004+$1DA6..$1F5A */
    table_3ef4_range(0x1B, 0x1F, 1);
    table_3ef4_range(0x26, 0x29, 1);
    table_3ef4_range(0x2C, 0x2F, 1);
    table_3ef4_range(0x30, 0x35, 2);
    table_3ef4_range(0x36, 0x3C, 1);
    for (i = 0x3D; i <= 0x3F; ++i) {
        H005_B(0x3EF4 + (i - 1) * 4) = 4;
        H005_B(0x3EF4 + (i - 1) * 4 + 1) = 0;
        H005_B(0x3EF4 + (i - 1) * 4 + 2) = 0;
    }
    table_3ef4_range(0x40, 0x41, 1);

    APPLY(s_init_1f5c);

    /* H004+$3CB8 */
    for (i = 7; i <= 0x0E; ++i) {
        H005_SET_W(0x1F4A + (i - 3) * 2, 0);
    }

    APPLY(s_init_3ce0);

    /* H004+$3CE8 */
    for (i = 0x10; i <= 0x19; ++i) {
        H005_SET_W(0x1F4A + (i - 3) * 2, 2);
    }
    init_class_tables();

    APPLY(s_init_4504);

    /* H004+$5484: 3 x 4 x 10 word a $1476. */
    for (i = 1; i <= 3; ++i) {
        for (j = 1; j <= 4; ++j) {
            for (k = 1; k <= 10; ++k) {
                H005_SET_W(0x1476 + (i - 1) * 0x50 + (j - 1) * 0x14 +
                           (k - 1) * 2, 0);
            }
        }
    }

    APPLY(s_init_54f8);

    /* H004+$5E9E */
    H005_SET_L(0x0000, 1);
    H005_SET_L(0x0004, 5);
    H005_SET_L(0x0008, 0x0A);
    H005_SET_L(0x000C, 0x19);
    H005_SET_L(0x0010, 0x32);

    APPLY(s_init_5ec6);
}

/* PORT H004+$0C28: link/unlk/rts, nessun effetto. */
void h004_0c28(void)
{
}
