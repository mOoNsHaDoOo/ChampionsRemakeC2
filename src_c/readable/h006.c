/*
 * H006: preparazione dell'ambiente, percorsi, stato e risorse comuni.
 *
 * Dati del modulo (a4 = H006+$40):
 *   +$07 "df0:"       +$0C "df0:Save"    +$15 "Save"
 *   +$1A/$30/$46      Assign "Disk One:" / "Disk Two:" / "Disk Three:" ""
 *   +$5E "NormIsKing" +$69 ""  +$6B ""   +$6D "Loading...Please Wait"
 *   +$83/$8A "COMSPR" +$91/$95/$99 "sky" +$9D "ITEMS"
 *   -$2  word, contatore dei cicli (dato del modulo, non locale)
 *   -$40 long, secondi di CurrentTime
 */
#include "h006.h"
#include "h027.h"
#include "h033.h"
#include "h008.h"
#include "h002_dos.h"
#include "h003_exec.h"
#include "h021_intuition.h"
#include "h026_string.h"
#include "h028_files.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h016_gfx.h"
#include "h031.h"
#include "h034.h"
#include "h035.h"
#include "globals.h"
#include "unported.h"

static u16 s_i;                         /* -$2(a4) */
static u32 s_time_seconds;              /* -$40(a4) */

extern u32 g_h023_0000;                 /* H023+$0000: microsecondi */

/* PORT H006+$00EC: link/unlk, nessun effetto. */
void h006_init(void)
{
}

/* move.b (a3)+,(a2)+ / dbeq dn: al massimo limit+1 byte, NUL compreso. */
static void copy_dbeq(char *dst, const char *src, unsigned limit)
{
    unsigned i;

    for (i = 0; i <= limit; ++i) {
        dst[i] = src[i];
        if (src[i] == 0) {
            break;
        }
    }
}

/*
 * PORT H006+$00FA: carica il record 99 di "border" (con maschera, colore
 * 13) e ne copia i primi 24x8 pixel, immagine e maschera, alla x 160 del
 * set 8x8 del posto 4 (H005+$3348); poi lo libera.
 */
static void merge_border_tiles(void)
{
    struct GfxRecord *border = NULL;    /* -$4(a5) */

    load_indexed_gfx_record(6, "border", 0x63, 1, 0x0D, &border);
    (void)graphics_blt_bitmap(border->image, 0, 0, g_8x8_sets[4]->image,
                              0xA0, 0, 0x18, 8, 0xC0, 0xFF, NULL);
    (void)graphics_blt_bitmap(border->mask, 0, 0, g_8x8_sets[4]->mask,
                              0xA0, 0, 0x18, 8, 0xC0, 0xFF, NULL);
    free_gfx_record(&border);
}

/* Legge i 129 record da $12 byte del file ITEMS in H005+$336C. */
static void load_items_table(void)
{
    cok_bptr file;

    file = dos_open("ITEMS", MODE_OLDFILE);
    if (file == 0) {
        return;
    }
    (void)dos_seek(file, 2, OFFSET_BEGINNING);
    for (s_i = 0; s_i <= 0x80; ++s_i) {
        /* $336C: tabella dei tipi di oggetto (ogg+$30), $12 byte per tipo; off = campo */
        u8 *rec = &g_h005[0x336C + (u32)s_i * 0x12];

        (void)dos_read(file, rec, 5);
        h031_swap_word(rec + 4);
        (void)dos_read(file, rec + 6, 7);
        h031_swap_word(rec + 0x0C);
        (void)dos_read(file, rec + 0x0E, 4);
    }
    dos_close(file);
}

/*
 * PORT H006+$01AE (Initialize_GameEnvironment): percorso del salvataggio e
 * assegnazioni dei dischi, blocchi di stato, record grafici, azzeramento
 * dello stato di gioco, risorse comuni e tabella degli oggetti.
 */
