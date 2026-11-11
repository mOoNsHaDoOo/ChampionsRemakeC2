/* H013: Creazione/gestione personaggi e menu principale del party. */
#include "h013.h"
#include "h008.h"
#include "h026_string.h"
#include "h044_tiles.h"
#include "globals.h"
#include "h010_input.h"
#include "unported.h"
#include "character.h"
#include "h003_exec.h"
#include "h023_shared.h"
#include "h029_gfx.h"
#include "h030.h"
#include "h045.h"
#include "h053.h"
#include "h062.h"
#include "h073.h"
#include "h065.h"
#include "h028_files.h"
#include "h047.h"
#include "h066.h"
#include "h063.h"

/* PORT H013+$0506: link/unlk, nessun effetto. */
void h013_init(void)
{
}

/* H013 -$52(a4): messaggio di "Free training". */
static char s_message[0x52];

/* Voce della tabella del menu principale (-$23A(a5), passo $2C). */
typedef struct MainMenuEntry {
    char text[0x2A];
    u8 enabled;                 /* +$2A */
    u8 pad;
} MainMenuEntry;

enum {
    MM_CREATE, MM_DROP, MM_MODIFY, MM_TRAIN, MM_KNIGHT, MM_VIEW, MM_ADD,
    MM_REMOVE, MM_LOAD, MM_SAVE, MM_BEGIN, MM_EXIT, MM_COUNT
};

/* Copia con dbeq $28: al massimo 41 byte, NUL compreso. */
static void copy_entry(MainMenuEntry *e, const char *text)
{
    unsigned i;

    for (i = 0; i <= 0x28; ++i) {
        e->text[i] = text[i];
        if (text[i] == 0) {
            break;
        }
    }
}

/* PORT H013+$4C0A: testi del menu principale e voci sempre presenti. */
static void init_main_menu(MainMenuEntry *items, char *keys)
{
    unsigned i;
    const char *letters = "C D M T K V A R L S B E J";

    for (i = 0; i <= 0x28; ++i) {
        keys[i] = letters[i];
        if (letters[i] == 0) {
            break;
        }
    }
    copy_entry(&items[MM_CREATE], "Create New Character");
    items[MM_CREATE].enabled = 1;
    copy_entry(&items[MM_DROP], "Drop Character");
    items[MM_DROP].enabled = 0;
    copy_entry(&items[MM_MODIFY], "Modify Character");
    items[MM_MODIFY].enabled = 0;
    copy_entry(&items[MM_TRAIN], "Train Character");
    items[MM_TRAIN].enabled = 0;
    copy_entry(&items[MM_KNIGHT], "Knight Change Classes");
    items[MM_KNIGHT].enabled = 0;
    copy_entry(&items[MM_VIEW], "View Character");
    items[MM_VIEW].enabled = 0;
    copy_entry(&items[MM_ADD], "Add Character to Party");
    items[MM_ADD].enabled = 1;
    copy_entry(&items[MM_REMOVE], "Remove Character from Party");
    items[MM_REMOVE].enabled = 0;
    copy_entry(&items[MM_LOAD], "Load Saved Game");
    items[MM_LOAD].enabled = 1;
    copy_entry(&items[MM_SAVE], "Save Current Game");
    items[MM_SAVE].enabled = 0;
    copy_entry(&items[MM_BEGIN], "BEGIN Adventuring");
    items[MM_BEGIN].enabled = 0;
    copy_entry(&items[MM_EXIT], "Exit to Workbench");
    items[MM_EXIT].enabled = 1;
}

/*
 * PORT H013+$4BFC: menu principale del party.  Ad ogni giro ridisegna la
 * cornice e il personaggio corrente, abilita le voci secondo party e
 * personaggio, mostra il menu (H008+$13C0) ed esegue la funzione scelta
 * (la lettera iniziale della voce).  Esce con "BEGIN Adventuring" (o con
 * la rimozione dell'ultimo personaggio senza un party caricato).
 */
static void copy_text(char *dst, const char *src, u16 max);
static s16 con_hp_bonus(Character *c, u8 cls);

/*
 * PORT H013+$2D76: aggiustamento dei punti ferita per la costituzione
 * (+$19): 3 -2, 4-6 -1, 7-14 0, 15 +1, 16 +2, 17-19 +2 (classi 2, 4, 7:
 * CON - 14).  Per una costituzione fuori da 3..19 l'originale restituisce
 * la parola non inizializzata del frame; qui 0.
 */
static s16 con_hp_adjust(u8 cls)
{
    s16 result = 0;                     /* -$2(a5) */
    u8 con = g_current_char->b[0x19];

    if (con == 3) {
        result = -2;
    } else if (con >= 4 && con <= 6) {
        result = -1;
    } else if (con >= 7 && con <= 14) {
        result = 0;
    } else if (con == 15) {
        result = 1;
    } else if (con == 16) {
        result = 2;
    } else if (con >= 17 && con <= 19) {
        if (cls == 2 || cls == 4 || cls == 7) {
            result = (s16)(con - 14);
        } else {
            result = 2;
        }
    }
    return result;
}

/*
 * PORT H013+$2E44: punti ferita massimi possibili di c (media sulle
 * classi del personaggio).
 */
static s16 max_hit_points(Character *c)
{
    s16 count = 0;                      /* -$2(a5) */
    s16 sum = 0;                        /* -$4(a5) */
    s16 adj;                            /* -$6(a5) */
    s16 extra;                          /* -$a(a5) */
    u8 k;                               /* -$7(a5) */
    u8 lvl;

    for (k = 0; k <= 7; ++k) {
        lvl = c->b[0xFE + k];
        if (lvl == 0) {
            continue;
        }
        adj = con_hp_adjust(k);
        if (lvl < H005_B(0x5026 + k)) {
            ++count;
            switch (k) {
            case 0:
                if (c->b[0x5E] <= 4) {
                    sum = (s16)(sum + (adj + 8) * (lvl + 1));
                } else {
                    sum = (s16)(sum + (adj + 8) * lvl);
                }
                break;
            case 1:
                sum = (s16)(sum + (adj + 8) * lvl);
                break;
            case 2:
            case 3:
                sum = (s16)(sum + (adj + 10) * lvl);
                break;
            case 4:
                sum = (s16)(sum + (adj + 8) * (lvl + 1));
                break;
            case 5:
                sum = (s16)(sum + (adj + 4) * lvl);
                break;
            case 6:
                sum = (s16)(sum + (adj + 6) * lvl);
                break;
            case 7:
                sum = (s16)(sum + (adj + 10) * (lvl + 1));
                break;
            }
        } else {
            ++count;
            extra = (s16)(lvl - H005_B(0x5026 + k) + 1);
            switch (k) {
            case 0:
                sum = (s16)(extra * 2 + 0x48);
                break;
            case 1:
                sum = 0x70;
                break;
            case 2:
            case 3:
            case 7:
                sum = (s16)(extra * 3 + 0x5A);
                break;
            case 4:
                sum = (s16)(extra * 2 + 0x58);
                break;
            case 5:
                sum = (s16)(extra + 0x2C);
                break;
            case 6:
                sum = (s16)(extra * 2 + 0x3C);
                break;
            }
        }
    }
    return (s16)(sum / count);
}

/*
 * PORT H013+$30DA: punti ferita minimi di c: somma dei livelli (+1 per le
 * classi 4 e 7) piu' il bonus di costituzione, diviso il numero di classi.
 */
static s16 min_hit_points(Character *c)
{
    s16 count = 0;                      /* -$2(a5) */
    s16 bonus;                          /* -$4(a5) */
    s16 sum = 0;                        /* -$6(a5) */
    u8 k;                               /* -$7(a5) */

    for (k = 0; k <= 7; ++k) {
        if (c->b[0xFE + k] > 0) {
            sum = (s16)(sum + c->b[0xFE + k]);
            ++count;
            if (k == 4 || k == 7) {
                ++sum;
            }
        }
    }
    bonus = con_hp_bonus(c, k);         /* k = 8 alla fine del ciclo */
    if (bonus < 0) {
        if (sum > (s16)((bonus < 0 ? -bonus : bonus) + count)) {
            sum = (s16)((sum + bonus) / count);
        } else {
            sum = 1;
        }
    } else {
        sum = (s16)((sum + bonus) / count);
    }
    return sum;
}

/* Frame di Modify Character (H013+$31E0) per la procedura annidata. */
typedef struct ModifyFrame {
    u16 field;                          /* -$40(a5): 0-5 caratteristica, 6 nome, 7 PF */
    u16 cursor;                         /* -$4c(a5): posizione nel nome */
    char cell[2];                       /* -$4a(a5): carattere sotto il cursore */
} ModifyFrame;

#define RACE_W(off)  H005_W(0x226C + c->b[0x5B] * 32 + (off))
#define RACE_SW(off) H005_W(0x226C + c->b[0x5B] * 32 + c->b[0x10E] * 2 + (off))
#define CLASS_W(off) H005_W(0x1F9A + c->b[0x5C] * 12 + (off))

/* PORT H013+$31EE: disegna il campo f->field (evidenziato o no). */
static void modify_draw_field(ModifyFrame *f, u8 highlight)
{
    Character *c = g_current_char;

    switch (f->field) {
    case 0: case 1: case 2: case 3: case 4: case 5:
        draw_stat_value((u8)f->field, highlight);
        break;
    case 7:
        draw_hit_points(c, 0x1F, 3, highlight, 0);
        break;
    case 6:
        if (highlight) {
            fill_text_cells((u16)(h026_strlen(0x0F, (const char *)c->b) + 1),
                            1, 0, 1);
            ui_draw_text(1, 1, 0x0D, 0, 0x0F, (const char *)c->b);
            if (c->b[f->cursor] == ' ') {
                ui_draw_text((u16)(f->cursor + 1), 1, 0x0F, 0, 1, "_");
            } else {
                f->cell[1] = 0;
                f->cell[0] = (char)c->b[f->cursor];
                ui_draw_text((u16)(f->cursor + 1), 1, 0x0F, 0, 1, f->cell);
            }
        } else {
            ui_draw_text(1, 1, 0x0A, 0, 0x0F, (const char *)c->b);
        }
        break;
    default:
        break;
    }
}

/* Riporta caratteristiche, punti ferita e nome ai valori salvati. */
static void modify_restore(Character *c, const u16 *stats, u16 ext_str,
                           u16 hp, const char *name, u8 hp_first)
{
    u8 i;

    for (i = 0; i <= 5; ++i) {
        g_current_char->b[0x11 + i * 2] = (u8)stats[i];
    }
    g_current_char->b[0x1C] = (u8)ext_str;
    g_current_char->b[0x64] = (u8)hp;
    if (hp_first) {
        g_current_char->b[0x1A8] = c->b[0x64];
    }
    h026_copy(0x0F, (char *)g_current_char->b, 0x28, name);
    if (!hp_first) {
        g_current_char->b[0x1A8] = c->b[0x64];
    }
    recompute_stats(g_current_char);
    H005_B(0x24DA) = 0;
}

