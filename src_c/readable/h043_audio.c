/*
 * H043: "SoundX", loading and handling of SMUS scores and 8SVX samples,
 * start-up and shutdown of audio.device and of the VBlank server (H094).
 * The whole player is compiled only with COK_AUDIO; without it h043_0584,
 * h043_0840 and h043_190e are the stubs of unported.c.
 */
#include <string.h>
#include "h043_audio.h"

/* Module data (offsets from a4). */
u8  g_h043_m1;                  /* -$1: soundData opened by load_object */
u8  g_h043_m2;                  /* -$2: player started */
u8  g_h043_m3;                  /* -$3: audio.device open */
u8  g_h043_m5;                  /* -$5: music enabled */
u32 g_h043_m8a;                 /* -$8A (the pointer is g_sound) */

/* PORT H043+$01BC (body at $19FC) */
void h043_init(void)
{
    g_h043_m5 = 1;
    g_h043_m2 = 0;
    g_h043_m3 = 0;
    g_h043_m8a = 0;
    g_h043_m1 = 0;
}

#ifdef COK_AUDIO

#include "h002_dos.h"
#include "h003_exec.h"
#include "h010_input.h"
#include "h020_io.h"
#include "h026_string.h"
#include "h028_files.h"
#include "h050.h"
#include "h079.h"
#include "h090.h"
#include "h092.h"
#if COK_AMIGA
#include <proto/exec.h>
#endif

static SoundX *g_sound;                 /* -$8A(a4) */
static SxObject *s_last_loaded;         /* -$8E(a4) */
static u8 s_error;                      /* -$4(a4) */
static u8 s_resource_result;            /* -$6(a4) */
static char s_sound_dir[0x28];          /* -$58(a4): "SOUND/" */
static char s_name[0x28];               /* -$30(a4) */
static struct Interrupt s_soft_int;     /* -$86(a4) */
static struct Interrupt s_vblank_int;   /* -$70(a4) */

#define INTB_VERTB_NUM  5

static void sx_error(u16 code);

/* PORT H043+$01D6: CHIP memory, otherwise error 1. */
static void *sx_alloc_chip(u32 size)
{
    void *p = exec_alloc_mem(size, COK_MEMF_CHIP);

    if (p == NULL) {
        sx_error(1);
    }
    return p;
}

/* PORT H043+$0214: cleared memory, otherwise error 2. */
static void *sx_alloc(u32 size)
{
    void *p = exec_alloc_mem(size, COK_MEMF_CLEAR);

    if (p == NULL) {
        sx_error(2);
    }
    return p;
}

/* PORT H043+$0252: frees *pp of size bytes and clears it. */
static void sx_free(void **pp, u32 size)
{
    if (*pp != NULL) {
        exec_free_mem(*pp, size);
        *pp = NULL;
    }
}

/* PORT H043+$0286: skips n bytes of the file (error if Seek fails). */
static void sx_skip(cok_bptr file, s32 n)
{
    if (!s_error && dos_seek(file, n, 0) == -1) {
        s_error = 1;
    }
}

/* PORT H043+$02C4: reads n bytes (error if fewer arrive). */
static void sx_read(cok_bptr file, void *buf, s32 n)
{
    if (!s_error && dos_read(file, buf, n) != n) {
        s_error = 1;
    }
}

/* Lengths of the IFF blocks: big-endian long. */
static s32 sx_read_long(cok_bptr file)
{
    u8 b[4];

    memset(b, 0, sizeof(b));
    sx_read(file, b, 4);
    return (s32)COK_GET32(b);
}

/* PORT H043+$0304: message port without a signal (type 4, empty list). */
static struct MsgPort *sx_create_port(void)
{
    struct MsgPort *p = (struct MsgPort *)sx_alloc(sizeof(struct MsgPort));

    p->mp_Node.ln_Type = 4;
    exec_new_list(&p->mp_MsgList);
    return p;
}

