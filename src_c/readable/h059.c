/* H059: tactical combat loop and turns of the actors. */
#include "h059.h"
#include "globals.h"
#include "unported.h"
#include "h003_exec.h"
#include "h008.h"
#include "h026_string.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h033.h"
#include "h036.h"
#include "h045.h"
#include "h048.h"
#include "h058.h"
#include "h062.h"
#include "h063.h"
#include "h065.h"
#include "h095.h"
#include "h096.h"
#include "h097.h"
#include <string.h>

/*
 * Turn order of the round (H005+$2392).  The original clears 40 entries
 * ($A0 bytes) but scans up to $48: the entries beyond 40 overlap
 * $2432..; the list is terminated by NULL and does not reach them with at most
 * 40 combatants.  Here 72 entries.
 */
Character *g_turn_order[0x48];

/* PORT H059+$0122: link/unlk, no effect. */
void h059_init(void)
{
}

/*
 * PORT H059+$0130: sorts the characters by initiative (+$4 of the turn,
 * highest first; ties at random) into H005+$2392.
 */
static void build_turn_order(void)
{
    Character *p;                       /* -$6(a5) */
    Character *moved;                   /* -$A(a5) */
    Character *next;                    /* -$E(a5) */
    s16 v;                              /* -$10(a5) */
    s16 w;                              /* -$12(a5) */
    u16 i;                              /* -$14(a5) */
    u16 j;                              /* -$16(a5) */
    u8 go;                              /* -$1(a5) */

    memset(g_turn_order, 0, 0xA0 / 4 * sizeof(Character *));
    for (p = g_party_head; p != NULL; p = p->next) {
        i = 1;
        go = 1;
        /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
        v = (s16)COK_GET16(&p->block_192->b[4]);
        while (i < 0x41 && go) {
            if (g_turn_order[i - 1] != NULL) {
                /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
                w = (s16)COK_GET16(&g_turn_order[i - 1]->block_192->b[4]);
            } else {
                w = -1;
            }
            if (v > w || (v == w && roll_dice(1, 2) == 1)) {
                go = 0;
            } else {
                ++i;
            }
        }
        moved = g_turn_order[i - 1];
        g_turn_order[i - 1] = p;
        if (moved != NULL) {
            j = i;
            go = 1;
            while (j < 0x48 && go) {
                ++j;
                next = g_turn_order[j - 1];
                g_turn_order[j - 1] = moved;
                moved = next;
                if (next == NULL) {
                    go = 0;
                }
            }
        }
    }
}

/*
 * PORT H059+$02AA: end of the combat: frees clouds and pools, whoever was
 * charmed comes back (status 3 if more enemies remain), the effects tied
 * to the combat drop, the map and the icons are freed; the handler
 * $276C goes back to the one of the spells outside combat.
 */
static void end_combat_cleanup(void)
{
    CokCloud *next;                     /* -$4(a5) */
    Character *p;                       /* -$8(a5) */
    CokEffect *e;                       /* -$C(a5) */

    while (g_clouds != NULL) {
        next = g_clouds->next;
        exec_free_mem(g_clouds, sizeof(CokCloud));
        g_clouds = next;
    }
    while (g_acid_pools != NULL) {
        next = g_acid_pools->next;
        exec_free_mem(g_acid_pools, sizeof(CokCloud));
        g_acid_pools = next;
    }
    for (p = g_party_head; p != NULL; p = p->next) {
        /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
        if (find_effect(p, 0x0B, &e) && p->b[0x197] == 0) {
            if (H005_B(0x2A1D) > 1) { /* $2A1D: active combatants of side 1 (entry 2 of $2A1C) */
                p->b[0x197] = 3; /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
            } else {
                p->b[0x197] = 0; /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
            }
        }
        drop_effects(p);
    }
    exec_free_mem(g_combat_area, 0x9CE);
    g_combat_area = NULL;
    free_gfx_record(&g_gfx_243a);
    g_handlers_25c0[107] = (CokHandler)select_spell_target;   /* H033+$12D4 */
}

/*
 * PORT H059+$03BE: turn menu: Move (if it has movement), View Aim, Use
 * (if it has items), Cast (if it has spells and can), Turn (clerics who
 * can turn undead), Yell (paladins without a chosen target), Done.
 * Returns the choice in *key (letters, space or a special key
 * 1/2/3/4/$13).
 */
