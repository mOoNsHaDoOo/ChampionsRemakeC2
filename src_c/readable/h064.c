/* H064: gestori nativi dei comandi ECL. */
#include "h064.h"
#include "globals.h"
#include "unported.h"
#include "h042_seq.h"
#include "h060.h"
#include "h011.h"
#include "h069.h"
#include "h003_exec.h"
#include "h008.h"
#include "h023_shared.h"
#include "h026_string.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h035.h"
#include "h044_tiles.h"
#include "h045.h"
#include "h053.h"
#include "h061.h"
#include "h063.h"
#include "h073.h"
#include <string.h>

/*
 * Dati all'inizio del modulo (H064+$0000..$005D): +$0 personaggio
 * corrente salvato, +$6..+$B flag della VM ECL (+$B: fine del
 * programma), +$C testo.  g_h064_data[k] e' H064+k.
 */
Character *g_h064_saved_char;           /* H064+$0000 */
u8 g_h064_data[0x5E];

/* PORT H064+$00EE: link/unlk, nessun effetto. */
void h064_init(void)
{
}

/* Operandi: byte grezzi e indirizzo dell'operando i. */
#define OPD(i)  operand_desc(i)
#define ADDR(i) decode_address(operand_lo(i), operand_hi(i))

/*
 * PORT H064+$0156 (comando $00, EXIT): fine del programma: ripristina il
 * personaggio corrente salvato, ferma la VM (+$B), svuota la pila GOSUB
 * e riporta il testo in alto a sinistra della finestra.
 */
void ecl_exit(void)
{
    if (H005_B(0x24BB)) { /* $24BB: uso: azzerato a inizio area; con 1 EXIT ridisegna la cornice */
        draw_explore_frame();
    }
    if (H064_B(9)) { /* H064_data+$9: flag LOAD CHARACTER: ripristinare il personaggio salvato */
        g_current_char = g_h064_saved_char;
        H064_B(9) = 0; /* H064_data+$9: flag LOAD CHARACTER: ripristinare il personaggio salvato */
    }
    /* $2378: flag: sprite dell'evento gia' mostrato (flags[0], 2 byte con +$2379) */
    h029_fill_bytes(1, &H005_B(0x2378), 2, 0);
    H005_B(0x24BD) = 0; /* $24BD: 1 se l'immagine/ritratto dell'evento e' a schermo */
    H005_B(0x24BB) = 0; /* $24BB: uso: azzerato a inizio area; con 1 EXIT ridisegna la cornice */
    H064_B(0x0B) = 1; /* H064_data+$B: flag fine esecuzione ECL (EXIT o NEWECL) */
    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1); /* $3DEA: (word) PC logico del programma ECL (base $3500) */
    while (g_ecl_stack != NULL) {
        g_ecl_stack_prev = g_ecl_stack->next;
        exec_free_mem(g_ecl_stack, sizeof(CokEclFrame));
        g_ecl_stack = g_ecl_stack_prev;
    }
    H005_SET_W(0x334C, 0x11); /* $334C: (word) cursore del testo: riga */
    H005_SET_W(0x334E, 1); /* $334E: (word) cursore del testo: colonna */
    H005_B(0x24BF) = 0; /* $24BF: uso: 1 dopo il comando ECL $3D (ridisegno), 0 dopo EXIT */
}

/* PORT H064+$0202 (comando $01, GOTO). */
void ecl_goto(void)
{
    read_operands(1);
    H005_SET_W(0x3DEA, ADDR(1)); /* $3DEA: (word) PC logico del programma ECL (base $3500) */
}

/* PORT H064+$0234 (comando $02, GOSUB). */
void ecl_gosub_cmd(void)
{
    read_operands(1);
    ecl_gosub(1);
}

/* PORT H064+$0258 (comando $03, COMPARE): stringhe se una lo e', altrimenti valori. */
void ecl_compare(void)
{
    char a[0x51];                       /* -$58(a5) */
    char b[0x51];                       /* -$AA(a5) */

    read_operands(2);
    if (OPD(1) >= 0x80 || OPD(2) >= 0x80) {
        h026_copy(0x50, a, 0xFF, ecl_string(1));
        h026_copy(0x50, b, 0xFF, ecl_string(2));
        compare_strings(0x50, a, 0x50, b);
    } else {
        compare_words(eval_operand(1), eval_operand(2));
    }
}

/*
 * PORT H064+$0306 (comandi $04..$07: ADD, SUB, DIV, MUL): risultato nella
 * variabile del terzo operando; il resto della divisione in $3E00+$67E.
 * SUB fa secondo - primo, DIV primo / secondo.  Con divisore 0 il
 * 68000 genererebbe un'eccezione: qui risultato 0 e resto invariato.
 */
