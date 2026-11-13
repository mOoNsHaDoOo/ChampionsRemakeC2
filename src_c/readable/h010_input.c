/* H010: Intuition input, event conversion, exit and errors. */
#include <stdio.h>
#include "h010_input.h"
#include "h045.h"
#include "character.h"
#include "h053.h"
#include "h050.h"
#include "h002_dos.h"
#include "h003_exec.h"
#include "h015_runtime.h"
#include "h026_string.h"
#include "h028_files.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h042_seq.h"
#include "globals.h"
#include "unported.h"
#include "h020_io.h"

/* Modifiers held down (H010+$043C). */
u8 g_input_alt;                 /* -$53(a4) */
u8 g_input_shift;               /* -$54(a4) */
u8 g_input_ctrl;                /* -$55(a4) */

/* PORT H010+$00B6 */
void h010_init(void)
{
    g_input_alt = 0;
    g_input_shift = 0;
    g_input_ctrl = 0;
}

/*
 * Conversion of the RAWKEY codes 1..$4F (jump table H010+$0712): the
 * ASCII character, 0 for the keys without a meaning.  Keypad and arrows
 * give the direction digits (up 8, down 2, right 6, left 4).
 */
static const u8 s_rawkey_ascii[0x4F] = {
    '1', '2', '3', '4', '5', '6', '7', '8', '9', '0',   /* $01..$0A */
    0, 0, 0, 0, '0',                                    /* $0B..$0F */
    'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',   /* $10..$19 */
    0, 0, 0, '1', '2', '3',                             /* $1A..$1F */
    'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';',   /* $20..$29 */
    '\'', 0, 0, '4', '5', '6', 0,                        /* $2A..$30 */
    'z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.',        /* $31..$39 */
    0, 0, 0, '7', '8', '9',                             /* $3A..$3F */
    ' ', 0x08, 0, 0x0D, 0x0D, 0x1B, 0x10,               /* $40..$46 */
    0, 0, 0, 0, 0,                                      /* $47..$4B */
    '8', '2', '6', '4'                                  /* $4C..$4F */
};

/* Module data below a4: -$52(a4), $52-byte text. */
static char s_free_text[0x52];

/*
 * PORT H010+$03AA (key 'c'): "max free block is NNNNNNNN bytes." at the
 * top left, with the largest free block (MEMF_LARGEST).
 */
static void show_free_memory(void)
{
    format_number(0x50, s_free_text,
                  (s32)exec_avail_mem(0x00020000UL), 0, 0x0A, 8, '0');
    h026_insert(0x50, s_free_text, 0x12, "max free block is ", 0);
    h026_append(0x50, s_free_text, 7, " bytes.");
    ui_draw_text(1, 1, 0x0F, 0, 0x50, s_free_text);
}

/*
 * PORT H010+$043C: converts the RAWKEY code into G_KEY.  Shift, Ctrl and Alt
 * (pressed $60/$61, $63, $64/$65; released with bit 7) update the
 * flags and clear the key; releases of the other keys give 0.  With Alt
 * pressed (and without Shift/Ctrl) the flag is cleared and a, m, q, x become
 * 1..4, c shows the free memory (H010+$03AA); the other keys set it
 * again.
 */
static void convert_rawkey(void)
{
    u8 key = G_KEY; /* $5305: key/action pending from the input (G_KEY) */

    if (key == 0x60 || key == 0x61) {
        g_input_shift = 1;
        G_KEY = 0; /* $5305: key/action pending from the input (G_KEY) */
    } else if (key == 0xE0 || key == 0xE1) {
        g_input_shift = 0;
        G_KEY = 0; /* $5305: key/action pending from the input (G_KEY) */
    } else if (key == 0x64 || key == 0x65) {
        g_input_alt = 1;
        G_KEY = 0; /* $5305: key/action pending from the input (G_KEY) */
    } else if (key == 0xE4 || key == 0xE5) {
        g_input_alt = 0;
        G_KEY = 0; /* $5305: key/action pending from the input (G_KEY) */
    } else if (key == 0x63) {
        g_input_ctrl = 1;
        G_KEY = 0; /* $5305: key/action pending from the input (G_KEY) */
    } else if (key == 0xE3) {
        g_input_ctrl = 0;
        G_KEY = 0; /* $5305: key/action pending from the input (G_KEY) */
    } else {
        u16 index = (u16)(key - 1);

        /* $5305: key/action pending from the input (G_KEY) */
        G_KEY = index <= 0x4E ? s_rawkey_ascii[index] : 0;
    }
    if (g_input_shift || g_input_ctrl || !g_input_alt) {
        return;
    }
    g_input_alt = 0;
    switch (G_KEY) { /* $5305: key/action pending from the input (G_KEY) */
    case 'a':
        G_KEY = 1; /* $5305: key/action pending from the input (G_KEY) */
        break;
    case 'm':
        G_KEY = 2; /* $5305: key/action pending from the input (G_KEY) */
        break;
    case 'q':
        G_KEY = 3; /* $5305: key/action pending from the input (G_KEY) */
        break;
    case 'x':
        G_KEY = 4; /* $5305: key/action pending from the input (G_KEY) */
        break;
    case 'c':
        show_free_memory();
        break;
    default:
        g_input_alt = 1;
        break;
    }
}