void init_game_environment(void)
{
    G_RESOURCE_GROUP = 0; /* $246E: disco dei dati / gruppo di risorse corrente (G_RESOURCE_GROUP) */

    /* Percorso del salvataggio ($3CD4, dbeq con $50). */
    if (h026_compare_nocase(0x50, G_DATA_PREFIX, 4, "df0:") == 1) {
        /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */
        copy_dbeq((char *)&g_h005[0x3CD4], "df0:Save", 0x50);
    } else {
        /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */
        copy_dbeq((char *)&g_h005[0x3CD4], "Save", 0x50);
        (void)dos_execute("Assign \"Disk One:\" \"\"", 0, 0);
        (void)dos_execute("Assign \"Disk Two:\" \"\"", 0, 0);
        (void)dos_execute("Assign \"Disk Three:\" \"\"", 0, 0);
    }

    if (file_exists(0x0A, "NormIsKing") == 0) {
        intuition_current_time(&s_time_seconds, &g_h023_0000);
    }
    open_game_display();

    H005_B(0x24A2) = 1; /* $24A2: 1: il clic su un nome del party sceglie il personaggio */
    H005_B(0x2489) = 0; /* $2489: uso: solo azzerato all'avvio (H006) */
    /* $2356: X del mouse (word, iniziale $A0) */
    H005_SET_W(0x2356, 0xA0);           /* mouse X */
    /* $2354: Y del mouse (word, iniziale $64) */
    H005_SET_W(0x2354, 0x64);           /* mouse Y */
    H005_SET_W(0x2352, 0); /* $2352: uso: word azzerata all'avvio accanto alle coordinate del mouse */
    H005_SET_W(0x2350, 0); /* $2350: uso: word azzerata all'avvio accanto alle coordinate del mouse */

    g_state_a = (u8 *)exec_alloc_mem(0x800, COK_MEMF_CLEAR);
    g_state_b = (u8 *)exec_alloc_mem(0x800, COK_MEMF_CLEAR);
    g_state_c = (u8 *)exec_alloc_mem(0x400, COK_MEMF_CLEAR);
    g_ecl_buffer = (u8 *)exec_alloc_mem(0x1E00, COK_MEMF_CLEAR);
    g_h005_282e = (u8 *)exec_alloc_mem(0x924, COK_MEMF_CLEAR);
    g_geo_planes = (u8 *)exec_alloc_mem(0x400, COK_MEMF_CLEAR);

    allocate_gfx_record(8, 1, 1, 0, &g_gfx_3334);
    allocate_gfx_record(0x30, 3, 1, 0, &g_gfx_3d8a);
    allocate_gfx_record(0x18, 3, 0x28, 1, &g_gfx_332c);
    g_gfx_3d8e = NULL;
    prepare_display_resources();

    COK_PUT16(g_state_a + 0x3E8, 3); /* A+$3E8: (word) livello di difficolta' (1..5, iniziale 3) */
    COK_PUT16(g_state_a + 0x1CC, 1); /* A+$1CC: (word) 1 area 3D (mappa 16x16), 0 mappa all'aperto */
    COK_PUT16(g_state_a + 0x1E4, 0); /* A+$1E4: (word) numero dell'area ECL corrente (copia di $2498) */
    COK_PUT16(g_state_a + 0x3F2, 2); /* A+$3F2: (word) fase (0..3) del ciclo 1: icona cornice colonna 8 */
    COK_PUT16(g_state_a + 0x3F4, 2); /* A+$3F4: (word) fase (0..3) del ciclo 2: icona cornice colonna $13 */
    COK_PUT16(g_state_a + 0x3F6, 2); /* A+$3F6: (word) fase (0..3) del ciclo 3: icona cornice colonna $1E */

    /* H006+$03E8: 29 coppie di set 24x24 a $3244. */
    for (s_i = 0; s_i <= 0x1C; ++s_i) {
        g_sprite_sets[s_i][0] = NULL;
        g_sprite_sets[s_i][1] = NULL;
    }
    /* H006+$041C: due voci da 6 byte a $27B0. */
    for (s_i = 1; s_i <= 2; ++s_i) {
        /* $27B0: 2 voci da 6 byte (id + long gfx a +2): id HEAD caricato, $FF nessuno */
        H005_B(0x27B0 + (s_i - 1) * 6) = 0xFF;
        g_gfx_27b0[s_i - 1] = NULL;      /* long a +2 */
    }
    g_pic_rec_27c2 = NULL;
    g_pic_rec_27c6 = NULL;
    /* H006+$0468 */
    for (s_i = 2; s_i <= 8; ++s_i) {
        /* $27DA: tab. 7 word: dim. compressa dei fotogrammi 2..n (idx frame-2) */
        H005_SET_W(0x27DA + (s_i - 2) * 2, 0);
        g_pic_buffers[s_i - 2] = NULL;
    }
    H005_SET_W(0x27BC, 0); /* $27BC: (word) fotogrammi della sequenza caricata (max 6), base del blocco */
    g_gfx_2798 = NULL;
    H005_SET_L(0x2A3A, 0); /* $2A3A: (long) puntatore alla lista degli oggetti del tesoro */

    h029_fill_bytes(7, &g_h005[0x281C], 7, 0); /* $281C: (word) x del party sulla mappa dell'area 16x16 */
    H005_SET_W(0x281C, 7); /* $281C: (word) x del party sulla mappa dell'area 16x16 */
    H005_SET_W(0x281E, 0x0D); /* $281E: (word) y del party sulla mappa dell'area 16x16 */
    H005_B(0x2820) = 0; /* $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
    h029_fill_bytes(2, &g_h005[0x24E4], 3, 1); /* $24E4: opzione Bash disponibile davanti alla porta chiusa */

    /* H006+$04F8: stato dei tre insiemi di pareti. */
    H005_SET_W(0x2810, 0); /* $2810: tab. 3 voci da 4 byte dei set di muri: word id WALLDEF, $FFFF vuoto */
    H005_SET_W(0x2812, 1); /* $2812: word +2 delle voci $2810: posizione (slot 1..3), $FFFF vuoto */
    for (s_i = 2; s_i <= 3; ++s_i) {
        /* $2810: tab. 3 voci da 4 byte dei set di muri: word id WALLDEF, $FFFF vuoto */
        H005_SET_W(0x2810 + (s_i - 1) * 4, 0xFFFF);
        /* $2812: word +2 delle voci $2810: posizione (slot 1..3), $FFFF vuoto */
        H005_SET_W(0x2810 + (s_i - 1) * 4 + 2, 0xFFFF);
    }

    H005_B(0x24D4) = 1; /* $24D4: Animation on/off (Alter): piu' fotogrammi e "Loading..." */
    H005_B(0x24D5) = 1; /* $24D5: Pics on/off (Alter); salvato con $24D4 in $3E04+$1FE */
    H005_B(0x24D2) = 0; /* $24D2: debug attivo ("*" in stato, valori extra) */
    H005_B(0x24CE) = 1; /* $24CE: 1: pausa per carattere nella scrittura del testo */
    H005_B(0x24D1) = 0; /* $24D1: 1 dopo Load Saved Game: l'area non azzera le sue variabili */
    H005_SET_W(0x3DDE, 0); /* $3DDE: (word) passi di riposo dall'ultimo controllo incontri */
    g_party_head = NULL;
    g_current_char = NULL;
    /* $3DEA: (word) PC logico del programma ECL (base $3500) */
    H005_SET_W(0x3DEA, 0x3500);         /* PC logico ECL */
    H005_SET_W(0x3DF6, 4); /* $3DF6: (word) velocita' del gioco 0..9 (pausa dei messaggi) */
    G_DEMO_FLAG = 0; /* $24D7: 1 se e' stata scelta la dimostrazione (Demo) */
    H005_B(0x246D) = 1; /* $246D: disco dei dati precedente (copia di +$246E) */
    H005_B(0x2825) = 0; /* $2825: flag mappa dall'alto attiva al posto della vista 3D */
    COK_PUT16(g_state_b + 0x67C, 0); /* B+$67C: (word) numero dei membri del party (max 8) */
    H005_SET_W(0x2796, 1); /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
    H005_B(0x24C1) = 0; /* $24C1: uso: azzerato all'avvio; con 1 esito e caduti trattati diversamente */
    H005_B(0x24E2) = 0; /* $24E2: 1 durante il riposo: puntatore d'attesa, messaggi dalla riga $12 */
    H005_B(0x2497) = 0; /* $2497: copia del bit Search ($3E00+$594) durante l'ingresso $3DF2 */
    H005_B(0x24BF) = 0; /* $24BF: uso: 1 dopo il comando ECL $3D (ridisegno), 0 dopo EXIT */
    H005_B(0x24BE) = 0; /* $24BE: uso: azzerato all'avvio e dal comando ECL $33 (a capo) */
    H005_B(0x24BD) = 0; /* $24BD: 1 se l'immagine/ritratto dell'evento e' a schermo */
    H005_B(0x24D0) = 0; /* $24D0: 1 party perduto o uscito: ferma ECL e ciclo dell'esplorazione */
    H005_B(0x24A6) = 1; /* $24A6: uso: solo posto a 1 all'avvio (H006) */
    H005_B(0x24BA) = 0; /* $24BA: 1 se lo sprite SPRIT dell'evento e' a schermo */
    H005_B(0x24A4) = 0; /* $24A4: uso: argomento ignorato di Open_ResourceFile; 1 caricando SPC */
    /* $27A6: nome (8 car.) della sequenza di immagini caricata, vuoto se nessuna */
    copy_dbeq((char *)&g_h005[0x27A6], "", 8);
    /* $279C: nome (8 car.) della sequenza salvata da Encamp per ricaricarla */
    copy_dbeq((char *)&g_h005[0x279C], "", 8);
    H005_B(0x2486) = 0xFF; /* $2486: id della sequenza caricata in $27BC (nome a $27A6), $FF nessuna */
    H005_B(0x2485) = 0xFF; /* $2485: id della sequenza salvato entrando al campo, ricaricato all'uscita */
    H005_B(0x24A3) = 0; /* $24A3: 1 se la partita e' salvata (avviso all'uscita); letto da eff. $36 */
    H005_B(0x247E) = 0xE8; /* $247E: uso: $E8 all'avvio, 9 a inizio area; scritto da ECL var $755F */
    H005_B(0x247F) = 0xDB; /* $247F: uso: $DB all'avvio, $41 a inizio area; scritto da ECL var $7559 */
    H005_B(0x24B4) = 0; /* $24B4: 1 durante il comando ENCOUNTER */
    H005_B(0x24D8) = 0; /* $24D8: modo di scelta membro: il clic va in $2508 e non nel corrente */
    H005_B(0x24C6) = 1; /* $24C6: 1 se le azioni del combattente vanno disegnate (visibile) */
    H005_B(0x2484) = 0xFF; /* $2484: id dell'immagine grande BIGPIC caricata ($FF nessuna) */
    H005_B(0x24AD) = 0; /* $24AD: uso: solo azzerato all'avvio (H006) */
    H005_B(0x24CF) = 0; /* $24CF: 1 durante la creazione: Train senza messaggi ne' domande */
    H005_B(0x2483) = 1; /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
    /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
    H005_B(0x3DE3) = 4;                 /* contesto nativo */
    H005_B(0x3DE2) = 0; /* $3DE2: contesto di gioco precedente (copia di $3DE3), salvato */
    H005_B(0x24A7) = 1; /* $24A7: uso: 1 ferma l'audio attorno alle scene, 0 riavvia H043 */
    H005_B(0x24E0) = 0; /* $24E0: 1: gli effetti passano al gestore $2A0E (oggetti magici) */
    H005_B(0x24AE) = 0; /* $24AE: 1 con un'immagine grande a tutto schermo: niente elenco party */
    g_gfx_sky_280c = NULL;
    g_gfx_sky_2808 = NULL;
    g_gfx_sky_2804 = NULL;
    g_dropped_items = NULL;             /* $3360 */
    H005_B(0x24B1) = 0; /* $24B1: uso: solo azzerato all'avvio (H006) */
    H005_B(0x24CB) = 0; /* $24CB: 1 nel modo Move/Attack: cursore sulla mappa di combattimento */
    H005_B(0x24CC) = 0; /* $24CC: 1 nel modo Manual: cursore sulla mappa di combattimento */
    H005_B(0x24B0) = 0; /* $24B0: modo Move dell'esplorazione: clic sulla vista come movimento */
    H005_B(0x249E) = 0; /* $249E: 1 se il tasto viene dal mouse (clic) */
    H005_B(0x24DA) = 0; /* $24DA: 1 in Modify Character: il clic sceglie il campo ($2506) */

    /* $16: lista di 20 puntatori (long) ai personaggi a terra, conteggio +$14 */
    h029_fill_bytes(0x4F, &g_h005[0x16], 0x50, 0);
    H005_SET_W(0x14, 0); /* $14: numero di personaggi a terra nella lista +$16 (word, max 20) */
    load_gothic_font();
    clear_message_line();
    ui_draw_text(0, 0x18, 0x0A, 0, 0x15, "Loading...Please Wait");

    for (s_i = 0; s_i <= 4; ++s_i) {
        g_8x8_sets[s_i] = NULL;
    }
    load_8x8_set(0xCA, 4);
    load_8x8_set(0xCB, 0);
    merge_border_tiles();

    for (s_i = 0; s_i <= 0x0B; ++s_i) {
        load_sprite_set(6, "COMSPR", s_i, (u16)(s_i + 0x0D));
    }
    for (s_i = 0x19; s_i <= 0x1C; ++s_i) {
        load_sprite_set(6, "COMSPR", s_i, s_i);
    }
    load_indexed_gfx_record(3, "sky", 0xFA, 1, 0, &g_gfx_sky_280c);
    load_indexed_gfx_record(3, "sky", 0xFB, 1, 0, &g_gfx_sky_2808);
    load_indexed_gfx_record(3, "sky", 0xFC, 1, 0x0D, &g_gfx_sky_2804);

    load_items_table();
    install_effect_handlers();
    install_action_handlers();
}