/*
 * PORT H013+$31E0: Modify Character.  Solo per personaggi appena creati
 * (esperienza iniziale, +$DC = 0).  Con Add/Subtract si cambiano le
 * caratteristiche (entro i limiti di razza e classe), i punti ferita
 * (entro $30DA..$2E44) e il nome; Keep conferma, Exit o Esc ripristinano.
 */
static void modify_character(void)
{
    ModifyFrame f;
    Character *c;                       /* a3 */
    u16 saved_stats[6];                 /* -$c(a5) */
    u16 saved_ext;                      /* -$e(a5) */
    u16 saved_hp;                       /* -$10(a5), poi somma */
    s16 sum;                            /* -$10(a5) */
    s16 count;                          /* -$4e(a5) */
    char saved_name[0x2A];              /* -$3a(a5) */
    u8 idx;                             /* -$3c(a5) */
    u8 k;                               /* -$3b(a5) */
    u8 key;                             /* -$3d(a5) */
    u8 special;                         /* -$3e(a5) */
    u32 xp;

    if (!pick_character()) {
        return;
    }
    xp = CH_L(g_current_char, 0x11E);
    if (!(xp == 0x5DC || xp == 0x4E3 || xp == 0x7D0 || xp == 0x7D1 ||
          xp == 0x8CB || xp == 0x9C4 || xp == 0x1388) ||
        g_current_char->b[0xDC] != 0) {
        h026_copy(0x50, s_message, 0x0F, (const char *)g_current_char->b);
        h026_append(0x50, s_message, 0x13, " can't be modified.");
        show_message(0x50, s_message, 0x0E, 0);
        return;
    }
    H005_SET_W(0x2506, 0xFF);
    H005_B(0x24DA) = 1;
    draw_character_sheet();
    for (idx = 0; idx <= 5; ++idx) {
        saved_stats[idx] = g_current_char->b[0x11 + idx * 2];
    }
    saved_ext = g_current_char->b[0x1C];
    saved_hp = g_current_char->b[0x64];
    h026_copy(0x28, saved_name, 0x0F, (const char *)g_current_char->b);
    f.cursor = 0;
    f.field = 7;
    modify_draw_field(&f, 0);
    f.field = 0;
    modify_draw_field(&f, 1);
    c = g_current_char;
    for (;;) {
        if (f.field == 6) {
            special = 0;
            wait_for_key();
            key = G_KEY;
            if (key > '0' && key <= '9') {
                key = H005_B(0x4F7C + key - '1');
                special = 1;
            }
            if (key == 0) {
                wait_for_key();
                key = G_KEY;
                special = 1;
            }
            if (key == 0x1B) {
                key = 0;
            }
        } else {
            key = ui_request_choice(8, "Modify: ", 0x16,
                                    "Add Subtract Keep Exit", 0x0D, 0x0A,
                                    0x0F, 1, 0, &special);
        }
        modify_draw_field(&f, 0);
        if (special) {
            switch (key) {
            case 'S':                   /* $35C2 */
                if (f.field == 6 &&
                    h026_strlen(0x0F, (const char *)g_current_char->b) > 0) {
                    h026_delete(0x0F, (char *)g_current_char->b, f.cursor, 1);
                }
                break;
            case 'P':                   /* $3606 */
                ++f.field;
                if (f.field > 7) {
                    f.field = 0;
                }
                break;
            case 'H':                   /* $361A */
                if (f.field == 0) {
                    f.field = 7;
                } else {
                    --f.field;
                }
                break;
            case 'G':                   /* $3632 */
                if (H005_B(0x249E) && H005_W(0x2506) != 0xFF) {
                    f.field = H005_W(0x2506);
                }
                break;
            default:
                break;
            }
        } else {
            switch (key) {
            case 'S':                   /* $3698: Subtract */
                if (f.field < 6) {
                    idx = (u8)f.field;
                    add_to_byte(&c->b[0x11 + idx * 2], 0xFFFF);
                    switch (idx) {
                    case 0:             /* $36D2 */
                        if (c->b[0x1C] > 0) {
                            add_to_byte(&c->b[0x1C], 0xFFFF);
                            add_to_byte(&c->b[0x11 + idx * 2], 1);
                        } else {
                            if (c->b[0x11] < RACE_SW(0)) {
                                c->b[0x11] = (u8)RACE_SW(0);
                            }
                            if (c->b[0x11] < CLASS_W(0)) {
                                c->b[0x11] = (u8)CLASS_W(0);
                            }
                        }
                        break;
                    case 1:             /* $37C4 */
                        if (c->b[0x13] < RACE_W(0x0C)) {
                            c->b[0x13] = (u8)RACE_W(0x0C);
                        }
                        if (c->b[0x13] < CLASS_W(2)) {
                            c->b[0x13] = (u8)CLASS_W(2);
                        }
                        break;
                    case 2:             /* $385E */
                        if (c->b[0x15] < RACE_W(0x10)) {
                            c->b[0x15] = (u8)RACE_W(0x10);
                        }
                        if (c->b[0x15] < CLASS_W(4)) {
                            c->b[0x15] = (u8)CLASS_W(4);
                        }
                        if (c->b[0x124] > 0) {
                            c->b[0x124] = 1;
                        }
                        break;
                    case 3:             /* $390A */
                        if (c->b[0x17] < RACE_W(0x14)) {
                            c->b[0x17] = (u8)RACE_W(0x14);
                        }
                        if (c->b[0x17] < CLASS_W(6)) {
                            c->b[0x17] = (u8)CLASS_W(6);
                        }
                        break;
                    case 4:             /* $39A4 */
                        if (c->b[0x19] < RACE_W(0x18)) {
                            c->b[0x19] = (u8)RACE_W(0x18);
                        }
                        if (c->b[0x19] < CLASS_W(8)) {
                            c->b[0x19] = (u8)CLASS_W(8);
                        }
                        if (c->b[0x64] > (u16)max_hit_points(g_current_char)) {
                            c->b[0x64] = (u8)max_hit_points(g_current_char);
                        }
                        c->b[0x1A8] = c->b[0x64];
                        f.field = 6;
                        modify_draw_field(&f, 0);
                        f.field = 4;
                        break;
                    case 5:             /* $3A8E */
                        if (c->b[0x1B] < RACE_W(0x1C)) {
                            c->b[0x1B] = (u8)RACE_W(0x1C);
                        }
                        if (c->b[0x1B] < CLASS_W(0x0A)) {
                            c->b[0x1B] = (u8)CLASS_W(0x0A);
                        }
                        break;
                    }
                } else if (f.field == 7) {
                    add_to_byte(&c->b[0x64], 0xFFFF);
                    if (c->b[0x64] < (u16)min_hit_points(g_current_char)) {
                        c->b[0x64] = (u8)min_hit_points(g_current_char);
                    }
                    c->b[0x1A8] = c->b[0x64];
                } else if (f.cursor == 0) {
                    f.cursor = (u16)(h026_strlen(0x0F,
                                     (const char *)g_current_char->b) - 1);
                } else {
                    --f.cursor;
                }
                break;
            case 'A':                   /* $3BD8: Add */
                if (f.field < 6) {
                    idx = (u8)f.field;
                    add_to_byte(&c->b[0x11 + idx * 2], 1);
                    switch (idx) {
                    case 0:             /* $3C12 */
                        if (c->b[0x11] > RACE_SW(4)) {
                            if (c->b[0x11] > 0x12 &&
                                (c->b[0x100] > 0 || c->b[0x105] > 0 ||
                                 c->b[0x102] > 0) &&
                                c->b[0x1C] < RACE_SW(8)) {
                                add_to_byte(&c->b[0x1C], 1);
                            }
                            c->b[0x11] = (u8)RACE_SW(4);
                        }
                        break;
                    case 1:             /* $3CE2 */
                        if (c->b[0x13] > RACE_W(0x0E)) {
                            c->b[0x13] = (u8)RACE_W(0x0E);
                        }
                        break;
                    case 2:             /* $3D2E */
                        if (c->b[0x15] > RACE_W(0x12)) {
                            c->b[0x15] = (u8)RACE_W(0x12);
                        }
                        if (c->b[0x124] > 0) {
                            c->b[0x124] = 1;
                        }
                        break;
                    case 3:             /* $3D8C */
                        if (c->b[0x17] > RACE_W(0x16)) {
                            c->b[0x17] = (u8)RACE_W(0x16);
                        }
                        break;
                    case 4:             /* $3DD8 */
                        if (c->b[0x19] > RACE_W(0x1A)) {
                            c->b[0x19] = (u8)RACE_W(0x1A);
                        }
                        if (c->b[0x64] < (u16)min_hit_points(g_current_char)) {
                            c->b[0x64] = (u8)min_hit_points(g_current_char);
                        }
                        c->b[0x1A8] = c->b[0x64];
                        f.field = 6;
                        modify_draw_field(&f, 0);
                        f.field = 4;
                        break;
                    case 5:             /* $3E74 */
                        if (c->b[0x1B] > RACE_W(0x1E)) {
                            c->b[0x1B] = (u8)RACE_W(0x1E);
                        }
                        break;
                    }
                } else if (f.field == 7) {
                    add_to_byte(&c->b[0x64], 1);
                    if (c->b[0x64] > (u16)max_hit_points(g_current_char)) {
                        c->b[0x64] = (u8)max_hit_points(g_current_char);
                    }
                    c->b[0x1A8] = c->b[0x64];
                } else if (f.cursor == (u16)(h026_strlen(0x0F,
                               (const char *)g_current_char->b) - 1)) {
                    f.cursor = 0;
                } else {
                    ++f.cursor;
                }
                break;
            case '\r':                  /* $3F72 */
                ++f.field;
                if (f.field > 7) {
                    f.field = 0;
                }
                break;
            case 0x08:                  /* $3F86 */
                if (f.field == 6 && f.cursor > 0) {
                    h026_delete(0x0F, (char *)g_current_char->b,
                                (u16)(f.cursor - 1), 1);
                    --f.cursor;
                    if (f.cursor > h026_strlen(0x0F,
                                               (const char *)g_current_char->b)) {
                        f.cursor = h026_strlen(0x0F,
                                               (const char *)g_current_char->b);
                    }
                }
                break;
            case 0:                     /* $3FF6 */
                modify_restore(c, saved_stats, saved_ext, saved_hp,
                               saved_name, 0);
                return;
            default:                    /* $4090 */
                if (f.field == 6) {
                    if (f.cursor < 0x0F && key >= 0x20 && key <= 0x7A) {
                        g_current_char->b[f.cursor] = key;
                        ++f.cursor;
                    }
                } else if (key == 'E') {
                    modify_restore(c, saved_stats, saved_ext, saved_hp,
                                   saved_name, 1);
                    return;
                }
                break;
            }
        }
        recompute_stats(g_current_char);
        draw_combat_values();
        modify_draw_field(&f, 1);
        if (!special && key == 'K') {
            break;
        }
    }
    cleric_spell_slots(g_current_char);
    c = g_current_char;
    c->b[0xED] = 1;
    sum = 0;
    count = 0;
    for (k = 0; k <= 7; ++k) {
        if (c->b[0xFE + k] > 0) {
            if (c->b[0xFE + k] < H005_B(0x5026 + k)) {
                if (k == 4) {
                    sum = (s16)(sum + con_hp_adjust(k) * (c->b[0xFE + k] + 1));
                } else {
                    sum = (s16)(sum + con_hp_adjust(k) * c->b[0xFE + k]);
                }
            } else {
                sum = (s16)(sum + (H005_B(0x5026 + k) - 1) * con_hp_adjust(k));
            }
            ++count;
        }
    }
    sum = (s16)(sum / count);
    c->b[0x123] = (u8)(c->b[0x64] - sum);
    for (idx = 0; idx <= 5; ++idx) {
        g_current_char->b[0x10 + idx * 2] = g_current_char->b[0x11 + idx * 2];
    }
    g_current_char->b[0x1D] = g_current_char->b[0x1C];
    H005_B(0x24DA) = 0;
    (void)saved_hp;
}

