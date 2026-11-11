/* H061: servizi della VM ECL. */
#ifndef COK_H061_H
#define COK_H061_H
#include "character.h"
#include "h015_runtime.h"
#include "h008.h"
char *ecl_string(u16 n);                        /* stringhe -$14C0(a4) */
void append_char(u16 len, char *s, u8 ch);      /* H061+$162E */
u16  make_word(u8 lo, u8 hi);                   /* H061+$1F12 */
u16  decode_address(u8 lo, u8 hi);              /* H061+$1F3C */
u8   ecl_char(u16 c);                           /* H061+$1F6A */
u8   var_region(u16 addr);                      /* H061+$1FA4 */
u16  party_index(Character *c);                 /* H061+$202C */
u16  read_var(u16 addr);                        /* H061+$2E04 */
void write_var(u16 addr, u16 val);              /* H061+$2BAA */
void read_operands(u16 n);                      /* H061+$1670 */
u16  eval_operand(u16 i);                       /* H061+$184E */
void read_string_operand(u16 len, u16 slot);    /* H061+$3244 */
void read_string_var(u16 slot, u16 addr);       /* H061+$33F0 */
u8   operand_desc(u16 i);
u8   operand_lo(u16 i);
u8   operand_hi(u16 i);
/* Nodo della pila GOSUB ($2388; 6 byte nell'originale). */
typedef struct CokEclFrame {
    u16 pc;                             /* +$00 */
    struct CokEclFrame *next;           /* +$02 */
} CokEclFrame;
extern CokEclFrame *g_ecl_stack;        /* $2388 */
extern CokEclFrame *g_ecl_stack_prev;   /* $2384 */
void ecl_start_area(void);                      /* H061+$1928 */
void load_ecl_program(u8 id);                   /* H061+$1ACC */
void load_monster(u8 idx, Character **out, CokItem **items,
                  CokEffect **effects);         /* H061+$1BD6 */
u16  free_steps(s16 x, s16 y, u8 dir);          /* H061+$1C42 */
void show_head_body(u16 head, u16 body);        /* H061+$1D20 */
void show_event_picture(u8 spr, u8 pic, u8 idx, u8 *flags); /* H061+$1D6E */
u16  ecl_menu(u16 title_len, const char *title, u16 opt_len,
              const char *options, u16 pen1, u16 pen2, u16 pen3,
              u8 allow_enter, u8 animate);      /* H061+$36E6 */
void compare_strings(u16 len_a, const char *a, u16 len_b, const char *b);
                                                /* H061+$3904 */
void compare_words(u16 a, u16 b);               /* H061+$3A0A */
void ecl_gosub(u16 i);                          /* H061+$3AAC */
void step_forward(void);                        /* H061+$3B4E */
void scale_money(CokReal keep, Character *c);   /* H061+$3C4C */
void destroy_items(u16 chance, Character *c);   /* H061+$3DBE */
void ecl_skip_command(void);                    /* H061+$3E80 */
void party_speed_range(u16 *maxv, u16 *minv);   /* H061+$3FA8 */
void ecl_damage_message(Character *c, u16 dmg); /* H061+$4092 */
void write_string_var(u16 addr, u16 len, const char *s);   /* H061+$3012 */
u8   ecl_list_menu(u16 title_len, const char *title, u16 opt_len,
                   const char *options, u16 title_pen, u16 normal_pen,
                   u16 highlight_pen, u16 first_col, u16 first_row,
                   u16 last_col, u16 last_row, CokMenuItem *list,
                   u8 with_exit, u8 *redraw, u16 *index,
                   CokMenuItem **chosen);       /* H061+$3860 */
#endif
