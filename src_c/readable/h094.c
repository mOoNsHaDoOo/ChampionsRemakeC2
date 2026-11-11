/*
 * H094: Callback audio: server del VBlank e interrupt software che fa
 * suonare il lettore SoundX (H043).  Compilato solo con COK_AUDIO.
 * Nell'originale e' assembly scritto a mano con lo stato del lettore in
 * a5; qui ogni routine riceve il puntatore al lettore.
 */
#include "cok.h"

/* PORT H094+$0004: rts. */
void h094_init(void)
{
}

#ifdef COK_AUDIO

#include "h043_audio.h"
#if COK_AMIGA
#include <proto/exec.h>
#include <clib/alib_protos.h>
#endif

#define VHDR_L(v, o)    COK_GET32(&(v)->vhdr[(o)])
#define VHDR_W(v, o)    COK_GET16(&(v)->vhdr[(o)])

/* Periodo della nota n e durata d (tabelle big-endian di periodTable). */
#define PERIOD(sx, n)   COK_GET32((u8 *)(sx)->periods + (n) * 4)
#define DURATION(sx, d) COK_GET16((u8 *)(sx)->durations + (d) * 2)

/* Richiesta libera dalla porta delle risposte, o NULL. */
static struct IOAudio *free_request(SoundX *sx)
{
    return (struct IOAudio *)GetMsg(sx->reply);
}

static void send(struct IOAudio *io, u32 unit_mask, u16 command, u8 flags)
{
#if COK_AMIGA
    io->ioa_Request.io_Unit = (struct Unit *)unit_mask;
#else
    io->ioa_Request.io_Unit = (struct Unit *)(uintptr_t)unit_mask;
#endif
    io->ioa_Request.io_Command = command;
    io->ioa_Request.io_Flags = flags;
    BeginIO((struct IORequest *)io);
}

/*
 * divu.w: dividend / divisor in 16 bit; se il quoziente non sta in una
 * word il dividendo resta com'e' (V acceso).  Restituisce 1 se riuscita.
 */
static int divu_w(u32 *d, u16 divisor)
{
    u32 q;

    if (divisor == 0) {
        return 0;
    }
    q = *d / divisor;
    if (q > 0xFFFF) {
        return 0;
    }
    *d = ((*d % divisor) << 16) | q;
    return 1;
}

/* PORT H094+$0738: una delle 8 note libere (flag 7) in testa alle da assegnare. */
static SxNote *alloc_note(SoundX *sx)
{
    u16 i;
    SxNote *n;

    for (i = 0; i < 8; ++i) {
        n = &sx->notes[i];
        if (!(n->flags & 2)) {
            n->flags = 7;
            n->next = sx->pending;
            sx->pending = n;
            return n;
        }
    }
    return NULL;
}

/*
 * PORT H094+$0288: avvia la nota note della traccia t sulla nota n:
 * campione dell'ottava giusta (con samplesPerHiCycle il periodo si
 * dimezza e il campione raddoppia finche' il periodo e' sotto $118 o
 * finiscono le ottave; altrimenti periodo da samplesPerSec), inviluppi
 * dello strumento e volume brano * traccia.  Senza strumento l'originale
 * leggerebbe da indirizzi nulli: qui la nota resta muta.
 */
static void start_note(SoundX *sx, SxScore *sc, SxTrack *t, SxNote *n,
                       u16 note)
{
    SxInst *inst;
    Sx8svx *v;
    u32 per;
    u32 d1;
    u16 oct;
    u32 d3;
    u32 d4;
    u32 d5 = 0;

    if (t->instr == NULL || t->instr->data == NULL ||
        ((SxInst *)t->instr->data)->samp == NULL) {
        return;
    }
    inst = (SxInst *)t->instr->data;
    v = inst->samp;
    per = VHDR_L(v, 8);
    if (per != 0) {
        d1 = PERIOD(sx, note);
        oct = v->vhdr[0x0E];
        d3 = VHDR_L(v, 0);
        d4 = VHDR_L(v, 4);
        while (!divu_w(&d1, (u16)per)) {
            if ((s16)oct <= 1) {
                goto done;
            }
            d5 += d3 + d4;
            d3 <<= 1;
            d4 <<= 1;
            d1 = (u32)((s32)d1 >> 1);
            --oct;
        }
        while ((s16)oct > 1 && (u16)d1 >= 0x118) {
            d5 += d3 + d4;
            d3 <<= 1;
            d4 <<= 1;
            d1 = (d1 & 0xFFFF0000UL) | (u16)((s16)(u16)d1 >> 1);
            --oct;
        }
done:
        n->data = v->body + d5;
        n->repeat = n->data + d3;
        n->len1 = d3;
        n->len2 = d4;
    } else {
        d1 = 0x369E9AUL;
        (void)divu_w(&d1, VHDR_W(v, 0x0C));
        d3 = VHDR_L(v, 0);
        d4 = VHDR_L(v, 4);
        n->data = v->body;
        n->repeat = n->data + d3;
        n->len1 = d3;
        n->len2 = d4;
    }
    n->period = (u16)d1;
    n->period_now = (u16)d1;
    if (inst->ptch == NULL) {
        n->ptch = NULL;
    } else {
        n->ptch = inst->ptch;
        n->period_count = 0;
        n->period_step = 0;
    }
    n->volume = (u16)(sc->volume * t->volume);
    n->volume_now = n->volume;
    if (inst->vlum == NULL) {
        n->vlum = NULL;
    } else {
        n->vlum = inst->vlum;
        n->volume_count = 0;
        n->volume_step = 0;
    }
}

