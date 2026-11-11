/* H021: adattatori intuition.library. */
#include "h021_intuition.h"

/* PORT H021+$0008: copia IntuitionBase (-$10(a4) del runtime H015). */
void h021_init(void)
{
}

#if COK_AMIGA
#include <proto/intuition.h>
#else
#include <time.h>
#endif

/* PORT H021+$0030 */
void intuition_current_time(u32 *seconds, u32 *micros)
{
#if COK_AMIGA
    CurrentTime((ULONG *)seconds, (ULONG *)micros);
#else
    /* Host: secondi dall'orologio di sistema, microsecondi dal clock(). */
    *seconds = (u32)time(NULL);
    *micros = (u32)(clock() % 1000000);
#endif
}

/*
 * Adattatori semplici: argomenti dallo stack ai registri e salto nella
 * libreria (sull'host la libreria e' emulata in host/intuition.c).
 */

/* PORT H021+$010C */
void intuition_close_screen(struct Screen *screen)
{
    CloseScreen(screen);
}

/* PORT H021+$011E: restituisce d0 cosi' com'e' (nessun neg.b). */
u32 intuition_close_workbench(void)
{
    return (u32)CloseWorkBench();
}

/* PORT H021+$0184 */
struct Screen *intuition_open_screen(struct NewScreen *ns)
{
    return OpenScreen(ns);
}

/* PORT H021+$0196 */
u32 intuition_open_workbench(void)
{
    return (u32)OpenWorkBench();
}

/* PORT H021+$01D2: il flag e' un byte esteso a long (moveq #0 / move.b). */
void intuition_show_title(struct Screen *screen, u8 show)
{
    ShowTitle(screen, (LONG)show);
}

/* PORT H021+$01FA */
void intuition_activate_window(struct Window *window)
{
    ActivateWindow(window);
}

/* PORT H021+$0230 */
void intuition_clear_pointer(struct Window *window)
{
    ClearPointer(window);
}

/* PORT H021+$0242 */
void intuition_close_window(struct Window *window)
{
    CloseWindow(window);
}

/* PORT H021+$029C */
struct Window *intuition_open_window(struct NewWindow *nw)
{
    return OpenWindow(nw);
}

/* PORT H021+$03AE */
u32 intuition_auto_request(struct Window *window, struct IntuiText *body,
                           struct IntuiText *pos, struct IntuiText *neg,
                           u32 pos_flags, u32 neg_flags, u16 width,
                           u16 height)
{
    return (u32)AutoRequest(window, body, pos, neg, pos_flags, neg_flags,
                            (LONG)width, (LONG)height);
}

/* PORT H021+$02EE: le misure sono word estese con segno (move.w). */
void intuition_set_pointer(struct Window *window, u8 *data, u16 height,
                           u16 width, u16 x_offset, u16 y_offset)
{
    SetPointer(window, (UWORD *)data, (s16)height, (s16)width, (s16)x_offset,
               (s16)y_offset);
}

/* PORT H021+$026C */
void intuition_modify_idcmp(struct Window *window, u32 flags)
{
    ModifyIDCMP(window, flags);
}
