/* H012: ciclo dell'esplorazione e interprete ECL. */
#include <string.h>
#include "h012.h"
#include "globals.h"
#include "unported.h"
#include "h060.h"
#include "h069.h"
#include "h070.h"
#include "h068.h"
#include "h061.h"
#include "h064.h"
#include "h013.h"
#include "h042_seq.h"
#include "h003_exec.h"
#include "h008.h"
#include "h010_input.h"
#include "h011.h"
#include "h026_string.h"
#include "h028_files.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h031.h"
#include "h036.h"
#include "h044_tiles.h"
#include "h045.h"
#include "h053.h"
#include "h056.h"
#include "h057.h"
#include "h066.h"
#include "h067.h"
#include "h071.h"
#include "h072.h"
#include "h058.h"
#include "h059.h"
#include "h062.h"
#include "h063.h"
#include "h065.h"

/* PORT H012+$0178: link/unlk, nessun effetto. */
void h012_init(void)
{
}

/*
 * PORT H012+$2DF2 (raggiunta da H012+$0186): esegue il comando ECL
 * $2493 col suo gestore (H064 o H012); i codici fuori tabella non fanno
 * nulla.
 */
static void ecl_execute(void)
{
    switch (H005_B(0x2493)) {
    case 0x00: ecl_exit(); break;
    case 0x01: ecl_goto(); break;
    case 0x02: ecl_gosub_cmd(); break;
    case 0x03: ecl_compare(); break;
    case 0x04: case 0x05: case 0x06: case 0x07: ecl_arithmetic(); break;
    case 0x08: ecl_random(); break;
    case 0x09: ecl_save(); break;
    case 0x0A: ecl_load_character(); break;
    case 0x0B: ecl_load_monster(); break;
    case 0x0C: ecl_approach(); break;
    case 0x0D: ecl_approach_step(); break;
    case 0x0E: ecl_picture(); break;
    case 0x0F: ecl_input_number(); break;
    case 0x10: ecl_input_string(); break;
    case 0x11: case 0x12: ecl_print(); break;
    case 0x13: ecl_return(); break;
    case 0x14: ecl_compare_and(); break;
    case 0x15: ecl_vertical_menu(); break;
    case 0x16: case 0x17: case 0x18: case 0x19: case 0x1A: case 0x1B:
        ecl_if(); break;
    case 0x1C: ecl_clear_monsters(); break;
    case 0x1D: ecl_party_strength(); break;
    case 0x1E: ecl_party_survey(); break;
    case 0x20: ecl_new_ecl(); break;
    case 0x21: case 0x37: ecl_load_files(); break;
    case 0x22: ecl_party_has_class(); break;
    case 0x23: ecl_surprise(); break;
    case 0x24: ecl_combat(); break;
    case 0x25: case 0x26: ecl_on_goto(); break;
    case 0x27: ecl_treasure(); break;
    case 0x28: ecl_rob(); break;
    case 0x29: ecl_encounter(); break;
    case 0x2A: ecl_get_table(); break;
    case 0x2B: ecl_horizontal_menu(); break;
    case 0x2C: ecl_parlay(); break;
    case 0x2D: ecl_special(); break;
    case 0x2E: ecl_damage(); break;
    case 0x2F: case 0x30: ecl_and_or(); break;
    case 0x31: ecl_clear_picture(); break;
    case 0x32: ecl_find_item(); break;
    case 0x33: ecl_new_line(); break;
    case 0x34: ecl_advance_time(); break;
    case 0x35: ecl_set_table(); break;
    case 0x36: ecl_add_npc(); break;
    case 0x38: ecl_party_menu(); break;
    case 0x39: ecl_who(); break;
    case 0x3A: ecl_delay(); break;
    case 0x3B: ecl_find_spell(); break;
    case 0x3C: ecl_nop_3c(); break;
    case 0x3D: ecl_redraw_screen(); break;
    case 0x3E: ecl_remove_character(); break;
    case 0x3F: ecl_has_effect(); break;
    case 0x40: ecl_remove_items(); break;
    case 0x41: ecl_experience(); break;
    default: break;
    }
}

/*
 * PORT H012+$018A: esegue il programma ECL da addr ($3DE8/$3DEA) finche'
 * un comando non lo ferma (H064+$B) o non si esce dall'area ($24D0);
 * $2494 tiene il comando precedente.
 */
void run_ecl(u16 addr)
{
    H005_SET_W(0x3DE8, addr);
    H005_SET_W(0x3DEA, addr);
    H064_B(0x0B) = 0;
    while (!H064_B(0x0B) && !H005_B(0x24D0)) {
        H005_B(0x2494) = H005_B(0x2493);
        H005_B(0x2493) = g_ecl_buffer[(u16)(H005_W(0x3DEA) - 0x3500)];
        ecl_execute();
    }
    H064_B(0x0B) = 0;
}

#define OPD(i)  operand_desc(i)
#define ADDR(i) decode_address(operand_lo(i), operand_hi(i))
#define TEXT64  ((char *)&g_h064_data[0x0C])    /* H064+$C */

/* Audio prima e dopo le scene: H043 (non portato, i comandi si saltano). */
static void scene_audio(void)
{
    if (H005_B(0x24A7)) {
        h043_190e(0xFF);
    }
    if (!H005_B(0x24A7)) {
        h043_0584();
    }
}

/*
 * PORT H012+$0208 (annidata in $01FA): scrive minimo, massimo, media e
 * "trovato" nelle variabili degli operandi 3..6.
 */
typedef struct SurveyFrame {
    u8 found;                           /* -$D(a5) */
    u16 avg;                            /* -$14(a5) */
    u16 max;                            /* -$16(a5) */
    u16 min;                            /* -$18(a5) */
    u16 dst[4];                         /* -$1A..-$20(a5) */
} SurveyFrame;

static void survey_store(SurveyFrame *f)
{
    write_var(f->dst[0], f->min);
    write_var(f->dst[1], f->max);
    write_var(f->dst[2], f->avg);
    write_var(f->dst[3], f->found);
}

/*
 * PORT H012+$01FA (comando $1E, PARTY SURVEY): per la variabile del
 * personaggio indicata (o il suo valore): effetto presente in qualcuno,
 * livello (+$1B), uno dei valori +$E0.. o la velocita' +$1A9: minimo,
 * massimo e media sul party.  Per una variabile non prevista l'indice non
 * e' inizializzato nell'originale: qui 0 (ricerca dell'effetto).
 */
