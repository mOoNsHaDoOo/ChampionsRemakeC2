/*
 * Host build: display of the Amiga screen with SDL2.
 *
 * It shows the planar BitMap of the screen opened with OpenScreen or,
 * after LoadView of a game View, the one of its ViewPort (RasInfo):
 * the pixels are converted to RGB with the ColorMap (RGB4) and shown in an
 * enlarged SDL window.
 *
 * Environment variables:
 *   COK_SCALE=n          window scale factor (default 3);
 *   COK_SCREENSHOT=f.bmp on exit saves the last frame to f.bmp;
 *   COK_SCREENSHOT_AT=t1,t2,...  also saves f-1.bmp, f-2.bmp, ... at the
 *                        given milliseconds from the start of the display;
 *   COK_KEYS=ms=Key,...  timed simulated keys (see host/input.c);
 *   SDL_VIDEODRIVER=dummy  run without a window (tests).
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
/*
 * main is the game's one (h000_entry.c): no SDL2main, which on
 * Windows would replace the entry point.
 */
#define SDL_MAIN_HANDLED
#include <SDL.h>
#include "ndk.h"

static struct Screen *s_screen;
static struct View *s_view;             /* View loaded with LoadView */
static SDL_Window *s_window;
static SDL_Renderer *s_renderer;
static SDL_Texture *s_texture;
static Uint32 *s_pixels;
static int s_tex_w;
static int s_tex_h;
static int s_dirty;
static Uint32 s_last_present;
static int s_sdl_ready;

/* ViewPort shown: the one of the loaded View or the screen one. */
static struct ViewPort *shown_viewport(void)
{
    if (s_view != NULL && s_view->ViewPort != NULL) {
        return s_view->ViewPort;
    }
    return s_screen != NULL ? &s_screen->ViewPort : NULL;
}

/* Converts the planar bitmap shown into s_pixels (ARGB8888). */
static void convert(void)
{
    const struct ViewPort *vp = shown_viewport();
    const struct BitMap *bm;
    Uint32 palette[256];
    int x;
    int y;
    int i;

    if (vp == NULL || vp->RasInfo == NULL || vp->RasInfo->BitMap == NULL ||
        s_pixels == NULL) {
        return;
    }
    bm = vp->RasInfo->BitMap;
    for (i = 0; i < 256; ++i) {
        UWORD c = 0;

        if (vp->ColorMap != NULL && vp->ColorMap->Count > 0) {
            c = vp->ColorMap->ColorTable[i % vp->ColorMap->Count];
        }
        palette[i] = 0xFF000000u | (Uint32)((c >> 8) & 15) * 0x110000u |
                     (Uint32)((c >> 4) & 15) * 0x001100u |
                     (Uint32)(c & 15) * 0x000011u;
    }
    for (y = 0; y < s_tex_h && y < bm->Rows; ++y) {
        for (x = 0; x < s_tex_w && x < bm->BytesPerRow * 8; ++x) {
            size_t at = (size_t)y * bm->BytesPerRow + (size_t)(x >> 3);
            UBYTE mask = (UBYTE)(0x80 >> (x & 7));
            unsigned pen = 0;

            for (i = 0; i < bm->Depth; ++i) {
                if (bm->Planes[i] != NULL && (bm->Planes[i][at] & mask)) {
                    pen |= 1u << i;
                }
            }
            s_pixels[(size_t)y * s_tex_w + x] = palette[pen];
        }
    }
}

static void save_screenshot(void)
{
    const char *path = getenv("COK_SCREENSHOT");
    SDL_Surface *surface;

    if (path == NULL || s_pixels == NULL) {
        return;
    }
    surface = SDL_CreateRGBSurfaceFrom(s_pixels, s_tex_w, s_tex_h, 32,
                                       s_tex_w * 4, 0x00FF0000, 0x0000FF00,
                                       0x000000FF, 0xFF000000);
    if (surface != NULL) {
        if (SDL_SaveBMP(surface, path) != 0) {
            fprintf(stderr, "COK_SCREENSHOT: %s\n", SDL_GetError());
        }
        SDL_FreeSurface(surface);
    }
}

/* Saves s_pixels to path (BMP). */
static void save_bmp(const char *path)
{
    SDL_Surface *surface;

    if (s_pixels == NULL) {
        return;
    }
    surface = SDL_CreateRGBSurfaceFrom(s_pixels, s_tex_w, s_tex_h, 32,
                                       s_tex_w * 4, 0x00FF0000, 0x0000FF00,
                                       0x000000FF, 0xFF000000);
    if (surface != NULL) {
        if (SDL_SaveBMP(surface, path) != 0) {
            fprintf(stderr, "COK_SCREENSHOT: %s\n", SDL_GetError());
        }
        SDL_FreeSurface(surface);
    }
}

/* COK_SCREENSHOT_AT: saves at the given times. */
static void timed_screenshots(Uint32 now)
{
    static int s_done;
    const char *path = getenv("COK_SCREENSHOT");
    const char *list = getenv("COK_SCREENSHOT_AT");
    const char *p = list;
    char name[600];
    int index = 0;

    if (path == NULL || list == NULL) {
        return;
    }
    while (p != NULL && *p != 0) {
        unsigned long t = strtoul(p, NULL, 10);

        ++index;
        if (index > s_done && now >= t) {
            s_done = index;
            convert();
            sprintf(name, "%.500s-%d.bmp", path, index);
            save_bmp(name);
        }
        p = strchr(p, ',');
        if (p != NULL) {
            ++p;
        }
    }
}

