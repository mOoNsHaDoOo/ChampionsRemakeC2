/*
 * H003: exec.library adapters.  On the host the memory comes from malloc;
 * MEMF_CLEAR clears the block like AllocMem does.
 */
#include "h003_exec.h"

#if !COK_AMIGA
#include <stdlib.h>
#endif

/* PORT H003+$0004: module initialisation (rts only). */
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
 * PORT H003+$0090.  CopyMem does not allow overlaps (EA used movmem):
 * on the host memmove is used, which gives the same result without
 * overlap and a well-defined one with it.
 */
void exec_copy_mem(const void *src, void *dst, u32 size)
{
#if COK_AMIGA
    CopyMem((APTR)src, (APTR)dst, size);
#else
    memmove(dst, src, size);
#endif
}
