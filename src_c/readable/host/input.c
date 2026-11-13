/*
 * Host build: input and time.  SDL events become IDCMP messages
 * (IntuiMessage) on the port of the open window, as Intuition would
 * deliver them: keys as RAWKEY with the Amiga keyboard code (bit 7 =
 * release), mouse buttons as MOUSEBUTTONS (SELECTDOWN/UP, and with
 * RMBTRAP MENUDOWN/UP) with the position in the 320x200 screen.
 */
#include <stdlib.h>
#include <string.h>
#include <SDL.h>
#include "ndk.h"

#define QUEUE_SIZE 64

static struct Window *s_window;         /* window with the IDCMP port */
static struct MsgPort s_port;
static struct IntuiMessage s_queue[QUEUE_SIZE];
static unsigned s_head;                 /* next one to deliver */
static unsigned s_count;
#ifdef COK_AUDIO
struct Message *host_port_get(struct MsgPort *port);
void host_port_put(struct MsgPort *port, struct Message *msg);
#endif

static struct IntuiMessage s_current;   /* message delivered by GetMsg */
static int s_mouse_x;
static int s_mouse_y;

/* Amiga keyboard RAWKEY codes for the SDL scancodes. */
static int amiga_rawkey(SDL_Scancode sc)
{
    static const struct { SDL_Scancode sc; int raw; } map[] = {
        { SDL_SCANCODE_GRAVE, 0x00 }, { SDL_SCANCODE_1, 0x01 },
        { SDL_SCANCODE_2, 0x02 }, { SDL_SCANCODE_3, 0x03 },
        { SDL_SCANCODE_4, 0x04 }, { SDL_SCANCODE_5, 0x05 },
        { SDL_SCANCODE_6, 0x06 }, { SDL_SCANCODE_7, 0x07 },
        { SDL_SCANCODE_8, 0x08 }, { SDL_SCANCODE_9, 0x09 },
        { SDL_SCANCODE_0, 0x0A }, { SDL_SCANCODE_MINUS, 0x0B },
        { SDL_SCANCODE_EQUALS, 0x0C }, { SDL_SCANCODE_BACKSLASH, 0x0D },
        { SDL_SCANCODE_KP_0, 0x0F }, { SDL_SCANCODE_Q, 0x10 },
        { SDL_SCANCODE_W, 0x11 }, { SDL_SCANCODE_E, 0x12 },
        { SDL_SCANCODE_R, 0x13 }, { SDL_SCANCODE_T, 0x14 },
        { SDL_SCANCODE_Y, 0x15 }, { SDL_SCANCODE_U, 0x16 },
        { SDL_SCANCODE_I, 0x17 }, { SDL_SCANCODE_O, 0x18 },
        { SDL_SCANCODE_P, 0x19 }, { SDL_SCANCODE_LEFTBRACKET, 0x1A },
        { SDL_SCANCODE_RIGHTBRACKET, 0x1B }, { SDL_SCANCODE_KP_1, 0x1D },
        { SDL_SCANCODE_KP_2, 0x1E }, { SDL_SCANCODE_KP_3, 0x1F },
        { SDL_SCANCODE_A, 0x20 }, { SDL_SCANCODE_S, 0x21 },
        { SDL_SCANCODE_D, 0x22 }, { SDL_SCANCODE_F, 0x23 },
        { SDL_SCANCODE_G, 0x24 }, { SDL_SCANCODE_H, 0x25 },
        { SDL_SCANCODE_J, 0x26 }, { SDL_SCANCODE_K, 0x27 },
        { SDL_SCANCODE_L, 0x28 }, { SDL_SCANCODE_SEMICOLON, 0x29 },
        { SDL_SCANCODE_APOSTROPHE, 0x2A }, { SDL_SCANCODE_KP_4, 0x2D },
        { SDL_SCANCODE_KP_5, 0x2E }, { SDL_SCANCODE_KP_6, 0x2F },
        { SDL_SCANCODE_Z, 0x31 }, { SDL_SCANCODE_X, 0x32 },
        { SDL_SCANCODE_C, 0x33 }, { SDL_SCANCODE_V, 0x34 },
        { SDL_SCANCODE_B, 0x35 }, { SDL_SCANCODE_N, 0x36 },
        { SDL_SCANCODE_M, 0x37 }, { SDL_SCANCODE_COMMA, 0x38 },
        { SDL_SCANCODE_PERIOD, 0x39 }, { SDL_SCANCODE_SLASH, 0x3A },
        { SDL_SCANCODE_KP_PERIOD, 0x3C }, { SDL_SCANCODE_KP_7, 0x3D },
        { SDL_SCANCODE_KP_8, 0x3E }, { SDL_SCANCODE_KP_9, 0x3F },
        { SDL_SCANCODE_SPACE, 0x40 }, { SDL_SCANCODE_BACKSPACE, 0x41 },
        { SDL_SCANCODE_TAB, 0x42 }, { SDL_SCANCODE_KP_ENTER, 0x43 },
        { SDL_SCANCODE_RETURN, 0x44 }, { SDL_SCANCODE_ESCAPE, 0x45 },
        { SDL_SCANCODE_DELETE, 0x46 }, { SDL_SCANCODE_KP_MINUS, 0x4A },
        { SDL_SCANCODE_UP, 0x4C }, { SDL_SCANCODE_DOWN, 0x4D },
        { SDL_SCANCODE_RIGHT, 0x4E }, { SDL_SCANCODE_LEFT, 0x4F },
        { SDL_SCANCODE_F1, 0x50 }, { SDL_SCANCODE_F2, 0x51 },
        { SDL_SCANCODE_F3, 0x52 }, { SDL_SCANCODE_F4, 0x53 },
        { SDL_SCANCODE_F5, 0x54 }, { SDL_SCANCODE_F6, 0x55 },
        { SDL_SCANCODE_F7, 0x56 }, { SDL_SCANCODE_F8, 0x57 },
        { SDL_SCANCODE_F9, 0x58 }, { SDL_SCANCODE_F10, 0x59 },
        { SDL_SCANCODE_KP_DIVIDE, 0x5C }, { SDL_SCANCODE_KP_MULTIPLY, 0x5D },
        { SDL_SCANCODE_KP_PLUS, 0x5E }, { SDL_SCANCODE_F11, 0x5F },
        { SDL_SCANCODE_LSHIFT, 0x60 }, { SDL_SCANCODE_RSHIFT, 0x61 },
        { SDL_SCANCODE_CAPSLOCK, 0x62 }, { SDL_SCANCODE_LCTRL, 0x63 },
        { SDL_SCANCODE_RCTRL, 0x63 }, { SDL_SCANCODE_LALT, 0x64 },
        { SDL_SCANCODE_RALT, 0x65 }, { SDL_SCANCODE_LGUI, 0x66 },
        { SDL_SCANCODE_RGUI, 0x67 }
    };
    size_t i;

    for (i = 0; i < sizeof(map) / sizeof(map[0]); ++i) {
        if (map[i].sc == sc) {
            return map[i].raw;
        }
    }
    return -1;
}

