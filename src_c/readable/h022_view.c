/* H022: adattatori graphics.library per view, palette e viewport. */
#include "h022_view.h"

/* PORT H022+$0008: copia GfxBase nella cella del modulo (vedi H016). */
void h022_init(void)
{
}

#if COK_AMIGA
#include <proto/graphics.h>
#endif

/*
 * PORT H022+$0084.  colors sono word RGB4 big-endian (dati del gioco): su
 * Amiga e' gia' il formato di LoadRGB4; sull'host LoadRGB4 emulata le
 * legge a byte (vedi host/ndk.h).
 */
void graphics_load_rgb4(struct ViewPort *vp, const u8 *colors, u16 count)
{
    LoadRGB4(vp, (UWORD *)colors, (LONG)count);
}

/* PORT H022+$0038 */
struct ColorMap *graphics_get_color_map(u32 entries)
{
    return GetColorMap((LONG)entries);
}

/* PORT H022+$0060 */
void graphics_init_view(struct View *view)
{
    InitView(view);
}

/* PORT H022+$0072 */
void graphics_init_vport(struct ViewPort *vp)
{
    InitVPort(vp);
}

/* PORT H022+$00A0 */
void graphics_load_view(struct View *view)
{
    LoadView(view);
}

/* PORT H022+$00B2 */
void graphics_make_vport(struct View *view, struct ViewPort *vp)
{
    MakeVPort(view, vp);
}

/* PORT H022+$00C8 */
void graphics_mrg_cop(struct View *view)
{
    MrgCop(view);
}

/* PORT H022+$0014 */
void graphics_free_color_map(struct ColorMap *cm)
{
    FreeColorMap(cm);
}

/* PORT H022+$0026 */
void graphics_free_vport_cop_lists(struct ViewPort *vp)
{
    FreeVPortCopLists(vp);
}
