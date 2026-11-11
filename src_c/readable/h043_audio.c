/*
 * H043: "SoundX", caricamento e gestione di brani SMUS e campioni 8SVX,
 * avvio e chiusura di audio.device e del server del VBlank (H094).
 * Tutto il lettore e' compilato solo con COK_AUDIO; senza, h043_0584,
 * h043_0840 e h043_190e sono gli stub di unported.c.
 */
#include <string.h>
#include "h043_audio.h"

/* Dati del modulo (offset rispetto ad a4). */
u8  g_h043_m1;                  /* -$1: soundData aperto da load_object */
u8  g_h043_m2;                  /* -$2: lettore avviato */
u8  g_h043_m3;                  /* -$3: audio.device aperto */
u8  g_h043_m5;                  /* -$5: musica abilitata */
u32 g_h043_m8a;                 /* -$8A (il puntatore e' g_sound) */

/* PORT H043+$01BC (corpo a $19FC) */
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

/* PORT H043+$01D6: memoria CHIP, altrimenti errore 1. */
static void *sx_alloc_chip(u32 size)
{
    void *p = exec_alloc_mem(size, COK_MEMF_CHIP);

    if (p == NULL) {
        sx_error(1);
    }
    return p;
}

/* PORT H043+$0214: memoria azzerata, altrimenti errore 2. */
static void *sx_alloc(u32 size)
{
    void *p = exec_alloc_mem(size, COK_MEMF_CLEAR);

    if (p == NULL) {
        sx_error(2);
    }
    return p;
}

/* PORT H043+$0252: libera *pp di size byte e lo azzera. */
static void sx_free(void **pp, u32 size)
{
    if (*pp != NULL) {
        exec_free_mem(*pp, size);
        *pp = NULL;
    }
}

/* PORT H043+$0286: salta n byte del file (errore se Seek fallisce). */
static void sx_skip(cok_bptr file, s32 n)
{
    if (!s_error && dos_seek(file, n, 0) == -1) {
        s_error = 1;
    }
}

/* PORT H043+$02C4: legge n byte (errore se ne arrivano meno). */
static void sx_read(cok_bptr file, void *buf, s32 n)
{
    if (!s_error && dos_read(file, buf, n) != n) {
        s_error = 1;
    }
}

/* Lunghezze dei blocchi IFF: long big-endian. */
static s32 sx_read_long(cok_bptr file)
{
    u8 b[4];

    memset(b, 0, sizeof(b));
    sx_read(file, b, 4);
    return (s32)COK_GET32(b);
}

/* PORT H043+$0304: porta messaggi senza segnale (tipo 4, lista vuota). */
static struct MsgPort *sx_create_port(void)
{
    struct MsgPort *p = (struct MsgPort *)sx_alloc(sizeof(struct MsgPort));

    p->mp_Node.ln_Type = 4;
    exec_new_list(&p->mp_MsgList);
    return p;
}

/* PORT H043+$0340: chiude la porta (tipo $FF, lista -1) e la libera. */
static void sx_delete_port(struct MsgPort **pp)
{
    if (*pp != NULL) {
        (*pp)->mp_Node.ln_Type = 0xFF;
        (*pp)->mp_MsgList.lh_Head = (struct Node *)-1;
        sx_free((void **)pp, sizeof(struct MsgPort));
        *pp = NULL;
    }
}

/* PORT H043+$038A: libera una traccia. */
static void sx_free_track(SxTrack *t)
{
    sx_free((void **)&t->data, (u32)(t->end - t->data));
    sx_free((void **)&t, sizeof(SxTrack));
}

/* PORT H043+$03CA: libera un brano con le sue tracce. */
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

/* PORT H043+$0422: libera un campione 8SVX. */
static void sx_free_8svx(Sx8svx *v)
{
    if (v == NULL) {
        return;
    }
    sx_free((void **)&v->body, v->body_size);
    sx_free((void **)&v, sizeof(Sx8svx));
}

/* PORT H043+$045E: libera un inviluppo (word della lunghezza + dati). */
static void sx_free_envl(u8 *e)
{
    if (e == NULL) {
        return;
    }
    sx_free((void **)&e, (u32)COK_GET16(e) + 2);
}

/* PORT H043+$048E: libera uno strumento (non i suoi oggetti). */
static void sx_free_inst(SxInst *i)
{
    if (i == NULL) {
        return;
    }
    sx_free((void **)&i, sizeof(SxInst));
}

/* PORT H043+$04B6: libera *pp secondo il tipo e lo sostituisce col seguente. */
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