/* PORT H043+$0340: closes the port (type $FF, list -1) and frees it. */
static void sx_delete_port(struct MsgPort **pp)
{
    if (*pp != NULL) {
        (*pp)->mp_Node.ln_Type = 0xFF;
        (*pp)->mp_MsgList.lh_Head = (struct Node *)-1;
        sx_free((void **)pp, sizeof(struct MsgPort));
        *pp = NULL;
    }
}

/* PORT H043+$038A: frees a track. */
static void sx_free_track(SxTrack *t)
{
    sx_free((void **)&t->data, (u32)(t->end - t->data));
    sx_free((void **)&t, sizeof(SxTrack));
}

/* PORT H043+$03CA: frees a score with its tracks. */
static void sx_free_score(SxScore *s)
{
    s16 i;

    if (s == NULL) {
        return;
    }
    for (i = 0; i < (s16)s->ntracks; ++i) {
        sx_free_track(s->tracks[i]);
    }
    sx_free((void **)&s, sizeof(SxScore));
}

/* PORT H043+$0422: frees an 8SVX sample. */
static void sx_free_8svx(Sx8svx *v)
{
    if (v == NULL) {
        return;
    }
    sx_free((void **)&v->body, v->body_size);
    sx_free((void **)&v, sizeof(Sx8svx));
}

/* PORT H043+$045E: frees an envelope (length word + data). */
static void sx_free_envl(u8 *e)
{
    if (e == NULL) {
        return;
    }
    sx_free((void **)&e, (u32)COK_GET16(e) + 2);
}

/* PORT H043+$048E: frees an instrument (not its objects). */
static void sx_free_inst(SxInst *i)
{
    if (i == NULL) {
        return;
    }
    sx_free((void **)&i, sizeof(SxInst));
}

/* PORT H043+$04B6: frees *pp according to the type and replaces it with the next one. */
static void sx_free_object(SxObject **pp)
{
    SxObject *o = *pp;
    SxObject *next = o->next;           /* -$4(a5) */

    if (o->flags & 0x01) {
        sx_free_score((SxScore *)o->data);
    } else if (o->flags & 0x02) {
        sx_free_inst((SxInst *)o->data);
    } else if (o->flags & 0x04) {
        sx_free_8svx((Sx8svx *)o->data);
    } else if (o->flags & 0x20) {
        sx_free_track((SxTrack *)o->data);
    } else if (o->flags & 0x40) {
        sx_free_envl((u8 *)o->data);
    }
    sx_free((void **)&o->name, 0x28);
    sx_free((void **)pp, sizeof(SxObject));
    *pp = next;
}

/* PORT H043+$07F6: trampoline (bra.w) to H043+$15C6, the routine below. */
/*
 * PORT H043+$15C6 (also $07F6): stops everything: the active objects no
 * longer play in this turn (bit 4), the voices end at once and the
 * list of the notes to assign is emptied.
 */
static void sx_stop_all(void)
{
    SxObject *o;                        /* -$4(a5) */
    s16 i;                              /* -$6(a5) */

    exec_disable();
    for (o = g_sound->active; o != NULL; o = o->next) {
        o->flags = (u8)(o->flags & (0xFF - (1 << 4)));
    }
    for (i = 3; i >= 0; --i) {
        if (g_sound->voice[i] != NULL) {
            g_sound->voice[i]->end = 0;
        }
    }
    g_sound->pending = NULL;
    exec_enable();
}

/* PORT H043+$07FA: stops everything and frees all the objects. */
static void sx_free_all(void)
{
    sx_stop_all();
    while (g_sound->active != NULL) {
        sx_free_object(&g_sound->active);
    }
    while (g_sound->loaded != NULL) {
        sx_free_object(&g_sound->loaded);
    }
}

/*
 * PORT H043+$0840: shutdown: removes the VBlank server, frees the
 * objects, closes audio.device, the ports and the player memory.
 */
