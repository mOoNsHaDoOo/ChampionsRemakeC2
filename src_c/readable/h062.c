/* H062: Shared helpers and effects of the game; not all meanings are assigned. */
#include "h062.h"
#include "h003_exec.h"
#include "h023_shared.h"
#include "h063.h"
#include "globals.h"
#include "unported.h"
#include "h077.h"
#include "h048.h"
#include "h029_gfx.h"
#include "h026_string.h"
#include "h030.h"
#include "h045.h"
#include "h056.h"
#include <string.h>

/* PORT H062+$0106: link/unlk, no effect. */
void h062_init(void)
{
}

/* PORT H062+$156C: sum of count rolls of a die with sides sides. */
u16 roll_dice(u16 count, u16 sides)
{
    u16 total = 0;
    u16 i;

    if (count > 0) {
        for (i = 1; i <= count; ++i) {
            total = (u16)(total + (u16)(random_below(sides) + 1));
            if (i == 0xFFFF) {
                break;          /* addq/bcc: the counter does not restart from 0 */
            }
        }
    }
    return total;
}

/*
 * PORT H062+$15F2: appends to the list +$E8 an effect of $0A bytes:
 * +0 = type, +2 = value (word), +4 = b4, +5 = b5.
 */
void add_effect(Character *c, u16 type, u16 value, u16 b4, u8 b5)
{
    CokEffect *node = (CokEffect *)exec_alloc_mem(sizeof(CokEffect),
                                                  COK_MEMF_CLEAR);
    CokEffect *tail;

    if (c->effects == NULL) {
        c->effects = node;
    } else {
        tail = c->effects;
        while (tail->next != NULL) {
            tail = tail->next;
        }
        tail->next = node;
    }
    node->next = NULL;
    node->b[0] = (u8)type; /* eff+$0: type of the effect (code of the handler) */
    /* eff+$2: (word) remaining duration of the effect, decreased with time; 0 = permanent */
    COK_PUT16(node->b + 2, value);
    node->b[5] = b5; /* eff+$5: flag: on removal it first calls the handler of the effect */
    node->b[4] = (u8)b4; /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
}

/* PORT H062+$1780: removes (H062+$0452) all the effects of type $19. */
void remove_effects_19(Character *c)
{
    CokEffect *e;                       /* -$4(a5) */

    while (find_effect(c, 0x19, &e)) {
        remove_effect(c, 0x19, e);
    }
}

/*
 * PORT H062+$253C: heals c by amount points (up to +$64) if the status
 * (+$197) is 0, 1, 4 or 5; with full_only it does not heal those already at the maximum.
 * Whoever was unconscious (+$198 = 0) becomes active again outside combat.
 */
u8 heal_character(Character *c, u16 amount, u8 full_only)
{
    u8 ok = 0;                          /* -$1(a5) */
    u8 st = c->b[0x197]; /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */

    if (st == 0 || st == 1 || st == 4 || st == 5) {
        /* ch+$1A8: current hit points; ch+$64: maximum hit points */
        if (!(c->b[0x1A8] >= c->b[0x64] && full_only)) {
            c->b[0x1A8] = (u8)(c->b[0x1A8] + amount); /* ch+$1A8: current hit points */
            if (c->b[0x1A8] > c->b[0x64]) { /* ch+$1A8: current hit points; ch+$64: maximum hit points */
                c->b[0x1A8] = c->b[0x64]; /* ch+$1A8: current hit points; ch+$64: maximum hit points */
            }
            if (!c->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
                /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
                if (c->b[0x197] == 5) {
                    /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
                    c->b[0x197] = 4;
                }
                /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down; $3DE3: game
                 * mode (0 menu, 1 view, 2 camp, 5 combat) */
                if (c->b[0x197] == 4 && H005_B(0x3DE3) != 5) {
                    /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
                    c->b[0x197] = 0;
                    c->b[0x198] = 1; /* ch+$198: active/standing (0 down or out of the combat) */
                }
            }
            ok = 1;
        }
    }
    return ok;
}


/* Handler of the effect table H005+$2832 (arguments as H062+$03F2). */
typedef void (*CokEffectHandler)(Character **c, void *obj, u8 flag);

/*
 * PORT H062+$03F2: calls the handler of effect type (H005+$2832 +
 * (type-1)*4), or the one of $2A0E if $24E0 is active, with (c, obj, flag).
 */
void call_effect_handler(u16 type, Character **c, void *obj, u8 flag)
{
    if (H005_B(0x24E0)) { /* $24E0: 1: the effects go to the handler $2A0E (magic items) */
        ((CokEffectHandler)g_handlers_2832[119])(c, obj, flag);
    } else {
        ((CokEffectHandler)g_handlers_2832[type - 1])(c, obj, flag);
    }
}

/*
 * PORT H062+$0452: removes from c the effect e (or the first of type type if e
 * is null); if it has +$5 it first calls its handler with flag 1.  For the types
 * $E, $C and $26 it recomputes the abilities involved.
 */
void remove_effect(Character *c, u16 type, CokEffect *e)
{
    CokEffect *p = e;                   /* -$8(a5) */
    CokEffect *prev;                    /* -$4(a5) */
    u16 n;                              /* -$a(a5) */

    if (p == NULL) {
        p = c->effects;
        n = 0;
        while (p != NULL && p->b[0] != type) { /* eff+$0: type of the effect (code of the handler) */
            ++n;
            p = p->next;
        }
        (void)n;
    }
    if (p == NULL) {
        return;
    }
    if (p->b[5]) { /* eff+$5: flag: on removal it first calls the handler of the effect */
        call_effect_handler(type, &c, p, 1);
    }
    if (c->effects == p) {
        c->effects = p->next;
    } else {
        prev = c->effects;
        while (prev != NULL && prev->next != p) {
            prev = prev->next;
        }
        prev->next = p->next;
    }
    exec_free_mem(p, sizeof(CokEffect));            /* FreeMem($0A) */
    if (type == 0x0E) {
        recompute_stat(c, 5);
    }
    if (type == 0x0C || type == 0x26) {
        recompute_stat(c, 0);
    }
}

