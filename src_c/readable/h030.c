/* H030: Text presentation and user interface. */
#include "h030.h"
#include "h036.h"
#include "h003_exec.h"
#include "h028_files.h"
#include "h040.h"
#include "h038.h"
#include "h015_runtime.h"
#include "h021_intuition.h"
#include "h049.h"
#include "h010_input.h"
#include "h045.h"
#include "h026_string.h"
#include "globals.h"

/* PORT H030+$0070: link/unlk, no effect. */
void h030_init(void)
{
}

/*
 * PORT H030+$019A: fills with pen width text cells (8x8) from
 * column col of row row (40x25 grid), clipping on the right at
 * column 40.  Outside the grid or with width 0 it does nothing.  The checks
 * "col < 0" and "row < 0" of the original (tst.w / bcc) never trigger.
 */
void fill_text_cells(u16 col, u16 row, u16 pen, u16 width)
{
    if (col > 0x27 || row > 0x18 || width < 1) {
        return;
    }
    if ((u16)(col + width) > 0x28) {
        width = (u16)(0x28 - col);
    }
    graphics_set_apen(g_rastport, pen);
    graphics_set_open(g_rastport, pen);
    graphics_rect_fill(g_rastport, (u16)(col << 3), (u16)(row << 3),
                       (u16)(((u16)(col + width) << 3) - 1),
                       (u16)((row << 3) + 7));
}

/* PORT H030+$0256 (UI_DrawText): text in the 40x25 grid (H049+$0224). */
void ui_draw_text(u16 col, u16 row, u16 fg, u16 bg, u16 len,
                  const char *text)
{
    draw_text_blitter(col, row, fg, bg, len, text);
}

/*
 * PORT H030+$0B6C: clears (pens 0) the rectangle of 8x8 cells from
 * (col1, row1) to (col2, row2) included.
 */
void clear_text_cells(u16 col1, u16 row1, u16 col2, u16 row2)
{
    graphics_set_apen(g_rastport, 0);
    graphics_set_bpen(g_rastport, 0);
    graphics_set_open(g_rastport, 0);
    graphics_rect_fill(g_rastport, (u16)(col1 << 3), (u16)(row1 << 3),
                       (u16)((col2 << 3) + 7), (u16)((row2 << 3) + 7));
}

/*
 * PORT H030+$00B6: count times the character ch in the cell (col, row) and
 * the following ones; a space fills the cells with colour bg.  Outside the grid or
 * count 0: nothing; on the right it is clipped at column 40.
 */
void draw_char_run(u16 col, u16 row, u16 fg, u16 bg, u16 count, u8 ch,
                   u8 unused)
{
    char text[0x2C];                    /* -$2C(a5) */
    u16 i;

    (void)unused;
    if (ch == ' ') {
        fill_text_cells(col, row, bg, count);
        return;
    }
    if (col > 0x27 || row > 0x18 || count < 1) {
        return;
    }
    if ((u16)(col + count) > 0x28) {
        count = (u16)(0x28 - col);
    }
    for (i = 0; i <= (u16)(count - 1); ++i) {
        text[i] = (char)ch;
    }
    text[count] = 0;
    ui_draw_text(col, row, fg, bg, 0x28, text);
}

/*
 * PORT H030+$0A40: current time in hundredths of a second (CurrentTime:
 * seconds * 100 + microseconds / 10000).
 */
s32 time_hundredths(void)
{
    u32 seconds;
    u32 micros;

    intuition_current_time(&seconds, &micros);
    return (s32)h015_mulu32(seconds, 100) +
           h015_divs32((s32)micros, 10000, NULL);
}

/*
 * PORT H030+$0718: reads a line of text on row 24 after the prompt:
 * characters from ' ' to 'z' (at most max_chars, echoed with pen 15),
 * backspace deletes, Enter or Esc (or the demo) end it.  The text, in
 * upper case, goes into out (at most out_max characters).
 */
void input_line(u16 prompt_len, const char *prompt, u16 fg, u16 bg,
                u16 max_chars, u16 out_max, char *out)
{
    char text[0x52];                    /* -$54(a5) */
    char key[2];                        /* -$56(a5): key and NUL */
    u16 col;                            /* -$2(a5) */

    fill_text_cells(0, 0x18, 0, 0x28);
    ui_draw_text(0, 0x18, fg, bg, prompt_len, prompt);
    col = (u16)(h026_strlen(prompt_len, prompt) - 1);
    text[0] = 0;
    key[1] = 0;
    do {
        wait_for_key();
        key[0] = (char)G_KEY; /* $5305: key/action pending from the input (G_KEY) */
        if ((u8)key[0] >= 0x20 && (u8)key[0] <= 0x7A) {
            if (h026_strlen(0x50, text) < max_chars) {
                h026_append(0x50, text, 1, key);
                ++col;
                ui_draw_text(col, 0x18, 0x0F, 0, 1, key);
            }
        } else if (key[0] == 0x08) {
            if (h026_strlen(0x50, text) > 0) {
                h026_delete(0x50, text,
                            (u16)(h026_strlen(0x50, text) - 1), 1);
                fill_text_cells(col, 0x18, 0, 1);
                --col;
            }
        }
    /* $24D7: 1 if the demonstration (Demo) was chosen */
    } while (key[0] != 0x0D && key[0] != 0x1B && !G_DEMO_FLAG);
    fill_text_cells(0, 0x18, 0, 0x28);
    h026_upcase(0x50, text);
    h026_copy(out_max, out, 0x50, text);
}