/*
 * PORT H013+$43E8: promuove c all'ordine di cavalleria successivo (+$5D):
 * il livello da cavaliere (+$105) cala di 1 se l'esperienza non basta,
 * e i punti ferita di quel livello (+$123 / (livello + 1) piu' il bonus di
 * costituzione) vengono tolti.
 */
static void promote_knight(Character *c)
{
    u8 level = c->b[0x105];             /* -$1(a5) */
    u8 order;                           /* -$2(a5) */
    u16 part;                           /* -$4(a5) */
    s16 adj;                            /* -$6(a5) */

    if (c->b[0x5D] == 1) {
        order = 4;
    } else {
        order = 5;
    }
    if ((s32)CH_L(c, 0x11E) <
        (s32)H005_L(0x1946 + order * 0x9A + (level - 2) * 4)) {
        add_to_byte(&c->b[0x105], 0xFFFF);
    }
    part = (u16)(c->b[0x123] / (u16)(level + 1));
    add_to_byte(&c->b[0x123], (u16)-(s16)part);
    adj = con_hp_adjust(7);
    add_to_byte(&c->b[0x64], (u16)-(s16)(part + adj));
    if (c->b[0x1A8] >= c->b[0x64]) {
        c->b[0x1A8] = c->b[0x64];
    }
    add_to_byte(&c->b[0x5D], 1);
    level_derived_values(c);
}

/* Riga "nome + testo" centrata a col nella riga 9. */
static void knight_line(Character *c, u16 col, u16 len, const char *text)
{
    h026_copy(0x50, s_message, 0x0F, (const char *)c->b);
    h026_append(0x50, s_message, len, text);
    ui_draw_text(col, 9, 0x0A, 0, 0x50, s_message);
}

/*
 * PORT H013+$4508: Knight Change Classes: un cavaliere della Corona
 * (+$5D = 1) puo' diventare della Spada, uno della Spada (2) della Rosa,
 * se ha livello ed esperienza sufficienti e le caratteristiche minime.
 */
static void knight_change(void)
{
    static const u16 sword_min[6] = { 0x0C, 9, 0x0D, 9, 0x0A, 3 };   /* -$2a(a5) */
    static const u16 rose_min[6] = { 0x0F, 0x0A, 0x0D, 0x0C, 0x0F, 3 }; /* -$36(a5) */
    Character *c;                       /* -$1e(a5), a3 */
    char options[0x0E];                 /* -$12(a5) */
    char order[6];                      /* -$6(a5) */
    u16 col;                            /* -$1a(a5) */
    u8 done;                            /* -$16(a5) */
    u8 key;                             /* -$15(a5) */
    u8 ok;                              /* -$14(a5) */
    u8 i;                               /* -$13(a5) */
    u8 special;                         /* -$17(a5) */
    u16 len;

    if (!pick_character()) {
        return;
    }
    c = g_current_char;
    draw_screen_frame(1);
    if (c->b[0x105] == 0 || c->b[0x5D] == 3) {
        return;
    }
    done = 0;
    copy_text(options, "Exit", 0x0B);
    len = h026_strlen(0x0F, (const char *)c->b);
    col = (u16)(0x13 - (len >> 1));
    ui_draw_text(col, 3, 0x0A, 0, 0x0F, (const char *)c->b);
    ui_draw_text(7, 5, 0x0A, 0, 0x1A, "is petitioning to become a");
    /*
     * Con +$5D diverso da 1 e 2 l'originale usa la stringa non
     * inizializzata del frame; qui e' vuota.
     */
    order[0] = 0;
    if (c->b[0x5D] == 1) {
        copy_text(order, "sword", 5);
    } else if (c->b[0x5D] == 2) {
        copy_text(order, "rose", 5);
    }
    copy_text(s_message, "Knight Of The ", 0x50);
    h026_append(0x50, s_message, 5, order);
    ui_draw_text(0x0A, 7, 0x0A, 0, 0x50, s_message);
    if (c->b[0x5D] == 1) {                         /* $46C6 */
        col = (u16)(0x13 - ((u16)(h026_strlen(0x0F, (const char *)c->b) +
                                  0x15) >> 1));
        if (c->b[0x105] < 2 ||
            (s32)CH_L(c, 0x11E) < (s32)H005_L(0x1BAE)) {
            knight_line(c, col, 0x16, " is too inExperienced.");
        } else {
            col = (u16)(0x13 - ((u16)(h026_strlen(0x0F,
                                     (const char *)c->b) + 0x12) >> 1));
            ok = 1;
            for (i = 0; i <= 5; ++i) {
                if (c->b[0x10 + i * 2] < sword_min[i]) {
                    ok = 0;
                }
            }
            if (!ok) {
                knight_line(c, col, 0x12, " does not qualify.");
            } else {
                col = (u16)(0x13 - ((u16)(h026_strlen(0x0F,
                                         (const char *)c->b) + 0x0D) >> 1));
                knight_line(c, col, 0x0D, " may become a");
                ui_draw_text(0x0A, 0x0B, 0x0A, 0, 0x13, "Knight Of The Sword");
                copy_text(options, "Change Exit", 0x0B);
            }
        }
    } else if (c->b[0x5D] == 2) {                  /* $48CC */
        col = (u16)(0x14 - ((u16)(h026_strlen(0x0F, (const char *)c->b) +
                                  0x15) >> 1));
        if (c->b[0x105] < 4 ||
            (s32)CH_L(c, 0x11E) < (s32)H005_L(0x1C50)) {
            knight_line(c, col, 0x15, " is too inexperienced");
        } else {
            col = (u16)(0x14 - ((u16)(h026_strlen(0x0F,
                                     (const char *)c->b) + 0x12) >> 1));
            ok = 1;
            for (i = 0; i <= 5; ++i) {
                if (c->b[0x10 + i * 2] < rose_min[i]) {
                    ok = 0;
                }
            }
            if (!ok) {
                knight_line(c, col, 0x12, " does not qualify.");
            } else {
                col = (u16)(0x13 - ((u16)(h026_strlen(0x0F,
                                         (const char *)c->b) + 0x0D) >> 1));
                knight_line(c, col, 0x0D, " may become a");
                ui_draw_text(0x0A, 0x0B, 0x0A, 0, 0x12, "Knight Of The Rose");
                copy_text(options, "Change Exit", 0x0B);
            }
        }
    }
    do {
        key = ui_request_choice(0, "", 0x0B, options, 0x0D, 0x0A, 0x0F, 0, 0,
                                &special);
        switch (key) {
        case 'C':
            promote_knight(c);
            done = 1;
            break;
        case 0:
        case 'E':
            done = 1;
            break;
        default:
            break;
        }
    } while (!done);
}

/*
 * PORT H013+$2B9A: Drop Character: sceglie il personaggio e, confermato
 * due volte, ne cancella i file e lo toglie dal party.
 */
static void drop_character(void)
{
    Character *c;                       /* a3 */

    if (!pick_character()) {
        return;
    }
    if (g_current_char != NULL) {
        c = g_current_char;
        copy_text(s_message, "Drop ", 0x50);
        h026_append(0x50, s_message, 0x0F, (const char *)c->b);
        h026_append(0x50, s_message, 9, " forever?");
        if (ask_yes_no(0x50, s_message, 0x0E, 0x0A, 0x0F) == 'Y' &&
            ask_yes_no(0x0E, "Are you sure? ", 0x0E, 0x0A, 0x0F) == 'Y') {
            if (!c->b[0x198]) {
                copy_text(s_message, "You dump ", 0x50);
                h026_append(0x50, s_message, 0x0F, (const char *)c->b);
                h026_append(0x50, s_message, 0x0A, " out back.");
                show_message_line(0x50, s_message);
            } else {
                h026_copy(0x50, s_message, 0x0F, (const char *)c->b);
                h026_append(0x50, s_message, 0x13, " bids you farewell.");
                show_message_line(0x50, s_message);
            }
            delete_character_files(g_current_char);
            remove_from_party(0, 1);
        } else {
            h026_copy(0x50, s_message, 0x0F, (const char *)c->b);
            h026_append(0x50, s_message, 0x1B,
                        " breathes a sigh of relief.");
            show_message_line(0x50, s_message);
        }
    }
    draw_party(g_current_char);
}