void ecl_party_survey(void)
{
    SurveyFrame f;
    Character *p;                       /* -$C(a5) */
    CokEffect *e;                       /* -$12(a5) */
    u16 addr;                           /* -$2(a5) */
    u16 kind = 0;                       /* -$4(a5) */
    u16 total = 0;                      /* -$6(a5) */
    u16 v8;                             /* -$8(a5) */
    u16 count = 0;                      /* -$22(a5) */
    u16 k;                              /* -$24(a5) */
    u8 v;

    read_operands(6);
    p = g_party_head;
    f.found = 0;
    if (OPD(1) == 1) {
        addr = ADDR(1);
    } else {
        addr = eval_operand(1);
    }
    v8 = eval_operand(2);
    f.dst[0] = ADDR(3);
    f.dst[1] = ADDR(4);
    f.dst[2] = ADDR(5);
    f.dst[3] = ADDR(6);
    f.min = 0xFF;
    f.max = 0;
    f.avg = 0;
    addr = (u16)(addr - 0x3100);
    if (addr == 0x8400) {
        kind = 0;
    } else if (addr == 0x19) {
        kind = 1;
    } else if (addr > 0xA4 && addr < 0xAD) {
        kind = (u16)(addr - 0xA3);
    } else if (addr == 0x9F) {
        kind = 0x0A;
    }
    switch (kind) {
    case 0:
        while (p != NULL && !f.found) {
            f.found = find_effect(p, v8, &e);
            p = p->next;
        }
        f.min = 0;
        f.max = 0;
        f.avg = 0;
        survey_store(&f);
        break;
    case 1:
        for (; p != NULL; p = p->next) {
            ++count;
            v = p->b[0x1B];
            if (v > f.max) f.max = v;
            if (v < f.min) f.min = v;
            total = (u16)(total + v);
        }
        f.avg = (u16)(total / count);
        survey_store(&f);
        break;
    case 2: case 3: case 4: case 5: case 6: case 7: case 8: case 9:
        k = (u16)(addr - 0xA4);
        for (; p != NULL; p = p->next) {
            ++count;
            v = p->b[0xE0 + k - 1];
            if (v < f.min) f.min = v;
            if (v > f.max) f.max = v;
            total = (u16)(total + v);
        }
        f.avg = (u16)(total / count);
        survey_store(&f);
        break;
    case 0x0A:
        for (; p != NULL; p = p->next) {
            ++count;
            v = p->b[0x1A9];
            if (v < f.min) f.min = v;
            if (v > f.max) f.max = v;
            total = (u16)(total + v);
        }
        f.avg = (u16)(total / count);
        survey_store(&f);
        break;
    default:
        break;
    }
}

/* PORT H012+$05D6 (comando $22): 1 se nel party c'e' un ranger/guaritore (+$5C 4 o $A). */
void ecl_party_has_class(void)
{
    Character *p;                       /* -$4(a5) */
    u16 r = 0;                          /* -$6(a5) */
    u16 zero = 0;                       /* -$8(a5) */

    read_operands(2);
    for (p = g_party_head; p != NULL; p = p->next) {
        if (p->b[0x5C] == 4 || p->b[0x5C] == 0x0A) {
            r = 1;
        }
    }
    write_var(ADDR(1), r);
    write_var(ADDR(2), zero);
}

/*
 * PORT H012+$0688 (comando $23, SURPRISE): due d6 contro i valori degli
 * operandi; il risultato (0 nessuno, 1 o 2 sorpreso un lato) va in $2CB.
 */
void ecl_surprise(void)
{
    u16 v[4];                           /* -$10(a5)..-$A(a5) */
    u16 i;                              /* -$6(a5) */
    s16 a;                              /* -$12(a5) */
    s16 b;                              /* -$14(a5) */
    s16 r1;                             /* -$2(a5) */
    s16 r2;                             /* -$4(a5) */
    u16 res = 0;                        /* -$8(a5) */

    read_operands(4);
    for (i = 1; i <= 4; ++i) {
        v[i - 1] = eval_operand(i);
    }
    a = (s16)(v[3] + 2 - v[0]);
    b = (s16)(v[1] + 2 - v[2]);
    r1 = (s16)roll_dice(1, 6);
    r2 = (s16)roll_dice(1, 6);
    if (r1 <= a) {
        if (r2 > b) {
            res = 1;
        } else {
            res = 3;
        }
    }
    if (r2 <= b) {
        res = 2;
    }
    write_var(0x2CB, res);
}

/*
 * PORT H012+$0766 (comando $24, COMBAT): senza mostri caricati una
 * scena (H071+$092C, H072+$120C o H070+$1958 secondo $3E00+$6D8/$5C4);
 * altrimenti il combattimento (H059+$1782), dopo il quale H070+$1958 e,
 * all'aperto, l'immagine $79.  Poi contesto 3/4 e ridisegno.
 */
void ecl_combat(void)
{
    u8 save;                            /* -$8(a5) */
    u8 redraw = 1;                      /* -$7(a5) */
    u16 steps;                          /* -$2(a5) */

    H005_B(0x24AE) = 0;
    save = H005_B(0x24B0);
    H005_B(0x24B0) = 0;
    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1);
    if (!H005_B(0x24B6)) {
        if (COK_GET16(g_state_b + 0x6D8) == 1) {
            COK_PUT16(g_state_b + 0x6D8, 0);
            scene_audio();
            shop();
            if (COK_GET16(g_state_a + 0x1CC) == 0) {
                redraw = 0;
            }
            scene_audio();
        } else if (COK_GET16(g_state_b + 0x5C4) == 1) {
            COK_PUT16(g_state_b + 0x5C4, 0);
            scene_audio();
            temple();
            if (COK_GET16(g_state_a + 0x1CC) == 0) {
                redraw = 0;
            }
            scene_audio();
        } else {
            scene_audio();
            combat_end();
            scene_audio();
        }
    } else {
        scene_audio();
        steps = free_steps((s16)H005_W(0x281C), (s16)H005_W(0x281E),
                           H005_B(0x2820));
        if (steps < COK_GET16(g_state_b + 0x582)) {
            COK_PUT16(g_state_b + 0x582, steps);
        }
        release_picture_set();
        combat_main_loop();
        if (H005_B(0x24A7)) {
            h043_190e(0xFF);
        }
        combat_end();
        if (!H005_B(0x24A7)) {
            h043_0584();
        }
        if (COK_GET16(g_state_a + 0x1CC) == 0) {
            scene_audio();
            load_big_picture(0x79);
        } else {
            scene_audio();
        }
    }
    H005_B(0x3DE3) = (u8)(COK_GET16(g_state_a + 0x1CC) ? 4 : 3);
    COK_PUT16(g_state_b + 0x594,
              mask_byte((u8)COK_GET16(g_state_b + 0x594), 1));
    h029_fill_bytes(1, &H005_B(0x2378), 2, 0);
    H005_B(0x24BD) = 0;
    if (redraw) {
        redraw_game_screen();
        if (COK_GET16(g_state_a + 0x1CC) == 0 && !H005_B(0x24D0) &&
            COK_GET16(g_state_a + 0x270) == 0) {
            h069_draw_marker();
        }
    }
    H005_B(0x24B0) = save;
}

/* PORT H012+$0B18 (comandi $25 ON GOTO e $26 ON GOSUB). */
void ecl_on_goto(void)
{
    u8 done = 0;                        /* -$9(a5) */
    u16 v;                              /* -$2(a5) */
    u16 n;                              /* -$4(a5) */
    u16 i = 0;                          /* -$8(a5) */

    read_operands(2);
    v = eval_operand(1);
    n = eval_operand(2);
    H005_SET_W(0x3DEA, H005_W(0x3DEA) - 1);
    read_operands(n);
    while (i < n && !done) {
        if (v == i) {
            if (H005_B(0x2493) == 0x25) {
                H005_SET_W(0x3DEA, ADDR(i + 1));
            } else {
                ecl_gosub((u16)(i + 1));
            }
            done = 1;
        } else {
            ++i;
        }
    }
}

