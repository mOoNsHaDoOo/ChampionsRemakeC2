/* H025: building of NewWindow and OpenWindow. */
#include "h025_window.h"
#include "h021_intuition.h"

#if COK_AMIGA
#include <graphics/gfxbase.h>
extern struct GfxBase *GfxBase;
#endif

/* Module data (offsets from a4). */
u8  g_h025_m1;                  /* -$1 */
u8  g_h025_m2;                  /* -$2 */
struct Image *g_h025_m6;        /* -$6: CheckMark (NULL) */
struct BitMap *g_h025_ma;       /* -$A: BitMap (NULL) */
u16 g_h025_mc;                  /* -$C */
u16 g_h025_me;                  /* -$E: GfxBase->NormalDisplayColumns */
u16 g_h025_m10;                 /* -$10 */
u16 g_h025_m12;                 /* -$12: GfxBase->NormalDisplayRows */

/* PORT H025+$001A (on the host: NTSC values, see H024). */
void h025_init(void)
{
    g_h025_m1 = 0xFF;
    g_h025_m2 = 0xFF;
    g_h025_mc = 0x28;
#if COK_AMIGA
    g_h025_me = GfxBase->NormalDisplayColumns;
    g_h025_m12 = GfxBase->NormalDisplayRows;
#else
    g_h025_me = 640;
    g_h025_m12 = 200;
#endif
    g_h025_m10 = 0x28;
}

/*
 * PORT H025+$0028 (Open_GameWindow): Type WBENCHSCREEN without a screen,
 * otherwise CUSTOMSCREEN.
 */
struct Window *open_game_window(u16 left, u16 top, u16 width, u16 height,
                                u32 idcmp, u32 flags, struct Gadget *gadgets,
                                struct Screen *screen, const char *title)
{
    struct NewWindow nw;

    nw.LeftEdge = (WORD)left;
    nw.TopEdge = (WORD)top;
    nw.Width = (WORD)width;
    nw.Height = (WORD)height;
    nw.DetailPen = g_h025_m1;
    nw.BlockPen = g_h025_m2;
    nw.IDCMPFlags = idcmp;
    nw.Flags = flags;
    nw.FirstGadget = gadgets;
    nw.CheckMark = g_h025_m6;
    nw.Title = (UBYTE *)title;
    nw.Screen = screen;
    nw.BitMap = g_h025_ma;
    nw.MinWidth = (WORD)g_h025_mc;
    nw.MinHeight = (WORD)g_h025_m10;
    nw.MaxWidth = g_h025_me;
    nw.MaxHeight = g_h025_m12;
    nw.Type = screen == NULL ? 0x0001 : 0x000F;
    return intuition_open_window(&nw);
}
