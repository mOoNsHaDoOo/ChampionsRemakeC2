/* H022: adattatori graphics.library per view, palette e viewport. */
#ifndef COK_H022_VIEW_H
#define COK_H022_VIEW_H

#include "cok.h"

void graphics_free_color_map(struct ColorMap *cm);       /* H022+$0014 */
void graphics_free_vport_cop_lists(struct ViewPort *vp); /* H022+$0026 */
struct ColorMap *graphics_get_color_map(u32 entries);   /* H022+$0038 */
void graphics_init_view(struct View *view);             /* H022+$0060 */
void graphics_init_vport(struct ViewPort *vp);          /* H022+$0072 */
void graphics_load_view(struct View *view);             /* H022+$00A0 */
void graphics_make_vport(struct View *view, struct ViewPort *vp); /* H022+$00B2 */
void graphics_mrg_cop(struct View *view);               /* H022+$00C8 */
void graphics_load_rgb4(struct ViewPort *vp, const u8 *colors, u16 count);
                                                        /* H022+$0084 */
void graphics_attach_view_mode(struct View *view, struct ViewPort *vp,
                               struct ViewPort *mode_vp); /* non nell'originale */
void graphics_detach_view_mode(struct View *view);      /* non nell'originale */
#endif
