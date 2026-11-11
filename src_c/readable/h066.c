#include <string.h>
/* H066: Salvataggi/caricamenti, personaggi, liste e record dei mostri. */
#include "h066.h"
#include "character.h"
#include "gfx_record.h"
#include "globals.h"
#include "h016_gfx.h"
#include "h028_files.h"
#include "h029_gfx.h"
#include "h035.h"
#include "h002_dos.h"
#include "h003_exec.h"
#include "h008.h"
#include "h015_runtime.h"
#include "h026_string.h"
#include "h030.h"
#include "h063.h"
#include "h073.h"
#include "h045.h"
#include "h014.h"
#include "h031.h"
#include "h010_input.h"
#include "unported.h"
#include "h042_seq.h"
#include "h011.h"

/* PORT H066+$02F0: link/unlk, nessun effetto. */
void h066_init(void)
{
}

/* Stato di H066+$0C34 condiviso con le sue procedure annidate. */
typedef struct IconFrame {
    struct BitMap *screen;              /* -$8(a5): charS o charT */
} IconFrame;

/*
 * PORT H066+$0BAC: sovrappone la testa (src, larga 24 pixel, alta quanto
 * src) a dst: immagine e maschera con minterm $E0.
 */
static void overlay_icon_part(struct GfxRecord *dst, struct GfxRecord *src)
{
    (void)graphics_blt_bitmap(src->image, 0, 0, dst->image, 0, 0, 0x18,
                              src->rows, 0xE0, 0xFF, NULL);
    (void)graphics_blt_bitmap(src->mask, 0, 0, dst->mask, 0, 0, 0x18,
                              src->rows, 0xE0, 0xFF, NULL);
}

/*
 * PORT H066+$0C42: procedura annidata: *rec diventa un record 24x24 di
 * 3 unita' con maschera (H029+$0408); se c'e' gia' con quelle misure i suoi
 * piani sono cancellati ($60 byte), altrimenti e' liberato e rifatto.
 */
static void ensure_icon_record(IconFrame *f, struct GfxRecord **rec)
{
    struct GfxRecord *r = *rec;
    s16 i;                              /* -$2(a5) */

    (void)f;
    if (r == NULL) {
        allocate_gfx_record(0x18, 3, 1, 1, rec);
        return;
    }
    if (r->count == 3 && r->rows == 0x18 && r->image != NULL &&
        r->mask != NULL && r->width8 == 1) {
        for (i = 0; i <= 4; ++i) {
            graphics_blt_clear(r->image->Planes[i], 0x60, 0);
        }
        graphics_blt_clear(r->mask->Planes[0], 0x60, 0);
        return;
    }
    free_gfx_record(rec);
    allocate_gfx_record(0x18, 3, 1, 1, rec);
}

/*
 * PORT H066+$0D2A: procedura annidata: copia la parte n (griglia di 12
 * per riga, celle 24x24) della schermata nei piani 0..3 dell'immagine e,
 * invertito, il piano 4 nella maschera.
 */
static void copy_icon_part(IconFrame *f, u16 n, struct GfxRecord **rec)
{
    s16 sx;                             /* -$2(a5) */
    s16 sy;                             /* -$4(a5) */

    ensure_icon_record(f, rec);
    sx = (s16)((((s16)n - 1) % 0x0C) * 0x18);
    sy = (s16)((((s16)n - 1) / 0x0C) * 0x18);
    (void)graphics_blt_bitmap(f->screen, (u16)sx, (u16)sy, (*rec)->image, 0,
                              0, 0x18, 0x18, 0xC0, 0x0F, NULL);
    (void)graphics_blt_bitmap(f->screen, (u16)sx, (u16)sy, (*rec)->mask, 0,
                              0, 0x18, 0x18, 0x30, 0x10, NULL);
}

/*
 * PORT H066+$0DEA: procedura annidata: copia la cella 24x24 (cx, cy)
 * della schermata nell'immagine di *rec.
 */
static void copy_icon_cell(IconFrame *f, u16 cy, u16 cx, struct GfxRecord **rec)
{
    ensure_icon_record(f, rec);
    (void)graphics_blt_bitmap(f->screen, (u16)(cx * 0x18), (u16)(cy * 0x18),
                              (*rec)->image, 0, 0, 0x18, 0x18, 0xC0, 0xFF,
                              NULL);
}

/*
 * PORT H066+$0C34 (corpo a $0E5A): compone nel posto +$143 la coppia di
 * immagini 24x24 dell'icona del personaggio corrente.  Con +$142 <= 31:
 * testa (+$141, nel posto 11) e due pose del corpo (+$142) da charS
 * (+$144 = 1) o charT, testa sovrapposta, e con recolor i colori +$146..
 * (le coppie di nibble) sui registri H005+$5228.  Con +$142 > 31: icone
 * intere da charT, maschera dal colore 0.  Il posto 11 e' poi liberato.
 */
void build_char_icon(u8 recolor)
{
    Character *c;
    IconFrame f;
    u8 from[16];                        /* -$1e(a5) */
    u8 to[16];                          /* -$2e(a5) */
    s16 i;                              /* -$a(a5) */
    s16 cx;                             /* -$c(a5) */
    s16 cy;                             /* -$e(a5) */
    u8 slot;

    load_char_screens();
    c = g_current_char;
    if (c->b[0x141] < 1) { /* pg+$141: parte della testa dell'icona (0..$0B) */
        c->b[0x141] = 1; /* pg+$141: parte della testa dell'icona (0..$0B) */
    }
    if (c->b[0x142] < 1) { /* pg+$142: figura del corpo dell'icona (>31: icone speciali) */
        c->b[0x142] = 1; /* pg+$142: figura del corpo dell'icona (>31: icone speciali) */
    }
    slot = c->b[0x143]; /* pg+$143: posto delle icone 24x24 (0..7 nel party; $0A creazione, $0C editor) */
    if (c->b[0x142] <= 0x1F) { /* pg+$142: figura del corpo dell'icona (>31: icone speciali) */
        /* pg+$144: taglia dell'icona (1 piccola, 2 grande) */
        f.screen = c->b[0x144] == 1 ? g_char_screen_s : g_char_screen_t;
        /* pg+$141: parte della testa dell'icona (0..$0B) */
        copy_icon_part(&f, (u16)(c->b[0x141] + 0x3E), &g_sprite_sets[11][0]);
        /* pg+$142: figura del corpo dell'icona (>31: icone speciali) */
        copy_icon_part(&f, c->b[0x142], &g_sprite_sets[slot][0]);
        /* pg+$142: figura del corpo dell'icona (>31: icone speciali) */
        copy_icon_part(&f, (u16)(c->b[0x142] + 0x1F),
                       &g_sprite_sets[slot][1]);
        overlay_icon_part(g_sprite_sets[slot][0], g_sprite_sets[11][0]);
        overlay_icon_part(g_sprite_sets[slot][1], g_sprite_sets[11][0]);
        if (recolor) {
            for (i = 0; i <= 0x0F; ++i) {
                from[i] = (u8)i;
                to[i] = (u8)i;
            }
            for (i = 1; i <= 6; ++i) {
                to[H005_B(0x5228 + i - 1)] = /* $5227: base i-1 dei 6 registri colore delle icone ($5228) */
                    /* pg+$145: base -1 colori dell'icona +$146..+$14B */
                    mask_byte(c->b[0x146 + i - 1], 0x0F);
                /* $5227: base i-1 dei 6 registri colore delle icone ($5228) */
                to[H005_B(0x5228 + i - 1) + 8] =
                    /* pg+$145: base -1 colori dell'icona +$146..+$14B */
                    (u8)(mask_byte(c->b[0x146 + i - 1], 0xF0) >> 4);
            }
            remap_gfx_colors(from, to, 0, g_sprite_sets[slot][0]);
            remap_gfx_colors(from, to, 0, g_sprite_sets[slot][1]);
        }
    } else {
        f.screen = g_char_screen_t;
        if (c->b[0x144] == 1) { /* pg+$144: taglia dell'icona (1 piccola, 2 grande) */
            if (c->b[0x142] > 0x23) { /* pg+$142: figura del corpo dell'icona (>31: icone speciali) */
                copy_icon_cell(&f, 6, 0x0B, &g_sprite_sets[slot][0]);
                copy_icon_cell(&f, 7, 0x0B, &g_sprite_sets[slot][1]);
            } else {
                /* pg+$142: figura del corpo dell'icona (>31: icone speciali) */
                copy_icon_cell(&f, (u16)((c->b[0x142] - 0x20) * 2), 0x0C,
                               &g_sprite_sets[slot][0]);
                /* pg+$142: figura del corpo dell'icona (>31: icone speciali) */
                copy_icon_cell(&f, (u16)((c->b[0x142] - 0x20) * 2 + 1), 0x0C,
                               &g_sprite_sets[slot][1]);
            }
        } else {
            /* pg+$142: figura del corpo dell'icona (>31: icone speciali) */
            cx = (s16)((c->b[0x142] - 0x20) * 2 + 3);
            cy = 6;
            if (cx > 0x0A) {
                cx = (s16)(cx - 0x0B);
                ++cy;
            }
            copy_icon_cell(&f, (u16)cy, (u16)cx, &g_sprite_sets[slot][0]);
            copy_icon_cell(&f, (u16)cy, (u16)(cx + 1),
                           &g_sprite_sets[slot][1]);
        }
        build_gfx_mask(0, g_sprite_sets[slot][0]);
        build_gfx_mask(0, g_sprite_sets[slot][1]);
        for (i = 0; i <= 0x0F; ++i) {
            from[i] = (u8)i;
            to[i] = (u8)i;
        }
        remap_gfx_colors(from, to, 0, g_sprite_sets[slot][0]);
        remap_gfx_colors(from, to, 0, g_sprite_sets[slot][1]);
    }
    free_sprite_set(0x0B);
}

