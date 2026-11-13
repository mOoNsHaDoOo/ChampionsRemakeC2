/*
 * H002: dos.library adapters.
 *
 * Each routine moves the arguments from the stack into the registers and jumps into the
 * library.  Those ending with neg.b d0 turn DOSTRUE (-1) into
 * a boolean 1.  The host has no dos.library: the #else implementations
 * are the minimal environment needed to run the port.
 * PORT H002+$00C0 (wrapper_IoErr): used only by the runtime H074+$0010,
 * replaced by stdio; no C function.
 */
/* Host: POSIX opendir/strncasecmp (before any system header). */
#if !defined(__SASC) && !defined(__AMIGA__) && !defined(AMIGA) && !defined(_WIN32)
#define _POSIX_C_SOURCE 200809L
#endif
#include "h002_dos.h"

#if !COK_AMIGA
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#if defined(_WIN32)
#include <direct.h>
#include <io.h>
#include <stdint.h>
#ifndef S_ISDIR
#define S_ISDIR(m) (((m) & _S_IFMT) == _S_IFDIR)
#endif
#else
#include <dirent.h>
#endif

/*
 * Host: the AmigaDOS names "volume:path" (df0:, Disk Two:, ...) become
 * paths relative to the data directory (COK_DATA, otherwise the current
 * one): everything up to the colon is removed.  As in AmigaDOS, names are
 * case insensitive: each path component that does not
 * exist as it is gets looked up in its directory ignoring
 * case.
 */
#if defined(_WIN32)
static const char *host_path(const char *name)
{
    static char path[1024];
    const char *colon = strchr(name, ':');
    const char *dir = getenv("COK_DATA");

    /* "C:\..." and "\\server\..." are absolute Windows paths: unchanged. */
    if ((colon == name + 1 && (name[2] == '\\' || name[2] == '/')) ||
        (name[0] == '\\' && name[1] == '\\')) {
        sprintf(path, "%.1000s", name);
        return path;
    }
    sprintf(path, "%.500s%s%.500s", dir != NULL ? dir : "",
            dir != NULL ? "/" : "", colon != NULL ? colon + 1 : name);
    return path;
}
#else
#include <dirent.h>
#include <strings.h>
#include <sys/stat.h>

static const char *host_path(const char *name)
{
    static char path[1024];
    const char *colon = strchr(name, ':');
    const char *dir = getenv("COK_DATA");
    const char *rest = colon != NULL ? colon + 1 : name;
    size_t base;
    struct stat st;

    if (rest[0] == '/') {
        path[0] = 0;            /* absolute host path */
    } else {
        sprintf(path, "%.500s", dir != NULL && dir[0] != 0 ? dir : ".");
    }
    while (*rest != 0) {
        const char *end = strchr(rest, '/');
        size_t n = end != NULL ? (size_t)(end - rest) : strlen(rest);
        DIR *d;

        if (n == 0) {
            ++rest;
            continue;
        }
        base = strlen(path);
        if (base + n + 2 >= sizeof(path)) {
            break;
        }
        path[base] = '/';
        memcpy(path + base + 1, rest, n);
        path[base + 1 + n] = 0;
        if (stat(path, &st) != 0) {
            path[base] = 0;
            d = opendir(path[0] != 0 ? path : "/");
            path[base] = '/';
            if (d != NULL) {
                struct dirent *e;

                while ((e = readdir(d)) != NULL) {
                    if (strlen(e->d_name) == n &&
                        strncasecmp(e->d_name, rest, n) == 0) {
                        memcpy(path + base + 1, e->d_name, n);
                        break;
                    }
                }
                closedir(d);
            }
        }
        rest += n;
    }
    return path;
}
#endif
#endif

/*
 * PORT H002+$0008: module initialisation.  Copies DOSBase (-$8(a4)
 * of H001) into the cell H002+$0000 used by the adapters; in C the
 * library base is already global, so there is nothing left to do.
 */
void h002_init(void)
{
}

#if !COK_AMIGA
/*
 * Host: locks are indices (from 1) into this table: the host path
 * and, after Examine of a directory, its scan for ExNext.
 */
#define HOST_LOCKS 16
typedef struct HostLock {
    int used;
    char path[1024];
#if defined(_WIN32)
    intptr_t find;              /* _findfirst, -1 if no scan */
    struct _finddata_t data;
    int have_data;
#else
    DIR *dir;
#endif
} HostLock;
static HostLock s_locks[HOST_LOCKS];