static void enqueue(ULONG cls, UWORD code)
{
    struct IntuiMessage *m;

    if (s_window == NULL || !(s_window->IDCMPFlags & cls) ||
        s_count == QUEUE_SIZE) {
        return;
    }
    m = &s_queue[(s_head + s_count) % QUEUE_SIZE];
    memset(m, 0, sizeof(*m));
    m->Class = cls;
    m->Code = code;
    m->MouseX = (WORD)(s_mouse_x - s_window->LeftEdge);
    m->MouseY = (WORD)(s_mouse_y - s_window->TopEdge);
    m->IDCMPWindow = s_window;
    m->Seconds = (ULONG)(SDL_GetTicks() / 1000);
    m->Micros = (ULONG)(SDL_GetTicks() % 1000) * 1000;
    ++s_count;
}

void host_input_event(const union SDL_Event *ev)
{
    int raw;

    switch (ev->type) {
    case SDL_KEYDOWN:
    case SDL_KEYUP:
        if (ev->key.repeat) {
            break;
        }
        raw = amiga_rawkey(ev->key.keysym.scancode);
        if (raw >= 0) {
            enqueue(IDCMP_RAWKEY,
                    (UWORD)(raw | (ev->type == SDL_KEYUP ? 0x80 : 0)));
        }
        break;
    case SDL_MOUSEMOTION:
        s_mouse_x = ev->motion.x;
        s_mouse_y = ev->motion.y;
        if (s_window != NULL) {
            s_window->MouseX = (WORD)(s_mouse_x - s_window->LeftEdge);
            s_window->MouseY = (WORD)(s_mouse_y - s_window->TopEdge);
        }
        break;
    case SDL_MOUSEBUTTONDOWN:
    case SDL_MOUSEBUTTONUP:
        s_mouse_x = ev->button.x;
        s_mouse_y = ev->button.y;
        if (ev->button.button == SDL_BUTTON_LEFT) {
            enqueue(IDCMP_MOUSEBUTTONS, ev->type == SDL_MOUSEBUTTONDOWN ?
                                        SELECTDOWN : SELECTUP);
        } else if (ev->button.button == SDL_BUTTON_RIGHT && s_window != NULL &&
                   (s_window->Flags & 0x00010000UL)) {     /* RMBTRAP */
            enqueue(IDCMP_MOUSEBUTTONS, ev->type == SDL_MOUSEBUTTONDOWN ?
                                        MENUDOWN : MENUUP);
        }
        break;
    default:
        break;
    }
}

