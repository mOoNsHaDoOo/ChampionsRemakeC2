/* H058: Resting, memorisation and the passing of time; partial detail. */
#include "h058.h"
#include "globals.h"
#include "h029_gfx.h"
#include "h034.h"
#include "h062.h"
#include "h008.h"
#include "h010_input.h"
#include "h030.h"
#include "h033.h"
#include "h045.h"
#include "h063.h"

/*
 * Module data below a4: -$28..-$1 one flag per party character
 * (still has timed effects).  g_h058_bss[0x28 - off] is -off(a4).
 */
u8 g_h058_bss[0x28];
#define H058_FLAG(i)    g_h058_bss[(i)]   /* -$28 + i */

/* Time counter: word of g_state_a + 2*idx (idx $C6..$CC, $1FC..). */
#define STATE_W(idx)    COK_GET16(g_state_a + (idx) * 2)
#define STATE_SETW(idx, v) COK_PUT16(g_state_a + (idx) * 2, (u16)(v))

/* PORT H058+$00CE: link/unlk, no effect. */
void h058_init(void)
{
}

/*
 * PORT H058+$018A (nested in $017C): counter idx reaches limit:
 * the cycle of idx-3 advances (0..3), its icon (8x8 tile in row 0)
 * changes and the counter goes back to 0; otherwise it advances.  For a different idx
 * the original would use an uninitialised tile and column (here 0).
 */
static void cycle_icon(u16 idx, u16 limit)
{
    u16 tile = 0;                       /* -$6 of the caller */
    u16 col = 0;                        /* -$4 of the caller */

    if (STATE_W(idx) < limit) {
        STATE_SETW(idx, STATE_W(idx) + 1);
        return;
    }
    if (STATE_W(idx - 3) >= 3) {
        STATE_SETW(idx - 3, 0);
    } else {
        STATE_SETW(idx - 3, STATE_W(idx - 3) + 1);
    }
    switch (idx) {
    case 0x1FC:
        /* A+$3F2: (word) phase (0..3) of cycle 1: frame icon column 8 */
        tile = (u16)(COK_GET16(g_state_a + 0x3F2) + 0x0A);
        col = 8;
        break;
    case 0x1FD:
        /* A+$3F4: (word) phase (0..3) of cycle 2: frame icon column $13 */
        tile = (u16)(COK_GET16(g_state_a + 0x3F4) + 6);
        col = 0x13;
        break;
    case 0x1FE:
        /* A+$3F6: (word) phase (0..3) of cycle 3: frame icon column $1E */
        tile = (u16)(COK_GET16(g_state_a + 0x3F6) + 0x0E);
        col = 0x1E;
        break;
    default:
        break;
    }
    draw_8x8_tile(col, 0, (u16)(tile + 0x114), 0, 0);
    STATE_SETW(idx, 0);
}

/* PORT H058+$017C: every hour the three icon cycles of the frame advance. */
static void hourly_icons(void)
{
    cycle_icon(0x1FC, 8);
    cycle_icon(0x1FD, 1);
    cycle_icon(0x1FE, 6);
}

/*
 * PORT H058+$052C: brings the time t[0..6] within the limits of H005+$500A
 * (carry to the next unit; every hour the icons; at the last unit
 * every character ages by one, +$62).
 */
static void normalize_time(u8 *t)
{
    u8 i;                               /* -$1(a5) */
    Character *p;                       /* -$6(a5) */

    for (i = 0; i <= 6; ++i) {
        /* $500A: (word) limits of the time units t[0..6] (carry) */
        if (COK_GET16(t + i * 2) < H005_W(0x500A + i * 2)) {
            continue;
        }
        if (i != 6) {
            COK_PUT16(t + (i + 1) * 2, COK_GET16(t + (i + 1) * 2) + 1);
            COK_PUT16(t + i * 2, /* $500A: (word) limits of the time units t[0..6] (carry) */
                      COK_GET16(t + i * 2) - H005_W(0x500A + i * 2));
            if (i == 3) {
                hourly_icons();
            }
        } else {
            for (p = g_party_head; p != NULL; p = p->next) {
                COK_PUT16(&p->b[0x62], COK_GET16(&p->b[0x62]) + 1); /* ch+$62: age (word) */
            }
        }
    }
}

/*
 * PORT H058+$02F4: lets amount units unit pass on the timed effects
 * of the characters (in steps of 10): the expired ones are removed.  Outside the
 * camp (context other than 2) all the characters must be checked;
 * in the camp only those that still have effects.
 */
