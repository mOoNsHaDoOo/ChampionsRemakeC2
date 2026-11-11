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

    if (H005_B(0x2486) == 9) {
        H005_B(0x24E1) = 0;
    }
    if (H005_B(0x24D0)) {
        return;
    }
    if (COK_GET16(g_state_a + 0x1CC)) {
        H005_B(0x2822) = map_flags((s16)H005_W(0x281C), (s16)H005_W(0x281E));
        if (H005_B(0x2822) > 0x7F) {
            idx = COK_GET16(g_state_a + 0x1FC);
        } else {
            idx = COK_GET16(g_state_a + 0x1FA);
        }
        H005_B(0x2829) = (u8)(idx < 16 ? sky[idx] : 0);
        H005_B(0x2826) = 8;
        debug_trace(4, "lost", (u8)COK_GET16(g_state_a + 0x1F6), 0, 0);
        if (COK_GET16(g_state_a + 0x1F6)) {
            H005_B(0x2825) = 0;
        }
        draw_3d_view((s16)H005_W(0x281C), (s16)H005_W(0x281E), H005_B(0x2820));
    } else if (H005_B(0x24E1)) {
        show_big_picture();
    }
    H005_B(0x24E1) = 0;
}