void h043_0840(void)
{
    if (!g_h043_m2) {
        return;
    }
    exec_rem_int_server(INTB_VERTB_NUM, &s_vblank_int);
    sx_free_all();
    if (g_sound->device != NULL) {
        exec_close_device((struct IORequest *)&g_sound->open_io);
        g_sound->device = NULL;
    }
    sx_delete_port(&g_sound->reply);
    sx_delete_port(&g_sound->port);
    sx_free((void **)&g_sound->periods, 0x280);
    sx_free((void **)&g_sound, sizeof(SoundX));
    g_h043_m2 = 0;
}

/*
 * PORT H043+$08C4: rewinds the tracks of the score, assigns the
 * instruments (tracks beyond the instruments use the first one) and marks all
 * the tracks active.
 */
static void sx_rewind_score(SxScore *s)
{
    s16 i;                              /* -$6(a5) */
    SxTrack *t;                         /* -$A(a5) */
    SxObject *ins;                      /* -$4(a5) */

    if (s_error) {
        return;
    }
    for (i = 0; i < (s16)s->ntracks; ++i) {
        t = s->tracks[i];
        t->cursor = t->data;
        if (i >= (s16)s->ninstr) {
            ins = s->instr[0];
        } else {
            ins = s->instr[i];
        }
        t->instr = ins;
        if (ins != NULL) {
            ++ins->refs;
        }
    }
    s->active = (u8)((1 << s->ntracks) - 1);
}

static SxObject *sx_load_object(char *name, u8 play);

/*
 * PORT H043+$0986: FORM SMUS of len bytes: SHDR (tempo / $44), INS1 (name
 * of the instrument, loaded), TRAK (track data).  The INS1 name
 * is not terminated in the original if it fills the buffer: here the buffer
 * starts cleared.
 */
static SxScore *sx_load_smus(s32 len, cok_bptr file)
{
    SxScore *s;                         /* -$3E(a5) */
    SxTrack *t;                         /* -$42(a5) */
    SxObject *ins;                      /* -$46(a5) */
    char id[5];                         /* -$6(a5); -$2(a5) cleared acts as the NUL */
    s32 size;                           /* -$A(a5) */
    u8 shdr[4];                         /* -$E(a5) */
    u8 skip4[4];                        /* -$12(a5) */
    char name[0x28];                    /* -$3A(a5) */

    memset(id, 0, sizeof(id));
    s = (SxScore *)sx_alloc(sizeof(SxScore));
    s->volume = 0x40;
    while (len >= 8 && !s_error) {
        if (len & 1) {
            sx_skip(file, 1);
            --len;
        }
        sx_read(file, id, 4);
        len -= 4;
        size = sx_read_long(file);
        len -= 4;
        len -= size;
        if (h026_compare(4, id, 4, "SHDR") == 1) {
            sx_read(file, shdr, 4);
            g_sound->tempo = (u32)(COK_GET16(shdr) / 0x44);
        } else if (h026_compare(4, id, 4, "INS1") == 1) {
            sx_read(file, skip4, 4);
            size -= 4;
            if (size > 0x28) {
                sx_error(5);
            }
            memset(name, 0, sizeof(name));
            sx_read(file, name, size);
            h026_upcase(0x27, name);
            ins = sx_load_object(name, 0);
            s->instr[s->ninstr] = ins;
            ++s->ninstr;
        } else if (h026_compare(4, id, 4, "TRAK") == 1) {
            t = (SxTrack *)sx_alloc(sizeof(SxTrack));
            t->volume = 0x80;
            t->data = (u8 *)sx_alloc((u32)size);
            t->end = t->data + size;
            s->tracks[s->ntracks] = t;
            sx_read(file, t->data, size);
            ++s->ntracks;
        } else {
            sx_skip(file, size);
        }
    }
    return s;
}

/*
 * PORT H043+$0BB2: FORM 8SVX of len bytes: VHDR (read as it is), BODY (in
 * CHIP memory), ATAK and the rest skipped.  A VHDR longer than $14 bytes
 * would write past the record in the original: here $14 is read and the
 * rest skipped.
 */