/*
 * PORT H062+$1952: ability value given by effect e (+$4 without
 * bit 7): up to $65 it is strength 18 with exceptional value - 1, beyond it is
 * value - $64.
 */
static void effect_stat_value(CokEffect *e, u16 *value, u16 *ext)
{
    *ext = 0;
    /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
    *value = mask_byte(e->b[4], 0x7F);
    if (*value <= 0x65) {
        *ext = (u16)(*value - 1);
        *value = 0x12;
    } else {
        *value = (u16)(*value - 0x64);
    }
}

/* Frame of H062+$1A32 for the nested procedures. */
typedef struct StatFrame {
    Character *c;                       /* $e(a5) */
    u16 sum;                            /* -$4(a5) */
    u16 value;                          /* -$e(a5) */
    u16 cand;                           /* -$10(a5) */
    u16 ext;                            /* -$12(a5) */
    u16 cand_ext;                       /* -$14(a5) */
} StatFrame;

/* PORT H062+$1A40: keeps the candidate value if greater. */
static void stat_take_max(StatFrame *f)
{
    if (f->cand > f->value || (f->cand == 0x12 && f->cand_ext > f->ext)) {
        f->value = f->cand;
        f->ext = f->cand_ext;
    }
}

/* PORT H062+$1A9E: constitution hit points for level levels of cls. */
static void stat_con_hp(StatFrame *f, u16 level, u8 cls)
{
    if (level >= H005_B(0x5026 + cls)) { /* $5026: maximum hit dice level per class (byte, 0..7) */
        /* $5026: maximum hit dice level per class (byte, 0..7) */
        level = (u16)(H005_B(0x5026 + cls) - 1);
    }
    if (cls == 4 &&
        /* ch+$DC: use: threshold for the levels +$106..+$10D and the HP; !=0 forbids Modify;
         * ch+$10A: previous ranger level */
        (f->c->b[0xDC] == 0 || f->c->b[0x10A] == f->c->b[0xDC])) {
        ++level;
    }
    if (cls == 2 || cls == 4 || cls == 7) {
        switch (f->value) {
        case 15: case 16: case 17: case 18: case 19:
            f->sum = (u16)(f->sum + (f->value - 0x0E) * level);
            break;
        case 20:
            f->sum = (u16)(f->sum + level * 5);
            break;
        case 21: case 22: case 23:
            f->sum = (u16)(f->sum + level * 6);
            break;
        case 24: case 25:
            f->sum = (u16)(f->sum + level * 7);
            break;
        default:
            break;
        }
    } else if (f->value > 0x0F) {
        f->sum = (u16)(f->sum + level * 2);
    } else if (f->value == 0x0F) {
        f->sum = (u16)(f->sum + level);
    }
}

/*
 * PORT H062+$1A32 (body at $1C04): recomputes ability stat of c
 * (0 STR, 3 DEX, 4 CON, 5 CHA) from the base value, from the readied magic
 * items and from the effects; for CON also the hit points.
 */