static void age_effects(u16 amount, u8 unit)
{
    u16 i;                              /* -$4(a5) */
    u16 step;                           /* -$6(a5) */
    u16 left;                           /* -$8(a5) */
    Character *p;                       /* -$C(a5) */
    u8 found;                           /* -$E(a5) */
    u8 done;                            /* -$D(a5) */
    CokEffect *e;                       /* -$12(a5) */
    CokEffect *last;                    /* -$16(a5) */
    CokEffect *next;                    /* -$1A(a5) */
    u8 u;                               /* -$1(a5) */

    if (H005_B(0x3DE3) != 2) { /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
        h029_fill_bytes(0x27, g_h058_bss, 0x28, 1);
    } else {
        found = 0;
        i = 1;
        do {
            if (H058_FLAG(i - 1)) {
                found = 1;
            }
            ++i;
        /* B+$67C: (word) number of party members (max 8) */
        } while (!found && i <= COK_GET16(g_state_b + 0x67C));
        if (!found) {
            return;
        }
    }
    left = amount;
    for (u = unit; u > 1; --u) {
        /* $500A: (word) limits of the time units t[0..6] (carry) */
        left = (u16)(left * H005_W(0x500A + (u - 1) * 2));
    }
    while (left > 0) {
        step = (u16)(left > 0x0A ? 0x0A : left);
        i = 1;
        for (p = g_party_head; p != NULL; p = p->next) {
            if (H058_FLAG(i - 1)) {
                H058_FLAG(i - 1) = 0;
                e = p->effects;
                if (e != NULL) {
                    last = e;
                    while (last->next != NULL) {
                        last = last->next;
                    }
                    done = 0;
                    while (e != NULL && !done) {
                        next = e->next;
                        if (e == last) {
                            done = 1;
                        }
                        /* eff+$2: (word) remaining duration of the effect, decreased with
                         * time; 0 = permanent */
                        if (COK_GET16(&e->b[2]) != 0) {
                            /* eff+$2: (word) remaining duration of the effect, decreased with
                             * time; 0 = permanent */
                            if (COK_GET16(&e->b[2]) > step) {
                                /* eff+$2: (word) remaining duration of the effect, decreased with
                                 * time; 0 = permanent */
                                COK_PUT16(&e->b[2], COK_GET16(&e->b[2]) - step);
                                H058_FLAG(i - 1) = 1;
                            } else {
                                /* eff+$0: type of the effect (code of the handler) */
                                remove_effect(p, e->b[0], e);
                            }
                        }
                        e = next;
                    }
                    while (e != NULL) {
                        /* eff+$2: (word) remaining duration of the effect, decreased with
                         * time; 0 = permanent */
                        if (COK_GET16(&e->b[2]) > 0) {
                            H058_FLAG(i - 1) = 1;
                        }
                        e = e->next;
                    }
                }
            }
            ++i;
        }
        left = (u16)(left > 0x0A ? left - 0x0A : 0);
    }
}

/*
 * PORT H058+$064A: advances the game time (g_state_a +$18C, 7 words) by
 * amount units unit, then the timed effects.
 */
void advance_time(u16 amount, u8 unit)
{
    u8 t[0x0E];                         /* -$E(a5) */
    u8 i;                               /* -$F(a5) */
    u16 k;                              /* -$12(a5) */

    for (i = 0; i <= 6; ++i) {
        /* A+$18C: game time: 7 words from here (seconds, minutes, tens, hours, days) */
        COK_PUT16(&t[i * 2], STATE_W(0xC6 + i));
    }
    for (k = 1; k <= amount; ++k) {
        COK_PUT16(&t[unit * 2], COK_GET16(&t[unit * 2]) + 1);
        normalize_time(t);
    }
    for (i = 0; i <= 6; ++i) {
        /* A+$18C: game time: 7 words from here (seconds, minutes, tens, hours, days) */
        STATE_SETW(0xC6 + i, COK_GET16(&t[i * 2]));
    }
    age_effects(amount, unit);
}

/*
 * Rest time: 7 words at $24F4 (0 seconds, 1 minutes, 2 tens of
 * minutes, 3 hours, 4 days, 5..6 beyond), limits at $500A.
 */