/* Copia con dbeq: al massimo max + 1 byte, NUL compreso. */
static void copy_dbeq(char *dst, const char *src, u16 max)
{
    u16 i;

    for (i = 0; i <= max; ++i) {
        dst[i] = src[i];
        if (src[i] == 0) {
            break;
        }
    }
}

/* Percorso dei salvataggi (H005+$3CD4, $50 byte). */
#define SAVE_PATH ((char *)&g_h005[0x3CD4]) /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */

/* Lettera iniziale del percorso dei salvataggi in maiuscolo. */
static u8 save_drive_letter(void)
{
    u8 d = (u8)SAVE_PATH[0]; /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */

    if (d >= 'a' && d <= 'z') {
        d = (u8)(d & 0x5F);
    }
    return d;
}

/*
 * PORT H066+$08F2: procedura annidata: il volume (per valore) seguito da
 * ":" e' uno dei dischi del gioco ("Disk One:", "Disk Two:", "Disk Three:")?
 */
static u8 is_game_disk(const char *volume)
{
    char v[0x52];                       /* $c(a5): copia per valore */

    memcpy(v, volume, sizeof(v));
    h026_append(0x50, v, 1, ":");
    if (h026_compare_nocase(0x50, v, 9, "Disk One:") == 1 ||
        h026_compare_nocase(0x50, v, 9, "Disk Two:") == 1 ||
        h026_compare_nocase(0x50, v, 0x0B, "Disk Three:") == 1) {
        return 1;
    }
    return 0;
}

/*
 * PORT H066+$08E4 (corpo a $0982): se $24E9 = 0, si assicura che la
 * directory dei salvataggi sia raggiungibile: chiede di togliere i dischi
 * del gioco (con create), di inserire il disco dei salvataggi e la crea
 * (con create) finche' Lock non riesce.  Restituisce sempre 1.
 */
static u8 ensure_save_dir(u8 create)
{
    char volume[0x52];                  /* -$ac(a5) */
    char text[0x52];                    /* -$5a(a5) */
    s32 mode;                           /* -$4(a5) */
    cok_bptr lock;                      /* -$8(a5) */

    mode = create ? -1 : -2;
    if (H005_B(0x24E9) != 0) { /* $24E9: tipo dei personaggi salvati (0: record $1AA); 0 salta il disco */
        return 1;
    }
    do {
        /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */
        get_volume_name(volume, 0x50, SAVE_PATH);
        while (create && is_game_disk(volume)) {
            h026_copy(0x50, text, 0x11, "Put save disk in ");
            /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */
            h026_append(0x50, text, 0x50, SAVE_PATH);
            h026_append(0x50, text, 1, ":");
            disk_request(0x0E, 0, 0x50, text);
            /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */
            get_volume_name(volume, 0x50, SAVE_PATH);
        }
        lock = dos_lock(SAVE_PATH, mode); /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */
        if (lock == 0) {
            if (save_drive_letter() == 'D') {
                copy_dbeq(text, "Is your save disk in drive ", 0x50);
                /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */
                h026_substr(0x50, volume, 0x50, SAVE_PATH, 0, 4);
                h026_append(0x50, text, 0x50, volume);
                h026_append(0x50, text, 2, " ?");
                if (ask_yes_no(0x50, text, 0x0D, 0x0A, 0x0F) != 'Y') {
                    h026_copy(0x50, text, 0x11, "Put save disk in ");
                    h026_append(0x50, text, 0x50, volume);
                    disk_request(0x0E, 0, 0x50, text);
                }
            }
            if (create) {
                /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */
                lock = dos_create_dir(SAVE_PATH);
            }
        }
    } while (lock == 0);
    dos_unlock(lock);
    return 1;
}

/*
 * PORT H066+$142E: byte liberi sul volume di path (per valore):
 * (blocchi - blocchi usati) * byte per blocco, da Info.
 */
static u32 free_disk_space(u16 path_len, const char *path)
{
    cok_info_data *info;                /* -$8(a5) */
    cok_bptr lock;                      /* -$4(a5) */
    u32 bytes;                          /* -$e(a5) */

    (void)path_len;
    info = (cok_info_data *)exec_alloc_mem(sizeof(cok_info_data),
                                           0x10001UL);
    lock = dos_lock(path, ACCESS_READ);
    (void)dos_info(lock, info);
    bytes = h015_mulu32((u32)(info->id_NumBlocks - info->id_NumBlocksUsed),
                        (u32)info->id_BytesPerBlock);
    exec_free_mem(info, sizeof(cok_info_data));
    dos_unlock(lock);
    return bytes;
}

/* PORT H066+$14EA: procedura annidata: percorso del file di prova. */
static void test_file_path(char *path)
{
    h026_copy(0x50, path, 0x50, SAVE_PATH); /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */
    h026_append(0x50, path, 1, "/");
    h026_append(0x50, path, 0x0C, "testfilename");
}

/*
 * PORT H066+$14DC (Check_SaveWritable): prova a creare un file nella
 * directory dei salvataggi.  Sul dischetto ("D...") ripete chiedendo il
 * disco; altrimenti messaggio d'errore e 1.  Se riesce lo cancella e 0.
 */
static u8 check_save_writable(void)
{
    char path[0x52];                    /* -$58(a5) */
    char head[0x52];                    /* -$aa(a5) */
    cok_bptr file;                      /* -$6(a5) */

    for (;;) {
        test_file_path(path);
        file = dos_open(path, MODE_NEWFILE);
        if (file == 0) {
            if (save_drive_letter() == 'D') {
                h026_copy(0x50, path, 0x11, "Put save disk in ");
                /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */
                h026_substr(0x50, head, 0x50, SAVE_PATH, 0, 4);
                h026_append(0x50, path, 0x50, head);
                show_message_wait(0x0E, 0, 0x50, path);
            } else {
                show_message_wait(0x0E, 0, 0x1D,
                                  "Unexpected error during save!");
                dos_close(file);
                return 1;
            }
        }
        if (file != 0) {
            break;
        }
    }
    dos_close(file);
    test_file_path(path);
    (void)dos_delete_file(path);
    return 0;
}