static void combat_menu(Character *c, u8 *key)
{
    char line[0x29];                    /* -$2A(a5) */
    u16 i;                              /* -$2C(a5) */
    u8 flag;                            /* -$2D(a5) */

    line[0] = '\0';
    if (c->block_192->b[8] > 0) { /* turn+$8: movement points left in the turn */
        h026_copy(0x28, line, 5, "Move ");
    }
    h026_append(0x28, line, 9, "View Aim ");
    if (c->b[0x14F] > 0) { /* ch+$14F: number of items owned (max 16) */
        h026_append(0x28, line, 4, "Use ");
    }
    flag = 0;
    for (i = 0; i <= 0x39; ++i) {
        /* ch+$1E: memorised spells, $3A bytes (+$1E..+$57); bit 7 = to be memorised */
        if (c->b[0x1E + i] > 0) {
            flag = 1;
        }
    }
    /* turn+$1: can cast spells flag (not in a cloud; cleared when attacking); A+$1CA: (word) if
     * not zero no spells can be cast in the area */
    if (flag && c->block_192->b[1] && COK_GET16(g_state_a + 0x1CA) == 0) {
        h026_append(0x28, line, 5, "Cast ");
    }
    /* ch+$FE: levels per class, 8 entries (0 cleric..7 knight); cleric; turn+$13: Turn Undead already
     * used in the combat (max H005+$248F); $248F: monsters loaded with +$DF: Turn Undead limit
     * (turn +$13) */
    if (c->b[0xFE] > 0 && c->block_192->b[0x13] < H005_B(0x248F)) {
        h026_append(0x28, line, 5, "Turn ");
    }
    if (c->b[0x5B] == 5 && g_h005_2432 == NULL) { /* ch+$5B: race (0..6, names H005+$4D04) */
        h026_append(0x28, line, 5, "Yell ");
    }
    h026_append(0x28, line, 4, "Done");
    do {
        *key = ui_request_choice(0, "", 0x28, line, 0x0D, 0x0A, 0x0F, 1, 0,
                                 &flag);
        if (flag && *key != 3 && *key != 1 && *key != 2 && *key != 4 &&
            *key != 0x13) {
            *key = 0;
        }
    } while (*key != 'M' && *key != 'V' && *key != 'A' && *key != 'U' &&
             *key != 'C' && *key != 'T' && *key != 'Q' && *key != 'D' &&
             *key != 'Y' && *key != 2 && *key != ' ' && *key != 3 &&
             *key != 1 && *key != 4 && *key != 0x13);
    clear_message_line();
}

/*
 * PORT H059+$0670: attack of actor on target (from the movement): a ranged
 * weapon that does not hit at close range is no use; otherwise, if it can
 * attack, target becomes the target and the attack starts.
 */
static void melee_attack(Character *actor, Character *target, u8 *done)
{
    if (has_ranged_weapon(actor) && !weapon_melee_ok(actor)) {
        show_message_line(0x14, "Not with that weapon");
        return;
    }
    if (!confirm_attack(actor, target)) {
        return;
    }
    actor->block_192->target = target;
    if (combat_sweep(actor, target)) {
        *done = 1;
        return;
    }
    record_attack(actor, target);
    combat_attack(actor, target, 0, NULL, done);
}

/* Variables of H059+$0726 read by the nested procedure $0734. */
typedef struct MoveFrame {
    Character *c;                       /* $12(a5) */
    u8 *done;                           /* $C(a5) */
    u16 moves;                          /* -$2(a5) */
    u16 facing;                         /* -$4(a5) */
    s16 x0;                             /* -$6(a5) */
    s16 y0;                             /* -$8(a5) */
    u16 dir;                            /* -$E(a5) */
} MoveFrame;

/*
 * PORT H059+$0734 (nested in $0726): Esc cancels the movement: c goes back
 * where it was with the previous movement and direction.
 */
