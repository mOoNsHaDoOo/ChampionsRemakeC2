/* H096: azioni, attacchi, mira e calcoli del combattimento. */
#ifndef COK_H096_H
#define COK_H096_H
#include "character.h"

/* Mira/bersaglio scelto (9 byte nell'originale: puntatore, x, y). */
typedef struct CokAim {
    Character *who;                     /* +$0 */
    u16 x;                              /* +$4 */
    u16 y;                              /* +$6 */
    u8 b8;                              /* +$8 */
} CokAim;

void h096_init(void);                   /* H096+$01F2 */
void combat_prepare_turn(Character *c); /* H096+$02CE */
void combat_step(Character *c, u16 dir);        /* H096+$099C */
void combat_leave_attacks(Character *c, u16 dir); /* H096+$0C3C */
u8   combat_flee(Character *c);         /* H096+$10FA */
void combat_attacks(Character *c);      /* H096+$11D4 */
u8   combat_sweep(Character *a, Character *t);  /* H096+$1340 */
void turn_undead(Character *c);         /* H096+$160A */
void record_attack(Character *a, Character *t); /* H096+$20E6 */
void combat_attack(Character *a, Character *t, u8 flag, CokItem *item,
                   u8 *done);           /* H096+$2182 */
void combat_spell_targets(u8 spell, u8 flag, u8 *ok); /* H096+$2A6C */
void combat_cast(u16 spell, u8 flag, u8 *done); /* H096+$3100 */
void enemy_strength(void);              /* H096+$37C2 */
u8   confirm_attack(Character *a, Character *t);    /* H096+$38DC */
void aim_target(Character *c, u16 range, u16 mode, u8 b16, u8 b14,
                u8 *found, CokAim *out);            /* H096+$4448 */
u8   combat_bandage(void);              /* H096+$4DE8 */
u16  movement_points(Character *c);     /* H096+$023E */
u8   can_attack(Character *a, Character *t);    /* H096+$1562 */
u8   find_undead(Character *c, Character **out, u8 *max); /* H096+$1B04 */
u8   find_heal_target(Character *c, Character **out); /* H096+$25DA */
u16  enemy_distance_points(Character *c);       /* H096+$3852 */
u8   ai_pick_target(Character *c, u16 radius, u8 b_any, u8 b0); /* H096+$4B86 */
#endif