/* $24F4: rest time: 7 words (sec, min, tens, hours, days, beyond) */
#define REST_T(i)       H005_W(0x24F4 + (i) * 2)
/* $24F4: rest time: 7 words (sec, min, tens, hours, days, beyond) */
#define REST_SET_T(i, v) H005_SET_W(0x24F4 + (i) * 2, (u16)(v))
#define REST_TIMER(i)   H005_B(0x24EC + (i))  /* per character */

/*
 * PORT H058+$05F4: normalises the rest time; the carry beyond the
 * days goes back into the days, at most 99.
 */
static void rest_normalize(void)
{
    /* $24F4: rest time: 7 words (sec, min, tens, hours, days, beyond) */
    normalize_time(&g_h005[0x24F4]);
    if (REST_T(5) > 0) { /* $24FE: rest time: carry beyond the days (word, entry 5) */
        /* $5012: (word) limit of unit 4 (days) for the carry; $24FE: rest time: carry beyond the days
         * (word, entry 5); $24FC: rest time: days, at most 99 (word, entry 4) */
        REST_SET_T(4, H005_W(0x5012) * REST_T(5) + REST_T(4));
        REST_SET_T(5, 0); /* $24FE: rest time: carry beyond the days (word, entry 5) */
        if (REST_T(4) > 0x63) { /* $24FC: rest time: days, at most 99 (word, entry 4) */
            REST_SET_T(4, 0x63); /* $24FC: rest time: days, at most 99 (word, entry 4) */
        }
    }
}

/*
 * PORT H058+$070E: removes amount units unit from the rest time,
 * borrowing from the larger units; if they are not enough the time
 * is cleared.
 */
static void rest_subtract(u16 amount, u8 unit)
{
    u8 j;                               /* -$1(a5) */
    u8 k;                               /* -$2(a5) */

    /* $24FC: rest time: days, at most 99 (word, entry 4); $24FA: rest time: hours (word, entry
     * 3); $24F8: rest time: tens of minutes (word, entry 2) */
    if (REST_T(4) == 0 && REST_T(3) == 0 && REST_T(2) == 0 &&
        REST_T(1) == 0) { /* $24F6: rest time: minutes (word, entry 1) */
        return;
    }
    /* $24F4: rest time: 7 words (sec, min, tens, hours, days, beyond) */
    while (amount > REST_T(unit)) {
        j = (u8)(unit + 1);
        /* $24F4: rest time: 7 words (sec, min, tens, hours, days, beyond) */
        while (REST_T(j) == 0 && j < 5) {
            j = (u8)(j + 1);
        }
        if (j == 5) {
            /* $24F4: rest time: 7 words (sec, min, tens, hours, days, beyond) */
            h029_fill_bytes(0x0D, &g_h005[0x24F4], 0x0E, 0);
            amount = 0;
        } else {
            for (k = j; k >= (u8)(unit + 1); --k) {
                /* $24F4: rest time: 7 words (sec, min, tens, hours, days, beyond) */
                REST_SET_T(k, REST_T(k) - 1);
                /* $24F4: rest time: 7 words (sec, min, tens, hours, days, beyond); $500A:
                 * (word) limits of the time units t[0..6] (carry) */
                REST_SET_T(k - 1, REST_T(k - 1) + H005_W(0x500A + (k - 1) * 2));
                if (k == 0) {
                    break;
                }
            }
        }
    }
    /* $24F4: rest time: 7 words (sec, min, tens, hours, days, beyond) */
    REST_SET_T(unit, REST_T(unit) - amount);
    rest_normalize();
}

/*
 * PORT H058+$084C: row "Rest Time : dd : hh : mm" (row $11); the field
 * sel (4 days, 3 hours, 2 minutes) in colour 15.
 */
static void rest_display(u8 sel)
{
    char buf[0x2A];                     /* -$2A(a5) */
    u8 i;                               /* -$2F(a5) */
    u16 color[7];                       /* -$3E(a5) */
    u16 col;                            /* -$40(a5) */

    for (i = 0; i <= 6; ++i) {
        color[i] = 0x0A;
    }
    color[sel] = 0x0F;
    ui_draw_text(1, 0x11, 0x0A, 0, 0x0C, "Rest Time : ");
    col = 0x0B;
    for (i = 4; i >= 3; --i) {
        /* $24F4: rest time: 7 words (sec, min, tens, hours, days, beyond) */
        format_number(0x28, buf, (s32)REST_T(i), 0, 0x0A, 2, '0');
        ui_draw_text((u16)(col + 1), 0x11, color[i], 0, 0x28, buf);
        ui_draw_text((u16)(col + 1 + 2), 0x11, 0x0A, 0, 3, " : ");
        col = (u16)(col + 3);
    }
    /* $24F8: rest time: tens of minutes (word, entry 2); $24F6: rest time: minutes (word,
     * entry 1) */
    format_number(0x28, buf, (s32)(u16)(REST_T(2) * 0x0A + REST_T(1)), 0,
                  0x0A, 2, '0');
    ui_draw_text((u16)(col + 1), 0x11, color[2], 0, 0x28, buf);
}