/* Tipo dell'oggetto casuale del tesoro (le tabelle di H012+$0BEA). */
static u16 random_treasure_type(void)
{
    u16 r;                              /* -$72(a5) */
    u16 r2;                             /* -$74(a5) */
    u16 cat;                            /* -$88(a5) */
    u16 sub;                            /* -$86(a5) */
    u16 t = 0;                          /* -$78(a5) */

    r = roll_dice(1, 0x64);
    if (r < 0x15) cat = 0;
    else if (r < 0x42) cat = 1;
    else if (r < 0x47) cat = 2;
    else if (r < 0x51) cat = 3;
    else if (r < 0x56) cat = 4;
    else if (r < 0x60) cat = 5;
    else cat = 6;
    switch (cat) {
    case 0:
        r2 = roll_dice(1, 0x64);
        sub = (u16)(r2 < 0x0B ? 0 : (r2 < 0x1A ? 1 : 2));
        switch (sub) {
        case 0:
            r2 = roll_dice(1, 0x0A);
            if (r2 <= 2) t = 6;
            else if (r2 <= 6) t = 8;
            else if (r2 <= 8) t = 0x46;
            else if (r2 == 9) t = 0x0F;
            else if (r2 == 0x0A) t = 0x1D;
            break;
        case 1:
            r2 = roll_dice(1, 0x14);
            if (r2 >= 1 && r2 <= 3) t = 5;
            else if (r2 <= 5) t = 7;
            else if (r2 <= 8) t = 0x18;
            else if (r2 <= 0x0A) t = 0x16;
            else if (r2 <= 0x0C) t = 0x19;
            else if (r2 <= 0x0E) t = 0x17;
            else if (r2 <= 0x10) t = 0x1C;
            else if (r2 <= 0x12) t = 0x1D;
            else if (r2 <= 0x14) t = 0x1E;
            break;
        default:
            r2 = roll_dice(1, 4);
            if (r2 < 4) {
                r2 = roll_dice(1, 0x14);
                if (r2 >= 1 && r2 <= 8) t = 0x12;
                else if (r2 <= 0x0D) t = 0x11;
                else if (r2 == 0x0E) t = 0x0D;
                else if (r2 == 0x0F) t = 0x10;
                else if (r2 <= 0x12) t = 0x13;
                else if (r2 <= 0x14) t = 0x14;
            } else {
                r2 = roll_dice(1, 8);
                if (r2 == 1) t = 1;
                else if (r2 <= 3) t = 4;
                else if (r2 <= 5) t = 8;
                else if (r2 == 6) t = 0x0A;
                else if (r2 == 7) t = 0x0E;
                else if (r2 == 8) t = 0x47;
            }
            break;
        }
        break;
    case 1: t = 0x27; break;
    case 2: t = 0x28; break;
    case 3: t = 0x25; break;
    case 4: t = 0x3B; break;
    case 5:
        r2 = roll_dice(1, 0x14);
        if (r2 >= 1 && r2 <= 3) t = 0x1F;
        else if (r2 <= 0x0B) t = 0x23;
        else if (r2 <= 0x10) t = 0x24;
        else if (r2 == 0x11) t = 0x20;
        else if (r2 == 0x12) t = 0x21;
        else if (r2 <= 0x14) t = 0x22;
        break;
    default:
        r2 = roll_dice(1, 6);
        if (r2 >= 1 && r2 <= 2) t = 0x32;
        else if (r2 <= 4) t = 0x30;
        else if (r2 == 5) t = 0x34;
        else if (r2 == 6) t = 0x35;
        break;
    }
    return t;
}

/* Mette in testa alla lista del tesoro ($2A3A) una copia di it. */
static void push_treasure(const CokItem *it)
{
    CokItem *old = g_treasure_items;

    g_treasure_items = (CokItem *)exec_alloc_mem(sizeof(CokItem),
                                                 COK_MEMF_CLEAR);
    memcpy(g_treasure_items->b, it->b, 0x48);
    g_treasure_items->next = old;
}

/*
 * PORT H012+$0BEA (comando $27, TREASURE): monete ($2A1E, 7 long) e
 * oggetti: con k < $80 tutti quelli del blocco k di ITEMn.DAX (record di
 * $3F byte), con $80+n n oggetti casuali (H067+$1292); i nomi si
 * costruiscono per il personaggio corrente.
 */
void ecl_treasure(void)
{
    u16 i;                              /* -$2(a5) */
    u16 k;                              /* -$4(a5) */
    u16 j;                              /* -$6(a5) */
    u16 pos;                            /* -$7A(a5) */
    u16 size = 0;                       /* -$7C(a5) */
    u8 *buf = NULL;                     /* -$82(a5) */
    char num[2];                        /* -$7E(a5) */
    CokItem it;                         /* -$66(a5) */
    CokItem *p;                         /* -$6E(a5) */
    u8 len;                             /* -$83(a5) */

    read_operands(8);
    for (i = 0; i <= 6; ++i) {
        H005_SET_L(0x2A1E + i * 4, (u32)eval_operand((u16)(i + 1)));
    }
    k = eval_operand(8);
    if (k < 0x80) {
        format_number(1, num, (s32)H005_B(0x246E), 0, 0x0A, 1, '0');
        strcpy(TEXT64, "ITEM");
        h026_append(0x50, TEXT64, 1, num);
        dax_load_block(0x50, TEXT64, 4, ".DAX", k, &size, &buf);
        if (size == 0) {
            show_message_wait(0x0F, 0, 0x18, "Unable to find item file");
            quit_game();
        }
        pos = 0;
        do {
            memset(&it, 0, sizeof it);
            len = buf[pos];
            exec_copy_mem(buf + pos + 1, it.b, 0x28);
            it.b[len] = 0;
            it.b[0x2A] = buf[pos + 0x29];
            it.next = NULL;
            it.b[0x30] = buf[pos + 0x2E];
            for (j = 1; j <= 3; ++j) {
                it.b[0x32 + j - 1] = buf[pos + 0x2E + j];
            }
            COK_PUT16(&it.b[0x36], (u16)h031_signed_byte(buf[pos + 0x32]));
            COK_PUT16(&it.b[0x38], (u16)h031_signed_byte(buf[pos + 0x33]));
            it.b[0x3A] = buf[pos + 0x34];
            it.b[0x3B] = buf[pos + 0x35];
            it.b[0x3C] = buf[pos + 0x36];
            exec_copy_mem(buf + pos + 0x37, &it.b[0x3E], 2);
            h031_swap_word(&it.b[0x3E]);
            it.b[0x40] = buf[pos + 0x39];
            exec_copy_mem(buf + pos + 0x3A, &it.b[0x42], 2);
            h031_swap_word(&it.b[0x42]);
            for (j = 1; j <= 3; ++j) {
                it.b[0x44 + j - 1] = buf[pos + 0x3B + j];
            }
            pos = (u16)(pos + 0x3F);
            push_treasure(&it);
        } while (pos < (u16)(size - 0x100));
        exec_free_mem(buf, size);
    } else if (k != 0xFF) {
        k = (u16)(k - 0x80);
        for (j = 1; j <= k; ++j) {
            memset(&it, 0, sizeof it);
            random_item(random_treasure_type(), &it);
            push_treasure(&it);
        }
        for (p = g_treasure_items; p != NULL; p = p->next) {
            build_item_name(g_current_char, p, 0, 0, 0, 0);
        }
    }
}

