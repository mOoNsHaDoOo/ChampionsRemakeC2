/*
 * H004+$0C1A: the H005 image produced by the C must match byte for
 * byte the one of the emulator on the assembly:
 *   python3 scripts/emu68k_init.py 4 C38 h005_expected.bin
 *   ./h004_test h005_expected.bin
 */
#include <stdio.h>
#include "../globals.h"
#include "../h004_init.h"

int main(int argc, char **argv)
{
    static u8 expected[H005_SIZE];
    FILE *f;
    size_t i;
    unsigned diffs = 0;

    if (argc < 2 || (f = fopen(argv[1], "rb")) == NULL) {
        printf("usage: h004_test h005_expected.bin\n");
        return 2;
    }
    if (fread(expected, 1, H005_SIZE, f) != H005_SIZE) {
        printf("expected image too short\n");
        return 2;
    }
    fclose(f);
    h004_init();
    for (i = 0; i < H005_SIZE; ++i) {
        if (g_h005[i] != expected[i]) {
            if (diffs < 20) {
                printf("H005+$%04X: C %02X, asm %02X\n", (unsigned)i,
                       g_h005[i], expected[i]);
            }
            ++diffs;
        }
    }
    if (diffs) {
        printf("%u bytes differ\n", diffs);
        return 1;
    }
    printf("H005 identical to the emulation of H004+$0C1A\n");
    return 0;
}