/*
 * PORT H010+$042E (body at H010+$0882, Poll_IntuitionEvents): drains the
 * IDCMP port of the window.  The first key (RAWKEY) goes into G_KEY and is
 * converted; a click (MOUSEBUTTONS) updates the mouse position
 * (H005+$2356/$2354) and the left button counts as Enter, the right one as Esc, with
 * G_MOUSE_CLICK = 1.
 * PORT H010+$0882 (Poll_IntuitionEvents): the body, here in the same function.
 */
void poll_intuition_events(void)
{
    struct IntuiMessage *msg;

    G_KEY = 0; /* $5305: key/action pending from the input (G_KEY) */
    G_MOUSE_CLICK = 0; /* $249E: 1 if the key comes from the mouse (click) */
    do {
        msg = (struct IntuiMessage *)exec_get_msg(g_window->UserPort);
        if (msg != NULL) {
            if (msg->Class == 0x400) {             /* RAWKEY */
                if (G_KEY == 0) { /* $5305: key/action pending from the input (G_KEY) */
                    G_KEY = (u8)msg->Code; /* $5305: key/action pending from the input (G_KEY) */
                    convert_rawkey();
                }
            } else if (msg->Class == 0x8) {        /* MOUSEBUTTONS */
                H005_SET_W(0x2356, (u16)msg->MouseX); /* $2356: mouse X (word, initial $A0) */
                H005_SET_W(0x2354, (u16)msg->MouseY); /* $2354: mouse Y (word, initial $64) */
                if (msg->Code == 0x68) {           /* SELECTDOWN */
                    G_KEY = 0x0D; /* $5305: key/action pending from the input (G_KEY) */
                    G_MOUSE_CLICK = 1; /* $249E: 1 if the key comes from the mouse (click) */
                } else if (msg->Code == 0x69) {    /* MENUDOWN */
                    G_KEY = 0x1B; /* $5305: key/action pending from the input (G_KEY) */
                    G_MOUSE_CLICK = 1; /* $249E: 1 if the key comes from the mouse (click) */
                }
            }
            exec_reply_msg(&msg->ExecMessage);
        }
    } while (msg != NULL);
}

/* PORT H010+$0974: waits on the IDCMP port until a key arrives. */
void wait_for_key(void)
{
    do {
        (void)exec_wait_port(g_window->UserPort);
        poll_intuition_events();
    } while (G_KEY == 0); /* $5305: key/action pending from the input (G_KEY) */
}

/*
 * PORT H010+$00C4: frees the game resources: character screens,
 * state blocks, graphic records, tile and sprite sets, the picture
 * set, the party characters, the blocks $52FC/$5300 and the font.
 * When installed on a hard disk (prefix other than "df0:"), removes the
 * Assigns of the three disks.
 */
static void free_game_resources(void)
{
    u16 i;
    u16 j;

    free_char_screens();
    exec_free_mem(g_state_a, 0x800);
    exec_free_mem(g_state_b, 0x800);
    exec_free_mem(g_state_c, 0x400);
    exec_free_mem(g_ecl_buffer, 0x1E00);
    exec_free_mem(g_h005_282e, 0x924);
    exec_free_mem(g_geo_planes, 0x400);
    free_gfx_record(&g_gfx_3334);
    free_gfx_record(&g_gfx_3d8a);
    free_gfx_record(&g_gfx_sky_2804);
    free_gfx_record(&g_gfx_sky_2808);
    free_gfx_record(&g_gfx_sky_280c);
    free_gfx_record(&g_gfx_332c);
    for (i = 1; i <= 2; ++i) {
        free_gfx_record(&g_gfx_27b0[i - 1]);
    }
    for (i = 0; i <= 4; ++i) {
        free_gfx_record(&g_8x8_sets[i]);
    }
    for (i = 0; i <= 0x1C; ++i) {
        for (j = 0; j <= 1; ++j) {
            free_gfx_record(&g_sprite_sets[i][j]);
        }
    }
    if (g_gfx_2798 != NULL) {
        free_gfx_record(&g_gfx_2798);
    }
    release_picture_set();
    while (g_party_head != NULL) {
        g_current_char = g_party_head->next;
        free_character(&g_party_head);
        g_party_head = g_current_char;
    }
    if (g_h005_52fc != NULL) {
        exec_free_mem(g_h005_52fc, 0x34);
    }
    if (g_h005_5300 != NULL) {
        exec_free_mem(g_h005_5300, 0x34);
    }
    free_gothic_font();
    if (h026_compare_nocase(0x50, G_DATA_PREFIX, 4, "df0:") != 1) {
        (void)dos_execute("Assign \"Disk One:\"", 0, 0);
        (void)dos_execute("Assign \"Disk Two:\"", 0, 0);
        (void)dos_execute("Assign \"Disk Three:\"", 0, 0);
    }
}

/*
 * PORT H010+$0332: exit from the game: stops the audio, frees the off-screen
 * View, closes window and screen, frees the resources and terminates (H015).
 */
void quit_game(void)
{
    h043_0840();
    release_display_resources();
    close_game_display();
    free_game_resources();
    h015_runtime_exit(0);
}

/*
 * PORT H010+$0360: writes the text (passed by value) and a newline to the
 * process console: H020+$085A and H020+$082E.
 */
void console_writeln(u16 len, const char *text)
{
    console_write(len, text);
    console_newline();
}
