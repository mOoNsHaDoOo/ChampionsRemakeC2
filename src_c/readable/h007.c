/* H007: Introduzione: immagini LBM, crediti e avvio audio. */
#include "h007.h"
#include "h003_exec.h"
#include "h010_input.h"
#include "h011.h"
#include "h016_gfx.h"
#include "h021_intuition.h"
#include "h022_view.h"
#include "h028_files.h"
#include "h030.h"
#include "h036.h"
#include "h038.h"
#include "h040.h"
#include "h042_seq.h"
#include "h044_tiles.h"
#include "globals.h"
#include "unported.h"

/* PORT H007+$02C0: link/unlk, nessun effetto. */
void h007_init(void)
{
}

/*
 * Dati del modulo (a4 = H007+$72):
 *   +$000 "Insert Disk One in drive df0" (richiesta del disco)
 *   +$01D..+$1EA testi dei crediti   +$1F8.. nomi delle immagini
 *   -$6C  palette di 32 colori RGB4 (word)
 *   -$6D  risultato di Open_ResourceFile    -$72 file aperto
 *   -$28  BitMap dell'immagine caricata      -$2C dimensione dei piani
 */
static u16 s_palette[32];               /* -$6C(a4) */
static u8 s_open_result;                /* -$6D(a4) */
static cok_bptr s_file;                 /* -$72(a4) */
static struct BitMap s_bitmap;          /* -$28(a4) */
static u32 s_alloc_size;                /* -$2C(a4) */

static const char s_insert_disk[] = "Insert Disk One in drive df0";

/* PORT H007+$02CE: allocatore dei piani per Read_ILBM (chip, azzerata). */
static u8 *alloc_picture_planes(u32 size)
{
    s_alloc_size = size;
    return (u8 *)exec_alloc_mem(size, COK_MEMF_CHIP | COK_MEMF_CLEAR);
}

/* PORT H007+$0304: separa un colore RGB4 nelle tre componenti. */
static void split_rgb4(s16 *blue, s16 *green, s16 *red, u16 color)
{
    *blue = (s16)(color & 0x0F);
    *green = (s16)((s16)(color & 0xF0) >> 4);
    *red = (s16)((s16)(color & 0xF00) >> 8);
}

/* PORT H007+$0348: ricompone un colore RGB4 limitando le componenti a 0..15. */
static u16 make_rgb4(s16 red, s16 green, s16 blue)
{
    if (red < 0) {
        red = 0;
    }
    if (green < 0) {
        green = 0;
    }
    if (blue < 0) {
        blue = 0;
    }
    if (red > 0x0F) {
        red = 0x0F;
    }
    if (green > 0x0F) {
        green = 0x0F;
    }
    if (blue > 0x0F) {
        blue = 0x0F;
    }
    return (u16)((red << 8) + (green << 4) + blue);
}

/*
 * PORT H007+$03CA: dissolvenza della palette in 16 passi, uno per quadro:
 * fade_in = 0 verso il nero, 1 dal nero.
 */
static void fade_palette(u8 fade_in)
{
    u8 colors[64];                      /* -$4C(a5): RGB4 big-endian */
    s16 step;
    s16 amount;
    s16 i;
    s16 blue;
    s16 green;
    s16 red;

    for (step = 0; step <= 0x0F; ++step) {
        amount = fade_in ? (s16)(0x0F - step) : step;
        for (i = 0; i <= 0x1F; ++i) {
            split_rgb4(&blue, &green, &red, s_palette[i]);
            red = (s16)(red - amount);
            blue = (s16)(blue - amount);
            green = (s16)(green - amount);
            COK_PUT16(&colors[i * 2], make_rgb4(red, green, blue));
        }
        graphics_wait_tof();
        graphics_load_rgb4(&g_screen->ViewPort, colors, 0x20);
    }
}

/* Carica s_palette (32 colori) nel ViewPort dello schermo. */
static void load_palette(void)
{
    u8 colors[64];
    int i;

    for (i = 0; i < 32; ++i) {
        COK_PUT16(&colors[i * 2], s_palette[i]);
    }
    graphics_load_rgb4(&g_screen->ViewPort, colors, 0x20);
}

