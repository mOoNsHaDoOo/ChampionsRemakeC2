/*
 * H043/H094: "SoundX", IFF SMUS music player with 8SVX samples on
 * audio.device.  Compiled only with COK_AUDIO (smake AUDIO, make AUDIO=1);
 * without it the audio commands stay the stubs that do nothing
 * (unported.c).
 */
#ifndef COK_H043_AUDIO_H
#define COK_H043_AUDIO_H

#include "cok.h"

void h043_init(void);                   /* H043+$01BC */
void h043_0584(void);                   /* H043+$0584: start-up */
void h043_0840(void);                   /* H043+$0840: shutdown */
void h043_190e(u16 command);            /* H043+$190E: command */

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
 * Loaded object ($10 bytes): name, data and type (+$E: 1 SMUS, 2 INST,
 * 4 8SVX, $20 SAMP, $40 ENVL; $10 = plays in this turn).
 */
typedef struct SxObject {
    struct SxObject *next;              /* +$00 */
    u16 refs;                           /* +$04 */
    void *data;                         /* +$06 */
    char *name;                         /* +$0A: $28 bytes */
    u8 flags;                           /* +$0E */
} SxObject;

/* SMUS track ($16 bytes). */
typedef struct SxTrack {
    u32 time;                           /* +$00: time of the next event */
    SxObject *instr;                    /* +$04 */
    u8 volume;                          /* +$08 */
    u8 *data;                           /* +$0A */
    u8 *cursor;                         /* +$0E */
    u8 *end;                            /* +$12 */
} SxTrack;

/* SMUS score ($4A bytes). */
typedef struct SxScore {
    u16 ntracks;                        /* +$00 */
    u16 ninstr;                         /* +$02 */
    SxTrack *tracks[8];                 /* +$04 */
    SxObject *instr[8];                 /* +$24 */
    u16 volume;                         /* +$44 */
    u8 pad;
    u8 active;                          /* +$48: tracks still active */
} SxScore;

/*
 * 8SVX sample ($1C bytes): VHDR read as it is from the file (big-endian:
 * +0 oneShotHiSamples, +4 repeatHiSamples, +8 samplesPerHiCycle, +$C
 * samplesPerSec, +$E ctOctave, +$F sCompression, +$10 volume), BODY.
 */
typedef struct Sx8svx {
    u8 vhdr[0x14];                      /* +$00 */
    u32 body_size;                      /* +$14 */
    s8 *body;                           /* +$18 */
} Sx8svx;

/* INST instrument ($18 bytes): PTCH and VLUM envelopes, SAMP sample. */
typedef struct SxInst {
    u8 *ptch;                           /* +$00: data after the length */
    u8 *vlum;                           /* +$04 */
    Sx8svx *samp;                       /* +$08 */
    SxObject *ptch_obj;                 /* +$0C */
    SxObject *vlum_obj;                 /* +$10 */
    SxObject *samp_obj;                 /* +$14 */
} SxInst;

/* ENVL envelope: length word and the bytes. */

/* Note playing on a voice ($36 bytes). */
typedef struct SxNote {
    struct SxNote *next;                /* +$00 */
    s8 *data;                           /* +$04: initial part */
    s8 *repeat;                         /* +$08: repeated part */
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
    u8 flags;                           /* +$34: 1 in use, 2 assigned, 4 to be started */
} SxNote;

/* Player state ($6B0 bytes). */
typedef struct SoundX {
    u32 clock;                          /* +$000 */
    u32 tempo;                          /* +$004: advance per VBlank */
    struct IOAudio open_io;             /* +$008: channel allocation */
    struct IOAudio model;               /* +$04C: request template */
    struct Device *device;              /* +$090 */
    SxNote *voice[4];                   /* +$094 */
    SxNote notes[8];                    /* +$0A4 */
    SxNote *pending;                    /* +$254 */
    struct IOAudio requests[16];        /* +$258 */
    struct MsgPort *port;               /* +$698 */
    struct MsgPort *reply;              /* +$69C: free requests */
    SxObject *active;                   /* +$6A0 */
    SxObject *loaded;                   /* +$6A4 */
    u32 *periods;                       /* +$6A8: $80 periods ... */
    u16 *durations;                     /* +$6AC: ... and $40 durations */
} SoundX;

/* H094: VBlank server and software interrupt of the player. */
#if COK_AMIGA
LONG __asm audio_vblank_server(register __a1 struct Interrupt *soft);
LONG __asm audio_soft_interrupt(register __a1 SoundX *sx);
#else
LONG audio_vblank_server(struct Interrupt *soft);
LONG audio_soft_interrupt(SoundX *sx);
#endif

#endif /* COK_AUDIO */
#endif