static void at_exit(void)
{
    convert();
    save_screenshot();
    if (s_sdl_ready) {
        SDL_Quit();
    }
}

static int open_sdl(int w, int h)
{
    const char *env = getenv("COK_SCALE");
    int scale = env != NULL ? atoi(env) : 3;

    if (scale < 1) {
        scale = 1;
    }
    if (!s_sdl_ready) {
        SDL_SetMainReady();
        if (SDL_Init(SDL_INIT_VIDEO) != 0) {
            fprintf(stderr, "SDL_Init: %s\n", SDL_GetError());
            return 0;
        }
        s_sdl_ready = 1;
        atexit(at_exit);
    }
    if (s_window == NULL) {
        s_window = SDL_CreateWindow("Champions of Krynn",
                                    SDL_WINDOWPOS_CENTERED,
                                    SDL_WINDOWPOS_CENTERED,
                                    w * scale, h * scale, 0);
        if (s_window == NULL) {
            fprintf(stderr, "SDL_CreateWindow: %s\n", SDL_GetError());
            return 0;
        }
        s_renderer = SDL_CreateRenderer(s_window, -1, 0);
        if (s_renderer == NULL) {
            s_renderer = SDL_CreateRenderer(s_window, -1,
                                            SDL_RENDERER_SOFTWARE);
        }
    }
    if (s_texture != NULL && (s_tex_w != w || s_tex_h != h)) {
        SDL_DestroyTexture(s_texture);
        s_texture = NULL;
    }
    if (s_texture == NULL && s_renderer != NULL) {
        s_texture = SDL_CreateTexture(s_renderer, SDL_PIXELFORMAT_ARGB8888,
                                      SDL_TEXTUREACCESS_STREAMING, w, h);
        SDL_RenderSetLogicalSize(s_renderer, w, h);
    }
    free(s_pixels);
    s_pixels = (Uint32 *)calloc((size_t)w * h, sizeof(Uint32));
    s_tex_w = w;
    s_tex_h = h;
    return s_pixels != NULL;
}

void host_display_attach(struct Screen *screen)
{
    if (open_sdl(screen->Width, screen->Height)) {
        s_screen = screen;
        s_dirty = 1;
        host_display_refresh(1);
    }
}

void host_display_detach(struct Screen *screen)
{
    if (s_screen == screen) {
        convert();              /* the last frame stays for the screenshot */
        s_screen = NULL;
    }
}

void host_display_view(struct View *view)
{
    s_view = view;
    s_dirty = 1;
}

void host_display_changed(void)
{
    s_dirty = 1;
}

/*
 * Shows the screen (at most ~60 times per second, or at once with
 * force) and drains the window events.
 */
#ifdef COK_AUDIO
void host_audio_vblank(unsigned long now_ms);
#endif

void host_display_refresh(int force)
{
    SDL_Event ev;
    Uint32 now;

    if (!s_sdl_ready) {
        return;
    }
    while (SDL_PollEvent(&ev)) {
        if (ev.type == SDL_QUIT) {
            exit(0);
        }
        host_input_event(&ev);
    }
    now = SDL_GetTicks();
    timed_screenshots(now);
    host_input_script(now);
#ifdef COK_AUDIO
    host_audio_vblank(now);
#endif
    if (shown_viewport() == NULL || s_texture == NULL ||
        (!force && (!s_dirty || now - s_last_present < 16))) {
        return;
    }
    convert();
    SDL_UpdateTexture(s_texture, NULL, s_pixels, s_tex_w * 4);
    SDL_RenderClear(s_renderer);
    SDL_RenderCopy(s_renderer, s_texture, NULL, NULL);
    SDL_RenderPresent(s_renderer);
    s_last_present = now;
    s_dirty = 0;
}

int host_display_wait_key(void)
{
    SDL_Event ev;

    if (!s_sdl_ready || s_window == NULL) {
        return -1;
    }
    host_display_refresh(1);
    while (SDL_WaitEvent(&ev)) {
        if (ev.type == SDL_QUIT) {
            exit(0);
        }
        if (ev.type == SDL_KEYDOWN) {
            return (int)ev.key.keysym.sym;
        }
        if (ev.type == SDL_WINDOWEVENT) {
            host_display_refresh(1);
        }
    }
    return -1;
}

unsigned long host_ticks_ms(void)
{
    return s_sdl_ready ? (unsigned long)SDL_GetTicks() : 0;
}

/* Waits at most timeout_ms for an event, then updates the screen. */
void host_display_wait_event(int timeout_ms)
{
    SDL_Event ev;

    if (!s_sdl_ready) {
        return;
    }
    if (SDL_WaitEventTimeout(&ev, timeout_ms)) {
        if (ev.type == SDL_QUIT) {
            exit(0);
        }
        host_input_event(&ev);
    }
    host_display_refresh(0);
}

/*
 * graphics.library WaitTOF: waits for the next frame (60 Hz, NTSC
 * display with 200 rows) and shows the screen.
 */
void WaitTOF(void)
{
    static Uint32 s_next;
    Uint32 now;

    host_display_refresh(1);
    if (!s_sdl_ready) {
        return;
    }
    now = SDL_GetTicks();
    if (s_next == 0 || now > s_next + 100) {
        s_next = now;
    }
    s_next += 1000 / 60;
    while ((now = SDL_GetTicks()) < s_next) {
        host_display_wait_event((int)(s_next - now));
    }
}

/* Mouse pointer: an empty image hides the system cursor. */
void host_display_show_cursor(int show)
{
    if (s_sdl_ready) {
        SDL_ShowCursor(show ? SDL_ENABLE : SDL_DISABLE);
    }
}
