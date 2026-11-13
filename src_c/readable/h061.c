/* H061: services of the ECL VM: operands, variables, strings and areas. */
#include "h061.h"
#include "h015_runtime.h"
#include "globals.h"
#include "unported.h"
#include "h066.h"
#include "h042_seq.h"
#include "h060.h"
#include "h026_string.h"
#include "h029_gfx.h"
#include "h073.h"
#include "h003_exec.h"
#include "h008.h"
#include "h011.h"
#include "h028_files.h"
#include "h030.h"
#include "h045.h"
#include "h062.h"
#include "h063.h"
#include "h065.h"
#include <string.h>

/*
 * Module data below a4 (g_h061_bss[0x1512 - off] is -off(a4)):
 * -$40 descriptors, -$80 second byte and -$C0 first byte of the operands
 * read, -$14C0 twenty strings of $100 bytes.
 */
u8 g_h061_bss[0x1512];
/* H061_bss+$14D2: 64 bytes: descriptor/type of the ECL operands (OP_DESC) */
#define OP_DESC(i)  g_h061_bss[0x1512 - 0x40 + (i)]
/* H061_bss+$1492: 64 bytes: high byte of the ECL operands (OP_HI, index i-1) */
#define OP_HI(i)    g_h061_bss[0x1512 - 0x80 + (i)]
/* H061_bss+$1452: 64 bytes: low byte of the ECL operands (OP_LO, index i-1) */
#define OP_LO(i)    g_h061_bss[0x1512 - 0xC0 + (i)]
/* H061_bss+$52: 20 ECL strings of $100 bytes (ECL_STR, index slot-1) */
#define ECL_STR(i)  ((char *)&g_h061_bss[0x1512 - 0x14C0 + (i) * 0x100])

/* ECL program: logical addresses from $3500 in g_ecl_buffer. */
#define ECL_BYTE(addr)  g_ecl_buffer[(u16)((addr) - 0x3500)]

/* PORT H061+$15C2: link/unlk, no effect. */
void h061_init(void)
{
}

/* String n (1..20) read by READ_OPERANDS. */
char *ecl_string(u16 n)
{
    return ECL_STR(n - 1); /* H061_bss+$52: 20 ECL strings of $100 bytes (ECL_STR, index slot-1) */
}

/* PORT H061+$162E: appends the character ch to the string s. */
void append_char(u16 len, char *s, u8 ch)
{
    u16 n;                              /* -$2(a5) */

    n = h026_strlen(len, s);
    s[n] = (char)ch;
    s[n + 1] = '\0';
}

/* PORT H061+$162A: trampoline (bra.w) to H061+$1F12, the routine below. */
/* PORT H061+$1F12: word from two bytes (high, low). */
u16 make_word(u8 lo, u8 hi)
{
    return (u16)((hi << 8) + lo);
}

/* PORT H061+$1F3C (ECL_DecodeAddress): variable address ($4B00 base). */
u16 decode_address(u8 lo, u8 hi)
{
    return (u16)((hi << 8) + lo - 0x4B00);
}

/* PORT H061+$1F6A: ECL character code (below $20 + $40). */
u8 ecl_char(u16 c)
{
    if (c > 0x1F) {
        return (u8)c;
    }
    return (u8)(c + 0x40);
}

/*
 * PORT H061+$1FA4: zone of the variable: 0 state A ($000..$3FF), 1 state
 * B ($3100..$34FF), 2 state C ($2F00..$30FF), 3 program ($3500..$52FF),
 * 4 special registers.
 */
u8 var_region(u16 addr)
{
    u16 r = 4;                          /* -$2(a5) */

    if (addr <= 0x3FF) {
        r = 0;
    }
    if (addr >= 0x3100 && addr <= 0x34FF) {
        r = 1;
    }
    if (addr >= 0x2F00 && addr <= 0x30FF) {
        r = 2;
    }
    if (addr >= 0x3500 && addr <= 0x52FF) {
        r = 3;
    }
    return (u8)r;
}

/* PORT H061+$202C: position (from 0) of c in the party; the count if missing. */
u16 party_index(Character *c)
{
    Character *p;                       /* -$6(a5) */
    u8 found = 0;                       /* -$7(a5) */
    u16 i = 0;                          /* -$2(a5) */

    p = g_party_head;
    while (p != NULL && !found) {
        if (p == c) {
            found = 1;
        } else {
            ++i;
            p = p->next;
        }
    }
    return i;
}

/*
 * PORT H061+$208E: the special variables $3100+ of state B read the
 * current character (*handled = 1); the others do not.  The index of the case is
 * the one assigned to the known entries or, for the others, the offset itself.
 * For the cases without a value the original returns d0 unset: 0.
 */