static void cancel_move(MoveFrame *f)
{
    f->c->block_192->b[8] = (u8)f->moves; /* turn+$8: movement points left in the turn */
    redraw_ground(0, 0, combatant_index(f->c));
    *f->done = (u8)!place_combatant(f->c, (u8)f->x0, (u8)f->y0, 0);
    center_view((s16)combatant_x(f->c), (s16)combatant_y(f->c), 0, 8);
    /* turn+$B: facing/frame of the combatant (direction 0..7) */
    f->c->block_192->b[0x0B] = (u8)f->facing;
    f->dir = 8;
}

/*
 * PORT H059+$0726: move/attack mode: "Move/Attack, Move Left = n"
 * and the arrows (special keypad codes $47..$51): towards a
 * combatant it attacks, towards outside the map it asks "Flee:", otherwise it
 * moves if the cost of the square (double, triple diagonally) is
 * covered by the movement left.  Esc cancels, Enter or 'D' close.
 */
static void move_mode(Character *c, u8 key, u8 *done)
{
    MoveFrame f;
    u16 blocker;                        /* -$10(a5) */
    u16 tile;                           /* -$12(a5) */
    u8 k;                               /* -$13(a5) */
    u8 in_cloud;                        /* -$14(a5) */
    u8 in_acid;                         /* -$15(a5) */
    u16 cost;                           /* -$18(a5) */
    char msg[0x51];                     /* -$6A(a5) */

    H005_B(0x24CB) = 1; /* $24CB: 1 in Move/Attack mode: cursor on the combat map */
    f.c = c;
    f.done = done;
    f.moves = c->block_192->b[8]; /* turn+$8: movement points left in the turn */
    f.facing = c->block_192->b[0x0B]; /* turn+$B: facing/frame of the combatant (direction 0..7) */
    f.x0 = (s16)combatant_x(c);
    f.y0 = (s16)combatant_y(c);
    k = key;
    *done = 0;
    f.dir = 8;
    /*
     * The original checks again on exit (k = ' ' without *done): with the
     * loop condition that case does not occur.
     */
    while (k != 0 && k != 0x0D && k != 'D' && !*done) {
        clear_text_cells(0x18, 0x18, 0x27, 0x18);
        if (k == ' ') {
            h026_copy(0x50, msg, 0x19, "Move/Attack, Move Left = ");
            /* $3C82: generic 80-character text buffer (TEXT_BUF) */
            format_number(0x50, (char *)&H005_B(0x3C82),
                          /* turn+$8: movement points left in the turn */
                          (s32)(c->block_192->b[8] >> 1), 0, 0x0A, 2, ' ');
            /* $3C82: generic 80-character text buffer (TEXT_BUF) */
            h026_append(0x50, msg, 0x50, (const char *)&H005_B(0x3C82));
            k = ui_request_choice(0x50, msg, 5, " Done", 0x0D, 0x0A, 0x0F, 1,
                                  /* $249F: use: scratch byte for *special and outcomes in the
                                   * combat menus */
                                  0, &H005_B(0x249F));
        }
        switch (k) {
        case 0:    cancel_move(&f); break;
        case 0x48: f.dir = 0; break;
        case 0x49: f.dir = 1; break;
        case 0x4D: f.dir = 2; break;
        case 0x51: f.dir = 3; break;
        case 0x50: f.dir = 4; break;
        case 0x4F: f.dir = 5; break;
        case 0x4B: f.dir = 6; break;
        case 0x47: f.dir = 7; break;
        default:   f.dir = 8; break;
        }
        if (f.dir < 8) {
            set_combatant_frame(c, (u8)f.dir, 0, 0);
            probe_move(c, f.dir, &blocker, &tile, &in_cloud, &in_acid);
            if (blocker > 0) {
                melee_attack(c, g_combatants[blocker - 1], done);
            } else if (tile == 0) {
                switch (ask_yes_no(5, "Flee:", 0x0D, 0x0A, 0x0F)) {
                case 'Y': *done = combat_flee(c); break;
                case 'N': *done = 0; break;
                default: break;
                }
            } else {
                if (f.dir & 1) {
                    /* $3EF4: terrain, $41 entries of 4 bytes (from 1): +0 cost ($FF impassable) */
                    cost = (u16)(H005_B(0x3EF4 + (tile - 1) * 4) * 3);
                } else {
                    /* $3EF4: terrain, $41 entries of 4 bytes (from 1): +0 cost ($FF impassable) */
                    cost = (u16)(H005_B(0x3EF4 + (tile - 1) * 4) * 2);
                }
                /* $3EF4: terrain, $41 entries of 4 bytes (from 1): +0 cost ($FF impassable) */
                if (H005_B(0x3EF4 + (tile - 1) * 4) == 0xFF) {
                    cost = 0xFF;
                }
                if (cost > c->block_192->b[8]) { /* turn+$8: movement points left in the turn */
                    show_message_line(0x0E, "can't go there");
                } else {
                    combat_leave_attacks(c, f.dir);
                    if (!c->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
                        *done = end_combat_turn(c);
                    } else {
                        if (c->block_192->b[8] > 0) { /* turn+$8: movement points left in the turn */
                            combat_step(c, f.dir);
                        }
                        if (!c->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
                            *done = end_combat_turn(c);
                        }
                        check_cloud(c, 1);
                        if (is_helpless(c)) {
                            *done = end_combat_turn(c);
                        }
                    }
                }
            }
        }
        if (k != 0 && k != 0x0D && k != 'D') {
            k = ' ';
        }
    }
    if (c->block_192->b[8] < 2) { /* turn+$8: movement points left in the turn */
        c->block_192->b[8] = 0; /* turn+$8: movement points left in the turn */
    }
    H005_B(0x24CB) = 0; /* $24CB: 1 in Move/Attack mode: cursor on the combat map */
}

