/* H028: files, disk requests, loading by ID and DAX RLE. */
#include "h028_files.h"
#include "h002_dos.h"
#include "h021_intuition.h"
#include "h026_string.h"
#include "h003_exec.h"
#include "h031.h"
#include "h040.h"
#include "h041.h"
#include "unported.h"
#include "h014.h"
#include "globals.h"
#include "h010_input.h"

u8  g_h028_mf9;                 /* -$F9(a4) */
struct BitMap *g_char_screen_s; /* -$AA(a4): "charS.LBM" */
struct BitMap *g_char_screen_t; /* -$AE(a4): "charT.LBM" */
char g_h028_m52[0x52];          /* -$52(a4): alternative directory, never
                                   written in the asm, so always "" */

/* PORT H028+$01B8 */
void h028_init(void)
{
    g_h028_mf9 = 0;
    g_char_screen_s = NULL;
    g_char_screen_t = NULL;
}

/*
 * PORT H028+$02D0: 1 if Lock(name, ACCESS_READ) succeeds (the lock is
 * released at once), otherwise 0.  The original first copies the name onto the
 * stack ((len + 1) rounded up to even); Lock reads only up to the NUL, so
 * here the string is passed directly.
 */
u8 file_exists(u16 len, const char *name)
{
    cok_bptr lock;

    (void)len;
    lock = dos_lock(name, ACCESS_READ);
    if (lock == 0) {
        return 0;
    }
    dos_unlock(lock);
    return 1;
}

/*
 * PORT H028+$01C6: "Retry"/"CANCEL" request with the given text on the
 * game window (320x70).  The result is not used.  The original
 * first copies the text onto the stack; here it is used directly.  The first two
 * arguments are not read.
 */
void disk_request(u16 unused1, u16 unused2, u16 len, char *text)
{
    struct IntuiText body;
    struct IntuiText retry;
    struct IntuiText cancel;

    (void)len;
    (void)unused1;
    (void)unused2;
    body.FrontPen = 3;
    body.BackPen = 1;
    body.DrawMode = 1;
    body.LeftEdge = 0x0A;
    body.TopEdge = 0x0A;
    body.ITextFont = NULL;
    body.IText = (UBYTE *)text;
    body.NextText = NULL;

    retry.FrontPen = 2;
    retry.BackPen = 1;
    retry.DrawMode = 1;
    retry.LeftEdge = 3;
    retry.TopEdge = 3;
    retry.ITextFont = NULL;
    retry.IText = (UBYTE *)"Retry";
    retry.NextText = NULL;

    cancel = retry;
    cancel.IText = (UBYTE *)"CANCEL";

    (void)intuition_auto_request(g_window, &body, &retry, &cancel, 0x8000, 0,
                                 0x140, 0x46);
}

/*
 * PORT H028+$0408: splits name into volume/path up to the first ':' (dir),
 * name (base) and extension from the first '.' within $4F characters (ext).  Without
 * ':' base is not written (as in the original: the branch is skipped).
 * The original works on a copy of name on the stack; here a local copy
 * of $52 bytes, which is enough for the names passed by the game.
 */
static void split_resource_name(u16 name_len, const char *name,
                                u16 dir_max, char *dir, u16 base_max,
                                char *base, u16 ext_max, char *ext)
{
    char copy[0x52];
    s16 dot;
    s16 colon;
    s16 len;
    s16 i;

    h026_copy(sizeof(copy) - 1, copy, name_len, name);
    dot = h026_find_char(name_len, copy, '.', 0, 0x4F);
    len = (s16)h026_strlen(name_len, copy);
    if (dot >= 0) {
        h026_substr(ext_max, ext, name_len, copy, (u16)dot, (u16)(len - dot));
        h026_delete(name_len, copy, (u16)dot, (u16)(len - dot));
    } else {
        h026_copy(ext_max, ext, 0, "");
    }

    len = (s16)h026_strlen(name_len, copy);
    colon = 0;
    if (len > 0) {
        for (i = (s16)(len - 1); i >= 0; --i) {
            if (copy[i] == ':') {
                colon = (s16)(i + 1);
            }
        }
        h026_substr(base_max, base, name_len, copy, (u16)colon,
                    (u16)(len - colon));
        h026_delete(name_len, copy, (u16)colon, (u16)(len - colon));
    }
    h026_copy(dir_max, dir, name_len, copy);
}

