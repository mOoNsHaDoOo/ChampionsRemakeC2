/*
 * Estrae il blocco id dal contenitore name+ext con DAX_LoadBlock (H028) e
 * lo scrive in out (byte decompressi, dimensione dichiarata + $100).
 * Confronto: scripts/check_dax.py.
 *   ./dax_test 8x8d1 .daa 202 out.bin
 */
#include <stdio.h>
#include <stdlib.h>
#include "../h028_files.h"
#include "../globals.h"
#include "../h040.h"

/* Messaggio di errore (H014+$0018) e uscita: qui segnalano e proseguono. */
void error_message(u16 len, const char *msg, u16 value)
{
    (void)len;
    printf("errore H014: %s %u\n", msg, value);
}

void quit_game(void)
{
    printf("uscita H010+$0332\n");
    exit(3);
}

/* Il lettore ILBM (H040) non serve al test dei DAX. */
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
        printf("uso: dax_test nome .ext id out.bin\n");
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
