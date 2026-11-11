/* H060: inizializzazione di area/vista e transizioni. */
#include "cok.h"
#include "h060.h"
#include "globals.h"
#include "unported.h"
#include "h042_seq.h"
#include "h011.h"
#include "h056.h"

/* PORT H060+$000A: link/unlk, nessun effetto. */
void h060_init(void)
{
}

/*
 * PORT H060+$0018: ridisegna la vista dell'esplorazione.  Nel dungeon
 * ($3E04+$1CC) sceglie il colore del cielo dalla tabella locale con
 * $3E04+$1FC (casella col bit 7 dei flag) o $1FA, toglie la mappa se
 * l'area la vieta ($1F6) e disegna la vista 3D; all'aperto, se richiesto
 * ($24E1), ridisegna l'immagine (H042+$10DC).  Un indice di colore oltre
 * la tabella leggerebbe lo stack nell'originale: qui 0.
 */
void refresh_view(void)
{
    static const u8 sky[16] = {         /* -$20(a5) */
        0x00, 0x0F, 0x04, 0x0B, 0x0D, 0x02, 0x09, 0x0E,
        0x00, 0x0F, 0x04, 0x0B, 0x0D, 0x02, 0x09, 0x0E
    };
    u16 idx;

    if (H005_B(0x2486) == 9) { /* $2486: id della sequenza caricata in $27BC (nome a $27A6), $FF nessuna */
        H005_B(0x24E1) = 0; /* $24E1: 1: immagine/vista dell'esplorazione da ridisegnare */
    }
    if (H005_B(0x24D0)) { /* $24D0: 1 party perduto o uscito: ferma ECL e ciclo dell'esplorazione */
        return;
    }
    if (COK_GET16(g_state_a + 0x1CC)) { /* A+$1CC: (word) 1 area 3D (mappa 16x16), 0 mappa all'aperto */
        /* $2822: flag della casella del party (map_flags); bit 7 sceglie il cielo; $281C: (word) x
         * del party sulla mappa dell'area 16x16; $281E: (word) y del party sulla mappa dell'area
         * 16x16 */
        H005_B(0x2822) = map_flags((s16)H005_W(0x281C), (s16)H005_W(0x281E));
        /* $2822: flag della casella del party (map_flags); bit 7 sceglie il cielo */
        if (H005_B(0x2822) > 0x7F) {
            /* A+$1FC: (word) indice colore del cielo per caselle col bit 7 dei flag */
            idx = COK_GET16(g_state_a + 0x1FC);
        } else {
            /* A+$1FA: (word) indice colore del cielo per caselle senza bit 7 dei flag */
            idx = COK_GET16(g_state_a + 0x1FA);
        }
        /* $2829: colore del cielo della vista (1o byte di partenza vista) */
        H005_B(0x2829) = (u8)(idx < 16 ? sky[idx] : 0);
        H005_B(0x2826) = 8; /* $2826: uso: 4o byte di partenza vista (arg d di H011+$04A6), 8 nel dungeon */
        /* A+$1F6: (word) area senza mappa: coordinate nascoste, mappa "Not Here" */
        debug_trace(4, "lost", (u8)COK_GET16(g_state_a + 0x1F6), 0, 0);
        /* A+$1F6: (word) area senza mappa: coordinate nascoste, mappa "Not Here" */
        if (COK_GET16(g_state_a + 0x1F6)) {
            H005_B(0x2825) = 0; /* $2825: flag mappa dall'alto attiva al posto della vista 3D */
        }
        /* $281C: (word) x del party sulla mappa dell'area 16x16; $281E: (word) y del party sulla
         * mappa dell'area 16x16; $2820: direzione del party (0 nord, 2 est, 4 sud, 6 ovest) */
        draw_3d_view((s16)H005_W(0x281C), (s16)H005_W(0x281E), H005_B(0x2820));
    } else if (H005_B(0x24E1)) { /* $24E1: 1: immagine/vista dell'esplorazione da ridisegnare */
        show_big_picture();
    }
    H005_B(0x24E1) = 0; /* $24E1: 1: immagine/vista dell'esplorazione da ridisegnare */
}