/*
 * PORT H028+$0576: opens dir + name if it exists; 1 if the handle is not null.
 */
static u8 try_open(cok_bptr *file, u16 dir_len, const char *dir,
                   u16 name_len, const char *name)
{
    char path[0x52];

    h026_copy(0x50, path, dir_len, dir);
    h026_append(0x50, path, name_len, name);
    if (!file_exists(0x50, path)) {
        return 0;
    }
    *file = dos_open(path, MODE_OLDFILE);
    return (u8)(*file != 0);
}

/*
 * PORT H028+$05FA (Open_ResourceFile): looks for the file in the directory of the
 * data prefix (with "DF0:" replaced by the disk of the current resource
 * group: 1 "Disk Two:", 2 "Disk Three:") and then in the volume of the name (or
 * in the alternative directory of the module if the name has none).  If it does not
 * find it, it asks to insert the disk and retries forever: the branch that
 * would return 0 in the original is unreachable (moveq #0 / tst.b /
 * beq).  Returns 1 with the handle in *file.
 */
u8 open_resource_file(u16 name_len, const char *name, u16 msg_len,
                      const char *msg, u8 unused, cok_bptr *file)
{
    char ext[0x52];             /* -$14C(a5) */
    char base[0x52];            /* -$FA(a5) */
    char dir[0x52];             /* -$A8(a5) */
    char text[0x52];            /* -$56(a5) */
    char disk[0x16];            /* -$162(a5) */

    (void)unused;
    split_resource_name(name_len, name, 0x50, dir, 0x50, base, 0x50, ext);
    h026_append(0x50, base, 0x50, ext);
    if (h026_compare_nocase(0x50, dir, 0, "") == 1) {
        h026_copy(0x50, dir, 0x50, g_h028_m52);
    }
    h026_copy(0x14, disk, 0x50, G_DATA_PREFIX);
    if (h026_compare_nocase(0x14, disk, 4, "DF0:") == 1) {
        /* $246E: data disk / current resource group (G_RESOURCE_GROUP) */
        switch (G_RESOURCE_GROUP) {
        case 1:
            h026_copy(0x14, disk, 9, "Disk Two:");
            break;
        case 2:
            h026_copy(0x14, disk, 0x0B, "Disk Three:");
            break;
        default:
            break;
        }
    }
    for (;;) {
        if (try_open(file, 0x14, disk, 0x50, base)) {
            return 1;
        }
        if (try_open(file, 0x50, dir, 0x50, base)) {
            return 1;
        }
        h026_copy(0x50, text, msg_len, msg);
        disk_request(0x0E, 0, 0x50, text);
    }
}

/*
 * PORT H028+$09DC (DAX_DecompressRLE): decompresses *comp_size bytes of src
 * into dst (at most *raw_size bytes, otherwise H014 error "uncompress
 * overuns buffer>").  Control byte n: 0..$7E = n+1 literal bytes;
 * $7F..$FE = the next byte repeated $100-n times; $FF repeats the type
 * of the last control.  At the start that type is not initialised
 * in the original (word on the stack); here it is -1, that is "skip the byte",
 * the default branch of the table.
 */