void recompute_stat(Character *c, u8 stat)
{
    StatFrame f;
    CokEffect *e;                       /* -$18(a5) */
    CokItem *it;                        /* -$1e(a5) */
    u16 override = 0xFF;                /* -$8(a5) */
    u16 v;                              /* -$a(a5) */
    u16 count;                          /* -$c(a5) */
    u16 lvl;                            /* -$6(a5) */
    u16 old_hp;                         /* -$2(a5) */
    u8 k;                               /* -$19(a5) */

    f.c = c;
    f.sum = 0;
    f.cand = 0;
    f.cand_ext = 0;
    it = c->items;
    /* pg+$10: caratteristiche base, 6 voci passo 2 (FOR INT SAG DES COS CAR); FOR */
    f.value = c->b[0x10 + stat * 2];
    f.ext = c->b[0x1D]; /* ch+$1D: base exceptional strength */
    for (; it != NULL; it = it->next) {
        /* item+$46: type of the magic effect: bit7 = passive effect, bits 0..6 type; item+$3A:
         * item readied flag (Ready) */
        if (it->b[0x46] > 0x80 && it->b[0x3A]) {
            /* item+$46: type of the magic effect: bit7 = passive effect, bits 0..6 type */
            v = mask_byte(it->b[0x46], 0x7F);
            if (stat == 0) {
                if (v == 3) {
                    f.cand = 0x12;
                    f.cand_ext = 0x64;
                } else if (v == 5) {
                    /* item+$45: spell/parameter of the magic item (bit 7 excluded) */
                    switch (it->b[0x45]) {
                    case 0: f.cand = 0x12; f.cand_ext = 0x64; break;
                    case 1: f.cand = 0x13; break;
                    case 2: f.cand = 0x14; break;
                    case 3: f.cand = 0x15; break;
                    case 4: f.cand = 0x16; break;
                    case 5: f.cand = 0x17; break;
                    case 6: f.cand = 0x18; break;
                    default: break;
                    }
                }
                stat_take_max(&f);
            }
        }
    }
    switch (stat) {
    case 0:                             /* $1D7C */
        if (find_effect(c, 0x26, &e)) {
            effect_stat_value(e, &f.cand, &f.cand_ext);
            if (f.value <= 0x12 && f.ext < 0x64) {
                f.cand = (u16)(f.value + f.cand);
                if (f.cand > 0x12) {
                    /* ch+$100: fighter level; ch+$108: previous fighter level */
                    if (c->b[0x100] > 0 || c->b[0x108] > 0 ||
                        /* ch+$105: knight level; ch+$10D: previous knight level */
                        c->b[0x105] > 0 || c->b[0x10D] > 0 ||
                        /* ch+$102: ranger level; ch+$10A: previous ranger level */
                        c->b[0x102] > 0 || c->b[0x10A] > 0) {
                        /* ch+$1C: current exceptional strength (18/xx, 1..100) */
                        f.cand_ext = (u16)(c->b[0x1C] + (f.cand - 0x12) * 10);
                        if (f.cand_ext > 0x64) {
                            f.cand_ext = 0x64;
                        }
                        f.cand = 0x12;
                    } else {
                        f.cand = 0x12;
                    }
                }
            }
            stat_take_max(&f);
        }
        if (find_effect(c, 0x71, &e)) {
            effect_stat_value(e, &f.cand, &f.cand_ext);
            stat_take_max(&f);
        }
        if (find_effect(c, 0x0C, &e)) {
            effect_stat_value(e, &f.cand, &f.cand_ext);
            stat_take_max(&f);
        }
        if (override != 0xFF) {
            /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength */
            c->b[0x11] = (u8)override;
            c->b[0x1C] = 0; /* ch+$1C: current exceptional strength (18/xx, 1..100) */
        } else {
            /* ch+$11: current abilities, 6 entries step 2 from +$11; current strength */
            c->b[0x11] = (u8)f.value;
            c->b[0x1C] = (u8)f.ext; /* ch+$1C: current exceptional strength (18/xx, 1..100) */
        }
        break;
    case 3:                             /* $20FA */
        if (override != 0xFF) {
            c->b[0x17] = (u8)override; /* ch+$17: current dexterity */
        } else {
            c->b[0x17] = (u8)f.value; /* ch+$17: current dexterity */
        }
        break;
    case 4:                             /* $1EF6 */
        count = 0;
        old_hp = c->b[0x64]; /* ch+$64: maximum hit points */
        /* ch+$64: maximum hit points; ch+$123: maximum HP without constitution; base -1 of
         * the spell slots +$124 */
        c->b[0x64] = c->b[0x123];
        for (k = 0; k <= 7; ++k) {
            lvl = c->b[0x106 + k]; /* ch+$106: levels of the previous class, 8 entries like +$FE; cleric */
            if (lvl > 0) {
                stat_con_hp(&f, lvl, k);
            }
            lvl = c->b[0xFE + k]; /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric */
            if (lvl > 0) {
                ++count;
            }
            if (lvl > H005_B(0x5026 + k)) { /* $5026: maximum hit dice level per class (byte, 0..7) */
                lvl = H005_B(0x5026 + k); /* $5026: maximum hit dice level per class (byte, 0..7) */
            }
            /* ch+$DC: use: threshold for the levels +$106..+$10D and the HP; !=0 forbids Modify */
            if (lvl > c->b[0xDC]) {
                /* ch+$DC: use: threshold for the levels +$106..+$10D and the HP; !=0 forbids Modify */
                lvl = (u16)(lvl - c->b[0xDC]);
                stat_con_hp(&f, lvl, k);
            }
        }
        f.sum = (u16)(f.sum / count);
        add_to_byte(&c->b[0x64], f.sum); /* ch+$64: maximum hit points */
        if (c->b[0x64] > old_hp) { /* ch+$64: maximum hit points */
            /* ch+$1A8: current hit points; ch+$64: maximum hit points */
            add_to_byte(&c->b[0x1A8], (u16)(c->b[0x64] - old_hp));
        }
        if (c->b[0x64] < old_hp) { /* ch+$64: maximum hit points */
            /* ch+$1A8: current hit points; ch+$64: maximum hit points */
            if (c->b[0x1A8] > (u16)(old_hp - c->b[0x64])) {
                /* ch+$1A8: current hit points; ch+$64: maximum hit points */
                c->b[0x1A8] = (u8)(c->b[0x1A8] - (old_hp - c->b[0x64]));
            } else {
                c->b[0x1A8] = 0; /* ch+$1A8: current hit points */
            }
        }
        c->b[0x19] = (u8)f.value; /* ch+$19: current constitution */
        if (c->b[0x19] >= 0x14) { /* ch+$19: current constitution */
            if (!find_effect(c, 0x3E, &e)) {
                add_effect(c, 0x3E, 0x3C, 0xFF, 1);
            }
        } else {
            remove_effect(c, 0x3E, NULL);
        }
        break;
    case 5:                             /* $2122 */
        if (find_effect(c, 0x0E, &e)) {
            /* eff+$4: parameter/level of the effect (for $28 high nibble = cloud no.) */
            f.value = (u16)(f.value + e->b[4]);
        }
        c->b[0x1B] = (u8)f.value; /* ch+$1B: current charisma */
        break;
    default:
        break;
    }
}

/* PORT H062+$18AC: if c has effect type it removes it with "is Cured". */
u8 cure_effect(Character *c, u16 type)
{
    CokEffect *e;                       /* -$6(a5) */
    u8 ok = 0;                          /* -$1(a5) */

    if (find_effect(c, type, &e)) {
        show_char_message(c, 8, "is Cured", 0x0A, 1);
        remove_effect(c, type, e);
        ok = 1;
    }
    return ok;
}

/* PORT H062+$1916: effect value for strength str (18: exceptional + 1). */
static u16 strength_effect_value(u16 str, u16 ext)
{
    u16 v = (u16)(str + 0x64);          /* -$2(a5) */

    if (str == 0x12) {
        v = (u16)(ext + 1);
    }
    return v;
}

/*
 * PORT H062+$19C2: does strength str/ext exceed the base one of c (+$10, +$1D)?
 * In *value the value for the effect.
 */
u8 strength_raises(Character *c, u16 str, u16 ext, u16 *value)
{
    u8 ok;                              /* -$f(a5) */

    /* pg+$10: caratteristiche base, 6 voci passo 2 (FOR INT SAG DES COS CAR); FOR; ch+$1D: base
     * exceptional strength */
    if (str > c->b[0x10] || (str == 0x12 && ext > c->b[0x1D])) {
        ok = 1;
        *value = strength_effect_value(str, ext);
    } else {
        ok = 0;
    }
    return ok;
}

/*
 * PORT H062+$057C: if *cp has effect type (or, for $15, $2D, $2E and $31,
 * a party member has it and in combat *cp is in its area) it
 * calls its handler.  The table H005+$2A3E is saved and restored.
 */
