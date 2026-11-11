/*
 * H001: corpo principale del gioco.
 *
 * Dati del modulo (a4 = H001+$4):
 *   $0   ""                            nome per Lock (directory corrente)
 *   $2   "df0:"                        prefisso per il dischetto
 *   $7   ""                            prefisso per il disco fisso
 *   $9   "Champions of Krynn v1.0 "    titolo del prompt ($2C uguale)
 *   $22  "Play Demo"                   opzioni del prompt ($45 uguale)
 *   -$2  flag "speciale" restituito da H008+$01FC
 *   -$1  tasto scelto
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
 * PORT H001+$0066: prefisso dei file di dati.  Lock della directory
 * corrente, Info in un blocco di $24 byte: sotto $708 blocchi (dischetto)
 * il prefisso e' "df0:", altrimenti "".  La copia usa dbeq con d2 = $50,
 * cioe' al massimo $51 byte compreso il NUL.
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

/* Prompt "Play Demo" con attesa massima timeout e tasto predefinito 'D'. */
static void ask_play_or_demo(s32 timeout)
{
    G_SET_PROMPT_TIMEOUT(timeout);
    G_PROMPT_KEY = 'D';
    s_choice = ui_request_choice(0x18, s_title, 9, s_options, 0x0D, 0x0A,
                                 0x0F, 0, 0, &s_special);
    G_SET_PROMPT_TIMEOUT(0);
    G_PROMPT_KEY = 0;
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
        G_DEMO_FLAG = (u8)(key == 'D');

        if (!G_DEMO_FLAG) {
            if (!manual_check()) {
                quit_game();
            }
            if (g_distribution_check != 0x3F8F) {
                quit_game();
            }
            G_RESOURCE_GROUP = 1;
            main_menu();
        } else {
            G_RESOURCE_GROUP = 2;
            H005_SET_W(0x3DF6, 9);
        }

        set_view_start(G_VIEW_START(3), G_VIEW_START(2), G_VIEW_START(1),
               G_VIEW_START(0));
        explore_loop();
        reset_game_state();

        if (G_DEMO_FLAG) {
            G_RESOURCE_GROUP = 0;
            play_intro();
            ask_play_or_demo(1000);
        }
    }
}
