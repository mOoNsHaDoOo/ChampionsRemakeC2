/*
 * H043/H094: "SoundX", lettore di musica IFF SMUS con campioni 8SVX su
 * audio.device.  Compilato solo con COK_AUDIO (smake AUDIO, make AUDIO=1);
 * senza, i comandi audio restano gli stub che non fanno nulla
 * (unported.c).
 */
#ifndef COK_H043_AUDIO_H
#define COK_H043_AUDIO_H

#include "cok.h"

void h043_init(void);                   /* H043+$01BC */
void h043_0584(void);                   /* H043+$0584: avvio */
void h043_0840(void);                   /* H043+$0840: chiusura */
void h043_190e(u16 command);            /* H043+$190E: comando */

#ifdef COK_AUDIO

#if COK_AMIGA
#include <exec/types.h>
#include <exec/ports.h>
#include <exec/interrupts.h>
#include <devices/audio.h>
#else
#include "host/ndk.h"
#endif

/*
 * Oggetto caricato ($10 byte): nome, dati e tipo (+$E: 1 SMUS, 2 INST,
 * 4 8SVX, $20 SAMP, $40 ENVL; $10 = suona in questo turno).
 */
typedef struct SxObject {
    struct SxObject *next;              /* +$00 */
    u16 refs;                           /* +$04 */
    void *data;                         /* +$06 */
    char *name;                         /* +$0A: $28 byte */
    u8 flags;                           /* +$0E */
} SxObject;

/* Traccia SMUS ($16 byte). */
typedef struct SxTrack {
    u32 time;                           /* +$00: istante del prossimo evento */
    SxObject *instr;                    /* +$04 */
    u8 volume;                          /* +$08 */
    u8 *data;                           /* +$0A */
    u8 *cursor;                         /* +$0E */
    u8 *end;                            /* +$12 */
} SxTrack;

/* Brano SMUS ($4A byte). */
typedef struct SxScore {
    u16 ntracks;                        /* +$00 */
    u16 ninstr;                         /* +$02 */
    SxTrack *tracks[8];                 /* +$04 */
    SxObject *instr[8];                 /* +$24 */
    u16 volume;                         /* +$44 */
    u8 pad;
    u8 active;                          /* +$48: tracce ancora attive */
} SxScore;

/*
 * Campione 8SVX ($1C byte): VHDR letto cosi' com'e' dal file (big-endian:
 * +0 oneShotHiSamples, +4 repeatHiSamples, +8 samplesPerHiCycle, +$C
 * samplesPerSec, +$E ctOctave, +$F sCompression, +$10 volume), BODY.
 */
typedef struct Sx8svx {
    u8 vhdr[0x14];                      /* +$00 */
    u32 body_size;                      /* +$14 */
    s8 *body;                           /* +$18 */
} Sx8svx;

/* Strumento INST ($18 byte): inviluppi PTCH e VLUM, campione SAMP. */
typedef struct SxInst {
    u8 *ptch;                           /* +$00: dati dopo la lunghezza */
    u8 *vlum;                           /* +$04 */
    Sx8svx *samp;                       /* +$08 */
    SxObject *ptch_obj;                 /* +$0C */
    SxObject *vlum_obj;                 /* +$10 */
    SxObject *samp_obj;                 /* +$14 */
} SxInst;

/* Inviluppo ENVL: word della lunghezza e i byte. */

/* Nota in corso su una voce ($36 byte). */
typedef struct SxNote {
    struct SxNote *next;                /* +$00 */
    s8 *data;                           /* +$04: parte iniziale */
    s8 *repeat;                         /* +$08: parte ripetuta */
    u32 len1;                           /* +$0C */
    u32 len2;                           /* +$10 */
    u32 start;                          /* +$14 */
    u32 end;                            /* +$18 */
    u8 *ptch;                           /* +$1C */
    u16 period;                         /* +$20 */
    u16 period_now;                     /* +$22 */
    s16 period_step;                    /* +$24 */
    u8 period_count;                    /* +$26 */
    u8 *vlum;                           /* +$28 */
    u16 volume;                         /* +$2C */
    u16 volume_now;                     /* +$2E */
    s16 volume_step;                    /* +$30 */
    u8 volume_count;                    /* +$32 */
    u8 flags;                           /* +$34: 1 in uso, 2 assegnata, 4 da avviare */
} SxNote;

/* Stato del lettore ($6B0 byte). */
typedef struct SoundX {
    u32 clock;                          /* +$000 */
    u32 tempo;                          /* +$004: avanzamento per VBlank */
    struct IOAudio open_io;             /* +$008: allocazione dei canali */
    struct IOAudio model;               /* +$04C: modello delle richieste */
    struct Device *device;              /* +$090 */
    SxNote *voice[4];                   /* +$094 */
    SxNote notes[8];                    /* +$0A4 */
    SxNote *pending;                    /* +$254 */
    struct IOAudio requests[16];        /* +$258 */
    struct MsgPort *port;               /* +$698 */
    struct MsgPort *reply;              /* +$69C: richieste libere */
    SxObject *active;                   /* +$6A0 */
    SxObject *loaded;                   /* +$6A4 */
    u32 *periods;                       /* +$6A8: $80 periodi ... */
    u16 *durations;                     /* +$6AC: ... e $40 durate */
} SoundX;

/* H094: server del VBlank e interrupt software del lettore. */
#if COK_AMIGA
LONG __asm audio_vblank_server(register __a1 struct Interrupt *soft);
LONG __asm audio_soft_interrupt(register __a1 SoundX *sx);
#else
LONG audio_vblank_server(struct Interrupt *soft);
LONG audio_soft_interrupt(SoundX *sx);
#endif

#endif /* COK_AUDIO */
#endif