static void trigger_effect(Character **cp, u16 type)
{
    u8 saved_area[0xA0];                /* -$a0(a5): 40 longwords */
    CokEffect *e;                       /* -$a8(a5) */
    Character *p = g_party_head;        /* -$a4(a5) */
    u16 radius;                         /* -$ae(a5) */
    u16 a;
    u16 b;
    u16 i;                              /* -$ac(a5) */
    u8 found = 0;                       /* -$a9(a5) */

    if (find_effect(*cp, type, &e)) {
        found = 1;
    } else if (type == 0x15 || type == 0x2D || type == 0x2E || type == 0x31) {
        /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
        memcpy(saved_area, &H005_B(0x2A3E), 0xA0);
        for (; p != NULL && !found; p = p->next) {
            if (find_effect(p, type, &e)) {
                /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
                if (H005_B(0x3DE3) == 5) {
                    radius = (type == 0x31) ? 6 : 1;
                    a = combatant_x(p);
                    b = combatant_y(p);
                    find_in_area((s16)a, (s16)b, radius, 0xFF,
                                 combatant_size(p), g_combat_area);
                    /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
                    for (i = 1; i <= H005_B(0x2479); ++i) {
                        /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
                        if (H005_B(0x2A3E + (i - 1) * 4) ==
                            combatant_index(*cp)) {
                            found = 1;
                        }
                    }
                } else {
                    found = 1;
                }
            }
        }
        /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
        memcpy(&H005_B(0x2A3E), saved_area, 0xA0);
    }
    if (found) {
        call_effect_handler(type, cp, e, 0);
    }
}

/*
 * PORT H062+$0772: magic resistance (+$196) of c against the effect
 * $2475 / the damage $2474: if it resists it clears them (except $5B and $52).
 */
static void magic_resistance(Character *c)
{
    /* ch+$196: magic resistance */
    u16 mr = c->b[0x196];               /* -$2(a5) */
    u16 chance;                         /* -$4(a5) */
    s16 level;                          /* -$6(a5) */

    if (mr == 0 || H005_B(0x2475) == 0) { /* $2475: incoming effect (0 = cancelled by the handlers) */
        return;
    }
    /* $2474: incoming damage points, changeable by the effect handlers; $2473: type of the
     * incoming damage (bits: 1 fire, 2 cold, 8, $20) */
    if (H005_B(0x2474) != 0 && !mask_byte(H005_B(0x2473), 8)) {
        return;
    }
    level = caster_level(H005_B(0x2471)); /* $2471: spell being cast (0 = none) */
    chance = (u16)((0x0B - level) * 5 + mr);
    if (roll_dice(1, 0x64) <= chance) {
        H005_B(0x2474) = 0; /* $2474: incoming damage points, changeable by the effect handlers */
        /* $2475: incoming effect (0 = cancelled by the handlers) */
        if (H005_B(0x2475) != 0x5B && H005_B(0x2475) != 0x52) {
            H005_B(0x2475) = 0; /* $2475: incoming effect (0 = cancelled by the handlers) */
        }
    }
}

/* Effects checked by H062+$083E for every event (0..$18). */
static const u8 s_ev1[] = { 0x25, 0x19, 0 };
static const u8 s_ev2[] = { 0x58, 0x57, 0x56, 0x51, 0x45, 0x40, 0x41, 0 };
static const u8 s_ev3[] = { 0x45, 0x40, 0x41, 0x51, 0x56, 0x57, 0 };
static const u8 s_ev4[] = { 7, 0x1D, 0x4B, 0x69, 0x72, 0x73, 0x75, 0 };
static const u8 s_ev5[] = { 0x3B, 0x1C, 0x29, 0x64, 0x67, 0x5D, 0x65, 0x70, 0 };
static const u8 s_ev6[] = { 0x47, 0x3B, 0x3D, 0x0A, 0x14, 0x66, 0x11, 0x1C,
                            0x62, 0x49, 0x3F, 0 };
static const u8 s_ev7[] = { 0x33, 0x34, 0x35, 0x1F, 3, 0x1B, 0 };
static const u8 s_ev8[] = { 0x52, 0x59, 0x38, 0 };
static const u8 s_ev9[] = { 0x47, 0x74, 0x5C, 0x3B, 0x5F, 0x60, 0x61, 0x62,
                            0x63, 0x12, 0x3F, 0 };
static const u8 s_ev10[] = { 7, 0x76, 0x77, 0x39, 1, 2, 0x21, 0x24, 0x31,
                             0x1A, 0x4B, 0 };
static const u8 s_ev11[] = { 0x21, 0x11, 8, 9, 0x2D, 0x2E, 0x1E, 0 };
static const u8 s_ev12[] = { 0x5E, 8, 9, 0x0A, 0x11, 0x14, 0x21, 0x24, 0x2D,
                             0x2E, 0x31, 0x3D, 0x63, 0x32, 0x36, 0 };
static const u8 s_ev13[] = { 0x44, 0x43, 0x0D, 0x20, 0x46, 0 };
static const u8 s_ev14[] = { 6, 0x55, 0x54, 0x53, 0x4E, 0x4A, 4, 0x5A, 0x68, 0 };
static const u8 s_ev15[] = { 0x4F, 0x4C, 0x48, 0x42, 0x30, 0x15, 0x1E, 0x0B,
                             0x4D, 0 };
static const u8 s_ev16[] = { 0x19, 0x25, 0x2F, 0x59, 0 };
static const u8 s_ev17[] = { 1, 2, 0x0B, 0 };
static const u8 s_ev18[] = { 0x27, 0x2A, 0 };
static const u8 s_ev19[] = { 0x17, 0x38, 0x0B, 0 };
static const u8 s_ev20[] = { 0x32, 0x36, 0 };
static const u8 s_ev21[] = { 0x23, 0 };
static const u8 s_ev24[] = { 0x52, 0 };
static const u8 *const s_events[0x19] = {
    NULL, s_ev1, s_ev2, s_ev3, s_ev4, s_ev5, s_ev6, s_ev7, s_ev8, s_ev9,
    s_ev10, s_ev11, s_ev12, s_ev13, s_ev14, s_ev15, s_ev16, s_ev17, s_ev18,
    s_ev19, s_ev20, s_ev21, NULL, NULL, s_ev24
};

