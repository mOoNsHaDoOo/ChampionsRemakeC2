/* H008: UI interactions, choice requests and menus. */
#include "h008.h"
#include "h030.h"
#include "h010_input.h"
#include "h021_intuition.h"
#include "h026_string.h"
#include "h029_gfx.h"
#include "h003_exec.h"
#include "globals.h"
#include "character.h"
#include "unported.h"
#include "h046.h"
#include "h042_seq.h"
#include "h077.h"
#include "h048.h"

/* PORT H008+$009A: link/unlk, no effect. */
void h008_init(void)
{
}

/* PORT H008+$139E: clears (pen 0) the last text row, row 24. */
void clear_message_line(void)
{
    fill_text_cells(0, 0x18, 0, 0x28);
}

/* PORT H008+$01A0: 1 for capital letters and digits. */
static u8 is_hotkey_char(u8 c)
{
    return (u8)((c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9'));
}

/*
 * Local variables of UI_RequestChoice (frame of H008+$01FC) also used
 * by the nested sub-procedures $020A and $03C8, which in the original
 * reach them through the frame of the caller.
 */
typedef struct ChoiceFrame {
    /* arguments */
    const char *options;        /* $1A(a5) */
    u16 title_pen;              /* $18(a5) */
    u16 normal_pen;             /* $16(a5) */
    u16 highlight_pen;          /* $14(a5) */
    u8 digits_map;              /* $12(a5) */
    u8 animate;                 /* $10(a5) */
    u8 *special;                /* $C(a5) */
    /* locals */
    struct { u16 start; u16 end; } item[20];    /* -$C4: start/end */
    u16 count;                  /* -$74: number of options */
    u16 title_len;              /* -$72: length of the title */
    u16 options_len;            /* -$70: length of the options */
    u8 key;                     /* -$5E */
    u8 done;                    /* -$C5 */
    u8 result;                  /* -$5F */
    s16 col;                    /* -$68 */
    s16 row;                    /* -$6A */
} ChoiceFrame;

/*
 * PORT H008+$020A: splits the options into entries: every entry starts with a
 * capital letter or a digit and ends two characters before the next one
 * (the separating space excluded); the last one ends at the end of the
 * string.  The unused entries are 0..0.
 */
static void parse_options(ChoiceFrame *f, u16 len, const char *options)
{
    u16 i;
    u16 j;
    u16 n = 1;                          /* -$2 */
    u16 length;                         /* -$8 */

    for (i = 1; i <= 0x14; ++i) {
        for (j = 0; j <= 1; ++j) {
            if (j == 0) {
                f->item[i - 1].start = 0x3E7;
            } else {
                f->item[i - 1].end = 0x3E7;
            }
        }
    }
    length = h026_strlen(len, options);
    for (i = 0; i <= length; ++i) {
        if (is_hotkey_char((u8)options[i])) {
            if (f->item[n - 1].start == 0x3E7) {
                f->item[n - 1].start = i;
            } else {
                f->item[n - 1].end = (u16)(i - 2);
                ++n;
                f->item[n - 1].start = i;
            }
        }
        if (i == 0xFFFF) {
            break;
        }
    }
    f->item[n - 1].end = (u16)(length - 1);
    for (i = 1; i <= 0x14; ++i) {
        if (f->item[i - 1].start == 0x3E7) {
            f->item[i - 1].start = 0;
        }
        if (f->item[i - 1].end == 0x3E7) {
            f->item[i - 1].end = 0;
        }
    }
    f->count = n;
}

/*
 * PORT H008+$03C8: draws the options on row 24 after the title: the
 * selected entry in reverse (if there is a highlight pen), the
 * initials with the highlight pen, the rest with the normal pen; then
 * clears up to column 39.
 */
static void draw_options(ChoiceFrame *f, u8 selected)
{
    u16 i;

    if (f->options_len == 0) {
        return;
    }
    for (i = 0; i <= (u16)(f->options_len - 1); ++i) {
        u16 col = (u16)(f->title_len + i);
        u8 ch = (u8)f->options[i];

        if (i >= f->item[selected - 1].start &&
            i <= f->item[selected - 1].end && f->highlight_pen != 0) {
            draw_char_run(col, 0x18, 0, f->highlight_pen, 1, ch, 1);
        } else if (is_hotkey_char(ch)) {
            draw_char_run(col, 0x18, f->highlight_pen, 0, 1, ch, 1);
        } else {
            draw_char_run(col, 0x18, f->normal_pen, 0, 1, ch, 1);
        }
    }
    if ((u16)(f->title_len + f->options_len) < 0x27) {
        draw_char_run((u16)(f->title_len + f->options_len), 0x18, 0, 0,
                      (u16)(0x27 - f->options_len - f->title_len + 1), ' ', 1);
    }
}

/* Index of the selected option (H005+$2483, persistent across calls). */
/* $2483: index of the selected option in the row menus (persistent) */
#define CHOICE_SELECTED H005_B(0x2483)

/* Combat/map coordinates of the cursor (branches $07F8/$0D8E). */
static void map_target(s16 *dx, s16 *dy)
{
    const u8 *area = g_combat_area;

    if (H005_B(0x24CC)) { /* $24CC: 1 in Manual mode: cursor on the combat map */
        /* $2438: cursor X on the combat map (word, 0..49) */
        *dx = (s16)(H005_W(0x2438) - COK_GET16(area + 2) + 1);
        /* $2436: cursor Y on the combat map (word, 0..24) */
        *dy = (s16)(H005_W(0x2436) - COK_GET16(area + 4) + 1);
    } else {
        s16 who = (s16)combatant_index(g_current_char);

        /* $3154: combatant positions, 6 bytes per n (from 1): +0 column (word) */
        *dx = (s16)(H005_W(0x3154 + (who - 1) * 6) - COK_GET16(area + 2) + 1);
        /* $3156: combatant positions +2: row on the map (word) */
        *dy = (s16)(H005_W(0x3154 + (who - 1) * 6 + 2) - COK_GET16(area + 4) + 1);
    }
}

/* Is the cursor on the combat map (22x22 cells)? */
static int over_combat_map(const ChoiceFrame *f)
{
    /* $24CB: 1 in Move/Attack mode: cursor on the combat map; $24CC: 1 in Manual mode: cursor on the
     * combat map; $3DE3: current game mode/context (0 menu, 1 view, 5 combat) */
    return (H005_B(0x24CB) || H005_B(0x24CC)) && H005_B(0x3DE3) == 5 &&
           f->col >= 0 && f->col <= 0x16 && f->row >= 0 && f->row <= 0x16;
}

/*
 * Is the cursor on the exploration view: inside the view 3..13, or
 * (outside the view, without the full-screen map, in context 3) in
 * 1..38 x 1..15.
 */
static int over_area_view(const ChoiceFrame *f)
{
    if (f->col >= 3 && f->col <= 0x0D && f->row >= 3 && f->row <= 0x0D) {
        return 1;
    }
    /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map; $3DE3: current game mode/context (0
     * menu, 1 view, 5 combat) */
    return COK_GET16(g_state_a + 0x1CC) == 0 && H005_B(0x3DE3) == 3 &&
           f->col >= 1 && f->col <= 0x26 && f->row >= 1 && f->row <= 0x0F;
}

/* Direction or action under the cursor in the view (H046 or table $4F86). */
static u8 area_view_code(const ChoiceFrame *f)
{
    if (COK_GET16(g_state_a + 0x1CC) == 0) { /* A+$1CC: (word) 1 3D area (16x16 map), 0 outdoor map */
        /* A+$186: (word) party x on the outdoor map (38x15) */
        return cursor_direction((u16)(COK_GET16(g_state_a + 0x186) + 1),
                         /* A+$188: (word) party y on the outdoor map (38x15) */
                         (u16)(COK_GET16(g_state_a + 0x188) + 1),
                         (u16)f->col, (u16)f->row);
    }
    /* $4F86: action under the cursor in the view: rows of $0C, from (3,3) */
    return H005_B(0x4F86 + (f->row - 3) * 0x0C + (f->col - 3));
}

/*
 * Enter key or click (branch $0BA6).  Without a click: the selected entry.  With
 * a click, in order: H047 active; party portraits; combat
 * map; exploration view; the option row; the areas
 * of $24DA; the list of H005+$2778.
 */
static void enter_or_click(ChoiceFrame *f)
{
    if (!G_MOUSE_CLICK) { /* $249E: 1 if the key comes from the mouse (click) */
        /* $2483: index of the selected option in the row menus (persistent) */
        f->key = (u8)f->options[f->item[CHOICE_SELECTED - 1].start];
        if (f->key == 0) {
            f->key = 0x0D;
        }
        f->done = 1;
        return;
    }
    f->row = (s16)((s16)H005_W(0x2354) / 8); /* $2354: mouse Y (word, initial $64) */
    f->col = (s16)((s16)H005_W(0x2356) / 8); /* $2356: mouse X (word, initial $A0) */
    if (g_h047_0001) {
        *f->special = 1;
        f->done = 1;
        return;
    }
    if (H005_B(0x24A2) && /* $24A2: 1: clicking a party name selects the character */
        /* $3DE3: game mode (0 menu, 1 view, 2 camp, 5 combat); A+$270: (word) town area:
         * no view redraw nor EXIT from the camp */
        (H005_B(0x3DE3) != 3 || COK_GET16(g_state_a + 0x270) != 0) &&
        /* $24B0: Move mode of the exploration: click on the view as movement; $3DE3: current game
         * mode/context (0 menu, 1 view, 5 combat) */
        !H005_B(0x24B0) && H005_B(0x3DE3) != 5 &&
        /* $248D: clickable party area: first column (1 or $11); $248C: clickable party area:
         * last column ($26) */
        f->col >= H005_B(0x248D) && f->col <= H005_B(0x248C) &&
        /* $248B: clickable party area: first row (4); $248A: clickable party area: last row
         * (3 + members) */
        f->row >= H005_B(0x248B) && f->row <= H005_B(0x248A)) {
        /* Click on a party character. */
        u16 index = (u16)(f->row - H005_B(0x248B)); /* $248B: clickable party area: first row (4) */
        Character *member = g_party_head;
        u16 i;

        for (i = 1; i <= index; ++i) {
            if (member != NULL) {
                member = member->next;
            }
        }
        if (member != NULL) {
            f->key = 'H';
            *f->special = 1;
            f->done = 1;
            if (H005_B(0x24D8)) { /* $24D8: member choice mode: the click goes to $2508 and not to the current one */
                g_h005_2508 = member;
            } else if (g_current_char == member) {
                *f->special = 0;
                /* $2483: index of the selected option in the row menus (persistent) */
                f->key = (u8)f->options[f->item[CHOICE_SELECTED - 1].start];
                if (f->key == 0) {
                    f->key = 0x0D;
                }
            } else {
                g_current_char = member;
            }
        }
        return;
    }
    if (over_combat_map(f)) {
        s16 dx;
        s16 dy;

        *f->special = 1;
        map_target(&dx, &dy);
        f->key = cursor_direction((u16)dx, (u16)dy, (u16)((f->col + 2) / 3),
                           (u16)((f->row + 2) / 3));
        f->done = 1;
        return;
    }
    /* $24B0: Move mode of the exploration: click on the view as movement */
    if (H005_B(0x24B0) && over_area_view(f)) {
        *f->special = 1;
        f->key = area_view_code(f);
        f->done = 1;
        return;
    }
    if (f->row == 0x18 && !f->done) {
        u16 i;

        ++f->col;
        if (!(f->col > (s16)f->title_len)) {
            /* Click on the title: the original exits at once (branch $0F56). */
            f->done = 2;
            return;
        }
        f->col = (s16)(f->col - f->title_len);
        for (i = 1; i <= f->count; ++i) {
            if ((s16)(f->item[i - 1].start + 1) <= f->col &&
                (s16)(f->item[i - 1].end + 1) >= f->col) {
                f->key = (u8)f->options[f->item[i - 1].start];
                /* $2483: index of the selected option in the row menus (persistent) */
                CHOICE_SELECTED = (u8)i;
                /* $2483: index of the selected option in the row menus (persistent) */
                draw_options(f, CHOICE_SELECTED);
                f->done = 1;
            }
        }
        return;
    }
    if (H005_B(0x24DA) && !f->done) { /* $24DA: 1 in Modify Character: the click chooses the field ($2506) */
        f->done = 1;
        switch (f->row) {
        case 1:
            if (f->col >= 1 && f->col <= 0x10) {
                /* $2506: (word) field clicked in Modify Character (0..7), $FF none */
                H005_SET_W(0x2506, 6);
            }
            break;
        case 3:
            if (f->col >= 0x1F && f->col <= 0x21) {
                /* $2506: (word) field clicked in Modify Character (0..7), $FF none */
                H005_SET_W(0x2506, 7);
            }
            break;
        case 9: case 10: case 11: case 12: case 13: case 14:
            if (f->col >= 5 && f->col <= 9) {
                /* $2506: (word) field clicked in Modify Character (0..7), $FF none */
                H005_SET_W(0x2506, (u16)(f->row - 9));
            }
            break;
        default:
            f->done = 0;
            break;
        }
        *f->special = 1;
        f->key = 'G';
        return;
    }
    /* $2504: (word) first column of the clickable area of the list menu */
    if (!f->done && f->col >= (s16)H005_W(0x2504) &&
        /* $2502: (word) last column of the clickable area of the list menu */
        f->col <= (s16)H005_W(0x2502)) {
        u16 i;

        for (i = 1; i <= 0x19; ++i) {
            /* $2777: 1-based base of the menu entry row table ($2778 + i - 1) */
            u8 limit = H005_B(0x2778 + i - 1);

            if (limit == 0xFF) {
                break;
            }
            if (!f->done && !(limit > f->row)) {
                f->done = 1;
                /* $2483: index of the selected option in the row menus (persistent) */
                f->key = (u8)f->options[f->item[CHOICE_SELECTED - 1].start];
            }
        }
    }
}

/* Digits 1..9 (and '\\' as 7) translated with the table H005+$4F7C. */
static void map_digit(ChoiceFrame *f)
{
    f->key = H005_B(0x4F7C + f->key - '1'); /* $4F7C: translation of the digit keys 1..9 into action keys */
    *f->special = 1;
}

/*
 * PORT H008+$01FC (UI_RequestChoice): shows on row 24 the title and the
 * options (entries with a capital initial) and returns the choice: the letter
 * of the entry, Enter/click on the selected entry, Esc (0), or a special
 * key with *special = 1 (arrows/'4' '6' to scroll, Alt+a/m/q/x,
 * clicks in the game areas).  With a maximum time (G_PROMPT_TIMEOUT, in
 * hundredths) it returns G_PROMPT_KEY.  The selected entry stays in
 * H005+$2483.  While waiting it animates the picture set of $27BC and
 * updates the shape of the pointer.
 */
u8 ui_request_choice(u16 title_len, const char *title, u16 options_len,
                     const char *options, u16 title_pen, u16 normal_pen,
                     u16 highlight_pen, u8 digits_map, u8 animate,
                     u8 *special)
{
    ChoiceFrame f;
    s32 last_time;                      /* -$56 */
    s32 now;                            /* -$5A */
    s16 shape_code;                     /* -$5C */
    u8 shape;                           /* -$5D */

    memset(&f, 0, sizeof(f));
    f.options = options;
    f.title_pen = title_pen;
    f.normal_pen = normal_pen;
    f.highlight_pen = highlight_pen;
    f.digits_map = digits_map;
    f.animate = animate;
    f.special = special;

    intuition_modify_idcmp(g_window, g_window->IDCMPFlags | 0x00400000UL);
    H005_B(0x249D) = 0; /* $249D: 1 if the last UI_RequestChoice gave a special key */
    f.title_len = h026_strlen(title_len, title);
    parse_options(&f, options_len, options);
    /* $2483: index of the selected option in the row menus (persistent) */
    if (CHOICE_SELECTED > f.count || CHOICE_SELECTED == 0) {
        CHOICE_SELECTED = 1; /* $2483: index of the selected option in the row menus (persistent) */
    }
    f.options_len = h026_strlen(options_len, options);
    f.key = 0;
    *special = 0;
    f.done = 0;
    last_time = time_hundredths();
    if (title[0] != 0) {
        ui_draw_text(0, 0x18, title_pen, 0, title_len, title);
    }
    /* $2483: index of the selected option in the row menus (persistent) */
    draw_options(&f, CHOICE_SELECTED);

    do {
        f.key = 0;
        /* Animation of the picture set ($069E). */
        /* A+$3FE: use: forces the animation while waiting for a choice; added to the direction */
        if ((COK_GET16(g_state_a + 0x3FE) != 0 || animate) &&
            /* $27BE: (word) current frame of the sequence animation (1..n) */
            H005_W(0x27BE) > 0) {
            u16 frame;
            s16 wait;

            now = time_hundredths();
            /* $27BE: (word) current frame of the sequence animation (1..n) */
            frame = (u16)(H005_W(0x27BE) + 1);
            /* $27BC: (word) frames of the loaded sequence (max 6), base of the block */
            if (frame > H005_W(0x27BC)) {
                frame = 1;
            }
            /* $27CA: tab. of words per frame (idx frame-1): duration in 1/10 s */
            wait = (s16)(H005_W(0x27BC + 0x0E + (frame - 1) * 2) * 10 - 0x0B);
            if (wait < 0) {
                wait = 0;
            }
            /* A+$3FE: use: forces the animation while waiting for a choice; added to the direction */
            if (COK_GET16(g_state_a + 0x3FE) != 0 ||
                !(now - last_time < (s32)wait)) {
                /* $27BE: (word) current frame of the sequence animation (1..n) */
                H005_SET_W(0x27BE, frame);
                show_picture(3, 3, animate, sequence_frame(frame));
                last_time = now;
            }
        }
        /* Shape of the pointer ($076A). */
        if (H005_B(0x24E2)) { /* $24E2: 1 while resting: wait pointer, messages from row $12 */
            shape_code = 9;
        } else {
            f.col = (s16)(g_window->MouseX / 8);
            f.row = (s16)(g_window->MouseY / 8);
            shape = 0;
            if (over_combat_map(&f)) {
                s16 dx;
                s16 dy;

                map_target(&dx, &dy);
                shape = cursor_direction((u16)dx, (u16)dy, (u16)((f.col + 2) / 3),
                                  (u16)((f.row + 2) / 3));
            /* $24B0: Move mode of the exploration: click on the view as movement */
            } else if (H005_B(0x24B0) && over_area_view(&f)) {
                shape = area_view_code(&f);
            }
            shape_code = 0x0A;
            switch (shape) {
            case 0x47: shape_code = 7; break;
            case 0x48: shape_code = 0; break;
            case 0x49: shape_code = 1; break;
            case 0x4B: shape_code = 6; break;
            case 0x4D: shape_code = 2; break;
            case 0x4F: shape_code = 5; break;
            case 0x50: shape_code = 4; break;
            case 0x51: shape_code = 3; break;
            default: break;
            }
        }
        set_pointer_shape(shape_code);

        /* Maximum time or input ($0A12). */
        /* $2792: (long) maximum wait time for the choice, in 1/100 s (0 none) */
        if (G_PROMPT_TIMEOUT > 0) {
            s32 elapsed = time_hundredths() - last_time;

            if (elapsed < 0) {
                elapsed = -elapsed;
            }
            /* $2792: (long) maximum wait time for the choice, in 1/100 s (0 none) */
            if (!(elapsed < G_PROMPT_TIMEOUT)) {
                f.key = G_PROMPT_KEY; /* $52FB: key returned when the wait times out (G_PROMPT_KEY) */
                f.done = 1;
            }
        }
        if (!f.done) {
            poll_intuition_events();
            f.key = G_KEY; /* $5305: key/action pending from the input (G_KEY) */
        }
        if (f.key != 0 && !f.done) {
            *special = 0;
            if (G_KEY > 0 && G_KEY < 5) { /* $5305: key/action pending from the input (G_KEY) */
                f.done = 1;
                *special = 1;
            } else {
                switch (f.key) {
                case 0x0D:
                    enter_or_click(&f);
                    if (f.done == 2) {
                        /*
                         * Click on the title: the original removes INTUITICKS and
                         * returns -$5F, which has not been written here
                         * (on the stack: undefined value); here 0.
                         */
                        intuition_modify_idcmp(g_window, g_window->IDCMPFlags &
                                                         ~0x00400000UL);
                        return f.result;
                    }
                    break;
                case 0x1B:
                    f.done = 1;
                    f.key = 0;
                    break;
                case '4':
                    *special = 1;
                    if (f.count > 1) {
                        /* $2483: index of the selected option in the row menus (persistent) */
                        if (CHOICE_SELECTED == 1) {
                            /* $2483: index of the selected option in the row menus (persistent) */
                            CHOICE_SELECTED = (u8)f.count;
                        } else {
                            /* $2483: index of the selected option in the row menus (persistent) */
                            CHOICE_SELECTED = (u8)(CHOICE_SELECTED - 1);
                        }
                        /* $2483: index of the selected option in the row menus (persistent) */
                        draw_options(&f, CHOICE_SELECTED);
                    } else {
                        if (digits_map) {
                            map_digit(&f);
                        }
                        f.done = 1;
                    }
                    break;
                case '6':
                    *special = 1;
                    if (f.count > 1) {
                        /* $2483: index of the selected option in the row menus (persistent) */
                        if (CHOICE_SELECTED == f.count) {
                            /* $2483: index of the selected option in the row menus (persistent) */
                            CHOICE_SELECTED = 1;
                        } else {
                            /* $2483: index of the selected option in the row menus (persistent) */
                            add_to_byte(&CHOICE_SELECTED, 1);
                        }
                        /* $2483: index of the selected option in the row menus (persistent) */
                        draw_options(&f, CHOICE_SELECTED);
                    } else {
                        f.done = 1;
                        if (digits_map) {
                            map_digit(&f);
                        }
                    }
                    break;
                default:
                    /* Letter of an entry, space, digits ($11BA). */
                    if (f.key >= 'a' && f.key <= 'z') {
                        f.key = (u8)(f.key & 0x5F);
                    }
                    if (is_hotkey_char(f.key) || f.key == ' ') {
                        if (f.key == ' ') {
                            f.done = 1;
                        } else {
                            u16 i;

                            for (i = 0; i <= f.options_len; ++i) {
                                if ((u8)options[i] == f.key) {
                                    u16 n;

                                    f.done = 1;
                                    /*
                                     * The original looks for the entry starting
                                     * here without a limit; here at most 20.
                                     */
                                    for (n = 1; n <= 0x14 &&
                                                f.item[n - 1].start != i; ++n) {
                                    }
                                    if (n <= 0x14) {
                                        /* $2483: index of the selected option in the row menus
                                         * (persistent) */
                                        CHOICE_SELECTED = (u8)n;
                                        /* $2483: index of the selected option in the row menus
                                         * (persistent) */
                                        draw_options(&f, CHOICE_SELECTED);
                                    }
                                }
                            }
                        }
                    }
                    if (digits_map && ((f.key >= '1' && f.key <= '9') ||
                                       f.key == '\\')) {
                        if (f.key == '\\') {
                            f.key = '7';
                        } else {
                            /* $4F7C: translation of the digit keys 1..9 into action keys */
                            f.key = H005_B(0x4F7C + f.key - '1');
                        }
                        *special = 1;
                        f.done = 1;
                    }
                    break;
                }
            }
        }
    } while (!f.done);

    /* A+$3FE: use: forces the animation while waiting for a choice; added to the direction */
    COK_PUT16(g_state_a + 0x3FE, 0);
    f.result = f.key;
    H005_B(0x249D) = *special; /* $249D: 1 if the last UI_RequestChoice gave a special key */
    intuition_modify_idcmp(g_window, g_window->IDCMPFlags & ~0x00400000UL);
    return f.result;
}

/* PORT H008+$0102: entry index (0 = the first), NULL if the list is short. */
CokMenuItem *menu_nth(CokMenuItem *list, u16 index)
{
    u16 i = 0;
    CokMenuItem *node = list;

    while (node != NULL && i != index) {
        node = node->next;
        ++i;
    }
    return i == index ? node : NULL;
}

/* PORT H008+$0162: number of entries. */
u16 menu_length(CokMenuItem *list)
{
    u16 n = 0;
    CokMenuItem *node = list;

    while (node != NULL) {
        ++n;
        node = node->next;
    }
    return n;
}

/*
 * Variables of list_menu (frame of H008+$13C0) used by the nested
 * sub-procedures $1448..$1A60 through the frame of the caller.
 */
typedef struct ListFrame {
    CokMenuItem *list;             /* $1A(a5) */
    u16 *index;                 /* $10(a5): selected entry */
    u16 first_col;              /* $24 */
    u16 first_row;              /* $22 */
    u16 last_col;               /* $20 */
    u16 last_row;               /* $1E */
    u16 title_pen;              /* $2A: headers */
    u16 normal_pen;             /* $28: entries */
    u16 highlight_pen;          /* $26: selected entry (background) */
    char text[0x52];            /* -$52 */
    u16 width;                  /* -$54 */
    u16 row_no;                 /* -$56 */
    u16 count;                  /* -$58 */
    u16 visible;                /* -$5C */
} ListFrame;

/* First row shown of the list menus (H005+$2796). */
#define LIST_TOP H005_W(0x2796) /* $2796: (word) index of the first entry shown in the list menus */
/* $2796: (word) index of the first entry shown in the list menus */
#define SET_LIST_TOP(v) H005_SET_W(0x2796, (u16)(v))

/*
 * PORT H008+$13CE: last header before entry index (or the first
 * entry if it is a header).  The result is not used by the caller.
 */
static CokMenuItem *last_header_before(CokMenuItem *list, s16 index)
{
    s16 i = 0;
    CokMenuItem *node = list;
    CokMenuItem *found = NULL;

    while (node != NULL && i < index) {
        if (node->header) {
            found = node;
        }
        node = node->next;
        ++i;
    }
    if (found == NULL && list->header) {
        return list;
    }
    return found;
}

/*
 * PORT H008+$1448: draws the entries from top in the menu area (headers
 * with title_pen, entries with normal_pen), noting in H005+$2778 the row of
 * each one ($FF = end).
 */
static void draw_menu_items(ListFrame *f, u16 top)
{
    CokMenuItem *node;
    s16 row;
    u16 len;

    /* $2778: 25-byte tab.: screen row of every menu entry shown, $FF end */
    h029_fill_bytes(0x18, &g_h005[0x2778], 0x19, 0xFF);
    clear_text_cells(f->first_col, f->first_row, f->last_col, f->last_row);
    node = menu_nth(f->list, top);
    (void)last_header_before(f->list, (s16)top);
    row = (s16)f->first_row;
    f->row_no = 1;
    while (node != NULL && row <= (s16)f->last_row) {
        /* $2777: 1-based base of the menu entry row table ($2778 + i - 1) */
        H005_B(0x2778 + f->row_no - 1) = (u8)row;
        ui_draw_text(f->first_col, (u16)row,
                     node->header ? f->title_pen : f->normal_pen, 0, 0x28,
                     node->text);
        len = h026_strlen(0x28, node->text);
        if (len < f->width) {
            draw_char_run((u16)(h026_strlen(0x28, node->text) + f->first_col),
                          (u16)row, 0, 0,
                          (u16)(f->width - h026_strlen(0x28, node->text)),
                          ' ', 1);
        }
        node = node->next;
        ++row;
        ++f->row_no;
    }
}

/* PORT H008+$15DC: leading spaces of the text. */
static u16 leading_spaces(u16 len, const char *text)
{
    u16 i = 0;
    u16 n = h026_strlen(len, text);

    while (i < n && text[i] == ' ') {
        ++i;
    }
    return i;
}

/*
 * PORT H008+$164E: position after the last non-space character; it starts from the
 * NUL, so in practice it is the length of the string.
 */
static u16 text_end(u16 len, const char *text)
{
    u16 n = h026_strlen(len, text);

    while (n > 1 && text[n] == ' ') {
        --n;
    }
    return n;
}

/* Text of entry index without leading spaces in f->text; returns the column. */
static u16 trimmed_text(ListFrame *f, u16 index)
{
    CokMenuItem *node = menu_nth(f->list, index);
    u16 lead = leading_spaces(0x28, node->text);
    u16 count = (u16)(text_end(0x28, node->text) - lead + 1);

    h026_substr(0x50, f->text, 0x28, node->text, lead, count);
    return (u16)(f->first_col + lead);
}

/* PORT H008+$16BA: highlights entry index (text 0 on highlight_pen). */
static void highlight_item(ListFrame *f, u16 index)
{
    u16 col = trimmed_text(f, index);

    /* $2796: (word) index of the first entry shown in the list menus */
    ui_draw_text(col, (u16)(index - LIST_TOP + f->first_row), 0,
                 f->highlight_pen, 0x50, f->text);
}

/* PORT H008+$176A: redraws entry index without the highlight. */
static void unhighlight_item(ListFrame *f, u16 index)
{
    CokMenuItem *node = menu_nth(f->list, index);
    u16 col = trimmed_text(f, index);

    /* $2796: (word) index of the first entry shown in the list menus */
    ui_draw_text(col, (u16)(index - LIST_TOP + f->first_row),
                 node->header ? f->title_pen : f->normal_pen, 0, 0x50,
                 f->text);
}

/*
 * PORT H008+$188A: moves the selection past the headers in the
 * direction down (wrapping inside the page), at most visible steps.
 * Past the end of the list the original reads the flag from a null
 * pointer, that is the byte at address $2A (CPU vector table,
 * normally not zero): the empty row is skipped like
 * a header.  Here a null node counts as a header.
 */
static void skip_headers(ListFrame *f, u8 down)
{
    s16 i = 0;
    CokMenuItem *node = menu_nth(f->list, *f->index);

    if (down) {
        while (i < (s16)f->visible && (node == NULL || node->header)) {
            ++i;
            ++*f->index;
            /* $2796: (word) index of the first entry shown in the list menus */
            if ((s16)*f->index > (s16)(LIST_TOP + f->visible - 1)) {
                *f->index = LIST_TOP; /* $2796: (word) index of the first entry shown in the list menus */
            }
            node = menu_nth(f->list, *f->index);
        }
    } else {
        while (i < (s16)f->visible && (node == NULL || node->header)) {
            ++i;
            --*f->index;
            /* $2796: (word) index of the first entry shown in the list menus */
            if ((s16)*f->index < (s16)LIST_TOP) {
                /* $2796: (word) index of the first entry shown in the list menus */
                *f->index = (u16)(LIST_TOP + f->visible - 1);
            }
            node = menu_nth(f->list, *f->index);
        }
    }
}

/*
 * PORT H008+$19A8: next (next) or previous page, keeping the
 * position of the selection in the page; redraws.
 */
static void page_menu(ListFrame *f, u8 next)
{
    /* $2796: (word) index of the first entry shown in the list menus */
    s16 rel = (s16)(*f->index - LIST_TOP);

    if (next) {
        /* $2796: (word) index of the first entry shown in the list menus */
        SET_LIST_TOP(LIST_TOP + f->visible);
        /* $2796: (word) index of the first entry shown in the list menus */
        if ((s16)LIST_TOP > (s16)(f->count - f->visible)) {
            /* $2796: (word) index of the first entry shown in the list menus */
            SET_LIST_TOP(f->count - f->visible);
        }
    } else {
        /* $2796: (word) index of the first entry shown in the list menus */
        SET_LIST_TOP(LIST_TOP - f->visible);
        if ((s16)LIST_TOP < 0) { /* $2796: (word) index of the first entry shown in the list menus */
            SET_LIST_TOP(0); /* $2796: (word) index of the first entry shown in the list menus */
        }
    }
    *f->index = (u16)(LIST_TOP + rel); /* $2796: (word) index of the first entry shown in the list menus */
    skip_headers(f, next);
    draw_menu_items(f, LIST_TOP); /* $2796: (word) index of the first entry shown in the list menus */
}

/* PORT H008+$1A60: selection down (down) or up, wrapping in the page. */
static void move_selection(ListFrame *f, u8 down)
{
    if (down) {
        ++*f->index;
        /* $2796: (word) index of the first entry shown in the list menus */
        if ((s16)*f->index > (s16)(LIST_TOP + f->visible - 1)) {
            *f->index = LIST_TOP; /* $2796: (word) index of the first entry shown in the list menus */
        }
    } else {
        --*f->index;
        /* $2796: (word) index of the first entry shown in the list menus */
        if ((s16)*f->index < (s16)LIST_TOP) {
            /* $2796: (word) index of the first entry shown in the list menus */
            *f->index = (u16)(LIST_TOP + f->visible - 1);
        }
    }
    skip_headers(f, down);
}

/*
 * PORT H008+$13C0 (body at $1AF4): list menu.  Shows the entries of list
 * in the area (first_col, first_row)..(last_col, last_row), the entry *index
 * highlighted and, on row 24, title and options with " Next"/" Prev" (if there
 * are other pages) and " Exit" (with_exit).  Up/down arrows (keypad
 * 8/2) move, 9/3 change page, N and P too; Enter or an option
 * choose: *chosen = selected entry and returns the key.  A click on
 * an entry selects it, a second click chooses it.  Esc, E or 0: *chosen
 * = NULL and 0.  *redraw: redraw the entries.
 */
u8 list_menu(u16 title_len, const char *title, u16 options_len,
             const char *options, u16 title_pen, u16 normal_pen,
             u16 highlight_pen, u16 first_col, u16 first_row,
             u16 last_col, u16 last_row, CokMenuItem *list, u8 with_exit,
             u8 *redraw, u16 *index, CokMenuItem **chosen)
{
    ListFrame f;
    char opts[0x2A];                    /* -$88 */
    u8 has_next;                        /* -$89 */
    u8 has_prev;                        /* -$8A */
    u8 special;                         /* -$59 */
    u8 key;                             /* -$5D */
    u8 prev_key = 'N';                  /* -$5E */
    u16 leading;                        /* -$90 */
    u16 total;                          /* -$92 */
    s16 row;                            /* -$96 */
    s16 col;                            /* -$94 */
    CokMenuItem *node;

    if (list == NULL) {
        *index = 0;
        *chosen = NULL;
        return 0;
    }
    memset(&f, 0, sizeof(f));
    f.list = list;
    f.index = index;
    f.first_col = first_col;
    f.first_row = first_row;
    f.last_col = last_col;
    f.last_row = last_row;
    f.title_pen = title_pen;
    f.normal_pen = normal_pen;
    f.highlight_pen = highlight_pen;

    H005_SET_W(0x2504, first_col); /* $2504: (word) first column of the clickable area of the list menu */
    H005_SET_W(0x2502, last_col); /* $2502: (word) last column of the clickable area of the list menu */
    f.width = (u16)(last_col - first_col + 1);
    f.count = menu_length(list);
    f.visible = (u16)(last_row - first_row + 1);
    leading = 0;
    for (node = list; node != NULL && node->header; node = node->next) {
        ++leading;
    }
    total = menu_length(list);
    if (!((s16)total > (s16)f.visible)) {
        SET_LIST_TOP(0); /* $2796: (word) index of the first entry shown in the list menus */
    }
    if ((s16)LIST_TOP > (s16)*index) { /* $2796: (word) index of the first entry shown in the list menus */
        SET_LIST_TOP(*index); /* $2796: (word) index of the first entry shown in the list menus */
        *redraw = 1;
    }
    if ((s16)LIST_TOP > (s16)total) { /* $2796: (word) index of the first entry shown in the list menus */
        SET_LIST_TOP(0); /* $2796: (word) index of the first entry shown in the list menus */
        *redraw = 1;
    }
    ++*index;
    move_selection(&f, 0);
    if (*redraw) {
        draw_menu_items(&f, LIST_TOP); /* $2796: (word) index of the first entry shown in the list menus */
    }
    *redraw = 0;

    for (;;) {
        highlight_item(&f, *index);
        h026_copy(0x28, opts, options_len, options);
        has_next = 0;
        has_prev = 0;
        /* $2796: (word) index of the first entry shown in the list menus */
        if ((s16)LIST_TOP < (s16)(f.count - f.visible)) {
            h026_append(0x28, opts, 5, " Next");
            has_next = 1;
        }
        /* $2796: (word) index of the first entry shown in the list menus */
        if ((s16)LIST_TOP > (s16)leading) {
            h026_append(0x28, opts, 5, " Prev");
            has_prev = 1;
        }
        if (with_exit) {
            h026_append(0x28, opts, 5, " Exit");
        }
        key = ui_request_choice(title_len, title, 0x28, opts, title_pen,
                                normal_pen, highlight_pen, 1, 0, &special);
        row = (s16)((s16)H005_W(0x2354) / 8); /* $2354: mouse Y (word, initial $64) */
        col = (s16)((s16)H005_W(0x2356) / 8); /* $2356: mouse X (word, initial $A0) */
        unhighlight_item(&f, *index);
        if (special) {
            switch (key) {
            case 'H':
                move_selection(&f, 0);
                break;
            case 'P':
                move_selection(&f, 1);
                break;
            case 'I':
                if (has_prev) {
                    page_menu(&f, 0);
                }
                break;
            case 'Q':
                if (has_next) {
                    page_menu(&f, 1);
                }
                break;
            default:
                break;
            }
            continue;
        }
        switch (key) {
        case 0:
        case 0x1B:
        case 'E':
            *chosen = NULL;
            return 0;
        case 'P':
            if (!G_MOUSE_CLICK || row == 0x18) { /* $249E: 1 if the key comes from the mouse (click) */
                page_menu(&f, 0);
            }
            break;
        case 'N':
            if (!G_MOUSE_CLICK || row == 0x18) { /* $249E: 1 if the key comes from the mouse (click) */
                page_menu(&f, 1);
            }
            break;
        default:
            if (G_MOUSE_CLICK && row != 0x18) { /* $249E: 1 if the key comes from the mouse (click) */
                /* $2504: (word) first column of the clickable area of the list menu; $2502: (word)
                 * last column of the clickable area of the list menu */
                if (col >= (s16)H005_W(0x2504) && col <= (s16)H005_W(0x2502)) {
                    u16 i;

                    for (i = 1; i <= 0x19; ++i) {
                        /* $2777: 1-based base of the menu entry row table ($2778 + i - 1) */
                        u8 item_row = H005_B(0x2778 + i - 1);

                        if (item_row == 0xFF) {
                            break;
                        }
                        if ((s16)item_row == row) {
                            /* $2796: (word) index of the first entry shown in the list menus */
                            if ((u16)(i - 1 + LIST_TOP) == *index) {
                                *chosen = menu_nth(list, *index);
                                return key;
                            }
                            unhighlight_item(&f, *index);
                            /* $2796: (word) index of the first entry shown in the list menus */
                            *index = (u16)(i - 1 + LIST_TOP);
                            highlight_item(&f, *index);
                        }
                    }
                }
            } else if (!G_MOUSE_CLICK || prev_key == key) { /* $249E: 1 if the key comes from the mouse (click) */
                *chosen = menu_nth(list, *index);
                return key;
            }
            break;
        }
        prev_key = key;
    }
}

/*
 * PORT H008+$203C: question "Yes No" (starting from No) until the answer is Y
 * or N; returns it.
 */
u8 ask_yes_no(u16 text_len, const char *text, u16 title_pen,
              u16 normal_pen, u16 highlight_pen)
{
    u8 special;                         /* -$1(a5) */
    u8 key;

    H005_B(0x2483) = 2; /* $2483: index of the selected option in the row menus (persistent) */
    do {
        key = ui_request_choice(text_len, text, 6, "Yes No", title_pen,
                                normal_pen, highlight_pen, 0, 0, &special);
    } while (key != 'Y' && key != 'N');
    return key;
}

/* PORT H008+$20C2: list of count empty entries (at least one). */
void menu_alloc(u16 count, CokMenuItem **list)
{
    CokMenuItem *node;
    s16 i;

    *list = (CokMenuItem *)exec_alloc_mem(sizeof(CokMenuItem), COK_MEMF_CLEAR);
    (*list)->next = NULL;
    (*list)->header = 0;
    (*list)->text[0] = 0;
    node = *list;
    for (i = 2; i <= (s16)count; ++i) {
        node->next = (CokMenuItem *)exec_alloc_mem(sizeof(CokMenuItem),
                                                COK_MEMF_CLEAR);
        node = node->next;
        node->next = NULL;
        node->header = 0;
        node->text[0] = 0;
    }
}

/* PORT H008+$2178: frees the list and clears *list. */
void menu_free(CokMenuItem **list)
{
    CokMenuItem *node;
    CokMenuItem *dead;

    if (*list == NULL) {
        return;
    }
    node = *list;
    while (node != NULL) {
        dead = node;
        node = node->next;
        exec_free_mem(dead, sizeof(CokMenuItem));
    }
    *list = NULL;
}