static void dax_decompress_rle(const u8 *src, u8 *dst, u16 *comp_size,
                               u16 *raw_size)
{
    static const char overrun[] = "uncompress overuns buffer>";
    u16 si = 0;                 /* -$2 */
    u16 di = 0;                 /* -$4 */
    u16 n;                      /* -$8 */
    s16 kind = -1;              /* -$A */
    u16 j;                      /* -$6 */

    do {
        n = src[si];
        if (n <= 0x7E) {
            kind = 0;
        } else if (n >= 0x7F && n <= 0xFE) {
            kind = 1;
        }
        if (kind == 0) {
            if ((u16)(di + n + 1) <= *raw_size) {
                /*
                 * The last control of some blocks declares more bytes than
                 * the remaining ones: the original reads them past the compressed
                 * buffer.  Here only the bytes present are copied (the
                 * buffer has a 2-byte margin) and the rest stays zero.
                 */
                u32 avail = (u32)*comp_size + 2 - (u32)(u16)(si + 1);
                u32 want = (u32)(u16)(n + 1);

                exec_copy_mem(src + (u16)(si + 1), dst + di,
                              want < avail ? want : avail);
            } else {
                error_message(0x1A, overrun, (u16)(di + n + 1 - *raw_size));
            }
            si = (u16)(si + n + 2);
            di = (u16)(di + n + 1);
        } else if (kind == 1) {
            n = (u16)(0x100 - n);
            for (j = 0; j <= (u16)(n - 1); ++j) {
                if ((u16)(di + j) < *raw_size) {
                    dst[(u16)(di + j)] = src[(u16)(si + 1)];
                } else if ((u16)(di + j) == *raw_size) {
                    /*
                     * The original allows the index *raw_size (<=) and writes one
                     * byte past the buffer, in the rounding margin of
                     * AllocMem; in C that byte does not exist and the write is
                     * skipped.
                     */
                } else {
                    error_message(0x1A, overrun, (u16)(di + j - *raw_size));
                }
                if (j == 0xFFFF) {
                    break;
                }
            }
            si = (u16)(si + 2);
            di = (u16)(di + n);
        } else {
            ++si;
        }
    } while (si < *comp_size);
}

/*
 * PORT H028+$0B80: opens name+ext with Open_ResourceFile (disk message
 * of the current resource group, H005+$3E08 + 30 * (group - 1)) and reads
 * the size word of the directory (bytes as in the file).
 */
u8 dax_open(u16 name_len, const char *name, u16 ext_len,
                   const char *ext, u8 *dir_size, cok_bptr *file)
{
    char path[0x52];

    h026_copy(0x50, path, name_len, name);
    h026_append(0x50, path, ext_len, ext);
    if (!open_resource_file(0x50, path, 0x1D,
                            /* $3E08: disk insertion messages, 30 bytes per resource group */
                            (const char *)&g_h005[0x3E08 +
                                /* $246E: data disk / current resource group
                                 * (G_RESOURCE_GROUP) */
                                (s32)((s16)(G_RESOURCE_GROUP - 1) * 0x1E)],
                            /* $24A4: use: ignored argument of Open_ResourceFile; 1 when loading SPC */
                            H005_B(0x24A4), file)) {
        return 0;
    }
    (void)dos_read(*file, dir_size, 2);
    return 1;
}

/*
 * PORT H028+$0DD8 (DAX_LoadBlock): looks for id in the directory of the container
 * name+ext (9-byte entries: id, long offset, size, compressed
 * size), reads the block and decompresses it into *data (*size bytes, $100
 * more than the declared size).  The ".dax" files are little-endian:
 * directory and entries are swapped (H031).  Block not found: *size = 0 and
 * *data = NULL.  A compressed block beyond $A000 bytes is a fatal error
 * (H010+$0332).
 *
 * Difference: the original reads the fields straight into the variables
 * (big-endian memory); here they are read into byte buffers decoded with
 * COK_GET16/32, identical on the Amiga and correct on the host.
 */
