/* H064: native handlers of the ECL commands. */
#ifndef COK_H064_H
#define COK_H064_H
#include "character.h"
extern Character *g_h064_saved_char;    /* H064+$0000 */
extern u8 g_h064_data[0x5E];            /* H064+$0000..$005D */
#define H064_B(off) g_h064_data[(off)]
void ecl_exit(void);                    /* H064+$0156 */
void ecl_goto(void);                    /* H064+$0202 */
void ecl_gosub_cmd(void);               /* H064+$0234 */
void ecl_compare(void);                 /* H064+$0258 */
void ecl_arithmetic(void);              /* H064+$0306 */
void ecl_random(void);                  /* H064+$03FC */
void ecl_save(void);                    /* H064+$0468 */
void ecl_load_character(void);          /* H064+$04DC */
void ecl_load_monster(void);            /* H064+$06A0 */
void ecl_approach(void);                /* H064+$05E2 */
void ecl_approach_step(void);           /* H064+$0ABE */
void ecl_picture(void);                 /* H064+$0B10 */
void ecl_input_number(void);            /* H064+$0C62 */
void ecl_input_string(void);            /* H064+$0CC4 */
void ecl_print(void);                   /* H064+$0D4A */
void ecl_return(void);                  /* H064+$0E40 */
void ecl_compare_and(void);             /* H064+$0E9C */
void ecl_if(void);                      /* H064+$0F30 */
void ecl_new_ecl(void);                 /* H064+$0F90 */
void ecl_load_files(void);              /* H064+$1004 */
void ecl_and_or(void);                  /* H064+$121C */
void ecl_get_table(void);               /* H064+$12CA */
void ecl_set_table(void);               /* H064+$1346 */
void ecl_vertical_menu(void);           /* H064+$13AC */
void ecl_horizontal_menu(void);         /* H064+$1544 */
void ecl_clear_monsters(void);          /* H064+$1748 */
void ecl_party_strength(void);          /* H064+$17BC */
#endif
