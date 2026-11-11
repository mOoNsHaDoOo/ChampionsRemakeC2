/*
 * H003: adattatori exec.library.  Sull'host la memoria viene da malloc;
 * MEMF_CLEAR azzera il blocco come fa AllocMem.
 */
#include "h003_exec.h"

#if !COK_AMIGA
#include <stdlib.h>
#endif

/* PORT H003+$0004: inizializzazione del modulo (solo rts). */
void h003_init(void)
{
}

/* PORT H003+$0068 */
void *exec_alloc_mem(u32 size, u32 flags)
{
#if COK_AMIGA
    return AllocMem(size, flags);
#else
    void *p = malloc(size != 0 ? size : 1);

    if (p != NULL && (flags & COK_MEMF_CLEAR) != 0) {
        memset(p, 0, size);
    }
    return p;
#endif
}

/* PORT H003+$00F6 */
void exec_free_mem(void *block, u32 size)
{
#if COK_AMIGA
    FreeMem(block, size);
#else
    (void)size;
    free(block);
#endif
}

/* PORT H003+$007E */
u32 exec_avail_mem(u32 requirements)
{
    return (u32)AvailMem(requirements);
}

/*
 * PORT H003+$0090.  CopyMem non ammette sovrapposizioni (EA usava movmem):
 * sull'host si usa memmove, che da' lo stesso risultato senza
 * sovrapposizione e uno ben definito con.
 */
void exec_copy_mem(const void *src, void *dst, u32 size)
{
#if COK_AMIGA
    CopyMem((APTR)src, (APTR)dst, size);
#else
    memmove(dst, src, size);
#endif
}