static u16 read_state_b_special(u16 addr, u8 *handled)
{
    static const u16 map[][2] = {
        { 0x15, 0 }, { 0x18, 1 }, { 0x19, 2 }, { 0x61, 3 }, { 0x72, 4 },
        { 0x73, 5 }, { 0x76, 6 }, { 0x9B, 7 }, { 0xA0, 8 }, { 0xB8, 0x11 },
        { 0xBB, 0x12 }, { 0xBD, 0x13 }, { 0xBF, 0x14 }, { 0xC1, 0x15 },
        { 0xC3, 0x16 }, { 0xC9, 0x17 }, { 0xCC, 0x18 }, { 0xCD, 0x19 },
        { 0xD0, 0x1A }, { 0xD6, 0x1B }, { 0xD8, 0x1C }, { 0xF7, 0x1D },
        { 0xF9, 0x1E }, { 0x100, 0x1F }, { 0x10C, 0x20 }, { 0x10D, 0x21 },
        { 0x119, 0x22 }, { 0x11B, 0x23 }, { 0x2B1, 0x24 }, { 0x2B4, 0x25 },
        { 0x2CF, 0x26 }, { 0x312, 0x27 }, { 0x33E, 0x28 }
    };
    Character *c = g_current_char;
    u16 idx;
    u16 k;

    *handled = 1;
    idx = (u16)(addr - 0x3100);
    if (idx >= 0xA5 && idx <= 0xAC) {
        idx = (u16)(idx - 0x9C);
    } else {
        for (k = 0; k < sizeof map / sizeof map[0]; ++k) {
            if (map[k][0] == idx) {
                idx = map[k][1];
                break;
            }
        }
    }
    switch (idx) {
    case 0: return c->b[0x13]; /* ch+$13: current intelligence */
    case 1: return c->b[0x19]; /* ch+$19: current constitution */
    case 2: return c->b[0x1B]; /* ch+$1B: current charisma */
    case 3: return c->b[0x5D]; /* ch+$5D: knightly order (1 Crown, 2 Sword, 3 Rose) */
    case 4: return c->b[0x5B]; /* ch+$5B: race (0..6, names H005+$4D04) */
    case 5: return c->b[0x5C]; /* ch+$5C: class or class combination (0..16, names H005+$4D84) */
    case 6: return c->b[0x64]; /* ch+$64: maximum hit points */
    case 7: return c->b[0xD5]; /* ch+$D5: saving throw of type 1 */
    case 8: return c->b[0xDB]; /* ch+$DB: highest level among the classes (also used as hit dice) */
    case 9: case 0x0A: case 0x0B: case 0x0C:
    case 0x0D: case 0x0E: case 0x0F: case 0x10:
        return c->b[0xE0 + idx - 9]; /* ch+$D7: base -9 of the thief skills +$E0.. (variables 9..16) */
    case 0x11: return c->b[0xEC]; /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
    /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
    case 0x12: return COK_GET16(&c->b[0xF0]);
    case 0x13: return COK_GET16(&c->b[0xF2]); /* ch+$F2: coins of type 1 (word) */
    case 0x14: return COK_GET16(&c->b[0xF4]); /* ch+$F4: coins of type 2 (word) */
    case 0x15: return COK_GET16(&c->b[0xF6]); /* ch+$F6: coins of type 3 (word) */
    case 0x16: return COK_GET16(&c->b[0xF8]); /* ch+$F8: steel pieces (coin type 4) (word) */
    case 0x17:
        /* ch+$103: mage level; ch+$10B: previous mage level */
        return (u16)(c->b[0x103] + c->b[0x10B] * h073_130a(g_current_char));
    case 0x18: return c->b[0x100]; /* ch+$100: fighter level */
    case 0x19: return c->b[0x105]; /* ch+$105: knight level */
    case 0x1A: return c->b[0x102]; /* ch+$102: ranger level */
    case 0x1B: return c->b[0x10E]; /* ch+$10E: sex (0 male, 1 female; names H005+$4BD2) */
    case 0x1C: return c->b[0x10F]; /* ch+$10F: alignment (0..8, evil 2/5/8; names H005+$4C62) */
    case 0x1D: return COK_GET16(&c->b[0x13C]); /* ch+$13C: experience given by the defeated monster (word) */
    case 0x1E: return c->b[0x13E]; /* ch+$13E: experience of the monster per hit point (multiplies +$123) */
    case 0x1F:
        if (H005_B(0x24B3)) { /* $24B3: 1 if LOAD CHARACTER did not find the character (var $1F = 0) */
            return 0;
        }
        switch (c->b[0x197]) { /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
        case 0: return 1;
        case 3: return 6;
        case 4: return 5;
        case 5: return 4;
        case 6: return 3;
        case 7: return 7;
        case 8: return 2;
        default: return 0;
        }
    case 0x20:
        /* ch+$199: side in combat (0 party, 1 opponents); ch+$19A: automatic control in combat (1
         * = AI) */
        if (c->b[0x199] == 0 && c->b[0x19A]) {
            return 0x80;
        }
        return (u16)(c->b[0x199] == 1 ? 0x81 : 0); /* ch+$199: side in combat (0 party, 1 opponents) */
    case 0x21: return 0;
    case 0x22: return c->b[0x1A8]; /* ch+$1A8: current hit points */
    case 0x23: return c->b[0x1A9]; /* ch+$1A9: current movement (armour and encumbrance) */
    case 0x24: return party_index(g_current_char);
    case 0x25: return party_index(g_current_char);
    case 0x26:
        switch (c->b[0x1B]) { /* ch+$1B: current charisma */
        case 3: return 0;
        case 4: return 5;
        case 5: return 0x0A;
        case 6: return 0x0F;
        case 7: return 0x14;
        case 8: case 9: case 0x0A: case 0x0B: case 0x0C: return 0x19;
        case 0x0D: return 0x1E;
        case 0x0E: return 0x23;
        case 0x0F: return 0x28;
        case 0x10: return 0x32;
        case 0x11: return 0x37;
        case 0x12: case 0x13: case 0x14: case 0x15:
        case 0x16: case 0x17: case 0x18: case 0x19: return 0x3C;
        default: return 0;
        }
    /* $246E: data disk / current resource group (G_RESOURCE_GROUP) */
    case 0x27: return H005_B(0x246E);
    case 0x28: return COK_GET16(g_state_b + 0x67C); /* B+$67C: (word) number of party members (max 8) */
    default:
        *handled = 0;
        return 0;
    }
}

/*
 * PORT H061+$2E04: value of variable addr.  For the special registers
 * not provided for the original returns d0 unset: 0.
 */
u16 read_var(u16 addr)
{
    u16 v;                              /* -$2(a5) */
    u8 handled = 0;                     /* -$5(a5) */

    switch (var_region(addr)) {
    case 0:
        if (addr == 0xEA) {
            return H005_B(0x2820); /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
        }
        return COK_GET16(g_state_a + addr * 2);
    case 1:
        v = read_state_b_special(addr, &handled);
        if (!handled) {
            v = COK_GET16(g_state_b + (u16)(addr - 0x3100) * 2);
        }
        return v;
    case 2:
        return COK_GET16(g_state_c + (u16)(addr - 0x2F00) * 2);
    case 3:
        return ECL_BYTE(addr);
    case 4:
        if (addr < 0x754B) {
            /* $238C: value of the special ECL variable $B1 (word, read) */
            if (addr == 0xB1) return H005_W(0x238C);
            /* $2390: value of the special ECL variable $FB (word, read) */
            if (addr == 0xFB) return H005_W(0x2390);
            /* $238E: value of the special ECL variable $FC (word, read) */
            if (addr == 0xFC) return H005_W(0x238E);
            /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
            if (addr == 0x33D) return H005_B(0x2820);
            return 0;
        }
        switch ((u16)(addr - 0x754B)) {
        case 0: return H005_W(0x281C); /* $281C: (word) party x on the 16x16 area map */
        case 1: return H005_W(0x281E); /* $281E: (word) party y on the 16x16 area map */
        case 2:
            /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
            if (COK_GET16(g_state_a + 0x1CC) == 0) {
                return H005_B(0x2820); /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
            }
            /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
            return (u16)(H005_B(0x2820) >> 1);
        case 3: return H005_B(0x2821); /* $2821: wall in front of the party (map_wall on the square and direction) */
        /* $2822: flags of the party square (map_flags); bit 7 picks the sky */
        case 4: return H005_B(0x2822);
        default: return 0;
        }
    default:
        return 0;
    }
}

/*
 * PORT H061+$27E2: writing some variables of state B also changes the
 * current character (spells, AI, values, status, side, hit
 * points, dungeon walls...).
 */
