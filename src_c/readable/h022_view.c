/* H022: graphics.library adapters for view, palette and viewport. */
#include "h022_view.h"

/* PORT H022+$0008: copies GfxBase into the module cell (see H016). */
void h022_init(void)
{
}

#if COK_AMIGA
#include <proto/graphics.h>
#include <graphics/videocontrol.h>
#include <graphics/displayinfo.h>
#include <graphics/gfxnodes.h>
#include <graphics/monitor.h>
#include <graphics/modeid.h>

static struct ViewExtra *s_vextra;
static struct ViewPortExtra *s_vpextra;
static struct MonitorSpec *s_monspec;
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

/*
 * Not in the original.  On graphics.library V36+ a View without a ViewExtra
 * is shown with the default monitor: if it differs from the one of the
 * screen (for example DblPAL in DEVS:Monitors), every LoadView that alternates
 * this View and the Intuition one changes BEAMCON0 and the display flashes.
 * Here view and vp get the monitor and the mode of mode_vp (the game
 * screen).  To be called after GetColorMap and before MakeVPort/MrgCop.
 * If something fails, the View stays as it is (1.3 behaviour).
 */
void graphics_attach_view_mode(struct View *view, struct ViewPort *vp,
                               struct ViewPort *mode_vp)
{
#if COK_AMIGA
    ULONG mode;
    DisplayInfoHandle handle;
    struct DimensionInfo dims;
    struct TagItem tags[4];

    if (((struct Library *)GfxBase)->lib_Version < 36) {
        return;
    }
    mode = GetVPModeID(mode_vp);
    if (mode == INVALID_ID) {
        mode = ((GfxBase->DisplayFlags & PAL) ? PAL_MONITOR_ID
                                              : NTSC_MONITOR_ID) | LORES_KEY;
    }
    handle = FindDisplayInfo(mode);
    if (handle == NULL ||
        GetDisplayInfoData(handle, (UBYTE *)&dims, sizeof(dims), DTAG_DIMS,
                           mode) == 0) {
        return;
    }

    s_vextra = (struct ViewExtra *)GfxNew(VIEW_EXTRA_TYPE);
    s_vpextra = (struct ViewPortExtra *)GfxNew(VIEWPORT_EXTRA_TYPE);
    s_monspec = OpenMonitor(NULL, mode);
    if (s_vextra == NULL || s_vpextra == NULL || s_monspec == NULL) {
        graphics_detach_view_mode(view);
        return;
    }
    s_vextra->Monitor = s_monspec;
    GfxAssociate(view, (struct ExtendedNode *)s_vextra);
    view->Modes |= EXTEND_VSTRUCT;

    s_vpextra->DisplayClip = dims.Nominal;
    tags[0].ti_Tag = VTAG_ATTACH_CM_SET;
    tags[0].ti_Data = (ULONG)vp;
    tags[1].ti_Tag = VTAG_VIEWPORTEXTRA_SET;
    tags[1].ti_Data = (ULONG)s_vpextra;
    tags[2].ti_Tag = VTAG_NORMAL_DISP_SET;
    tags[2].ti_Data = (ULONG)handle;
    tags[3].ti_Tag = VTAG_END_CM;
    tags[3].ti_Data = 0;
    if (VideoControl(vp->ColorMap, tags) != 0) {
        graphics_detach_view_mode(view);
        return;
    }
    vp->Modes = (UWORD)(mode & 0xFFFF);
#else
    (void)view;
    (void)vp;
    (void)mode_vp;
#endif
}

/*
 * Not in the original.  Frees what graphics_attach_view_mode
 * allocated; to be called after FreeColorMap and
 * FreeVPortCopLists.
 */
void graphics_detach_view_mode(struct View *view)
{
#if COK_AMIGA
    if (s_vpextra != NULL) {
        GfxFree((struct ExtendedNode *)s_vpextra);
        s_vpextra = NULL;
    }
    if (s_monspec != NULL) {
        CloseMonitor(s_monspec);
        s_monspec = NULL;
    }
    if (s_vextra != NULL) {
        GfxFree((struct ExtendedNode *)s_vextra);
        s_vextra = NULL;
    }
    view->Modes &= ~EXTEND_VSTRUCT;
#else
    (void)view;
#endif
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