void main_menu(void)
{
    MainMenuEntry items[MM_COUNT];      /* -$23A(a5) */
    char keys[0x2A];                    /* -$2A(a5) */
    CokMenuItem *list = NULL;              /* -$250(a5) */
    CokMenuItem *node;                     /* -$25C(a5) */
    CokMenuItem *chosen = NULL;            /* -$258(a5) */
    u16 index;                          /* -$262(a5) */
    u16 count;                          /* -$248(a5) */
    u16 i;                              /* -$23C(a5) */
    u8 saved_context;                   /* -$24A(a5) */
    u8 rebuild;                         /* -$249(a5) */
    u8 redraw;                          /* -$23F(a5) */
    u8 key;                             /* -$23D(a5) */

    init_main_menu(items, keys);
    H005_B(0x24A2) = 0;
    saved_context = H005_B(0x3DE3);
    H005_B(0x3DE3) = 0;
    rebuild = 1;
    H005_B(0x24DE) = 0;
    index = 0;

    for (;;) {
        if (rebuild) {
            draw_screen_frame(1);
            if (g_current_char != NULL) {
                draw_party(g_current_char);
                items[MM_DROP].enabled = 1;
                items[MM_MODIFY].enabled = 1;
                items[MM_TRAIN].enabled =
                    (u8)(COK_GET16(g_state_b + 0x550) > 0 || H005_B(0x24DE));
                items[MM_KNIGHT].enabled = items[MM_TRAIN].enabled;
                items[MM_VIEW].enabled = 1;
                items[MM_REMOVE].enabled = 1;
                items[MM_LOAD].enabled = 0;
                items[MM_SAVE].enabled = 1;
                items[MM_BEGIN].enabled = 1;
            } else {
                items[MM_DROP].enabled = 0;
                items[MM_MODIFY].enabled = 0;
                items[MM_TRAIN].enabled = 0;
                items[MM_KNIGHT].enabled = 0;
                items[MM_VIEW].enabled = 0;
                items[MM_REMOVE].enabled = 0;
                items[MM_LOAD].enabled = 1;
                items[MM_SAVE].enabled = 0;
                items[MM_BEGIN].enabled = 0;
            }
            count = 0;
            for (i = 0; i <= 0x0B; ++i) {
                if (items[i].enabled) {
                    ++count;
                }
            }
            menu_alloc(count, &list);
            node = list;
            for (i = 0; i <= 0x0B; ++i) {
                if (items[i].enabled) {
                    memcpy(node->text, items[i].text, 0x2A);
                    node = node->next;
                }
            }
        }
        redraw = 1;
        (void)list_menu(0x12, "Choose a function ", 7, "Select ", 0x0D, 0x0A,
                        0x0F, 9, 0x0C, 0x26, 0x16, list, 0, &redraw, &index,
                        &chosen);
        /*
         * La funzione e' la lettera iniziale della voce scelta.  Con Esc
         * (voce nulla) l'originale legge il byte all'indirizzo 0; qui 0.
         */
        key = chosen != NULL ? (u8)chosen->text[0] : 0;
        if (rebuild) {
            menu_free(&list);
        }
        if (key != 'S' && key != 'E') {
            H005_B(0x24A3) = 0;
        }
        switch (key) {
        case 'C':
            if (items[MM_CREATE].enabled) {
                create_character();
            }
            break;
        case 'D':
            if (items[MM_DROP].enabled) {
                drop_character();
            }
            break;
        case 'M':
            if (items[MM_MODIFY].enabled) {
                modify_character();
            }
            break;
        case 'T':
            if (items[MM_TRAIN].enabled) {
                train_character();
            }
            break;
        case 'K':
            if (items[MM_KNIGHT].enabled) {
                knight_change();
            }
            break;
        case 'V':
            if (items[MM_VIEW].enabled && pick_character()) {
                view_character(&redraw);
            }
            break;
        case 'A':
            if (items[MM_ADD].enabled) {
                add_character_to_party();
            }
            break;
        case 'R':
            if (items[MM_REMOVE].enabled && g_current_char != NULL &&
                pick_character()) {
                if (g_current_char->b[0xEC] < 0x80) {
                    save_character(g_current_char, 0, "");
                    remove_from_party(0, 1);
                } else {
                    drop_character();
                }
                if (g_current_char == NULL && !H005_B(0x249C)) {
                    H005_B(0x24D0) = 1;
                    return;
                }
            }
            break;
        case 'L':
            if (items[MM_LOAD].enabled) {
                load_game();
            }
            break;
        case 'S':
            if (items[MM_SAVE].enabled && g_party_head != NULL) {
                save_game();
            }
            break;
        case 'B':
            if (items[MM_BEGIN].enabled) {
                H005_B(0x24A2) = 1;
                if (g_party_head != NULL || G_DEMO_FLAG) {
                    H005_B(0x3DE3) = saved_context;
                    if (!H005_B(0x24D1) && H005_B(0x2486) != 9) {
                        if (H005_B(0x3DE3) == 3 &&
                            COK_GET16(g_state_a + 0x270) == 0) {
                            draw_wild_frame();
                        } else {
                            draw_explore_frame();
                        }
                        draw_party(g_current_char);
                    } else if (COK_GET16(g_state_a + 0x1E4) == 0 ||
                               COK_GET16(g_state_a + 0x270) != 0) {
                        draw_explore_frame();
                        draw_party(g_current_char);
                    }
                    clear_message_line();
                    COK_PUT16(g_state_b + 0x550, 0);
                    free_char_screens();
                    return;
                }
            }
            break;
        case 'E':
            if (items[MM_EXIT].enabled) {
                key = ask_yes_no(0x12, "Quit to workbench ", 0x0E, 0x0A, 0x0F);
                if (key == 'Y') {
                    if (g_party_head != NULL && !H005_B(0x24A3)) {
                        key = ask_yes_no(0x1E, "Game not saved.  Quit anyway? ",
                                         0x0E, 0x0A, 0x0F);
                        if (key == 'N') {
                            save_game();
                        }
                    }
                    if (key == 'Y') {
                        menu_free(&list);
                        h043_0840();
                        quit_game();
                    }
                }
            }
            break;
        case 'J':
            /*
             * Trucco: se il terzo argomento della riga di comando e' la
             * parola di H005+$2358, attiva/disattiva "Free training".
             * L'originale legge argv[2] in ogni caso; qui solo se esiste.
             */
            if (g_argc > 2 &&
                h026_compare_nocase(0xFF, g_argv[2], 0x14,
                                    (const char *)&g_h005[0x2358]) == 1) {
                H005_B(0x24DE) = (u8)(H005_B(0x24DE) == 0);
                h026_copy(0x50, s_message, 0x0E, "Free training ");
                if (H005_B(0x24DE)) {
                    h026_append(0x50, s_message, 2, "on");
                } else {
                    h026_append(0x50, s_message, 3, "off");
                }
                show_message_line(0x50, s_message);
            }
            break;
        default:
            break;
        }
    }
}

/* Copia con dbeq: al massimo max + 1 byte, NUL compreso. */
static void copy_text(char *dst, const char *src, u16 max)
{
    u16 i;

    for (i = 0; i <= max; ++i) {
        dst[i] = src[i];
        if (src[i] == 0) {
            break;
        }
    }
}

/*
 * PORT H013+$56CE (trampolino H013+$0520): bonus ai punti ferita per la
 * costituzione (+$19) dalla tabella H005+$1F4A; le classi 2, 4 e 7 hanno
 * un bonus in piu' oltre 16.
 */
static s16 con_hp_bonus(Character *c, u8 cls)
{
    s16 bonus = 0;

    bonus = (s16)(bonus + (s16)H005_W((u16)(0x1F4A +
                                            ((s16)c->b[0x19] - 3) * 2)));
    if (cls == 2 || cls == 7 || cls == 4) {
        switch (c->b[0x19]) {
        case 17:
            bonus += 1;
            break;
        case 18:
            bonus += 2;
            break;
        case 19: case 20:
            bonus += 3;
            break;
        case 21: case 22: case 23:
            bonus += 4;
            break;
        case 24: case 25:
            bonus += 5;
            break;
        default:
            break;
        }
    }
    return bonus;
}

/*
 * PORT H013+$0524: punti ferita iniziali.  Per ogni classe del personaggio
 * selezionata da mask (H005+$5038): sotto il livello massimo dei dadi
 * (H005+$5026) il migliore di due tiri e il bonus di costituzione, sopra un
 * valore fisso (assegnato, non sommato, come nell'originale).  Il totale e
 * il bonus sono divisi per il numero di classi; +$123 riceve i dadi, +$64
 * dadi e bonus, +$1A8 conserva la differenza con +$64.
 */
static void roll_hit_points(Character *c, u16 mask, u16 nclasses)
{
    static const u16 dice[8] = { 2, 1, 1, 1, 2, 1, 1, 2 };     /* -$1C */
    static const u16 sides[8] = { 8, 8, 10, 10, 8, 4, 6, 10 }; /* -$2C */
    s16 hp = 0;                         /* -$6(a5) */
    s16 bonus = 0;                      /* -$a(a5) */
    s16 n = 0;                          /* -$8(a5) */
    s16 r1;                             /* -$2(a5) */
    s16 r2;                             /* -$4(a5) */
    s16 diff;
    u8 k;                               /* -$b(a5) */

    for (k = 0; k <= 7; ++k) {
        if (c->b[0xFE + k] == 0 ||
            mask_byte((u8)mask, H005_B(0x5038 + k)) == 0) {
            continue;
        }
        if (c->b[0xFE + k] < H005_B(0x5026 + k)) {
            if (c->b[0xFE + k] > 1) {
                n = 1;
            } else if (k == 0 && c->b[0x5E] > 4) {
                n = 1;
            } else {
                n = (s16)dice[k];
            }
            r1 = (s16)roll_dice((u16)n, sides[k]);
            r2 = (s16)roll_dice((u16)n, sides[k]);
            if (r2 > r1) {
                r1 = r2;
            }
            hp = (s16)(hp + r1);
            bonus = (s16)(bonus + con_hp_bonus(c, k) * n);
        } else {
            switch (k) {
            case 2: case 7:
                hp = 3;
                break;
            case 0: case 4: case 6:
                hp = 2;
                break;
            case 5:
                hp = 1;
                break;
            default:
                break;
            }
        }
    }
    hp = (s16)(hp / (s16)nclasses);
    if (hp < 1) {
        hp = 1;
    }
    add_to_byte(&c->b[0x123], (u16)hp);
    bonus = (s16)(bonus / (s16)nclasses);
    diff = (s16)(c->b[0x64] - c->b[0x1A8]);
    add_to_byte(&c->b[0x64], (u16)(hp + bonus));
    c->b[0x1A8] = (u8)(c->b[0x64] - diff);
}

/*
 * PORT H013+$07B2: tre oggetti iniziali ($48 byte) inseriti dopo il primo
 * della lista +$150; +$14F = 3.
 */
