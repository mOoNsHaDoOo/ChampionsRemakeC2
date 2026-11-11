/*
 * Dati prodotti dall'inizializzazione di un modulo, confrontati con
 * l'emulazione dell'assembly.  Per i dati del modulo (sotto a4):
 *   python3 scripts/emu68k_init.py 44 84A h044.bin --bss B6
 *   ./bss_test h044 h044.bin
 * Per H005 (moduli che scrivono solo H005, partendo da H005 azzerato):
 *   python3 scripts/emu68k_init.py 32 22 h032.bin
 *   ./bss_test h032 h032.bin
 */
#include <stdio.h>
#include <string.h>
#include "../cok.h"
#include "../globals.h"

#define MOD(n, size) extern u8 g_##n##_bss[size]; void n##_init(void);
MOD(h044, 0xB6) MOD(h011, 0xAC) MOD(h095, 0x342) MOD(h097, 0x42)
MOD(h072, 0xC) MOD(h085, 0x292) MOD(h057, 0xA8)
void h032_init(void);

#define ENTRY(n) { #n, n##_init, g_##n##_bss, sizeof(g_##n##_bss) }
static const struct {
    const char *name;
    void (*init)(void);
    u8 *data;
    size_t size;
} s_modules[] = {
    ENTRY(h044), ENTRY(h011), ENTRY(h095), ENTRY(h097), ENTRY(h072),
    ENTRY(h085), ENTRY(h057), { "h032", h032_init, g_h005, H005_SIZE },
};

int main(int argc, char **argv)
{
    static u8 expected[H005_SIZE];
    size_t m;
    size_t i;
    unsigned diffs = 0;
    FILE *f;

    for (m = 0; argc >= 3 && m < sizeof(s_modules) / sizeof(s_modules[0]); ++m) {
        if (strcmp(argv[1], s_modules[m].name) == 0) {
            break;
        }
    }
    if (argc < 3 || m == sizeof(s_modules) / sizeof(s_modules[0])) {
        printf("uso: bss_test modulo atteso.bin\n");
        return 2;
    }
    s_modules[m].init();
    if ((f = fopen(argv[2], "rb")) == NULL ||
        fread(expected, 1, s_modules[m].size, f) != s_modules[m].size) {
        printf("file atteso non valido\n");
        return 2;
    }
    fclose(f);
    for (i = 0; i < s_modules[m].size; ++i) {
        if (s_modules[m].data[i] != expected[i]) {
            if (diffs < 10) {
                printf("byte %lu: C $%02X, asm $%02X\n", (unsigned long)i,
                       s_modules[m].data[i], expected[i]);
            }
            ++diffs;
        }
    }
    printf("%s: %lu byte, %u differenze\n", s_modules[m].name,
           (unsigned long)s_modules[m].size, diffs);
    return diffs != 0;
}