/*
 * PORT H094+$01BE: eventi della traccia i fino all'istante corrente:
 * note e pause (durata dalla tabella; legature e accordi), cambio di
 * strumento ($81), volume ($84), fine ($FF o fine dei dati).
 */
static void play_track(SoundX *sx, SxScore *sc, SxTrack *t, u16 i)
{
    u32 dur = 0;                        /* d4 */
    u16 type;                           /* d6 */
    u16 data;                           /* d5 */
    SxNote *n;

    for (;;) {
        if (t->time > sx->clock) {
            return;
        }
        if (t->cursor >= t->end) {
            sc->active = (u8)(sc->active & ~(1 << (i & 7)));
            return;
        }
        type = *t->cursor++;
        data = *t->cursor++;
        if (type <= 0x80) {
            if (data & 0x80) {
                continue;
            }
            dur += DURATION(sx, data & 0x3F);
            if (data & 0x40) {
                continue;
            }
            if (type != 0x80) {
                n = alloc_note(sx);
                if (n != NULL) {
                    n->start = t->time;
                    n->end = t->time + dur;
                    start_note(sx, sc, t, n, type);
                }
            }
            t->time += dur;
            dur = 0;
        } else if (type == 0x81) {
            if (data > sc->ninstr) {
                data = 0;
            }
            t->instr = sc->instr[data & 7];
        } else if (type == 0x84) {
            t->volume = (u8)data;
        } else if (type == 0xFF) {
            sc->active = (u8)(sc->active & ~(1 << (i & 7)));
            return;
        }
    }
}

/* PORT H094+$0188: le tracce del brano; finito, l'oggetto non suona piu'. */
static void play_score(SoundX *sx, SxObject *o)
{
    SxScore *sc = (SxScore *)o->data;
    u16 i;

    for (i = 0; i < sc->ntracks; ++i) {
        play_track(sx, sc, sc->tracks[i], i);
    }
    if (!sc->active) {
        o->flags = (u8)(o->flags & ~0x10);
    }
}

/*
 * PORT H094+$0390: suono singolo (8SVX o strumento INST): una nota dal
 * momento corrente, all'ottava piu' alta, con periodo da samplesPerSec
 * (0: 2000) e volume dal VHDR; senza parte ripetuta finisce dopo la
 * durata del campione.  samplesPerSec 0 dividerebbe per zero
 * nell'originale: qui il quoziente resta quello del dividendo.
 */