static void add_starting_items(Character *c)
{
    u16 i;                              /* -$6(a5) */

    for (i = 1; i <= 3; ++i) {
        CokItem *it = (CokItem *)exec_alloc_mem(sizeof(CokItem),
                                                COK_MEMF_CLEAR);

        it->next = NULL;
        it->b[0x2A] = 0;
        it->b[0x3A] = 0;
        it->b[0x3C] = 0;
        switch (i) {
        case 1:
            it->b[0x30] = 0x24;
            it->b[0x34] = 0x24;
            it->b[0x33] = 0x2F;
            COK_PUT16(it->b + 0x3E, 0x1C2);
            COK_PUT16(it->b + 0x42, 0);
            break;
        case 2:
            it->b[0x30] = 0x12;
            it->b[0x34] = 0x12;
            COK_PUT16(it->b + 0x3E, 0x32);
            COK_PUT16(it->b + 0x42, 0);
            break;
        case 3:
            it->b[0x30] = 0x25;
            it->b[0x34] = 0x25;
            COK_PUT16(it->b + 0x3E, 0x3C);
            COK_PUT16(it->b + 0x42, 0);
            break;
        default:
            break;
        }
        if (c->items == NULL) {
            c->items = it;
        } else {
            it->next = c->items->next;
            c->items->next = it;
        }
    }
    c->b[0x14F] = 3;
}

/*
 * PORT H013+$08C2 (corpo a H013+$097C): figura predefinita del personaggio
 * corrente: +$141 secondo razza, sesso e +$10E, +$142 secondo la classe.
 */
static void set_default_figure(void)
{
    Character *c = g_current_char;

    if (c->b[0x5B] == 5) {
        c->b[0x141] = 3;
    } else if (c->b[0x10E] == 1) {
        if (c->b[0x144] == 2) {
            c->b[0x141] = 9;
        } else {
            c->b[0x141] = 7;
        }
    } else if (c->b[0x144] == 2) {
        c->b[0x141] = 5;
    }
    if (c->b[0xFE] > 0) {
        c->b[0x142] = 0x17;
    } else if (c->b[0x102] > 0) {
        c->b[0x142] = 1;
    } else if (c->b[0x105] > 0 || c->b[0x100] > 0) {
        c->b[0x142] = 0x18;
    } else if (c->b[0x103] > 0) {
        c->b[0x142] = 0x1D;
    } else {
        c->b[0x142] = 5;
    }
}

/*
 * PORT H013+$0990: procedura annidata di Create_Character: eta' massima
 * della razza per la riga cls della tabella H005+$20AC ($30 byte per
 * razza, 6 per riga): base + dadi * facce.
 */
static u16 max_age(u8 race, u8 cls)
{
    u16 row = (u16)(0x20AC + race * 0x30 + cls * 6);

    return (u16)(H005_W(row + 4) * H005_W(row + 2) + H005_W(row));
}

/* Menu a elenco di Create_Character (H008+$13C0), con gli stessi argomenti. */
static u8 create_menu(CokMenuItem *list, u8 with_exit, u8 *redraw, u16 *index,
                      CokMenuItem **chosen)
{
    return list_menu(0, "", 6, "Select", 0x0D, 0x0A, 0x0F, 1, 2, 0x26, 0x16,
                     list, with_exit, redraw, index, chosen);
}

/* Limiti di eta' della razza (H005+$2066, 5 word per razza). */
static u16 age_limit(const Character *c, u16 n)
{
    return H005_W(0x2066 + c->b[0x5B] * 0x0A + n * 2);
}

/* Limiti delle caratteristiche della razza (H005+$226C, $20 byte). */
static u16 race_limit(const Character *c, u16 off)
{
    return H005_W(0x226C + c->b[0x5B] * 0x20 + off);
}

/* Minimo della classe per la caratteristica s (H005+$1F9A, 12 byte). */
static u16 class_min(const Character *c, u8 s)
{
    return H005_W(0x1F9A + c->b[0x5C] * 0x0C + s * 2);
}

/* Riporta *v tra il minimo e il massimo della razza e il minimo di classe. */
static void clamp_stat(Character *c, u8 s, u8 *v, u16 min_off, u16 max_off)
{
    if (*v < race_limit(c, min_off)) {
        *v = (u8)race_limit(c, min_off);
    }
    if (*v > race_limit(c, max_off)) {
        *v = (u8)race_limit(c, max_off);
    }
    if (*v < class_min(c, s)) {
        *v = (u8)class_min(c, s);
    }
}

/*
 * Procedure annidate H013+$1B2E, $1E28, $1F98, $21DA, $234A, $24F4:
 * correzioni per eta' (+$62) e limiti di razza/sesso/classe della
 * caratteristica s appena tirata (+$11 + 2s).
 */
static void adjust_stat(Character *c, u8 s)
{
    u8 *v = &c->b[0x11 + s * 2];
    u16 age = CH_W(c, 0x62);
    u16 g = (u16)(c->b[0x10E] * 2);

    switch (s) {
    case 0:                     /* H013+$1B2E: forza */
        if (*v > 0 && age > age_limit(c, 0)) {
            add_to_byte(v, 1);
        }
        if (*v > 0 && age > age_limit(c, 1)) {
            add_to_byte(v, 0xFFFF);
        }
        if (*v > 0 && age > age_limit(c, 2)) {
            add_to_byte(v, 0xFFFE);
        }
        if (*v > 0 && age > age_limit(c, 3)) {
            add_to_byte(v, 0xFFFF);
        }
        clamp_stat(c, s, v, g, (u16)(4 + g));
        if (c->b[0x11] == 18 &&
            (c->b[0x100] > 0 || c->b[0x102] > 0 || c->b[0x105] > 0)) {
            c->b[0x1C] = (u8)(random_below(0x64) + 1);
            if (c->b[0x1C] > race_limit(c, (u16)(8 + g))) {
                c->b[0x1C] = (u8)race_limit(c, (u16)(8 + g));
            }
        }
        break;
    case 1:                     /* H013+$1E28 */
        if (age > age_limit(c, 1)) {
            add_to_byte(v, 1);
        }
        if (age > age_limit(c, 3)) {
            add_to_byte(v, 1);
        }
        clamp_stat(c, s, v, 0x0C, 0x0E);
        break;
    case 2:                     /* H013+$1F98 */
        if (age <= age_limit(c, 0)) {
            add_to_byte(v, 0xFFFF);
        }
        if (age > age_limit(c, 1)) {
            add_to_byte(v, 1);
        }
        if (age > age_limit(c, 2)) {
            add_to_byte(v, 1);
        }
        if (age > age_limit(c, 3)) {
            add_to_byte(v, 1);
        }
        clamp_stat(c, s, v, 0x10, 0x12);
        if (*v < 13 && c->b[0x5C] >= 8 && c->b[0x5C] <= 12) {
            *v = 13;
        }
        break;
    case 3:                     /* H013+$21DA */
        if (age > age_limit(c, 2)) {
            add_to_byte(v, 0xFFFE);
        }
        if (age > age_limit(c, 3)) {
            add_to_byte(v, 0xFFFF);
        }
        clamp_stat(c, s, v, 0x14, 0x16);
        break;
    case 4:                     /* H013+$234A */
        if (age > age_limit(c, 1)) {
            add_to_byte(v, 0xFFFF);
        }
        if (age > age_limit(c, 2)) {
            add_to_byte(v, 0xFFFF);
        }
        if (age > age_limit(c, 3)) {
            add_to_byte(v, 0xFFFF);
        }
        clamp_stat(c, s, v, 0x18, 0x1A);
        break;
    case 5:                     /* H013+$24F4 */
        clamp_stat(c, s, v, 0x1C, 0x1E);
        break;
    default:
        break;
    }
}

/*
 * PORT H013+$0982: Create New Character.  Menu di razza, sesso, classe,
 * divinita' (solo chierici) e allineamento, poi eta', caratteristiche
 * (con nuovo tiro a richiesta), punti ferita, denaro, nome, figura e
 * salvataggio su disco (H066+$1640).  Esc in un menu annulla tutto.
 */