static Sx8svx *sx_load_8svx(s32 len, cok_bptr file)
{
    Sx8svx *v;                          /* -$12(a5) */
    char id[5];                         /* -$6(a5); -$2(a5) cleared acts as the NUL */
    s32 size;                           /* -$A(a5) */

    memset(id, 0, sizeof(id));
    v = (Sx8svx *)sx_alloc(sizeof(Sx8svx));
    while (len >= 8 && !s_error) {
        if (len & 1) {
            sx_skip(file, 1);
            --len;
        }
        sx_read(file, id, 4);
        size = sx_read_long(file);
        len -= 8;
        if (h026_compare(4, id, 4, "VHDR") == 1) {
            if (size > 0x14) {
                sx_read(file, v->vhdr, 0x14);
                sx_skip(file, size - 0x14);
            } else {
                sx_read(file, v->vhdr, size);
            }
            len -= size;
        } else if (h026_compare(4, id, 4, "BODY") == 1) {
            v->body_size = (u32)size;
            v->body = (s8 *)sx_alloc_chip((u32)size);
            sx_read(file, v->body, size);
            len -= size;
        } else if (h026_compare(4, id, 4, "ATAK") == 1) {
            sx_skip(file, size);
            len -= size;
        } else {
            sx_skip(file, size);
            len -= size;
        }
    }
    if (s_error) {
        return NULL;
    }
    return v;
}

/* PORT H043+$0D3A: FORM ENVL: length word and the len bytes. */
static u8 *sx_load_envl(s32 len, cok_bptr file)
{
    u8 *e = (u8 *)sx_alloc((u32)len + 2);  /* -$4(a5) */

    COK_PUT16(e, (u16)len);
    sx_read(file, e + 2, len);
    return e;
}

/*
 * PORT H043+$0D84: FORM INST: PTCH and VLUM (envelopes, after the length
 * word) and SAMP (sample), loaded by name.
 */
static SxInst *sx_load_inst(s32 len, cok_bptr file)
{
    SxInst *i;                          /* -$E(a5) */
    char id[5];                         /* -$6(a5); -$2(a5) cleared acts as the NUL */
    s32 size;                           /* -$A(a5) */
    char name[0x28];                    /* -$36(a5) */

    memset(id, 0, sizeof(id));
    i = (SxInst *)sx_alloc(sizeof(SxInst));
    while (len >= 8 && !s_error) {
        sx_read(file, id, 4);
        size = sx_read_long(file);
        len -= 8;
        memset(name, 0, sizeof(name));
        if (h026_compare(4, id, 4, "PTCH") == 1) {
            sx_read(file, name, size);
            i->ptch_obj = sx_load_object(name, 0);
            if (i->ptch_obj != NULL) {
                i->ptch = (u8 *)i->ptch_obj->data + 2;
            }
        } else if (h026_compare(4, id, 4, "VLUM") == 1) {
            sx_read(file, name, size);
            i->vlum_obj = sx_load_object(name, 0);
            if (i->vlum_obj != NULL) {
                i->vlum = (u8 *)i->vlum_obj->data + 2;
            }
        } else if (h026_compare(4, id, 4, "SAMP") == 1) {
            sx_read(file, name, size);
            i->samp_obj = sx_load_object(name, 0);
            if (i->samp_obj != NULL) {
                i->samp = (Sx8svx *)i->samp_obj->data;
            }
        } else {
            sx_skip(file, size);
        }
        len -= size;
    }
    return i;
}

/*
 * PORT H043+$0F50: looks for name among the active and loaded ones and, if it
 * finds it, removes it from its list.
 */