/*
 * PORT H058+$09AA: rest time menu.  Up/down add and
 * remove, left/right change field; 1 if Rest is chosen.
 */
static u8 rest_menu(void)
{
    u8 rest = 0;                        /* -$1(a5) */
    u8 special;                         /* -$2(a5) */
    u8 key;                             /* -$3(a5) */
    u8 sel = 2;                         /* -$4(a5) */

    do {
        rest_display(sel);
        key = ui_request_choice(0, "", 0x26,
                                "Rest Days Hours Mins Add Subtract Exit",
                                0x0D, 0x0A, 0x0F, 1, 0, &special);
        if (special) {
            switch (key) {
            case 'H':
                key = 'A';
                break;
            case 'P':
                key = 'S';
                break;
            case 'K':
                sel = (u8)(sel + 1);
                if (sel > 4) {
                    sel = 2;
                }
                key = 'X';
                break;
            case 'M':
                sel = (u8)(sel - 1);
                if (sel < 2) {
                    sel = 4;
                }
                key = 'X';
                break;
            default:
                key = 'X';
                break;
            }
        }
        if (key == 0x0D) {
            key = 'R';
        }
        switch (key) {
        case 'R':
            rest = 1;
            break;
        case 'D':
            sel = 4;
            break;
        case 'H':
            sel = 3;
            break;
        case 'M':
            sel = 2;
            break;
        case 'A':
            if (sel == 2) {
                REST_SET_T(1, REST_T(1) + 5); /* $24F6: rest time: minutes (word, entry 1) */
            } else {
                /* $24F4: rest time: 7 words (sec, min, tens, hours, days, beyond) */
                REST_SET_T(sel, REST_T(sel) + 1);
            }
            rest_normalize();
            break;
        case 'S':
            if (sel == 2) {
                rest_subtract(5, 1);
            } else {
                rest_subtract(1, sel);
            }
            rest_normalize();
            break;
        default:
            break;
        }
    } while (key != 'R' && key != 'E' && key != 0);
    return rest;
}

/*
 * PORT H058+$0B84: every $120 steps the whole party recovers one hit
 * point.
 */
static void rest_heal(u8 show)
{
    u8 healed;                          /* -$1(a5) */
    Character *p;                       /* -$6(a5) */

    /* $24EA: counter of the rest steps for +1 HP every $120 (word) */
    H005_SET_W(0x24EA, H005_W(0x24EA) + 1);
    if (H005_W(0x24EA) < 0x120) { /* $24EA: counter of the rest steps for +1 HP every $120 (word) */
        return;
    }
    healed = 0;
    for (p = g_party_head; p != NULL; p = p->next) {
        if (heal_character(p, 1, 0)) {
            healed = 1;
        }
    }
    if (show) {
        rest_display(0);
    }
    ui_draw_text(1, 0x13, 0x0A, 0, 0x19, "The whole Party Is Healed");
    if (healed) {
        draw_party(g_current_char);
    }
    message_delay();
    clear_message_area();
    H005_SET_W(0x24EA, 0); /* $24EA: counter of the rest steps for +1 HP every $120 (word) */
}

/*
 * PORT H058+$0C38: with *flag at 0 memorises the first spell
 * waiting (bit 7) and announces it; with *flag at 1 returns the level
 * of the first one waiting.  *flag becomes 1.
 */
