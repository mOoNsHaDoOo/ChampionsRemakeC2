/*
 * Build host: intuition.library ed exec emulati (solo quanto usa il port).
 * Lo schermo e' una BitMap planare in memoria, mostrata da host/display.c.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ndk.h"

struct Library *host_graphics_base(void);

static struct IntuitionBase s_intuition = { { "intuition.library", 34 }, NULL };
static struct Library s_dos = { "dos.library", 34 };
static struct Library s_exec = { "exec.library", 34 };

struct Screen *host_first_screen(void)
{
    return s_intuition.FirstScreen;
}

struct Library *OpenLibrary(STRPTR name, ULONG version)
{
    const char *n = (const char *)name;

    (void)version;
    if (strcmp(n, "graphics.library") == 0) {
        return host_graphics_base();
    }
    if (strcmp(n, "intuition.library") == 0) {
        return &s_intuition.LibNode;
    }
    if (strcmp(n, "dos.library") == 0) {
        return &s_dos;
    }
    if (strcmp(n, "exec.library") == 0) {
        return &s_exec;
    }
    return NULL;
}

void CloseLibrary(struct Library *library)
{
    (void)library;
}

/*
 * Preferences: sull'host non ci sono preferenze di sistema; gli
 * spostamenti del display (usati solo per la View personalizzata) sono 0.
 */
struct Preferences *GetPrefs(struct Preferences *prefs, LONG size)
{
    (void)size;
    memset(prefs, 0, sizeof(*prefs));
    return prefs;
}

static struct Process s_process = { { "Champions of Krynn" }, NULL };

struct Task *FindTask(STRPTR name)
{
    (void)name;                 /* il gioco chiede solo il proprio task */
    return &s_process.pr_Task;
}

struct Screen *OpenScreen(struct NewScreen *ns)
{
    struct Screen *s = (struct Screen *)calloc(1, sizeof(*s));
    UWORD bpr;
    int i;

    if (s == NULL) {
        return NULL;
    }
    s->LeftEdge = ns->LeftEdge;
    s->TopEdge = ns->TopEdge;
    s->Width = ns->Width;
    s->Height = ns->Height;
    s->Title = ns->DefaultTitle;
    s->ViewPort.DWidth = ns->Width;
    s->ViewPort.DHeight = ns->Height;
    s->ViewPort.Modes = ns->ViewModes;
    s->ViewPort.ColorMap = GetColorMap(32);
    s->ViewPort.RasInfo = &s->RasInfo;
    s->RasInfo.BitMap = &s->BitMap;

    bpr = (UWORD)(((ns->Width + 15) / 16) * 2);
    s->BitMap.BytesPerRow = bpr;
    s->BitMap.Rows = (UWORD)ns->Height;
    s->BitMap.Depth = (UBYTE)ns->Depth;
    for (i = 0; i < ns->Depth && i < 8; ++i) {
        s->BitMap.Planes[i] = (PLANEPTR)calloc(1, (size_t)bpr * ns->Height);
        if (s->BitMap.Planes[i] == NULL) {
            CloseScreen(s);
            return NULL;
        }
    }
    s->RastPort.BitMap = &s->BitMap;
    s->RastPort.FgPen = (BYTE)ns->DetailPen;
    s->RastPort.BgPen = (BYTE)ns->BlockPen;
    s->ShowTitle = TRUE;
    host_display_attach(s);
    s_intuition.FirstScreen = s;    /* il nuovo schermo va in primo piano */
    host_screen_colors_changed(&s->ViewPort);
    return s;
}

void CloseScreen(struct Screen *screen)
{
    int i;

    if (screen == NULL) {
        return;
    }
    host_display_detach(screen);
    if (s_intuition.FirstScreen == screen) {
        s_intuition.FirstScreen = NULL;
    }
    for (i = 0; i < 8; ++i) {
        free(screen->BitMap.Planes[i]);
    }
    FreeColorMap(screen->ViewPort.ColorMap);
    free(screen);
}

struct Window *OpenWindow(struct NewWindow *nw)
{
    struct Window *w;