static void write_state_b_hook(u16 addr, u16 val)
{
    static const u16 map[][2] = {
        { 0xB8, 2 }, { 0xBB, 3 }, { 0xBD, 4 }, { 0xBF, 5 }, { 0xC1, 6 },
        { 0xC3, 7 }, { 0xF7, 8 }, { 0xF9, 9 }, { 0x100, 0x0A },
        { 0x10C, 0x0B }, { 0x119, 0x0C }, { 0x312, 0x0D }, { 0x322, 0x0E },
        { 0x324, 0x0F }, { 0x326, 0x10 }
    };
    Character *c = g_current_char;
    u16 off;
    u16 idx = 0xFF;                     /* -$4(a5) */
    u16 k;

    off = (u16)(addr - 0x3100);
    if (off >= 0x20 && off <= 0x70) {
        idx = 1;
    } else {
        for (k = 0; k < sizeof map / sizeof map[0]; ++k) {
            if (map[k][0] == off) {
                idx = map[k][1];
                break;
            }
        }
    }
    switch (idx) {
    case 0:
        if (val == 0) {
            H005_B(0x24C3) = 1; /* $24C3: use: 1 from an ECL write of state B to 0; with $24C4 it leaves */
        }
        break;
    case 1:
        /* ch-$2: base -$20 of the spell list +$1E for the variables $3120..$3170 */
        c->b[0x1E + off - 0x20] = (u8)val;
        break;
    case 2:
        if (val > 0xB2) {
            val = (u16)(val - 0x32);
        }
        c->b[0xEC] = (u8)val; /* ch+$EC: control: <$80 PC, >$7F NPC/AI ($B3 = charmed or confused) */
        break;
    /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
    case 3: COK_PUT16(&c->b[0xF0], val); break;
    case 4: COK_PUT16(&c->b[0xF2], val); break; /* ch+$F2: coins of type 1 (word) */
    case 5: COK_PUT16(&c->b[0xF4], val); break; /* ch+$F4: coins of type 2 (word) */
    case 6: COK_PUT16(&c->b[0xF6], val); break; /* ch+$F6: coins of type 3 (word) */
    case 7: COK_PUT16(&c->b[0xF8], val); break; /* ch+$F8: steel pieces (coin type 4) (word) */
    case 8: COK_PUT16(&c->b[0x13C], val); break; /* ch+$13C: experience given by the defeated monster (word) */
    /* ch+$13E: experience of the monster per hit point (multiplies +$123) */
    case 9: c->b[0x13E] = (u8)val; break;
    case 0x0A:
        if (val == 1) {
            c->b[0x197] = 0; /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
            c->b[0x198] = 1; /* ch+$198: active/standing (0 down or out of the combat) */
        }
        break;
    case 0x0B:
        if (val > 0x7F) {
            val = (u16)(val - 0x7F);
        }
        switch (val) {
        /* ch+$199: side in combat (0 party, 1 opponents); ch+$19A: automatic control in combat (1
         * = AI) */
        case 0: c->b[0x199] = 0; c->b[0x19A] = 0; break;
        /* ch+$199: side in combat (0 party, 1 opponents); ch+$19A: automatic control in combat (1
         * = AI) */
        case 1: c->b[0x199] = 0; c->b[0x19A] = 1; break;
        /* ch+$199: side in combat (0 party, 1 opponents); ch+$19A: automatic control in combat (1
         * = AI) */
        case 2: c->b[0x199] = 1; c->b[0x19A] = 1; break;
        default: break;
        }
        break;
    case 0x0C:
        c->b[0x1A8] = (u8)val; /* ch+$1A8: current hit points */
        break;
    case 0x0D:
        set_data_disk((u8)val);
        break;
    case 0x0E:
    case 0x0F:
    case 0x10:
        if (val > 0x80) {
            val = mask_byte((u8)val, 0x7F);
            load_wall_defs(val, (u16)(idx - 0x0D));
        }
        break;
    default:
        break;
    }
}

/* PORT H061+$2BAA: writes val into variable addr. */
void write_var(u16 addr, u16 val)
{
    s16 a;
    u8 ok;                              /* -$3(a5) */

    switch (var_region(addr)) {
    case 0:
        if (addr == 0xFD || addr == 0xFE) {
            H005_B(0x24B5) = 1; /* $24B5: 1 if ECL wrote vars $FD/$FE: view to be redrawn */
        /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
        } else if (addr == 0xE6 && COK_GET16(g_state_a + 0x1CC) != val) {
            /* $3DE2: previous game context (copy of $3DE3), saved; $3DE3: current game
             * mode/context (0 menu, 1 view, 5 combat) */
            H005_B(0x3DE2) = H005_B(0x3DE3);
            /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
            H005_B(0x3DE3) = (u8)(val == 0 ? 3 : 4);
        }
        COK_PUT16(g_state_a + addr * 2, val);
        break;
    case 1:
        COK_PUT16(g_state_b + (u16)(addr - 0x3100) * 2, val);
        write_state_b_hook(addr, val);
        break;
    case 2:
        COK_PUT16(g_state_c + (u16)(addr - 0x2F00) * 2, val);
        break;
    case 3:
        ECL_BYTE(addr) = (u8)val;
        break;
    case 4:
        if (addr < 0x7468) {
            if (addr == 0xB8) {
                H005_SET_W(0x2374, val); /* $2374: use: word written by the ECL with variable $B8 */
            } else if (addr == 0xB9) {
                H005_SET_W(0x2372, val); /* $2372: use: word written by the ECL with variable $B9 */
            }
            break;
        }
        a = (s16)(addr - 0x754B);
        if (a == 0x0E) {
            a = 3;
        } else if (a == 0x14) {
            a = 4;
        }
        switch (a) {
        case 0:
            H005_B(0x24B7) = 1; /* $24B7: 1 if the party position/direction changed: view to be redrawn */
            H005_SET_W(0x281C, val); /* $281C: (word) party x on the 16x16 area map */
            break;
        case 1:
            H005_SET_W(0x281E, val); /* $281E: (word) party y on the 16x16 area map */
            H005_B(0x24B7) = 1; /* $24B7: 1 if the party position/direction changed: view to be redrawn */
            break;
        case 2:
            do {
                ok = 1;
                if (val < 4) {
                    /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
                    H005_B(0x2820) = (u8)(val * 2);
                } else {
                    ok = 0;
                    val = (u16)(val - 4);
                }
            } while (ok != 1);
            H005_B(0x24B7) = 1; /* $24B7: 1 if the party position/direction changed: view to be redrawn */
            break;
        case 3:
            /* $247F: use: $DB at start-up, $41 when the area starts; written by ECL var $7559 */
            H005_B(0x247F) = (u8)val;
            H005_B(0x24B8) = 1; /* $24B8: 1 if $247E/$247F changed: view to be redrawn */
            break;
        case 4:
            /* $247E: use: $E8 at start-up, 9 when the area starts; written by ECL var $755F */
            H005_B(0x247E) = (u8)val;
            H005_B(0x24B8) = 1; /* $24B8: 1 if $247E/$247F changed: view to be redrawn */
            break;
        default:
            break;
        }
        break;
    default:
        break;
    }
}

/*
 * PORT H061+$1670 (ECL_ReadOperands): reads n operands after the code of the
 * command: descriptor and one byte, plus another byte for types 1..3 and 5;
 * the strings (type $80 immediate, $81 from a variable) go into the strings
 * of the module in order.  Then skips the code of the next command.
 */