void dax_load_block(u16 name_len, const char *name, u16 ext_len,
                    const char *ext, u16 id, u16 *size, u8 **data)
{
    cok_bptr file;              /* -$14 */
    u8 dir_raw[2];              /* -$16 */
    u16 dir_size;
    u8 entry_id = 0;            /* -$B */
    u8 offset_raw[4];           /* -$A */
    u8 size_raw[2];
    u8 comp_raw[2];             /* -$2 */
    u16 comp_size;
    u16 comp_saved;             /* -$4 */
    u16 count = 0;              /* -$78 */
    int little = h026_compare_nocase(ext_len, ext, 4, ".dax") == 1;

    if (!dax_open(name_len, name, ext_len, ext, dir_raw, &file)) {
        error_message(0x13, "could not open file", 0);
        *size = 0;
        *data = NULL;
        return;
    }
    if (little) {
        h031_swap_word(dir_raw);
    }
    dir_size = COK_GET16(dir_raw);
    if (little) {
        dir_size = (u16)(dir_size + 2);
    }
    for (;;) {
        ++count;
        (void)dos_read(file, &entry_id, 1);
        (void)dos_read(file, offset_raw, 4);
        (void)dos_read(file, size_raw, 2);
        (void)dos_read(file, comp_raw, 2);
        if (h026_compare_nocase(ext_len, ext, 4, ".dax") == 1) {
            h031_swap_word(size_raw);
            h031_swap_word(comp_raw);
            h031_swap_long(offset_raw);
        }
        *size = (u16)(COK_GET16(size_raw) + 0x100);
        comp_size = COK_GET16(comp_raw);
        if (comp_size > 0xA000 && entry_id == id) {
            dos_close(file);
            quit_game();
        }
        if (count > 0x3E7) {
            error_message(0x1C, "large limit in getdatablock>", count);
        }
        if (entry_id == id) {
            break;
        }
        if (!(dos_seek(file, 0, OFFSET_CURRENT) < (s32)dir_size)) {
            break;
        }
    }
    if (entry_id != id) {
        *size = 0;
        *data = NULL;
        dos_close(file);
        return;
    }
    /*
     * Two extra bytes (cleared): the decompression may read the byte
     * after the last control, which in the original is the AllocMem margin.
     */
    g_dax_buffer = (u8 *)exec_alloc_mem((u32)comp_size + 2, COK_MEMF_CLEAR);
    *data = (u8 *)exec_alloc_mem(*size, COK_MEMF_CLEAR);
    (void)dos_seek(file, (s32)(dir_size + COK_GET32(offset_raw)),
                   OFFSET_BEGINNING);
    (void)dos_read(file, g_dax_buffer, comp_size);
    dos_close(file);
    comp_saved = comp_size;
    dax_decompress_rle(g_dax_buffer, *data, &comp_size, size);
    exec_free_mem(g_dax_buffer, (u32)comp_saved + 2);
}

/*
 * PORT H028+$0D74: if loaded (flag -$F9), frees the two character
 * screens (charS/charT: planes with H041+$00BE, BitMap of $28 bytes).
 */
void free_char_screens(void)
{
    if (!g_h028_mf9) {
        return;
    }
    if (g_char_screen_s != NULL) {
        sized_free(g_char_screen_s->Planes[0]);
        exec_free_mem(g_char_screen_s, sizeof(struct BitMap));
    }
    if (g_char_screen_t != NULL) {
        sized_free(g_char_screen_t->Planes[0]);
        exec_free_mem(g_char_screen_t, sizeof(struct BitMap));
    }
    g_h028_mf9 = 0;
}

/*
 * PORT H028+$0C68: loads the ILBM picture name (parameter by value) into
 * a new BitMap (*bitmap, $28 bytes) with the planes of H041+$004A; its
 * 32 colours go into H005+$522E ($40 bytes), then H005+$523E = colour 0 and
 * colour 0 = black.  Disk message H005+$3E08.
 */
static void load_char_screen(u16 name_len, const char *name,
                             struct BitMap **bitmap)
{
    ILBMFrame frame;                    /* -$6e(a5) */
    cok_bptr file = 0;                  /* -$4(a5) */
    u16 i;

    *bitmap = (struct BitMap *)exec_alloc_mem(sizeof(struct BitMap),
                                              COK_MEMF_CLEAR);
    if (open_resource_file(name_len, name, 0x1D,
                           /* $3E08: disk insertion messages, 30 bytes per resource group */
                           (const char *)&g_h005[0x3E08], 0, &file) &&
        file != 0) {
        (void)read_ilbm(file, *bitmap, &frame, sized_alloc_chip);
        /*
         * CopyMem of the colours: in the frame they are native words, in H005
         * big-endian (on the Amiga it is the same $40-byte copy).
         */
        for (i = 0; i < 0x20; ++i) {
            /* $522E: palette of the loaded picture, 32 RGB4 colours ($40 bytes) */
            H005_SET_W(0x522E + i * 2, frame.color_map[i]);
        }
        /* $522E: palette of the loaded picture, 32 RGB4 colours ($40 bytes); $523E: (word) colour
         * 8 of the palette $522E (copy of colour 0) */
        H005_SET_W(0x523E, H005_W(0x522E));
        H005_SET_W(0x522E, 0); /* $522E: palette of the loaded picture, 32 RGB4 colours ($40 bytes) */
        dos_close(file);
    }
}