static void play_sample(SoundX *sx, SxObject *o)
{
    SxNote *n;
    SxObject *so = o;
    SxInst *inst;
    Sx8svx *v;
    u32 d0;
    u32 d1;
    u16 oct;
    u32 d3;
    u32 d4;
    u32 d5 = 0;
    u16 sps;

    o->flags = (u8)(o->flags & ~0x10);
    n = alloc_note(sx);
    if (n == NULL) {
        return;
    }
    if (!(o->flags & 2)) {
        n->ptch = NULL;
        n->vlum = NULL;
    } else {
        inst = (SxInst *)o->data;
        if (inst->ptch == NULL) {
            n->ptch = NULL;
        } else {
            n->ptch = inst->ptch;
            n->period_count = 0;
            n->period_step = 0;
        }
        if (inst->vlum == NULL) {
            n->vlum = NULL;
        } else {
            n->vlum = inst->vlum;
            n->volume_count = 0;
            n->volume_step = 0;
        }
        so = inst->samp_obj;
    }
    n->start = sx->clock;
    v = (Sx8svx *)so->data;
    sps = VHDR_W(v, 0x0C);
    if (sps == 0) {
        sps = 0x7D0;
    }
    d1 = 0x369E9AUL;
    (void)divu_w(&d1, sps);
    oct = v->vhdr[0x0E];
    d3 = VHDR_L(v, 0);
    d4 = VHDR_L(v, 4);
    while ((s16)oct > 1) {
        d5 += d3 + d4;
        d3 <<= 1;
        d4 <<= 1;
        --oct;
    }
    n->data = v->body + d5;
    n->repeat = n->data + d3;
    n->len1 = d3;
    n->len2 = d4;
    n->end = 0xFFFFFFFFUL;
    if (VHDR_L(v, 4) == 0) {
        d0 = (u32)(u16)sx->tempo * 0x3CUL;
        d0 = (u32)(u16)d0 * (u32)(u16)VHDR_L(v, 0);
        (void)divu_w(&d0, VHDR_W(v, 0x0C));
        d0 = (u32)(s32)(s16)(u16)d0;
        n->end = d0 + sx->clock;
    }
    n->period = (u16)d1;
    n->period_now = (u16)d1;
    d0 = VHDR_L(v, 0x10);
    if ((s32)d0 >= 0x10000L) {
        d0 = 0x4000;
    } else {
        d0 >>= 2;
    }
    n->volume = (u16)d0;
    n->volume_now = (u16)d0;
}

/*
 * PORT H094+$0108: gli oggetti attivi suonano; quelli finiti (bit 4
 * spento) passano fra i caricati.
 */
static void play_objects(SoundX *sx)
{
    SxObject *o = sx->active;
    SxObject *prev = NULL;
    SxObject *next;

    while (o != NULL) {
        if (o->flags & 0x01) {
            play_score(sx, o);
        } else if (o->flags & 0x02) {
            play_sample(sx, o);
        } else if (o->flags & 0x04) {
            play_sample(sx, o);
        }
        if (o->flags & 0x10) {
            prev = o;
            o = o->next;
            continue;
        }
        next = o->next;
        if (prev == NULL) {
            sx->active = next;
        } else {
            prev->next = next;
        }
        o->next = sx->loaded;
        sx->loaded = o;
        o = next;
    }
}

/*
 * PORT H094+$003A: assegna alle voci le note nuove: una voce libera, o
 * quella che finisce prima (fermata con ADCMD_FINISH).  Le note senza il
 * bit 0 tornano libere.
 */
static void assign_voices(SoundX *sx)
{
    SxNote *n = sx->pending;            /* a4 */
    SxNote *prev = NULL;                /* d6 */
    s16 slot;                           /* d7 */
    s16 best;                           /* d5 */
    u32 earliest;                       /* d4 */
    SxNote *v;
    struct IOAudio *io;

    sx->pending = NULL;
    while (n != NULL) {
        if (!(n->flags & 1)) {
            n->flags = (u8)(n->flags & ~2);
            if (prev == NULL) {
                sx->pending = n->next;
            } else {
                prev->next = n->next;
            }
            n = n->next;
            continue;
        }
        earliest = 0xFFFFFFFFUL;
        best = 3;
        for (slot = 3; slot >= 0; --slot) {
            v = sx->voice[slot];
            if (v == NULL) {
                break;
            }
            if (earliest >= v->end) {
                earliest = v->end;
                best = slot;
            }
        }
        if (slot < 0) {
            slot = best;
            v = sx->voice[slot];
            v->flags = (u8)(v->flags & ~2);
            io = free_request(sx);
            if (io == NULL) {
                return;
            }
            send(io, 1UL << slot, 11, 0);      /* ADCMD_FINISH */
        }
        sx->voice[slot] = n;
        prev = n;
        n = n->next;
    }
}

/*
 * PORT H094+$04A4: per ogni voce: a fine nota ADCMD_FINISH; poi gli
 * inviluppi di periodo (PTCH) e volume (VLUM); una nota nuova parte con
 * CMD_WRITE della parte iniziale (1 ciclo) e di quella ripetuta (senza
 * fine), le altre aggiornano periodo e volume con ADCMD_PERVOL.
 */