void ecl_arithmetic(void)
{
    u16 v[2];                           /* -$6(a5), -$4(a5) */
    u16 dst;                            /* -$2(a5) */
    u16 r = 0;                          /* -$A(a5) */
    u16 i;                              /* -$8(a5) */

    read_operands(3);
    for (i = 1; i <= 2; ++i) {
        v[i - 1] = eval_operand(i);
    }
    dst = ADDR(3);
    switch (H005_B(0x2493)) { /* $2493: codice del comando ECL in esecuzione */
    case 4:
        r = (u16)(v[0] + v[1]);
        break;
    case 5:
        r = (u16)(v[1] - v[0]);
        break;
    case 6:
        if (v[1] != 0) {
            r = (u16)(v[0] / v[1]);
            /* B+$67E: (word) resto della divisione dei comandi ECL ADD..MUL */
            COK_PUT16(g_state_b + 0x67E, (u16)(v[0] % v[1]));
        }
        break;
    case 7:
        r = (u16)((u32)v[0] * v[1]);
        break;
    default:
        break;
    }
    write_var(dst, r);
}

/* PORT H064+$03FC (comando $08, RANDOM): numero casuale da 0 a n (n < $FF). */
void ecl_random(void)
{
    u16 n;                              /* -$2(a5) */
    u16 dst;                            /* -$6(a5) */

    read_operands(2);
    n = eval_operand(1);
    if (n < 0xFF) {
        ++n;
    }
    dst = ADDR(2);
    write_var(dst, (u16)random_below(n));
}

/* PORT H064+$0468 (comando $09, SAVE): valore o stringa nella variabile. */
void ecl_save(void)
{
    u16 dst;                            /* -$4(a5) */

    read_operands(2);
    dst = ADDR(2);
    if (OPD(1) < 0x80) {
        write_var(dst, eval_operand(1));
    } else {
        write_string_var(dst, 0xFF, ecl_string(1));
    }
}

/*
 * PORT H064+$04DC (comando $0A, LOAD CHARACTER): il personaggio n del
 * party diventa il corrente ($24B3 se non c'e'); col bit 7, se richiesto
 * ($24C4, $24C3), lascia il party.
 */
void ecl_load_character(void)
{
    u16 i = 0;                          /* -$8(a5) */
    u8 v;                               /* -$9(a5) */
    u8 leave;                           /* -$A(a5) */
    Character *p;                       /* -$4(a5) */

    H064_B(9) = 1; /* H064_data+$9: flag LOAD CHARACTER: ripristinare il personaggio salvato */
    read_operands(1);
    v = (u8)eval_operand(1);
    p = g_party_head;
    leave = mask_byte(v, 0x80);
    v = mask_byte(v, 0x7F);
    while (v > 0 && i < v && p != NULL) {
        p = p->next;
        ++i;
    }
    if (p != NULL) {
        g_current_char = p;
        H005_B(0x24B3) = 0; /* $24B3: 1 se LOAD CHARACTER non ha trovato il personaggio (var $1F = 0) */
    } else {
        H005_B(0x24B3) = 1; /* $24B3: 1 se LOAD CHARACTER non ha trovato il personaggio (var $1F = 0) */
    }
    /* $24C4: uso: azzerato; con $24C3 LOAD CHARACTER toglie dal party; $24C3: uso: 1 da una
     * scrittura ECL dello stato B a 0; con $24C4 lascia */
    if (leave && H005_B(0x24C4) && H005_B(0x24C3)) {
        if (g_h064_saved_char == g_current_char) {
            H064_B(9) = 0; /* H064_data+$9: flag LOAD CHARACTER: ripristinare il personaggio salvato */
        }
        remove_from_party(0, 1);
        draw_party(g_current_char);
        H005_B(0x24C4) = 0; /* $24C4: uso: azzerato; con $24C3 LOAD CHARACTER toglie dal party */
        H005_B(0x24C3) = 0; /* $24C3: uso: 1 da una scrittura ECL dello stato B a 0; con $24C4 lascia */
    }
}

/*
 * PORT H064+$06A0 (comando $0B, LOAD MONSTER): aggiunge al party n copie
 * del mostro idx (con oggetti ed effetti, questi in ordine inverso) e il
 * suo set di figure CPIC spr nel posto $248E; i nemici (lato 1) hanno i
 * punti ferita scalati con la difficolta' ($3E04+$3E8, 1..5).  Al massimo
 * $3F mostri (H064+$5).
 */
