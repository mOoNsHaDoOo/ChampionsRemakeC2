/* H042: picture sequences, head and body, big picture. */
#ifndef COK_H042_SEQ_H
#define COK_H042_SEQ_H
#include "cok.h"
#include "gfx_record.h"

void release_picture_set(void);         /* H042+$0300 */
void show_picture(u16 x, u16 y, u8 flag, struct GfxRecord *rec);
                                        /* H042+$0254 */
void load_sequence(u16 name_len, const char *name, u16 id, u16 with_mask);
                                        /* H042+$0406 */
struct GfxRecord *sequence_frame(u16 frame);    /* H042+$0B80 */
void load_head_body(u16 head, u16 body);        /* H042+$0D70 */
void draw_head_body(u16 x, u16 y, u8 flag);     /* H042+$0ED2 */
void show_3d_sprite(u16 frame);                 /* H042+$0F50 */
void load_big_picture(u16 id);                  /* H042+$1006 */
void show_big_picture(void);                    /* H042+$10DC */

#endif
