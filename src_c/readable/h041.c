/* H041: Memoria per le immagini: blocco preceduto dalla dimensione di allocazione. */
#include "h041.h"
#include "h003_exec.h"

/* PORT H041+$0004: link/unlk, nessun effetto. */
void h041_init(void)
{
}

/*
 * PORT H041+$000C: AllocMem di size + 4 byte; la dimensione totale va nella
 * prima long, il chiamante riceve l'indirizzo dopo (0 se manca memoria).
 */
u8 *sized_alloc(u32 flags, u32 size)
{
    u8 *p;

    size += 4;
    p = (u8 *)exec_alloc_mem(size, flags);
    if (p != NULL) {
        *(u32 *)p = size;
        p += 4;
    }
    return p;
}

/* PORT H041+$004A: sized_alloc in memoria chip azzerata ($10003). */
u8 *sized_alloc_chip(u32 size)
{
    return sized_alloc(0x10003UL, size);
}

/* PORT H041+$00BE: libera un blocco di sized_alloc (NULL ignorato). */
void sized_free(void *block)
{
    if (block != NULL) {
        u8 *p = (u8 *)block - 4;

        exec_free_mem(p, *(u32 *)p);
    }
}