/*
 * PORT H062+$083E (body at $0F04): event event for *cp: calls in
 * order the handlers of the effects of the event (table at $0ED2); the
 * events 6 and 9 first check the magic resistance.
 */
void trigger_event(Character **cp, u16 event)
{
    const u8 *list;

    if (event > 0x18) {
        return;
    }
    if (event == 6 || event == 9) {
        magic_resistance(*cp);
    }
    list = s_events[event];
    if (list == NULL) {
        return;
    }
    for (; *list != 0; ++list) {
        trigger_effect(cp, *list);
    }
}

/*
 * PORT H062+$0114: applies to t the effect type (duration dur, level lvl),
 * unless resisted ("is Unaffected"); an identical effect with a duration is
 * replaced; then the message text (if any).
 */
void apply_spell_effect_on(Character *t, u16 type, u16 dur, u16 lvl, u8 b5,
                           u8 kind, u8 saved, u16 len, const char *text)
{
    CokEffect *e;                       /* -$4(a5) */

    H005_B(0x2475) = (u8)type; /* $2475: incoming effect (0 = cancelled by the handlers) */
    trigger_event(&t, 9);
    /* $2475: incoming effect (0 = cancelled by the handlers) */
    if (H005_B(0x2475) == 0 || (saved && kind == 1)) {
        show_char_message(t, 0x0D, "is Unaffected", 0x0A, 1);
        return;
    }
    /* eff+$2: (word) remaining duration of the effect, decreased with time; 0 = permanent */
    if (find_effect(t, type, &e) && COK_GET16(&e->b[2]) > 0) {
        remove_effect(t, type, e);
    }
    add_effect(t, type, dur, lvl, b5);
    if (text[0] != 0) {
        show_effect_message(t, 1, len, text);
        clear_message_area();
    }
}

/*
 * PORT H062+$12F6: to-hit roll of attacker against target (d20 die
 * in $2A1A, 20 counts as 100, 1 always misses) with thac0 +$19B and the bonus of
 * B+$6E2/$6E0.
 */
u8 attack_roll(Character *attacker, Character *defender, u16 target)
{
    s16 mod;                            /* -$2(a5) */
    u8 hit = 0;                         /* -$3(a5) */
    s32 d;

    remove_effects_19(attacker);
    /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
    H005_SET_W(0x2A1A, roll_dice(1, 0x14));
    /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
    if ((s16)H005_W(0x2A1A) <= 1) {
        return 0;
    }
    /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
    if (H005_W(0x2A1A) == 0x14) {
        /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
        H005_SET_W(0x2A1A, 0x64);
    }
    trigger_event(&attacker, 0x0A);
    trigger_event(&defender, 0x10);
    if (attacker->b[0x199] == 0) { /* ch+$199: side in combat (0 party, 1 opponents) */
        /* B+$6E2: (word) to-hit bonus of the party (side 0) */
        mod = (s16)COK_GET16(g_state_b + 0x6E2);
    } else {
        /* B+$6E0: (word) to-hit bonus of the enemies (side 1) */
        mod = (s16)COK_GET16(g_state_b + 0x6E0);
    }
    /* Here the original has a switch on the constant value 500: no case. */
    /* ch+$19B: encoded current THAC0 (60 - THAC0) */
    debug_trace(5, "thac0", attacker->b[0x19B], (u8)target, (u8)mod);
    /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
    if ((s16)H005_W(0x2A1A) >= 0) {
        /* ch+$19B: encoded current THAC0 (60 - THAC0); $2A1A: (word) to-hit roll: d20 (20 counts
         * as 100) + effect modifiers */
        d = (s16)(attacker->b[0x19B] + H005_W(0x2A1A) + mod);
        if (d >= (s16)target) {
            hit = 1;
        }
    }
    return hit;
}

/*
 * PORT H062+$142C: saving throw of c of type kind (d20 in $2476, 1
 * always fails and 20 always succeeds) against +$D4+kind; result in $24A5.
 */
u8 saving_throw_roll(Character *c, u8 kind, s16 bonus)
{
    H005_B(0x24A5) = 1; /* $24A5: outcome of the last saving throw (1 succeeded) */
    /* $2476: saving throw: d20 plus the bonuses of the effect handlers */
    H005_B(0x2476) = (u8)roll_dice(1, 0x14);
    if (H005_B(0x2476) == 1) { /* $2476: saving throw: d20 plus the bonuses of the effect handlers */
        H005_B(0x24A5) = 0; /* $24A5: outcome of the last saving throw (1 succeeded) */
        return H005_B(0x24A5); /* $24A5: outcome of the last saving throw (1 succeeded) */
    }
    if (H005_B(0x2476) == 0x14) { /* $2476: saving throw: d20 plus the bonuses of the effect handlers */
        H005_B(0x24A5) = 1; /* $24A5: outcome of the last saving throw (1 succeeded) */
        return H005_B(0x24A5); /* $24A5: outcome of the last saving throw (1 succeeded) */
    }
    /* ch+$103: mage level; ch+$5F: mage order (1 alignm. 0/3/6, 2 for 1/4/7, 0 none) */
    if (c->b[0x103] > 0 && c->b[0x5F] > 0) {
        /* A+$3F0: tab. of cycle phase words (idx CH+$5F, 1..3); entry 0 set to 1 by H070; ch+$5F:
         * mage order (1 alignm. 0/3/6, 2 for 1/4/7, 0 none) */
        switch (COK_GET16(g_state_a + (c->b[0x5F] + 0x1F8) * 2)) {
        case 0:
            --bonus;
            break;
        case 2:
            ++bonus;
            break;
        default:
            break;
        }
    }
    /* $2476: saving throw: d20 plus the bonuses of the effect handlers; ch+$18A: saving throw
     * bonus from the readied items (word, +$38) */
    H005_B(0x2476) = (u8)(H005_B(0x2476) + CH_W(c, 0x18A) + bonus);
    H005_B(0x2A13) = kind; /* $2A13: type of the saving throw in progress (index into +$D4), for the effects */
    trigger_event(&c, 0x0C);
    /* $2476: saving throw: d20 plus the bonuses of the effect handlers; ch+$D4: saving throws, 5
     * entries (+$D4..+$D8) per type; minimum d20 value */
    if (H005_B(0x2476) >= c->b[0xD4 + kind]) {
        H005_B(0x24A5) = 1; /* $24A5: outcome of the last saving throw (1 succeeded) */
    } else {
        H005_B(0x24A5) = 0; /* $24A5: outcome of the last saving throw (1 succeeded) */
    }
    return H005_B(0x24A5); /* $24A5: outcome of the last saving throw (1 succeeded) */
}

