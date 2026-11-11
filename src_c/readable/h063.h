/* H063: personaggi, inventario e aggiornamento della UI. */
#ifndef COK_H063_H
#define COK_H063_H

#include "character.h"

void trim_leading_spaces(u16 len, char *s);             /* H063+$0112 */
u8   find_effect(Character *c, u16 type, CokEffect **out);
                                                        /* H063+$0946 */
void build_item_name(Character *c, CokItem *it, u16 col, u16 row,
                     u8 ready_mark, u8 draw);           /* H063+$09B2 */
void draw_armor_class(Character *c, u16 col, u16 row);  /* H063+$0FA0 */
void draw_hit_points(Character *c, u16 col, u16 row, u8 highlight,
                     u8 with_max);                      /* H063+$103A */
void recompute_stats(Character *c);                     /* H063+$13BE */
void draw_character_name(Character *c, u16 col, u16 row, u8 possessive);
                                                        /* H063+$1F34 */
u8   class_xp_row(Character *c, u8 cls);            /* H063+$3F72 */
void show_message_line(u16 len, const char *text);     /* H063+$1D44 */
void draw_party(Character *current);                   /* H063+$0D80 */
void redraw_game_screen(void);                         /* H063+$321A */
void delete_item(Character *c, CokItem *it);           /* H063+$1BE8 */
void show_char_message(Character *c, u16 len, const char *text, u16 row,
                       u8 wait);                        /* H063+$1DC2 */
void clear_message_area(void);                          /* H063+$1EE8 */
u8   end_combat_turn(Character *c);                     /* H063+$2F12 */
void choose_party_member(u16 len, const char *text, u8 with_exit,
                         u8 mode, Character **out);     /* H063+$3A26 */

s16  str_weight_allowance(Character *c);                 /* H063+$1A8A */

void give_item_copy(Character *c, CokItem *it);         /* H063+$1CC0 */

void heal_message(Character *c);                        /* H063+$2ACC */

s16  caster_level(u16 spell);                            /* H063+$2FAA */

void forget_spell(Character *c, u16 spell);             /* H063+$1B90 */
void show_effect_message(Character *c, u8 flag, u16 len, const char *text);
                                                        /* H063+$2760 */
void damage_hit_points(Character *c, u16 dmg);          /* H063+$2984 */

void count_sides(void);                                 /* H063+$2B7C */

u8   is_helpless(Character *c);                          /* H063+$135A */
void draw_combat_status(Character *c);                  /* H063+$1160 */
u16  combat_distance(Character *c, Character *t);       /* H063+$2DC6 */
u8   find_weapon(Character *c, CokItem **weapon);       /* H063+$37B2 */

s16  dex_missile_adj(Character *c);                     /* H063+$016A */
s16  str_hit_bonus(Character *c);                       /* H063+$0354 */
s16  str_damage_bonus(Character *c);                    /* H063+$19B6 */
void load_missile_frames(u16 slot);                     /* H063+$2178 */
void animate_missile(s16 x0, s16 y0, s16 x1, s16 y1, u16 frames, u16 unused);
                                                        /* H063+$21D2 */
u8   other_side(Character *c);                          /* H063+$2B4C */
u16  count_enemies_near(Character *c, u16 radius);      /* H063+$2BDE */
void draw_status_line(void);                            /* H063+$33A0 */
void redraw_combat_screen(void);                        /* H063+$3658 */
u16  direction_toward(Character *a, Character *b);      /* H063+$3CA0 */
u8   has_ranged_weapon(Character *c);                   /* H063+$3698 */
u8   weapon_is_43(Character *c);                        /* H063+$36EE */
u8   weapon_melee_ok(Character *c);                     /* H063+$3734 */
u8   bandage_dying(u8 bandage);                         /* H063+$3980 */
u8   guard_turn(Character *c);                          /* H063+$2F5A */

void copy_sprite_frame(u16 slot, u16 which, u16 dest, u8 mirror);
                                        /* H063+$1FDC */
#endif