/* PORT H043+$07F6: trampolino (bra.w) verso H043+$15C6, la routine qui sotto. */
/*
 * PORT H043+$15C6 (anche $07F6): ferma tutto: gli oggetti attivi non
 * suonano piu' in questo turno (bit 4), le voci finiscono subito e la
 * lista delle note da assegnare si svuota.
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

/* PORT H043+$07FA: ferma tutto e libera tutti gli oggetti. */
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
 * PORT H043+$0840: chiusura: toglie il server del VBlank, libera gli
 * oggetti, chiude audio.device, le porte e la memoria del lettore.
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
 * PORT H043+$08C4: riporta all'inizio le tracce del brano, assegna gli
 * strumenti (le tracce oltre gli strumenti usano il primo) e segna attive
 * tutte le tracce.
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
 * PORT H043+$0986: FORM SMUS di len byte: SHDR (tempo / $44), INS1 (nome
 * dello strumento, caricato), TRAK (dati della traccia).  Il nome di INS1
 * non e' terminato nell'originale se riempie il buffer: qui il buffer
 * parte azzerato.
 */
static SxScore *sx_load_smus(s32 len, cok_bptr file)
{
    SxScore *s;                         /* -$3E(a5) */
    SxTrack *t;                         /* -$42(a5) */
    SxObject *ins;                      /* -$46(a5) */
    char id[5];                         /* -$6(a5); -$2(a5) azzerato fa da NUL */
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
 * PORT H043+$0BB2: FORM 8SVX di len byte: VHDR (letto com'e'), BODY (in
 * memoria CHIP), ATAK e il resto saltati.  Un VHDR piu' lungo di $14 byte
 * scriverebbe oltre il record nell'originale: qui si legge $14 e si salta
 * il resto.
 */
static Sx8svx *sx_load_8svx(s32 len, cok_bptr file)
{
    Sx8svx *v;                          /* -$12(a5) */
    char id[5];                         /* -$6(a5); -$2(a5) azzerato fa da NUL */
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

/* PORT H043+$0D3A: FORM ENVL: word della lunghezza e i len byte. */
static u8 *sx_load_envl(s32 len, cok_bptr file)
{
    u8 *e = (u8 *)sx_alloc((u32)len + 2);  /* -$4(a5) */

    COK_PUT16(e, (u16)len);
    sx_read(file, e + 2, len);
    return e;
}

/*
 * PORT H043+$0D84: FORM INST: PTCH e VLUM (inviluppi, dopo la word della
 * lunghezza) e SAMP (campione), caricati per nome.
 */
static SxInst *sx_load_inst(s32 len, cok_bptr file)
{
    SxInst *i;                          /* -$E(a5) */
    char id[5];                         /* -$6(a5); -$2(a5) azzerato fa da NUL */
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
 * PORT H043+$0F50: cerca per nome fra gli attivi e i caricati e, se lo
 * trova, lo toglie dalla sua lista.
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
 * PORT H043+$1058: mette o fra gli attivi (play: suona da ora, segnato col
 * bit 4) o fra i caricati.  Un brano prima ferma tutto e si riavvolge.
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

/* PORT H043+$01D2: trampolino (bra.w) verso H043+$113E, la routine qui sotto. */
/*
 * PORT H043+$113E (anche $01D2): l'oggetto name (gia' caricato, oppure
 * dal file SOUND/name o, la prima volta che manca, da SOUND/soundData).
 * Il file e' una sequenza di FORM (con un NAME facoltativo davanti); gli
 * oggetti con altro nome si caricano e restano fra i caricati.  Come
 * nell'originale, un FORM gia' presente viene saltato e l'oggetto trovato
 * esce dalla sua lista.
 */
static SxObject *sx_load_object(char *name, u8 play)
{
    cok_bptr file;                      /* -$4(a5) */
    char path[0x2C];                    /* -$2C(a5) */
    char fname[0x28];                   /* -$54(a5) */
    char id[5];                         /* -$5A(a5); -$56(a5) azzerato fa da NUL */
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

/* PORT H043+$01CA: trampolino (bra.w) verso H043+$165A, la routine qui sotto. */
/*
 * PORT H043+$165A (anche $01CA): "SoundX is quiting, exit code =", il
 * codice, chiusura dell'audio e uscita dal gioco.
 */
static void sx_error(u16 code)
{
    console_write(0x1E, "SoundX is quiting, exit code =");
    console_write_int(code, 2);
    console_newline();
    h043_0840();
    quit_game();
}

/* PORT H043+$169A: nome del suono numero 2..$17 (gli altri: invariato). */
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
 * PORT H043+$0584: avvio: "SOUND/periodTable" ($80 periodi e $40
 * durate), due porte, audio.device con la maschera dei canali $F, 16
 * richieste CMD_WRITE (rese libere con ReplyMsg) e il server del VBlank
 * che fa partire l'interrupt software del lettore (H094).  La porta delle
 * risposte dell'apertura e' una variabile locale non inizializzata
 * nell'originale: qui azzerata.
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
 * PORT H043+$190E: comando audio: $FF ferma tutto; 0 ferma e disabilita;
 * 1 abilita; $FE ricarica (toglie il server, libera tutto, lo rimette);
 * $FD carica in anticipo i suoni 1..$16; altrimenti, se abilitata, suona
 * il suono numero command.
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
