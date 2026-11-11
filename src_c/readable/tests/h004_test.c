/*
 * H004+$0C1A: l'immagine di H005 prodotta dal C deve coincidere byte per
 * byte con quella dell'emulatore sull'assembly:
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
        printf("uso: h004_test h005_expected.bin\n");
        return 2;
    }
    if (fread(expected, 1, H005_SIZE, f) != H005_SIZE) {
        printf("immagine attesa troppo corta\n");
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
        printf("%u byte diversi\n", diffs);
        return 1;
    }
    printf("H005 identico all'emulazione di H004+$0C1A\n");
    return 0;
}
