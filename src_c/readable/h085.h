/* H085: module data used by H033 (spell lists). */
#ifndef COK_H085_H
#define COK_H085_H

#include "cok.h"
#include "character.h"
#include "h008.h"

/*
 * The first $292 bytes of H085 are the module data (a4 = H085+$292).  H033
 * uses them with absolute addresses; words and pointers live in C variables,
 * the rest (level names at H085+$1B6) in g_h085_bss[H085 + off].
 */
extern u8 g_h085_bss[0x292];
extern u16 g_h085_scroll_count;              /* H085+$0004 */
extern CokItem *g_h085_scroll_items[0x31];   /* H085+$0006..$00C9 */
extern u16 g_h085_spell_ids[0x3A];           /* H085+$00CA..$013D */
extern u16 g_h085_spell_counts[0x3A];        /* H085+$013E..$01B1 */
extern CokMenuItem *g_h085_spell_list;       /* H085+$01B2 */

/* H085+$1B6 + level * $16: "Special", "1st Level", ... "9th Level". */
#define H085_LEVEL_NAME(level) \
    ((const char *)&g_h085_bss[0x1B6 + (level) * 0x16])

void h085_init(void);
void apply_spell_effect(u16 spell, u16 level, u8 b5, u16 dmg, u16 dmg_type,
                        u16 len, const char *text);   /* H085+$07B6 */
void spell_bless(void);                   /* H085+$1C60 */
void spell_curse(void);                   /* H085+$1C86 */
void spell_cause_light_wounds(void);      /* H085+$1D3C */
void spell_resist_cold(void);             /* H085+$1D78 */
void spell_burning_hands(void);           /* H085+$1DA6 */
void spell_charm_person(void);            /* H085+$1DE4 */
void spell_reduce(void);                  /* H085+$1FFA */
void spell_friends(void);                 /* H085+$2090 */
void spell_magic_missile(void);           /* H085+$20DE */
void spell_shield(void);                  /* H085+$2144 */
void spell_shocking_grasp(void);          /* H085+$2172 */
void spell_sleep(void);                   /* H085+$21C8 */
void spell_resist_fire(void);             /* H085+$23B8 */
void spell_silence(void);                 /* H085+$23E6 */
void spell_slow_poison(void);             /* H085+$2414 */
void spell_snake_charm(void);             /* H085+$24C6 */
void spell_spiritual_hammer(void);        /* H085+$25B8 */
void spell_knock(void);                   /* H085+$25FA */
void spell_mirror_image(void);            /* H085+$2628 */
void spell_ray_of_enfeeblement(void);     /* H085+$2692 */
void spell_cure_blindness(void);          /* H085+$2DBA */
void spell_cause_blindness(void);         /* H085+$2DFA */
void spell_cause_disease(void);           /* H085+$2E40 */
void spell_prayer(void);                  /* H085+$2E70 */
void spell_remove_curse(void);            /* H085+$2EC4 */
void spell_bestow_curse(void);            /* H085+$2FCE */
void spell_blink(void);                   /* H085+$2FFC */
void spell_haste(void);                   /* H085+$318A */
void spell_slow(void);                    /* H085+$3224 */
void spell_speedy(void);                  /* H085+$3252 */
void spell_strength_21(void);             /* H085+$331E */
void spell_paralyze(void);                /* H085+$3402 */
void spell_heal_3430(void);               /* H085+$3430 */
void spell_invisible(void);               /* H085+$3482 */
void spell_damage_2d4(void);              /* H085+$34B0 */
void spell_cause_serious_wounds(void);    /* H085+$34F0 */
void spell_sticks_to_snakes(void);        /* H085+$36B8 */
void spell_confusion(void);               /* H085+$37E2 */
void spell_fire_shield(void);             /* H085+$3A5E */
void spell_fumble(void);                  /* H085+$3C06 */
void spell_ice_storm(void);               /* H085+$3D0A */
void spell_minor_globe(void);             /* H085+$3D46 */
void spell_silent_3d74(void);             /* H085+$3D74 */
void spell_silent_3da0(void);             /* H085+$3DA0 */
void spell_silent_3dcc(void);             /* H085+$3DCC */
void spell_heal_3df8(void);               /* H085+$3DF8 */
void spell_affected(void);                /* H085+$3E4A */
void spell_protected(void);               /* H085+$3E78 */
void spell_invisibility(void);            /* H085+$3EA6 */
void spell_dispel_magic(void);                 /* H085+$3ED4 */
void cure_light_wounds(void);                /* H085+$1CB8 */
void cure_serious_wounds(void);              /* H085+$3298 */
void cure_disease(void);                     /* H085+$2E28 */
void neutralize_poison(void);                /* H085+$3552 */
void enlarge(void);                          /* H085+$1EBA */
void strength_spell(void);                   /* H085+$2BD4 */                        /* H085+$0664 */

void spell_fireball(void);                   /* H085+$15FE */
void effect_breath(Character **cp, void *obj, u8 flag); /* H085+$172A */
void spell_event_9(void);                    /* H085+$363E */
void spell_hold_person(void);                /* H085+$2338 */
void spell_stinking_cloud(void);             /* H085+$26C0 */
void spell_charm_monster(void);              /* H085+$3758 */
void spell_fear(void);                       /* H085+$3936 */
void spell_lightning_bolt(void);             /* H085+$31B4 */
void spell_bolt_20(void);                    /* H085+$33A8 */
void effect_fireball(Character **cp, void *obj, u8 flag);        /* H085+$431A */
void effect_poison_breath(Character **cp, void *obj, u8 flag);   /* H085+$442E */
void effect_lightning_breath(Character **cp, void *obj, u8 flag);/* H085+$4628 */
void effect_acid_breath(Character **cp, void *obj, u8 flag);     /* H085+$4798 */
void effect_eye_attack(Character **cp, void *obj, u8 flag);      /* H085+$4A02 */
void spell_teleport(void);                   /* H085+$38AA */
#endif
