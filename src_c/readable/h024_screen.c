/* H024: building of NewScreen and OpenScreen. */
#include "h024_screen.h"
#include "h021_intuition.h"

#if COK_AMIGA
#include <graphics/gfxbase.h>
extern struct GfxBase *GfxBase;
#endif

/* Module data (offsets from a4). */
u16 g_h024_m2;                  /* -$2: GfxBase->NormalDisplayColumns */
u16 g_h024_m4;                  /* -$4: GfxBase->NormalDisplayRows */
u8  g_h024_m5;                  /* -$5: DetailPen (never written, 0) */
u8  g_h024_m6;                  /* -$6: BlockPen */
u16 g_h024_m8;                  /* -$8: LeftEdge (0) */
u16 g_h024_ma;                  /* -$A: TopEdge (0) */
struct TextAttr *g_h024_me;     /* -$E: Font (NULL) */
struct BitMap *g_h024_m12;      /* -$12: CustomBitMap (NULL) */
u16 g_h024_m14;                 /* -$14 (H024+$4): Type bits besides CUSTOMSCREEN; H029+$1210 writes $10F there */

/*
 * PORT H024+$001C.  On the host there is no GfxBase: the NTSC values are
 * used (640 columns, 200 rows).
 */
void h024_init(void)
{
#if COK_AMIGA
    g_h024_m2 = GfxBase->NormalDisplayColumns;
    g_h024_m4 = GfxBase->NormalDisplayRows;
#else
    g_h024_m2 = 640;
    g_h024_m4 = 200;
#endif
    g_h024_m6 = 1;
}

/*
 * PORT H024+$002A (Open_GameScreen): HIRES if the width exceeds half
 * the display columns, LACE if the height exceeds the rows, HAM with
 * depth 6.  The width comparison is signed (ble).
 */
struct Screen *open_game_screen(u16 width, u16 height, u16 depth,
                                const char *title)
{
    struct NewScreen ns;
    u16 modes = 0;

    if ((s16)width > (s16)((s16)g_h024_m2 / 2)) {
        modes |= 0x8000;        /* HIRES */
    }
    if ((s16)height > (s16)g_h024_m4) {
        modes |= 0x0004;        /* LACE */
    }
    if (depth == 6) {
        modes |= 0x0800;        /* HAM */
    }
    ns.LeftEdge = (WORD)g_h024_m8;
    ns.TopEdge = (WORD)g_h024_ma;
    ns.Width = (WORD)width;
    ns.Height = (WORD)height;
    ns.Depth = (WORD)depth;
    ns.DetailPen = g_h024_m5;
    ns.BlockPen = g_h024_m6;
    ns.ViewModes = modes;
    ns.Type = (UWORD)(g_h024_m14 | 0x000F);     /* CUSTOMSCREEN */
    ns.Font = g_h024_me;
    ns.DefaultTitle = (UBYTE *)title;
    ns.Gadgets = NULL;
    ns.CustomBitMap = g_h024_m12;
    return intuition_open_screen(&ns);
}
