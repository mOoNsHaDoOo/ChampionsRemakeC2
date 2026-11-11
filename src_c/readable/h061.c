/* H061: servizi della VM ECL: operandi, variabili, stringhe e aree. */
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
 * Dati del modulo sotto a4 (g_h061_bss[0x1512 - off] e' -off(a4)):
 * -$40 descrittori, -$80 secondo byte e -$C0 primo byte degli operandi
 * letti, -$14C0 venti stringhe da $100 byte.
 */
u8 g_h061_bss[0x1512];
#define OP_DESC(i)  g_h061_bss[0x1512 - 0x40 + (i)]
#define OP_HI(i)    g_h061_bss[0x1512 - 0x80 + (i)]
#define OP_LO(i)    g_h061_bss[0x1512 - 0xC0 + (i)]
#define ECL_STR(i)  ((char *)&g_h061_bss[0x1512 - 0x14C0 + (i) * 0x100])

/* Programma ECL: indirizzi logici da $3500 in g_ecl_buffer. */
#define ECL_BYTE(addr)  g_ecl_buffer[(u16)((addr) - 0x3500)]

/* PORT H061+$15C2: link/unlk, nessun effetto. */
void h061_init(void)
{
}

/* Stringa n (1..20) letta da READ_OPERANDS. */
char *ecl_string(u16 n)
{
    return ECL_STR(n - 1);
}

/* PORT H061+$162E: accoda il carattere ch alla stringa s. */
void append_char(u16 len, char *s, u8 ch)
{
    u16 n;                              /* -$2(a5) */

    n = h026_strlen(len, s);
    s[n] = (char)ch;
    s[n + 1] = '\0';
}

/* PORT H061+$1F12: word da due byte (alto, basso). */
u16 make_word(u8 lo, u8 hi)
{
    return (u16)((hi << 8) + lo);
}

/* PORT H061+$1F3C (ECL_DecodeAddress): indirizzo di variabile ($4B00 di base). */
u16 decode_address(u8 lo, u8 hi)
{
    return (u16)((hi << 8) + lo - 0x4B00);
}

/* PORT H061+$1F6A: codice di carattere ECL (sotto $20 + $40). */
u8 ecl_char(u16 c)
{
    if (c > 0x1F) {
        return (u8)c;
    }
    return (u8)(c + 0x40);
}

/*
 * PORT H061+$1FA4: zona della variabile: 0 stato A ($000..$3FF), 1 stato
 * B ($3100..$34FF), 2 stato C ($2F00..$30FF), 3 programma ($3500..$52FF),
 * 4 registri speciali.
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

/* PORT H061+$202C: posizione (da 0) di c nel party; il numero se manca. */
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
 * PORT H061+$208E: le variabili $3100+ speciali dello stato B leggono il
 * personaggio corrente (*handled = 1); le altre no.  L'indice del caso e'
 * quello assegnato alle voci note o, per le altre, lo scarto stesso.
 * Per i casi senza valore l'originale restituisce d0 non impostato: 0.
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
    case 0: return c->b[0x13];
    case 1: return c->b[0x19];
    case 2: return c->b[0x1B];
    case 3: return c->b[0x5D];
    case 4: return c->b[0x5B];
    case 5: return c->b[0x5C];
    case 6: return c->b[0x64];
    case 7: return c->b[0xD5];
    case 8: return c->b[0xDB];
    case 9: case 0x0A: case 0x0B: case 0x0C:
    case 0x0D: case 0x0E: case 0x0F: case 0x10:
        return c->b[0xE0 + idx - 9];
    case 0x11: return c->b[0xEC];
    case 0x12: return COK_GET16(&c->b[0xF0]);
    case 0x13: return COK_GET16(&c->b[0xF2]);
    case 0x14: return COK_GET16(&c->b[0xF4]);
    case 0x15: return COK_GET16(&c->b[0xF6]);
    case 0x16: return COK_GET16(&c->b[0xF8]);
    case 0x17:
        return (u16)(c->b[0x103] + c->b[0x10B] * h073_130a(g_current_char));
    case 0x18: return c->b[0x100];
    case 0x19: return c->b[0x105];
    case 0x1A: return c->b[0x102];
    case 0x1B: return c->b[0x10E];
    case 0x1C: return c->b[0x10F];
    case 0x1D: return COK_GET16(&c->b[0x13C]);
    case 0x1E: return c->b[0x13E];
    case 0x1F:
        if (H005_B(0x24B3)) {
            return 0;
        }
        switch (c->b[0x197]) {
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
        if (c->b[0x199] == 0 && c->b[0x19A]) {
            return 0x80;
        }
        return (u16)(c->b[0x199] == 1 ? 0x81 : 0);
    case 0x21: return 0;
    case 0x22: return c->b[0x1A8];
    case 0x23: return c->b[0x1A9];
    case 0x24: return party_index(g_current_char);
    case 0x25: return party_index(g_current_char);
    case 0x26:
        switch (c->b[0x1B]) {
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
    case 0x27: return H005_B(0x246E);
    case 0x28: return COK_GET16(g_state_b + 0x67C);
    default:
        *handled = 0;
        return 0;
    }
}

/*
 * PORT H061+$2E04: valore della variabile addr.  Per i registri speciali
 * non previsti l'originale restituisce d0 non impostato: 0.
 */
u16 read_var(u16 addr)
{
    u16 v;                              /* -$2(a5) */
    u8 handled = 0;                     /* -$5(a5) */

    switch (var_region(addr)) {
    case 0:
        if (addr == 0xEA) {
            return H005_B(0x2820);
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
            if (addr == 0xB1) return H005_W(0x238C);
            if (addr == 0xFB) return H005_W(0x2390);
            if (addr == 0xFC) return H005_W(0x238E);
            if (addr == 0x33D) return H005_B(0x2820);
            return 0;
        }
        switch ((u16)(addr - 0x754B)) {
        case 0: return H005_W(0x281C);
        case 1: return H005_W(0x281E);
        case 2:
            if (COK_GET16(g_state_a + 0x1CC) == 0) {
                return H005_B(0x2820);
            }
            return (u16)(H005_B(0x2820) >> 1);
        case 3: return H005_B(0x2821);
        case 4: return H005_B(0x2822);
        default: return 0;
        }
    default:
        return 0;
    }
}

/*
 * PORT H061+$27E2: scrivere certe variabili dello stato B cambia anche il
 * personaggio corrente (incantesimi, IA, valori, stato, lato, punti
 * ferita, muri del dungeon...).
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
            H005_B(0x24C3) = 1;
        }
        break;
    case 1:
        c->b[0x1E + off - 0x20] = (u8)val;
        break;
    case 2:
        if (val > 0xB2) {
            val = (u16)(val - 0x32);
        }
        c->b[0xEC] = (u8)val;
        break;
    case 3: COK_PUT16(&c->b[0xF0], val); break;
    case 4: COK_PUT16(&c->b[0xF2], val); break;
    case 5: COK_PUT16(&c->b[0xF4], val); break;
    case 6: COK_PUT16(&c->b[0xF6], val); break;
    case 7: COK_PUT16(&c->b[0xF8], val); break;
    case 8: COK_PUT16(&c->b[0x13C], val); break;
    case 9: c->b[0x13E] = (u8)val; break;
    case 0x0A:
        if (val == 1) {
            c->b[0x197] = 0;
            c->b[0x198] = 1;
        }
        break;
    case 0x0B:
        if (val > 0x7F) {
            val = (u16)(val - 0x7F);
        }
        switch (val) {
        case 0: c->b[0x199] = 0; c->b[0x19A] = 0; break;
        case 1: c->b[0x199] = 0; c->b[0x19A] = 1; break;
        case 2: c->b[0x199] = 1; c->b[0x19A] = 1; break;
        default: break;
        }
        break;
    case 0x0C:
        c->b[0x1A8] = (u8)val;
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

/* PORT H061+$2BAA: scrive val nella variabile addr. */
void write_var(u16 addr, u16 val)
{
    s16 a;
    u8 ok;                              /* -$3(a5) */

    switch (var_region(addr)) {
    case 0:
        if (addr == 0xFD || addr == 0xFE) {
            H005_B(0x24B5) = 1;
        } else if (addr == 0xE6 && COK_GET16(g_state_a + 0x1CC) != val) {
            H005_B(0x3DE2) = H005_B(0x3DE3);
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
                H005_SET_W(0x2374, val);
            } else if (addr == 0xB9) {
                H005_SET_W(0x2372, val);
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
            H005_B(0x24B7) = 1;
            H005_SET_W(0x281C, val);
            break;
        case 1:
            H005_SET_W(0x281E, val);
            H005_B(0x24B7) = 1;
            break;
        case 2:
            do {
                ok = 1;
                if (val < 4) {
                    H005_B(0x2820) = (u8)(val * 2);
                } else {
                    ok = 0;
                    val = (u16)(val - 4);
                }
            } while (ok != 1);
            H005_B(0x24B7) = 1;
            break;
        case 3:
            H005_B(0x247F) = (u8)val;
            H005_B(0x24B8) = 1;
            break;
        case 4:
            H005_B(0x247E) = (u8)val;
            H005_B(0x24B8) = 1;
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
 * PORT H061+$1670 (ECL_ReadOperands): legge n operandi dopo il codice del
 * comando: descrittore e un byte, piu' un altro byte per i tipi 1..3 e 5;
 * le stringhe (tipo $80 immediata, $81 da variabile) vanno nelle stringhe
 * del modulo in ordine.  Poi salta il codice del comando successivo.
 */
void read_operands(u16 n)
{
    u16 i;                              /* -$2(a5) */
    u16 strings = 0;                    /* -$4(a5) */
    u16 kind;                           /* -$A(a5) */
    u16 len;                            /* -$8(a5) */

    for (i = 1; i <= n; ++i) {
        OP_DESC(i - 1) = ECL_BYTE(H005_W(0x3DEA) + 1);
        OP_LO(i - 1) = ECL_BYTE(H005_W(0x3DEA) + 2);
        H005_SET_W(0x3DEA, H005_W(0x3DEA) + 2);
        if (OP_DESC(i - 1) > 0x7F) {
            kind = (u16)(OP_DESC(i - 1) - 0x7C);
        } else {
            kind = OP_DESC(i - 1);
        }
        switch (kind) {
        case 1:
        case 2:
        case 3:
            H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1);
            OP_HI(i - 1) = ECL_BYTE(H005_W(0x3DEA));
            break;
        case 4:
            ++strings;
            len = OP_LO(i - 1);
            if (len > 0) {
                read_string_operand(len, strings);
            } else {
                strcpy(ECL_STR(strings - 1), "");
            }
            break;
        case 5:
            ++strings;
            H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1);
            OP_HI(i - 1) = ECL_BYTE(H005_W(0x3DEA));
            read_string_var(strings,
                            decode_address(OP_LO(i - 1), OP_HI(i - 1)));
            break;
        default:
            break;
        }
    }
    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1);
}

/*
 * PORT H061+$184E (ECL_EvaluateOperand): valore dell'operando i: tipo 0
 * byte, 2 word immediata, 1 e 3 variabile, 4 indirizzo ($81 -> 4).  Con
 * un tipo diverso l'originale restituisce d0 non impostato: 0.
 */
u16 eval_operand(u16 i)
{
    u8 lo = OP_LO(i - 1);               /* -$9(a5) */
    u8 hi = OP_HI(i - 1);               /* -$A(a5) */
    u16 kind;                           /* -$2(a5) */

    kind = OP_DESC(i - 1);
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

/* Byte grezzi dell'operando i (per chi li legge direttamente in H012/H064). */
u8 operand_desc(u16 i) { return OP_DESC(i - 1); }
u8 operand_lo(u16 i)   { return OP_LO(i - 1); }
u8 operand_hi(u16 i)   { return OP_HI(i - 1); }

/*
 * PORT H061+$3244: stringa immediata di len caratteri da 6 bit (quattro
 * caratteri ogni tre byte) nella stringa slot; i caratteri 0 si saltano.
 * I primi byte "precedente" e "corrente" non sono inizializzati
 * nell'originale: qui 0.
 */
void read_string_operand(u16 len, u16 slot)
{
    char *s = ECL_STR(slot - 1);
    u16 count = 0;                      /* -$2(a5) */
    u16 phase = 1;                      /* -$A(a5) */
    u16 ch = 0;                         /* -$8(a5) */
    u8 cur = 0;                         /* -$5(a5) */
    u8 prev = 0;                        /* -$6(a5) */

    strcpy(s, "");
    while (count < len) {
        if (phase < 4) {
            H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1);
            prev = cur;
            cur = ECL_BYTE(H005_W(0x3DEA));
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
 * PORT H061+$33F0: stringa letta dalle variabili da addr (un carattere
 * per word, fino a 0) nella stringa slot; $3100 e' il nome del
 * personaggio corrente.
 */
void read_string_var(u16 slot, u16 addr)
{
    char *s = ECL_STR(slot - 1);
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

/* Pila delle chiamate ECL (GOSUB): $2388 cima, $2384 appoggio. */
CokEclFrame *g_ecl_stack;               /* $2388 */
CokEclFrame *g_ecl_stack_prev;          /* $2384 */

/*
 * PORT H061+$1928: inizio del programma ECL dell'area: azzera i flag del
 * passo, PC a $3500, pila vuota, risultati dei confronti a 0; legge i
 * cinque indirizzi d'ingresso ($3DF4, $3DF2, $3DF0, $3DEE, $3DEC) e, se
 * l'area non e' ricaricata ($24D1), azzera le variabili $100..$11F dello
 * stato A e $3479..$3482 dello stato B.
 */
void ecl_start_area(void)
{
    u16 i;                              /* -$4(a5) */

    H005_B(0x24BD) = 0;
    H005_B(0x24BB) = 0;
    H005_B(0x24C4) = 0;
    H005_B(0x24C3) = 0;
    H005_B(0x247F) = 0x41;
    H005_B(0x247E) = 9;
    H005_B(0x24B8) = 1;
    h029_fill_bytes(1, &H005_B(0x2378), 2, 0);
    H005_B(0x248E) = 8;
    H005_SET_W(0x3DEA, 0x3500);
    H005_B(0x24C5) = 0;
    g_ecl_stack = NULL;
    g_ecl_stack_prev = NULL;
    h029_fill_bytes(5, &H005_B(0x237E), 6, 0);
    COK_PUT16(g_state_b + 0x5C2, 0xFF);
    COK_PUT16(g_state_b + 0x5A4, 0);
    COK_PUT16(g_state_b + 0x5A6, 0);
    COK_PUT16(g_state_a + 0x1CA, 0);
    read_operands(1);
    H005_SET_W(0x3DF4, decode_address(OP_LO(0), OP_HI(0)));
    read_operands(1);
    H005_SET_W(0x3DF2, decode_address(OP_LO(0), OP_HI(0)));
    read_operands(1);
    H005_SET_W(0x3DF0, decode_address(OP_LO(0), OP_HI(0)));
    read_operands(1);
    H005_SET_W(0x3DEE, decode_address(OP_LO(0), OP_HI(0)));
    read_operands(1);
    H005_SET_W(0x3DEC, decode_address(OP_LO(0), OP_HI(0)));
    if (H005_B(0x24D1)) {
        return;
    }
    for (i = 1; i <= 0x20; ++i) {
        COK_PUT16(g_state_a + (i + 0xFF) * 2, 0);
    }
    for (i = 0; i <= 9; ++i) {
        COK_PUT16(g_state_b + (i + 0x3479 - 0x3100) * 2, 0);
    }
}

/*
 * PORT H061+$1ACC: carica il blocco id di ECLn.dax (n = disco $246E) nel
 * programma ($1DFF byte azzerati), riprovando finche' il blocco non e'
 * valido ($102 byte almeno); "Loading...Please Wait" intanto.
 */
void load_ecl_program(u8 id)
{
    char num[6];                        /* -$6(a5) */
    u16 size = 0;                       /* -$8(a5) */
    u8 *data = NULL;                    /* -$C(a5) */
    char *name = (char *)&g_h061_bss[0];    /* -$1512(a4) */

    h029_fill_bytes(0x1DFF, g_ecl_buffer, 0x1DFF, 0);
    H005_B(0x24A4) = 0;
    do {
        clear_message_line();
        ui_draw_text(0, 0x18, 0x0A, 0, 0x15, "Loading...Please Wait");
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
 * PORT H061+$1BD6: alloca un personaggio e vi carica il mostro idx
 * (H066+$1FDA); restituisce anche i suoi oggetti e i suoi effetti.
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
 * PORT H061+$1C42: caselle libere (al massimo 2) da (x, y) in direzione
 * dir prima di un muro; all'aperto sempre 2 (e $3E00+$582 = 2).
 */
u16 free_steps(s16 x, s16 y, u8 dir)
{
    u16 steps = 0;                      /* -$4(a5) */
    u8 stop = 0;                        /* -$1(a5) */
    u16 r = 0;                          /* -$6(a5) */

    if (COK_GET16(g_state_a + 0x1CC) == 0) {
        r = 2;
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

/* PORT H061+$1D20: ritratto testa+corpo (H042) nella finestra 3,3. */
void show_head_body(u16 head, u16 body)
{
    H005_B(0x24BC) = 0;
    H005_B(0x2488) = (u8)head;
    H005_B(0x2487) = (u8)body;
    load_head_body(head, body);
    draw_head_body(3, 3, 1);
}

/*
 * PORT H061+$1D6E: immagini dell'evento: al primo uso lo sfondo (nel
 * dungeon lo sprite spr di SPRITn) e il fotogramma idx+1; poi, se
 * $3E00+$5C2 e' cambiato, il ritratto: PIC pic ($FF) o testa+corpo.
 * flags[0]/[1]: sprite e ritratto gia' mostrati.
 */
void show_event_picture(u8 spr, u8 pic, u8 idx, u8 *flags)
{
    u16 frame;                          /* -$A(a5) */

    frame = (u16)(idx + 1);
    if (!flags[1]) {
        if (!flags[0]) {
            if (H005_B(0x2825)) {
                H005_B(0x2825) = 0;
                H005_B(0x24E1) = 1;
                refresh_view();
            }
            if (COK_GET16(g_state_a + 0x1CC)) {
                load_sequence(5, "SPRIT", spr, 1);
                flags[0] = 1;
                H005_B(0x24BA) = 1;
            }
        } else {
            H005_B(0x24E1) = 1;
            refresh_view();
        }
        if (H005_B(0x3DE3) == 4) {
            show_3d_sprite(frame);
        }
    }
    if (flags[1] && H005_B(0x2496) == COK_GET16(g_state_b + 0x5C2)) {
        return;
    }
    if (idx != 0 || H005_B(0x3DE3) != 4) {
        return;
    }
    if (H005_B(0x24B4) && !H005_B(0x24D3)) {
        return;
    }
    H005_B(0x2496) = (u8)COK_GET16(g_state_b + 0x5C2);
    H005_B(0x24BD) = 1;
    if (COK_GET16(g_state_b + 0x5C2) == 0xFF) {
        load_sequence(3, "PIC", pic, 0);
        flags[1] = 1;
        show_picture(3, 3, 1, g_pic_rec_27c2);
    } else {
        show_head_body(COK_GET16(g_state_b + 0x5C2), pic);
        flags[1] = 1;
        H005_B(0x24BC) = 0;
    }
}

/*
 * PORT H061+$35E2: dst = lettere e cifre di src rese "minuscole" (+$20)
 * e, dopo ogni '~', il carattere seguente in maiuscolo (le scorciatoie
 * di un menu ECL).  src viene modificata.
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
 * PORT H061+$36E6: menu ECL: opzioni con le scorciatoie marcate da '~';
 * restituisce la posizione della scorciatoia scelta, 0 per Invio (se
 * ammesso), $FF se non trovata.  I tasti speciali cambiano il
 * personaggio corrente (H065+$3390).
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
 * PORT H061+$3904: confronto di stringhe (H026+$0106, senza maiuscole):
 * risultati in H005+$237E..$2383 (=, <>, <, >, <=, >=).
 */
void compare_strings(u16 len_a, const char *a, u16 len_b, const char *b)
{
    char ca[0x100];
    char cb[0x100];
    u8 r;                               /* -$1(a5) */

    h026_copy(0xFF, ca, len_a, a);
    h026_copy(0xFF, cb, len_b, b);
    h029_fill_bytes(5, &H005_B(0x237E), 6, 0);
    r = h026_compare_nocase(len_a, ca, len_b, cb);
    if (r == 1) {
        H005_B(0x237E) = 1;
    }
    if (r != 1) {
        H005_B(0x237F) = 1;
    }
    if (r == 0) {
        H005_B(0x2380) = 1;
    }
    if (r == 2) {
        H005_B(0x2381) = 1;
    }
    if (r == 1 || r == 0) {
        H005_B(0x2382) = 1;
    }
    if (r == 1 || r == 2) {
        H005_B(0x2383) = 1;
    }
}

/* PORT H061+$3A0A: confronto di word: risultati in H005+$237E..$2383. */
void compare_words(u16 a, u16 b)
{
    h029_fill_bytes(5, &H005_B(0x237E), 6, 0);
    if (a == b) {
        H005_B(0x237E) = 1;
    }
    if (a != b) {
        H005_B(0x237F) = 1;
    }
    if (a < b) {
        H005_B(0x2380) = 1;
    }
    if (a > b) {
        H005_B(0x2381) = 1;
    }
    if (a <= b) {
        H005_B(0x2382) = 1;
    }
    if (a >= b) {
        H005_B(0x2383) = 1;
    }
}

/*
 * PORT H061+$3AAC (GOSUB): salva il PC sulla pila ($2388, nodi di 6 byte
 * nell'originale) e salta all'indirizzo dell'operando i.
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
    g_ecl_stack->pc = H005_W(0x3DEA);
    H005_SET_W(0x3DEA, decode_address(OP_LO(i - 1), OP_HI(i - 1)));
}

/*
 * PORT H061+$3B4E: il party avanza di una casella nella direzione
 * $2820 (0 nord, 2 est, 4 sud, 6 ovest; la mappa 16x16 fa il giro);
 * aggiorna i flag della casella ($2822) e il muro davanti ($2821).
 */
void step_forward(void)
{
    switch (H005_B(0x2820)) {
    case 0:
        if ((s16)H005_W(0x281E) > 0) {
            H005_SET_W(0x281E, H005_W(0x281E) - 1);
        } else {
            H005_SET_W(0x281E, 0x0F);
        }
        break;
    case 2:
        if ((s16)H005_W(0x281C) < 0x0F) {
            H005_SET_W(0x281C, H005_W(0x281C) + 1);
        } else {
            H005_SET_W(0x281C, 0);
        }
        break;
    case 4:
        if ((s16)H005_W(0x281E) < 0x0F) {
            H005_SET_W(0x281E, H005_W(0x281E) + 1);
        } else {
            H005_SET_W(0x281E, 0);
        }
        break;
    case 6:
        if ((s16)H005_W(0x281C) > 0) {
            H005_SET_W(0x281C, H005_W(0x281C) - 1);
        } else {
            H005_SET_W(0x281C, 0x0F);
        }
        break;
    default:
        break;
    }
    H005_B(0x2822) = map_flags((s16)H005_W(0x281C), (s16)H005_W(0x281E));
    H005_B(0x2821) = (u8)map_wall((s16)H005_W(0x281C), (s16)H005_W(0x281E),
                                  H005_B(0x2820));
    H005_B(0x24B7) = 1;
}

/*
 * PORT H061+$3C4C: moltiplica per keep (numero reale FFP: SPFlt, SPMul,
 * SPFix con troncamento) le monete, le gemme e i gioielli di c
 * (+$F0..+$FC).
 */
void scale_money(CokReal keep, Character *c)
{
    u16 k;

    for (k = 0; k <= 6; ++k) {
        COK_PUT16(&c->b[0xF0 + k * 2],
                  (u16)h015_spfix(h015_spmul(
                      h015_spflt((s32)COK_GET16(&c->b[0xF0 + k * 2])),
                      keep)));
    }
}

/*
 * PORT H061+$3DBE: ogni oggetto di c ha chance% di andare distrutto; la
 * probabilita' cala di $5A per gli oggetti di valore +$3E oltre $FF e di
 * $32 oltre $18 (e resta calata per i seguenti).
 */
void destroy_items(u16 chance, Character *c)
{
    CokItem *it;                        /* -$6(a5) */
    CokItem *next;                      /* -$A(a5) */
    u16 r;                              /* -$2(a5) */

    it = c->items;
    while (it != NULL) {
        if (COK_GET16(&it->b[0x3E]) > 0xFF) {
            chance = (u16)(chance > 0x5A ? chance - 0x5A : 0);
        } else if (COK_GET16(&it->b[0x3E]) > 0x18) {
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
 * PORT H061+$3E80: salta il comando ECL corrente senza eseguirlo (legge
 * i suoi operandi); i codici senza operandi avanzano di un byte.
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

    H005_B(0x2493) = ECL_BYTE(H005_W(0x3DEA));
    op = H005_B(0x2493);
    if (op >= 1 && op <= 0x41 && nops[op] != 0) {
        read_operands(nops[op]);
    } else {
        H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1);
    }
}

/*
 * PORT H061+$3FA8: velocita' (+$1A9) piu' alta in *maxv e piu' bassa in
 * *minv fra i personaggi (doppia con l'effetto $27, dimezzata con $2A).
 * Partono dal primo personaggio, letto anche se il party e' vuoto:
 * qui allora restano invariati.
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
    *maxv = p->b[0x1A9];
    *minv = p->b[0x1A9];
    for (; p != NULL; p = p->next) {
        v = p->b[0x1A9];
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
 * PORT H061+$4092: messaggio del danno dmg a c nella finestra di testo
 * ("<nome> is hit for nn points of Damage." o "<nome> dies. " se il
 * danno supera i punti ferita di 10), poi il danno; a finestra piena
 * "press <enter>/<return> to continue".  Non per chi e' gia' morto.
 */
void ecl_damage_message(Character *c, u16 dmg)
{
    char num[4];                        /* -$58(a5) */
    char msg[0x51];                     /* -$54(a5) */
    u8 clear;                           /* -$59(a5) */

    if (c->b[0x197] == 6) {
        return;
    }
    clear = 0;
    format_number(3, num, (s32)dmg, 0, 0x0A, 2, '0');
    strcpy(msg, "  ");
    if (dmg > (u16)(c->b[0x1A8] + 0x0A)) {
        h026_append(0x50, msg, 0x0F, (const char *)c->b);
        h026_append(0x50, msg, 7, " dies. ");
    } else {
        h026_append(0x50, msg, 0x0F, (const char *)c->b);
        h026_append(0x50, msg, 0x0C, " is hit for ");
        h026_append(0x50, msg, 3, num);
        h026_append(0x50, msg, 0x12, " points of Damage.");
    }
    if (H005_W(0x334C) > 0x16) {
        H005_SET_W(0x334C, 0x11);
        clear = 1;
        show_message_wait(0x0F, 0, 0x22, "press <enter>/<return> to continue");
    } else {
        clear = 0;
    }
    H005_SET_W(0x334E, 0x26);
    word_wrap_text(1, 0x11, 0x26, 0x16, 0x0F, 0, clear, 0x50, msg);
    damage_hit_points(c, dmg);
    clear_text_cells(0x11, 1, 0x26, 0x0F);
    draw_party(g_current_char);
}

/*
 * PORT H061+$3012: scrive la stringa s (per valore) nelle variabili da
 * addr, un carattere per word e uno 0 finale; $3100 e' il nome del
 * personaggio corrente.  Nello stato A lo 0 finale si scrive solo con una
 * stringa non vuota.
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
 * PORT H061+$3860: lista ECL: H008+$13C0 con il titolo "Select" (le
 * opzioni passate non sono usate).
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