void read_operands(u16 n)
{
    u16 i;                              /* -$2(a5) */
    u16 strings = 0;                    /* -$4(a5) */
    u16 kind;                           /* -$A(a5) */
    u16 len;                            /* -$8(a5) */

    for (i = 1; i <= n; ++i) {
        /* H061_bss+$14D2: 64 bytes: descriptor/type of the ECL operands (OP_DESC); ECL-$34FF: use: byte at
         * ECL PC+1 (buffer from $3500): descriptor of the operand; $3DEA: (word) logical PC of the
         * ECL program (base $3500) */
        OP_DESC(i - 1) = ECL_BYTE(H005_W(0x3DEA) + 1);
        /* H061_bss+$1452: 64 bytes: low byte of the ECL operands (OP_LO, index i-1); ECL-$34FE: use: byte
         * at ECL PC+2 (buffer from $3500): low byte of the operand; $3DEA: (word) logical PC of the
         * ECL program (base $3500) */
        OP_LO(i - 1) = ECL_BYTE(H005_W(0x3DEA) + 2);
        H005_SET_W(0x3DEA, H005_W(0x3DEA) + 2); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
        /* H061_bss+$14D2: 64 bytes: descriptor/type of the ECL operands (OP_DESC) */
        if (OP_DESC(i - 1) > 0x7F) {
            /* H061_bss+$14D2: 64 bytes: descriptor/type of the ECL operands (OP_DESC) */
            kind = (u16)(OP_DESC(i - 1) - 0x7C);
        } else {
            /* H061_bss+$14D2: 64 bytes: descriptor/type of the ECL operands (OP_DESC) */
            kind = OP_DESC(i - 1);
        }
        switch (kind) {
        case 1:
        case 2:
        case 3:
            /* $3DEA: (word) logical PC of the ECL program (base $3500) */
            H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1);
            /* H061_bss+$1492: 64 bytes: high byte of the ECL operands (OP_HI, index i-1);
             * $3DEA: (word) logical PC of the ECL program (base $3500) */
            OP_HI(i - 1) = ECL_BYTE(H005_W(0x3DEA));
            break;
        case 4:
            ++strings;
            /* H061_bss+$1452: 64 bytes: low byte of the ECL operands (OP_LO, index i-1) */
            len = OP_LO(i - 1);
            if (len > 0) {
                read_string_operand(len, strings);
            } else {
                /* H061_bss+$52: 20 ECL strings of $100 bytes (ECL_STR, index slot-1) */
                strcpy(ECL_STR(strings - 1), "");
            }
            break;
        case 5:
            ++strings;
            /* $3DEA: (word) logical PC of the ECL program (base $3500) */
            H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1);
            /* H061_bss+$1492: 64 bytes: high byte of the ECL operands (OP_HI, index i-1);
             * $3DEA: (word) logical PC of the ECL program (base $3500) */
            OP_HI(i - 1) = ECL_BYTE(H005_W(0x3DEA));
            read_string_var(strings,
                            /* H061_bss+$1452: 64 bytes: low byte of the ECL operands (OP_LO, index i-1); H061_bss+$1492: 64
                             * bytes: high byte of the ECL operands (OP_HI, index i-1) */
                            decode_address(OP_LO(i - 1), OP_HI(i - 1)));
            break;
        default:
            break;
        }
    }
    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
}

/*
 * PORT H061+$184E (ECL_EvaluateOperand): value of operand i: type 0
 * byte, 2 immediate word, 1 and 3 variable, 4 address ($81 -> 4).  With
 * another type the original returns d0 unset: 0.
 */
u16 eval_operand(u16 i)
{
    /* H061_bss+$1452: 64 bytes: low byte of the ECL operands (OP_LO, index i-1) */
    u8 lo = OP_LO(i - 1);               /* -$9(a5) */
    /* H061_bss+$1492: 64 bytes: high byte of the ECL operands (OP_HI, index i-1) */
    u8 hi = OP_HI(i - 1);               /* -$A(a5) */
    u16 kind;                           /* -$2(a5) */

    kind = OP_DESC(i - 1); /* H061_bss+$14D2: 64 bytes: descriptor/type of the ECL operands (OP_DESC) */
    if (kind > 0x7F) {
        kind = (u16)(kind - 0x7D);
    }
    switch (kind) {
    case 0: return lo;
    case 1:
    case 3: return read_var((u16)((hi << 8) + lo - 0x4B00));
    case 2: return make_word(lo, hi);
    case 4: return decode_address(lo, hi);
    default: return 0;
    }
}

/* Raw bytes of operand i (for whoever reads them directly in H012/H064). */
/* H061_bss+$14D2: 64 bytes: descriptor/type of the ECL operands (OP_DESC) */
u8 operand_desc(u16 i) { return OP_DESC(i - 1); }
/* H061_bss+$1452: 64 bytes: low byte of the ECL operands (OP_LO, index i-1) */
u8 operand_lo(u16 i)   { return OP_LO(i - 1); }
/* H061_bss+$1492: 64 bytes: high byte of the ECL operands (OP_HI, index i-1) */
u8 operand_hi(u16 i)   { return OP_HI(i - 1); }

/*
 * PORT H061+$3244: immediate string of len 6-bit characters (four
 * characters every three bytes) into string slot; characters 0 are skipped.
 * The first "previous" and "current" bytes are not initialised
 * in the original: here 0.
 */
void read_string_operand(u16 len, u16 slot)
{
    char *s = ECL_STR(slot - 1); /* H061_bss+$52: 20 ECL strings of $100 bytes (ECL_STR, index slot-1) */
    u16 count = 0;                      /* -$2(a5) */
    u16 phase = 1;                      /* -$A(a5) */
    u16 ch = 0;                         /* -$8(a5) */
    u8 cur = 0;                         /* -$5(a5) */
    u8 prev = 0;                        /* -$6(a5) */

    strcpy(s, "");
    while (count < len) {
        if (phase < 4) {
            /* $3DEA: (word) logical PC of the ECL program (base $3500) */
            H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1);
            prev = cur;
            cur = ECL_BYTE(H005_W(0x3DEA)); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
            ++count;
        }
        switch (phase) {
        case 1:
            ch = (u8)(cur >> 2);
            break;
        case 2:
            ch = (u16)(((u8)(prev << 6) + (u8)(cur >> 2)) >> 2);
            break;
        case 3:
            ch = (u16)(((u8)(prev << 4) + (u8)(cur >> 4)) >> 2);
            break;
        case 4:
            ch = mask_byte(cur, 0x3F);
            break;
        default:
            break;
        }
        phase = (u16)(phase < 4 ? phase + 1 : 1);
        if (ch != 0) {
            append_char(0xFF, s, ecl_char(ch));
        }
    }
    if (phase == 4) {
        ch = mask_byte(cur, 0x3F);
        if (ch != 0) {
            append_char(0xFF, s, ecl_char(ch));
        }
    }
}

/*
 * PORT H061+$33F0: string read from the variables from addr (one character
 * per word, up to 0) into string slot; $3100 is the name of the
 * current character.
 */
void read_string_var(u16 slot, u16 addr)
{
    char *s = ECL_STR(slot - 1); /* H061_bss+$52: 20 ECL strings of $100 bytes (ECL_STR, index slot-1) */
    u16 k = 0;                          /* -$4(a5) */

    strcpy(s, "");
    switch (var_region(addr)) {
    case 0:
        while (COK_GET16(g_state_a + (u16)(addr + k) * 2) != 0) {
            append_char(0xFF, s,
                        (u8)COK_GET16(g_state_a + (u16)(addr + k) * 2));
            ++k;
        }
        break;
    case 1:
        if (addr == 0x3100) {
            h026_copy(0xFF, s, 0x0F, (const char *)g_current_char->b);
        } else {
            while (COK_GET16(g_state_b + (u16)(addr + k - 0x3100) * 2) != 0) {
                append_char(0xFF, s,
                            (u8)COK_GET16(g_state_b +
                                          (u16)(addr + k - 0x3100) * 2));
                ++k;
            }
        }
        break;
    case 2:
        while (COK_GET16(g_state_c + (u16)(addr + k - 0x2F00) * 2) != 0) {
            append_char(0xFF, s,
                        (u8)COK_GET16(g_state_c +
                                      (u16)(addr + k - 0x2F00) * 2));
            ++k;
        }
        break;
    case 3:
        while (ECL_BYTE(addr + k) != 0) {
            append_char(0xFF, s, ECL_BYTE(addr + k));
            ++k;
        }
        break;
    default:
        break;
    }
}

/* ECL call stack (GOSUB): $2388 top, $2384 scratch. */
CokEclFrame *g_ecl_stack;               /* $2388 */
CokEclFrame *g_ecl_stack_prev;          /* $2384 */