static u16 memorize_next(Character *c, u8 *flag)
{
    u16 level = 0;                      /* -$2(a5) */
    u16 i;                              /* -$4(a5) */
    u16 spell;

    for (i = 0; i <= 0x39 && level == 0; ++i) {
        /* ch+$1E: memorised spells, $3A bytes (+$1E..+$57); bit 7 = to be memorised */
        if (c->b[0x1E + i] > 0x7F) {
            if (*flag) {
                /* ch+$1E: memorised spells, $3A bytes (+$1E..+$57); bit 7 = to be memorised */
                spell = mask_byte(c->b[0x1E + i], 0x7F);
                level = H005_B(0x66 + (spell - 1) * 16 + 1);
            } else {
                /* ch+$1E: memorised spells, $3A bytes (+$1E..+$57); bit 7 = to be memorised */
                c->b[0x1E + i] = (u8)(c->b[0x1E + i] - 0x80);
                rest_display(0);
                /* ch+$1E: memorised spells, $3A bytes (+$1E..+$57); bit 7 = to be memorised */
                announce_spell(c, 0x0D, "has memorized", c->b[0x1E + i]);
            }
            *flag = 1;
        }
    }
    return level;
}

/*
 * PORT H058+$0D2C: like memorize_next for the scrolls to be scribed:
 * the spell becomes known (+$66) and is removed from the scroll.
 */
static u16 scribe_next(Character *c, u8 *flag)
{
    u16 k;                              /* -$2(a5) */
    u16 spell;                          /* -$4(a5) */
    u16 level = 0;                      /* -$6(a5) */
    CokItem *it;                        /* -$A(a5) */
    u8 found = 0;                       /* -$B(a5) */

    for (it = c->items; it != NULL && level == 0; it = it->next) {
        k = 1;
        if (!is_scroll(it)) {
            continue;
        }
        for (; k <= 3 && level == 0; ++k) {
            /* item+$43: base of the table of 3 spells +$44..+$46 (index 1..3, bit7=to be scribed) */
            if (it->b[0x44 + k - 1] <= 0x80) {
                continue;
            }
            found = 1;
            if (*flag) {
                /* item+$43: base of the table of 3 spells +$44..+$46 (index 1..3, bit7=to be scribed) */
                spell = mask_byte(it->b[0x44 + k - 1], 0x7F);
                level = H005_B(0x66 + (spell - 1) * 16 + 1);
            } else {
                /* item+$43: base of the table of 3 spells +$44..+$46 (index 1..3, bit7=to be scribed) */
                spell = mask_byte(it->b[0x44 + k - 1], 0x7F);
                /* ch+$65: base -1 of the known spells +$66+s-1 (s = 1..$6B, flag per spell) */
                c->b[0x66 + spell - 1] = 1;
                remove_scroll_spell(c, it, spell);
                rest_display(0);
                announce_spell(c, 0x0B, "has scribed", spell);
                *flag = 1;
            }
        }
    }
    (void)found;
    return level;
}

/*
 * PORT H058+$0E80: decrements the counters of the characters; at zero (and without
 * initial wait +$58) scribes or memorises and sets the next
 * counter to 3 times the level.
 */
static void rest_learn(void)
{
    u16 i = 1;                          /* -$2(a5) */
    u16 level;                          /* -$4(a5) */
    Character *p;                       /* -$8(a5) */
    u8 flag;                            /* -$9(a5) */

    for (p = g_party_head; p != NULL; p = p->next, ++i) {
        if (REST_TIMER(i - 1) > 0) { /* $24EC: study counters per character (8 bytes, index = slot) */
            /* $24EC: study counters per character (8 bytes, index = slot) */
            REST_TIMER(i - 1) = (u8)(REST_TIMER(i - 1) - 1);
        }
        /* $24EC: study counters per character (8 bytes, index = slot); ch+$58: remaining
         * study hours (memorisation/scribing) (word) */
        if (REST_TIMER(i - 1) == 0 && COK_GET16(&p->b[0x58]) == 0) {
            flag = 0;
            level = scribe_next(p, &flag);
            if (level == 0) {
                level = memorize_next(p, &flag);
            }
            /* $24EC: study counters per character (8 bytes, index = slot) */
            REST_TIMER(i - 1) = (u8)(level * 3);
        }
    }
}

/*
 * PORT H058+$0F5C: every 12 steps decrements the initial wait (+$58); when
 * it ends sets the counter to the level of the next spell.
 */
