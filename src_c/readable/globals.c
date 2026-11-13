/* Definitions of the global data (see globals.h). */
#include "globals.h"

u8  g_h005[H005_SIZE];
u16 g_distribution_check;
struct Character *g_h005_2508;
struct Character *g_spell_target;
struct Character *g_spell_targets[40];
CokItem *g_scroll_item;
u8 *g_combat_area;
CokCloud *g_clouds;
CokCloud *g_acid_pools;
CokDropped *g_dropped_items;
CokBody g_bodies[8];
CokItem *g_treasure_items;
CokItem *g_thrown_tail;
struct Character *g_h005_2432;
struct Character *g_h005_2a14;
struct Character *g_combatants[40];
struct Character *g_h005_0016[20];

u8 *g_state_a;
u8 *g_state_b;
u8 *g_state_c;
u8 *g_ecl_buffer;
u8 *g_h005_282e;
u8 *g_geo_planes;
struct GfxRecord *g_gfx_332c;
struct GfxRecord *g_gfx_3334;
struct GfxRecord *g_gfx_3348;
struct GfxRecord *g_gfx_3d8a;
struct GfxRecord *g_gfx_243a;
struct GfxRecord *g_gfx_3d8e;
struct GfxRecord *g_gfx_sky_2804;
struct GfxRecord *g_gfx_sky_2808;
struct GfxRecord *g_gfx_sky_280c;
struct Screen *g_screen;
struct Window *g_window;
struct RastPort *g_rastport;
struct GfxRecord *g_gfx_2798;
struct GfxRecord *g_gfx_27b0[2];
u8 *g_h005_52fc;
u8 *g_h005_5300;
u8 *g_dax_buffer;
struct GfxRecord *g_8x8_sets[5];
struct GfxRecord *g_sprite_sets[29][2];
struct GfxRecord *g_pic_rec_27c2;
struct GfxRecord *g_pic_rec_27c6;
u8 *g_pic_buffers[7];
struct Character *g_party_head;
struct Character *g_current_char;

CokHandler g_handlers_25c0[108];
CokHandler g_handlers_2832[120];
