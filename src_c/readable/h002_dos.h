/* H002: adattatori dos.library. */
#ifndef COK_H002_DOS_H
#define COK_H002_DOS_H

#include "cok.h"

#if COK_AMIGA
typedef BPTR cok_bptr;
typedef struct InfoData cok_info_data;
typedef struct FileInfoBlock cok_fib;
#else
typedef s32 cok_bptr;
typedef struct cok_info_data {
    s32 id_NumBlocks;          /* $0C nell'InfoData di AmigaDOS */
    s32 id_NumBlocksUsed;      /* $10 */
    s32 id_BytesPerBlock;      /* $14 */
} cok_info_data;
/* Solo il campo del FileInfoBlock letto dal gioco (offset 8). */
typedef struct cok_fib {
    s32 fib_DirEntryType;      /* $04: > 0 directory */
    char fib_FileName[108];    /* $08 */
    s32 fib_Size;              /* $7C */
} cok_fib;
#define ACCESS_WRITE     (-1)
#define ACCESS_READ      (-2)
#define MODE_OLDFILE     1005
#define MODE_NEWFILE     1006
#define MODE_READWRITE   1004
#define OFFSET_BEGINNING (-1)
#define OFFSET_CURRENT   0
#define OFFSET_END       1
#endif

cok_bptr dos_lock(const char *name, s32 mode);   /* H002+$00DC */
void     dos_unlock(cok_bptr lock);               /* H002+$01A2 */
u8       dos_info(cok_bptr lock, cok_info_data *info);  /* H002+$00A0 */
void     dos_close(cok_bptr file);                /* H002+$0014 */
cok_bptr dos_open(const char *name, s32 mode);    /* H002+$00F2 */
s32      dos_read(cok_bptr file, void *buf, s32 len);   /* H002+$0122 */
s32      dos_write(cok_bptr file, const void *buf, s32 len);  /* H002+$01CC */
s32      dos_seek(cok_bptr file, s32 pos, s32 mode);    /* H002+$0156 */
u8       dos_execute(const char *cmd, cok_bptr in, cok_bptr out); /* H002+$01E8 */
cok_bptr dos_create_dir(const char *name);        /* H002+$0026 */
u8       dos_delete_file(const char *name);       /* H002+$004A */
u8       dos_examine(cok_bptr lock, cok_fib *fib); /* H002+$0070 */
u8       dos_exnext(cok_bptr lock, cok_fib *fib);  /* H002+$0088 */

#endif
