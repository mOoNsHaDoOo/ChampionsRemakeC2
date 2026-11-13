/* H062: shared character services (dice, effects). */
#ifndef COK_H062_H
#define COK_H062_H

#include "character.h"

u16  roll_dice(u16 count, u16 sides);           /* H062+$156C */
void add_effect(Character *c, u16 type, u16 value, u16 b4, u8 b5);
                                                /* H062+$15F2 */

void remove_effects_19(Character *c);           /* H062+$1780 */

u8   heal_character(Character *c, u16 amount, u8 full_only); /* H062+$253C */

void call_effect_handler(u16 type, Character **c, void *obj, u8 flag);
                                                /* H062+$03F2 */
void remove_effect(Character *c, u16 type, CokEffect *e);  /* H062+$0452 */
void recompute_stat(Character *c, u8 stat);     /* H062+$1A32 */

u8   cure_effect(Character *c, u16 type);        /* H062+$18AC */

u8   strength_raises(Character *c, u16 str, u16 ext, u16 *value);
                                                /* H062+$19C2 */

void trigger_event(Character **cp, u16 event);  /* H062+$083E */
u8   attack_roll(Character *attacker, Character *defender, u16 target);
                                                /* H062+$12F6 */
u8   saving_throw_roll(Character *c, u8 kind, s16 bonus);  /* H062+$142C */
void apply_damage(Character *c, u16 dmg, u8 kind, u8 saved); /* H062+$2188 */
void apply_spell_effect_on(Character *t, u16 type, u16 dur, u16 lvl, u8 b5,
                           u8 kind, u8 saved, u16 len, const char *text);
                                                /* H062+$0114 */

u16  roll_damage_dice(u16 count, u16 sides);     /* H062+$15C6 */

void knock_out(Character *c, u8 status, u16 len, const char *text);
                                                /* H062+$02FA */
u8   revive(Character *c, u16 hp, u16 len, const char *text); /* H062+$2650 */
void explode_fallen(void);                      /* H062+$2734 */
void drop_effects(Character *c);                /* H062+$17C0 */
void yell_challenge(Character *c);              /* H062+$021E */
void check_cloud(Character *c, u8 in_cloud);    /* H062+$1038 */
void fall_down(Character *c, u8 status, u16 len, const char *text);
                                                /* H062+$1694 */
void h062_nop_1898(void);                       /* H062+$1898 */
u8   ecl_attack_hits(Character *c, u16 bonus);   /* H062+$126C */

#endif