/* Stato di H066+$1640 condiviso con la procedura annidata. */
typedef struct SaveFrame {
    char path[0x52];                    /* -$58(a5) */
    char base[0x2A];                    /* -$82(a5) */
} SaveFrame;

/*
 * PORT H066+$164E: procedura annidata: path = percorso dei salvataggi +
 * "/" + nome di base + estensione ext (per valore).
 */
static void save_file_path(SaveFrame *f, u16 ext_len, const char *ext)
{
    h026_copy(0x28, f->path, 0x50, SAVE_PATH); /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */
    h026_append(0x28, f->path, 1, "/");
    h026_append(0x28, f->path, 0x28, f->base);
    h026_append(0x28, f->path, ext_len, ext);
}

/*
 * PORT H066+$1640 (Save_CharacterRecord, corpo a $16EC): salva il
 * personaggio c: nome.who (o name.sav se name non e' vuoto) con il record
 * di $1AA byte, nome.swg con gli oggetti ($48 byte ciascuno) e nome.fx con
 * gli effetti ($0A byte).  Prima controlla la directory, lo spazio libero
 * ("Lose character?" se manca) e chiede se sovrascrivere un .who esistente
 * o un nome nuovo, che diventa anche il nome del personaggio.
 *
 * I campi puntatore del record e dei nodi (+$E8, +$150.., successivi)
 * nell'originale finiscono nel file con l'indirizzo in memoria; qui sono
 * scritti a 0 (il caricamento ricostruisce le liste).
 */
void save_character(Character *c, u16 name_len, const char *name)
{
    SaveFrame f;
    char ext[5];                        /* -$88(a5) */
    char input[0x2A];                   /* -$2e(a5) */
    char drive[0x2A];                   /* path, -$58(a5) */
    char name_copy[0x100];              /* parametro per valore */
    CokItem *it;                        /* -$8e(a5) */
    CokEffect *ef;                      /* -$92(a5) */
    cok_bptr file;                      /* -$4(a5) */
    u32 size;                           /* -$b4(a5) */
    u8 key;                             /* -$89(a5) */
    u8 special;                         /* -$b9(a5) */

    memcpy(name_copy, name, (size_t)name_len + 1);
    H005_B(0x24E9) = 0; /* $24E9: tipo dei personaggi salvati (0: record $1AA); 0 salta il disco */
    do {
        if (!ensure_save_dir(1)) {
            return;
        }
        size = 0x1AA;
        for (it = c->items; it != NULL; it = it->next) {
            size += 0x48;
        }
        for (ef = c->effects; ef != NULL; ef = ef->next) {
            size += 0x0A;
        }
        key = 'O';
        if (save_drive_letter() == 'D') {
            copy_dbeq(drive, "df0:", 0x28);
        } else {
            copy_dbeq(drive, "dh0:", 0x28);
        }
        if (free_disk_space(0x28, drive) < size) {
            show_message_wait(0x0E, 0, 0x22,
                              "Can't save.  No room on this disk.");
            key = ui_request_choice(0x10, "Lose character? ", 0x14,
                                    "Ok, try another disk", 0x0D, 0x0A,
                                    0x0F, 0, 0, &special);
        }
    } while (key != 'O');

    if (name_copy[0] == 0) {
        h026_copy(4, ext, 4, ".who");
        make_file_name(0x0F, (const char *)c->b, 0x28, f.base);
    } else {
        h026_copy(4, ext, 4, ".sav");
        h026_copy(0x28, f.base, name_len, name_copy);
    }
    if (check_save_writable()) {
        return;
    }
    key = 'N';
    save_file_path(&f, 4, ext);
    /*
     * Dopo la richiesta del nome nuovo l'originale ricontrolla l'esistenza
     * su f.path, che ora contiene la domanda "Overwrite ...": il controllo
     * non trova il file e si esce dal ciclo.
     */
    while (key == 'N' && name_copy[0] == 0 &&
           file_exists(0x28, f.path)) {
        copy_dbeq(f.path, "Overwrite ", 0x28);
        h026_append(0x28, f.path, 0x28, f.base);
        h026_append(0x28, f.path, 2, "? ");
        key = ask_yes_no(0x28, f.path, 0x0E, 0x0A, 0x0F);
        if (key == 'N') {
            f.base[0] = 0;
            while (f.base[0] == 0) {
                input_line(0x0F, "New file name: ", 0x0A, 0, 8, 0x28,
                           input);
                h026_copy(0x28, f.base, 0x28, input);
                h026_copy(0x0F, (char *)c->b, 0x28, input);
            }
        }
    }
    save_file_path(&f, 4, ext);
    file = dos_open(f.path, MODE_NEWFILE);
    (void)dos_write(file, c->b, 0x1AA);
    dos_close(file);

    save_file_path(&f, 4, ".swg");
    (void)dos_delete_file(f.path);
    if (c->items != NULL) {
        file = dos_open(f.path, MODE_NEWFILE);
        for (it = c->items; it != NULL; it = it->next) {
            (void)dos_write(file, it->b, 0x48);
        }
        dos_close(file);
    }
    save_file_path(&f, 3, ".fx");
    (void)dos_delete_file(f.path);
    if (c->effects != NULL) {
        file = dos_open(f.path, MODE_NEWFILE);
        for (ef = c->effects; ef != NULL; ef = ef->next) {
            (void)dos_write(file, ef->b, 0x0A);
        }
        dos_close(file);
    }
}

/* Dati del modulo sotto a4. */
static cok_fib *s_list_fib;             /* -$c(a4) */
static cok_bptr s_list_lock;            /* -$4(a4) */
static cok_bptr s_list_file;            /* -$8(a4) */
static char s_load_path[0x52];          /* -$5e(a4) */

/*
 * PORT H066+$0852: Open_ResourceFile con il gruppo di risorse ($246E)
 * azzerato, cioe' senza sostituire il disco nel percorso.
 */
static u8 open_save_file(u16 path_len, const char *path, u16 msg_len,
                         const char *msg, u8 flag, cok_bptr *file)
{
    /* $246E: disco dei dati / gruppo di risorse corrente (G_RESOURCE_GROUP) */
    u8 saved = H005_B(0x246E);          /* -$2(a5) */
    u8 ok;                              /* -$1(a5) */

    H005_B(0x246E) = 0; /* $246E: disco dei dati / gruppo di risorse corrente (G_RESOURCE_GROUP) */
    ok = open_resource_file(path_len, path, msg_len, msg, flag, file);
    H005_B(0x246E) = saved; /* $246E: disco dei dati / gruppo di risorse corrente (G_RESOURCE_GROUP) */
    return ok;
}

/*
 * PORT H066+$03DE: procedura annidata di H066+$03D0: scandisce la
 * directory path (per valore) e, per ogni file ".WHO" di record_size byte,
 * legge il nome (16 byte da name_at) e la word a status_at (dalla
 * posizione corrente).  Escluso se la word supera $7F o se il nome e' gia'
 * nel party; altrimenti il nome va in *names e il nome del file in *files.
 * La stringa "from saved game ..." (-$70) e' composta ma non usata.
 */
