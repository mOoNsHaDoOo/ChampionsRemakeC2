/* H030: text presentation and user interface. */
#ifndef COK_H030_H
#define COK_H030_H

#include "cok.h"

void fill_text_cells(u16 col, u16 row, u16 pen, u16 width); /* H030+$019A */
void ui_draw_text(u16 col, u16 row, u16 fg, u16 bg, u16 len,
                  const char *text);                    /* H030+$0256 */
void clear_text_cells(u16 col1, u16 row1, u16 col2, u16 row2);
                                        /* H030+$0B6C */
void draw_char_run(u16 col, u16 row, u16 fg, u16 bg, u16 count, u8 ch,
                   u8 unused);                          /* H030+$00B6 */
s32  time_hundredths(void);                             /* H030+$0A40 */
void input_line(u16 prompt_len, const char *prompt, u16 fg, u16 bg,
                u16 max_chars, u16 out_max, char *out); /* H030+$0718 */
void show_message(u16 len, const char *text, u16 fg, u16 bg);
                                                        /* H030+$0AD2 */
void message_delay(void);
void word_wrap_text(u16 x1, u16 y1, u16 x2, u16 y2, u16 fg, u16 bg,
                    u8 clear, u16 len, const char *text);   /* H030+$0302 */
void show_message_wait(u16 fg, u16 bg, u16 len, const char *text);
                                                        /* H030+$028A */               /* H030+$0B4A */
u16  input_number(u16 len, const char *prompt, u16 fg, u16 bg);
                                                        /* H030+$09A6 */
void load_gothic_font(void);            /* H030+$0C10 */
void free_gothic_font(void);            /* H030+$0C84 */

#endif