/*
 * PORT H012+$15AE (comando $29, ENCOUNTER): incontro alla distanza
 * $3E00+$580 con COMBAT/WAIT/FLEE/ADVANCE (o PARLAY da vicino o
 * all'aperto); per ogni scelta l'azione dell'operando 5..9 decide il
 * risultato (variabile dell'operando 4: 0 i mostri fuggono, 1
 * combattimento, 2 fuga, 3 parlare) o un avvicinamento e un nuovo giro.
 * I testi 1..3 valgono per le distanze 0..2.
 */
void ecl_encounter(void)
{
    u16 act[5];                         /* -$C(a5) */
    char texts[3][0x100];               /* -$30C(a5) */
    char text[0x100];                   /* -$40C(a5) */
    char title[2];                      /* -$446(a5) */
    char opts[0x29];                    /* -$444(a5) */
    u16 near_speed;                     /* -$40E(a5) */
    u16 flee_speed;                     /* -$410(a5) */
    u16 maxv = 0;                       /* -$414(a5) */
    u16 minv = 0;                       /* -$416(a5) */
    u16 dst;                            /* -$44C(a5) */
    u16 k;                              /* -$44A(a5) */
    u16 i;                              /* -$412(a5) */
    u16 choice;                         /* -$2(a5) */
    u16 a;                              /* -$448(a5) */
    u8 again;                           /* -$417(a5) */
    u8 clear;                           /* -$418(a5) */
    u8 animate;                         /* -$419(a5) */

    H005_B(0x24B4) = 1;
    H005_B(0x24B9) = 0;
    H005_B(0x24CE) = 1;
    party_speed_range(&maxv, &minv);
    title[0] = '\0';
    title[1] = '\0';
    text[0] = '\0';
    read_operands(0x0E);
    H005_B(0x2491) = (u8)eval_operand(1);
    COK_PUT16(g_state_b + 0x580, eval_operand(2));
    H005_B(0x2490) = (u8)eval_operand(3);
    dst = ADDR(4);
    for (i = 0; i <= 4; ++i) {
        act[i] = eval_operand((u16)(i + 5));
    }
    for (i = 1; i <= 3; ++i) {
        memcpy(texts[i - 1], ecl_string(i), 0x100);
    }
    near_speed = eval_operand(0x0D);
    flee_speed = eval_operand(0x0E);
    COK_PUT16(g_state_b + 0x582,
              free_steps((s16)H005_W(0x281C), (s16)H005_W(0x281E),
                         H005_B(0x2820)));
    if (COK_GET16(g_state_b + 0x580) < COK_GET16(g_state_b + 0x582)) {
        COK_PUT16(g_state_b + 0x582, COK_GET16(g_state_b + 0x580));
    }
    show_event_picture(H005_B(0x2491), H005_B(0x2490),
                       (u8)COK_GET16(g_state_b + 0x582), &H005_B(0x2378));
    do {
        animate = (u8)(H005_B(0x24BD) && H005_B(0x24BC) &&
                       COK_GET16(g_state_a + 0x1CC) && H005_B(0x2486) != 9);
        clear = (u8)(COK_GET16(g_state_a + 0x1CC) != 0);
        again = 0;
        H005_SET_W(0x334E, 1);
        H005_SET_W(0x334C, 0x11);
        switch (COK_GET16(g_state_b + 0x582)) {
        case 0:
            k = 1;
            do {
                memcpy(text, texts[k - 1], 0x100);
                ++k;
            } while (text[0] == '\0' && k <= 3);
            break;
        case 1:
            k = 2;
            do {
                memcpy(text, texts[k - 1], 0x100);
                ++k;
                if (k > 3) k = 1;
            } while (text[0] == '\0' && k != 2);
            break;
        case 2:
            k = 3;
            do {
                memcpy(text, texts[k - 1], 0x100);
                ++k;
                if (k > 3) k = 1;
            } while (text[0] == '\0' && k != 3);
            break;
        default:
            break;
        }
        if (text[0] == '\0') {
            clear = 0;
        }
        word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, clear, 0xFF, text);
        if (COK_GET16(g_state_b + 0x582) == 0 ||
            COK_GET16(g_state_a + 0x1CC) == 0) {
            strcpy(opts, "~COMBAT ~WAIT ~FLEE ~PARLAY");
        } else {
            strcpy(opts, "~COMBAT ~WAIT ~FLEE ~ADVANCE");
        }
        choice = ecl_menu(1, title, 0x28, opts, 0x0D, 0x0A, 0x0F, 0, animate);
        if ((COK_GET16(g_state_b + 0x582) == 0 ||
             COK_GET16(g_state_a + 0x1CC) == 0) && choice == 3) {
            choice = 4;
        }
        a = (choice <= 4) ? act[choice] : 0;
        switch (a) {
        case 0:
            if (choice != 2) {
                write_var(dst, 1);
            } else if (minv >= near_speed) {
                write_var(dst, 2);
            } else {
                write_var(dst, 1);
            }
            break;
        case 1:
            switch (choice) {
            case 0: write_var(dst, 1); break;
            case 1:
                again = 1;
                word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 1, 0x10,
                               "Both sides wait.");
                break;
            case 2: write_var(dst, 2); break;
            case 3:
                if (COK_GET16(g_state_b + 0x582) != 0) {
                    COK_PUT16(g_state_b + 0x582,
                              COK_GET16(g_state_b + 0x582) - 1);
                    show_event_picture(H005_B(0x2491), H005_B(0x2490),
                                       (u8)COK_GET16(g_state_b + 0x582),
                                       &H005_B(0x2378));
                } else {
                    word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 1, 0x10,
                                   "Both sides wait.");
                    again = 1;
                }
                break;
            case 4:
                if (COK_GET16(g_state_b + 0x582) == 0) {
                    write_var(dst, 3);
                } else {
                    COK_PUT16(g_state_b + 0x582,
                              COK_GET16(g_state_b + 0x582) - 1);
                    show_event_picture(H005_B(0x2491), H005_B(0x2490),
                                       (u8)COK_GET16(g_state_b + 0x582),
                                       &H005_B(0x2378));
                    again = 1;
                }
                break;
            default: break;
            }
            break;
        case 2:
            if (choice == 0 && !(flee_speed > maxv)) {
                write_var(dst, 1);
            } else if (choice <= 4) {
                write_var(dst, 0);
                H005_SET_W(0x334E, 1);
                H005_SET_W(0x334C, 0x11);
                word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 1, 0x12,
                               "The monsters flee.");
            }
            break;
        case 3:
            switch (choice) {
            case 0: write_var(dst, 1); break;
            case 1:
            case 3:
                if (COK_GET16(g_state_b + 0x582) != 0) {
                    COK_PUT16(g_state_b + 0x582,
                              COK_GET16(g_state_b + 0x582) - 1);
                    show_event_picture(H005_B(0x2491), H005_B(0x2490),
                                       (u8)COK_GET16(g_state_b + 0x582),
                                       &H005_B(0x2378));
                } else {
                    word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 1, 0x10,
                                   "Both sides wait.");
                }
                again = 1;
                break;
            case 2: write_var(dst, 2); break;
            case 4:
                if (COK_GET16(g_state_b + 0x582) == 0) {
                    write_var(dst, 3);
                } else {
                    COK_PUT16(g_state_b + 0x582,
                              COK_GET16(g_state_b + 0x582) - 1);
                    show_event_picture(H005_B(0x2491), H005_B(0x2490),
                                       (u8)COK_GET16(g_state_b + 0x582),
                                       &H005_B(0x2378));
                    again = 1;
                }
                break;
            default: break;
            }
            break;
        case 4:
            switch (choice) {
            case 0: write_var(dst, 1); break;
            case 1:
            case 3:
            case 4:
                if (COK_GET16(g_state_b + 0x582) == 0) {
                    write_var(dst, 3);
                } else {
                    COK_PUT16(g_state_b + 0x582,
                              COK_GET16(g_state_b + 0x582) - 1);
                    show_event_picture(H005_B(0x2491), H005_B(0x2490),
                                       (u8)COK_GET16(g_state_b + 0x582),
                                       &H005_B(0x2378));
                    again = 1;
                }
                break;
            case 2: write_var(dst, 2); break;
            default: break;
            }
            break;
        default:
            break;
        }
    } while (again);
    clear_message_line();
    H005_B(0x24CE) = 0;
    H005_B(0x24B4) = 0;
}