/*
 * PORT H006+$0914: azzera lo stato per una nuova partita (dopo la fine
 * dell'avventura): stati A, B, C e programma ECL, posizione 7,13 verso
 * est, definizioni dei muri, party vuoto, PC dell'ECL a $3500, velocita'
 * 4, disco 1 e i flag del gioco; contesto 4.
 */
void reset_game_state(void)
{
    h029_fill_bytes(0x7FF, g_state_a, 0x800, 0);
    COK_PUT16(g_state_a + 0x3E8, 3); /* A+$3E8: (word) livello di difficolta' (1..5, iniziale 3) */
    COK_PUT16(g_state_a + 0x1CC, 1); /* A+$1CC: (word) 1 area 3D (mappa 16x16), 0 mappa all'aperto */
    COK_PUT16(g_state_a + 0x1E4, 0); /* A+$1E4: (word) numero dell'area ECL corrente (copia di $2498) */
    h029_fill_bytes(0x7FF, g_state_b, 0x800, 0);
    h029_fill_bytes(0x3FF, g_state_c, 0x400, 0);
    h029_fill_bytes(0x1DFF, g_ecl_buffer, 0x1DFF, 0);
    h029_fill_bytes(7, &H005_B(0x281C), 7, 0); /* $281C: (word) x del party sulla mappa dell'area 16x16 */
    H005_SET_W(0x281C, 7); /* $281C: (word) x del party sulla mappa dell'area 16x16 */
    H005_SET_W(0x281E, 0x0D); /* $281E: (word) y del party sulla mappa dell'area 16x16 */
    H005_B(0x2820) = 2; /* $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
    h029_fill_bytes(2, &H005_B(0x24E4), 3, 1); /* $24E4: opzione Bash disponibile davanti alla porta chiusa */
    H005_B(0x24A2) = 1; /* $24A2: 1: il clic su un nome del party sceglie il personaggio */
    H005_SET_W(0x2810, 0); /* $2810: tab. 3 voci da 4 byte dei set di muri: word id WALLDEF, $FFFF vuoto */
    H005_SET_W(0x2812, 1); /* $2812: word +2 delle voci $2810: posizione (slot 1..3), $FFFF vuoto */
    for (s_i = 2; s_i <= 3; ++s_i) {
        /* $2810: tab. 3 voci da 4 byte dei set di muri: word id WALLDEF, $FFFF vuoto */
        H005_SET_W(0x2810 + (s_i - 1) * 4, 0xFFFF);
        /* $2812: word +2 delle voci $2810: posizione (slot 1..3), $FFFF vuoto */
        H005_SET_W(0x2812 + (s_i - 1) * 4, 0xFFFF);
    }
    H005_B(0x24D2) = 0; /* $24D2: debug attivo ("*" in stato, valori extra) */
    COK_PUT16(g_state_a + 0x3F2, 2); /* A+$3F2: (word) fase (0..3) del ciclo 1: icona cornice colonna 8 */
    COK_PUT16(g_state_a + 0x3F4, 2); /* A+$3F4: (word) fase (0..3) del ciclo 2: icona cornice colonna $13 */
    COK_PUT16(g_state_a + 0x3F6, 2); /* A+$3F6: (word) fase (0..3) del ciclo 3: icona cornice colonna $1E */
    H005_B(0x24CE) = 1; /* $24CE: 1: pausa per carattere nella scrittura del testo */
    H005_B(0x24D1) = 0; /* $24D1: 1 dopo Load Saved Game: l'area non azzera le sue variabili */
    H005_SET_W(0x3DDE, 0); /* $3DDE: (word) passi di riposo dall'ultimo controllo incontri */
    g_party_head = NULL;
    g_current_char = NULL;
    H005_SET_W(0x3DEA, 0x3500); /* $3DEA: (word) PC logico del programma ECL (base $3500) */
    H005_SET_W(0x3DF6, 4); /* $3DF6: (word) velocita' del gioco 0..9 (pausa dei messaggi) */
    H005_B(0x246E) = 1; /* $246E: disco dei dati / gruppo di risorse corrente (G_RESOURCE_GROUP) */
    H005_B(0x246D) = 1; /* $246D: disco dei dati precedente (copia di +$246E) */
    H005_B(0x2825) = 0; /* $2825: flag mappa dall'alto attiva al posto della vista 3D */
    COK_PUT16(g_state_b + 0x67C, 0); /* B+$67C: (word) numero dei membri del party (max 8) */
    H005_SET_W(0x2796, 1); /* $2796: (word) indice della prima voce mostrata nei menu a elenco */
    H005_B(0x24C1) = 0; /* $24C1: uso: azzerato all'avvio; con 1 esito e caduti trattati diversamente */
    H005_B(0x24E2) = 0; /* $24E2: 1 durante il riposo: puntatore d'attesa, messaggi dalla riga $12 */
    H005_B(0x2497) = 0; /* $2497: copia del bit Search ($3E00+$594) durante l'ingresso $3DF2 */
    H005_B(0x24BF) = 0; /* $24BF: uso: 1 dopo il comando ECL $3D (ridisegno), 0 dopo EXIT */
    H005_B(0x24BE) = 0; /* $24BE: uso: azzerato all'avvio e dal comando ECL $33 (a capo) */
    H005_B(0x24BD) = 0; /* $24BD: 1 se l'immagine/ritratto dell'evento e' a schermo */
    H005_B(0x24D0) = 0; /* $24D0: 1 party perduto o uscito: ferma ECL e ciclo dell'esplorazione */
    H005_B(0x24A6) = 1; /* $24A6: uso: solo posto a 1 all'avvio (H006) */
    H005_B(0x24BA) = 0; /* $24BA: 1 se lo sprite SPRIT dell'evento e' a schermo */
    H005_B(0x24A4) = 0; /* $24A4: uso: argomento ignorato di Open_ResourceFile; 1 caricando SPC */
    /* $27A6: nome (8 car.) della sequenza di immagini caricata, vuoto se nessuna */
    H005_B(0x27A6) = 0;                 /* stringa vuota (H006 -$A3) */
    /* $279C: nome (8 car.) della sequenza salvata da Encamp per ricaricarla */
    H005_B(0x279C) = 0;                 /* stringa vuota (H006 -$A5) */
    H005_B(0x2486) = 0xFF; /* $2486: id della sequenza caricata in $27BC (nome a $27A6), $FF nessuna */
    H005_B(0x2485) = 0xFF; /* $2485: id della sequenza salvato entrando al campo, ricaricato all'uscita */
    H005_B(0x24A3) = 0; /* $24A3: 1 se la partita e' salvata (avviso all'uscita); letto da eff. $36 */
    H005_B(0x247E) = 0xE8; /* $247E: uso: $E8 all'avvio, 9 a inizio area; scritto da ECL var $755F */
    H005_B(0x247F) = 0xDB; /* $247F: uso: $DB all'avvio, $41 a inizio area; scritto da ECL var $7559 */
    H005_B(0x24B4) = 0; /* $24B4: 1 durante il comando ENCOUNTER */
    H005_B(0x24C6) = 1; /* $24C6: 1 se le azioni del combattente vanno disegnate (visibile) */
    H005_B(0x2484) = 0xFF; /* $2484: id dell'immagine grande BIGPIC caricata ($FF nessuna) */
    H005_B(0x24AD) = 0; /* $24AD: uso: solo azzerato all'avvio (H006) */
    H005_B(0x24CF) = 0; /* $24CF: 1 durante la creazione: Train senza messaggi ne' domande */
    clear_message_line();
    H005_B(0x2483) = 1; /* $2483: indice dell'opzione selezionata nei menu a riga (persistente) */
    H005_B(0x3DE3) = 4; /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
    H005_B(0x3DE2) = 0; /* $3DE2: contesto di gioco precedente (copia di $3DE3), salvato */
    H005_B(0x24A7) = 1; /* $24A7: uso: 1 ferma l'audio attorno alle scene, 0 riavvia H043 */
    H005_B(0x24E0) = 0; /* $24E0: 1: gli effetti passano al gestore $2A0E (oggetti magici) */
    H005_B(0x24B1) = 0; /* $24B1: uso: solo azzerato all'avvio (H006) */
    g_dropped_items = NULL;
    H005_B(0x24CB) = 0; /* $24CB: 1 nel modo Move/Attack: cursore sulla mappa di combattimento */
    H005_B(0x24CC) = 0; /* $24CC: 1 nel modo Manual: cursore sulla mappa di combattimento */
    H005_B(0x24B0) = 0; /* $24B0: modo Move dell'esplorazione: clic sulla vista come movimento */
    H005_B(0x249E) = 0; /* $249E: 1 se il tasto viene dal mouse (clic) */
    H005_B(0x24D8) = 0; /* $24D8: modo di scelta membro: il clic va in $2508 e non nel corrente */
    H005_B(0x24DA) = 0; /* $24DA: 1 in Modify Character: il clic sceglie il campo ($2506) */
    H005_B(0x24AE) = 0; /* $24AE: 1 con un'immagine grande a tutto schermo: niente elenco party */
}