static void scan_save_dir(u16 path_len, const char *path, u16 name_at,
                          u16 status_at, u16 record_size,
                          CokMenuItem **names, CokMenuItem **files)
{
    char dir[0x52];                     /* $1a(a5): per valore */
    char full[0x52];                    /* -$70(a5) */
    char ext[0x52];                     /* -$114(a5) */
    char tail[0x52];                    /* -$166(a5) */
    u8 word_raw[2];                     /* -$16a(a5) */
    CokMenuItem *name_node = NULL;      /* -$6(a5) */
    CokMenuItem *file_node = NULL;      /* -$e(a5) */
    CokMenuItem *name_tail = NULL;      /* -$a(a5) */
    CokMenuItem *file_tail = NULL;      /* -$12(a5) */
    Character *m;                       /* -$16(a5) */
    s16 dot;                            /* -$168(a5) */

    memcpy(dir, path, (size_t)path_len + 1 < sizeof(dir) ?
                      (size_t)path_len + 1 : sizeof(dir));
    s_list_fib = (cok_fib *)exec_alloc_mem(sizeof(cok_fib), COK_MEMF_CLEAR);
    s_list_lock = dos_lock(dir, -1);
    if (dos_examine(s_list_lock, s_list_fib)) {
        while (dos_exnext(s_list_lock, s_list_fib)) {
            const char *fname = s_list_fib->fib_FileName;

            h026_copy(0x50, tail, 0,
                      fname + h026_strlen(0x6B, fname) - 4);
            if (h026_compare_nocase(0x50, tail, 4, ".WHO") != 1) {
                continue;
            }
            /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */
            h026_copy(0x50, full, 0x50, SAVE_PATH);
            h026_append(0x50, full, 1, "/");
            h026_append(0x50, full, 0x6B, fname);
            s_list_file = dos_open(full, MODE_OLDFILE);
            if ((u16)s_list_fib->fib_Size == record_size) {
                name_node = (CokMenuItem *)exec_alloc_mem(sizeof(CokMenuItem),
                                                          COK_MEMF_CLEAR);
                file_node = (CokMenuItem *)exec_alloc_mem(sizeof(CokMenuItem),
                                                          COK_MEMF_CLEAR);
                (void)dos_seek(s_list_file, name_at, OFFSET_CURRENT);
                (void)dos_read(s_list_file, name_node->text, 0x10);
                (void)dos_seek(s_list_file, status_at, OFFSET_CURRENT);
                word_raw[0] = 0;
                word_raw[1] = 0;
                (void)dos_read(s_list_file, word_raw, 2);
                h026_copy(0x28, file_node->text, 0x6B, fname);
                dot = h026_find_char(0x6B, fname, '.', 0,
                                     h026_strlen(0x6B, fname));
                h026_substr(0x50, ext, 0x6B, fname, (u16)dot, 4);
                if (h026_compare_nocase(0x50, ext, 4, ".SAV") == 1) {
                    h026_copy(0x50, full, 0x10, "from saved game ");
                    h026_append(0x50, full, 0, fname + 7);
                } else {
                    copy_dbeq(full, "", 0x50);
                }
                for (m = g_party_head; m != NULL; m = m->next) {
                    if (h026_compare_nocase(0x0F, (const char *)m->b, 0x28,
                                            name_node->text) == 1) {
                        break;
                    }
                }
                if (COK_GET16(word_raw) > 0x7F || m != NULL) {
                    exec_free_mem(name_node, sizeof(CokMenuItem));
                    exec_free_mem(file_node, sizeof(CokMenuItem));
                    name_node = NULL;
                    file_node = NULL;
                }
                if (name_node != NULL) {
                    if (*names == NULL) {
                        *names = name_node;
                        name_tail = *names;
                        *files = file_node;
                        file_tail = *files;
                    } else {
                        name_tail->next = name_node;
                        name_tail = name_tail->next;
                        file_tail->next = file_node;
                        file_tail = file_tail->next;
                    }
                }
            }
            dos_close(s_list_file);
        }
    }
    dos_unlock(s_list_lock);
    exec_free_mem(s_list_fib, sizeof(cok_fib));
}

/*
 * PORT H066+$03D0 (corpo a $0780): elenchi dei personaggi salvati (nomi e
 * nomi dei file) nella directory dei salvataggi, per il tipo $24E9 (0:
 * record di $1AA byte, nome all'inizio, word a +$107).
 */
void list_saved_characters(CokMenuItem **names, CokMenuItem **files)
{
    static const u16 name_at[3] = { 0, 0, 4 };          /* -$5a(a5) */
    static const u16 status_at[3] = { 0xF7, 0x84, 0x13 };   /* -$60(a5) */
    static const u16 sizes[3] = { 0x1AA, 0x1AA, 0x1AA };    /* -$66(a5) */
    u8 kind = H005_B(0x24E9); /* $24E9: tipo dei personaggi salvati (0: record $1AA); 0 salta il disco */

    *names = NULL;
    *files = NULL;
    if (!ensure_save_dir(0)) {
        return;
    }
    if (kind == 0) {
        /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */
        scan_save_dir(0x50, SAVE_PATH, name_at[kind], status_at[kind],
                      sizes[kind], names, files);
    }
}

/*
 * PORT H066+$1B0E (Load_CharacterRecord): carica in c il personaggio dal
 * file name (per valore) della directory dei salvataggi: il record ($1AA
 * byte, liste azzerate), poi gli oggetti (.swg, $48 byte) e gli effetti
 * (.fx, $0A byte) se esistono; ricalcola i valori derivati.  Con
 * save_disk il messaggio del disco e' "Put save disk in ...", altrimenti
 * quello del gruppo di risorse.
 */
void load_character(u16 name_len, const char *name, Character *c,
                    u8 unused, u8 save_disk)
{
    char fname[0x100];                  /* $14(a5): per valore */
    char msg[0x2A];                     /* -$52(a5) */
    char head[0x52];                    /* -$106(a5) */
    cok_bptr file = 0;                  /* -$4(a5) */
    CokItem *item_buf;                  /* -$20(a5) */
    CokItem *item_tail = NULL;          /* -$1c(a5) */
    CokEffect *fx_buf;                  /* -$28(a5) */
    CokEffect *fx_tail = NULL;          /* -$24(a5) */
    s16 got;                            /* -$18(a5) */
    s16 dot;                            /* -$16(a5) */

    (void)unused;
    memcpy(fname, name, (size_t)name_len + 1 < sizeof(fname) ?
                        (size_t)name_len + 1 : sizeof(fname));
    load_char_screens();
    if (save_disk) {
        h026_copy(0x28, msg, 0x11, "Put save disk in ");
        /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */
        h026_substr(0x50, head, 0x50, SAVE_PATH, 0, 4);
        h026_append(0x28, msg, 0x50, head);
    } else {
        /* $3E08: messaggi di inserimento disco, 30 byte per gruppo di risorse */
        h026_copy(0x28, msg, 0x1D, (const char *)&g_h005[0x3E08 +
                  /* $246E: disco dei dati / gruppo di risorse corrente (G_RESOURCE_GROUP) */
                  ((s16)H005_B(0x246E) - 1) * 0x1E]);
    }
    /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */
    h026_copy(0x50, s_load_path, 0x50, SAVE_PATH);
    h026_append(0x50, s_load_path, 1, "/");
    h026_append(0x50, s_load_path, name_len, fname);
    (void)open_save_file(0x50, s_load_path, 0x28, msg, 0, &file);
    ui_draw_text(0, 0x18, 0x0A, 0, 0x15, "Loading...Please Wait");
    h029_fill_bytes(0x1A9, c->b, 0x1AA, 0);
    if (H005_B(0x24E9) == 0) { /* $24E9: tipo dei personaggi salvati (0: record $1AA); 0 salta il disco */
        (void)dos_read(file, c->b, 0x1AA);
        dos_close(file);
        c->items = NULL;
        c->effects = NULL;
        c->block_192 = NULL;
        c->next = NULL;
    }
    memset(c->readied, 0, sizeof(c->readied));
    dot = h026_find_char(name_len, fname, '.', 0,
                         h026_strlen(name_len, fname));
    h026_delete(name_len, fname, (u16)dot, 4);

    /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */
    h026_copy(0x50, s_load_path, 0x50, SAVE_PATH);
    h026_append(0x50, s_load_path, 1, "/");
    h026_append(0x50, s_load_path, name_len, fname);
    h026_append(0x50, s_load_path, 4, ".swg");
    if (file_exists(0x50, s_load_path)) {
        item_buf = (CokItem *)exec_alloc_mem(sizeof(CokItem), COK_MEMF_CLEAR);
        (void)open_save_file(0x50, s_load_path, 0x28, msg, 0, &file);
        do {
            got = (s16)dos_read(file, item_buf->b, 0x48);
            if (got == 0x48) {
                CokItem *n = (CokItem *)exec_alloc_mem(sizeof(CokItem),
                                                       COK_MEMF_CLEAR);

                if (c->items == NULL) {
                    c->items = n;
                } else {
                    item_tail->next = n;
                }
                item_tail = n;
                memcpy(item_tail->b, item_buf->b, 0x48);
                item_tail->next = NULL;
            }
        } while (got == 0x48);
        dos_close(file);
        exec_free_mem(item_buf, sizeof(CokItem));
    }

    /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */
    h026_copy(0x50, s_load_path, 0x50, SAVE_PATH);
    h026_append(0x50, s_load_path, 1, "/");
    h026_append(0x50, s_load_path, name_len, fname);
    h026_append(0x50, s_load_path, 3, ".fx");
    if (file_exists(0x50, s_load_path)) {
        fx_buf = (CokEffect *)exec_alloc_mem(sizeof(CokEffect),
                                             COK_MEMF_CLEAR);
        (void)open_save_file(0x50, s_load_path, 0x28, msg, 0, &file);
        do {
            got = (s16)dos_read(file, fx_buf->b, 0x0A);
            if (got == 0x0A) {
                CokEffect *n = (CokEffect *)exec_alloc_mem(sizeof(CokEffect),
                                                           COK_MEMF_CLEAR);

                if (c->effects == NULL) {
                    c->effects = n;
                } else {
                    fx_tail->next = n;
                }
                fx_tail = n;
                memcpy(fx_tail->b, fx_buf->b, 0x0A);
                fx_tail->next = NULL;
            }
        } while (got == 0x0A);
        dos_close(file);
        exec_free_mem(fx_buf, sizeof(CokEffect));
    }
    recompute_stats(c);
    level_derived_values(c);
}