void ecl_load_monster(void)
{
    Character *save;                    /* -$16(a5) */
    Character *mon = NULL;              /* -$12(a5) */
    Character *p;                       /* -$A(a5) */
    Character *q;                       /* -$E(a5) */
    Character tmpl;                     /* -$1C0(a5) */
    CokItem *items = NULL;              /* -$1D2(a5) */
    CokItem *items0;                    /* -$1DA(a5) */
    CokEffect *effects = NULL;          /* -$1DE(a5) */
    CokEffect *effects0;                /* -$1E6(a5) */
    CokItem *it;
    CokEffect *ef;
    u16 count = 1;                      /* -$6(a5) */
    u8 idx;                             /* -$1(a5) */
    u8 n;                               /* -$2(a5) */
    u8 spr;                             /* -$3(a5) */
    u16 diff;

    save = g_current_char;
    read_operands(3);
    if (H064_B(5) >= 0x3F) { /* H064_data+$5: numero di mostri caricati con LOAD MONSTER (max $3F) */
        g_current_char = save;
        return;
    }
    idx = (u8)eval_operand(1);
    load_monster(idx, &mon, &items, &effects);
    diff = COK_GET16(g_state_a + 0x3E8); /* A+$3E8: (word) livello di difficolta' (1..5, iniziale 3) */
    /* pg+$199: lato in combattimento (0 party, 1 avversari) */
    if (mon->b[0x199] == 1 && diff > 0 && diff < 6) {
        mon->b[0x1A8] = (u8)((u16)(mon->b[0x1A8] * (diff + 1)) >> 2); /* pg+$1A8: punti ferita correnti */
        mon->b[0x64] = (u8)((u16)(mon->b[0x64] * (diff + 1)) >> 2); /* pg+$64: punti ferita massimi */
        /* pg+$1A8: punti ferita correnti; pg+$64: punti ferita massimi */
        if (mon->b[0x1A8] == 0 || mon->b[0x64] == 0) {
            mon->b[0x1A8] = 1; /* pg+$1A8: punti ferita correnti */
            mon->b[0x64] = 1; /* pg+$64: punti ferita massimi */
        }
    }
    if (mon->b[0xDF]) { /* pg+$DF: tipo di non morto (0 = no); base -1 abilita' da ladro +$E0..+$E7 */
        /* $248F: mostri caricati con +$DF: limite di Turn Undead (turno +$13) */
        add_to_byte(&H005_B(0x248F), 1);
    }
    tmpl = *mon;
    items0 = items;
    effects0 = effects;
    n = (u8)eval_operand(2);
    if (n == 0) {
        n = 1;
    }
    spr = (u8)eval_operand(3);
    p = g_party_head;
    /* $248E: prossimo posto del set di figure CPIC per i mostri (da 8) */
    load_sprite_set(0x0C, "CPIC", spr, H005_B(0x248E));
    while (p->next != NULL) {
        p = p->next;
    }
    p->next = mon;
    p = p->next;
    /* pg+$143: posto delle icone 24x24 (0..7 nel party; $0A creazione, $0C editor); $248E: prossimo
     * posto del set di figure CPIC per i mostri (da 8) */
    p->b[0x143] = H005_B(0x248E);
    p->next = NULL;
    add_to_byte(&H064_B(5), 1); /* H064_data+$5: numero di mostri caricati con LOAD MONSTER (max $3F) */
    ++count;
    /* H064_data+$5: numero di mostri caricati con LOAD MONSTER (max $3F) */
    while (count <= n && H064_B(5) < 0x3F) {
        q = (Character *)exec_alloc_mem(sizeof(Character), COK_MEMF_CLEAR);
        p->next = q;
        p = p->next;
        *p = tmpl;                      /* copia dei $1AA byte */
        /* pg+$143: posto delle icone 24x24 (0..7 nel party; $0A creazione, $0C editor); $248E:
         * prossimo posto del set di figure CPIC per i mostri (da 8) */
        p->b[0x143] = H005_B(0x248E);
        p->next = NULL;
        p->effects = NULL;
        p->items = NULL;
        ++count;
        add_to_byte(&H064_B(5), 1); /* H064_data+$5: numero di mostri caricati con LOAD MONSTER (max $3F) */
        for (it = items; it != NULL; it = it->next) {
            CokItem *old = p->items;

            p->items = (CokItem *)exec_alloc_mem(sizeof(CokItem),
                                                 COK_MEMF_CLEAR);
            memcpy(p->items->b, it->b, 0x48);
            p->items->next = old;
        }
        items = items0;
        for (ef = effects; ef != NULL; ef = ef->next) {
            CokEffect *old = p->effects;

            p->effects = (CokEffect *)exec_alloc_mem(sizeof(CokEffect),
                                                     COK_MEMF_CLEAR);
            memcpy(p->effects->b, ef->b, 0x0A);
            p->effects->next = old;
        }
        effects = effects0;
    }
    add_to_byte(&H005_B(0x248E), 1); /* $248E: prossimo posto del set di figure CPIC per i mostri (da 8) */
    H005_B(0x24B6) = 1; /* $24B6: 1 se ci sono mostri caricati (LOAD MONSTER) per COMBAT */
    g_current_char = save;
}

/*
 * PORT H064+$05E2 (comando $0C, APPROACH): sprite spr ($2491) e ritratto
 * pic ($2490) dell'incontro alla distanza d ($3E00+$580), limitata dalle
 * caselle libere davanti ($3E00+$582).
 */