/*
 * PORT H012+$1DDE (comando $2C, PARLAY): HAUGHTY/SLY/NICE/MEEK/ABUSIVE;
 * il valore dell'operando scelto va nella variabile del sesto.  Senza
 * scelta valida l'originale legge fuori dai cinque valori: qui 0.
 */
void ecl_parlay(void)
{
    u16 v[5];                           /* -$10(a5) */
    u16 i;                              /* -$6(a5) */
    u16 k;                              /* -$2(a5) */

    read_operands(6);
    for (i = 0; i <= 4; ++i) {
        v[i] = eval_operand((u16)(i + 1));
    }
    k = ecl_menu(0, "", 0x22, "~HAUGHTY ~SLY ~NICE ~MEEK ~ABUSIVE", 0x0D,
                 0x0A, 0x0F, 0, 0);
    write_var(ADDR(6), (k <= 4) ? v[k] : 0);
}

/* PORT H012+$1E90 (comando $32): qualcuno porta un oggetto del tipo t (+$30)? */
void ecl_find_item(void)
{
    u8 found = 0;                       /* -$D(a5) */
    u16 t;                              /* -$2(a5) */
    Character *p;                       /* -$8(a5) */
    CokItem *it;                        /* -$C(a5) */

    read_operands(1);
    t = eval_operand(1);
    h029_fill_bytes(5, &H005_B(0x237E), 6, 0);
    H005_B(0x237F) = 1;
    for (p = g_party_head; p != NULL && !found; p = p->next) {
        for (it = p->items; it != NULL && !found; it = it->next) {
            if (it->b[0x30] == t) {
                H005_B(0x237E) = 1;
                H005_B(0x237F) = 0;
                found = 1;
            }
        }
    }
}

/* PORT H012+$1F4C (comando $3A, DELAY): pausa. */
void ecl_delay(void)
{
    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1);
    message_delay();
}

/*
 * PORT H012+$14C8 (comando $28, ROB): il personaggio corrente (primo
 * operando 0) o tutto il party perde il secondo operando per cento di
 * monete, gemme e gioielli (H061+$3C4C, con (100 - p) / 100 in FFP:
 * SPFlt e SPDiv) e ogni oggetto ha il terzo operando per cento di
 * andare distrutto (H061+$3DBE).
 */
void ecl_rob(void)
{
    u16 who;                            /* -$2(a5) */
    u16 percent;                        /* -$4(a5) */
    u16 chance;                         /* -$6(a5) */
    Character *p;                       /* -$A(a5) */
    CokReal keep;                       /* -$12(a5) */

    read_operands(3);
    who = eval_operand(1);
    percent = eval_operand(2);
    keep = h015_spdiv(h015_spflt((s32)(u16)(0x64 - percent)),
                      h015_spflt(0x64));
    chance = eval_operand(3);
    if (who == 0) {
        scale_money(keep, g_current_char);
        destroy_items(chance, g_current_char);
    } else {
        for (p = g_party_head; p != NULL; p = p->next) {
            scale_money(keep, p);
            destroy_items(chance, p);
        }
    }
}

/*
 * PORT H012+$1F68 (comando $2E, DAMAGE): danno nd(s)+b a uno o a tutti
 * (bit 6), con tiro salvezza (bit 7: tipo dal 5o operando, danno pieno
 * comunque col bit 4), o a flags bersagli casuali con un tiro per
 * colpire (H062+$126C).  Se cadono tutti "The entire party is killed!".
 */
