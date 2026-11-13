/*
 * H001: main body of the game.
 *
 * Module data (a4 = H001+$4):
 *   $0   ""                            name for Lock (current directory)
 *   $2   "df0:"                        prefix for the floppy disk
 *   $7   ""                            prefix for the hard disk
 *   $9   "Champions of Krynn v1.0 "    title of the prompt ($2C the same)
 *   $22  "Play Demo"                   options of the prompt ($45 the same)
 *   -$2  "special" flag returned by H008+$01FC
 *   -$1  chosen key
 */
#include "h001_main.h"
#include "h002_dos.h"
#include "h003_exec.h"
#include "h004_init.h"
#include "h006.h"
#include "h007.h"
#include "h008.h"
#include "h009.h"
#include "h013.h"
#include "h011.h"
#include "h012.h"
#include "globals.h"
#include "h010_input.h"
#include "unported.h"

static u8 s_special;               /* H001 -$2(a4) */
static u8 s_choice;                /* H001 -$1(a4) */

static const char s_title[] = "Champions of Krynn v1.0 ";
static const char s_options[] = "Play Demo";

/*
 * PORT H001+$0066: prefix of the data files.  Lock of the current
 * directory, Info in a $24-byte block: below $708 blocks (floppy disk)
 * the prefix is "df0:", otherwise "".  The copy uses dbeq with d2 = $50,
 * that is at most $51 bytes including the NUL.
 */
static void select_data_prefix(void)
{
    cok_bptr lock;
    cok_info_data *info;

    lock = dos_lock("", ACCESS_READ);
    info = (cok_info_data *)exec_alloc_mem(0x24, COK_MEMF_CLEAR);
    (void)dos_info(lock, info);
    if (info->id_NumBlocks < 0x708) {
        strcpy(G_DATA_PREFIX, "df0:");
    } else {
        strcpy(G_DATA_PREFIX, "");
    }
    dos_unlock(lock);
    exec_free_mem(info, 0x24);
}

/* "Play Demo" prompt with maximum wait timeout and default key 'D'. */
static void ask_play_or_demo(s32 timeout)
{
    /* $2792: (long) maximum wait time for the choice, in 1/100 s (0 none); $2794: low word of the
     * long $2792 (maximum wait time) */
    G_SET_PROMPT_TIMEOUT(timeout);
    G_PROMPT_KEY = 'D'; /* $52FB: key returned when the wait times out (G_PROMPT_KEY) */
    s_choice = ui_request_choice(0x18, s_title, 9, s_options, 0x0D, 0x0A,
                                 0x0F, 0, 0, &s_special);
    /* $2792: (long) maximum wait time for the choice, in 1/100 s (0 none); $2794: low word of the
     * long $2792 (maximum wait time) */
    G_SET_PROMPT_TIMEOUT(0);
    G_PROMPT_KEY = 0; /* $52FB: key returned when the wait times out (G_PROMPT_KEY) */
}

/* PORT H001+$0058 */
void game_main(void)
{
    h004_0c28();
    select_data_prefix();
    init_game_environment();
    play_intro();
    ask_play_or_demo(3000);

    for (;;) {
        u8 key = s_choice;

        if (key >= 'a' && key <= 'z') {
            key = (u8)(key & 0x5F);
        }
        G_DEMO_FLAG = (u8)(key == 'D'); /* $24D7: 1 if the demonstration (Demo) was chosen */

        if (!G_DEMO_FLAG) { /* $24D7: 1 if the demonstration (Demo) was chosen */
            if (!manual_check()) {
                quit_game();
            }
            if (g_distribution_check != 0x3F8F) {
                quit_game();
            }
            G_RESOURCE_GROUP = 1; /* $246E: data disk / current resource group (G_RESOURCE_GROUP) */
            main_menu();
        } else {
            G_RESOURCE_GROUP = 2; /* $246E: data disk / current resource group (G_RESOURCE_GROUP) */
            H005_SET_W(0x3DF6, 9); /* $3DF6: (word) game speed 0..9 (message pause) */
        }

        /* $2829: sky colour of the view (1st view start byte); $2828: use: 2nd view start byte (arg b
         * of H011+$04A6); $2827: use: 3rd view start byte (arg c of H011+$04A6) */
        set_view_start(G_VIEW_START(3), G_VIEW_START(2), G_VIEW_START(1),
               /* $2826: use: 4th view start byte (arg d of H011+$04A6), 8 in the dungeon */
               G_VIEW_START(0));
        explore_loop();
        reset_game_state();

        if (G_DEMO_FLAG) { /* $24D7: 1 if the demonstration (Demo) was chosen */
            G_RESOURCE_GROUP = 0; /* $246E: data disk / current resource group (G_RESOURCE_GROUP) */
            play_intro();
            ask_play_or_demo(1000);
        }
    }
}
