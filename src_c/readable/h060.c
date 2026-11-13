/* H060: initialisation of area/view and transitions. */
#include "cok.h"
#include "h060.h"
#include "globals.h"
#include "unported.h"
#include "h042_seq.h"
#include "h011.h"
#include "h056.h"

/* PORT H060+$000A: link/unlk, no effect. */
void h060_init(void)
{
}

/*
 * PORT H060+$0018: redraws the exploration view.  In the dungeon
 * ($3E04+$1CC) it picks the sky colour from the local table with
 * $3E04+$1FC (square with bit 7 of the flags) or $1FA, removes the map if
 * the area forbids it ($1F6) and draws the 3D view; outdoors, if requested
 * ($24E1), it redraws the picture (H042+$10DC).  A colour index beyond
 * the table would read the stack in the original: here 0.
 */
void refresh_view(void)
{
    static const u8 sky[16] = {         /* -$20(a5) */
        0x00, 0x0F, 0x04, 0x0B, 0x0D, 0x02, 0x09, 0x0E,
        0x00, 0x0F, 0x04, 0x0B, 0x0D, 0x02, 0x09, 0x0E
    };
    u16 idx;

    if (H005_B(0x2486) == 9) { /* $2486: id of the sequence loaded at $27BC (name at $27A6), $FF none */
        H005_B(0x24E1) = 0; /* $24E1: 1: exploration picture/view to be redrawn */
    }
    if (H005_B(0x24D0)) { /* $24D0: 1 party lost or gone out: stops ECL and the exploration loop */
        return;
    }
    if (COK_GET16(g_state_a + 0x1CC)) { /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
        /* $2822: flags of the party square (map_flags); bit 7 picks the sky; $281C: (word) party x
         * on the 16x16 area map; $281E: (word) party y on the 16x16 area
         * map */
        H005_B(0x2822) = map_flags((s16)H005_W(0x281C), (s16)H005_W(0x281E));
        /* $2822: flags of the party square (map_flags); bit 7 picks the sky */
        if (H005_B(0x2822) > 0x7F) {
            /* A+$1FC: (word) sky colour index for squares with bit 7 of the flags */
            idx = COK_GET16(g_state_a + 0x1FC);
        } else {
            /* A+$1FA: (word) sky colour index for squares without bit 7 of the flags */
            idx = COK_GET16(g_state_a + 0x1FA);
        }
        /* $2829: sky colour of the view (1st view start byte) */
        H005_B(0x2829) = (u8)(idx < 16 ? sky[idx] : 0);
        H005_B(0x2826) = 8; /* $2826: use: 4th view start byte (arg d of H011+$04A6), 8 in the dungeon */
        /* A+$1F6: (word) area without a map: coordinates hidden, map "Not Here" */
        debug_trace(4, "lost", (u8)COK_GET16(g_state_a + 0x1F6), 0, 0);
        /* A+$1F6: (word) area without a map: coordinates hidden, map "Not Here" */
        if (COK_GET16(g_state_a + 0x1F6)) {
            H005_B(0x2825) = 0; /* $2825: top-down map flag, active instead of the 3D view */
        }
        /* $281C: (word) party x on the 16x16 area map; $281E: (word) party y on the
         * 16x16 area map; $2820: party direction (0 north, 2 east, 4 south, 6 west) */
        draw_3d_view((s16)H005_W(0x281C), (s16)H005_W(0x281E), H005_B(0x2820));
    } else if (H005_B(0x24E1)) { /* $24E1: 1: exploration picture/view to be redrawn */
        show_big_picture();
    }
    H005_B(0x24E1) = 0; /* $24E1: 1: exploration picture/view to be redrawn */
}