void ecl_damage(void)
{
    Character *save;                    /* -$22(a5) */
    Character *p;                       /* -$1A(a5) */
    u8 group = 0;                       /* -$24(a5) */
    u8 full;                            /* -$25(a5) */
    u16 flags;                          /* -$2(a5) */
    u16 n;                              /* -$4(a5) */
    u16 sides;                          /* -$6(a5) */
    u16 bonus;                          /* -$E(a5) */
    u16 save_t;                         /* -$C(a5) */
    u16 dmg;                            /* -$16(a5) */
    u16 victim = 0;                     /* -$10(a5) */
    u16 kind;                           /* -$A(a5) */
    u16 st;                             /* -$12(a5) */
    u16 i;                              /* -$8(a5) */
    u16 j;                              /* -$14(a5) */

    save = g_current_char;
    p = g_party_head;
    read_operands(5);
    flags = eval_operand(1);
    n = eval_operand(2);
    sides = eval_operand(3);
    bonus = eval_operand(4);
    save_t = eval_operand(5);
    dmg = (u16)(roll_dice(n, sides) + bonus);
    full = mask_byte((u8)flags, 0x10);
    if (mask_byte((u8)flags, 0x40)) {
        group = 1;
    } else {
        victim = roll_dice(1, COK_GET16(g_state_b + 0x67C));
    }
    if (mask_byte((u8)flags, 0x80)) {
        kind = mask_byte((u8)flags, 0x1F);
        st = mask_byte((u8)save_t, 7);
        if (group) {
            for (; p != NULL; p = p->next) {
                if (mask_byte((u8)flags, 0x20)) {
                    ecl_damage_message(p, dmg);
                } else if (!saving_throw_roll(p, (u8)st, (s16)kind)) {
                    ecl_damage_message(p, dmg);
                } else if (full) {
                    ecl_damage_message(p, dmg);
                }
            }
        } else if (mask_byte((u8)save_t, 0x80)) {
            if (st == 0 ||
                !saving_throw_roll(g_current_char, (u8)(st - 1), (s16)kind)) {
                ecl_damage_message(g_current_char, dmg);
            } else if (full) {
                ecl_damage_message(g_current_char, dmg);
            }
        } else {
            for (i = 2; i <= victim; ++i) {
                p = p->next;
            }
            if (!saving_throw_roll(p, (u8)st, (s16)kind)) {
                ecl_damage_message(p, dmg);
            } else if (full) {
                ecl_damage_message(p, dmg);
            }
        }
    } else {
        for (i = 1; i <= flags; ++i) {
            p = g_party_head;
            victim = roll_dice(1, COK_GET16(g_state_b + 0x67C));
            for (j = 1; j < victim; ++j) {
                p = p->next;
            }
            if (ecl_attack_hits(p, save_t)) {
                ecl_damage_message(p, dmg);
            }
            dmg = (u16)(roll_dice(n, sides) + bonus);
        }
    }
    H005_B(0x24D0) = 1;
    for (p = g_party_head; p != NULL; p = p->next) {
        if (p->b[0x198]) {
            H005_B(0x24D0) = 0;
        }
    }
    if (H005_B(0x24D0)) {
        draw_screen_frame(1);
        H005_SET_W(0x334E, 2);
        H005_SET_W(0x334C, 2);
        word_wrap_text(1, 1, 0x26, 0x16, 0x0A, 0, 1, 0x1B,
                       "The entire party is killed!");
        dos_delay(0x96);
    }
    g_current_char = save;
    show_message_wait(0x0F, 0, 0x22, "press <enter>/<return> to continue");
}

/* PORT H012+$2358 (comando $31): chiude le immagini dell'evento. */
void ecl_clear_picture(void)
{
    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1);
    if (H005_B(0x24BA)) {
        H005_B(0x24E1) = 1;
        refresh_view();
        H005_B(0x24BA) = 0;
        H005_B(0x24BD) = 0;
    }
}

/* PORT H012+$2392 (comando $34): avanza il tempo di n unita' u. */
void ecl_advance_time(void)
{
    u16 n;                              /* -$2(a5) */
    u8 u;                               /* -$3(a5) */

    read_operands(2);
    n = eval_operand(1);
    u = (u8)eval_operand(2);
    advance_time(n, u);
}

/* PORT H012+$23D6 (comando $33): a capo nella finestra di testo. */
void ecl_new_line(void)
{
    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1);
    if (H005_B(0x24BE)) {
        H005_SET_W(0x334E, 1);
        H005_SET_W(0x334C, H005_W(0x334C) + 1);
        H005_B(0x24BE) = 0;
    } else {
        H005_SET_W(0x334E, 1);
        H005_SET_W(0x334C, H005_W(0x334C) + 1);
    }
}

/* PORT H012+$241C (comando $3D): ridisegna la schermata dell'esplorazione. */
void ecl_redraw_screen(void)
{
    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1);
    H005_B(0x24AE) = 0;
    draw_explore_frame();
    draw_party(g_current_char);
    draw_status_line();
    if (!H005_B(0x24D7)) {
        show_picture(3, 3, 1, g_pic_rec_27c2);
    }
    draw_status_line();
    H005_B(0x24B2) = 0;
    H005_B(0x24BF) = 1;
}

/* PORT H012+$2486 (comando $39): sceglie il personaggio corrente col testo dato. */
void ecl_who(void)
{
    u8 save;                            /* -$53(a5) */
    char prompt[0x51];                  /* -$52(a5) */

    save = H005_B(0x24B0);
    H005_B(0x24B0) = 0;
    H005_B(0x24B3) = 0;
    read_operands(1);
    clear_text_cells(1, 0x11, 0x26, 0x16);
    h026_copy(0x50, prompt, 0xFF, ecl_string(1));
    choose_party_member(0x50, prompt, 0, 0, &g_current_char);
    H005_B(0x24B0) = save;
}

/* PORT H012+$2502 (comando $36): aggiunge un PNG (H066+$276E) con l'IA data. */
void ecl_add_npc(void)
{
    u16 v;                              /* -$C(a5) */

    read_operands(2);
    add_npc(eval_operand(1));
    v = (u16)(eval_operand(2) >> 1);
    v = or_byte((u8)v, 0x80);
    g_current_char->b[0xEC] = (u8)v;
    recompute_stats(g_current_char);
    draw_party(g_current_char);
}

/*
 * PORT H012+$2596 (comando $3B): cerca l'incantesimo s fra quelli
 * memorizzati (+$1F..) dei personaggi: posizione ($FF se no) e numero
 * del personaggio nelle variabili; poi la traccia di debug H056+$0886.
 */
void ecl_find_spell(void)
{
    u8 found = 0;                       /* -$B(a5) */
    u8 stop = 0;                        /* -$C(a5) */
    u16 s;                              /* -$2(a5) */
    u16 dst1;                           /* -$E(a5) */
    u16 dst2;                           /* -$10(a5) */
    u16 k = 1;                          /* -$4(a5) */
    u16 idx = 0;                        /* -$6(a5) */
    Character *p;                       /* -$A(a5) */

    read_operands(3);
    s = eval_operand(1);
    dst1 = ADDR(2);
    dst2 = ADDR(3);
    p = g_party_head;
    while (p != NULL && !found) {
        k = 1;
        do {
            if (p->b[0x1E + k] == s) {
                found = 1;
            } else if (k <= 0x39) {
                ++k;
            } else {
                stop = 1;
            }
        } while (!stop && !found);
        stop = 0;
        p = p->next;
        if (p != NULL && !found) {
            ++idx;
        }
    }
    if (k > 0x39) {
        k = 0xFF;
    }
    write_var(dst1, k);
    write_var(dst2, idx);
    debug_trace(5, "spell", (u8)k, (u8)idx, (u8)s);
}

/*
 * PORT H012+$2AAE (comando $3C): nessun effetto.  L'originale non avanza
 * il PC (il comando si ripeterebbe all'infinito); qui lo stesso.
 */
void ecl_nop_3c(void)
{
}

/* PORT H012+$2ABE (comando $3E): il personaggio corrente lascia il party. */
void ecl_remove_character(void)
{
    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1);
    remove_from_party(0, 1);
    g_h064_saved_char = g_current_char;
    draw_party(g_current_char);
}

/* PORT H012+$2AF6 (comando $3F): il personaggio corrente ha l'effetto t? */
void ecl_has_effect(void)
{
    CokEffect *e;                       /* -$4(a5) */

    h029_fill_bytes(5, &H005_B(0x237E), 6, 0);
    read_operands(1);
    if (find_effect(g_current_char, eval_operand(1), &e)) {
        H005_B(0x237E) = 1;
    } else {
        H005_B(0x237F) = 1;
    }
}