static SxObject *sx_find_object(const char *name)
{
    SxObject *found = NULL;             /* -$4(a5) */
    SxObject *p;                        /* -$8(a5) */
    SxObject *prev = NULL;              /* -$C(a5) */
    u8 in_loaded = 0;                   /* -$D(a5) */

    exec_disable();
    p = g_sound->active;
    if (p == NULL) {
        p = g_sound->loaded;
        in_loaded = 1;
    }
    while (p != NULL) {
        if (h026_compare(0x27, p->name, 0x27, name) == 1) {
            found = p;
            if (prev == NULL) {
                if (in_loaded) {
                    g_sound->loaded = p->next;
                } else {
                    g_sound->active = p->next;
                }
            } else {
                prev->next = p->next;
            }
            p->next = NULL;
            p = NULL;
        } else {
            prev = p;
            p = p->next;
            if (p == NULL && !in_loaded) {
                p = g_sound->loaded;
                prev = NULL;
                in_loaded = 1;
            }
        }
    }
    exec_enable();
    return found;
}

/*
 * PORT H043+$1058: puts o among the active ones (play: plays from now, marked with
 * bit 4) or among the loaded ones.  A score first stops everything and rewinds.
 */
static void sx_add_object(u8 play, SxObject *o)
{
    SxScore *s;                         /* -$4(a5) */
    s16 i;                              /* -$6(a5) */
    SxTrack *t;                         /* -$A(a5) */

    if (o->flags & 0x01) {
        sx_stop_all();
        sx_rewind_score((SxScore *)o->data);
    }
    exec_disable();
    if (play) {
        o->flags = (u8)(o->flags + 0x10);
        o->next = g_sound->active;
        g_sound->active = o;
        if (o->flags & 0x01) {
            s = (SxScore *)o->data;
            for (i = 0; i < (s16)s->ntracks; ++i) {
                t = s->tracks[i];
                if (t != NULL) {
                    t->time = g_sound->clock;
                }
            }
        }
    } else {
        o->next = g_sound->loaded;
        g_sound->loaded = o;
    }
    exec_enable();
}

/* PORT H043+$01D2: trampoline (bra.w) to H043+$113E, the routine below. */
/*
 * PORT H043+$113E (also $01D2): the object name (already loaded, or
 * from the file SOUND/name or, the first time it is missing, from SOUND/soundData).
 * The file is a sequence of FORMs (with an optional NAME in front); the
 * objects with another name are loaded and stay among the loaded ones.  As
 * in the original, a FORM already present is skipped and the object found
 * leaves its list.
 */
static SxObject *sx_load_object(char *name, u8 play)
{
    cok_bptr file;                      /* -$4(a5) */
    char path[0x2C];                    /* -$2C(a5) */
    char fname[0x28];                   /* -$54(a5) */
    char id[5];                         /* -$5A(a5); -$56(a5) cleared acts as the NUL */
    s32 total;                          /* -$5E(a5) */
    s32 size;                           /* -$62(a5) */
    SxObject *result;                   /* -$66(a5) */
    SxObject *o;                        /* -$6A(a5) */
    u8 from_data = 0;                   /* -$6B(a5) */

    memset(id, 0, sizeof(id));
    h026_upcase(0x27, name);
    o = sx_find_object(name);
    if (o != NULL) {
        sx_add_object(play, o);
        return o;
    }
    result = NULL;
    memset(path, 0, sizeof(path));
    h026_copy(0x27, path, 0x27, s_sound_dir);
    h026_append(0x27, path, 0x27, name);
    file = dos_open(path, MODE_OLDFILE);
    if (file == 0 && !g_h043_m1) {
        h026_copy(0x27, path, 0x27, s_sound_dir);
        h026_append(0x27, path, 9, "soundData");
        file = dos_open(path, MODE_OLDFILE);
        g_h043_m1 = 1;
        from_data = 1;
    }
    if (file == 0) {
        s_error = 1;
        return result;
    }
    (void)dos_seek(file, 0, 1);
    total = dos_seek(file, 0, -1);
    sx_skip(file, 0);
    while (total > 0 && !s_error) {
        sx_read(file, id, 4);
        total -= 4;
        memset(fname, 0, sizeof(fname));
        if (h026_compare(4, id, 4, "NAME") == 1) {
            size = sx_read_long(file);
            total -= 4;
            sx_read(file, fname, size);
            h026_upcase(0x27, fname);
            total -= size;
            sx_read(file, id, 4);
            total -= 4;
        } else {
            h026_copy(0x27, fname, 0x27, name);
        }
        if (h026_compare(4, id, 4, "FORM") != 1) {
            s_error = 1;
        }
        size = sx_read_long(file);
        total -= 4;
        total -= size;
        if (sx_find_object(fname) != NULL) {
            sx_skip(file, size);
            continue;
        }
        o = (SxObject *)sx_alloc(sizeof(SxObject));
        sx_read(file, id, 4);
        size -= 4;
        if (!s_error) {
            if (h026_compare(4, id, 4, "SMUS") == 1) {
                o->data = sx_load_smus(size, file);
                o->flags = 1;
            } else if (h026_compare(4, id, 4, "8SVX") == 1) {
                o->data = sx_load_8svx(size, file);
                o->flags = 4;
            } else if (h026_compare(4, id, 4, "INST") == 1) {
                o->data = sx_load_inst(size, file);
                o->flags = 2;
            } else if (h026_compare(4, id, 4, "ENVL") == 1) {
                o->data = sx_load_envl(size, file);
                o->flags = 0x40;
            } else {
                s_error = 1;
            }
            if (o->data == NULL) {
                s_error = 1;
            }
        }
        if (s_error) {
            sx_free_object(&o);
            return NULL;
        }
        ++o->refs;
        o->name = (char *)sx_alloc(0x28);
        h026_copy(0x27, o->name, 0x27, fname);
        if (h026_compare(0x27, fname, 0x27, name) == 1) {
            sx_add_object(play, o);
            result = o;
        } else {
            sx_add_object(0, o);
        }
    }
    dos_close(file);
    if (from_data) {
        g_h043_m1 = 0;
    }
    return result;
}