/* PORT H062+$17C0: removes from c the effects that end when it is down. */
void drop_effects(Character *c)
{
    static const u8 types[0x10] = {
        3, 0x0B, 0x15, 0x17, 0x1B, 0x1E, 0x1F, 0x33,
        0x34, 0x35, 0x5B, 0x6A, 0x6B, 0x6F, 0x76, 0x77
    };                                  /* -$26(a5) */
    CokEffect *e;                       /* -$6(a5) */
    u16 i;                              /* -$2(a5) */

    for (i = 1; i <= 0x10; ++i) {
        remove_effect(c, types[i - 1], NULL);
    }
    /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
    if (find_effect(c, 0x4D, &e) && c->b[0xEC] == 0xB3) {
        c->b[0x199] = 0; /* ch+$199: side in combat (0 party, 1 opponents) */
    }
}

/*
 * PORT H062+$2188: c takes dmg damage points ($2474) of type $2473;
 * saved: type 1 no damage, type 2 half.  Messages "takes .. points
 * of damage from ..", then "Goes Down" / "is killed".
 */
void apply_damage(Character *c, u16 dmg, u8 kind, u8 saved)
{
    char text[0x52];                    /* -$52(a5) */
    char number[0x52];                  /* -$a4(a5) */
    u8 ended;                           /* -$a5(a5) */
    u8 *turn;

    H005_B(0x2474) = (u8)dmg; /* $2474: incoming damage points, changeable by the effect handlers */
    trigger_event(&c, 6);
    if (saved) {
        switch (kind) {
        case 1:
            H005_B(0x2474) = 0; /* $2474: incoming damage points, changeable by the effect handlers */
            break;
        case 2:
            /* $2474: incoming damage points, changeable by the effect handlers */
            H005_B(0x2474) = (u8)(H005_B(0x2474) >> 1);
            break;
        default:
            break;
        }
    } else {
        trigger_event(&c, 0x14);
    }
    /* $2474: incoming damage points, changeable by the effect handlers; ch+$198: active/standing
     * (0 down or out of the combat) */
    if (H005_B(0x2474) == 0 || !c->b[0x198]) {
        return;
    }
    if (H005_B(0x2474) != 1) { /* $2474: incoming damage points, changeable by the effect handlers */
        strcpy(text, "takes ");
        /* $2474: incoming damage points, changeable by the effect handlers */
        format_number(0x50, number, H005_B(0x2474), 0, 0x0A, 3, ' ');
        trim_leading_spaces(0x50, number);
        h026_append(0x50, text, 0x50, number);
        h026_append(0x50, text, 0x12, " points of damage ");
    } else {
        strcpy(text, "takes 1 point of damage ");
    }
    /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
    switch (mask_byte(H005_B(0x2473), 0xF7)) {
    case 1:
        h026_append(0x50, text, 9, "from Fire");
        break;
    case 2:
        h026_append(0x50, text, 9, "from Cold");
        break;
    case 4:
        h026_append(0x50, text, 0x10, "from Electricity");
        break;
    case 0x10:
        h026_append(0x50, text, 9, "from Acid");
        break;
    default:
        break;
    }
    /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
    if (mask_byte(H005_B(0x2473), 8) == H005_B(0x2473)) {
        h026_append(0x50, text, 0x0A, "from Magic");
    }
    show_effect_message(c, 0, 0x50, text);
    /* $2474: incoming damage points, changeable by the effect handlers */
    damage_hit_points(c, H005_B(0x2474));
    if (H005_B(0x3DE3) == 5) { /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
        turn = c->block_192->b;
        turn[1] = 0;
        if (turn[0] > 0) {
            show_char_message(c, 0x0C, "lost a spell", 0x0C, 1);
            forget_spell(c, turn[0]);
            ended = end_combat_turn(c);
            (void)ended;
        }
    }
    if (!c->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
        strcpy(text, "Goes Down");
        if (c->b[0x197] == 5) { /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
            h026_append(0x50, text, 0x0E, ", and is Dying");
        }
        /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
        if (c->b[0x197] == 6 || c->b[0x197] == 8 || c->b[0x197] == 7) {
            strcpy(text, "is killed");
        }
        /* $334C: (word) text cursor: row */
        show_char_message(c, 0x50, text, (u16)(H005_W(0x334C) + 1), 0);
        /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
        if (H005_B(0x3DE3) != 5) {
            message_delay();
        } else {
            drop_effects(c);
            trigger_event(&c, 0x0D);
            /* ch+$198: active/standing (0 down or out of the combat); ch+$197: status: 0 ok, 4
             * unconscious, 5 dying, 6-8 dead, $0A down */
            if (!c->b[0x198] && c->b[0x197] != 0x0A) {
                combatant_falls(c);
            } else {
                message_delay();
            }
        }
    }
    clear_message_area();
}

/* PORT H062+$15C6: dice roll that notes the number of dice in $2470. */
u16 roll_damage_dice(u16 count, u16 sides)
{
    H005_B(0x2470) = (u8)count; /* $2470: number of dice of the last damage roll */
    return roll_dice(count, sides);
}

/*
 * PORT H062+$02FA: message text and, if c is not already dead (6-8), it
 * puts it down in status status (events $D, H048+$12F4).
 */