/* PORT H012+$2B64 (comando $40): toglie a tutti gli oggetti del tipo t. */
void ecl_remove_items(void)
{
    u16 t;                              /* -$2(a5) */
    Character *save;                    /* -$A(a5) */
    Character *p;                       /* -$6(a5) */
    CokItem *it;                        /* -$E(a5) */
    CokItem *next;                      /* -$12(a5) */

    read_operands(1);
    t = eval_operand(1);
    save = g_current_char;
    for (p = g_party_head; p != NULL; p = p->next) {
        it = p->items;
        while (it != NULL) {
            next = it->next;
            if (it->b[0x30] == t) {
                g_current_char = p;
                if (it->b[0x3A]) {
                    ready_item(it);
                }
                delete_item(p, it);
            }
            it = next;
        }
        recompute_stats(p);
    }
    g_current_char = save;
}

/*
 * PORT H012+$2C28 (comando $41, EXPERIENCE): punti esperienza al party (o
 * al corrente), divisi per le classi di ciascuno (+$FE..+$105 non nulli);
 * solo a chi e' in piedi.  Senza classi l'originale divide per 0
 * (eccezione del 68000): qui nessun punto.
 */
static void give_xp(Character *p, u16 xp)
{
    u16 classes = 0;                    /* -$C(a5) */
    u8 i;                               /* -$9(a5) */
    u16 share;                          /* -$E(a5) */

    for (i = 0; i <= 7; ++i) {
        if (p->b[0xFE + i] > 0) {
            ++classes;
        }
    }
    if (classes == 0) {
        return;
    }
    share = (u16)(xp / classes);
    if (p->b[0x198]) {
        COK_PUT32(&p->b[0x11E], COK_GET32(&p->b[0x11E]) + share);
    }
}

void ecl_experience(void)
{
    u16 xp;                             /* -$2(a5) */
    u8 all;                             /* -$3(a5) */
    Character *p;                       /* -$8(a5) */

    read_operands(2);
    xp = eval_operand(2);
    all = (u8)eval_operand(1);
    H005_SET_W(0x334C, 0x11);
    H005_SET_W(0x334E, 1);
    if (all) {
        word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 1, 0x2B,
                       "Congratulations the party gains experience!");
        message_delay();
        for (p = g_party_head; p != NULL; p = p->next) {
            give_xp(p, xp);
        }
    } else {
        p = g_current_char;
        strcpy(TEXT64, "Congratulations ");
        h026_append(0x50, TEXT64, 0x0F, (const char *)p->b);
        h026_append(0x50, TEXT64, 0x12, " gains experience!");
        word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 1, 0x50, TEXT64);
        message_delay();
        give_xp(p, xp);
    }
}

/*
 * PORT H012+$26D6 (comando $2D): azioni speciali per codice: $2E10
 * ridisegna la vista se cambiata, $6803 anima l'insieme $27BC, $B203
 * suono, $C018 muro davanti, $C01E un passo avanti.
 */
void ecl_special(void)
{
    u16 w;                              /* -$2(a5) */
    u8 *set = &g_h005[0x27BC];

    read_operands(1);
    w = make_word(operand_lo(1), operand_hi(1));
    if (w == 0x2E10) w = 0;
    else if (w == 0x6803) w = 1;
    else if (w == 0xB203) w = 2;
    else if (w == 0xC018) w = 3;
    else if (w == 0xC01E) w = 4;
    switch (w) {
    case 0:
        H005_B(0x2822) = map_flags((s16)H005_W(0x281C), (s16)H005_W(0x281E));
        if (H005_B(0x24BD) || H005_B(0x24BA) || H005_B(0x24B8) ||
            H005_B(0x24B7) || H005_B(0x24B5)) {
            h029_fill_bytes(1, &H005_B(0x2378), 2, 0);
            H005_B(0x24E1) = 1;
            refresh_view();
            draw_status_line();
            H005_B(0x24B5) = 0;
            H005_B(0x24B8) = 0;
            H005_B(0x24B7) = 0;
            H005_B(0x24BD) = 0;
            H005_B(0x24BA) = 0;
            H005_B(0x2821) = (u8)map_wall((s16)H005_W(0x281C),
                                          (s16)H005_W(0x281E),
                                          H005_B(0x2820));
        }
        break;
    case 1:
        show_picture(3, 3, 1, sequence_frame(COK_GET16(set + 2)));
        COK_PUT16(set + 2, COK_GET16(set + 2) + 1);
        if (COK_GET16(set + 2) > COK_GET16(set)) {
            COK_PUT16(set + 2, 1);
        }
        message_delay();
        break;
    case 2:
        switch (H005_W(0x2376)) {
        case 0x0A: h043_190e(0x13); break;
        default: h043_190e(0x11); break;
        }
        break;
    case 3:
        if (COK_GET16(g_state_a + 0x1CC) == 0) {
            H005_B(0x2821) = (u8)map_wall((s16)H005_W(0x281C),
                                          (s16)H005_W(0x281E),
                                          H005_B(0x2820));
        }
        break;
    case 4:
        step_forward();
        break;
    default:
        break;
    }
}

/*
 * PORT H012+$2922: riposo/accampamento dell'area: esegue l'ingresso
 * $3DF0, poi H057+$2F3A; se richiesto ridisegna ed esegue $3DEE; infine
 * ridisegna la vista (e all'aperto l'immagine).
 */
void ecl_camp_entry(void)
{
    u8 r = 0;                           /* -$1(a5) */

    run_ecl(H005_W(0x3DF0));
    encamp(&r);
    if (r) {
        redraw_game_screen();
        run_ecl(H005_W(0x3DEE));
    }
    H005_B(0x24E1) = 1;
    if (COK_GET16(g_state_a + 0x270) == 0) {
        refresh_view();
    }
    H005_B(0x24A3) = 0;
    if (COK_GET16(g_state_a + 0x1CC) == 0 && COK_GET16(g_state_a + 0x270) == 0) {
        h069_draw_marker();
    }
}

/*
 * PORT H012+$29A6 (comando $38): 0 il menu del party (H013+$4BFC), 9 il
 * campo ($2922) e, fuori dalla citta', EXIT.
 */
void ecl_party_menu(void)
{
    u8 save;                            /* -$A(a5) */
    u16 pc;                             /* -$4(a5) */
    u16 v;                              /* -$2(a5) */

    save = H005_B(0x24B0);
    H005_B(0x24B0) = 0;
    if (H064_B(9)) {
        g_current_char = g_h064_saved_char;
        H064_B(9) = 0;
    }
    pc = H005_W(0x3DEA);
    read_operands(1);
    v = eval_operand(1);
    switch (v) {
    case 0:
        H005_B(0x249C) = 0;
        main_menu();
        H005_B(0x249C) = 1;
        if (H005_B(0x2486) != 9 && COK_GET16(g_state_a + 0x270) == 0 &&
            COK_GET16(g_state_a + 0x1CC) == 0) {
            redraw_game_screen();
        }
        break;
    case 9:
        pc = H005_W(0x3DEA);
        ecl_camp_entry();
        H005_SET_W(0x3DEA, pc);
        if (COK_GET16(g_state_a + 0x270) == 0) {
            ecl_exit();
        }
        break;
    default:
        break;
    }
    (void)pc;
    H005_B(0x24B0) = save;
}