/*
 * PORT H066+$276E: aggiunge al party il PNG npc (record dei mostri), se
 * i membri (stato B +$67C) non sono piu' di 7: +$11C e' il suo numero e
 * le icone 24x24 "CPIC" npc vanno nel suo posto (+$143).
 */
void add_npc(u16 npc)
{
    Character *c;                       /* -$8(a5) */

    if (COK_GET16(g_state_b + 0x67C) > 7) { /* B+$67C: (word) numero dei membri del party (max 8) */
        return;
    }
    c = (Character *)exec_alloc_mem(sizeof(Character), COK_MEMF_CLEAR);
    load_monster_record(npc, c);
    c->b[0x11C] = (u8)npc; /* pg+$11C: identificativo: casuale per i PG, numero del PNG (icone CPIC) */
    add_to_party(c);
    /* pg+$143: posto delle icone 24x24 (0..7 nel party; $0A creazione, $0C editor) */
    load_sprite_set(4, "CPIC", npc, c->b[0x143]);
}

/*
 * PORT H066+$27EE: aggiunge c in fondo al party e lo rende corrente; il
 * suo posto delle icone (+$143) e' il primo libero tra 0 e 7; conta i
 * membri (stato B +$67C) e per i non giocanti (+$EC > $7F) ricalcola i
 * valori di livello.
 */
void add_to_party(Character *c)
{
    u8 used[8];                         /* -$c(a5) */
    Character *m;                       /* -$4(a5) */

    c->b[0x143] = 0xFF; /* pg+$143: posto delle icone 24x24 (0..7 nel party; $0A creazione, $0C editor) */
    if (g_party_head == NULL) {
        g_party_head = c;
    } else {
        m = g_party_head;
        while (m->next != NULL) {
            m = m->next;
        }
        m->next = c;
    }
    g_current_char = c;
    h029_fill_bytes(7, used, 8, 0);
    for (m = g_party_head; m != NULL; m = m->next) {
        /* pg+$143: posto delle icone 24x24 (0..7 nel party; $0A creazione, $0C editor) */
        if (m->b[0x143] <= 7) {
            /* pg+$143: posto delle icone 24x24 (0..7 nel party; $0A creazione, $0C editor) */
            used[m->b[0x143]] = 1;
        }
    }
    c = g_current_char;
    c->b[0x143] = 0; /* pg+$143: posto delle icone 24x24 (0..7 nel party; $0A creazione, $0C editor) */
    /* pg+$143: posto delle icone 24x24 (0..7 nel party; $0A creazione, $0C editor) */
    while (c->b[0x143] < 8 && used[c->b[0x143]]) {
        /* pg+$143: posto delle icone 24x24 (0..7 nel party; $0A creazione, $0C editor) */
        add_to_byte(&c->b[0x143], 1);
    }
    /* B+$67C: (word) numero dei membri del party (max 8) */
    COK_PUT16(g_state_b + 0x67C, (u16)(COK_GET16(g_state_b + 0x67C) + 1));
    if (c->b[0xEC] > 0x7F) { /* pg+$EC: controllo: <$80 PG, >$7F PNG/IA ($B3 = charme o confuso) */
        level_derived_values(c);
    }
}

/*
 * PORT H066+$1312: cancella i file del personaggio c nella directory di
 * salvataggio: nome.who, nome.swg e nome.fx.
 */
void delete_character_files(Character *c)
{
    char path[0x52];                    /* -$a6(a5) */
    char file[0x52];                    /* -$54(a5) */
    u8 ok;                              /* -$1(a5) */

    make_file_name(0x0F, (const char *)c->b, 0x50, file);
    h026_copy(0x50, path, 0x50, SAVE_PATH); /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */
    h026_append(0x50, path, 1, "/");
    h026_append(0x50, path, 0x50, file);
    h026_copy(0x50, file, 4, ".who");
    h026_insert(0x50, file, 0x50, path, 0);
    ok = dos_delete_file(file);
    copy_dbeq(file, ".swg", 0x50);
    h026_insert(0x50, file, 0x50, path, 0);
    ok = dos_delete_file(file);
    copy_dbeq(file, ".fx", 0x50);
    h026_insert(0x50, file, 0x50, path, 0);
    ok = dos_delete_file(file);
    (void)ok;
}

/* PORT H066+$300E: byte da salvare per il party (record, oggetti, effetti). */
static u16 party_save_size(void)
{
    Character *p;                       /* -$4(a5) */
    CokItem *it;                        /* -$8(a5) */
    CokEffect *ef;                      /* -$c(a5) */
    u16 size = 0;                       /* -$e(a5) */

    for (p = g_party_head; p != NULL; p = p->next) {
        size = (u16)(size + 0x1AA);
        if (p->items != NULL) {
            for (it = p->items; it != NULL; it = it->next) {
                size = (u16)(size + 0x48);
            }
        }
        if (p->effects != NULL) {
            for (ef = p->effects; ef != NULL; ef = ef->next) {
                size = (u16)(size + 0x0A);
            }
        }
    }
    return size;
}

/* PORT H066+$30A8: percorso "<save>/savgam<lettera>.dat". */
static void game_file_path(char *path, u8 letter)
{
    char one[2];

    one[0] = (char)letter;
    one[1] = 0;
    h026_copy(0x28, path, 0x50, SAVE_PATH); /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */
    h026_append(0x28, path, 1, "/");
    h026_append(0x28, path, 6, "savgam");
    h026_append(0x28, path, 1, one);
    h026_append(0x28, path, 4, ".dat");
}

/* Nome "CHRDAT<lettera><n>" del personaggio n del salvataggio. */
static void party_file_name(char *name, u8 letter, u16 n)
{
    char one[2];
    char number[2];                     /* -$160(a5) */

    format_number(1, number, n, 0, 0x0A, 1, '0');
    one[0] = (char)letter;
    one[1] = 0;
    copy_dbeq(name, "CHRDAT", 0x28);
    h026_append(0x28, name, 1, one);
    h026_append(0x28, name, 1, number);
}

/*
 * PORT H066+$3000: Save Current Game: savgam<A-J>.dat con gli stati
 * ($246E, A, B, C, $281C, $3DE2, $3DE3, $2810..) e i nomi dei personaggi;
 * ogni personaggio va in CHRDAT<lettera><n>.sav e i suoi file .who
 * vengono cancellati.
 */
