/*
 * Host: audio.device and Exec for the SoundX player (H043/H094), compiled
 * only with COK_AUDIO.
 *
 * audio.device is emulated on top of SDL2 as the 4 Paula channels: each
 * channel has its own queue of CMD_WRITE (signed 8-bit data, length,
 * period, volume 0..64, cycles: 0 = endless); ADCMD_PERVOL changes
 * period and volume of the sound playing, ADCMD_FINISH stops it (the
 * next one in the queue starts), CMD_FLUSH empties everything.  The mixer runs in the
 * SDL callback (PAL clock 3546895 Hz; channels 0 and 3 on the left, 1 and 2 on
 * the right).  Finished requests go back to their ports only in the main
 * thread (BeginIO and VBlank), under the audio lock.  If SDL does not
 * open the audio every request completes at once, without sound.
 *
 * The registered VBlank server runs at 50 Hz from the display refresh
 * (main thread, never between Disable and Enable); Cause runs the
 * software interrupt at once.  The ports have a real queue.
 */
#include "ndk.h"

#ifdef COK_AUDIO
#include <string.h>
#include <SDL.h>

#define PAULA_CLOCK     3546895.0
#define OUT_RATE        44100
#define QUEUE_LEN       16
#define DONE_LEN        64

#define CMD_WRITE_NUM   3
#define CMD_FLUSH_NUM   8
#define ADCMD_FINISH_NUM 11
#define ADCMD_PERVOL_NUM 12
#define ADIOF_PERVOL_FLAG 0x10

typedef struct HostChannel {
    struct IOAudio *queue[QUEUE_LEN];   /* [0] = playing */
    int count;
    double pos;                         /* current sample */
    UWORD period;
    UWORD volume;
    UWORD cycles_left;                  /* 0 = endless */
} HostChannel;

static struct Device s_audio_device;
static SDL_AudioDeviceID s_dev;
static HostChannel s_ch[4];
static struct IOAudio *s_done[DONE_LEN];
static int s_done_count;

/* Queue of a port: doubly linked list with sentinel nodes as in Exec. */
static void list_init_if_needed(struct List *l)
{
    if (l->lh_Head == NULL) {
        l->lh_Head = (struct Node *)&l->lh_Tail;
        l->lh_Tail = NULL;
        l->lh_TailPred = (struct Node *)&l->lh_Head;
    }
}

void host_port_put(struct MsgPort *port, struct Message *msg)
{
    struct List *l = &port->mp_MsgList;
    struct Node *n = &msg->mn_Node;
    struct Node *tail;

    list_init_if_needed(l);
    tail = l->lh_TailPred;
    n->ln_Succ = (struct Node *)&l->lh_Tail;
    n->ln_Pred = tail;
    tail->ln_Succ = n;
    l->lh_TailPred = n;
}

struct Message *host_port_get(struct MsgPort *port)
{
    struct List *l = &port->mp_MsgList;
    struct Node *n;

    list_init_if_needed(l);
    n = l->lh_Head;
    if (n->ln_Succ == NULL) {
        return NULL;
    }
    l->lh_Head = n->ln_Succ;
    n->ln_Succ->ln_Pred = (struct Node *)&l->lh_Head;
    return (struct Message *)n;
}

static void reply(struct IORequest *io)
{
    if (io->io_Message.mn_ReplyPort != NULL) {
        host_port_put(io->io_Message.mn_ReplyPort, &io->io_Message);
    }
}

/* Finished request (in the callback or under lock): back to the main thread. */
static void mark_done(struct IOAudio *io, BYTE error)
{
    io->ioa_Request.io_Error = error;
    if (s_done_count < DONE_LEN) {
        s_done[s_done_count++] = io;
    }
}

/* Starts the write at the head of the channel queue. */
static void start_head(HostChannel *c)
{
    struct IOAudio *io;

    c->pos = 0.0;
    if (c->count == 0) {
        return;
    }
    io = c->queue[0];
    if (io->ioa_Request.io_Flags & ADIOF_PERVOL_FLAG) {
        c->period = io->ioa_Period;
        c->volume = io->ioa_Volume;
    }
    c->cycles_left = io->ioa_Cycles;
}