/*
 * PORT H059+$0CCA: game speed: "gameSpeed (n) :" with Slower (up
 * to 9) and Faster (down to 0) on H005+$3DF6.
 */
static void game_speed_menu(void)
{
    char title[0x29];                   /* -$54(a5) */
    char line[0x29];                    /* -$2A(a5) */
    u8 key = ' ';                       /* -$55(a5) */

    while (key != 'E' && key != 0) {
        h026_copy(0x28, title, 0x0B, "gameSpeed (");
        /* $3DF6: (word) game speed 0..9 (message pause) */
        format_number(0x28, line, (s32)H005_W(0x3DF6), 0, 0x0A, 1, ' ');
        h026_append(0x28, line, 3, ") :");
        h026_append(0x28, title, 0x28, line);
        strcpy(line, " ");
        if (H005_W(0x3DF6) < 9) { /* $3DF6: (word) game speed 0..9 (message pause) */
            h026_append(0x28, line, 7, "Slower ");
        }
        if (H005_W(0x3DF6) > 0) { /* $3DF6: (word) game speed 0..9 (message pause) */
            h026_append(0x28, line, 7, "Faster ");
        }
        h026_append(0x28, line, 4, "Exit");
        key = ui_request_choice(0x28, title, 0x28, line, 0x0D, 0x0A, 0x0F, 0,
                                /* $249F: use: scratch byte for *special and outcomes in the
                                 * combat menus */
                                0, &H005_B(0x249F));
        switch (key) {
        /* $3DF6: (word) game speed 0..9 (message pause) */
        case 'S': H005_SET_W(0x3DF6, H005_W(0x3DF6) + 1); break;
        /* $3DF6: (word) game speed 0..9 (message pause) */
        case 'F': H005_SET_W(0x3DF6, H005_W(0x3DF6) - 1); break;
        default: break;
        }
    }
}

/* PORT H059+$0E4A: c switches to automatic control and drops an allied target. */
static void set_auto(Character *c)
{
    c->b[0x19A] = 1; /* ch+$19A: automatic control in combat (1 = AI) */
    if (c->block_192->target != NULL &&
        /* ch+$199: side in combat (0 party, 1 opponents) */
        c->block_192->target->b[0x199] == c->b[0x199]) {
        c->block_192->target = NULL;
    }
}

/*
 * PORT H059+$0EA0: "Done" submenu: Guard (if it does not have a ranged-only
 * weapon), Delay (moves to the end of the round order), Quit (end of
 * turn), Bandage (if a companion is dying), Auto (the computer plays for
 * it), Speed, Exit.
 */