void create_character(void)
{
    static const u8 align_values[6] = { 0, 1, 3, 4, 6, 7 };    /* -$6 */
    Character *ch;                      /* -$a(a5) */
    Character *saved;                   /* -$e(a5) */
    CokMenuItem *list = NULL;              /* -$12(a5) */
    CokMenuItem *node;                     /* -$16(a5) */
    u16 index;                          /* -$18(a5) */
    u16 i;                              /* -$1a(a5) */
    u16 j;                              /* -$1c(a5) */
    u16 roll;                           /* -$1e(a5) */
    u8 key;                             /* -$1f(a5) */
    u8 race_i;                          /* -$20(a5) */
    u8 g;                               /* -$21(a5) */
    u8 k;                               /* -$22(a5) */
    u8 s;                               /* -$23(a5) */
    u16 class_count;                    /* -$26(a5) */
    u16 nclasses;                       /* -$2c(a5) */
    u8 with_exit;                       /* -$2f(a5) */
    u8 redraw;                          /* -$30(a5) */
    u8 sep;                             /* -$32(a5) */
    char line[0x29];                    /* -$5c(a5) */
    u16 saved_550;                      /* -$5e(a5) */
    u8 align_ids[6];                    /* -$64(a5) */
    u16 god_mask;                       /* -$66(a5) */
    u16 bits;                           /* -$68(a5) */
    u16 gold;                           /* -$6a(a5) */
    u8 race;

    ch = (Character *)exec_alloc_mem(sizeof(Character), COK_MEMF_CLEAR);
    ch->items = NULL;
    ch->effects = NULL;
    for (i = 1; i <= 6; ++i) {
        u8 v = H005_B(0x5228 + i - 1);

        ch->b[0x146 + i - 1] = (u8)(v + ((v + 8) << 4));
    }
    ch->b[0x11A] = 0x32;
    ch->b[0x5A] = 0x28;
    ch->b[0x197] = 0;
    ch->b[0x198] = 1;
    ch->b[0xD3] = 1;
    ch->b[0x11C] = (u8)random_below(0x100);
    ch->b[0x143] = 0x0A;

    /* Razza. */
    menu_alloc(8, &list);
    list->header = 1;
    copy_text(list->text, "Pick Race", 0x28);
    for (race_i = 0; race_i <= 6; ++race_i) {
        node = menu_nth(list, (u16)(race_i + 1));
        copy_text(node->text, "  ", 0x28);
        h026_append(0x28, node->text, 0x0F,
                    (const char *)&g_h005[0x4D04 + race_i * 16]);
    }
    node = list;
    index = 1;
    redraw = 1;
    with_exit = 1;
    do {
        key = create_menu(list, with_exit, &redraw, &index, &node);
        if (key == 0) {
            menu_free(&list);
            free_character(&ch);
            return;
        }
    } while (key != 'S');
    ch->b[0x5B] = (u8)(index - 1);
    switch (ch->b[0x5B]) {
    case 5:                     /* H013+$0C0A */
        ch->b[0x144] = 1;
        add_effect(ch, 0x5C, 0, 0xFF, 0);
        add_effect(ch, 0x5E, 0, 0xFF, 0);
        break;
    case 3: case 4:             /* H013+$0C46 */
        ch->b[0x144] = 1;
        add_effect(ch, 0x5E, 0, 0xFF, 0);
        add_effect(ch, 0x1A, 0, 0xFF, 0);
        add_effect(ch, 0x2F, 0, 0xFF, 0);
        break;
    case 0: case 1:             /* H013+$0C9C */
        ch->b[0x144] = 2;
        add_effect(ch, 0x5F, 0, 0xFF, 0);
        break;
    case 2:                     /* H013+$0CBE */
        ch->b[0x144] = 2;
        add_effect(ch, 0x12, 0, 0xFF, 0);
        break;
    default:                    /* H013+$0CE0 */
        ch->b[0x144] = 2;
        break;
    }
    menu_free(&list);

    /* Sesso. */
    menu_alloc(3, &list);
    list->header = 1;
    copy_text(list->text, "Pick Gender", 0x28);
    for (g = 0; g <= 1; ++g) {
        node = menu_nth(list, (u16)(g + 1));
        copy_text(node->text, "  ", 0x28);
        h026_append(0x28, node->text, 6,
                    (const char *)&g_h005[0x4BD2 + g * 8]);
    }
    node = list;
    index = 1;
    with_exit = 1;
    redraw = 1;
    do {
        key = create_menu(list, with_exit, &redraw, &index, &node);
        if (key == 0) {
            menu_free(&list);
            free_character(&ch);
            return;
        }
    } while (key != 'S');
    ch->b[0x10E] = (u8)(index - 1);
    menu_free(&list);

    /* Classe: le classi ammesse dalla razza (H005+$21FC). */
    race = ch->b[0x5B];
    class_count = H005_W(0x21FC + race * 16);
    menu_alloc((u16)(class_count + 1), &list);
    list->header = 1;
    copy_text(list->text, "Pick Class", 0x28);
    for (i = 1; i <= class_count; ++i) {
        node = menu_nth(list, i);
        copy_text(node->text, "  ", 0x28);
        h026_append(0x28, node->text, 0x1A, (const char *)&g_h005[0x4D84 +
                    H005_B(0x21FC + race * 16 + 2 + i - 1) * 0x1C]);
        if (i == 0xFFFF) {
            break;
        }
    }
    node = list;
    index = 1;
    with_exit = 1;
    redraw = 1;
    do {
        key = create_menu(list, with_exit, &redraw, &index, &node);
        if (key == 0) {
            menu_free(&list);
            free_character(&ch);
            return;
        }
    } while (key != 'S');
    CH_PUTL(ch, 0x11E, 0);
    ch->b[0x5C] = H005_B(0x21FC + ch->b[0x5B] * 16 + 2 + index - 1);
    switch (ch->b[0x5C]) {      /* livelli iniziali ed esperienza */
    case 0:                     /* H013+$0FBC */
        ch->b[0xFE] = 1;
        break;
    case 6:                     /* H013+$0FC4 */
        ch->b[0x104] = 2;
        CH_PUTL(ch, 0x11E, 0x4E3);
        break;
    case 2:                     /* H013+$0FD6 */
        ch->b[0x100] = 2;
        CH_PUTL(ch, 0x11E, 0x7D1);
        break;
    case 5:                     /* H013+$0FE8 */
        ch->b[0x103] = 2;
        CH_PUTL(ch, 0x11E, 0x1388);
        break;
    case 4:                     /* H013+$0FFA */
        ch->b[0x102] = 2;
        CH_PUTL(ch, 0x11E, 0x8CB);
        add_effect(ch, 0x69, 0, 0xFF, 0);
        break;
    case 7:                     /* H013+$1026 */
        ch->b[0x105] = 1;
        CH_PUTL(ch, 0x11E, 0x9C4);
        ch->b[0x5D] = 1;
        break;
    case 8:                     /* H013+$103E */
        ch->b[0xFE] = 1;
        ch->b[0x100] = 1;
        CH_PUTL(ch, 0x11E, 0x7D1);
        break;
    case 9:                     /* H013+$1056 */
        ch->b[0xFE] = 1;
        ch->b[0x100] = 1;
        ch->b[0x103] = 1;
        CH_PUTL(ch, 0x11E, 0x1388);
        break;
    case 10:                    /* H013+$1074 */
        ch->b[0xFE] = 1;
        ch->b[0x102] = 1;
        add_effect(ch, 0x69, 0, 0xFF, 0);
        CH_PUTL(ch, 0x11E, 0x8CB);
        break;
    case 11:                    /* H013+$10A6 */
        ch->b[0xFE] = 1;
        ch->b[0x103] = 1;
        CH_PUTL(ch, 0x11E, 0x1388);
        break;
    case 12:                    /* H013+$10BE */
        ch->b[0xFE] = 1;
        ch->b[0x104] = 1;
        break;
    case 13:                    /* H013+$10CC */
        ch->b[0x100] = 1;
        ch->b[0x103] = 1;
        CH_PUTL(ch, 0x11E, 0x1388);
        break;
    case 14:                    /* H013+$10E4 */
        ch->b[0x100] = 1;
        ch->b[0x104] = 1;
        CH_PUTL(ch, 0x11E, 0x7D1);
        break;
    case 15:                    /* H013+$10FC */
        ch->b[0x100] = 1;
        ch->b[0x103] = 1;
        ch->b[0x104] = 1;
        CH_PUTL(ch, 0x11E, 0x1388);
        break;
    case 16:                    /* H013+$111A */
        ch->b[0x103] = 1;
        ch->b[0x104] = 1;
        CH_PUTL(ch, 0x11E, 0x1388);
        break;
    default:
        break;
    }
    if (ch->b[0x104] > 0) {
        thief_skills(ch);
    }
    ch->b[0x122] = 0;
    ch->b[0x5A] = 0;
    for (k = 0; k <= 7; ++k) {
        if (ch->b[0xFE + k] > 0) {
            u16 t = H005_W(0x5158 + k * 0x1A + ch->b[0xFE + k] * 2);

            if (t > ch->b[0x5A]) {
                ch->b[0x5A] = (u8)t;
            }
            add_to_byte(&ch->b[0x122], H005_B(0x5040 + k));
        }
    }
    saving_throws(ch);

    /* Divinita' (solo con livelli da chierico). */
    if (ch->b[0xFE] > 0) {
        menu_free(&list);
        if (ch->b[0x5B] == 3 || ch->b[0x5B] == 4) {
            menu_alloc(2, &list);
            list->header = 1;
            copy_text(list->text, "Pick God", 0x28);
            node = menu_nth(list, 1);
            copy_text(node->text, "  ", 0x28);
            h026_append(0x28, node->text, 0x0B,
                        (const char *)&g_h005[0x4C4A]);
        } else {
            menu_alloc(8, &list);
            list->header = 1;
            copy_text(list->text, "Pick God", 0x28);
            for (i = 1; i <= 7; ++i) {
                node = menu_nth(list, i);
                copy_text(node->text, "  ", 0x28);
                h026_append(0x28, node->text, 0x0B,
                            (const char *)&g_h005[0x4C02 + (i & 0xFF) * 0x0C]);
            }
        }
        node = list;
        index = 1;
        with_exit = 1;
        redraw = 1;
        do {
            key = create_menu(list, with_exit, &redraw, &index, &node);
            if (key == 0) {
                menu_free(&list);
                free_character(&ch);
                return;
            }
        } while (key != 'S');
        if (ch->b[0x5B] == 3 || ch->b[0x5B] == 4) {
            ch->b[0x5E] = 6;
        } else {
            ch->b[0x5E] = (u8)index;
        }
        switch (ch->b[0x5E]) {  /* allineamenti ammessi e poteri */
        case 1:                 /* H013+$1430 */
            god_mask = 0x15;
            ch->b[0xCA] = 1;
            break;
        case 2:                 /* H013+$1442 */
            god_mask = 0x15;
            ch->b[0xCB] = 1;
            break;
        case 3:                 /* H013+$1454 */
            god_mask = 0x15;
            ch->b[0xCC] = 1;
            add_to_byte(&ch->b[0x5A], 1);
            break;
        case 4:                 /* H013+$1478 */
            god_mask = 0x15;
            ch->b[0xCD] = 1;
            ch->b[0xCE] = 1;
            ch->b[0xCF] = 1;
            break;
        case 5:                 /* H013+$149E */
            god_mask = 0x2E;
            ch->b[0xD0] = 1;
            break;
        case 6:                 /* H013+$14B0 */
            god_mask = 0x2E;
            if (ch->b[0x5B] == 3 || ch->b[0x5B] == 4) {
                add_to_byte(&ch->b[0x5A], 1);
            }
            break;
        case 7:                 /* H013+$14E6 */
            god_mask = 0x2E;
            ch->b[0xCF] = 1;
            break;
        default:
            /*
             * Valore non previsto: l'originale lascia -$66(a5) com'era
             * nello stack.  Qui 0 (nessun allineamento ammesso).
             */
            god_mask = 0;
            break;
        }
    } else {
        ch->b[0x5E] = 0;
        god_mask = 0xFF;
    }
    menu_free(&list);

    /* Allineamento: quelli ammessi da classe (H005+$1F78) e divinita'. */
    list = (CokMenuItem *)exec_alloc_mem(sizeof(CokMenuItem), COK_MEMF_CLEAR);
    list->next = NULL;
    list->header = 1;
    copy_text(list->text, "Pick Alignment", 0x28);
    node = list;
    j = 0;
    for (i = 0; i <= 5; ++i) {
        bits = (u16)(u8)(mask_byte((u8)god_mask,
                                   H005_W(0x1F78 + ch->b[0x5C] * 2)) >> i);
        if (mask_byte((u8)bits, 1)) {
            node->next = (CokMenuItem *)exec_alloc_mem(sizeof(CokMenuItem),
                                                    COK_MEMF_CLEAR);
            node = node->next;
            node->next = NULL;
            node->header = 0;
            copy_text(node->text, "  ", 0x28);
            h026_append(0x28, node->text, 0x10, (const char *)&g_h005[0x4C62 +
                        align_values[i] * 0x12]);
            align_ids[j] = align_values[i];
            ++j;
        }
    }
    node = list;
    index = 1;
    with_exit = 1;
    redraw = 1;
    do {
        key = create_menu(list, with_exit, &redraw, &index, &node);
        if (key == 0) {
            menu_free(&list);
            free_character(&ch);
            return;
        }
    } while (key != 'S');
    ch->b[0x10F] = align_ids[index - 1];
    switch (ch->b[0x10F]) {
    case 0: case 3: case 6:     /* H013+$171E */
        if (CH_L(ch, 0x11E) == 0 && ch->b[0xFE] > 0) {
            CH_PUTL(ch, 0x11E, 0x7D0);
        }
        if (ch->b[0x103] > 0) {
            ch->b[0x5F] = 1;
        }
        break;
    case 1: case 4: case 7:     /* H013+$175C */
        if (CH_L(ch, 0x11E) == 0 && ch->b[0xFE] > 0) {
            CH_PUTL(ch, 0x11E, 0x5DC);
        }
        if (ch->b[0x103] > 0) {
            ch->b[0x5F] = 2;
        }
        break;
    default:
        break;
    }
    menu_free(&list);

    /* Eta' (+$62): tirata per una classe, massima per le multiclasse. */
    if (ch->b[0x5C] <= 7) {
        u16 row = (u16)(0x20AC + ch->b[0x5B] * 0x30 + ch->b[0x5C] * 6);

        CH_PUTW(ch, 0x62, roll_dice(H005_W(row + 2), H005_W(row + 4)) +
                          H005_W(row));
    } else {
        switch (ch->b[0x5C]) {
        case 8: case 9: case 10: case 11: case 12:
            CH_PUTW(ch, 0x62, max_age(ch->b[0x5B], 0));
            break;
        case 13: case 15: case 16:
            CH_PUTW(ch, 0x62, max_age(ch->b[0x5B], 5));
            break;
        case 14:
            CH_PUTW(ch, 0x62, max_age(ch->b[0x5B], 2));
            break;
        default:
            break;
        }
    }

    saved = g_current_char;
    g_current_char = ch;
    draw_character_sheet();
    do {
        for (k = 0; k <= 7; ++k) {
            if (g_current_char->b[0xFE + k] > 0) {
                g_current_char->b[0xFE + k] = 1;
            }
        }
        ch->b[0x1C] = 0;

        /*
         * Caratteristiche: il migliore di 6 tiri di 3d6+1 per ognuna.  Le
         * correzioni di razza dipendono da -$20(a5), che qui vale sempre 7
         * (il contatore del menu delle razze): nell'originale non si
         * applicano mai.
         */
        for (s = 0; s <= 5; ++s) {
            ch->b[0x10 + s * 2 + 1] = 0;
            for (j = 1; j <= 6; ++j) {
                roll = (u16)(roll_dice(3, 6) + 1);
                switch (race_i) {
                case 0: case 1:
                    if (s == 3) {
                        ++roll;
                    } else if (s == 4) {
                        --roll;
                    }
                    break;
                case 2:
                    if (s == 3) {
                        roll = (u16)(roll + 2);
                    }
                    break;
                case 3: case 4:
                    if (s == 4) {
                        ++roll;
                    } else if (s == 5) {
                        --roll;
                    }
                    break;
                case 5:
                    if (s == 0) {
                        --roll;
                    } else if (s == 3) {
                        roll = (u16)(roll + 2);
                    }
                    break;
                default:
                    break;
                }
                if (ch->b[0x11 + s * 2] < roll) {
                    ch->b[0x11 + s * 2] = (u8)roll;
                }
            }
            adjust_stat(ch, s);
            ch->b[0x10 + s * 2] = ch->b[0x11 + s * 2];
            if (s == 0) {
                ch->b[0x1D] = ch->b[0x1C];
            }
            draw_stat_value(s, 0);
        }

        ch->b[0x1A8] = ch->b[0x64];
        ch->b[0x110] = 2;
        ch->b[0x112] = 1;
        ch->b[0x114] = 2;
        ch->b[0x11B] = 1;
        ch->b[0xDA] = 0x0C;
        nclasses = 0;           /* -$2e(a5) e' azzerata ma non usata */
        gold = 0;
        h029_fill_bytes(0x17, &ch->b[0x124], 0x17, 0);
        for (k = 0; k <= 7; ++k) {
            if (ch->b[0xFE + k] == 0) {
                continue;
            }
            switch (k) {
            case 0:             /* H013+$26DC */
                ch->b[0x124] = (u8)(ch->b[0x5E] <= 4 ? 1 : 2);
                break;
            case 5:             /* H013+$26FC */
                ch->b[0x136] = 1;
                break;
            default:
                break;
            }
            switch (k) {        /* denaro iniziale */
            case 0:             /* H013+$2766 */
                gold = (u16)(gold + roll_dice(3, 6));
                cleric_spell_slots(ch);
                i = 1;
                j = 0xFF;
                while (i <= 0x0A && j != 0) {
                    j = H005_W(0x1476 + (i - 1) * 2);
                    if (j != 0) {
                        ch->b[0x66 + j - 1] = 1;
                    }
                    ++i;
                }
                break;
            case 2: case 4:     /* H013+$274C */
                gold = (u16)(gold + roll_dice(5, 4));
                break;
            case 5:             /* H013+$27DE */
                gold = (u16)(gold + roll_dice(2, 4));
                ch->b[0x70] = 1;
                ch->b[0x77] = 1;
                ch->b[0x71] = 1;
                ch->b[0x74] = 1;
                ch->b[0x7A] = 1;
                break;
            case 6:             /* H013+$2816 */
                gold = (u16)(gold + roll_dice(2, 6));
                break;
            case 7:             /* H013+$2734 */
                gold = roll_dice(1, 4);
                break;
            default:
                break;
            }
            ++nclasses;
        }
        /* All'uscita dal ciclo k vale 8: la divisione si fa sempre. */
        if (k != 7) {
            gold = (u16)((gold / nclasses) * 5);
        }
        CH_PUTW(ch, 0xF8, gold);
        ch->b[0x64] = 0;
        ch->b[0x123] = 0;
        ch->b[0x1A8] = 0;
        roll_hit_points(ch, 0xFF, nclasses);

        saved_550 = COK_GET16(g_state_b + 0x550);
        COK_PUT16(g_state_b + 0x550, 0xFF);
        H005_B(0x24DF) = 0;
        H005_B(0x24CF) = 1;
        do {
            train_character();
        } while (!H005_B(0x24DF));
        COK_PUT16(g_state_b + 0x550, saved_550);
        H005_B(0x24CF) = 0;

        /* Livelli per classe, "n/n/n", alla riga 7. */
        sep = 0;
        copy_text(line, "", 0x28);
        for (k = 0; k <= 7; ++k) {
            Character *c = g_current_char;

            if (c->b[0xFE + k] > 0 ||
                (c->b[0x106 + k] < h073_12c8(c) && c->b[0x106 + k] > 0)) {
                if (sep) {
                    h026_append(0x28, line, 1, "/");
                }
                format_number(0x50, s_message,
                              (s32)(u16)(c->b[0xFE + k] + c->b[0x106 + k]),
                              0, 0x0A, 2, ' ');
                h026_append(0x28, line, 0x50, s_message);
                sep = 1;
            }
        }
        ui_draw_text(7, 7, 0x0F, 0, 0x28, line);
        draw_combat_values();
        draw_character_money();
        key = ask_yes_no(0x0E, "Reroll stats? ", 0x0D, 0x0A, 0x0F);
    } while (key != 'N');

    draw_character_sheet();
    do {
        input_line(0x10, "Character name: ", 0x0D, 0, 0x0F, 0x0F,
                   (char *)ch->b);
    } while (ch->b[0] == 0);
    load_char_screens();
    set_default_figure();
    edit_character_icon();
    for (s = 0; s <= 5; ++s) {
        ch->b[0x10 + s * 2] = ch->b[0x11 + s * 2];
    }
    ch->b[0x1D] = ch->b[0x1C];
    copy_text(s_message, "Save ", 0x50);
    h026_append(0x50, s_message, 0x0F, (const char *)ch->b);
    h026_append(0x50, s_message, 2, "? ");
    key = ask_yes_no(0x50, s_message, 0x0D, 0x0A, 0x0F);
    if (key == 'N') {
        free_character(&ch);
        g_current_char = saved;
        return;
    }
    if (ch->b[0x105] > 0) {
        add_starting_items(ch);
    }
    save_character(ch, 0, "");
    free_character(&ch);
    g_current_char = saved;
}