/* Removes the write in progress (finished or stopped) and starts the next one. */
static void pop_head(HostChannel *c, BYTE error)
{
    int i;

    if (c->count == 0) {
        return;
    }
    mark_done(c->queue[0], error);
    for (i = 1; i < c->count; ++i) {
        c->queue[i - 1] = c->queue[i];
    }
    --c->count;
    start_head(c);
}

static void SDLCALL mix(void *user, Uint8 *stream, int len)
{
    Sint16 *out = (Sint16 *)stream;
    int frames = len / 4;
    int f;
    int k;

    (void)user;
    for (f = 0; f < frames; ++f) {
        int left = 0;
        int right = 0;

        for (k = 0; k < 4; ++k) {
            HostChannel *c = &s_ch[k];
            struct IOAudio *io;
            int s;

            if (c->count == 0 || c->period == 0) {
                continue;
            }
            io = c->queue[0];
            if (io->ioa_Length == 0 || io->ioa_Data == NULL) {
                pop_head(c, 0);
                continue;
            }
            s = (int)(signed char)io->ioa_Data[(ULONG)c->pos] *
                (c->volume > 64 ? 64 : c->volume);
            if (k == 0 || k == 3) {
                left += s;
            } else {
                right += s;
            }
            c->pos += PAULA_CLOCK / (double)c->period / (double)OUT_RATE;
            while (c->count > 0 && c->pos >= (double)io->ioa_Length) {
                c->pos -= (double)io->ioa_Length;
                if (c->cycles_left == 0) {
                    continue;           /* endless */
                }
                if (--c->cycles_left == 0) {
                    pop_head(c, 0);
                    break;
                }
            }
        }
        /* 2 channels * 127 * 64 per side: in 16 bits with headroom. */
        out[f * 2] = (Sint16)(left * 2);
        out[f * 2 + 1] = (Sint16)(right * 2);
    }
}

/* Returns the finished requests to their ports (main thread). */
static void drain_done(void)
{
    int i;
    struct IOAudio *done[DONE_LEN];
    int n;

    if (s_dev == 0) {
        return;
    }
    SDL_LockAudioDevice(s_dev);
    n = s_done_count;
    for (i = 0; i < n; ++i) {
        done[i] = s_done[i];
    }
    s_done_count = 0;
    SDL_UnlockAudioDevice(s_dev);
    for (i = 0; i < n; ++i) {
        reply(&done[i]->ioa_Request);
    }
}

BYTE OpenDevice(STRPTR name, ULONG unit, struct IORequest *io, ULONG flags)
{
    SDL_AudioSpec want;
    SDL_AudioSpec have;

    (void)unit;
    (void)flags;
    if (strcmp((const char *)name, "audio.device") != 0) {
        io->io_Error = -1;
        return -1;
    }
    io->io_Device = &s_audio_device;
    io->io_Error = 0;
    if (s_dev == 0 && SDL_InitSubSystem(SDL_INIT_AUDIO) == 0) {
        memset(&want, 0, sizeof(want));
        want.freq = OUT_RATE;
        want.format = AUDIO_S16SYS;
        want.channels = 2;
        want.samples = 1024;
        want.callback = mix;
        memset(s_ch, 0, sizeof(s_ch));
        s_done_count = 0;
        s_dev = SDL_OpenAudioDevice(NULL, 0, &want, &have, 0);
        if (s_dev != 0) {
            SDL_PauseAudioDevice(s_dev, 0);
        }
    }
    return 0;
}

void CloseDevice(struct IORequest *io)
{
    int k;

    if (s_dev != 0) {
        SDL_CloseAudioDevice(s_dev);
        s_dev = 0;
        for (k = 0; k < 4; ++k) {
            while (s_ch[k].count > 0) {
                pop_head(&s_ch[k], -2);     /* IOERR_ABORTED */
            }
        }
        for (k = 0; k < s_done_count; ++k) {
            reply(&s_done[k]->ioa_Request);
        }
        s_done_count = 0;
    }
    io->io_Device = NULL;
}