static void done_menu(Character *c, u8 *done)
{
    char line[0x29];                    /* -$2A(a5) */
    u8 key = ' ';                       /* -$2B(a5) */
    Character *p;                       /* -$30(a5) */
    u16 i;                              /* -$32(a5) */

    *done = 0;
    line[0] = '\0';
    if (!has_ranged_weapon(c) || weapon_melee_ok(c)) {
        h026_copy(0x28, line, 6, "Guard ");
    }
    h026_append(0x28, line, 0x0B, "Delay Quit ");
    if (bandage_dying(0)) {
        h026_append(0x28, line, 8, "Bandage ");
    }
    h026_append(0x28, line, 0x0F, "Auto Speed Exit");
    while (key != 'E' && key != 0 && !*done) {
        key = ui_request_choice(0, "", 0x28, line, 0x0D, 0x0A, 0x0F, 0, 0,
                                /* $249F: use: scratch byte for *special and outcomes in the
                                 * combat menus */
                                &H005_B(0x249F));
        switch (key) {
        case 'G':
            *done = guard_turn(c);
            break;
        case 'D':
            /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
            COK_PUT16(&c->block_192->b[4], 1);
            i = H005_B(0x2480); /* $2480: current position in the turn order (1..$48, g_turn_order) */
            p = g_turn_order[i];
            while (p != NULL && i < 0x48) {
                g_turn_order[i - 1] = p;
                ++i;
                /* the original also reads entry $48 (outside the table) */
                p = (i < 0x48) ? g_turn_order[i] : NULL;
            }
            g_turn_order[i - 1] = c;
            /* $2480: current position in the turn order (1..$48, g_turn_order) */
            add_to_byte(&H005_B(0x2480), 0xFFFF);
            *done = 1;
            break;
        case 'Q':
            *done = end_combat_turn(c);
            break;
        case 'B':
            *done = bandage_dying(1);
            *done = end_combat_turn(c);
            break;
        case 'S':
            game_speed_menu();
            break;
        case 'A':
            set_auto(c);
            clear_message_line();
            dos_delay(0x0A);
            *done = 1;
            monster_turn(c);
            break;
        default:
            break;
        }
    }
}

/*
 * PORT H059+$1110: turn of a player character: a spell
 * in progress (+$0 of the turn) starts at once; otherwise the menu until the
 * turn ends.  Special keys: 1/3 everyone on automatic for the
 * rest of the round, 2 magic on/off, 4 H096+$4DE8.
 */
static void player_turn(Character *c)
{
    u8 key;                             /* -$1(a5) */
    u8 done;                            /* -$2(a5) */
    CokAim area;                        /* -$10(a5): aim (9 bytes) */
    u16 spell;                          /* -$12(a5) */
    Character *p;                       /* -$6(a5) */

    if (!c->b[0x198]) { /* ch+$198: active/standing (0 down or out of the combat) */
        done = end_combat_turn(c);
        return;
    }
    if (c->block_192->b[0] > 0) { /* turn+$0: spell being prepared, cast at the start of the turn */
        /* turn+$0: spell being prepared, cast at the start of the turn */
        spell = c->block_192->b[0];
        c->block_192->b[0] = 0; /* turn+$0: spell being prepared, cast at the start of the turn */
        cast_spell(spell, 0, 1, &done);
        done = end_combat_turn(c);
        return;
    }
    done = 0;
    while (!done) {
        H005_B(0x2483) = 1; /* $2483: index of the selected option in the row menus (persistent) */
        combat_menu(c, &key);
        if (H005_B(0x249D)) { /* $249D: 1 if the last UI_RequestChoice gave a special key */
            switch (key) {
            case 1:
            case 3:
                /* $2480: current position in the turn order (1..$48, g_turn_order) */
                add_to_byte(&H005_B(0x2480), 0xFFFF);
                /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
                COK_PUT16(&c->block_192->b[4], 0x14);
                for (p = g_party_head; p != NULL; p = p->next) {
                    set_auto(p);
                }
                clear_message_line();
                dos_delay(0x0A);
                done = 1;
                break;
            case 2:
                /* $24A0: Magic On/Off (key 2): characters on automatic cast spells */
                H005_B(0x24A0) = (u8)(H005_B(0x24A0) == 0);
                /* $24A0: Magic On/Off (key 2): characters on automatic cast spells */
                if (H005_B(0x24A0)) {
                    show_message_line(8, "Magic On");
                } else {
                    show_message_line(9, "Magic Off");
                }
                break;
            case 4:
                if (combat_bandage()) {
                    show_combatant_cursor(c, 3, 0);
                    done = 1;
                } else {
                    show_message_line(0x11, "That doesn't work");
                }
                break;
            default:
                break;
            }
        } else {
            switch (key) {
            case ' ':
                for (p = g_party_head; p != NULL; p = p->next) {
                    /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
                    if (p->b[0xEC] < 0x80) {
                        p->b[0x19A] = 0; /* ch+$19A: automatic control in combat (1 = AI) */
                    }
                }
                break;
            case 'A':
                aim_target(c, 0xFF, 1, 0, 1, &done, &area);
                break;
            case 'C':
                combat_cast(0, 0, &done);
                break;
            case 'D':
                done_menu(c, &done);
                break;
            case 'M':
                move_mode(c, ' ', &done);
                break;
            case 'T':
                turn_undead(c);
                done = end_combat_turn(c);
                break;
            case 'U':
                H005_B(0x2483) = 2; /* $2483: index of the selected option in the row menus (persistent) */
                show_items(&done);
                combat_attacks(c);
                if (!done) {
                    redraw_combat_screen();
                }
                break;
            case 'V':
                view_character(&done);
                combat_attacks(c);
                if (!done) {
                    redraw_combat_screen();
                }
                break;
            case 'Y':
                yell_challenge(c);
                done = end_combat_turn(c);
                break;
            default:
                break;
            }
        }
        if (!done) {
            show_combatant_cursor(c, 2, 1);
            H005_B(0x24C7) = 1; /* $24C7: 1: combatant panel on the right to be redrawn */
            draw_combat_status(c);
        }
    }
}