/* Esperienza (long) della tabella H005+$1946 per la riga row e l'indice i. */
static s32 xp_table(u8 row, s16 i)
{
    return (s32)H005_L((u16)(0x1946 + row * 0x9A + i * 4));
}

/*
 * PORT H013+$58DC (trampolino H013+$051C): Train Character.  Le classi
 * con esperienza sufficiente (H005+$1946) e addestrabili qui (maschera
 * dello stato B +$550) salgono di un livello dopo la conferma; poi valori
 * derivati, nuovo incantesimo del mago e punti ferita.  Durante la
 * creazione ($24CF) non ci sono messaggi ne' domande e, quando nessuna
 * classe puo' salire, $24DF = 1.  Con l'addestramento gratuito ($24DE) non
 * serve esperienza.
 */
void train_character(void)
{
    Character *c;                       /* a3 */
    s32 next_xp;                        /* -$6(a5) */
    s32 xp;                             /* -$a(a5) */
    s32 best;                           /* -$2e(a5) */
    u16 eligible = 0;                   /* -$c(a5) */
    u16 classes = 0;                    /* -$e(a5) */
    u16 train = 0;                      /* -$10(a5) */
    u16 nclasses;                       /* -$12(a5) */
    u16 row;                            /* -$1e(a5) */
    u16 spell;                          /* -$24(a5) */
    s16 spell_value;                    /* -$26(a5) */
    u16 allowed;                        /* -$2a(a5) */
    u8 again = 0;                       /* -$27(a5) */
    u8 blocked;                         /* -$1(a5) */
    u8 k;                               /* -$19(a5) */
    u8 old_103;                         /* -$1f(a5) */
    u8 old_102;                         /* -$20(a5) */
    u8 lvl = 0;                         /* -$21(a5) */
    u8 best_k = 0;                      /* -$2f(a5) */
    u8 xp_row = 0;                      /* -$30(a5) */

    if (!H005_B(0x24CF) && !pick_character()) {
        return;
    }
    if (g_current_char->b[0x197] != 0 && !H005_B(0x24DE)) {
        show_message(0x1E, "we only train conscious people", 0x0E, 0);
        return;
    }
    allowed = COK_GET16(g_state_b + 0x550);
    c = g_current_char;
    next_xp = 0;
    for (k = 0; k <= 7; ++k) {
        s32 need;

        if (c->b[0xFE + k] == 0) {
            continue;
        }
        classes = (u16)(classes + H005_B(0x5038 + k));
        blocked = 0;
        lvl = c->b[0xFE + k];
        if (c->b[0x5B] == 5 && (k == 2 || k == 4)) {
            if (lvl == 7 || (lvl == 6 && c->b[0x11] == 0x11) ||
                (lvl == 5 && c->b[0x11] < 0x11)) {
                blocked = 1;
            }
        }
        xp_row = class_xp_row(g_current_char, k);
        if (blocked) {
            continue;
        }
        need = xp_table(xp_row, (s16)((u8)(lvl + 1) - 2));
        if (!((s32)CH_L(c, 0x11E) >= need || H005_B(0x24DE)) || need <= 0) {
            continue;
        }
        if (H005_B(0x24DE) && (u16)need != 0 && (s32)CH_L(c, 0x11E) < need) {
            CH_PUTL(c, 0x11E, need);
        }
        eligible = (u16)(eligible + H005_B(0x5038 + k));
        xp = xp_table(xp_row, (s16)((u8)(lvl + 2) - 2));
        if (xp > 0 && (s32)CH_L(c, 0x11E) >= xp && xp > next_xp) {
            next_xp = xp - 1;
        }
    }
    if (!H005_B(0x24CF)) {
        /*
         * Come nell'originale la riga e il livello sono quelli rimasti
         * dall'ultima classe del ciclo precedente.
         */
        best = 0;
        for (k = 0; k <= 7; ++k) {
            if (mask_byte((u8)eligible, H005_B(0x5038 + k)) &&
                best < xp_table(xp_row, (s16)((u8)(lvl + 1) - 2))) {
                best = xp_table(xp_row, (s16)((u8)(lvl + 1) - 2));
                best_k = k;
            }
            if (best > 0) {
                eligible = or_byte(H005_B(0x5038 + best_k), eligible);
                xp = xp_table(xp_row, (s16)((u8)(lvl + 2) - 2));
                if (xp > 0 && (s32)CH_L(c, 0x11E) >= xp && xp > next_xp) {
                    next_xp = xp - 1;
                }
            }
        }
    }
    if (next_xp > 0 && !H005_B(0x24CF)) {
        CH_PUTL(c, 0x11E, next_xp);
    }
    if (!H005_B(0x24DE)) {
        if (!mask_byte((u8)classes, allowed) && !H005_B(0x24CF)) {
            show_message(0x1E, "We don't train that class here", 0x0E, 0);
            return;
        }
        if (!mask_byte((u8)eligible, allowed)) {
            H005_B(0x24DF) = 1;
            if (!H005_B(0x24CF)) {
                show_message(0x15, "Not Enough Experience", 0x0E, 0);
            }
            return;
        }
        train = mask_byte((u8)eligible, allowed);
    } else {
        train = eligible;
    }
    if (!H005_B(0x24CF)) {
        clear_text_cells(1, 1, 0x26, 0x16);
        row = 4;
        draw_character_name(g_current_char, 4, row, 0);
        ui_draw_text((u16)(h026_strlen(0x0F, (const char *)c->b) + 4), row,
                     0x0A, 0, 0x0D, " will become:");
        for (k = 0; k <= 7; ++k) {
            if (c->b[0xFE + k] == 0 ||
                !mask_byte(H005_B(0x5038 + k), train)) {
                continue;
            }
            ++row;
            format_number(0x50, s_message, (s32)(u16)(c->b[0xFE + k] + 1), 0,
                          0x0A, 1, ' ');
            if (row == 5) {
                h026_insert(0x50, s_message, 0x0C, "    a level ", 0);
            } else {
                h026_insert(0x50, s_message, 0x0C, "and a level ", 0);
            }
            h026_append(0x50, s_message, 1, " ");
            h026_append(0x50, s_message, 0x1A,
                        (const char *)&g_h005[0x4D84 + k * 0x1C]);
            ui_draw_text(6, row, 0x0A, 0, 0x50, s_message);
        }
        if (ask_yes_no(0x16, "Do you wish to train? ", 0x0D, 0x0A, 0x0F) !=
            'Y') {
            return;
        }
        show_message_line(0x12, "Congratulations...");
    }

    nclasses = 0;
    old_103 = c->b[0x103];
    old_102 = c->b[0x102];
    c->b[0x122] = 0;
    for (k = 0; k <= 7; ++k) {
        if (c->b[0xFE + k] == 0) {
            continue;
        }
        ++nclasses;
        if (mask_byte(H005_B(0x5038 + k), train)) {
            ++c->b[0xFE + k];
            if (c->b[0xDD] > 0) {
                add_to_byte(&c->b[0xDE], (u16)-(s16)((s16)c->b[0xDE] /
                                                     (s16)c->b[0xDD]));
                add_to_byte(&c->b[0xDD], 0xFFFF);
            }
        }
    }
    level_derived_values(g_current_char);
    if (!H005_B(0x24CF) && (c->b[0x103] > old_103 || c->b[0x102] > 8)) {
        spell_value = -1;               /* $FFFF */
        do {
            spell = choose_spell_of_kind(4, 4, &spell_value, &again);
        } while (spell == 0 && again);
        if (spell > 0) {
            c->b[0x66 + spell - 1] = 1;
        }
    }
    (void)old_102;
    if (H005_B(0x24CF)) {
        switch (c->b[0x103]) {  /* incantesimi del mago per livello */
        case 2:
            c->b[0x74] = 1;
            break;
        case 3:
            c->b[0x87] = 1;
            c->b[0x6F] = 1;
            break;
        case 4:
            c->b[0x84] = 1;
            break;
        case 5:
            c->b[0x94] = 1;
            break;
        default:
            break;
        }
    }
    if (c->b[0xDB] > c->b[0xDC]) {
        roll_hit_points(g_current_char, train, nclasses);
    }
    c = g_current_char;
    for (k = 0; k <= 7; ++k) {
        if (c->b[0xFE + k] > 1) {
            s32 v;

            xp_row = class_xp_row(g_current_char, k);
            v = xp_table(xp_row, (s16)(c->b[0xFE + k] - 2));
            if (v > (s32)CH_L(c, 0x11E)) {
                CH_PUTL(c, 0x11E, v);
            }
        }
    }
}