/*
 * PORT H028+$0D36: loads only once (flag -$F9) the character
 * screens "charS.LBM" and "charT.LBM".
 */
void load_char_screens(void)
{
    if (g_h028_mf9) {
        return;
    }
    load_char_screen(9, "charS.LBM", &g_char_screen_s);
    load_char_screen(9, "charT.LBM", &g_char_screen_t);
    g_h028_mf9 = 1;
}

/* -$F8(a4): FileInfoBlock of H028+$033E. */
static cok_fib *s_fib;

/*
 * PORT H028+$033E: in out the volume name of the first 4 characters of path
 * (parameter by value): Lock and Examine of the FileInfoBlock ($104 bytes).
 */
void get_volume_name(char *out, u16 path_len, const char *path)
{
    char head[0x51];                    /* -$52(a5) */
    cok_bptr lock;                      /* -$56(a5) */

    s_fib = (cok_fib *)exec_alloc_mem(sizeof(cok_fib), COK_MEMF_CLEAR);
    h026_substr(0x50, head, path_len, path, 0, 4);
    lock = dos_lock(head, ACCESS_READ);
    (void)dos_examine(lock, s_fib);
    dos_unlock(lock);
    /*
     * The original frees the block and then reads its name (on the Amiga it stays
     * intact); here the name is copied before freeing it.
     */
    h026_copy(0x50, out, 0x6B, s_fib->fib_FileName);
    exec_free_mem(s_fib, sizeof(cok_fib));
}

/*
 * PORT H028+$07E0: copies into out the string str (by value) without the
 * occurrences of pat (case-insensitive comparison).  The index skips the
 * length of pat after every deletion and the length is not
 * recomputed: as in the original the last position is not checked.
 */
void remove_substring(u16 str_len, const char *str, u16 pat_len,
                      const char *pat, u16 out_max, char *out)
{
    char s[0x100];                      /* copy by value */
    char part[0x51];                    /* -$58(a5) */
    u16 plen;                           /* -$4(a5) */
    u16 diff;                           /* -$2(a5) */
    u16 i;                              /* -$6(a5) */

    memcpy(s, str, (size_t)str_len + 1 < sizeof(s) ? (size_t)str_len + 1 :
                                                     sizeof(s));
    plen = h026_strlen(pat_len, pat);
    diff = (u16)(h026_strlen(str_len, s) - plen);
    i = 0;
    while (i < diff) {
        h026_substr(0x50, part, str_len, s, i, plen);
        if (h026_compare_nocase(0x50, part, pat_len, pat) == 1) {
            h026_delete(str_len, s, i, plen);
            i = (u16)(i + plen);
        } else {
            ++i;
        }
    }
    h026_copy(out_max, out, str_len, s);
}

/*
 * PORT H028+$08F0: file name from the character name (by value):
 * " .*,?/#:;|" removed, at most 8 characters.
 */
void make_file_name(u16 name_len, const char *name, u16 out_max, char *out)
{
    static const char bad[10] = { ' ', '.', '*', ',', '?', '/', '#', ':',
                                  ';', '|' };   /* -$a(a5) */
    char copy[0x100];
    char tmp[0x51];                     /* -$5e(a5) */
    char one[2];                        /* -$b0(a5) */
    u16 i;                              /* -$c(a5) */

    memcpy(copy, name, (size_t)name_len + 1 < sizeof(copy) ?
                       (size_t)name_len + 1 : sizeof(copy));
    one[1] = 0;
    for (i = 1; i <= 0x0A; ++i) {
        one[0] = bad[i - 1];
        remove_substring(name_len, copy, 0x50, one, 0x50, tmp);
        h026_copy(name_len, copy, 0x50, tmp);
    }
    h026_substr(out_max, out, name_len, copy, 0, 8);
}

/* PORT H028+$1098: data disk from the value v ((v+2)/3); the previous one in $246D. */
void set_data_disk(u8 v)
{
    /* $246D: previous data disk (copy of +$246E); $246E: data disk / current resource group
     * (G_RESOURCE_GROUP) */
    H005_B(0x246D) = H005_B(0x246E);
    /* $246E: data disk / current resource group (G_RESOURCE_GROUP) */
    H005_B(0x246E) = (u8)((u16)(v + 2) / 3);
}