void save_game(void)
{
    char names[8][0x2A];                /* -$158(a5) */
    char path[0x2A];                    /* -$18a(a5) */
    Character *p;                       /* -$15e(a5) */
    cok_bptr file;                      /* -$8(a5) */
    u32 size;                           /* -$194(a5) */
    u16 count;                          /* -$15a(a5) */
    u16 i;
    u8 buf[2];
    u8 special;                         /* -$18b(a5) */
    u8 key;                             /* -$18e(a5) */
    s32 written;                        /* -$4(a5) */

    do {
        key = ui_request_choice(0x11, "Save Which Game: ", 0x13,
                                "A B C D E F G H I J", 0x0D, 0x0A, 0x0F, 0,
                                /* $3DE3: modo/contesto di gioco corrente (0 menu, 1 vista, 5
                                 * combattimento) */
                                (u8)(H005_B(0x3DE3) == 2), &special);
    } while (!(key >= 'A' && key <= 'J') && key != 0);
    if (key == 0) {
        return;
    }
    H005_B(0x24E9) = 0; /* $24E9: tipo dei personaggi salvati (0: record $1AA); 0 salta il disco */
    if (!ensure_save_dir(1)) {
        return;
    }
    game_file_path(path, key);
    if (file_exists(0x28, path)) {
        size = 0;
    } else {
        size = 0x140B;
    }
    size += party_save_size();
    if (SAVE_PATH[0] == 'd') { /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */
        copy_dbeq(s_load_path, "df0:", 0x50);
    } else {
        copy_dbeq(s_load_path, "dh0:", 0x50);
    }
    if (free_disk_space(0x50, s_load_path) < size) {
        show_message_wait(0x0E, 0, 0x22, "Can't save.  No room on this disk.");
        return;
    }
    if (check_save_writable()) {
        return;
    }
    file = dos_open(path, MODE_NEWFILE);
    clear_message_line();
    ui_draw_text(0, 0x18, 0x0A, 0, 0x14, "Saving...Please Wait");
    /* $3DF6: (word) velocita' del gioco 0..9 (pausa dei messaggi); A+$1F8: (word) velocita' di
     * gioco ($3DF6) salvata nel salvataggio */
    COK_PUT16(g_state_a + 0x1F8, H005_W(0x3DF6));
    /* $24D5: Pics on/off (Alter); salvato con $24D4 in $3E04+$1FE; $24D4: Animation on/off (Alter):
     * piu' fotogrammi e "Loading..."; A+$1FE: (word) Pics*2+Animation nel salvataggio; da +$200 32
     * var. d'area */
    COK_PUT16(g_state_a + 0x1FE, H005_B(0x24D5) * 2 + H005_B(0x24D4));
    /* $246E: disco dei dati / gruppo di risorse corrente (G_RESOURCE_GROUP); B+$624: (word) disco
     * corrente ($246E) salvato nel salvataggio */
    COK_PUT16(g_state_b + 0x624, H005_B(0x246E));
    /* $246E: disco dei dati / gruppo di risorse corrente (G_RESOURCE_GROUP) */
    written = dos_write(file, &H005_B(0x246E), 1);
    written = dos_write(file, g_state_a, 0x800);
    written = dos_write(file, g_state_b, 0x800);
    written = dos_write(file, g_state_c, 0x400);
    written = dos_write(file, &H005_B(0x281C), 8); /* $281C: (word) x del party sulla mappa dell'area 16x16 */
    /* $3DE2: contesto di gioco precedente (copia di $3DE3), salvato */
    written = dos_write(file, &H005_B(0x3DE2), 1);
    /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
    written = dos_write(file, &H005_B(0x3DE3), 1);
    for (i = 1; i <= 3; ++i) {
        /* $2810: tab. 3 voci da 4 byte dei set di muri: word id WALLDEF, $FFFF vuoto */
        written = dos_write(file, &H005_B(0x2810 + (i - 1) * 4), 2);
        /* $2812: word +2 delle voci $2810: posizione (slot 1..3), $FFFF vuoto */
        written = dos_write(file, &H005_B(0x2810 + (i - 1) * 4 + 2), 2);
    }
    /* Le voci non usate nell'originale sono quello che c'e' sullo stack. */
    memset(names, 0, sizeof(names));
    count = 0;
    p = g_party_head;
    if (p == NULL) {
        show_message_wait(0x0E, 0, 0x16, "warning, low on memory");
    }
    while (p != NULL) {
        ++count;
        party_file_name(names[count - 1], key, count);
        p = p->next;
    }
    COK_PUT16(buf, count);              /* parola big-endian */
    written = dos_write(file, buf, 2);
    written = dos_write(file, names, 0x150);
    dos_close(file);
    (void)written;
    p = g_party_head;
    count = 0;
    while (p != NULL) {
        ++count;
        party_file_name(names[count - 1], key, count);
        save_character(p, 0x28, names[count - 1]);
        delete_character_files(p);
        p = p->next;
    }
    H005_B(0x24A3) = 1; /* $24A3: 1 se la partita e' salvata (avviso all'uscita); letto da eff. $36 */
    clear_message_line();
}

/*
 * PORT H066+$291E: Load Saved Game: sceglie fra i savgam<A-J>.dat
 * esistenti, rilegge gli stati e carica i personaggi CHRDAT<..>.sav nel
 * party (cancellando i loro .who); poi la mappa 3D o l'immagine grande.
 * PORT H066+$292C (annidata): percorso "<save>/savgam<lettera>.dat"; e'
 * identica a H066+$30A8, qui game_file_path.
 */