    if (nw->Screen == NULL) {
        return NULL;            /* nessun Workbench sull'host */
    }
    w = (struct Window *)calloc(1, sizeof(*w));
    if (w == NULL) {
        return NULL;
    }
    w->LeftEdge = nw->LeftEdge;
    w->TopEdge = nw->TopEdge;
    w->Width = nw->Width;
    w->Height = nw->Height;
    w->IDCMPFlags = nw->IDCMPFlags;
    w->Flags = nw->Flags;
    w->WScreen = nw->Screen;
    /* Finestra BACKDROP|BORDERLESS a schermo intero: disegna sullo schermo. */
    w->RPort = &nw->Screen->RastPort;
    host_input_open_window(w);
    return w;
}

void CloseWindow(struct Window *window)
{
    if (window != NULL) {
        host_input_close_window(window);
    }
    free(window);
}

void ShowTitle(struct Screen *screen, LONG show)
{
    screen->ShowTitle = (BOOL)(show != 0);
}

LONG CloseWorkBench(void)
{
    return TRUE;                /* nessun Workbench da chiudere */
}

ULONG OpenWorkBench(void)
{
    return 0;                   /* nessun Workbench: schermo nullo */
}

void ActivateWindow(struct Window *window)
{
    (void)window;
}

void ClearPointer(struct Window *window)
{
    (void)window;
    host_display_show_cursor(1);
}

/*
 * Il cursore di sistema sostituisce lo sprite del puntatore: un puntatore
 * di dati tutti a zero (come quello dell'intro) lo nasconde, gli altri lo
 * mostrano.  L'immagine del puntatore non e' riprodotta.
 */
void SetPointer(struct Window *window, UWORD *data, LONG height, LONG width,
                LONG x_offset, LONG y_offset)
{
    const UBYTE *p = (const UBYTE *)data;
    LONG i;
    int blank = 1;

    (void)window;
    (void)width;
    (void)x_offset;
    (void)y_offset;
    /* Word di controllo e righe: (altezza + 1) * 4 byte. */
    for (i = 0; i < (height + 1) * 4 && p != NULL; ++i) {
        if (p[i] != 0) {
            blank = 0;
            break;
        }
    }
    host_display_show_cursor(!blank);
}

/*
 * Richiesta di sistema: il testo va su stderr e si attende un tasto nella
 * finestra: Invio o R = scelta positiva (TRUE), Esc o C = negativa (FALSE).
 * Senza display interattivo (SDL_VIDEODRIVER=dummy) o con
 * COK_NONINTERACTIVE definita il programma termina, perche' il gioco
 * ripeterebbe la richiesta all'infinito.
 */
BOOL AutoRequest(struct Window *window, struct IntuiText *body,
                 struct IntuiText *pos, struct IntuiText *neg,
                 ULONG pos_flags, ULONG neg_flags, LONG width, LONG height)
{
    const struct IntuiText *t;
    const char *driver = getenv("SDL_VIDEODRIVER");

    (void)window;
    (void)pos_flags;
    (void)neg_flags;
    (void)width;
    (void)height;
    fprintf(stderr, "Richiesta:");
    for (t = body; t != NULL; t = t->NextText) {
        fprintf(stderr, " %s", t->IText != NULL ? (const char *)t->IText : "");
    }
    fprintf(stderr, "  [%s / %s]\n",
            pos != NULL && pos->IText != NULL ? (const char *)pos->IText : "",
            neg != NULL && neg->IText != NULL ? (const char *)neg->IText : "");
    if (getenv("COK_NONINTERACTIVE") != NULL ||
        (driver != NULL && strcmp(driver, "dummy") == 0)) {
        exit(20);
    }
    for (;;) {
        int key = host_display_wait_key();

        if (key < 0) {
            exit(20);
        }
        if (key == '\r' || key == 'r') {
            return TRUE;
        }
        if (key == 27 || key == 'c') {
            return FALSE;
        }
    }
}

void ModifyIDCMP(struct Window *window, ULONG flags)
{
    window->IDCMPFlags = flags;
}
