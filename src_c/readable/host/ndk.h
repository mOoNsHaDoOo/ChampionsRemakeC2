/*
 * Build host: sottoinsieme dell'NDK di AmigaOS usato dal port.
 *
 * Le strutture hanno gli stessi nomi di campo dell'NDK, cosi' il codice
 * del gioco e' lo stesso sui due target; contengono solo i campi che il
 * port usa (non hanno la disposizione in memoria dell'originale).  Le
 * funzioni di libreria omonime sono emulate nei file .c di host/, sopra SDL2.
 *
 * Convenzione: la memoria che arriva dai dati del gioco (H005, file) e'
 * nell'ordine dei byte dell'Amiga; le funzioni emulate che leggono word da
 * quella memoria (per esempio LoadRGB4) le leggono big-endian.
 */
#ifndef COK_HOST_NDK_H
#define COK_HOST_NDK_H

#include <stdint.h>
#include <stddef.h>

typedef void          *APTR;
typedef int32_t        LONG;
typedef uint32_t       ULONG;
typedef int16_t        WORD;
typedef uint16_t       UWORD;
typedef int8_t         BYTE;
typedef uint8_t        UBYTE;
typedef int16_t        BOOL;
typedef unsigned char *STRPTR;
typedef unsigned char *PLANEPTR;

#ifndef TRUE
#define TRUE  1
#define FALSE 0
#endif

/* exec */
struct Task {
    const char *tc_Name;
};

struct Process {
    struct Task pr_Task;
    APTR pr_WindowPtr;          /* finestra delle richieste di sistema */
};

struct Library {
    const char *lib_Name;
    UWORD lib_Version;
};

struct Node {
    struct Node *ln_Succ;
    struct Node *ln_Pred;
    UBYTE ln_Type;
    BYTE ln_Pri;
    char *ln_Name;
};

struct List {
    struct Node *lh_Head;
    struct Node *lh_Tail;
    struct Node *lh_TailPred;
    UBYTE lh_Type;
    UBYTE l_pad;
};

struct Message {
    struct Node mn_Node;
    struct MsgPort *mn_ReplyPort;
    UWORD mn_Length;
};

struct MsgPort {
    struct Node mp_Node;
    UBYTE mp_Flags;
    UBYTE mp_SigBit;
    void *mp_SigTask;
    struct List mp_MsgList;
};

/* Device e richieste di I/O (usati dall'audio, COK_AUDIO). */
struct Device {
    struct Library dd_Library;
};

struct Unit;

struct IORequest {
    struct Message io_Message;
    struct Device *io_Device;
    struct Unit *io_Unit;
    UWORD io_Command;
    UBYTE io_Flags;
    BYTE io_Error;
};

struct IOAudio {
    struct IORequest ioa_Request;
    WORD ioa_AllocKey;
    UBYTE *ioa_Data;
    ULONG ioa_Length;
    UWORD ioa_Period;
    UWORD ioa_Volume;
    UWORD ioa_Cycles;
    struct Message ioa_WriteMsg;
};

struct Interrupt {
    struct Node is_Node;
    APTR is_Data;
    void (*is_Code)(void);
};

BYTE OpenDevice(STRPTR name, ULONG unit, struct IORequest *io, ULONG flags);
void CloseDevice(struct IORequest *io);
void BeginIO(struct IORequest *io);
void AddIntServer(LONG intnum, struct Interrupt *interrupt);
void RemIntServer(LONG intnum, struct Interrupt *interrupt);
void Cause(struct Interrupt *interrupt);
void Disable(void);
void Enable(void);

struct Task    *FindTask(STRPTR name);
struct Message *GetMsg(struct MsgPort *port);
void            ReplyMsg(struct Message *msg);
struct Message *WaitPort(struct MsgPort *port);
ULONG           AvailMem(ULONG requirements);
struct Library *OpenLibrary(STRPTR name, ULONG version);
void            CloseLibrary(struct Library *library);

/* graphics */
struct BitMap {
    UWORD BytesPerRow;
    UWORD Rows;
    UBYTE Flags;
    UBYTE Depth;
    UWORD pad;
    PLANEPTR Planes[8];
};

struct TextFont;