/*
 * PORT H061+$1928: start of the ECL program of the area: clears the flags of the
 * step, PC at $3500, empty stack, comparison results at 0; reads the
 * five entry addresses ($3DF4, $3DF2, $3DF0, $3DEE, $3DEC) and, if
 * the area is not reloaded ($24D1), clears the variables $100..$11F of
 * state A and $3479..$3482 of state B.
 */
void ecl_start_area(void)
{
    u16 i;                              /* -$4(a5) */

    H005_B(0x24BD) = 0; /* $24BD: 1 if the event picture/portrait is on screen */
    H005_B(0x24BB) = 0; /* $24BB: use: cleared when the area starts; with 1 EXIT redraws the frame */
    H005_B(0x24C4) = 0; /* $24C4: use: cleared; with $24C3 LOAD CHARACTER removes from the party */
    H005_B(0x24C3) = 0; /* $24C3: use: 1 from an ECL write of state B to 0; with $24C4 it leaves */
    H005_B(0x247F) = 0x41; /* $247F: use: $DB at start-up, $41 when the area starts; written by ECL var $7559 */
    H005_B(0x247E) = 9; /* $247E: use: $E8 at start-up, 9 when the area starts; written by ECL var $755F */
    H005_B(0x24B8) = 1; /* $24B8: 1 if $247E/$247F changed: view to be redrawn */
    /* $2378: flag: event sprite already shown (flags[0], 2 bytes with +$2379) */
    h029_fill_bytes(1, &H005_B(0x2378), 2, 0);
    H005_B(0x248E) = 8; /* $248E: next slot of the CPIC figure set for the monsters (from 8) */
    H005_SET_W(0x3DEA, 0x3500); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
    H005_B(0x24C5) = 0; /* $24C5: outcome of the target choice (breaths, effect $42) */
    g_ecl_stack = NULL;
    g_ecl_stack_prev = NULL;
    /* $237E: results of the last ECL comparison, 6 bytes: +0 equal */
    h029_fill_bytes(5, &H005_B(0x237E), 6, 0);
    COK_PUT16(g_state_b + 0x5C2, 0xFF); /* B+$5C2: (word) head of the event portrait, $FF PIC picture */
    COK_PUT16(g_state_b + 0x5A4, 0); /* B+$5A4: (word) rest steps (5 min) between encounter rolls, 0 never */
    COK_PUT16(g_state_b + 0x5A6, 0); /* B+$5A6: (word) % chance of an encounter while resting */
    COK_PUT16(g_state_a + 0x1CA, 0); /* A+$1CA: (word) if not zero no spells can be cast in the area */
    read_operands(1);
    /* H061_bss+$1452: 64 bytes: low byte of the ECL operands (OP_LO, index i-1); H061_bss+$1492:
     * 64 bytes: high byte of the ECL operands (OP_HI, index i-1); $3DF4: (word) ECL entry run
     * after $3DEC and in the exploration loop */
    H005_SET_W(0x3DF4, decode_address(OP_LO(0), OP_HI(0)));
    read_operands(1);
    /* H061_bss+$1452: 64 bytes: low byte of the ECL operands (OP_LO, index i-1); H061_bss+$1492: 64
     * bytes: high byte of the ECL operands (OP_HI, index i-1); $3DF2: (word) ECL entry after
     * $3DF4; PC brought back here by the outdoor step */
    H005_SET_W(0x3DF2, decode_address(OP_LO(0), OP_HI(0)));
    read_operands(1);
    /* H061_bss+$1452: 64 bytes: low byte of the ECL operands (OP_LO, index i-1); H061_bss+$1492: 64
     * bytes: high byte of the ECL operands (OP_HI, index i-1); $3DF0: (word) ECL entry address of
     * the area's rest/camp */
    H005_SET_W(0x3DF0, decode_address(OP_LO(0), OP_HI(0)));
    read_operands(1);
    /* H061_bss+$1452: 64 bytes: low byte of the ECL operands (OP_LO, index i-1); H061_bss+$1492: 64
     * bytes: high byte of the ECL operands (OP_HI, index i-1); $3DEE: (word) ECL entry address
     * after resting/camp */
    H005_SET_W(0x3DEE, decode_address(OP_LO(0), OP_HI(0)));
    read_operands(1);
    /* H061_bss+$1452: 64 bytes: low byte of the ECL operands (OP_LO, index i-1); H061_bss+$1492:
     * 64 bytes: high byte of the ECL operands (OP_HI, index i-1); $3DEC: (word) first ECL
     * entry address of the area (on entry) */
    H005_SET_W(0x3DEC, decode_address(OP_LO(0), OP_HI(0)));
    if (H005_B(0x24D1)) { /* $24D1: 1 after Load Saved Game: the area does not clear its variables */
        return;
    }
    for (i = 1; i <= 0x20; ++i) {
        /* A+$1FE: (word) Pics*2+Animation in the saved game; from +$200 32 area vars */
        COK_PUT16(g_state_a + (i + 0xFF) * 2, 0);
    }
    for (i = 0; i <= 9; ++i) {
        /* B+$6F2: 10 words (ECL vars $3479..$3482) cleared when the area starts */
        COK_PUT16(g_state_b + (i + 0x3479 - 0x3100) * 2, 0);
    }
}

/*
 * PORT H061+$1ACC: loads block id of ECLn.dax (n = disk $246E) into the
 * program ($1DFF bytes cleared), retrying until the block is
 * valid ($102 bytes at least); "Loading...Please Wait" meanwhile.
 */
void load_ecl_program(u8 id)
{
    char num[6];                        /* -$6(a5) */
    u16 size = 0;                       /* -$8(a5) */
    u8 *data = NULL;                    /* -$C(a5) */
    /* H061_bss+$0: buffer of the name of the ECLn.dax file to load */
    char *name = (char *)&g_h061_bss[0];    /* -$1512(a4) */

    h029_fill_bytes(0x1DFF, g_ecl_buffer, 0x1DFF, 0);
    H005_B(0x24A4) = 0; /* $24A4: use: ignored argument of Open_ResourceFile; 1 when loading SPC */
    do {
        clear_message_line();
        ui_draw_text(0, 0x18, 0x0A, 0, 0x15, "Loading...Please Wait");
        /* $246E: data disk / current resource group (G_RESOURCE_GROUP) */
        format_number(1, num, (s32)H005_B(0x246E), 0, 0x0A, 1, '0');
        strcpy(name, "ECL");
        h026_append(0x50, name, 1, num);
        dax_load_block(0x50, name, 4, ".dax", id, &size, &data);
    } while (size < 0x102);
    exec_copy_mem(data + 2, g_ecl_buffer, (u32)(u16)(size - 0x102));
    exec_free_mem(data, size);
    clear_message_line();
}

/*
 * PORT H061+$1BD6: allocates a character and loads monster idx into it
 * (H066+$1FDA); also returns its items and its effects.
 */
void load_monster(u8 idx, Character **out, CokItem **items,
                  CokEffect **effects)
{
    *out = NULL;
    *out = (Character *)exec_alloc_mem(sizeof(Character), COK_MEMF_CLEAR);
    load_monster_record(idx, *out);
    *items = (*out)->items;
    *effects = (*out)->effects;
}

/*
 * PORT H061+$1C42: free squares (at most 2) from (x, y) in direction
 * dir before a wall; outdoors always 2 (and $3E00+$582 = 2).
 */
