/* H028: files, disk requests, loading by ID and DAX RLE. */
#ifndef COK_H028_FILES_H
#define COK_H028_FILES_H

#include "cok.h"

#include "h002_dos.h"

u8 file_exists(u16 len, const char *name);      /* H028+$02D0 */
u8 open_resource_file(u16 name_len, const char *name, u16 msg_len,
                      const char *msg, u8 unused, cok_bptr *file);
                                                /* H028+$05FA */
extern struct BitMap *g_char_screen_s;  /* -$AA(a4): "charS.LBM" */
extern struct BitMap *g_char_screen_t;  /* -$AE(a4): "charT.LBM" */
void disk_request(u16 unused1, u16 unused2, u16 len, char *text);
                                                /* H028+$01C6 */
void get_volume_name(char *out, u16 path_len, const char *path);
                                                /* H028+$033E */
void make_file_name(u16 name_len, const char *name, u16 out_max, char *out);
                                                /* H028+$08F0 */
void load_char_screens(void);            /* H028+$0D36 */
void free_char_screens(void);            /* H028+$0D74 */
void set_data_disk(u8 v);                /* H028+$1098 */
u8   dax_open(u16 name_len, const char *name, u16 ext_len,
                const char *ext, u8 *dir_size, cok_bptr *file);
                                                /* H028+$0B80 */
void dax_load_block(u16 name_len, const char *name, u16 ext_len,
                    const char *ext, u16 id, u16 *size, u8 **data);
                                                /* H028+$0DD8 */

void remove_substring(u16 str_len, const char *str, u16 pat_len,
                      const char *pat, u16 out_max, char *out);
                                                        /* H028+$07E0 */

#endif