void ecl_approach(void)
{
    read_operands(3);
    H005_B(0x2491) = (u8)eval_operand(1); /* $2491: sprite SPRIT dell'incontro (ENCOUNTER/APPROACH) */
    /* B+$580: (word) distanza richiesta dell'incontro (ENCOUNTER/APPROACH) */
    COK_PUT16(g_state_b + 0x580, eval_operand(2));
    H005_B(0x2490) = (u8)eval_operand(3); /* $2490: ritratto PIC dell'incontro (ENCOUNTER/APPROACH) */
    /* $281C: (word) x del party sulla mappa dell'area 16x16; $281E: (word) y del party sulla mappa
     * dell'area 16x16; $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest); B+$582: (word)
     * distanza attuale dei nemici, limitata alle caselle libere */
    COK_PUT16(g_state_b + 0x582,
              free_steps((s16)H005_W(0x281C), (s16)H005_W(0x281E),
                         H005_B(0x2820)));
    /* B+$580: (word) distanza richiesta dell'incontro (ENCOUNTER/APPROACH); B+$582: (word) distanza
     * attuale dei nemici, limitata alle caselle libere */
    if (COK_GET16(g_state_b + 0x580) < COK_GET16(g_state_b + 0x582)) {
        /* B+$580: (word) distanza richiesta dell'incontro (ENCOUNTER/APPROACH); B+$582: (word)
         * distanza attuale dei nemici, limitata alle caselle libere */
        COK_PUT16(g_state_b + 0x582, COK_GET16(g_state_b + 0x580));
    }
    /* $2491: sprite SPRIT dell'incontro (ENCOUNTER/APPROACH); $2490: ritratto PIC dell'incontro
     * (ENCOUNTER/APPROACH) */
    show_event_picture(H005_B(0x2491), H005_B(0x2490),
                       /* B+$582: (word) distanza attuale dei nemici, limitata alle caselle libere;
                        * $2378: flag: sprite dell'evento gia' mostrato (flags[0], 2 byte con
                        * +$2379) */
                       (u8)COK_GET16(g_state_b + 0x582), &H005_B(0x2378));
}

/* PORT H064+$0ABE (comando $0D): l'incontro si avvicina di una casella. */
void ecl_approach_step(void)
{
    /* B+$582: (word) distanza attuale dei nemici, limitata alle caselle libere */
    if (COK_GET16(g_state_b + 0x582) > 0) {
        /* B+$582: (word) distanza attuale dei nemici, limitata alle caselle libere */
        COK_PUT16(g_state_b + 0x582, COK_GET16(g_state_b + 0x582) - 1);
        /* $2491: sprite SPRIT dell'incontro (ENCOUNTER/APPROACH); $2490: ritratto PIC dell'incontro
         * (ENCOUNTER/APPROACH) */
        show_event_picture(H005_B(0x2491), H005_B(0x2490),
                           /* B+$582: (word) distanza attuale dei nemici, limitata alle caselle
                            * libere; $2378: flag: sprite dell'evento gia' mostrato (flags[0], 2
                            * byte con +$2379) */
                           (u8)COK_GET16(g_state_b + 0x582), &H005_B(0x2378));
    }
    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1); /* $3DEA: (word) PC logico del programma ECL (base $3500) */
}

/*
 * PORT H064+$0B10 (comando $0E, PICTURE): mostra l'immagine n: dalla $70
 * un'immagine grande (la $79 con H069+$0012), sotto un PIC nella
 * finestra, con un ritratto testa+corpo se impostato; $FF chiude le
 * immagini e ridisegna la vista.
 */
void ecl_picture(void)
{
    u16 n;                              /* -$2(a5) */
    char name[0x51];                    /* -$54(a5) */

    read_operands(1);
    n = eval_operand(1);
    if (n != 0xFF) {
        H005_B(0x2379) = 1; /* $2379: flag: ritratto dell'evento gia' mostrato (flags[1]) */
        H005_B(0x24BD) = 1; /* $24BD: 1 se l'immagine/ritratto dell'evento e' a schermo */
        /* B+$5C2: (word) testa del ritratto dell'evento, $FF immagine PIC */
        if (COK_GET16(g_state_b + 0x5C2) == 0xFF) {
            H005_B(0x24BC) = 1; /* $24BC: 1 se l'immagine dell'evento e' animabile (non testa+corpo) */
            if (n >= 0x70) {
                load_big_picture(n);
                show_big_picture();
                if (n == 0x79) {
                    h069_draw_marker();
                } else {
                    /* $24AE: 1 con un'immagine grande a tutto schermo: niente elenco party */
                    H005_B(0x24AE) = 1;
                }
                H005_B(0x24E1) = 0; /* $24E1: 1: immagine/vista dell'esplorazione da ridisegnare */
            } else {
                strcpy(name, "PIC");
                load_sequence(0x50, name, n, 0);
                show_picture(3, 3, 1, g_pic_rec_27c2);
            }
        } else {
            /* B+$5C2: (word) testa del ritratto dell'evento, $FF immagine PIC */
            show_head_body(COK_GET16(g_state_b + 0x5C2), n);
        }
        return;
    }
    /* $3DE2: contesto di gioco precedente (copia di $3DE3), salvato; $3DE3: modo/contesto di gioco
     * corrente (0 menu, 1 vista, 5 combattimento) */
    if ((H005_B(0x3DE2) != 4 || H005_B(0x3DE3) == 4) &&
        /* $24BD: 1 se l'immagine/ritratto dell'evento e' a schermo; $24BA: 1 se lo sprite SPRIT
         * dell'evento e' a schermo */
        (H005_B(0x24BD) || H005_B(0x24BA))) {
        H005_B(0x24E1) = 1; /* $24E1: 1: immagine/vista dell'esplorazione da ridisegnare */
        refresh_view();
        H005_B(0x24BD) = 0; /* $24BD: 1 se l'immagine/ritratto dell'evento e' a schermo */
        H005_B(0x24BA) = 0; /* $24BA: 1 se lo sprite SPRIT dell'evento e' a schermo */
        H005_B(0x24BC) = 1; /* $24BC: 1 se l'immagine dell'evento e' animabile (non testa+corpo) */
    }
    H005_B(0x2378) = 0; /* $2378: flag: sprite dell'evento gia' mostrato (flags[0], 2 byte con +$2379) */
    H005_B(0x2379) = 0; /* $2379: flag: ritratto dell'evento gia' mostrato (flags[1]) */
}

