/* H029: graphic records, bitplanes, masks and tile drawing. */
#ifndef COK_H029_GFX_H
#define COK_H029_GFX_H

#include "cok.h"
#include "gfx_record.h"


void allocate_gfx_record(u16 rows, u16 count, u16 width8, u16 with_mask,
                         struct GfxRecord **rec);       /* H029+$0408 */
void free_pointer_data(void);           /* H029+$0180 */
void set_pointer_shape(s16 shape);      /* H029+$01B6 */
void add_to_byte(u8 *value, u16 delta); /* H029+$03E2 */
u8   mask_byte(u8 value, u16 mask);     /* H029+$0354 */
u8   xor_byte(u8 value, u16 mask);      /* H029+$0376 */
u8   or_byte(u8 value, u16 mask);       /* H029+$039A */
void build_gfx_mask(u8 color, struct GfxRecord *r);     /* H029+$0766 */
void fill_cells(u16 col, u16 row, u16 width, u16 height, u8 pen,
                struct GfxRecord *unused);              /* H029+$10B8 */

/* Module data used elsewhere (-$4, -$5, -$6, -$9 below a4). */
extern struct RastPort *g_offscreen_rp; /* H029+$66 */
extern u8 g_h029_m5;                    /* H029+$65 */
extern u8 g_h029_m6;                    /* H029+$64 */
extern u8 g_h029_m9;                    /* H029+$61 */
extern u16 g_h029_m8;                   /* H029+$62: View being shown (H029+$1576) */
void remap_gfx_colors(const u8 from[16], const u8 to[16], s16 frame,
                      struct GfxRecord *rec);           /* H029+$0EFE */
void transfer_gfx_planes(const u8 *data, u16 offset, u16 last_plane,
                         u8 mask_color, struct GfxRecord **rec);
                                                        /* H029+$091E */
void free_gfx_record(struct GfxRecord **rec);           /* H029+$067A */
void load_indexed_gfx_record(u16 name_len, const char *name, u16 id,
                             u16 with_mask, u8 mask_color,
                             struct GfxRecord **rec);   /* H029+$0A0E */
void prepare_display_resources(void);   /* H029+$1346 */
void release_display_resources(void);   /* H029+$148E */
void open_game_display(void);           /* H029+$1206 */
void close_game_display(void);          /* H029+$12BC */
void h029_fill_bytes(u16 unused, u8 *dst, u16 count, u8 value); /* H029+$0312 */
void wait_screen_in_front(void);        /* H029+$14F6 */
void copy_screen_to_offscreen(void);    /* H029+$1520 */
void swap_display_view(void);           /* H029+$1576 */
void begin_screen_update(void);         /* H029+$16A2 */
void end_screen_update(void);           /* H029+$16DE */
void copy_intuition_colors(void);       /* H029+$1718 */
void draw_tile24(u16 x, u16 y, u8 frame, u8 masked, struct GfxRecord *src,
                 struct GfxRecord *unused);             /* H029+$0B94 */
void draw_tile24_saving(u16 x, u16 y, u8 frame, u8 mode,
                        struct GfxRecord *src, struct GfxRecord *unused);
                                                        /* H029+$0D58 */

void save_screen_cell(u16 x, u16 y, struct GfxRecord *rec);   /* H029+$0E26 */
void restore_screen_cell(u16 x, u16 y, struct GfxRecord *rec);/* H029+$0E92 */
#endif