/* PORT H043+$01CA: trampoline (bra.w) to H043+$165A, the routine below. */
/*
 * PORT H043+$165A (also $01CA): "SoundX is quiting, exit code =", the
 * code, audio shutdown and exit from the game.
 */
static void sx_error(u16 code)
{
    console_write(0x1E, "SoundX is quiting, exit code =");
    console_write_int(code, 2);
    console_newline();
    h043_0840();
    quit_game();
}

/* PORT H043+$169A: name of sound number 2..$17 (the others: unchanged). */
static void sx_sound_name(u16 n, char *buf, u16 max)
{
    static const char *const names[0x16] = {
        "cast", "cast2", "cast3", "cast4", "swish", "spell", "dead0",
        "dead1", "dead", "dead3", "dead4", "whisl", "hit", "light",
        "swish", "pad", "bigPad", "fireb", "arrow", "turn", "gate", "krynn"
    };

    if (n >= 2 && n <= 0x17) {
        h026_copy(max, buf, (u16)strlen(names[n - 2]), names[n - 2]);
    }
}

/*
 * PORT H043+$0584: start-up: "SOUND/periodTable" ($80 periods and $40
 * durations), two ports, audio.device with the channel mask $F, 16
 * CMD_WRITE requests (made free with ReplyMsg) and the VBlank server
 * that triggers the software interrupt of the player (H094).  The reply
 * port of the open call is an uninitialised local variable
 * in the original: here cleared.
 */