u16 free_steps(s16 x, s16 y, u8 dir)
{
    u16 steps = 0;                      /* -$4(a5) */
    u8 stop = 0;                        /* -$1(a5) */
    u16 r = 0;                          /* -$6(a5) */

    if (COK_GET16(g_state_a + 0x1CC) == 0) { /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
        r = 2;
        /* B+$582: (word) current distance of the enemies, limited to the free squares */
        COK_PUT16(g_state_b + 0x582, 2);
        return r;
    }
    while (steps < 2 && !stop) {
        if (map_wall(x, y, dir) == 0) {
            ++steps;
            r = steps;
            switch (dir) {
            case 0: --y; break;
            case 2: ++x; break;
            case 4: ++y; break;
            case 6: --x; break;
            default: break;
            }
        } else {
            stop = 1;
        }
    }
    return r;
}

/* PORT H061+$1D20: head+body portrait (H042) in the window 3,3. */
void show_head_body(u16 head, u16 body)
{
    H005_B(0x24BC) = 0; /* $24BC: 1 if the event picture can be animated (not head+body) */
    H005_B(0x2488) = (u8)head; /* $2488: head of the head+body portrait shown (for redrawing) */
    H005_B(0x2487) = (u8)body; /* $2487: body of the head+body portrait shown (for redrawing) */
    load_head_body(head, body);
    draw_head_body(3, 3, 1);
}

/*
 * PORT H061+$1D6E: event pictures: on first use the background (in the
 * dungeon the sprite spr of SPRITn) and frame idx+1; then, if
 * $3E00+$5C2 changed, the portrait: PIC pic ($FF) or head+body.
 * flags[0]/[1]: sprite and portrait already shown.
 */
void show_event_picture(u8 spr, u8 pic, u8 idx, u8 *flags)
{
    u16 frame;                          /* -$A(a5) */

    frame = (u16)(idx + 1);
    if (!flags[1]) {
        if (!flags[0]) {
            if (H005_B(0x2825)) { /* $2825: top-down map flag, active instead of the 3D view */
                H005_B(0x2825) = 0; /* $2825: top-down map flag, active instead of the 3D view */
                H005_B(0x24E1) = 1; /* $24E1: 1: exploration picture/view to be redrawn */
                refresh_view();
            }
            /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
            if (COK_GET16(g_state_a + 0x1CC)) {
                load_sequence(5, "SPRIT", spr, 1);
                flags[0] = 1;
                H005_B(0x24BA) = 1; /* $24BA: 1 if the SPRIT sprite of the event is on screen */
            }
        } else {
            H005_B(0x24E1) = 1; /* $24E1: 1: exploration picture/view to be redrawn */
            refresh_view();
        }
        /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
        if (H005_B(0x3DE3) == 4) {
            show_3d_sprite(frame);
        }
    }
    /* $2496: portrait ($3E00+$5C2) of the last event picture shown; B+$5C2: (word) head of the
     * event portrait, $FF PIC picture */
    if (flags[1] && H005_B(0x2496) == COK_GET16(g_state_b + 0x5C2)) {
        return;
    }
    /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat) */
    if (idx != 0 || H005_B(0x3DE3) != 4) {
        return;
    }
    /* $24B4: 1 during the ENCOUNTER command; $24D3: use: never written; with $24B4 it blocks the
     * portrait in ENCOUNTER */
    if (H005_B(0x24B4) && !H005_B(0x24D3)) {
        return;
    }
    /* $2496: portrait ($3E00+$5C2) of the last event picture shown; B+$5C2: (word) head of the
     * event portrait, $FF PIC picture */
    H005_B(0x2496) = (u8)COK_GET16(g_state_b + 0x5C2);
    H005_B(0x24BD) = 1; /* $24BD: 1 if the event picture/portrait is on screen */
    /* B+$5C2: (word) head of the event portrait, $FF PIC picture */
    if (COK_GET16(g_state_b + 0x5C2) == 0xFF) {
        load_sequence(3, "PIC", pic, 0);
        flags[1] = 1;
        show_picture(3, 3, 1, g_pic_rec_27c2);
    } else {
        /* B+$5C2: (word) head of the event portrait, $FF PIC picture */
        show_head_body(COK_GET16(g_state_b + 0x5C2), pic);
        flags[1] = 1;
        H005_B(0x24BC) = 0; /* $24BC: 1 if the event picture can be animated (not head+body) */
    }
}

/*
 * PORT H061+$35E2: dst = letters and digits of src made "lower case" (+$20)
 * and, after every '~', the next character in upper case (the shortcuts
 * of an ECL menu).  src is modified.
 */
static void menu_hotkeys(char *dst, u16 dst_len, char *src, u16 src_len)
{
    u16 i;                              /* -$2(a5) */
    u8 ch;

    dst[0] = '\0';
    for (i = 0; i <= (u16)(h026_strlen(src_len, src) - 1); ++i) {
        ch = (u8)src[i];
        if ((ch >= 'A' && ch <= 'Z') || (ch >= '0' && ch <= '9')) {
            src[i] = (char)(ch + 0x20);
        }
        if (src[i] == '~') {
            h026_delete(src_len, src, i, 1);
            ch = (u8)src[i];
            if (ch >= 'a' && ch <= 'z') {
                ch = (u8)(ch & 0x5F);
            }
            append_char(dst_len, dst, ch);
        }
    }
}

/*
 * PORT H061+$36E6: ECL menu: options with the shortcuts marked by '~';
 * returns the position of the chosen shortcut, 0 for Enter (if
 * allowed), $FF if not found.  The special keys change the
 * current character (H065+$3390).
 */
u16 ecl_menu(u16 title_len, const char *title, u16 opt_len,
             const char *options, u16 pen1, u16 pen2, u16 pen3,
             u8 allow_enter, u8 animate)
{
    char t[0x100];
    char o[0x100];
    char keys[0x2A];                    /* -$2A(a5) */
    u8 special;                         /* -$2E(a5) */
    u8 key;                             /* -$2D(a5) */
    u16 k;                              /* -$2C(a5) */

    h026_copy(0xFF, t, title_len, title);
    h026_copy(0xFF, o, opt_len, options);
    menu_hotkeys(keys, 0x28, o, opt_len);
    for (;;) {
        key = ui_request_choice(title_len, t, opt_len, o, pen1, pen2, pen3, 1,
                                animate, &special);
        if (special) {
            select_party_member(key);
            draw_party(g_current_char);
            key = 0;
        }
        if ((key >= 'A' && key <= 'Z') || (key >= '0' && key <= '9') ||
            (key == 0x0D && allow_enter)) {
            break;
        }
    }
    if (key == 0x0D) {
        return 0;
    }
    k = 0;
    while (k <= (u16)(h026_strlen(0x28, keys) - 1) && (u8)keys[k] != key) {
        ++k;
    }
    if (k <= (u16)(h026_strlen(0x28, keys) - 1)) {
        return k;
    }
    return 0xFF;
}

/*
 * PORT H061+$3904: string comparison (H026+$0106, case insensitive):
 * results in H005+$237E..$2383 (=, <>, <, >, <=, >=).
 */