void host_input_open_window(struct Window *window)
{
    s_window = window;
    window->UserPort = &s_port;
    s_head = 0;
    s_count = 0;
}

void host_input_close_window(struct Window *window)
{
    if (s_window == window) {
        s_window = NULL;
        s_count = 0;
    }
}

int host_input_pending(void)
{
    return s_count != 0;
}

/* exec: the IDCMP port of the only window. */
struct Message *GetMsg(struct MsgPort *port)
{
    if (port != &s_port) {
#ifdef COK_AUDIO
        return host_port_get(port);
#else
        return NULL;
#endif
    }
    host_display_refresh(0);
    if (s_count == 0) {
        /*
         * The game polls the port in busy-wait loops: a 1 ms pause
         * avoids using all of the host CPU.
         */
        SDL_Delay(1);
        return NULL;
    }
    s_current = s_queue[s_head];
    s_head = (s_head + 1) % QUEUE_SIZE;
    --s_count;
    return &s_current.ExecMessage;
}

void ReplyMsg(struct Message *msg)
{
#ifdef COK_AUDIO
    if (msg != NULL && msg->mn_ReplyPort != NULL &&
        msg->mn_ReplyPort != &s_port) {
        host_port_put(msg->mn_ReplyPort, msg);
    }
#else
    (void)msg;
#endif
}

struct Message *WaitPort(struct MsgPort *port)
{
    while (port == &s_port && s_count == 0) {
        host_display_wait_event(20);
    }
    return port == &s_port ? &s_queue[s_head].ExecMessage : NULL;
}

/* Free memory: meaningless on the host; fixed value of 512K. */
ULONG AvailMem(ULONG requirements)
{
    (void)requirements;
    return 0x80000UL;
}

/* dos.library Delay: ticks at 50 Hz, processing events meanwhile. */
void Delay(LONG ticks)
{
    unsigned long end = host_ticks_ms() + (unsigned long)ticks * 20UL;

    host_display_refresh(0);
    while (ticks > 0 && host_ticks_ms() < end) {
        unsigned long left = end - host_ticks_ms();

        host_display_wait_event(left < 10 ? (int)left : 10);
    }
}

/*
 * COK_KEYS="ms=Name,ms=Name,...": for tests without a window, presses and
 * releases the SDL key Name (e.g. P, Return, Escape, Left) at the time
 * given in milliseconds from the start of the display.
 */
void host_input_script(unsigned long now)
{
    static int s_done;
    const char *list = getenv("COK_KEYS");
    const char *p = list;
    int index = 0;

    while (p != NULL && *p != 0) {
        char name[32];
        unsigned long t = strtoul(p, NULL, 10);
        const char *eq = strchr(p, '=');
        const char *end = strchr(p, ',');
        size_t n;

        ++index;
        if (eq == NULL) {
            break;
        }
        n = (size_t)((end != NULL ? end : eq + strlen(eq)) - (eq + 1));
        if (n >= sizeof(name)) {
            n = sizeof(name) - 1;
        }
        memcpy(name, eq + 1, n);
        name[n] = 0;
        if (index > s_done && now >= t) {
            SDL_Event ev;

            s_done = index;
            memset(&ev, 0, sizeof(ev));
            ev.type = SDL_KEYDOWN;
            ev.key.keysym.scancode = SDL_GetScancodeFromName(name);
            host_input_event(&ev);
            ev.type = SDL_KEYUP;
            host_input_event(&ev);
        }
        p = end != NULL ? end + 1 : NULL;
    }
}