void knock_out(Character *c, u8 status, u16 len, const char *text)
{
    show_char_message(c, len, text, 0x0A, 0);
    /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
    if (c->b[0x197] == 7 || c->b[0x197] == 6 || c->b[0x197] == 8) {
        return;
    }
    c->b[0x197] = status; /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
    c->b[0x198] = 0; /* ch+$198: active/standing (0 down or out of the combat) */
    c->b[0x1A8] = 0; /* ch+$1A8: current hit points */
    drop_effects(c);
    trigger_event(&c, 0x0D);
    /* ch+$198: active/standing (0 down or out of the combat); ch+$197: status: 0 ok, 4
     * unconscious, 5 dying, 6-8 dead, $0A down */
    if (!c->b[0x198] && c->b[0x197] != 0x0A) {
        combatant_falls(c);
    }
    message_delay();
    clear_message_area();
    if (H005_B(0x3DE3) != 5) { /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
        draw_party(g_current_char);
    }
}

/*
 * PORT H062+$2650: stands c up with hp hit points if it finds room
 * (H048+$16D4), with the message text; recomputes the sides.
 */
u8 revive(Character *c, u16 hp, u16 len, const char *text)
{
    u8 saved;                           /* -$1(a5) */
    u8 a = (u8)combatant_x(c);
    u8 b = (u8)combatant_y(c);

    if (!place_combatant(c, a, b, 1)) {
        return 0;
    }
    c->b[0x197] = 0; /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
    c->b[0x198] = 1; /* ch+$198: active/standing (0 down or out of the combat) */
    c->b[0x1A8] = (u8)hp; /* ch+$1A8: current hit points */
    if (H005_B(0x3DE3) == 5) { /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
        saved = H005_B(0x24C6); /* $24C6: 1 if the combatant's actions must be drawn (visible) */
        H005_B(0x24C6) = 1; /* $24C6: 1 if the combatant's actions must be drawn (visible) */
        show_combatant_cursor(c, 3, 0);
        H005_B(0x24C6) = saved; /* $24C6: 1 if the combatant's actions must be drawn (visible) */
    }
    show_effect_message(c, 1, len, text);
    count_sides();
    return 1;
}

/*
 * PORT H062+$2734: the characters down in the list H005+$16 ($14 = how many)
 * explode: "explodes.", 1d6 to the combatants of the area not in status $A,
 * then they go to status 6 and the list is emptied.  The original writes +$198,
 * +$197 and calls H048+$12F4 also for an empty entry (NULL): skipped here.
 * Radius 1: at most 9 squares, so 8 neighbours in the list.
 */
void explode_fallen(void)
{
    u16 i;                              /* -$2(a5) */
    u16 j;                              /* -$4(a5) */
    Character *p;                       /* -$8(a5) */
    u16 list[8];                        /* -$18(a5) */
    u16 n;                              /* -$1A(a5) */
    u16 a;
    u16 b;
    Character *q;

    H005_B(0x2473) = 0; /* $2473: type of the incoming damage (bits: 1 fire, 2 cold, 8, $20) */
    /* $14: number of characters on the ground in the list +$16 (word, max 20) */
    for (i = 1; i <= H005_W(0x14); ++i) {
        p = g_h005_0016[i - 1];
        if (p != NULL) {
            show_char_message(p, 9, "explodes.", 0x0A, 1);
            a = combatant_x(p);
            b = combatant_y(p);
            find_in_area((s16)a, (s16)b, 1, 0xFF,
                         combatant_size(p), g_combat_area);
            /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
            if (H005_B(0x2479) > 1) {
                /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
                n = (u16)(H005_B(0x2479) - 1);
                /* $2479: number of entries of the area list +$2A3E (4 bytes per entry) */
                for (j = 2; j <= H005_B(0x2479); ++j) {
                    /* $2A3E: area list: 4-byte entries ($2479), byte 0 = combatant no. */
                    list[j - 2] = H005_B(0x2A3E + (j - 1) * 4);
                }
                for (j = 1; j <= n; ++j) {
                    q = g_combatants[list[j - 1] - 1];
                    /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
                    if (q->b[0x197] != 0x0A) {
                        apply_damage(q, roll_damage_dice(1, 6), 0, 0);
                    }
                }
            }
        }
        if (p == NULL) {
            continue;
        }
        p->b[0x198] = 0; /* ch+$198: active/standing (0 down or out of the combat) */
        p->b[0x197] = 6; /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
        combatant_falls(p);
    }
    if (H005_W(0x14) > 0) { /* $14: number of characters on the ground in the list +$16 (word, max 20) */
        H005_SET_W(0x14, 0); /* $14: number of characters on the ground in the list +$16 (word, max 20) */
        /* H029+$0312 on $50 bytes: the 20 pointers of the list. */
        memset(g_h005_0016, 0, sizeof g_h005_0016);
    }
}

/*
 * PORT H062+$021E (Yell): c becomes the preferred target ($2432); every
 * standing opponent (+$197 = 0) with +$13 > 3, not helpless, that
 * fails the saving throw "wants to kill <name>" (effect $5B).
 */
void yell_challenge(Character *c)
{
    Character *p;                       /* -$4(a5) */
    char msg[0x51];                     /* -$56(a5) */

    g_h005_2432 = c;
    for (p = g_party_head; p != NULL; p = p->next) {
        /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down; ch+$13:
         * current intelligence */
        if (p->b[0x197] != 0 || p->b[0x13] <= 3 ||
            /* ch+$199: side in combat (0 party, 1 opponents) */
            p->b[0x199] == c->b[0x199] || is_helpless(p) ||
            saving_throw_roll(p, 4, 0)) {
            continue;
        }
        strcpy(msg, "wants to kill ");
        h026_append(0x50, msg, 0x0F, (const char *)c->b);
        apply_spell_effect_on(p, 0x5B, 0, 0xFF, 0, 0, 0, 0x50, msg);
    }
}

/*
 * PORT H062+$0F24: owner of the cloud of the list list that covers
 * (x, y) with one of the count squares; the directions are dirs[1..count]
 * (copy by value of len bytes: the original reads dirs[count], past the
 * copy, from the stack; here the next byte of H005+$5022).  Without a cloud the
 * first of the party.
 */