/* PORT H007+$04A0: palette tutta nera. */
static void black_palette(void)
{
    s16 i;

    for (i = 0; i <= 0x1F; ++i) {
        s_palette[i] = 0;
    }
    load_palette();
    graphics_wait_tof();
}

/*
 * PORT H007+$04F2 (Intro_LoadLBM): legge un'immagine ILBM e la copia nello
 * schermo da (dx, dy) per width x height.  fade_out: prima dissolve verso
 * il nero la palette attuale; fade_in: parte dal nero e dissolve verso
 * quella dell'immagine (altrimenti la carica subito).
 */
static void load_intro_picture(u16 dx, u16 dy, u16 width, u16 height,
                               u16 name_len, const char *name, u8 fade_out,
                               u8 fade_in)
{
    ILBMFrame frame;                    /* -$6C(a5) */
    s32 iffp;                           /* -$4(a5) */
    s16 i;

    s_open_result = open_resource_file(name_len, name, 0x1C, s_insert_disk,
                                       1, &s_file);
    if (s_file == 0) {
        return;
    }
    /* Il frame dell'originale e' sullo stack non inizializzato: qui a zero. */
    memset(&frame, 0, sizeof(frame));
    for (i = 0; i <= 4; ++i) {
        s_bitmap.Planes[i] = NULL;
    }
    iffp = read_ilbm(s_file, &s_bitmap, &frame, alloc_picture_planes);
    dos_close(s_file);
    if (iffp >= IFF_DONE) {
        if (fade_out) {
            fade_palette(0);
        } else if (fade_in) {
            black_palette();
        }
        for (i = 0; i < 32; ++i) {
            s_palette[i] = frame.color_map[i];
        }
        (void)graphics_blt_bitmap(&s_bitmap, 0, 0, &g_screen->BitMap, dx, dy,
                                  width, height, 0xCA, 0xFF, NULL);
        if (fade_in) {
            fade_palette(1);
        } else {
            load_palette();
        }
    }
    exec_free_mem(s_bitmap.Planes[0], s_alloc_size);
}

/*
 * PORT H007+$064E: attende seconds secondi (passi di Delay(5), un decimo
 * di secondo) leggendo l'input; restituisce 1 se un tasto l'ha interrotta.
 */
static u8 intro_wait(u16 seconds)
{
    u16 count = 0;
    u16 limit = (u16)(seconds * 10);

    do {
        dos_delay(5);
        ++count;
        poll_intuition_events();
        if (G_KEY != 0) { /* $5305: tasto/azione pendente dall'input (G_KEY) */
            break;
        }
    } while (count < limit);
    return (u8)(count < limit);
}

/* PORT H007+$06B4: cancella lo schermo (penna 0, 320x200). */
static void clear_screen(void)
{
    graphics_set_apen(g_rastport, 0);
    graphics_rect_fill(g_rastport, 0, 0, 0x140, 0xC8);
}

/* Testi dei crediti (H007+$06EA): colonna, riga, penna, sfondo, lunghezza. */
static const struct {
    u8 col;
    u8 row;
    u8 fg;
    u8 bg;
    u8 len;
    const char *text;
} s_credits[] = {
    { 5, 1, 5, 0, 0x1E, "based on an original story by:" },
    { 15, 2, 14, 0, 0x08, "Jim Ward" },
    { 4, 3, 14, 0, 0x0E, "Victor Penman," },
    { 19, 3, 5, 0, 0x03, "and" },
    { 24, 3, 14, 0, 0x0C, "Dave Shelley" },
    { 2, 5, 5, 0, 0x10, "game created by:" },
    { 18, 5, 12, 0, 0x14, "SSI Special Projects" },
    { 2, 7, 12, 0, 0x11, "Project Director:" },
    { 20, 7, 14, 0, 0x0D, "Victor Penman" },
    { 2, 9, 12, 0, 0x0B, "Programming" },
    { 2, 10, 14, 0, 0x0A, "Norm Koger" },
    { 2, 11, 14, 0, 0x0A, "Russ Brown" },
    { 2, 12, 14, 0, 0x0F, "Michael McNally" },
    { 20, 9, 12, 0, 0x10, "Encounter Design" },
    { 20, 10, 14, 0, 0x0C, "Dave Shelley" },
    { 20, 11, 14, 0, 0x0F, "Michael Mancuso" },
    { 20, 12, 14, 0, 0x0D, "Ken Humphries" },
    { 2, 14, 12, 0, 0x0D, "Graphic Arts:" },
    { 2, 15, 14, 0, 0x21, "Laura Bowen, Tom Wahl, Fred Butts" },
    { 2, 16, 14, 0, 0x25, "Mark Johnson, Cyrus Lum, Susan Manley" },
    { 2, 18, 12, 0, 0x09, "playtest:" },
    { 12, 18, 14, 0, 0x1A, "Rick White, Tom Schumacher" },
    { 2, 19, 14, 0, 0x21, "Erik Flom, John Kirk, Dave Lucca," },
    { 2, 20, 14, 0, 0x24, "Don McClure, L.S.Webber, Rick Wilson" },
    { 2, 22, 12, 0, 0x0E, "Musical score:" },
    { 20, 22, 14, 0, 0x0D, "john halblieb" },
};