/* PORT H064+$0C62 (comando $0F, INPUT NUMBER). */
void ecl_input_number(void)
{
    u16 dst;                            /* -$6(a5) */

    read_operands(2);
    dst = ADDR(2);
    write_var(dst, input_number(1, "", 0x0A, 0));
}

/* PORT H064+$0CC4 (comando $10, INPUT STRING): stringa vuota diventa " ". */
void ecl_input_string(void)
{
    char buf[0x51];                     /* -$56(a5) */
    u16 dst;                            /* -$4(a5) */

    read_operands(2);
    dst = ADDR(2);
    input_line(1, "", 0x0A, 0, 0x28, 0x50, buf);
    if (buf[0] == '\0') {
        strcpy(buf, " ");
    }
    write_string_var(dst, 0x50, buf);
}

/*
 * PORT H064+$0D4A (comandi $11 PRINT e $12 PRINTCLEAR): testo (o numero)
 * nella finestra di testo; $12 riparte dall'alto e la pulisce.
 */
void ecl_print(void)
{
    read_operands(1);
    H005_B(0x24B9) = 0; /* $24B9: 0 dopo testo ECL; il menu comandi pulisce righe $11..$16 e mette 1 */
    H005_B(0x24CE) = 1; /* $24CE: 1: pausa per carattere nella scrittura del testo */
    if (OPD(1) < 0x80) {
        format_number(0xFF, ecl_string(1), (s32)eval_operand(1), 0, 0x0A, 4,
                      ' ');
        trim_leading_spaces(0xFF, ecl_string(1));
    }
    if (H005_B(0x2493) == 0x11) { /* $2493: codice del comando ECL in esecuzione */
        word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 0, 0xFF, ecl_string(1));
    } else {
        H005_SET_W(0x334C, 0x11); /* $334C: (word) cursore del testo: riga */
        H005_SET_W(0x334E, 1); /* $334E: (word) cursore del testo: colonna */
        word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 1, 0xFF, ecl_string(1));
    }
    H005_B(0x24CE) = 0; /* $24CE: 1: pausa per carattere nella scrittura del testo */
}

/* PORT H064+$0E40 (comando $13, RETURN): torna dal GOSUB; senza pila e' EXIT. */
void ecl_return(void)
{
    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1); /* $3DEA: (word) PC logico del programma ECL (base $3500) */
    if (g_ecl_stack != NULL) {
        H005_SET_W(0x3DEA, g_ecl_stack->pc); /* $3DEA: (word) PC logico del programma ECL (base $3500) */
        g_ecl_stack_prev = g_ecl_stack->next;
        exec_free_mem(g_ecl_stack, sizeof(CokEclFrame));
        g_ecl_stack = g_ecl_stack_prev;
    } else {
        ecl_exit();
    }
}

/* PORT H064+$0E9C (comando $14, COMPARE AND): (a = b) e (c = d). */
void ecl_compare_and(void)
{
    u16 v[4];                           /* -$8(a5) */
    u16 i;                              /* -$A(a5) */

    /* $237E: risultati dell'ultimo confronto ECL, 6 byte: +0 uguale */
    h029_fill_bytes(5, &H005_B(0x237E), 6, 0);
    read_operands(4);
    for (i = 1; i <= 4; ++i) {
        v[i - 1] = eval_operand(i);
    }
    if (v[0] == v[1] && v[2] == v[3]) {
        H005_B(0x237E) = 1; /* $237E: risultati dell'ultimo confronto ECL, 6 byte: +0 uguale */
    } else {
        H005_B(0x237F) = 1; /* $237F: risultati del confronto +1: diverso */
    }
}

/*
 * PORT H064+$0F30 (comandi $16..$1B, IF =, <>, <, >, <=, >=): se il
 * risultato dell'ultimo confronto e' falso salta il comando seguente.
 */
void ecl_if(void)
{
    u16 i;                              /* -$2(a5) */

    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1); /* $3DEA: (word) PC logico del programma ECL (base $3500) */
    for (i = 1; i <= 6; ++i) {
        if (H005_B(0x2493) == i + 0x15) { /* $2493: codice del comando ECL in esecuzione */
            /* $237D: uso: base calcolata $237E+i-1 con i>=1; vedi i risultati a +$237E */
            if (!H005_B(0x237E + i - 1)) {
                ecl_skip_command();
                return;
            }
        }
    }
}

/*
 * PORT H064+$0F90 (comando $20, NEWECL): carica il programma dell'area n
 * (la precedente in $3E04+$1E4) e lo riparte dall'inizio.
 */
