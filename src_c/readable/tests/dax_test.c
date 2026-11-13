/*
 * Extracts block id from the container name+ext with DAX_LoadBlock (H028) and
 * writes it to out (decompressed bytes, declared size + $100).
 * Comparison: scripts/check_dax.py.
 *   ./dax_test 8x8d1 .daa 202 out.bin
 */
#include <stdio.h>
#include <stdlib.h>
#include "../h028_files.h"
#include "../globals.h"
#include "../h040.h"

/* Error message (H014+$0018) and exit: here they report and go on. */
void error_message(u16 len, const char *msg, u16 value)
{
    (void)len;
    printf("H014 error: %s %u\n", msg, value);
}

void quit_game(void)
{
    printf("exit H010+$0332\n");
    exit(3);
}

/* The ILBM reader (H040) is not needed by the DAX test. */
s32 read_ilbm(cok_bptr file, struct BitMap *bitmap, ILBMFrame *frame,
              IlbmAllocFn alloc)
{
    (void)file;
    (void)bitmap;
    (void)frame;
    (void)alloc;
    return 0;
}

int main(int argc, char **argv)
{
    u16 size = 0;
    u8 *data = NULL;
    FILE *out;

    if (argc < 5) {
        printf("usage: dax_test name .ext id out.bin\n");
        return 2;
    }
    G_RESOURCE_GROUP = 1;
    dax_load_block((u16)strlen(argv[1]), argv[1], (u16)strlen(argv[2]),
                   argv[2], (u16)atoi(argv[3]), &size, &data);
    out = fopen(argv[4], "wb");
    if (data != NULL) {
        fwrite(data, 1, size, out);
    }
    fclose(out);
    return data != NULL ? 0 : 1;
}