static HostLock *host_lock(cok_bptr lock)
{
    return lock >= 1 && lock <= HOST_LOCKS && s_locks[lock - 1].used ?
           &s_locks[lock - 1] : NULL;
}

/* Last component of a host path. */
static const char *host_base_name(const char *path)
{
    const char *slash = strrchr(path, '/');
#if defined(_WIN32)
    const char *bslash = strrchr(path, '\\');

    if (bslash != NULL && (slash == NULL || bslash > slash)) {
        slash = bslash;
    }
#endif
    return slash != NULL ? slash + 1 : path;
}
#endif

/* PORT H002+$00DC */
cok_bptr dos_lock(const char *name, s32 mode)
{
#if COK_AMIGA
    return Lock((STRPTR)name, mode);
#else
    const char *path;
    struct stat st;
    int i;

    (void)mode;
    /* "" and the volume alone ("df0:") are the data directory. */
    if (name[0] == 0 ||
        (strchr(name, ':') != NULL && strchr(name, ':')[1] == 0)) {
        path = host_path("");
    } else {
        path = host_path(name);
        if (stat(path, &st) != 0) {
            return 0;
        }
    }
    for (i = 0; i < HOST_LOCKS; ++i) {
        if (!s_locks[i].used) {
            memset(&s_locks[i], 0, sizeof(s_locks[i]));
            s_locks[i].used = 1;
            sprintf(s_locks[i].path, "%.1000s", path);
#if defined(_WIN32)
            s_locks[i].find = -1;
#endif
            return i + 1;
        }
    }
    return 0;
#endif
}

/* PORT H002+$01A2 */
void dos_unlock(cok_bptr lock)
{
#if COK_AMIGA
    UnLock(lock);
#else
    HostLock *l = host_lock(lock);

    if (l == NULL) {
        return;
    }
#if defined(_WIN32)
    if (l->find != -1) {
        _findclose(l->find);
    }
#else
    if (l->dir != NULL) {
        closedir(l->dir);
    }
#endif
    l->used = 0;
#endif
}

/* PORT H002+$00A0: Info, then neg.b d0. */
u8 dos_info(cok_bptr lock, cok_info_data *info)
{
#if COK_AMIGA
    return (u8)(-(s8)Info(lock, info));
#else
    (void)lock;
    /*
     * Host: no floppy disk.  A hard-disk number of blocks makes
     * H001+$0066 choose the prefix "" (current directory).
     */
    info->id_NumBlocks = 0x708;
    info->id_NumBlocksUsed = 0;
    info->id_BytesPerBlock = 0x200;
    return 1;
#endif
}

#if !COK_AMIGA

/*
 * Host: AmigaDOS file handles are indices (from 1) into this table of
 * FILE *.  0 stays "no file", like the null BPTR returned by Open.
 */
#define HOST_FILES 16
static FILE *s_files[HOST_FILES];

static FILE *host_file(cok_bptr file)
{
    return file >= 1 && file <= HOST_FILES ? s_files[file - 1] : NULL;
}
#endif

/* PORT H002+$0014 */
void dos_close(cok_bptr file)
{
#if COK_AMIGA
    Close(file);
#else
    FILE *f = host_file(file);

    if (f != NULL) {
        fclose(f);
        s_files[file - 1] = NULL;
    }
#endif
}

/* PORT H002+$00F2 */
cok_bptr dos_open(const char *name, s32 mode)
{
#if COK_AMIGA
    return Open((STRPTR)name, mode);
#else
    const char *how = mode == MODE_NEWFILE ? "w+b" :
                      mode == MODE_READWRITE ? "r+b" : "rb";
    int i;

    for (i = 0; i < HOST_FILES; ++i) {
        if (s_files[i] == NULL) {
            s_files[i] = fopen(host_path(name), how);
            if (s_files[i] == NULL && mode == MODE_READWRITE) {
                /* MODE_READWRITE creates the file */
                s_files[i] = fopen(host_path(name), "w+b");
            }
            return s_files[i] != NULL ? i + 1 : 0;
        }
    }
    return 0;
#endif
}

/* PORT H002+$0122 */
s32 dos_read(cok_bptr file, void *buf, s32 len)
{
#if COK_AMIGA
    return Read(file, buf, len);
#else
    FILE *f = host_file(file);

    return f != NULL ? (s32)fread(buf, 1, (size_t)len, f) : -1;
#endif
}

/* PORT H002+$01CC */
s32 dos_write(cok_bptr file, const void *buf, s32 len)
{
#if COK_AMIGA
    return Write(file, (APTR)buf, len);
#else
    FILE *f = host_file(file);

    return f != NULL ? (s32)fwrite(buf, 1, (size_t)len, f) : -1;
#endif
}