void BeginIO(struct IORequest *io)
{
    struct IOAudio *a = (struct IOAudio *)io;
    ULONG mask = (ULONG)(uintptr_t)io->io_Unit;
    int k;

    io->io_Error = 0;
    if (s_dev == 0) {
        reply(io);                      /* without audio: at once */
        return;
    }
    SDL_LockAudioDevice(s_dev);
    switch (io->io_Command) {
    case CMD_WRITE_NUM:
        for (k = 0; k < 4; ++k) {
            if (mask & (1UL << k)) {
                HostChannel *c = &s_ch[k];

                if (c->count < QUEUE_LEN) {
                    c->queue[c->count++] = a;
                    if (c->count == 1) {
                        start_head(c);
                    }
                } else {
                    mark_done(a, -1);
                }
                break;
            }
        }
        if (mask == 0) {
            mark_done(a, -1);
        }
        break;
    case ADCMD_PERVOL_NUM:
        for (k = 0; k < 4; ++k) {
            if ((mask & (1UL << k)) && s_ch[k].count > 0) {
                s_ch[k].period = a->ioa_Period;
                s_ch[k].volume = a->ioa_Volume;
            }
        }
        mark_done(a, 0);
        break;
    case ADCMD_FINISH_NUM:
        for (k = 0; k < 4; ++k) {
            if (mask & (1UL << k)) {
                pop_head(&s_ch[k], -2);
            }
        }
        mark_done(a, 0);
        break;
    case CMD_FLUSH_NUM:
        for (k = 0; k < 4; ++k) {
            if (mask & (1UL << k)) {
                while (s_ch[k].count > 0) {
                    pop_head(&s_ch[k], -2);
                }
            }
        }
        mark_done(a, 0);
        break;
    default:
        mark_done(a, 0);
        break;
    }
    SDL_UnlockAudioDevice(s_dev);
    drain_done();
}

static struct Interrupt *s_vblank_server;
static int s_disabled;
static unsigned long s_next_vblank;

typedef LONG (*HostIntCode)(APTR data);

void AddIntServer(LONG intnum, struct Interrupt *interrupt)
{
    if (intnum == 5) {
        s_vblank_server = interrupt;
    }
}

/*
 * When the VBlank server is removed H043 frees the samples at once ($FE,
 * shutdown): Paula would keep reading that memory harmlessly,
 * the host callback would not, so here the channels are emptied.
 */
void RemIntServer(LONG intnum, struct Interrupt *interrupt)
{
    int k;

    if (intnum == 5 && s_vblank_server == interrupt) {
        s_vblank_server = NULL;
        if (s_dev != 0) {
            SDL_LockAudioDevice(s_dev);
            for (k = 0; k < 4; ++k) {
                while (s_ch[k].count > 0) {
                    pop_head(&s_ch[k], -2);
                }
            }
            SDL_UnlockAudioDevice(s_dev);
            drain_done();
        }
    }
}

void Cause(struct Interrupt *interrupt)
{
    if (interrupt != NULL && interrupt->is_Code != NULL) {
        ((HostIntCode)interrupt->is_Code)(interrupt->is_Data);
    }
}

void Disable(void)
{
    ++s_disabled;
}

void Enable(void)
{
    if (s_disabled > 0) {
        --s_disabled;
    }
}

/* From the display refresh: the VBlanks (20 ms) elapsed, at most 5. */
void host_audio_vblank(unsigned long now_ms)
{
    int n = 0;

    if (s_disabled == 0) {
        drain_done();
    }
    if (s_next_vblank == 0) {
        s_next_vblank = now_ms;
    }
    while (now_ms >= s_next_vblank && n < 5) {
        s_next_vblank += 20;
        ++n;
        if (s_vblank_server != NULL && s_disabled == 0 &&
            s_vblank_server->is_Code != NULL) {
            ((HostIntCode)s_vblank_server->is_Code)(s_vblank_server->is_Data);
        }
    }
    if (now_ms >= s_next_vblank) {
        s_next_vblank = now_ms + 20;
    }
}
#else
typedef int cok_host_audio_unused;
#endif