struct RastPort {
    struct BitMap *BitMap;
    struct TextFont *Font;
    BYTE FgPen;
    BYTE BgPen;
    BYTE AOlPen;
    BYTE DrawMode;
    UWORD Flags;                /* AREAOUTLINE = 8 */
    WORD cp_x;
    WORD cp_y;
};

struct ColorMap {
    UBYTE Flags;
    UBYTE Type;
    UWORD Count;
    UWORD *ColorTable;          /* Count colori RGB4 */
};

struct RasInfo {
    struct RasInfo *Next;
    struct BitMap *BitMap;
    WORD RxOffset;
    WORD RyOffset;
};

struct ViewPort {
    struct ViewPort *Next;
    struct ColorMap *ColorMap;
    WORD DWidth;
    WORD DHeight;
    WORD DxOffset;
    WORD DyOffset;
    UWORD Modes;
    struct RasInfo *RasInfo;
};

/* Lista Copper (graphics/copper.h): sull'host solo quella di Intuition. */
struct cprlist {
    struct cprlist *Next;
    UWORD *start;               /* coppie di word: registro, valore */
    WORD MaxCount;
};

struct View {
    struct ViewPort *ViewPort;
    struct cprlist *LOFCprList; /* liste Copper: sull'host sempre NULL */
    WORD DyOffset;
    WORD DxOffset;
    UWORD Modes;
};

struct GfxBase {
    struct Library LibNode;
    struct View *ActiView;      /* View mostrata (NULL: schermo Intuition) */
};

#define RASSIZE(w, h) ((ULONG)(h) * ((((ULONG)(w) + 15) >> 3) & 0xFFFE))

void     LoadRGB4(struct ViewPort *vp, const UWORD *colors, LONG count);
void     InitView(struct View *view);
void     InitVPort(struct ViewPort *vp);
struct ColorMap *GetColorMap(LONG entries);
void     FreeColorMap(struct ColorMap *cm);
void     MakeVPort(struct View *view, struct ViewPort *vp);
void     MrgCop(struct View *view);
void     LoadView(struct View *view);
void     FreeVPortCopLists(struct ViewPort *vp);
void     FreeCprList(struct cprlist *list);
void     InitRastPort(struct RastPort *rp);
void     WaitTOF(void);
void     OwnBlitter(void);
void     DisownBlitter(void);
void     WaitBlit(void);
void     SetAPen(struct RastPort *rp, ULONG pen);
void     SetBPen(struct RastPort *rp, ULONG pen);
void     RectFill(struct RastPort *rp, LONG xmin, LONG ymin, LONG xmax,
                  LONG ymax);

#define AREAOUTLINE 0x0008
#define COMPLEMENT  2
void     InitBitMap(struct BitMap *bm, LONG depth, LONG width, LONG height);
PLANEPTR AllocRaster(ULONG width, ULONG height);
void     FreeRaster(PLANEPTR p, ULONG width, ULONG height);
void     BltClear(void *memory, ULONG count, ULONG flags);
LONG     BltBitMap(struct BitMap *src, LONG src_x, LONG src_y,
                   struct BitMap *dst, LONG dst_x, LONG dst_y, LONG width,
                   LONG height, ULONG minterm, ULONG mask, PLANEPTR temp);
void     BltMaskBitMapRastPort(struct BitMap *src, LONG src_x, LONG src_y,
                               struct RastPort *dst, LONG dst_x, LONG dst_y,
                               LONG width, LONG height, ULONG minterm,
                               PLANEPTR mask);

/* intuition */
struct TextAttr;
struct Gadget;
struct Image;

#define CUSTOMSCREEN  0x000F
#define WBENCHSCREEN  0x0001
#define HIRES         0x8000
#define LACE          0x0004
#define HAM           0x0800

struct NewScreen {
    WORD LeftEdge, TopEdge, Width, Height, Depth;
    UBYTE DetailPen, BlockPen;
    UWORD ViewModes;
    UWORD Type;
    struct TextAttr *Font;
    UBYTE *DefaultTitle;
    struct Gadget *Gadgets;
    struct BitMap *CustomBitMap;
};

struct Screen {
    WORD LeftEdge, TopEdge, Width, Height;
    UBYTE *Title;
    struct ViewPort ViewPort;
    struct RastPort RastPort;
    struct BitMap BitMap;
    struct RasInfo RasInfo;     /* (host) RasInfo del ViewPort */
    BOOL ShowTitle;
};