/* Allineamento malvagio: (allineamento + 1) multiplo di 3 (2, 5, 8). */
static u8 is_evil(const Character *c)
{
    return (u8)((u16)(c->b[0x10F] + 1) % 3 == 0);
}

/*
 * PORT H013+$52E0 (trampolino H013+$0518): Add Character to Party.
 * Elenco dei personaggi salvati (H066+$03D0); quello scelto e' caricato,
 * segnato con "* " e aggiunto se non e' gia' nel party, se il party non
 * e' pieno (6 personaggi giocanti, 8 in tutto) e se paladini, ranger
 * (al massimo 3) e allineamenti malvagi sono compatibili; altrimenti il
 * segno e' tolto, con il messaggio del motivo.  Fino a Esc/Exit o party
 * pieno.  Il personaggio rifiutato libera solo il record, come
 * nell'originale (oggetti ed effetti caricati restano allocati).
 */
void add_character_to_party(void)
{
    CokMenuItem *names = NULL;          /* -$4(a5) */
    CokMenuItem *files = NULL;          /* -$8(a5) */
    CokMenuItem *chosen;                /* -$c(a5) */
    CokMenuItem *file_node;             /* -$10(a5) */
    Character *c;                       /* -$14(a5) */
    Character *m;                       /* -$18(a5) */
    char paladin_name[0x2A];            /* -$4e(a5) */
    u16 index;                          /* -$1a(a5) */
    u16 members = 0;                    /* -$22(a5): nell'originale non
                                         * inizializzato prima della prima
                                         * scelta; qui 0 */
    u16 rangers = 0;                    /* -$24(a5) */
    u8 key;                             /* -$1b(a5) */
    u8 has_evil = 0;                    /* -$1c(a5) */
    u8 has_paladin = 0;                 /* -$1d(a5) */
    u8 with_exit = 0;                   /* -$1e(a5): non inizializzato
                                         * nell'originale; qui 0 */
    u8 redraw;                          /* -$20(a5) */

    paladin_name[0] = 0;
    H005_B(0x24E9) = 0;
    list_saved_characters(&names, &files);
    if (names == NULL) {
        return;
    }
    index = 0;
    chosen = names;
    redraw = 1;
    do {
        key = list_menu(0x11, "Add a character: ", 4, "Add ", 0x0D, 0x0A,
                        0x0F, 1, 2, 0x26, 0x16, names, with_exit, &redraw,
                        &index, &chosen);
        if ((key == 0x0D || key == 'A') && chosen->text[0] != '#') {
            clear_message_line();
            c = (Character *)exec_alloc_mem(sizeof(Character),
                                            COK_MEMF_CLEAR);
            file_node = menu_nth(files, index);
            load_character(0x28, file_node->text, c, 0, 1);
            h026_insert(0x28, chosen->text, 2, "* ", 0);
            members = 0;
            if (g_party_head == NULL) {
                COK_PUT16(g_state_b + 0x67C, 0);
                add_to_party(c);
                build_char_icon(1);
            } else {
                rangers = 0;
                for (m = g_party_head; m != NULL; m = m->next) {
                    if (h026_compare_nocase(0x0F, (const char *)m->b, 0x0F,
                                            (const char *)c->b) == 1 &&
                        m->b[0x11C] == c->b[0x11C]) {
                        break;          /* gia' nel party */
                    }
                    if (m->b[0xEC] < 0x80) {
                        ++members;
                    }
                    if (m->b[0x102] > 0) {
                        ++rangers;
                    }
                    if (is_evil(m)) {
                        has_evil = 1;
                    }
                    if (m->b[0x101] > 0) {
                        has_paladin = 1;
                        h026_copy(0x28, paladin_name, 0x0F,
                                  (const char *)m->b);
                    }
                }
                if (m == NULL &&
                    ((c->b[0xEC] < 0x80 && members < 6) ||
                     (c->b[0xEC] > 0x7F &&
                      COK_GET16(g_state_b + 0x67C) < 8)) &&
                    !(c->b[0x101] != 0 && has_evil) &&
                    !(c->b[0x102] != 0 && rangers >= 3) &&
                    !(is_evil(c) && has_paladin)) {
                    add_to_party(c);
                    build_char_icon(1);
                    if (c->b[0xEC] < 0x80) {
                        ++members;
                    }
                } else {
                    h026_delete(0x28, chosen->text, 0, 2);
                    if (c->b[0x101] > 0 && has_evil) {
                        show_message_line(0x23,
                            "paladins do not join with evil scum");
                        message_delay();
                    } else if (c->b[0x102] > 0 && rangers > 2) {
                        show_message_line(0x19, "too many rangers in party");
                    } else if (is_evil(c) && has_paladin) {
                        h026_copy(0x50, s_message, 0x28, paladin_name);
                        h026_append(0x50, s_message, 0x17,
                                    " will tolerate no evil!");
                        show_message_line(0x50, s_message);
                    }
                    exec_free_mem(c, sizeof(Character));
                }
            }
        }
    } while (key != 'E' && key != 0 && members <= 5 &&
             COK_GET16(g_state_b + 0x67C) <= 7);
    menu_free(&names);
    menu_free(&files);
}