static Character *cloud_owner_at(s16 x, s16 y, CokCloud *list, u16 count,
                                 u16 len, const u8 *dirs)
{
    CokCloud *p = list;                 /* -$4(a5) */
    u8 found = 0;                       /* -$5(a5) */
    u16 i;                              /* -$8(a5) */

    (void)len;
    while (p != NULL && !found) {
        for (i = 1; i <= count; ++i) {
            /* nube+$9: base of the table of 4 covered-square flags +$A..+$D (index 1..4) */
            if (p->b[0x12 - 8 + i - 1] &&
                /* nube+$14: (word) x of the centre of the cloud/pool; $3EE2: (word) x offset for
                 * direction d (step 2) */
                (s16)(COK_GET16(&p->b[0x1C - 8]) + H005_W(0x3EE2 + dirs[i] * 2)) == x &&
                /* nube+$16: (word) y of the centre of the cloud/pool; $3ED0: (word) y offset for
                 * direction d (step 2) */
                (s16)(COK_GET16(&p->b[0x1E - 8]) + H005_W(0x3ED0 + dirs[i] * 2)) == y) {
                found = 1;
            }
        }
        if (!found) {
            p = p->next;
        }
    }
    return found ? p->owner : g_party_head;
}

/*
 * PORT H062+$1038: c in a cloud (with in_cloud, if it does not have $1F/$63/$3F):
 * with the saving throw "starts to cough" ($1E), without it "chokes and gags from
 * nausea" ($1F), cast by the owner of the cloud; in an acid
 * pool 1d6 of damage.  In the first case the original passes to the handler
 * the effect -$8(a5) of the previous searches (the same here).
 */
void check_cloud(Character *c, u8 in_cloud)
{
    u16 blocker;                        /* -$4(a5) */
    u16 tile;                           /* -$2(a5) */
    u8 cloud;                           /* -$E(a5) */
    u8 acid;                            /* -$F(a5) */
    CokEffect *e8 = NULL;               /* -$8(a5) */
    CokEffect *ec;                      /* -$C(a5) */
    u8 saved;                           /* -$D(a5) */
    Character *save;                    /* -$14(a5) */

    if (!c->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
        return;
    }
    probe_move(c, 8, &blocker, &tile, &cloud, &acid);
    if (cloud && in_cloud && !find_effect(c, 0x1F, &e8) &&
        !find_effect(c, 0x63, &e8) && !find_effect(c, 0x3F, &e8)) {
        saved = saving_throw_roll(c, 0, 0);
        save = g_current_char;
        g_current_char = cloud_owner_at((s16)combatant_x(c),
                                        (s16)combatant_y(c), g_clouds, 4, 3,
                                        /* $5022: directions of the 4 squares around the centre of a
                                         * cloud */
                                        &H005_B(0x5022));
        if (saved) {
            apply_spell_effect_on(c, 0x1E, (u16)(roll_dice(1, 4) + 1), 0xFF,
                                  0, 0, saved, 0x0F, "starts to cough");
            ec = NULL;
            if (find_effect(c, 0x1E, &ec)) {
                call_effect_handler(0x1E, &c, e8, 0);
            }
        } else {
            apply_spell_effect_on(c, 0x1F, (u16)(roll_dice(1, 4) + 1), 0xFF,
                                  0, 0, saved, 0x1B,
                                  "chokes and gags from nausea");
            if (find_effect(c, 0x1F, &e8)) {
                call_effect_handler(0x1F, &c, e8, 0);
            }
        }
        g_current_char = save;
    }
    if (acid) {
        apply_damage(c, roll_damage_dice(1, 6), 0, 0);
    }
}

/*
 * PORT H062+$1694: c falls into status status with the message text (by
 * value): it leaves the map and, if the turn ends, loses the effects
 * tied to it.  With a status other than 3 the hit points go to 0.
 */
void fall_down(Character *c, u8 status, u16 len, const char *text)
{
    char copy[0x52];
    u16 n;                              /* -$2(a5) */

    h026_copy(0x50, copy, len, text);
    if (!c->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
        return;
    }
    n = combatant_index(c);
    show_combatant_cursor(c, 3, 0);
    show_char_message(c, len, copy, 0x0A, 1);
    c->b[0x198] = 0; /* ch+$198: active/standing (0 down or out of the combat) */
    c->b[0x197] = status; /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
    if (c->b[0x197] != 3) { /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
        c->b[0x1A8] = 0; /* ch+$1A8: current hit points */
    }
    redraw_ground(0, 0, n);
    /* $3159: combatant positions +5: shape/size (0 = off the map) */
    H005_B(0x3154 + (n - 1) * 6 + 5) = 0;
    rebuild_occupancy();
    if (end_combat_turn(c)) {
        drop_effects(c);
    }
}

/* PORT H062+$1898: link/unlk, no effect. */
void h062_nop_1898(void)
{
}

/*
 * PORT H062+$126C: to-hit roll on c (d20 in $2A1A, 20 counts as 100; event
 * $10): it hits if the roll plus bonus exceeds the AC (+$19C).  With 1 no.
 */
u8 ecl_attack_hits(Character *c, u16 bonus)
{
    u8 hit = 0;                         /* -$1(a5) */

    /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
    H005_SET_W(0x2A1A, roll_dice(1, 0x14));
    /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
    if ((s16)H005_W(0x2A1A) > 1) {
        /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
        if (H005_W(0x2A1A) == 0x14) {
            /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
            H005_SET_W(0x2A1A, 0x64);
        }
        trigger_event(&c, 0x10);
        /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers */
        if ((s16)H005_W(0x2A1A) >= 0 &&
            /* $2A1A: (word) to-hit roll: d20 (20 counts as 100) + effect modifiers; ch+$19C:
             * encoded current armour class (60 - AC) */
            (u16)(H005_W(0x2A1A) + bonus) > c->b[0x19C]) {
            hit = 1;
        }
    }
    return hit;
}