/* PORT H007+$06EA: pagina dei crediti dentro la cornice. */
static void show_credits(void)
{
    size_t i;

    draw_credits_frame();
    for (i = 0; i < sizeof(s_credits) / sizeof(s_credits[0]); ++i) {
        ui_draw_text(s_credits[i].col, s_credits[i].row, s_credits[i].fg,
                     s_credits[i].bg, s_credits[i].len, s_credits[i].text);
    }
}

/*
 * PORT H007+$09D8 (Intro_LoadAndShow): introduzione.  Dopo un secondo (se
 * nessun tasto) avvia la musica, nasconde il puntatore, verifica il disco
 * uno, poi per tre volte: "scrn1b", "scrn2", i due testi e i crediti, con
 * tre secondi ciascuno; un tasto interrompe.  Alla fine prepara la palette
 * del gioco e i comandi audio $FE e $FD.
 */
void play_intro(void)
{
    u8 interrupted;                     /* -$1(a5) */
    u8 *pointer;                        /* -$8(a5) */
    s16 round;                          /* -$4(a5) */

    interrupted = intro_wait(1);
    h043_0584();
    if (!interrupted) {
        release_picture_set();
        pointer = (u8 *)exec_alloc_mem(8, COK_MEMF_CHIP | COK_MEMF_CLEAR);
        intuition_set_pointer(g_window, pointer, 1, 1, 0, 0);
        s_open_result = open_resource_file(0x0A, "scrn1b.lbm", 0x1C,
                                           s_insert_disk, 1, &s_file);
        dos_close(s_file);
        if (H005_B(0x3D79) != 2) { /* $3D79: uso: se diverso da 2 l'introduzione suona l'effetto $17 */
            h043_190e(0x17);
        }
        black_palette();
        round = 0;
        while (round != 3 && !interrupted) {
            ++round;
            if (!interrupted) {
                load_intro_picture(0, 0, 0x140, 0xC8, 0x0A, "scrn1b.LBM", 1, 1);
                interrupted = intro_wait(3);
            }
            if (!interrupted) {
                load_intro_picture(0, 0, 0x140, 0xC8, 9, "scrn2.LBM", 1, 1);
                interrupted = intro_wait(3);
            }
            if (!interrupted) {
                load_intro_picture(0x28, 8, 0xF0, 0x58, 9, "text1.LBM", 0, 0);
                interrupted = intro_wait(3);
            }
            if (!interrupted) {
                load_intro_picture(0, 8, 0x140, 0x58, 9, "text2.LBM", 0, 0);
                interrupted = intro_wait(3);
            }
            if (!interrupted) {
                fade_palette(0);
                clear_screen();
                show_credits();
                interrupted = intro_wait(3);
            }
        }
        intuition_clear_pointer(g_window);
        exec_free_mem(pointer, 8);
    }
    clear_screen();
    load_game_palette();
    h043_190e(0xFE);
    h043_190e(0xFD);
    H005_B(0x24C9) = 1; /* $24C9: uso: posto a 1 nell'introduzione (H007), mai letto */
}