static void rest_wait(u16 *count)
{
    u16 i;                              /* -$2(a5) */
    u16 level;                          /* -$4(a5) */
    Character *p;                       /* -$8(a5) */
    u8 flag;                            /* -$9(a5) */

    *count = (u16)(*count + 1);
    if (*count < 0x0C) {
        return;
    }
    *count = 0;
    i = 1;
    for (p = g_party_head; p != NULL; p = p->next, ++i) {
        /* ch+$58: remaining study hours (memorisation/scribing) (word) */
        if ((s16)COK_GET16(&p->b[0x58]) > 0) {
            /* ch+$58: remaining study hours (memorisation/scribing) (word) */
            COK_PUT16(&p->b[0x58], COK_GET16(&p->b[0x58]) - 1);
            /* ch+$58: remaining study hours (memorisation/scribing) (word) */
            if (COK_GET16(&p->b[0x58]) == 0) {
                flag = 1;
                level = scribe_next(p, &flag);
                if (level == 0) {
                    level = memorize_next(p, &flag);
                }
                /* $24EC: study counters per character (8 bytes, index = slot) */
                REST_TIMER(i - 1) = (u8)(level * 3);
            }
        }
    }
}

/*
 * PORT H058+$1014: rest for the time at $24F4 (interactive: first the
 * menu, and it can be interrupted with a key) in steps of 5 minutes; an
 * encounter may happen (g_state_b +$5A4/+$5A6).  1 if interrupted.
 */
u8 rest_party(u8 interactive)
{
    Character *p;                       /* -$4(a5) */
    u16 i;                              /* -$C(a5) */
    u16 wait_count;                     /* -$E(a5) */
    u16 steps;                          /* -$10(a5) */
    u8 stop;                            /* -$11(a5) */
    u8 interrupted = 0;                 /* -$13(a5) */

    i = 1;
    for (p = g_party_head; p != NULL; p = p->next) {
        REST_TIMER(i - 1) = 0; /* $24EC: study counters per character (8 bytes, index = slot) */
        ++i;
    }
    h029_fill_bytes(0x27, g_h058_bss, 0x28, 1);
    wait_count = 0;
    steps = 0;
    if (interactive) {
        clear_text_cells(1, 0x11, 0x26, 0x16);
        rest_display(0);
    }
    set_pointer_shape(9);
    H005_B(0x24E2) = 1; /* $24E2: 1 while resting: wait pointer, messages from row $12 */
    stop = (u8)(interactive ? !rest_menu() : 0);
    /* $24FC: rest time: days, at most 99 (word, entry 4); $24FA: rest time: hours (word, entry
     * 3); $24F8: rest time: tens of minutes (word, entry 2) */
    while (!stop && (REST_T(4) > 0 || REST_T(3) > 0 || REST_T(2) > 0 ||
                     REST_T(1) > 0)) { /* $24F6: rest time: minutes (word, entry 1) */
        poll_intuition_events();
        if (interactive && G_KEY) { /* $5305: key/action pending from the input (G_KEY) */
            rest_display(0);
            if (ask_yes_no(0x0E, "Stop Resting? ", 0x0D, 0x0A, 0x0F) == 'Y') {
                stop = 1;
            } else {
                clear_message_line();
            }
        }
        if (stop) {
            continue;
        }
        rest_subtract(5, 1);
        ++steps;
        if (interactive && steps >= 5) {
            rest_display(0);
            steps = 0;
        }
        advance_time(5, 1);
        rest_heal(interactive);
        rest_learn();
        rest_wait(&wait_count);
        /* B+$5A4: (word) rest steps (5 min) between encounter rolls, 0 never */
        if (COK_GET16(g_state_b + 0x5A4) > 0) {
            /* $3DDE: (word) rest steps since the last encounter check */
            H005_SET_W(0x3DDE, H005_W(0x3DDE) + 1);
            /* $3DDE: (word) rest steps since the last encounter check; B+$5A4: (word) rest steps (5
             * min) between encounter rolls, 0 never */
            if (H005_W(0x3DDE) >= COK_GET16(g_state_b + 0x5A4)) {
                H005_SET_W(0x3DDE, 0); /* $3DDE: (word) rest steps since the last encounter check */
                /* B+$5A6: (word) % chance of an encounter while resting */
                if (roll_dice(1, 0x64) <= COK_GET16(g_state_b + 0x5A6)) {
                    clear_message_area();
                    rest_display(0);
                    ui_draw_text(1, 0x13, 0x0F, 0, 0x24,
                                 "Your repose is suddenly interrupted!");
                    stop = 1;
                    interrupted = 1;
                    message_delay();
                }
            }
        }
    }
    clear_text_cells(1, 0x11, 0x26, 0x16);
    H005_B(0x24E2) = 0; /* $24E2: 1 while resting: wait pointer, messages from row $12 */
    set_pointer_shape(0x0A);
    return interrupted;
}