/*
 * PORT H012+$3020: ingresso in una nuova area (dopo NEWECL o un'uscita):
 * libera le immagini, esegue gli ingressi $3DEC, $3DF4 e $3DF2 del
 * programma ECL e ridisegna, ripetendo finche' un comando chiede
 * un'altra area (H064+$A).
 */
static void enter_area(void)
{
    do {
        release_picture_set();
        H005_B(0x279C) = 0;             /* stringa vuota di H012+$16F */
        H005_B(0x2485) = 0xFF;
        H064_B(0x0A) = 0;
        H005_B(0x2822) = map_flags((s16)H005_W(0x281C), (s16)H005_W(0x281E));
        COK_PUT16(g_state_b + 0x5AA, 0);
        g_h064_saved_char = g_current_char;
        run_ecl(H005_W(0x3DEC));
        if (!H064_B(0x0A)) {
            COK_PUT16(g_state_a + 0x1E4, H005_B(0x2498));
        }
        if (!H064_B(0x0A)) {
            if ((H005_B(0x3DE2) == 4 && H005_B(0x3DE3) == 4) ||
                (H005_B(0x3DE2) != 4 && H064_B(8))) {
                refresh_view();
            }
            H064_B(0x0A) = 0;
            run_ecl(H005_W(0x3DF4));
            if (!H064_B(0x0A)) {
                run_ecl(H005_W(0x3DF2));
                if (!H064_B(0x0A)) {
                    g_current_char = g_h064_saved_char;
                    draw_party(g_current_char);
                }
            }
        }
    } while (H064_B(0x0A));
    H005_B(0x3DE2) = H005_B(0x3DE3);
}

/* Maiuscola come nell'originale (a..z con andi #$5F). */
static u8 key_upper(u8 k)
{
    if (k >= 'a' && k <= 'z') {
        k = (u8)(k & 0x5F);
    }
    return k;
}

/* Toglie dal party tutti i personaggi (H012+$3248 e $34CE). */
static void dismiss_party(u8 keep)
{
    Character *p;                       /* -$6(a5) */

    p = g_party_head;
    while (p != NULL) {
        g_current_char = p;
        p = p->next;
        remove_from_party(keep, 1);
    }
}

/*
 * PORT H012+$3150: ciclo dell'esplorazione.  Carica il programma ECL
 * dell'area ($3E04+$1E4, o $24 all'inizio, $39 nella dimostrazione), ne
 * esegue l'ingresso e poi ripete: menu dei comandi (H068+$0C0E) con
 * Encamp, ricerca e sguardo, ed eseguito il passo (H068+$122E) gli
 * ingressi $3DF2/$3DF4; finche' il party non e' perduto ($24D0).
 */
void explore_loop(void)
{
    u8 key;                             /* -$1(a5) */

    g_h064_saved_char = g_current_char;
    H005_B(0x24E1) = 1;
    H005_B(0x24BB) = 0;
    H064_B(7) = 0;
    H064_B(6) = 0;
    H064_B(9) = 0;
    H064_B(8) = 0;
    H005_B(0x24B2) = 1;
    H005_B(0x3DE3) = 4;
    H064_B(0x0A) = 0;
    if (COK_GET16(g_state_a + 0x1E4) == 0) {
        H005_B(0x24B2) = 0;
        if (H005_B(0x24D7)) {
            H005_B(0x2498) = 0x39;
        } else {
            H005_B(0x2498) = 0x24;
            draw_party(g_current_char);
        }
    } else {
        H005_B(0x2498) = (u8)COK_GET16(g_state_a + 0x1E4);
    }
    if (COK_GET16(g_state_a + 0x1CC) == 0) {
        H005_B(0x3DE3) = 3;
    }
    load_ecl_program(H005_B(0x2498));
    ui_draw_text(0, 0, 0x0B, 0, 0x50, TEXT64);
    ecl_start_area();
    run_ecl(H005_W(0x3DEC));
    if (H005_B(0x24D7)) {
        dismiss_party(1);
        return;
    }
    if (!H064_B(0x0A)) {
        COK_PUT16(g_state_a + 0x1E4, H005_B(0x2498));
    } else {
        enter_area();
    }
    if (H005_B(0x3DE3) != 3 && H005_B(0x24D1)) {
        if (H005_B(0x24B2) == 1) {
            redraw_game_screen();
        }
        H005_B(0x24E1) = 1;
        refresh_view();
    }
    H005_B(0x24D1) = 0;
    H005_B(0x24B0) = 0;
    do {
        if (H005_W(0x3DE8) != H005_W(0x3DF4) && !H064_B(0x0A)) {
            key = explore_command_menu();
            g_h064_saved_char = g_current_char;
            if (!H064_B(0x0A)) {
                COK_PUT16(g_state_a + 0x1E4, H005_B(0x2498));
            }
            while ((COK_GET16(g_state_b + 0x594) > 1 ||
                    key_upper(key) == 'E') && !H005_B(0x24D0)) {
                if (key_upper(key) == 'E') {
                    ecl_camp_entry();
                } else {
                    H005_B(0x2497) = mask_byte((u8)COK_GET16(g_state_b + 0x594), 1);
                    COK_PUT16(g_state_b + 0x594, 1);
                    H005_B(0x24E1) = 1;
                    refresh_view();
                    run_ecl(H005_W(0x3DF2));
                    if (H064_B(0x0A)) {
                        enter_area();
                    }
                    COK_PUT16(g_state_b + 0x594, H005_B(0x2497));
                }
                if (!H005_B(0x24D0)) {
                    key = explore_command_menu();
                    g_h064_saved_char = g_current_char;
                }
            }
            if (!H005_B(0x24D0)) {
                run_ecl(H005_W(0x3DF4));
            }
        } else if (H064_B(0x0A)) {
            enter_area();
        } else if (!H005_B(0x24D0)) {
            COK_PUT16(g_state_a + 0x1E0, H005_W(0x281C));
            COK_PUT16(g_state_a + 0x1E2, H005_W(0x281E));
            explore_move_or_door();
            refresh_view();
            if (H005_W(0x281C) != COK_GET16(g_state_a + 0x1E0) ||
                H005_W(0x281E) != COK_GET16(g_state_a + 0x1E2)) {
                h043_190e(0x11);
            }
            H005_B(0x24BD) = 0;
            H005_B(0x24BC) = 1;
            run_ecl(H005_W(0x3DF2));
            if (H064_B(0x0A)) {
                enter_area();
            }
        }
    } while (!H005_B(0x24D0));
    H005_B(0x24D0) = 0;
    dismiss_party(0);
}
