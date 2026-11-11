/*
 * Dati globali.
 *
 * H005 e' l'hunk dei dati condivisi: qui e' un'immagine di $531C byte con la
 * stessa disposizione dell'originale (word e long big-endian), perche' il
 * gioco vi accede a byte e a word sugli stessi indirizzi e ne salva
 * intervalli contigui.  I campi gia' identificati hanno un nome (macro o
 * accessore); gli altri si leggono con H005_B/H005_W/H005_L e l'offset.
 * I puntatori dell'originale (32 bit) non stanno qui: sono variabili C.
 */
#ifndef COK_GLOBALS_H
#define COK_GLOBALS_H

#include "cok.h"
#include "gfx_record.h"

#define H005_SIZE 0x531Cu

extern u8 g_h005[H005_SIZE];

#define H005_B(off)        (g_h005[(off)])
#define H005_W(off)        COK_GET16(&g_h005[(off)])
#define H005_L(off)        COK_GET32(&g_h005[(off)])
#define H005_SET_W(off, v) COK_PUT16(&g_h005[(off)], (v))
#define H005_SET_L(off, v) do { u32 cok_v_ = (u32)(v); \
                               COK_PUT16(&g_h005[(off)], cok_v_ >> 16); \
                               COK_PUT16(&g_h005[(off) + 2], cok_v_); } while (0)

/* Campi identificati. */
#define G_RESOURCE_GROUP   H005_B(0x246E)  /* 1 gioco, 2 demo, 0 fine demo */
#define G_DEMO_FLAG        H005_B(0x24D7)  /* 1 se e' stata scelta Demo */
#define G_PROMPT_TIMEOUT   ((s32)H005_L(0x2792)) /* attesa in 1/100 s */
/* $2792: (long) tempo massimo di attesa della scelta, in 1/100 s (0 nessuno) */
#define G_SET_PROMPT_TIMEOUT(v) H005_SET_L(0x2792, (u32)(v))
#define G_VIEW_START(i)    H005_B(0x2826 + (i))  /* argomenti di H011+$04A6 */
#define G_DATA_PREFIX      ((char *)&g_h005[0x3D26]) /* "df0:" o "", $51 byte */
#define G_PROMPT_KEY       H005_B(0x52FB)  /* tasto al termine dell'attesa */
#define G_KEY              H005_B(0x5305)  /* tasto/azione pendente (H010) */
#define G_MOUSE_CLICK      H005_B(0x249E)  /* 1 se il tasto viene dal mouse */

/*
 * Puntatori tenuti in H005 (long nell'originale): variabili C, perche' sul
 * host un puntatore non sta in 32 bit.  Le celle corrispondenti di g_h005
 * restano inutilizzate.
 */