/* PORT H002+$0156: returns the previous position, like Seek. */
s32 dos_seek(cok_bptr file, s32 pos, s32 mode)
{
#if COK_AMIGA
    return Seek(file, pos, mode);
#else
    FILE *f = host_file(file);
    long old;
    int whence = mode == OFFSET_BEGINNING ? SEEK_SET :
                 mode == OFFSET_END ? SEEK_END : SEEK_CUR;

    if (f == NULL || (old = ftell(f)) < 0 || fseek(f, pos, whence) != 0) {
        return -1;
    }
    return (s32)old;
#endif
}

/* PORT H002+$01E8: Execute, then neg.b d0. */
u8 dos_execute(const char *cmd, cok_bptr in, cok_bptr out)
{
#if COK_AMIGA
    return (u8)(-(s8)Execute((STRPTR)cmd, in, out));
#else
    /*
     * Host: the game's commands are only Assigns of the disk names, which
     * have no equivalent; success is reported without running anything.
     */
    (void)cmd;
    (void)in;
    (void)out;
    return 1;
#endif
}

/* PORT H002+$0026 */
cok_bptr dos_create_dir(const char *name)
{
#if COK_AMIGA
    return CreateDir((STRPTR)name);
#else
#if defined(_WIN32)
    return _mkdir(host_path(name)) == 0 ? 1 : 0;
#else
    return mkdir(host_path(name), 0777) == 0 ? 1 : 0;
#endif
#endif
}

/* PORT H002+$004A: DeleteFile, then neg.b d0. */
u8 dos_delete_file(const char *name)
{
#if COK_AMIGA
    return (u8)(-(s8)DeleteFile((STRPTR)name));
#else
    return (u8)(remove(host_path(name)) == 0 ? 1 : 0);
#endif
}

/*
 * PORT H002+$0070: Examine, then neg.b d0.  Host: name (last component)
 * and size; for a directory it starts the scan used by ExNext.
 */
u8 dos_examine(cok_bptr lock, cok_fib *fib)
{
#if COK_AMIGA
    return (u8)(-(s8)Examine(lock, fib));
#else
    HostLock *l = host_lock(lock);
    struct stat st;

    memset(fib, 0, sizeof(*fib));
    if (l == NULL || stat(l->path, &st) != 0) {
        return 0;
    }
    sprintf(fib->fib_FileName, "%.100s", host_base_name(l->path));
    fib->fib_Size = (s32)st.st_size;
    fib->fib_DirEntryType = S_ISDIR(st.st_mode) ? 2 : -3;
#if defined(_WIN32)
    if (S_ISDIR(st.st_mode) && l->find == -1) {
        char pattern[1100];

        sprintf(pattern, "%.1000s/*", l->path);
        l->find = _findfirst(pattern, &l->data);
        l->have_data = l->find != -1;
    }
#else
    if (S_ISDIR(st.st_mode) && l->dir == NULL) {
        l->dir = opendir(l->path);
    }
#endif
    return 1;
#endif
}

/*
 * PORT H002+$0088: ExNext, then neg.b d0.  Host: next entry of the
 * directory (without "." and ".."), 0 at the end.
 */
u8 dos_exnext(cok_bptr lock, cok_fib *fib)
{
#if COK_AMIGA
    return (u8)(-(s8)ExNext(lock, fib));
#else
    HostLock *l = host_lock(lock);
    char full[1200];
    struct stat st;
    const char *entry;

    if (l == NULL) {
        return 0;
    }
    for (;;) {
#if defined(_WIN32)
        if (l->find == -1 || !l->have_data) {
            return 0;
        }
        sprintf(full, "%.100s", l->data.name);
        l->have_data = _findnext(l->find, &l->data) == 0;
        entry = full;
#else
        struct dirent *e;

        if (l->dir == NULL || (e = readdir(l->dir)) == NULL) {
            return 0;
        }
        entry = e->d_name;
#endif
        if (strcmp(entry, ".") != 0 && strcmp(entry, "..") != 0) {
            break;
        }
    }
    memset(fib, 0, sizeof(*fib));
    sprintf(fib->fib_FileName, "%.100s", entry);
    sprintf(full, "%.1000s/%.100s", l->path, fib->fib_FileName);
    if (stat(full, &st) == 0) {
        fib->fib_Size = (s32)st.st_size;
        fib->fib_DirEntryType = S_ISDIR(st.st_mode) ? 2 : -3;
    }
    return 1;
#endif
}