void load_game(void)
{
    char names[8][0x2A];                /* -$154(a5) */
    char path[0x2A];                    /* -$186(a5) */
    char path2[0x2A];                   /* -$1b0(a5) */
    char name[0x2A];                    /* -$1da(a5) */
    char avail[0x16];                   /* -$1f8(a5) */
    char letter[2];                     /* -$1e0(a5), -$1df(a5) */
    Character *p;                       /* -$15c(a5) */
    cok_bptr file;                      /* -$1fc(a5) */
    s32 got;                            /* -$4(a5) */
    u16 count;                          /* -$1dc(a5) */
    u16 i;                              /* -$156(a5) */
    u8 buf[2];
    u8 ok;                              /* -$1dd(a5) */
    u8 special;                         /* -$1e1(a5) */

    H005_B(0x24E9) = 0; /* $24E9: tipo dei personaggi salvati (0: record $1AA); 0 salta il disco */
    if (!ensure_save_dir(0)) {
        return;
    }
    copy_dbeq(avail, "", 0x14);
    letter[1] = 0;
    for (letter[0] = 'A'; letter[0] != 'K'; ++letter[0]) {
        game_file_path(path, (u8)letter[0]);
        if (file_exists(0x28, path)) {
            h026_append(0x14, avail, 1, letter);
            h026_append(0x14, avail, 1, " ");
        }
    }
    if (avail[0] == 0) {
        return;
    }
    avail[h026_strlen(0x14, avail)] = 0;
    do {
        letter[0] = (char)ui_request_choice(0x11, "Load Which Game: ", 0x14,
                                            avail, 0x0D, 0x0A, 0x0F, 0, 0,
                                            &special);
        game_file_path(path, (u8)letter[0]);
    } while (!((u8)letter[0] >= 'A' && (u8)letter[0] <= 'J' &&
               file_exists(0x28, path)) && letter[0] != 0);
    if (letter[0] == 0) {
        return;
    }
    h026_copy(0x28, path2, 0x11, "Put save disk in ");
    h026_append(0x28, path2, 0x50, SAVE_PATH); /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */
    ok = open_save_file(0x28, path, 0x28, path2, 1, &file);
    if (!ok) {
        error_message(0x16, "oh no, can't load file", 0);
    }
    clear_message_line();
    ui_draw_text(0, 0x18, 0x0A, 0, 0x15, "Loading...Please Wait");
    H005_B(0x24D1) = 1; /* $24D1: 1 dopo Load Saved Game: l'area non azzera le sue variabili */
    /* $246E: disco dei dati / gruppo di risorse corrente (G_RESOURCE_GROUP) */
    got = dos_read(file, &H005_B(0x246E), 1);
    got = dos_read(file, g_state_a, 0x800);
    got = dos_read(file, g_state_b, 0x800);
    got = dos_read(file, g_state_c, 0x400);
    got = dos_read(file, &H005_B(0x281C), 8); /* $281C: (word) x del party sulla mappa dell'area 16x16 */
    /* $3DE2: contesto di gioco precedente (copia di $3DE3), salvato */
    got = dos_read(file, &H005_B(0x3DE2), 1);
    /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
    got = dos_read(file, &H005_B(0x3DE3), 1);
    for (i = 1; i <= 3; ++i) {
        /* $2810: tab. 3 voci da 4 byte dei set di muri: word id WALLDEF, $FFFF vuoto */
        got = dos_read(file, &H005_B(0x2810 + (i - 1) * 4), 2);
        /* $2812: word +2 delle voci $2810: posizione (slot 1..3), $FFFF vuoto */
        got = dos_read(file, &H005_B(0x2810 + (i - 1) * 4 + 2), 2);
    }
    got = dos_read(file, buf, 2);
    count = COK_GET16(buf);             /* parola big-endian */
    got = dos_read(file, names, 0x150);
    dos_close(file);
    (void)got;
    /* $24D5: Pics on/off (Alter); salvato con $24D4 in $3E04+$1FE; A+$1FE: (word) Pics*2+Animation
     * nel salvataggio; da +$200 32 var. d'area */
    H005_B(0x24D5) = (u8)(COK_GET16(g_state_a + 0x1FE) >> 1);
    /* $24D4: Animation on/off (Alter): piu' fotogrammi e "Loading..."; A+$1FE: (word)
     * Pics*2+Animation nel salvataggio; da +$200 32 var. d'area */
    H005_B(0x24D4) = mask_byte((u8)COK_GET16(g_state_a + 0x1FE), 1);
    /* A+$1F8: (word) velocita' di gioco ($3DF6) salvata nel salvataggio; $3DF6: (word) velocita'
     * del gioco 0..9 (pausa dei messaggi) */
    H005_SET_W(0x3DF6, COK_GET16(g_state_a + 0x1F8));
    COK_PUT16(g_state_b + 0x67C, 0); /* B+$67C: (word) numero dei membri del party (max 8) */
    for (i = 1; i <= count; ++i) {
        remove_substring(0x28, names[i - 1], 1, ".", 0x28, name);
        make_file_name(0x28, name, 0x28, path);
        /* $3CD4: percorso dei salvataggi ($50 byte, es. "df0:Save") */
        h026_copy(0x28, path2, 0x50, SAVE_PATH);
        h026_append(0x28, path2, 1, "/");
        h026_append(0x28, path2, 0x28, path);
        h026_append(0x28, path2, 4, ".sav");
        if (file_exists(0x28, path2)) {
            p = (Character *)exec_alloc_mem(sizeof(Character),
                                            COK_MEMF_CLEAR);
            h026_copy(0x28, path2, 0x28, path);
            h026_append(0x28, path2, 4, ".sav");
            load_character(0x28, path2, p, 1, 1);
            add_to_party(p);
            if (!ensure_save_dir(0)) {
                return;
            }
        } else {
            copy_dbeq(name, "nonexistent ", 0x28);
            h026_append(0x28, path2, 0x28, name);
            error_message(0x28, path2, 0);
        }
    }
    for (p = g_party_head; p != NULL; p = p->next) {
        delete_character_files(p);
    }
    for (g_current_char = g_party_head; g_current_char != NULL;
         g_current_char = g_current_char->next) {
        /* pg+$EC: controllo: <$80 PG, >$7F PNG/IA ($B3 = charme o confuso) */
        if (g_current_char->b[0xEC] < 0x80) {
            build_char_icon(1);
        } else {
            /* pg+$11C: identificativo: casuale per i PG, numero del PNG (icone CPIC) */
            load_sprite_set(4, "CPIC", g_current_char->b[0x11C],
                            /* pg+$143: posto delle icone 24x24 (0..7 nel party; $0A creazione, $0C
                             * editor) */
                            g_current_char->b[0x143]);
        }
    }
    g_current_char = g_party_head;
    /* $246E: disco dei dati / gruppo di risorse corrente (G_RESOURCE_GROUP); B+$624: (word) disco
     * corrente ($246E) salvato nel salvataggio */
    H005_B(0x246E) = (u8)COK_GET16(g_state_b + 0x624);
    if (COK_GET16(g_state_a + 0x1CC) != 0) { /* A+$1CC: (word) 1 area 3D (mappa 16x16), 0 mappa all'aperto */
        /* $2810: tab. 3 voci da 4 byte dei set di muri: word id WALLDEF, $FFFF vuoto */
        if ((s16)H005_W(0x2810) > 0) {
            /* A+$18A: (word) id della mappa GEO caricata (ricaricata al Load) */
            load_geo_map(COK_GET16(g_state_a + 0x18A));
        }
        for (i = 1; i <= 3; ++i) {
            /* $2810: tab. 3 voci da 4 byte dei set di muri: word id WALLDEF, $FFFF vuoto */
            if ((s16)H005_W(0x2810 + (i - 1) * 4) > 0) {
                /* $2810: tab. 3 voci da 4 byte dei set di muri: word id WALLDEF, $FFFF vuoto */
                load_wall_defs(H005_W(0x2810 + (i - 1) * 4),
                          /* $2812: word +2 delle voci $2810: posizione (slot 1..3), $FFFF vuoto */
                          H005_W(0x2810 + (i - 1) * 4 + 2));
            }
        }
    } else {
        load_big_picture(0x79);
    }
    clear_message_line();
    /* $3DE2: contesto di gioco precedente (copia di $3DE3), salvato; $3DE3: modo/contesto di gioco
     * corrente (0 menu, 1 vista, 5 combattimento) */
    H005_B(0x3DE2) = H005_B(0x3DE3);
    H005_B(0x3DE3) = 0; /* $3DE3: modo di gioco (0 menu, 1 vista, 2 campo, 5 combattimento) */
}

/* Copie del record PC del mostro: (sorgente, destinazione, byte). */
static const u16 s_monster_copy[][3] = {
    { 0x010, 0x010, 0x48 }, { 0x059, 0x05A, 0x07 }, { 0x060, 0x062, 0x03 },
    { 0x063, 0x066, 0x6B }, { 0x0CE, 0x0D2, 0x07 }, { 0x0D5, 0x0DA, 0x3C },
    { 0x113, 0x11A, 0x03 }, { 0x116, 0x11E, 0x0B }, { 0x121, 0x12A, 0x05 },
    { 0x126, 0x130, 0x05 }, { 0x12B, 0x136, 0x05 }, { 0x130, 0x13C, 0x09 },
    { 0x139, 0x146, 0x43 }, { 0x17D, 0x18C, 0x18 }, { 0x197, 0x1A8, 0x02 }
};

/* Byte con segno del record PC in una word del personaggio: (sorgente, destinazione). */
static const u16 s_monster_signed[][2] = {
    { 0x058, 0x058 }, { 0x111, 0x116 }, { 0x112, 0x118 }, { 0x17C, 0x18A },
    { 0x195, 0x1A4 }, { 0x196, 0x1A6 }
};

/*
 * PORT H066+$1FE8: procedura annidata: nome del file del mostro
 * "MON" + disco + parte (CHA, SPC, ITM).
 */
static void monster_file_name(char *name, const char *num, u16 part_len,
                              const char *part)
{
    h026_copy(0x50, name, 3, "MON");
    h026_append(0x50, name, 1, num);
    h026_append(0x50, name, part_len, part);
}