extern u8 *g_state_a;                   /* $3E04: stato persistente A, $800 */
extern u8 *g_state_b;                   /* $3E00: stato persistente B, $800 */
extern u8 *g_state_c;                   /* $3DFC: stato persistente C, $400 */
extern u8 *g_ecl_buffer;                /* $3DF8: programma ECL, $1E00 */
extern u8 *g_h005_282e;                 /* $282E: blocco di $924 byte */
extern u8 *g_geo_planes;                /* $282A: quattro piani dati GEO, $400 */
extern struct GfxRecord *g_gfx_332c;    /* $332C */
extern struct GfxRecord *g_gfx_3334;    /* $3334 */
extern struct GfxRecord *g_gfx_3348;    /* $3348 */
extern struct GfxRecord *g_gfx_3d8a;    /* $3D8A */
extern struct GfxRecord *g_gfx_243a;    /* $243A: icone del combattimento */
extern struct GfxRecord *g_gfx_3d8e;    /* $3D8E: bitmap 320x200 fuori schermo */
extern struct GfxRecord *g_gfx_sky_2804; /* $2804: "sky" $FC */
extern struct GfxRecord *g_gfx_sky_2808; /* $2808: "sky" $FB */
extern struct GfxRecord *g_gfx_sky_280c; /* $280C: "sky" $FA */
extern struct Screen *g_screen;         /* $52F2: schermo del gioco */
extern struct Window *g_window;         /* $52F6: finestra del gioco */
extern struct RastPort *g_rastport;     /* $52EE: RastPort della finestra */
extern struct GfxRecord *g_gfx_2798;    /* $2798 */
extern struct GfxRecord *g_gfx_27b0[2]; /* $27B2, $27B8: record di due voci da 6 byte */
extern u8 *g_h005_52fc;                 /* $52FC: blocco di $34 byte */
extern u8 *g_h005_5300;                 /* $5300: blocco di $34 byte */
extern u8 *g_dax_buffer;                /* $3C7E: blocco DAX compresso */
extern struct GfxRecord *g_8x8_sets[5]; /* $3338: set 8x8 caricati da H034 */
extern struct GfxRecord *g_sprite_sets[29][2]; /* $3244: coppie di set 24x24 */
extern struct GfxRecord *g_pic_rec_27c2; /* $27C2: immagine dell'insieme $27BC */
extern struct GfxRecord *g_pic_rec_27c6; /* $27C6 */
extern u8 *g_pic_buffers[7];            /* $27E8: blocchi 2..8 dell'insieme */
#include "character.h"
extern struct Character *g_party_head;  /* $3364: testa della lista del party */
extern struct Character *g_current_char;/* $3368: personaggio corrente */
extern struct Character *g_h005_2508;   /* $2508: personaggio scelto */
extern struct Character *g_spell_target;/* $251C: bersaglio scelto */
extern struct Character *g_spell_targets[40]; /* $2520..$25BF: bersagli */
extern CokItem *g_scroll_item;
extern u8 *g_combat_area;               /* $2ADE: mappa del combattimento ($9CE byte) */
/* Nube (Stinking Cloud e simili), record di $22 byte della lista $2514. */
typedef struct CokCloud {
    struct Character *owner;            /* +$00 */
    struct CokCloud *next;              /* +$04 */
    u8 b[0x22];                         /* +$08..: posizioni, +$1C/+$1E, +$20, +$21 */
} CokCloud;
extern CokCloud *g_clouds;              /* $2514 */
extern CokCloud *g_acid_pools;          /* $250C: pozze d'acido (stessi record) */
extern struct Character *g_h005_2a14;   /* $2A14: bersaglio del turno in esame */
extern struct Character *g_combatants[40]; /* $2B32..$2BD1: combattenti per numero */
extern struct Character *g_h005_0016[20]; /* $16..$65: personaggi a terra ($14 = quanti) */
/* Arma persa in combattimento: copia dei $48 byte dell'oggetto + chi l'ha persa. */
typedef struct CokDropped {
    u8 b[0x48];                         /* +$00: copia dell'oggetto */
    struct Character *owner;            /* +$48 */
    struct CokDropped *next;            /* +$4C */
} CokDropped;
extern CokDropped *g_dropped_items;     /* $3360 */
/* Personaggio caduto sulla mappa (H005+$2AE2, 8 voci da $A byte, $247A usate). */
typedef struct CokBody {
    struct Character *who;              /* +$00 */
    u16 x;                              /* +$04 */
    u16 y;                              /* +$06 */
    u8 tile;                            /* +$08: contenuto salvato della casella */
} CokBody;
extern CokBody g_bodies[8];             /* $2AE2 */
extern CokItem *g_treasure_items;       /* $2A3A: oggetti del tesoro */
extern CokItem *g_thrown_tail;          /* $335C: ultima arma lanciata messa nel tesoro */
extern struct Character *g_h005_2432;   /* $2432: bersaglio preferito (effetto $5B) */

/*
 * Tabelle di gestori in H005 (puntatori a codice nell'originale).  Il tipo
 * e' generico finche' non si porta chi le chiama.
 */
typedef void (*CokHandler)(void);
extern CokHandler g_handlers_25c0[108]; /* $25C0..$276C: azioni (H033) */
extern CokHandler g_handlers_2832[120]; /* $2832..$2A0E: effetti (H027/H033) */

/* Dati di altri moduli. */
extern int g_argc;                 /* argomenti (H015+$8: argv) */
extern char **g_argv;
extern u16 g_distribution_check;
extern u8  g_h047_0001;            /* H047+$0001 (-$1(a4) di H047) */   /* H009+$0000: $3F8F dopo la verifica */

#endif
