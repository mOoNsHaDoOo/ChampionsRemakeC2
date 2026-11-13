/* H041: Memory for the pictures: block preceded by the allocation size. */
#include "h041.h"
#include "h003_exec.h"

/* PORT H041+$0004: link/unlk, no effect. */
void h041_init(void)
{
}

/*
 * PORT H041+$000C: AllocMem of size + 4 bytes; the total size goes in the
 * first long, the caller gets the address after it (0 if out of memory).
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

/* PORT H041+$004A: sized_alloc in cleared chip memory ($10003). */
u8 *sized_alloc_chip(u32 size)
{
    return sized_alloc(0x10003UL, size);
}

/* PORT H041+$00BE: frees a sized_alloc block (NULL ignored). */
void sized_free(void *block)
{
    if (block != NULL) {
        u8 *p = (u8 *)block - 4;

        exec_free_mem(p, *(u32 *)p);
    }
}