/* IntuitionBase: solo lo schermo in primo piano (FirstScreen). */
struct IntuitionBase {
    struct Library LibNode;
    struct Screen *FirstScreen;
};

struct NewWindow {
    WORD LeftEdge, TopEdge, Width, Height;
    UBYTE DetailPen, BlockPen;
    ULONG IDCMPFlags;
    ULONG Flags;
    struct Gadget *FirstGadget;
    struct Image *CheckMark;
    UBYTE *Title;
    struct Screen *Screen;
    struct BitMap *BitMap;
    WORD MinWidth, MinHeight;
    UWORD MaxWidth, MaxHeight;
    UWORD Type;
};

struct Window {
    WORD LeftEdge, TopEdge, Width, Height;
    ULONG IDCMPFlags;
    ULONG Flags;
    struct RastPort *RPort;
    struct Screen *WScreen;
    struct MsgPort *UserPort;   /* porta IDCMP (eventi da SDL) */
    WORD MouseY, MouseX;        /* posizione del mouse nella finestra */
};

#define IDCMP_INTUITICKS 0x00400000

#define IDCMP_MOUSEBUTTONS 0x00000008
#define IDCMP_RAWKEY       0x00000400
#define SELECTDOWN 0x68
#define SELECTUP   0xE8
#define MENUDOWN   0x69
#define MENUUP     0xE9

struct IntuiMessage {
    struct Message ExecMessage;
    ULONG Class;
    UWORD Code;
    UWORD Qualifier;
    APTR IAddress;
    WORD MouseX, MouseY;
    ULONG Seconds, Micros;
    struct Window *IDCMPWindow;
};

/* Solo i campi di Preferences letti dal gioco. */
struct Preferences {
    BYTE ViewXOffset;
    BYTE ViewYOffset;
    WORD ViewInitX;
    WORD ViewInitY;
};

struct Preferences *GetPrefs(struct Preferences *prefs, LONG size);
struct IntuiText {
    UBYTE FrontPen, BackPen;
    UBYTE DrawMode;
    WORD LeftEdge;
    WORD TopEdge;
    struct TextAttr *ITextFont;
    UBYTE *IText;
    struct IntuiText *NextText;
};

BOOL AutoRequest(struct Window *window, struct IntuiText *body,
                 struct IntuiText *pos, struct IntuiText *neg,
                 ULONG pos_flags, ULONG neg_flags, LONG width, LONG height);
struct Screen *OpenScreen(struct NewScreen *ns);
void           CloseScreen(struct Screen *screen);
struct Window *OpenWindow(struct NewWindow *nw);
void           CloseWindow(struct Window *window);
void           ShowTitle(struct Screen *screen, LONG show);
void           ModifyIDCMP(struct Window *window, ULONG flags);
LONG           CloseWorkBench(void);
ULONG          OpenWorkBench(void);
void           ActivateWindow(struct Window *window);
void           ClearPointer(struct Window *window);
void           SetPointer(struct Window *window, UWORD *data, LONG height,
                          LONG width, LONG x_offset, LONG y_offset);

/* dos.library (le altre funzioni DOS sono in h002_dos.c). */
void Delay(LONG ticks);

/* Input (host/input.c): eventi SDL -> messaggi IDCMP. */
union SDL_Event;
void host_input_open_window(struct Window *window);
void host_input_close_window(struct Window *window);
void host_input_event(const union SDL_Event *ev);
int  host_input_pending(void);
void host_input_script(unsigned long now);   /* COK_KEYS */

/* Display SDL2 (host/display.c). */
void host_display_attach(struct Screen *screen);   /* schermo visibile */
void host_display_detach(struct Screen *screen);
void host_display_changed(void);   /* bitmap o colori modificati */
struct Screen *host_first_screen(void);     /* IntuitionBase->FirstScreen */
void host_screen_colors_changed(struct ViewPort *vp); /* Copper di Intuition */
void host_display_view(struct View *view);   /* LoadView */
void host_display_refresh(int force);
int  host_display_wait_key(void);
void host_display_wait_event(int timeout_ms);  /* attende ed elabora eventi */
unsigned long host_ticks_ms(void);
void host_display_show_cursor(int show);  /* tasto premuto (SDL_Keycode), -1 se nessun display */

#endif