void ecl_new_ecl(void)
{
    u8 n;                               /* -$1(a5) */

    read_operands(1);
    /* $2498: id del programma ECL dell'area corrente ($24 iniziale, $39 demo); A+$1E4: (word)
     * numero dell'area ECL corrente (copia di $2498) */
    COK_PUT16(g_state_a + 0x1E4, H005_B(0x2498));
    n = (u8)eval_operand(1);
    H005_B(0x2498) = n; /* $2498: id del programma ECL dell'area corrente ($24 iniziale, $39 demo) */
    load_ecl_program(n);
    ecl_start_area();
    H064_B(0x0B) = 1; /* H064_data+$B: flag fine esecuzione ECL (EXIT o NEWECL) */
    H064_B(0x0A) = 1; /* H064_data+$A: flag NEWECL: nuovo programma caricato, riparte l'ingresso */
    /* $2378: flag: sprite dell'evento gia' mostrato (flags[0], 2 byte con +$2379) */
    h029_fill_bytes(1, &H005_B(0x2378), 2, 0);
}

/*
 * PORT H064+$1004 (comandi $21 LOAD FILES e $37 LOAD PIECES): mappa GEO
 * del dungeon ($21) o definizioni dei muri dei tre set ($37, $FF nessuna,
 * $7F tutte via); se cambiano entrambi nel dungeon si ridisegna la
 * cornice.
 */
void ecl_load_files(void)
{
    u16 v[3];                           /* -$6(a5)..-$2(a5) */
    u16 i;                              /* -$8(a5) */

    read_operands(3);
    H064_B(8) = 1; /* H064_data+$8: flag LOAD FILES/PIECES eseguito: ridisegna la vista */
    for (i = 1; i <= 3; ++i) {
        v[i - 1] = eval_operand(i);
    }
    if (H005_B(0x2493) == 0x21) { /* $2493: codice del comando ECL in esecuzione */
        H064_B(6) = 1; /* H064_data+$6: flag mappa GEO caricata (LOAD FILES $21) nel programma */
        /* A+$1CC: (word) 1 area 3D (mappa 16x16), 0 mappa all'aperto */
        if (v[0] != 0xFF && v[0] != 0x7F && COK_GET16(g_state_a + 0x1CC)) {
            /* A+$18A: (word) id della mappa GEO caricata (ricaricata al Load) */
            COK_PUT16(g_state_a + 0x18A, v[0]);
            load_geo_map(v[0]);
            /* B+$592: uso: se >= $FF il passo dell'esplorazione e' annullato (poi 0) */
            COK_PUT16(g_state_b + 0x592, 0);
        }
    } else {
        H064_B(7) = 1; /* H064_data+$7: flag muri caricati (LOAD PIECES $37) nel programma */
        if (v[0] == 0x7F) {
            load_wall_defs(0, 1);
        /* A+$1CE: uso: con +$1D0 non nullo LOAD FILES carica solo i muri 1 e 3; A+$1D0: uso: con
         * +$1CE non nullo LOAD FILES carica solo i muri 1 e 3 */
        } else if (COK_GET16(g_state_a + 0x1CE) && COK_GET16(g_state_a + 0x1D0)) {
            if (v[0] != 0xFF) {
                load_wall_defs(v[0], 1);
            } else {
                /* $2810: tab. 3 voci da 4 byte dei set di muri: word id WALLDEF, $FFFF vuoto */
                H005_SET_W(0x2810, 0xFFFF);
                /* $2812: word +2 delle voci $2810: posizione (slot 1..3), $FFFF vuoto */
                H005_SET_W(0x2812, 0xFFFF);
            }
            if (v[2] != 0xFF && v[2] != 0x7F) {
                load_wall_defs(v[2], 3);
            } else {
                H005_SET_W(0x2818, 0xFFFF); /* $2818: word id WALLDEF della 3a voce di $2810 ($FFFF vuoto) */
                H005_SET_W(0x281A, 0xFFFF); /* $281A: word posizione della 3a voce di $2810 ($FFFF vuoto) */
            }
        } else {
            for (i = 1; i <= 3; ++i) {
                if (v[i - 1] != 0xFF) {
                    load_wall_defs(v[i - 1], i);
                } else {
                    /* $2810: tab. 3 voci da 4 byte dei set di muri: word id WALLDEF, $FFFF vuoto */
                    H005_SET_W(0x2810 + (i - 1) * 4, 0xFFFF);
                    /* $2812: word +2 delle voci $2810: posizione (slot 1..3), $FFFF vuoto */
                    H005_SET_W(0x2810 + (i - 1) * 4 + 2, 0xFFFF);
                }
            }
        }
    }
    /* H064_data+$7: flag muri caricati (LOAD PIECES $37) nel programma; H064_data+$6: flag mappa
     * GEO caricata (LOAD FILES $21) nel programma; $3DE2: contesto di gioco precedente (copia di
     * $3DE3), salvato */
    if (H064_B(7) && H064_B(6) && H005_B(0x3DE2) == 3) {
        /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento); $24B2: 1:
         * cornice dell'esplorazione da ridisegnare (dopo LOAD FILES) */
        if (H005_B(0x3DE3) != 3 && H005_B(0x24B2)) {
            draw_explore_frame();
            draw_party(g_current_char);
            draw_status_line();
        }
        H005_B(0x24B2) = 0; /* $24B2: 1: cornice dell'esplorazione da ridisegnare (dopo LOAD FILES) */
    }
}

