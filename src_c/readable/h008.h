/* H008: interazioni UI, richieste di scelta e menu. */
#ifndef COK_H008_H
#define COK_H008_H

#include "cok.h"

/*
 * Voce di un menu a elenco ($30 byte nell'originale): testo, flag di
 * intestazione (riga non selezionabile, saltata dal cursore) e successiva.
 */
typedef struct CokMenuItem {
    char text[0x2A];            /* +$00 */
    u8 header;                  /* +$2A */
    u8 pad;
    struct CokMenuItem *next;      /* +$2C */
} CokMenuItem;

CokMenuItem *menu_nth(CokMenuItem *list, u16 index);          /* H008+$0102 */
u16  menu_length(CokMenuItem *list);                       /* H008+$0162 */
u8   ui_request_choice(u16 title_len, const char *title, u16 options_len,
                       const char *options, u16 title_pen, u16 normal_pen,
                       u16 highlight_pen, u8 digits_map, u8 animate,
                       u8 *special);                    /* H008+$01FC */
void clear_message_line(void);          /* H008+$139E */
u8   list_menu(u16 title_len, const char *title, u16 options_len,
               const char *options, u16 title_pen, u16 normal_pen,
               u16 highlight_pen, u16 first_col, u16 first_row,
               u16 last_col, u16 last_row, CokMenuItem *list, u8 with_exit,
               u8 *redraw, u16 *index, CokMenuItem **chosen);
                                        /* H008+$13C0 (corpo a $1AF4) */
u8   ask_yes_no(u16 text_len, const char *text, u16 title_pen,
                u16 normal_pen, u16 highlight_pen);     /* H008+$203C */
void menu_alloc(u16 count, CokMenuItem **list);            /* H008+$20C2 */
void menu_free(CokMenuItem **list);                        /* H008+$2178 */

#endif
