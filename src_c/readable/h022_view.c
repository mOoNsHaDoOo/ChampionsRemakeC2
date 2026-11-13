/* H022: graphics.library adapters for view, palette and viewport. */
#include "h022_view.h"

/* PORT H022+$0008: copies GfxBase into the module cell (see H016). */
void h022_init(void)
{
}

#if COK_AMIGA
#include <proto/graphics.h>
#endif

/*
 * PORT H022+$0084.  colors are big-endian RGB4 words (game data): on the
 * Amiga this is already the LoadRGB4 format; on the host the emulated
 * LoadRGB4 reads them byte by byte (see host/ndk.h).
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