void compare_strings(u16 len_a, const char *a, u16 len_b, const char *b)
{
    char ca[0x100];
    char cb[0x100];
    u8 r;                               /* -$1(a5) */

    h026_copy(0xFF, ca, len_a, a);
    h026_copy(0xFF, cb, len_b, b);
    /* $237E: results of the last ECL comparison, 6 bytes: +0 equal */
    h029_fill_bytes(5, &H005_B(0x237E), 6, 0);
    r = h026_compare_nocase(len_a, ca, len_b, cb);
    if (r == 1) {
        H005_B(0x237E) = 1; /* $237E: results of the last ECL comparison, 6 bytes: +0 equal */
    }
    if (r != 1) {
        H005_B(0x237F) = 1; /* $237F: comparison results +1: not equal */
    }
    if (r == 0) {
        H005_B(0x2380) = 1; /* $2380: comparison results +2: less */
    }
    if (r == 2) {
        H005_B(0x2381) = 1; /* $2381: comparison results +3: greater */
    }
    if (r == 1 || r == 0) {
        H005_B(0x2382) = 1; /* $2382: comparison results +4: less or equal */
    }
    if (r == 1 || r == 2) {
        H005_B(0x2383) = 1; /* $2383: comparison results +5: greater or equal */
    }
}

/* PORT H061+$3A0A: word comparison: results in H005+$237E..$2383. */
void compare_words(u16 a, u16 b)
{
    /* $237E: results of the last ECL comparison, 6 bytes: +0 equal */
    h029_fill_bytes(5, &H005_B(0x237E), 6, 0);
    if (a == b) {
        H005_B(0x237E) = 1; /* $237E: results of the last ECL comparison, 6 bytes: +0 equal */
    }
    if (a != b) {
        H005_B(0x237F) = 1; /* $237F: comparison results +1: not equal */
    }
    if (a < b) {
        H005_B(0x2380) = 1; /* $2380: comparison results +2: less */
    }
    if (a > b) {
        H005_B(0x2381) = 1; /* $2381: comparison results +3: greater */
    }
    if (a <= b) {
        H005_B(0x2382) = 1; /* $2382: comparison results +4: less or equal */
    }
    if (a >= b) {
        H005_B(0x2383) = 1; /* $2383: comparison results +5: greater or equal */
    }
}

/*
 * PORT H061+$3AAC (GOSUB): saves the PC on the stack ($2388, 6-byte nodes
 * in the original) and jumps to the address of operand i.
 */
void ecl_gosub(u16 i)
{
    if (g_ecl_stack == NULL) {
        g_ecl_stack = (CokEclFrame *)exec_alloc_mem(sizeof(CokEclFrame),
                                                    COK_MEMF_CLEAR);
        g_ecl_stack->next = NULL;
    } else {
        g_ecl_stack_prev = g_ecl_stack;
        g_ecl_stack = (CokEclFrame *)exec_alloc_mem(sizeof(CokEclFrame),
                                                    COK_MEMF_CLEAR);
        g_ecl_stack->next = g_ecl_stack_prev;
    }
    g_ecl_stack->pc = H005_W(0x3DEA); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
    /* H061_bss+$1452: 64 bytes: low byte of the ECL operands (OP_LO, index i-1); H061_bss+$1492:
     * 64 bytes: high byte of the ECL operands (OP_HI, index i-1); $3DEA: (word) logical PC of
     * the ECL program (base $3500) */
    H005_SET_W(0x3DEA, decode_address(OP_LO(i - 1), OP_HI(i - 1)));
}

/*
 * PORT H061+$3B4E: the party moves forward one square in direction
 * $2820 (0 north, 2 east, 4 south, 6 west; the 16x16 map wraps around);
 * updates the flags of the square ($2822) and the wall in front ($2821).
 */
void step_forward(void)
{
    switch (H005_B(0x2820)) { /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
    case 0:
        if ((s16)H005_W(0x281E) > 0) { /* $281E: (word) party y on the 16x16 area map */
            /* $281E: (word) party y on the 16x16 area map */
            H005_SET_W(0x281E, H005_W(0x281E) - 1);
        } else {
            H005_SET_W(0x281E, 0x0F); /* $281E: (word) party y on the 16x16 area map */
        }
        break;
    case 2:
        if ((s16)H005_W(0x281C) < 0x0F) { /* $281C: (word) party x on the 16x16 area map */
            /* $281C: (word) party x on the 16x16 area map */
            H005_SET_W(0x281C, H005_W(0x281C) + 1);
        } else {
            H005_SET_W(0x281C, 0); /* $281C: (word) party x on the 16x16 area map */
        }
        break;
    case 4:
        if ((s16)H005_W(0x281E) < 0x0F) { /* $281E: (word) party y on the 16x16 area map */
            /* $281E: (word) party y on the 16x16 area map */
            H005_SET_W(0x281E, H005_W(0x281E) + 1);
        } else {
            H005_SET_W(0x281E, 0); /* $281E: (word) party y on the 16x16 area map */
        }
        break;
    case 6:
        if ((s16)H005_W(0x281C) > 0) { /* $281C: (word) party x on the 16x16 area map */
            /* $281C: (word) party x on the 16x16 area map */
            H005_SET_W(0x281C, H005_W(0x281C) - 1);
        } else {
            H005_SET_W(0x281C, 0x0F); /* $281C: (word) party x on the 16x16 area map */
        }
        break;
    default:
        break;
    }
    /* $2822: flags of the party square (map_flags); bit 7 picks the sky; $281C: (word) party x on the
     * 16x16 area map; $281E: (word) party y on the 16x16 area map */
    H005_B(0x2822) = map_flags((s16)H005_W(0x281C), (s16)H005_W(0x281E));
    /* $2821: wall in front of the party (map_wall on the square and direction); $281C: (word)
     * party x on the 16x16 area map; $281E: (word) party y on the 16x16 area map */
    H005_B(0x2821) = (u8)map_wall((s16)H005_W(0x281C), (s16)H005_W(0x281E),
                                  /* $2820: party direction (0 north, 2 east, 4 south, 6 west) */
                                  H005_B(0x2820));
    H005_B(0x24B7) = 1; /* $24B7: 1 if the party position/direction changed: view to be redrawn */
}

/*
 * PORT H061+$3C4C: multiplies by keep (FFP real number: SPFlt, SPMul,
 * SPFix with truncation) the coins, gems and jewellery of c
 * (+$F0..+$FC).
 */
void scale_money(CokReal keep, Character *c)
{
    u16 k;

    for (k = 0; k <= 6; ++k) {
        /* ch+$F0: coins, 7 words step 2 (0..4 coins, 4 steel, 5 gems, 6 jewellery) */
        COK_PUT16(&c->b[0xF0 + k * 2],
                  (u16)h015_spfix(h015_spmul(
                      h015_spflt((s32)COK_GET16(&c->b[0xF0 + k * 2])),
                      keep)));
    }
}

/*
 * PORT H061+$3DBE: every item of c has a chance% of being destroyed; the
 * probability drops by $5A for items with value +$3E beyond $FF and by
 * $32 beyond $18 (and stays lowered for the following ones).
 */
void destroy_items(u16 chance, Character *c)
{
    CokItem *it;                        /* -$6(a5) */
    CokItem *next;                      /* -$A(a5) */
    u16 r;                              /* -$2(a5) */

    it = c->items;
    while (it != NULL) {
        if (COK_GET16(&it->b[0x3E]) > 0xFF) { /* item+$3E: (word) unit weight of the item */
            chance = (u16)(chance > 0x5A ? chance - 0x5A : 0);
        } else if (COK_GET16(&it->b[0x3E]) > 0x18) { /* item+$3E: (word) unit weight of the item */
            chance = (u16)(chance > 0x32 ? chance - 0x32 : 0);
        }
        r = roll_dice(1, 0x64);
        next = it->next;
        if (r <= chance) {
            delete_item(c, it);
        }
        it = next;
    }
}