/* PORT H064+$121C (comandi $2F AND e $30 OR): bit a bit, confronto con 0. */
void ecl_and_or(void)
{
    u16 a;                              /* -$6(a5) */
    u16 b;                              /* -$4(a5) */
    u16 dst;                            /* -$2(a5) */
    u16 r;                              /* -$8(a5) */

    read_operands(3);
    a = eval_operand(1);
    b = eval_operand(2);
    dst = ADDR(3);
    if (H005_B(0x2493) == 0x2F) { /* $2493: codice del comando ECL in esecuzione */
        r = mask_byte((u8)a, b);
    } else {
        r = or_byte((u8)a, b);
    }
    compare_words(0, r);
    write_var(dst, r);
}

/* PORT H064+$12CA (comando $2A, GETTABLE): dst = base[i]. */
void ecl_get_table(void)
{
    u16 base;                           /* -$2(a5) */
    u16 i;                              /* -$A(a5) */
    u16 dst;                            /* -$4(a5) */

    read_operands(3);
    base = ADDR(1);
    i = eval_operand(2);
    dst = ADDR(3);
    write_var(dst, read_var((u16)(base + i)));
}

/* PORT H064+$1346 (comando $35, SETTABLE): base[i] = valore. */
void ecl_set_table(void)
{
    u16 val;                            /* -$6(a5) */
    u16 base;                           /* -$4(a5) */
    u16 i;                              /* -$2(a5) */

    read_operands(3);
    val = eval_operand(1);
    base = ADDR(2);
    i = eval_operand(3);
    write_var((u16)(base + i), val);
}

/*
 * PORT H064+$13AC (comando $15, VERTICAL MENU): testo nella finestra,
 * poi una lista di n voci (gli operandi seguenti); la scelta va nella
 * variabile del primo operando.
 */
void ecl_vertical_menu(void)
{
    u8 redraw = 1;                      /* -$111(a5) */
    char title[2];                      /* -$10E(a5) */
    u16 k = 1;                          /* -$4(a5) */
    u16 dst;                            /* -$114(a5) */
    char text[0x100];                   /* -$104(a5) */
    u16 n;                              /* -$2(a5) */
    CokMenuItem *list;                  /* -$108(a5) */
    CokMenuItem *head;                  /* -$10C(a5) */
    u16 sel;                            /* -$110(a5) */

    H005_B(0x2483) = 1; /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
    H005_B(0x24B9) = 0; /* $24B9: 0 dopo testo ECL; il menu comandi pulisce righe $11..$16 e mette 1 */
    title[0] = '\0';
    title[1] = '\0';
    read_operands(3);
    dst = ADDR(1);
    memcpy(text, ecl_string(1), 0x100);
    n = eval_operand(3);
    H005_SET_W(0x3DEA, H005_W(0x3DEA) - 1); /* $3DEA: (word) PC logico del programma ECL (base $3500) */
    read_operands(n);
    menu_alloc(n, &list);
    head = list;
    H005_SET_W(0x334E, 1); /* $334E: (word) cursore del testo: colonna */
    H005_SET_W(0x334C, 0x11); /* $334C: (word) cursore del testo: riga */
    word_wrap_text(1, 0x11, 0x26, 0x16, 0x0A, 0, 1, 0xFF, text);
    while (list != NULL) {
        h026_copy(0x28, list->text, 0xFF, ecl_string(k));
        list->header = 0;
        list = list->next;
        ++k;
    }
    list = head;
    sel = 0;
    (void)ecl_list_menu(1, title, 1, title, 0x0D, 0x0A, 0x0F, 1,
                        /* $334C: (word) cursore del testo: riga */
                        (u16)(H005_W(0x334C) + 1), 0x26, 0x16, list, 0,
                        &redraw, &sel, &list);
    write_var(dst, sel);
    menu_free(&list);
    clear_text_cells(1, 0x11, 0x26, 0x16);
}

/*
 * PORT H064+$1544 (comando $2B, HORIZONTAL MENU): opzioni con le
 * scorciatoie '~' sulla riga dei messaggi; con una sola opzione Invio la
 * conferma (e "PRESS BUTTON OR RETURN..." diventa la versione da
 * tastiera).  La scelta va nella variabile del primo operando.
 */
