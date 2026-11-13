/*
 * Global data.
 *
 * H005 is the hunk of the shared data: here it is a $531C-byte image with the
 * same layout as the original (big-endian words and longs), because the
 * game accesses it as bytes and as words at the same addresses and saves
 * contiguous ranges of it.  The fields already identified have a name (macro or
 * accessor); the others are read with H005_B/H005_W/H005_L and the offset.
 * The pointers of the original (32 bits) do not live here: they are C variables.
 */
#ifndef COK_GLOBALS_H
#define COK_GLOBALS_H

#include "cok.h"
#include "gfx_record.h"

#define H005_SIZE 0x531Cu

extern u8 g_h005[H005_SIZE];

#define H005_B(off)        (g_h005[(off)])
#define H005_W(off)        COK_GET16(&g_h005[(off)])
#define H005_L(off)        COK_GET32(&g_h005[(off)])
#define H005_SET_W(off, v) COK_PUT16(&g_h005[(off)], (v))
#define H005_SET_L(off, v) do { u32 cok_v_ = (u32)(v); \
                               COK_PUT16(&g_h005[(off)], cok_v_ >> 16); \
                               COK_PUT16(&g_h005[(off) + 2], cok_v_); } while (0)

/* Identified fields. */
#define G_RESOURCE_GROUP   H005_B(0x246E)  /* 1 game, 2 demo, 0 end of demo */
#define G_DEMO_FLAG        H005_B(0x24D7)  /* 1 if Demo was chosen */
#define G_PROMPT_TIMEOUT   ((s32)H005_L(0x2792)) /* wait in 1/100 s */
/* $2792: (long) maximum wait time for the choice, in 1/100 s (0 none) */
#define G_SET_PROMPT_TIMEOUT(v) H005_SET_L(0x2792, (u32)(v))
#define G_VIEW_START(i)    H005_B(0x2826 + (i))  /* arguments of H011+$04A6 */
#define G_DATA_PREFIX      ((char *)&g_h005[0x3D26]) /* "df0:" or "", $51 bytes */
#define G_PROMPT_KEY       H005_B(0x52FB)  /* key when the wait ends */
#define G_KEY              H005_B(0x5305)  /* pending key/action (H010) */
#define G_MOUSE_CLICK      H005_B(0x249E)  /* 1 if the key comes from the mouse */

/*
 * Pointers kept in H005 (longs in the original): C variables, because on
 * the host a pointer does not fit in 32 bits.  The corresponding cells of g_h005
 * stay unused.
 */

