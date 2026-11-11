/*
 * Legge un file ILBM con Read_ILBM (H040) e scrive su out: w, h, piani
 * (word big-endian), numero di colori (byte), i colori RGB4 (word) e i
 * piani della bitmap.  Confronto: scripts/check_ilbm.py.
 *   ./ilbm_test file.lbm out.bin
 */
#include <stdio.h>
#include <stdlib.h>
#include "../h040.h"

static u32 s_size;

static u8 *alloc_planes(u32 size)
{
    s_size = size;
    return (u8 *)calloc(1, size);
}

int main(int argc, char **argv)
{
    struct BitMap bm;
    ILBMFrame frame;
    cok_bptr file;
    s32 iffp;
    FILE *out;
    int i;

    if (argc < 3) {
        printf("uso: ilbm_test file.lbm out.bin\n");
        return 2;
    }
    memset(&bm, 0, sizeof(bm));
    file = dos_open(argv[1], MODE_OLDFILE);
    if (file == 0) {
        printf("%s: non trovato\n", argv[1]);
        return 2;
    }
    iffp = read_ilbm(file, &bm, &frame, alloc_planes);
    dos_close(file);
    printf("%s: iffp %ld, %ux%u, %u piani, %u colori\n", argv[1], (long)iffp,
           frame.bm_hdr.w, frame.bm_hdr.h, bm.Depth, frame.n_color_regs);
    out = fopen(argv[2], "wb");
    fputc(bm.BytesPerRow >> 8, out); fputc(bm.BytesPerRow & 0xFF, out);
    fputc(bm.Rows >> 8, out); fputc(bm.Rows & 0xFF, out);
    fputc(0, out); fputc(bm.Depth, out);
    fputc(frame.n_color_regs, out);
    for (i = 0; i < frame.n_color_regs; ++i) {
        fputc(frame.color_map[i] >> 8, out);
        fputc(frame.color_map[i] & 0xFF, out);
    }
    for (i = 0; i < bm.Depth; ++i) {
        fwrite(bm.Planes[i], 1, (size_t)bm.BytesPerRow * bm.Rows, out);
    }
    fclose(out);
    return iffp == IFF_DONE ? 0 : 1;
}