/*
 * PORT H059+$1498 (Combat_ActorTurn): turn of c: events 7, $F and $15,
 * cursor and status; whoever still has initiative (+$4 > 0) plays: on
 * automatic (+$19A, H097+$1D68) or with the menu.
 */
static void actor_turn(Character *c)
{
    c->block_192->b[0x11] = 0; /* turn+$11: attacks received in the round */
    c->block_192->b[0x14] = 0; /* turn+$14: sum (mod 8) of the off-facing eighths of the attacks */
    c->block_192->b[9] = 0; /* turn+$9: on guard flag (Guard), attacks whoever comes close */
    trigger_event(&c, 7);
    /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
    if ((s16)COK_GET16(&c->block_192->b[4]) <= 0) {
        return;
    }
    /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
    if (COK_GET16(&c->block_192->b[4]) == 0x14) {
        /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
        COK_PUT16(&c->block_192->b[4], 0x13);
    }
    g_current_char = c;
    /* $24C6: 1 if the combatant's actions must be drawn (visible); ch+$199: side in
     * combat (0 party, 1 opponents) */
    H005_B(0x24C6) = (u8)(c->b[0x199] == 0 || combatant_visible(c, 0));
    show_combatant_cursor(c, 2, 1);
    recompute_stats(c);
    H005_B(0x24C7) = 1; /* $24C7: 1: combatant panel on the right to be redrawn */
    draw_combat_status(c);
    trigger_event(&c, 0x0F);
    /* turn+$0: spell being prepared, cast at the start of the turn */
    if (c->block_192->b[0] == 0) {
        trigger_event(&c, 0x15);
    }
    /* turn+$4: (word) initiative of the round (1d6+dexterity); <=0 turn over */
    if (COK_GET16(&c->block_192->b[4]) > 0) {
        if (c->b[0x19A]) { /* ch+$19A: automatic control in combat (1 = AI) */
            monster_turn(c);
        } else {
            player_turn(c);
        }
    }
    redraw_combat_cell((s16)combatant_x(c), (s16)combatant_y(c));
}

/*
 * PORT H059+$15EE: end of the round: one minute of game time, round
 * counter, enemy strength, event $13, clouds (acid only) and whoever is dying
 * gets worse (dead after 10 rounds); "Your Teammate is Dying".  The
 * combat ends if a side is gone or after $2477 rounds; with
 * only enemies left one can choose to continue.
 */