void ecl_horizontal_menu(void)
{
    char title[2];                      /* -$8(a5) */
    char opts[0x33];                    /* -$3C(a5) */
    u16 dst;                            /* -$3E(a5) */
    u16 n;                              /* -$2(a5) */
    u16 k;                              /* -$6(a5) */
    u8 allow_enter;                     /* -$3F(a5) */
    u8 animate;                         /* -$40(a5) */
    u16 pen3;                           /* -$42(a5) */
    u16 pen2;                           /* -$44(a5) */

    H005_B(0x2483) = 1; /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
    title[0] = '\0';
    title[1] = '\0';
    opts[0] = '\0';
    read_operands(2);
    dst = ADDR(1);
    n = eval_operand(2);
    H005_SET_W(0x3DEA, H005_W(0x3DEA) - 1); /* $3DEA: (word) PC logico del programma ECL (base $3500) */
    read_operands(n);
    opts[0] = '\0';
    if (n == 1) {
        allow_enter = 1;
        pen3 = 0x0F;
        pen2 = 0x0F;
        if (h026_compare_nocase(0xFF, ecl_string(1), 0x23,
                                "PRESS BUTTON OR RETURN TO CONTINUE.") == 1) {
            h026_copy(0xFF, ecl_string(1), 0x22,
                      "PRESS <ENTER>/<RETURN> TO CONTINUE");
        }
    } else {
        allow_enter = 0;
        pen3 = 0x0F;
        pen2 = 0x0A;
    }
    /* $24BD: 1 se l'immagine/ritratto dell'evento e' a schermo; $24BC: 1 se l'immagine dell'evento
     * e' animabile (non testa+corpo) */
    animate = (u8)(H005_B(0x24BD) && H005_B(0x24BC));
    for (k = 1; k <= (u16)(n - 1); ++k) {
        h026_append(0x32, opts, 1, "~");
        h026_append(0x32, opts, 0xFF, ecl_string(k));
        h026_append(0x32, opts, 1, " ");
    }
    h026_append(0x32, opts, 1, "~");
    h026_append(0x32, opts, 0xFF, ecl_string(n));
    write_var(dst, ecl_menu(1, title, 0x32, opts, 0x0D, pen2, pen3,
                            allow_enter, animate));
    clear_text_cells(0, 0x18, 0x27, 0x18);
}

/*
 * PORT H064+$1748 (comando $1C, CLEAR MONSTERS): nessun mostro caricato,
 * posti delle figure da 8, tesoro ($2A1E..$2A39 e la lista $2A3A) vuoto.
 */
void ecl_clear_monsters(void)
{
    CokItem *next;                      /* -$4(a5) */

    H005_SET_W(0x3DEA, H005_W(0x3DEA) + 1); /* $3DEA: (word) PC logico del programma ECL (base $3500) */
    H005_B(0x248F) = 0; /* $248F: mostri caricati con +$DF: limite di Turn Undead (turno +$13) */
    H064_B(5) = 0; /* H064_data+$5: numero di mostri caricati con LOAD MONSTER (max $3F) */
    H005_B(0x24B6) = 0; /* $24B6: 1 se ci sono mostri caricati (LOAD MONSTER) per COMBAT */
    H005_B(0x248E) = 8; /* $248E: prossimo posto del set di figure CPIC per i mostri (da 8) */
    /* $2A1E: cassa del party: 7 long, monete per tipo 0..6 (4 = acciaio) */
    h029_fill_bytes(0x1B, &H005_B(0x2A1E), 0x1C, 0);
    while (g_treasure_items != NULL) {
        next = g_treasure_items->next;
        exec_free_mem(g_treasure_items, sizeof(CokItem));
        g_treasure_items = next;
    }
}

/*
 * PORT H064+$17BC (comando $1D, PARTY STRENGTH): somma per personaggio di
 * (PF + CA*5 + THAC0*5 + livello*8 + livello2*4) / 10 (byte, CA oltre
 * $3C e THAC0 oltre $27), nella variabile dell'operando.
 */
void ecl_party_strength(void)
{
    u8 total = 0;                       /* -$6(a5) */
    Character *p;                       /* -$C(a5) */
    u8 hp;                              /* -$1(a5) */
    u8 ac;                              /* -$5(a5) */
    u8 thac0;                           /* -$2(a5) */
    u8 lvl;                             /* -$3(a5) */
    u8 lvl2;                            /* -$4(a5) */

    read_operands(1);
    for (p = g_party_head; p != NULL; p = p->next) {
        hp = p->b[0x1A8]; /* pg+$1A8: punti ferita correnti */
        ac = p->b[0x19C]; /* pg+$19C: classe d'armatura corrente codificata (60 - CA) */
        thac0 = p->b[0x19B]; /* pg+$19B: THAC0 corrente codificato (60 - THAC0) */
        /* pg+$103: livello da mago; pg+$10B: livello precedente da mago */
        lvl = (u8)(p->b[0x103] + p->b[0x10B] * h073_130a(p));
        /* pg+$FE: livelli per classe, 8 voci (0 chierico..7 cavaliere); chierico; pg+$106: livelli
         * della classe precedente, 8 voci come +$FE; chierico */
        lvl2 = (u8)(p->b[0xFE] + p->b[0x106] * h073_130a(p));
        ac = (u8)(ac > 0x3C ? ac - 0x3C : 0);
        thac0 = (u8)(thac0 > 0x27 ? thac0 - 0x27 : 0);
        add_to_byte(&total, (u16)((u16)(hp + ac * 5 + thac0 * 5 + lvl * 8 +
                                        lvl2 * 4) / 10));
    }
    write_var(ADDR(1), total);
}