/*
 * PORT H061+$3E80: skips the current ECL command without running it (reads
 * its operands); the codes without operands advance by one byte.
 */
void ecl_skip_command(void)
{
    static const u8 nops[0x42] = {
        /* 00 */ 0, 1, 1, 2, 3, 3, 3, 3, 2, 2, 1, 3, 3, 0, 1, 2,
        /* 10 */ 2, 1, 1, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 1, 6, 2,
        /* 20 */ 1, 3, 2, 4, 0, 0, 0, 8, 3, 0x0E, 3, 0, 6, 1, 5, 3,
        /* 30 */ 3, 0, 1, 0, 1, 3, 1, 3, 1, 1, 0, 3, 1, 0, 0, 1,
        /* 40 */ 1, 2
    };
    u8 op;

    /* $2493: code of the ECL command being executed; $3DEA: (word) logical PC of the ECL program
     * (base $3500) */
    H005_B(0x2493) = ECL_BYTE(H005_W(0x3DEA));
    op = H005_B(0x2493); /* $2493: code of the ECL command being executed */
    if (op >= 1 && op <= 0x41 && nops[op] != 0) {
        read_operands(nops[op]);
    } else {
        H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1); /* $3DEA: (word) logical PC of the ECL program (base $3500) */
    }
}

/*
 * PORT H061+$3FA8: highest speed (+$1A9) in *maxv and lowest in
 * *minv among the characters (doubled with effect $27, halved with $2A).
 * They start from the first character, read even if the party is empty:
 * in that case they stay unchanged here.
 */
void party_speed_range(u16 *maxv, u16 *minv)
{
    Character *p;                       /* -$4(a5) */
    CokEffect *e;                       /* -$8(a5) */
    u8 v;                               /* -$9(a5) */

    p = g_party_head;
    if (p == NULL) {
        return;
    }
    *maxv = p->b[0x1A9]; /* ch+$1A9: current movement (armour and encumbrance) */
    *minv = p->b[0x1A9]; /* ch+$1A9: current movement (armour and encumbrance) */
    for (; p != NULL; p = p->next) {
        v = p->b[0x1A9]; /* ch+$1A9: current movement (armour and encumbrance) */
        if (find_effect(p, 0x27, &e)) {
            v = (u8)(v << 1);
        } else if (find_effect(p, 0x2A, &e)) {
            v = (u8)(v >> 1);
        }
        if (v > *maxv) {
            *maxv = v;
        }
        if (v < *minv) {
            *minv = v;
        }
    }
}

/*
 * PORT H061+$4092: message of the damage dmg to c in the text window
 * ("<name> is hit for nn points of Damage." or "<name> dies. " if the
 * damage exceeds the hit points by 10), then the damage; when the window is full
 * "press <enter>/<return> to continue".  Not for those already dead.
 */
void ecl_damage_message(Character *c, u16 dmg)
{
    char num[4];                        /* -$58(a5) */
    char msg[0x51];                     /* -$54(a5) */
    u8 clear;                           /* -$59(a5) */

    if (c->b[0x197] == 6) { /* ch+$197: status: 0 ok, 4 unconscious, 5 dying, 6-8 dead, $0A down */
        return;
    }
    clear = 0;
    format_number(3, num, (s32)dmg, 0, 0x0A, 2, '0');
    strcpy(msg, "  ");
    if (dmg > (u16)(c->b[0x1A8] + 0x0A)) { /* ch+$1A8: current hit points */
        h026_append(0x50, msg, 0x0F, (const char *)c->b);
        h026_append(0x50, msg, 7, " dies. ");
    } else {
        h026_append(0x50, msg, 0x0F, (const char *)c->b);
        h026_append(0x50, msg, 0x0C, " is hit for ");
        h026_append(0x50, msg, 3, num);
        h026_append(0x50, msg, 0x12, " points of Damage.");
    }
    if (H005_W(0x334C) > 0x16) { /* $334C: (word) text cursor: row */
        H005_SET_W(0x334C, 0x11); /* $334C: (word) text cursor: row */
        clear = 1;
        show_message_wait(0x0F, 0, 0x22, "press <enter>/<return> to continue");
    } else {
        clear = 0;
    }
    H005_SET_W(0x334E, 0x26); /* $334E: (word) text cursor: column */
    word_wrap_text(1, 0x11, 0x26, 0x16, 0x0F, 0, clear, 0x50, msg);
    damage_hit_points(c, dmg);
    clear_text_cells(0x11, 1, 0x26, 0x0F);
    draw_party(g_current_char);
}

/*
 * PORT H061+$3012: writes the string s (by value) into the variables from
 * addr, one character per word and a final 0; $3100 is the name of the
 * current character.  In state A the final 0 is written only with a
 * non-empty string.
 */
void write_string_var(u16 addr, u16 len, const char *s)
{
    char copy[0x100];
    u16 n;                              /* -$4(a5) */
    u16 k;                              /* -$6(a5) */

    h026_copy(0xFF, copy, len, s);
    n = h026_strlen(len, copy);
    switch (var_region(addr)) {
    case 0:
        if (n > 0) {
            for (k = 0; k <= (u16)(n - 1); ++k) {
                COK_PUT16(g_state_a + (u16)(addr + k) * 2, (u8)copy[k]);
            }
            COK_PUT16(g_state_a + (u16)(addr + n) * 2, 0);
        }
        break;
    case 1:
        if (addr == 0x3100) {
            h026_copy(0x0F, (char *)g_current_char->b, len, copy);
            break;
        }
        if (n > 0) {
            for (k = 0; k <= (u16)(n - 1); ++k) {
                COK_PUT16(g_state_b + (u16)(addr + k - 0x3100) * 2,
                          (u8)copy[k]);
            }
        }
        COK_PUT16(g_state_b + (u16)(addr + n - 0x3100) * 2, 0);
        break;
    case 2:
        if (n > 0) {
            for (k = 0; k <= (u16)(n - 1); ++k) {
                COK_PUT16(g_state_c + (u16)(addr + k - 0x2F00) * 2,
                          (u8)copy[k]);
            }
        }
        COK_PUT16(g_state_c + (u16)(addr + n - 0x2F00) * 2, 0);
        break;
    case 3:
        if (n > 0) {
            for (k = 0; k <= (u16)(n - 1); ++k) {
                ECL_BYTE(addr + k) = (u8)copy[k];
            }
        }
        ECL_BYTE(addr + n) = 0;
        break;
    default:
        break;
    }
}

/*
 * PORT H061+$3860: ECL list: H008+$13C0 with the title "Select" (the
 * options passed are not used).
 */
u8 ecl_list_menu(u16 title_len, const char *title, u16 opt_len,
                 const char *options, u16 title_pen, u16 normal_pen,
                 u16 highlight_pen, u16 first_col, u16 first_row,
                 u16 last_col, u16 last_row, CokMenuItem *list, u8 with_exit,
                 u8 *redraw, u16 *index, CokMenuItem **chosen)
{
    char copy[0x100];

    (void)opt_len;
    (void)options;
    h026_copy(0xFF, copy, title_len, title);
    return list_menu(title_len, copy, 6, "Select", title_pen, normal_pen,
                     highlight_pen, first_col, first_row, last_col, last_row,
                     list, with_exit, redraw, index, chosen);
}
