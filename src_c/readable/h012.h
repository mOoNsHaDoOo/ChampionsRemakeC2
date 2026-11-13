/* H012: exploration loop and ECL interpreter. */
#ifndef COK_H012_H
#define COK_H012_H
#include "cok.h"
void run_ecl(u16 addr);                 /* H012+$018A */
void ecl_party_survey(void); /* H012+$01FA */
void ecl_party_has_class(void); /* H012+$05D6 */
void ecl_surprise(void);     /* H012+$0688 */
void ecl_combat(void);       /* H012+$0766 */
void ecl_on_goto(void);      /* H012+$0B18 */
void ecl_treasure(void);     /* H012+$0BEA */
void ecl_encounter(void);    /* H012+$15AE */
void ecl_parlay(void);       /* H012+$1DDE */
void ecl_special(void);      /* H012+$26D6 */
void ecl_damage(void);       /* H012+$1F68 */
void ecl_clear_picture(void); /* H012+$2358 */
void ecl_find_item(void);    /* H012+$1E90 */
void ecl_new_line(void);     /* H012+$23D6 */
void ecl_advance_time(void); /* H012+$2392 */
void ecl_add_npc(void);      /* H012+$2502 */
void ecl_party_menu(void);   /* H012+$29A6 */
void ecl_who(void);          /* H012+$2486 */
void ecl_delay(void);        /* H012+$1F4C */
void ecl_find_spell(void);   /* H012+$2596 */
void ecl_nop_3c(void);       /* H012+$2AAE */
void ecl_redraw_screen(void); /* H012+$241C */
void ecl_remove_character(void); /* H012+$2ABE */
void ecl_has_effect(void);   /* H012+$2AF6 */
void ecl_remove_items(void); /* H012+$2B64 */
void ecl_experience(void);   /* H012+$2C28 */
void ecl_camp_entry(void);              /* H012+$2922 */
void explore_loop(void);                /* H012+$3150 */
void ecl_rob(void);          /* H012+$14C8 */
#endif