/* Module data (below a4). */
struct BitMap g_gothic_bitmap;          /* -$2C: font "gothic.lbm" */
u32 g_h030_alloc_size;                  /* -$4: last allocation */

/*
 * PORT H030+$0BDA: allocator for Read_ILBM (cleared chip memory); the
 * size stays in -$4(a4).
 */
static u8 *alloc_chip_planes(u32 size)
{
    g_h030_alloc_size = size;
    return (u8 *)exec_alloc_mem(size, COK_MEMF_CHIP | COK_MEMF_CLEAR);
}

/*
 * PORT H030+$0C10: loads "gothic.lbm" (text font) into
 * g_gothic_bitmap and registers it in H049 as the glyph source, with
 * the window bitmap as destination.  If the file is missing only the
 * registration remains (with the planes NULL), as in the original.
 */
void load_gothic_font(void)
{
    ILBMFrame frame;                    /* -$6A(a5) */
    cok_bptr file = 0;                  /* -$6E(a5) */

    (void)open_resource_file(0x0A, "gothic.lbm", 0x15,
                             "Can't load intro gfx!", 1, &file);
    if (file != 0) {
        (void)read_ilbm(file, &g_gothic_bitmap, &frame, alloc_chip_planes);
        dos_close(file);
    }
    h049_set_glyph_planes((u8 *)g_gothic_bitmap.Planes[0],
                          g_rastport->BitMap);
}

/* PORT H030+$0C84: frees the planes of the font (allocation size). */
void free_gothic_font(void)
{
    exec_free_mem(g_gothic_bitmap.Planes[0], g_h030_alloc_size);
}

/* PORT H030+$0B4A: message pause: H005+$3DF6 * 5 ticks. */
void message_delay(void)
{
    dos_delay((u32)H005_W(0x3DF6) * 5); /* $3DF6: (word) game speed 0..9 (message pause) */
}

/*
 * PORT H030+$0AD2: message on row $18 (text copied, parameter by
 * value), pause, then the row is cleared.
 */
void show_message(u16 len, const char *text, u16 fg, u16 bg)
{
    char copy[0x100];
    u16 i;

    for (i = 0; i <= len && i < sizeof(copy) - 1; ++i) {
        copy[i] = text[i];
    }
    copy[i] = 0;
    fill_text_cells(0, 0x18, 0, 0x28);
    ui_draw_text(0, 0x18, fg, bg, len, copy);
    message_delay();
    fill_text_cells(0, 0x18, 0, 0x28);
}

/*
 * PORT H030+$028A: message on row $18 (text by value) until a key
 * is pressed, then the row is cleared.
 */
void show_message_wait(u16 fg, u16 bg, u16 len, const char *text)
{
    char copy[0x100];
    u16 i;

    for (i = 0; i <= len && i < sizeof(copy) - 1; ++i) {
        copy[i] = text[i];
    }
    copy[i] = 0;
    fill_text_cells(0, 0x18, 0, 0x28);
    ui_draw_text(0, 0x18, fg, bg, len, copy);
    wait_for_key();
    fill_text_cells(0, 0x18, 0, 0x28);
}

/* State of H030+$0302 shared with the nested procedures. */
typedef struct WrapFrame {
    const char *text;                   /* $c(a5) */
    u16 fg;                             /* $16(a5) */
    u16 bg;                             /* $14(a5) */
    u16 len;                            /* -$2(a5) */
    u16 pos;                            /* -$6(a5) */
    u16 end;                            /* -$8(a5) */
} WrapFrame;

/* Text cursor (H005+$334E column, $334C row). */
#define TEXT_COL H005_W(0x334E) /* $334E: (word) text cursor: column */
#define TEXT_ROW H005_W(0x334C) /* $334C: (word) text cursor: row */

/*
 * PORT H030+$0310: nested procedure: writes the characters from pos to end at the
 * cursor (with $24CE a pause per character).
 */
static void wrap_emit(WrapFrame *f)
{
    while (f->pos <= f->end) {
        if (f->text[f->pos] != 0) {
            /* $334E: (word) text cursor: column; $334C: (word) text cursor: row */
            draw_char_run(TEXT_COL, TEXT_ROW, f->fg, f->bg, 1,
                          (u8)f->text[f->pos], 1);
            if (H005_B(0x24CE)) { /* $24CE: 1: per-character pause when writing text */
                /* $3DF6: (word) game speed 0..9 (message pause) */
                dos_delay((u32)(H005_W(0x3DF6) >> 1));
            }
            H005_SET_W(0x334E, (u16)(TEXT_COL + 1)); /* $334E: (word) text cursor: column */
        }
        ++f->pos;
    }
}