void h043_0584(void)
{
    char path[0x28];                    /* -$4E(a5) */
    cok_bptr file;                      /* -$52(a5) */
    struct MsgPort open_port;           /* -$24(a5) */
    UBYTE mask;                         /* -$1(a5) */
    s16 i;                              /* -$26(a5) */
    struct IOAudio *io;

    h026_copy(0x27, s_sound_dir, 6, "SOUND/");
    if (g_h043_m2) {
        return;
    }
    g_sound = (SoundX *)sx_alloc(sizeof(SoundX));
    g_sound->tempo = 1;
    g_sound->periods = (u32 *)sx_alloc(0x280);
    g_sound->durations = (u16 *)((u8 *)g_sound->periods + 0x200);
    h026_copy(0x27, path, 0x27, s_sound_dir);
    h026_append(0x27, path, 0x0B, "periodTable");
    s_resource_result = open_resource_file(0x27, path, 0x13,
                                           "Insert Disk One in ", 0, &file);
    if (file == 0) {
        sx_error(3);
    }
    sx_read(file, g_sound->periods, 0x280);
    dos_close(file);
    g_sound->port = sx_create_port();
    g_sound->reply = sx_create_port();
    mask = 0x0F;
    memset(&open_port, 0, sizeof(open_port));
    io = &g_sound->open_io;
    io->ioa_Request.io_Message.mn_Node.ln_Pri = 0x7F;
    io->ioa_Request.io_Message.mn_ReplyPort = &open_port;
    io->ioa_Data = &mask;
    io->ioa_Length = 1;
    if (exec_open_device("audio.device", 0, (struct IORequest *)io, 0) != 0) {
        sx_error(4);
    }
    g_sound->device = io->ioa_Request.io_Device;
    g_h043_m3 = 1;
    io = &g_sound->model;
    io->ioa_Request.io_Message.mn_ReplyPort = g_sound->reply;
    io->ioa_Request.io_Device = g_sound->device;
    io->ioa_Request.io_Unit = NULL;
    io->ioa_Request.io_Command = 8;     /* CMD_FLUSH */
    io->ioa_Request.io_Flags = 1;       /* IOF_QUICK */
    io->ioa_Request.io_Error = 0;
    g_sound->model.ioa_AllocKey = g_sound->open_io.ioa_AllocKey;
    for (i = 0; i < 16; ++i) {
        g_sound->requests[i] = g_sound->model;
        g_sound->requests[i].ioa_Request.io_Command = 3;   /* CMD_WRITE */
        g_sound->requests[i].ioa_Request.io_Flags = 0x10;  /* ADIOF_PERVOL */
        exec_reply_msg(&g_sound->requests[i].ioa_Request.io_Message);
    }
    s_soft_int.is_Node.ln_Pri = 0;
    s_soft_int.is_Node.ln_Type = 2;     /* NT_INTERRUPT */
    s_soft_int.is_Node.ln_Name = NULL;
    s_soft_int.is_Data = g_sound;
    s_soft_int.is_Code = (void (*)(void))audio_soft_interrupt;
    s_vblank_int.is_Node.ln_Pri = 0;
    s_vblank_int.is_Node.ln_Type = 2;
    s_vblank_int.is_Node.ln_Name = NULL;
    s_vblank_int.is_Data = &s_soft_int;
    s_vblank_int.is_Code = (void (*)(void))audio_vblank_server;
    exec_add_int_server(INTB_VERTB_NUM, &s_vblank_int);
    g_h043_m2 = 1;
}

/*
 * PORT H043+$190E: audio command: $FF stops everything; 0 stops and disables;
 * 1 enables; $FE reloads (removes the server, frees everything, puts it back);
 * $FD preloads the sounds 1..$16; otherwise, if enabled, plays
 * sound number command.
 */
void h043_190e(u16 command)
{
    if (command == 0xFF) {
        sx_stop_all();
    } else if (command == 0) {
        sx_stop_all();
        g_h043_m5 = 0;
    } else if (command == 1) {
        g_h043_m5 = 1;
    } else if (command == 0xFE) {
        exec_rem_int_server(INTB_VERTB_NUM, &s_vblank_int);
        sx_free_all();
        exec_add_int_server(INTB_VERTB_NUM, &s_vblank_int);
    } else if (command == 0xFD) {
        for (command = 1; command <= 0x16; ++command) {
            s_error = 0;
            sx_sound_name(command, s_name, 0x27);
            s_last_loaded = sx_load_object(s_name, 0);
        }
    } else if (g_h043_m5) {
        s_error = 0;
        sx_sound_name(command, s_name, 0x27);
        s_last_loaded = sx_load_object(s_name, 1);
    }
}

#endif /* COK_AUDIO */
