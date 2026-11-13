/* H049: text/glyph drawing, direct blitter and QBSBlit nodes. */
#ifndef COK_H049_H
#define COK_H049_H

#include "cok.h"
#include "gfx_record.h"

/* Entry of the manual check (H049+$07E4, 12 bytes). */
typedef struct QuizEntry {
    const u8 *answer;           /* +$00: encoded answer */
    u16 page;                   /* +$04 */
    u16 line;                   /* +$06 */
    u16 word;                   /* +$08 */
    u16 length;                 /* +$0A */
} QuizEntry;

QuizEntry *quiz_entry(u16 index);       /* H049+$079E */
void draw_text_blitter(u16 col, u16 row, u16 fg, u16 bg, u16 len,
                       const char *text);               /* H049+$0224 */
void draw_8x8_tile_raw(u16 x, u16 row, u16 id, struct BitMap *dest,
                       struct GfxRecord **sets);        /* H049+$012A */
void *queue_bitplane_blit(struct BitMap *src, u16 sx, u16 sy, void *dest,
                          u16 dx, u16 dy, u16 w, u16 h, u8 minterm, u8 *mask);
                                                        /* H049+$04AE */
void mirror_gfx_record(struct GfxRecord *src, struct GfxRecord *dst);
                                                        /* H049+$09D6 */
void draw_8x8_tile_masked(u16 x, u16 row, u16 id, struct BitMap *dest,
                          struct GfxRecord **sets);        /* H049+$0014 */
void h049_set_glyph_planes(u8 *glyphs, struct BitMap *dest); /* H049+$0438 */

#endif