/* PORT H030+$03B8: nested procedure: skips the spaces. */
static void wrap_skip_spaces(WrapFrame *f)
{
    while (f->pos < f->len && f->text[f->pos] == ' ') {
        ++f->pos;
    }
}

/* PORT H030+$03FC: nested procedure: punctuation "-.,?!:;". */
static u8 wrap_is_punct(u8 ch)
{
    static const char punct[7] = { '-', '.', ',', '?', '!', ':', ';' };
    u8 found = 0;
    u16 i;

    for (i = 1; i <= 7; ++i) {
        if (ch == (u8)punct[i - 1]) {
            found = 1;
        }
    }
    return found;
}

/*
 * PORT H030+$0302 (body at $0470): writes text (by value) in the rectangle
 * of cells (x1, y1)-(x2, y2) wrapping between words from the cursor
 * H005+$334E/$334C (moved back to the start if outside, or if clear clears
 * the rectangle); when the page is full "Press any key to continue".
 */
void word_wrap_text(u16 x1, u16 y1, u16 x2, u16 y2, u16 fg, u16 bg,
                    u8 clear, u16 len, const char *text)
{
    char copy[0x100];
    WrapFrame f;
    u16 i;

    for (i = 0; i <= len && i < sizeof(copy) - 1; ++i) {
        copy[i] = text[i];
    }
    copy[i] = 0;
    if (x1 > 0x27 || y1 > 0x18 || x2 > 0x27 || y2 > 0x27) {
        return;
    }
    /* $334E: (word) text cursor: column; $334C: (word) text cursor: row */
    if (TEXT_COL < x1 || TEXT_COL > x2 || TEXT_ROW < y1 || TEXT_ROW > y2) {
        H005_SET_W(0x334E, x1); /* $334E: (word) text cursor: column */
        H005_SET_W(0x334C, y1); /* $334C: (word) text cursor: row */
    }
    if (clear) {
        clear_text_cells(x1, y1, x2, y2);
        H005_SET_W(0x334E, x1); /* $334E: (word) text cursor: column */
        H005_SET_W(0x334C, y1); /* $334C: (word) text cursor: row */
    }
    f.text = copy;
    f.fg = fg;
    f.bg = bg;
    f.pos = 0;
    f.len = h026_strlen(len, copy);
    if (f.len == 0) {
        return;
    }
    do {
        f.end = f.pos;
        while (f.end < (u16)(f.len - 1) &&
               wrap_is_punct((u8)copy[f.end])) {
            ++f.end;
        }
        while (f.end < (u16)(f.len - 1) &&
               !wrap_is_punct((u8)copy[f.end]) && copy[f.end] != ' ') {
            ++f.end;
        }
        if (copy[f.end] != ' ') {
            while ((u16)(f.end + 1) < (u16)(f.len - 1) &&
                   wrap_is_punct((u8)copy[f.end + 1])) {
                ++f.end;
            }
        }
        if ((u16)(f.end - f.pos + TEXT_COL) > x2) { /* $334E: (word) text cursor: column */
            /* Equality impossible here: dead branch in the original. */
            if ((u16)(f.end - f.pos + TEXT_COL) == x2 && /* $334E: (word) text cursor: column */
                copy[f.end] == ' ') {
                --f.end;
                wrap_emit(&f);
            }
            H005_SET_W(0x334E, x1); /* $334E: (word) text cursor: column */
            H005_SET_W(0x334C, (u16)(TEXT_ROW + 1)); /* $334C: (word) text cursor: row */
            wrap_skip_spaces(&f);
            if (TEXT_ROW > y2 && f.pos < f.len) { /* $334C: (word) text cursor: row */
                H005_SET_W(0x334E, x1); /* $334E: (word) text cursor: column */
                H005_SET_W(0x334C, y1); /* $334C: (word) text cursor: row */
                show_message_wait(0x0D, 0, 0x19,
                                  "Press any key to continue");
                clear_text_cells(x1, y1, x2, y2);
                wrap_emit(&f);
            }
        } else {
            wrap_emit(&f);
        }
    } while (f.pos <= (u16)(f.len - 1));
    if (TEXT_COL > x2) { /* $334E: (word) text cursor: column */
        H005_SET_W(0x334E, x1); /* $334E: (word) text cursor: column */
        H005_SET_W(0x334C, (u16)(TEXT_ROW + 1)); /* $334C: (word) text cursor: row */
    }
}

/*
 * PORT H030+$09A6: asks for a number (at most 6 digits) until it is
 * valid and between 0 and $FFFF.
 */
u16 input_number(u16 len, const char *prompt, u16 fg, u16 bg)
{
    char copy[0x100];
    char buf[0x2A];                     /* -$2E(a5) */
    s32 v = 0;                          /* -$4(a5) */
    u8 ok;                              /* -$31(a5) */

    h026_copy(0xFF, copy, len, prompt);
    do {
        input_line(len, copy, fg, bg, 6, 0x28, buf);
        ok = parse_number(0x28, buf, &v, 1, 0x0A);
    } while (!ok || v >= 0x10000 || v < 0);
    return (u16)v;
}
