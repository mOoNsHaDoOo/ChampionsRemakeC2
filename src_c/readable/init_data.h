/*
 * Applicatore comune delle tabelle di costanti generate da
 * scripts/gen_init_data.py (inizializzazioni dei moduli).
 */
#ifndef COK_INIT_DATA_H
#define COK_INIT_DATA_H

#include "cok.h"

enum { INIT_STR, INIT_BYTES, INIT_WCOPY, INIT_B, INIT_W, INIT_L };
enum { INIT_H005, INIT_BSS };

typedef struct InitOp {
    u8 kind;          /* INIT_STR ... INIT_L */
    u8 space;         /* INIT_H005: offset in H005; INIT_BSS: -dst(a4) */
    u16 dst;
    u32 value;        /* valore, limite dbeq (STR), conteggio (BYTES) */
    const char *text;
} InitOp;

/*
 * Applica n operazioni.  bss/bss_size: dati del modulo sotto a4, cioe'
 * -off(a4) e' bss[bss_size - off].
 */
void init_apply(const InitOp *op, size_t n, u8 *bss, size_t bss_size);

#define INIT_APPLY(table, bss, size) \
    init_apply(table, sizeof(table) / sizeof(table[0]), bss, size)

#endif