static void update_voices(SoundX *sx)
{
    s16 slot;
    u32 unit = 8;
    SxNote *n;
    u8 *p;
    u16 d1;
    u16 d0;
    s32 d2;
    struct IOAudio *io;

    for (slot = 3; slot >= 0; --slot, unit >>= 1) {
        n = sx->voice[slot];
        if (n == NULL) {
            continue;
        }
        if (n->end < sx->clock) {
            goto finish;
        }
        if (n->ptch != NULL) {
            n->period_now = (u16)(n->period_now + n->period_step);
            if ((u8)(--n->period_count) == 0 || n->period_count == 0xFF) {
                p = n->ptch;
                for (;;) {
                    d1 = *p++;
                    if (d1 == 0xFF) {
                        d1 = *p++;
                        if (d1 == 0) {
                            goto finish;
                        }
                        if (d1 == 1) {
                            n->ptch = NULL;
                            break;
                        }
                        d1 = (u16)(*p++ << 8);
                        d1 = (u16)(d1 | *p++);
                        n->period_now = d1;
                        continue;
                    }
                    if (d1 == 0xFE) {
                        d1 = *p++;
                        p -= ((u32)d1 + 1) * 2;
                        continue;
                    }
                    n->period_step = (s16)(s8)*p++;
                    n->period_count = (u8)d1;
                    n->ptch = p;
                    break;
                }
            }
        }
        if (n->vlum != NULL) {
            n->volume_now = (u16)(n->volume_now + n->volume_step);
            if ((u8)(--n->volume_count) == 0 || n->volume_count == 0xFF) {
                p = n->vlum;
                for (;;) {
                    d1 = *p++;
                    if (d1 == 0xFF) {
                        if (*p == 0) {
                            goto finish;
                        }
                        n->vlum = NULL;
                        break;
                    }
                    if (d1 == 0xFE) {
                        d1 = *p++;
                        p -= ((u32)d1 + 1) * 2;
                        continue;
                    }
                    d0 = *p++;
                    if (d0 & 0x80) {
                        d0 = (u16)((u16)((u16)(d0 - 0xC0) << 8) + n->volume_now);
                    } else {
                        d2 = (s32)((u32)n->volume * d0) >> 6;
                        if ((s16)d2 > 0x4000) {
                            d2 = 0x4000;
                        }
                        d0 = (u16)d2;
                    }
                    if (d1 == 0) {
                        n->volume_now = d0;
                        continue;
                    }
                    n->volume_count = (u8)d1;
                    if (d1 == 1) {
                        n->volume_now = d0;
                        n->volume_step = 0;
                    } else {
                        n->volume_step = (s16)((s32)(s16)(u16)(d0 - n->volume_now) /
                                               (s16)d1);
                    }
                    n->vlum = p;
                    break;
                }
            }
        }
        if (!(n->flags & 4)) {
            if (n->ptch == NULL && n->vlum == NULL) {
                continue;
            }
            io = free_request(sx);
            if (io == NULL) {
                return;
            }
            io->ioa_Period = n->period_now;
            io->ioa_Volume = (UWORD)(n->volume_now >> 8);
            send(io, unit, 12, 0x10);           /* ADCMD_PERVOL */
            continue;
        }
        n->flags = (u8)(n->flags & ~4);
        if (n->len1 != 0) {
            io = free_request(sx);
            if (io == NULL) {
                return;
            }
            io->ioa_Data = (UBYTE *)n->data;
            io->ioa_Length = n->len1;
            io->ioa_Period = n->period_now;
            io->ioa_Volume = (UWORD)(n->volume_now >> 8);
            io->ioa_Cycles = 1;
            send(io, unit, 3, 0x10);            /* CMD_WRITE */
        }
        if (n->len2 != 0) {
            io = free_request(sx);
            if (io == NULL) {
                return;
            }
            io->ioa_Data = (UBYTE *)n->repeat;
            io->ioa_Length = n->len2;
            io->ioa_Period = n->period_now;
            io->ioa_Volume = (UWORD)(n->volume_now >> 8);
            io->ioa_Cycles = 0;
            send(io, unit, 3, 0x10);
        }
        continue;
finish:
        n->flags = (u8)(n->flags & ~2);
        sx->voice[slot] = NULL;
        io = free_request(sx);
        if (io == NULL) {
            return;
        }
        send(io, unit, 11, 0);                  /* ADCMD_FINISH */
    }
}

/*
 * PORT H094+$0016: interrupt software: avanza l'orologio del tempo, fa
 * suonare gli oggetti, assegna le voci e le aggiorna.
 */
#if COK_AMIGA
LONG __asm audio_soft_interrupt(register __a1 SoundX *sx)
#else
LONG audio_soft_interrupt(SoundX *sx)
#endif
{
    sx->clock += sx->tempo;
    play_objects(sx);
    assign_voices(sx);
    update_voices(sx);
    return 0;
}

/* PORT H094+$0006: server del VBlank: Cause dell'interrupt software. */
#if COK_AMIGA
LONG __asm audio_vblank_server(register __a1 struct Interrupt *soft)
#else
LONG audio_vblank_server(struct Interrupt *soft)
#endif
{
    Cause(soft);
    return 0;
}

#endif /* COK_AUDIO */