extern u8 *g_state_a;                   /* $3E04: persistent state A, $800 */
extern u8 *g_state_b;                   /* $3E00: persistent state B, $800 */
extern u8 *g_state_c;                   /* $3DFC: persistent state C, $400 */
extern u8 *g_ecl_buffer;                /* $3DF8: programma ECL, $1E00 */
extern u8 *g_h005_282e;                 /* $282E: block of $924 bytes */
extern u8 *g_geo_planes;                /* $282A: four GEO data planes, $400 */
extern struct GfxRecord *g_gfx_332c;    /* $332C */
extern struct GfxRecord *g_gfx_3334;    /* $3334 */
extern struct GfxRecord *g_gfx_3348;    /* $3348 */
extern struct GfxRecord *g_gfx_3d8a;    /* $3D8A */
extern struct GfxRecord *g_gfx_243a;    /* $243A: combat icons */
extern struct GfxRecord *g_gfx_3d8e;    /* $3D8E: off-screen 320x200 bitmap */
extern struct GfxRecord *g_gfx_sky_2804; /* $2804: "sky" $FC */
extern struct GfxRecord *g_gfx_sky_2808; /* $2808: "sky" $FB */
extern struct GfxRecord *g_gfx_sky_280c; /* $280C: "sky" $FA */
extern struct Screen *g_screen;         /* $52F2: game screen */
extern struct Window *g_window;         /* $52F6: game window */
extern struct RastPort *g_rastport;     /* $52EE: RastPort of the window */
extern struct GfxRecord *g_gfx_2798;    /* $2798 */
extern struct GfxRecord *g_gfx_27b0[2]; /* $27B2, $27B8: record of two 6-byte entries */
extern u8 *g_h005_52fc;                 /* $52FC: block of $34 bytes */
extern u8 *g_h005_5300;                 /* $5300: block of $34 bytes */
extern u8 *g_dax_buffer;                /* $3C7E: compressed DAX block */
extern struct GfxRecord *g_8x8_sets[5]; /* $3338: 8x8 sets loaded by H034 */
extern struct GfxRecord *g_sprite_sets[29][2]; /* $3244: pairs of 24x24 sets */
extern struct GfxRecord *g_pic_rec_27c2; /* $27C2: picture of the set $27BC */
extern struct GfxRecord *g_pic_rec_27c6; /* $27C6 */
extern u8 *g_pic_buffers[7];            /* $27E8: blocks 2..8 of the set */
#include "character.h"
extern struct Character *g_party_head;  /* $3364: head of the party list */
extern struct Character *g_current_char;/* $3368: current character */
extern struct Character *g_h005_2508;   /* $2508: chosen character */
extern struct Character *g_spell_target;/* $251C: chosen target */
extern struct Character *g_spell_targets[40]; /* $2520..$25BF: targets */
extern CokItem *g_scroll_item;
extern u8 *g_combat_area;               /* $2ADE: combat map ($9CE bytes) */
/* Cloud (Stinking Cloud and the like), $22-byte record of the list $2514. */
typedef struct CokCloud {
    struct Character *owner;            /* +$00 */
    struct CokCloud *next;              /* +$04 */
    u8 b[0x22];                         /* +$08..: positions, +$1C/+$1E, +$20, +$21 */
} CokCloud;
extern CokCloud *g_clouds;              /* $2514 */
extern CokCloud *g_acid_pools;          /* $250C: acid pools (same records) */
extern struct Character *g_h005_2a14;   /* $2A14: target of the turn being examined */
extern struct Character *g_combatants[40]; /* $2B32..$2BD1: combatants by number */
extern struct Character *g_h005_0016[20]; /* $16..$65: characters on the ground ($14 = how many) */
/* Weapon lost in combat: copy of the $48 bytes of the item + who lost it. */
typedef struct CokDropped {
    u8 b[0x48];                         /* +$00: copy of the item */
    struct Character *owner;            /* +$48 */
    struct CokDropped *next;            /* +$4C */
} CokDropped;
extern CokDropped *g_dropped_items;     /* $3360 */
/* Character fallen on the map (H005+$2AE2, 8 entries of $A bytes, $247A used). */
typedef struct CokBody {
    struct Character *who;              /* +$00 */
    u16 x;                              /* +$04 */
    u16 y;                              /* +$06 */
    u8 tile;                            /* +$08: saved contents of the square */
} CokBody;
extern CokBody g_bodies[8];             /* $2AE2 */
extern CokItem *g_treasure_items;       /* $2A3A: treasure items */
extern CokItem *g_thrown_tail;          /* $335C: last thrown weapon put into the treasure */
extern struct Character *g_h005_2432;   /* $2432: preferred target (effect $5B) */

/*
 * Tables of handlers in H005 (code pointers in the original).  The type
 * is generic until whoever calls them is ported.
 */
typedef void (*CokHandler)(void);
extern CokHandler g_handlers_25c0[108]; /* $25C0..$276C: actions (H033) */
extern CokHandler g_handlers_2832[120]; /* $2832..$2A0E: effects (H027/H033) */

/* Data of other modules. */
extern int g_argc;                 /* arguments (H015+$8: argv) */
extern char **g_argv;
extern u16 g_distribution_check;
extern u8  g_h047_0001;            /* H047+$0001 (-$1(a4) of H047) */   /* H009+$0000: $3F8F after the check */

#endif