static void end_round(u8 *over)
{
    Character *p;                       /* -$4(a5) */
    u16 i;                              /* -$8(a5) */

    advance_time(1, 1);
    /* $247C: combat round number (0 at the start; bit 0 rounds) */
    add_to_byte(&H005_B(0x247C), 1);
    enemy_strength();
    i = 1;
    for (p = g_party_head; p != NULL; p = p->next) {
        trigger_event(&p, 0x13);
        check_cloud(p, 0);
        if (p->b[0x197] == 5) { /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
            /* turn+$10: rounds spent below zero hit points (beyond 9 it dies) */
            add_to_byte(&p->block_192->b[0x10], 1);
            /* turn+$10: rounds spent below zero hit points (beyond 9 it dies) */
            if (p->block_192->b[0x10] > 9) {
                p->b[0x197] = 6; /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
            }
        }
        ++i;
    }
    if (bandage_dying(0)) {
        show_message_line(0x16, "Your Teammate is Dying");
    }
    count_sides();
    center_view((s16)((s16)COK_GET16(g_combat_area + 2) + 3),
                (s16)((s16)COK_GET16(g_combat_area + 4) + 3), 0xFF, 8);
    /* $2A1C: active combatants of side 0; byte table indexed by side; $2A1D: active combatants of
     * side 1 (entry 2 of $2A1C) */
    if (H005_B(0x2A1C) == 0 || H005_B(0x2A1D) == 0 ||
        /* $247C: combat round number (0 at the start; bit 0 rounds); $2477: limit round of the
         * combat (+$247C + 15) */
        H005_B(0x247C) >= H005_B(0x2477)) {
        *over = 1;
    }
    /* $2A1C: active combatants of side 0; byte table indexed by side; $2A1D: active combatants of
     * side 1 (entry 2 of $2A1C); $24D7: 1 if the demonstration (Demo) was chosen */
    if (H005_B(0x2A1C) > 0 && H005_B(0x2A1D) == 0 && !H005_B(0x24D7) &&
        ask_yes_no(0x10, "Continue Battle:", 0x0D, 0x0A, 0x0F) == 'Y') {
        *over = 0;
    }
}

/*
 * PORT H059+$1782 (Combat_MainLoop), from the COMBAT command: start (H095),
 * event $18 for everyone, then rounds while a side remains: turn
 * order, everyone's turn with the explosions of the fallen, end of the round;
 * finally the clean-up.
 */
void combat_main_loop(void)
{
    u8 over;                            /* -$1(a5) */
    Character *p;                       /* -$6(a5) */

    H005_B(0x3DE3) = 5; /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    g_handlers_25c0[107] = (CokHandler)combat_spell_targets;
    start_combat();
    over = 0;
    /* $2A1C: active combatants of side 0; byte table indexed by side; $2A1D: active combatants of
     * side 1 (entry 2 of $2A1C) */
    if (H005_B(0x2A1C) == 0 || H005_B(0x2A1D) == 0) {
        over = 1;
    }
    for (p = g_party_head; p != NULL; p = p->next) {
        trigger_event(&p, 0x18);
    }
    while (!over) {
        count_sides();
        for (p = g_party_head; p != NULL; p = p->next) {
            combat_prepare_turn(p);
        }
        /* B+$596: (word) mask of the surprised sides: bit side+1 removes 6 from the initiative */
        COK_PUT16(g_state_b + 0x596, 0);
        build_turn_order();
        p = g_turn_order[0];
        H005_B(0x2480) = 1; /* $2480: current position in the turn order (1..$48, g_turn_order) */
        while (p != NULL) {
            actor_turn(p);
            explode_fallen();
            /* $2480: current position in the turn order (1..$48, g_turn_order) */
            add_to_byte(&H005_B(0x2480), 1);
            /* $2480: current position in the turn order (1..$48, g_turn_order) */
            if (H005_B(0x2480) > 0x48) {
                p = NULL;
            } else {
                /* $2480: current position in the turn order (1..$48, g_turn_order) */
                p = g_turn_order[H005_B(0x2480) - 1];
            }
        }
        end_round(&over);
    }
    end_combat_cleanup();
    H005_B(0x24CE) = 1; /* $24CE: 1: per-character pause when writing text */
}