/*
 * PORT H066+$1FDA (Load_MonsterRecord, corpo a $206A): carica in c il
 * mostro id dai blocchi di MONnCHA.dax (record PC: campi spostati, byte
 * con segno allargati a word, word e long girati), MONnSPC.dax (effetti
 * da 9 byte) e MONnITM.dax (oggetti da $3F byte).  Senza il record:
 * "Unable to load monster" e uscita.  I puntatori del record (effetti,
 * oggetti, successivo, blocco del turno) vengono azzerati come
 * nell'originale; gli oggetti pronti (+$154..), che nell'originale
 * restano i byte del file, qui sono vuoti.
 */
void load_monster_record(u16 id, Character *c)
{
    char num[0x12];                     /* -$66(a5) */
    char name[0x52];                    /* -$54(a5) */
    u16 size = 0;                       /* -$56(a5) */
    u8 *data = NULL;                    /* -$5A(a5) */
    u16 pos;                            /* -$5C(a5) */
    CokItem *it;                        /* -$60(a5) */
    CokEffect *fx;                      /* -$64(a5) */
    u8 i;                               /* -$1(a5) */

    /* $246E: disco dei dati / gruppo di risorse corrente (G_RESOURCE_GROUP) */
    format_number(1, num, (s32)H005_B(0x246E), 0, 0x0A, 1, '0');
    monster_file_name(name, num, 3, "CHA");
    dax_load_block(0x50, name, 4, ".dax", id, &size, &data);
    if (size == 0) {
        /* $246E: disco dei dati / gruppo di risorse corrente (G_RESOURCE_GROUP) */
        error_message(5, "cdisk", H005_B(0x246E));
        error_message(0x50, name, id);
        show_message_wait(0x0F, 0, 0x16, "Unable to load monster");
        quit_game();
    }
    exec_copy_mem(data + 1, c->b, 0x0F);
    c->b[0x0F] = 0; /* pg+$F: terminatore del nome (azzerato al caricamento dei mostri) */
    for (i = 0; i < sizeof(s_monster_copy) / sizeof(s_monster_copy[0]); ++i) {
        exec_copy_mem(data + s_monster_copy[i][0], c->b + s_monster_copy[i][1],
                      s_monster_copy[i][2]);
    }
    for (i = 0; i < sizeof(s_monster_signed) / sizeof(s_monster_signed[0]); ++i) {
        CH_PUTW(c, s_monster_signed[i][1],
                (u16)h031_signed_byte(data[s_monster_signed[i][0]]));
    }
    h031_swap_long(c->b + 0x11E); /* pg+$11E: punti esperienza (long) */
    h031_swap_word(c->b + 0x62); /* pg+$62: eta' (word) */
    h031_swap_word(c->b + 0x13C); /* pg+$13C: esperienza data dal mostro sconfitto (word) */
    for (i = 0; i <= 6; ++i) {
        /* pg+$F0: monete, 7 word passo 2 (0..4 monete, 4 acciaio, 5 gemme, 6 gioielli) */
        h031_swap_word(c->b + 0xF0 + i * 2);
    }
    h031_swap_word(c->b + 0x18C); /* pg+$18C: ingombro: peso di oggetti e monete (word) */
    memset(c->b + 0x150, 0, 4); /* pg+$150: puntatore alla lista degli oggetti (long; sull'host c->items) */
    memset(c->b + 0xE8, 0, 4); /* pg+$E8: puntatore alla lista degli effetti (long; sull'host c->effects) */
    memset(c->b + 0x18E, 0, 4); /* pg+$18E: puntatore al personaggio seguente del party (long) */
    memset(c->b + 0x192, 0, 4); /* pg+$192: puntatore al blocco del turno di combattimento (long) */
    c->items = NULL;
    c->effects = NULL;
    c->next = NULL;
    c->block_192 = NULL;
    memset(c->readied, 0, sizeof(c->readied));
    exec_free_mem(data, size);

    H005_B(0x24A4) = 1; /* $24A4: uso: argomento ignorato di Open_ResourceFile; 1 caricando SPC */
    monster_file_name(name, num, 3, "SPC");
    dax_load_block(0x50, name, 4, ".dax", id, &size, &data);
    if (size != 0) {
        pos = 0;
        c->effects = (CokEffect *)exec_alloc_mem(sizeof(CokEffect),
                                                 COK_MEMF_CLEAR);
        fx = c->effects;
        do {
            exec_copy_mem(data + pos, fx->b, 1);
            /* eff+$2: (word) durata residua dell'effetto, scalata col tempo; 0 = permanente */
            exec_copy_mem(data + pos + 1, fx->b + 2, 8);
            /* eff+$2: (word) durata residua dell'effetto, scalata col tempo; 0 = permanente */
            h031_swap_word(fx->b + 2);
            /* eff+$6: (long) puntatore al successivo nell'originale, azzerato al carico */
            memset(fx->b + 6, 0, 4);
            fx->next = NULL;
            pos = (u16)(pos + 9);
            if (pos < (u16)(size - 0x100)) {
                fx->next = (CokEffect *)exec_alloc_mem(sizeof(CokEffect),
                                                       COK_MEMF_CLEAR);
                fx = fx->next;
            }
        } while (pos < (u16)(size - 0x100));
        exec_free_mem(data, size);
    }

    monster_file_name(name, num, 3, "ITM");
    dax_load_block(0x50, name, 4, ".dax", id, &size, &data);
    if (size != 0) {
        pos = 0;
        c->items = (CokItem *)exec_alloc_mem(sizeof(CokItem), COK_MEMF_CLEAR);
        it = c->items;
        do {
            exec_copy_mem(data + pos, it->b, 0x28);
            it->b[0x28] = 0; /* ogg+$28: terminatore del nome (+$00..+$27), posto a 0 */
            /* ogg+$2A: flag intestazione: copiato in header della voce di menu */
            exec_copy_mem(data + pos + 0x29, it->b + 0x2A, 1);
            /* ogg+$2C: (long) puntatore al successivo nell'originale, azzerato al carico */
            exec_copy_mem(data + pos + 0x2A, it->b + 0x2C, 5);
            /* ogg+$32: parola 1 del nome (indice 1-based in H005+$406E, $16 byte) */
            exec_copy_mem(data + pos + 0x2F, it->b + 0x32, 3);
            /* ogg+$36: (word) bonus magico (+n) dell'oggetto, con segno */
            COK_PUT16(it->b + 0x36, (u16)h031_signed_byte(data[pos + 0x32]));
            /* ogg+$38: (word) secondo bonus, sommato a CH +$18A quando pronto */
            COK_PUT16(it->b + 0x38, (u16)h031_signed_byte(data[pos + 0x33]));
            /* ogg+$3A: flag oggetto pronto all'uso (Ready) */
            exec_copy_mem(data + pos + 0x34, it->b + 0x3A, 3);
            /* ogg+$3E: (word) peso unitario dell'oggetto */
            exec_copy_mem(data + pos + 0x37, it->b + 0x3E, 3);
            /* ogg+$42: (word) valore in monete (Sell offre la meta') */
            exec_copy_mem(data + pos + 0x3A, it->b + 0x42, 5);
            h031_swap_word(it->b + 0x3E); /* ogg+$3E: (word) peso unitario dell'oggetto */
            h031_swap_word(it->b + 0x42); /* ogg+$42: (word) valore in monete (Sell offre la meta') */
            /* ogg+$2C: (long) puntatore al successivo nell'originale, azzerato al carico */
            memset(it->b + 0x2C, 0, 4);
            it->next = NULL;
            pos = (u16)(pos + 0x3F);
            if (pos < (u16)(size - 0x100)) {
                it->next = (CokItem *)exec_alloc_mem(sizeof(CokItem),
                                                     COK_MEMF_CLEAR);
                it = it->next;
            }
        } while (pos < (u16)(size - 0x100));
        exec_free_mem(data, size);
    }
    H005_B(0x24A4) = 0; /* $24A4: uso: argomento ignorato di Open_ResourceFile; 1 caricando SPC */
}
