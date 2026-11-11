/* H042: sequenze grafiche, cache, HEAD/BODY e BIGPIC. */
#include "h042_seq.h"
#include "h003_exec.h"
#include "h029_gfx.h"
#include "globals.h"
#include <string.h>
#include "h002_dos.h"
#include "h010_input.h"
#include "h016_gfx.h"
#include "h020_io.h"
#include "h022_view.h"
#include "h023_shared.h"
#include "h026_string.h"
#include "h028_files.h"
#include "h030.h"
#include "h036.h"
#include "h044_tiles.h"
#include "h045.h"
#include "h049.h"
#include "h087.h"

u8 g_h042_m1;                   /* -$1(a4) */
u8 g_h042_m2;                   /* -$2(a4) */

/* PORT H042+$0146 */
void h042_init(void)
{
    g_h042_m1 = 0;
    g_h042_m2 = 0;
}

/*
 * PORT H042+$0300: libera l'insieme di immagini di H005+$27BC (sempre
 * quello: l'argomento dell'originale e' sempre H005+$27BC).  Le due
 * immagini, i blocchi 2..conteggio (dimensioni a $27DA), azzera il
 * conteggio, svuota il nome a $27A6 e mette $FF in $2486.
 */
void release_picture_set(void)
{
    u16 i;

    g_h042_m1 = 0;
    free_gfx_record(&g_pic_rec_27c2);
    free_gfx_record(&g_pic_rec_27c6);
    /* $27BC: (word) fotogrammi della sequenza caricata (max 6), base del blocco */
    for (i = 2; i <= H005_W(0x27BC); ++i) {
        if (g_pic_buffers[i - 2] != NULL) {
            /* $27DA: tab. 7 word: dim. compressa dei fotogrammi 2..n (idx frame-2) */
            exec_free_mem(g_pic_buffers[i - 2], H005_W(0x27DA + (i - 2) * 2));
            g_pic_buffers[i - 2] = NULL;
        }
    }
    H005_SET_W(0x27BC, 0); /* $27BC: (word) fotogrammi della sequenza caricata (max 6), base del blocco */
    /* $27A6: nome (8 car.) della sequenza di immagini caricata, vuoto se nessuna */
    H005_B(0x27A6) = 0;                 /* stringa vuota (dbeq con $8) */
    H005_B(0x2486) = 0xFF; /* $2486: id della sequenza caricata in $27BC (nome a $27A6), $FF nessuna */
}

#define SEQ_COUNT   0x27BC              /* +$0: fotogrammi */
#define SEQ_CURRENT 0x27BE              /* +$2: fotogramma corrente */
#define SEQ_LAST    0x27C0              /* +$4: fotogramma in g_pic_rec_27c6 */
#define SEQ_EXTRA   0x27CA              /* +$E: due byte per fotogramma */
#define SEQ_PSIZE   0x27DA              /* +$1E: dimensioni compresse 2.. */

/*
 * PORT H042+$01AE: sostituisce il record con la sua copia specchiata in
 * orizzontale (H049+$09D6), con la maschera se c'era.
 */
static void mirror_record(struct GfxRecord **rec)
{
    struct GfxRecord *copy = NULL;      /* -$4(a5) */
    u16 with_mask;                      /* -$6(a5) */

    if (*rec == NULL) {
        return;
    }
    with_mask = (u16)((*rec)->mask != NULL ? 1 : 0);
    allocate_gfx_record((*rec)->rows, (*rec)->count, (*rec)->width8,
                        with_mask, &copy);
    copy->w4 = (*rec)->w4;
    copy->w6 = (*rec)->w6;
    mirror_gfx_record(*rec, copy);
    free_gfx_record(rec);
    *rec = copy;
}

/*
 * PORT H042+$0254: mostra il record alla cella (x, y) con la palette di
 * $52AE.  flag non e' usato.
 */
void show_picture(u16 x, u16 y, u8 flag, struct GfxRecord *rec)
{
    (void)flag;
    if (rec == NULL) {
        return;
    }
    copy_intuition_colors();
    begin_screen_update();
    /* $52AE: palette corrente dello schermo, RGB4 (16 o 32 colori) */
    graphics_load_rgb4(&g_screen->ViewPort, &g_h005[0x52AE], 0x20);
    restore_screen_cell(x, y, rec);
    end_screen_update();
}

/* PORT H042+$02B2: la testa alla cella (x, y). */
static void show_head(struct GfxRecord *rec, u16 x, u16 y)
{
    show_picture(x, y, 0, rec);
}

/* PORT H042+$02D6: il corpo, 5 celle sotto la testa. */
static void show_body(struct GfxRecord *rec, u16 x, u16 y)
{
    show_picture(x, (u16)(y + 5), 0, rec);
}

/* PORT H042+$03BC: dst = src XOR dst (fotogrammi salvati come differenza). */
static void xor_bitmap(struct BitMap *src, struct BitMap *dst)
{
    (void)graphics_blt_bitmap(src, 0, 0, dst, 0, 0,
                              (u16)(dst->BytesPerRow << 3), dst->Rows, 0x60,
                              0xFF, NULL);
}

/*
 * PORT H042+$0406 (Load_Sequence): carica la sequenza id di name+disco.daa
 * nell'insieme $27BC (l'argomento dell'originale e' sempre quello), se
 * diversa dalla attuale.  Directory: word della dimensione, voci di 6
 * byte (id, un byte, offset long).  Blocco: intestazione compressa
 * (righe, unita', w4, w6, fotogrammi, palette di 32 colori per $52AE,
 * dimensioni compresse), poi ogni fotogramma ByteRun1 seguito da due
 * byte.  Il primo diventa g_pic_rec_27c2; con due fotogrammi il secondo
 * e' gia' decodificato in g_pic_rec_27c6 (salvato come XOR col primo),
 * con piu' fotogrammi restano compressi in g_pic_buffers.  Le immagini
 * PIC e FINAL non hanno trasparenza e, senza $24D4, un solo fotogramma.
 * A caso (H023+$0010) le immagini vengono specchiate.  Piu' di 6
 * fotogrammi leggerebbero oltre l'intestazione: qui al massimo 6.
 */
void load_sequence(u16 name_len, const char *name, u16 id, u16 with_mask)
{
    char local[0x52];                   /* -$52(a5) */
    char num[2];                        /* -$62(a5) */
    u8 dir_raw[2];                      /* -$72(a5) */
    u16 dir_size;
    cok_bptr file;                      /* -$70(a5) */
    u8 entry[6];                        /* -$68(a5) */
    u8 head_size_raw[2];                /* -$CC(a5) */
    u16 head_size;
    u8 head[0x56];                      /* -$CA(a5) */
    u8 *packed;                         /* -$5A(a5) */
    u8 *planes = NULL;                  /* -$56(a5) */
    u8 *src;                            /* -$D6(a5) */
    u8 *dst;                            /* -$DA(a5) */
    struct BitMap *saved_mask;          /* -$DE(a5) */
    u16 plane_bytes = 0;                /* -$5E(a5) */
    u16 frames;                         /* -$C2(a5) */
    u16 k;                              /* -$5C(a5) */
    u8 color;                           /* -$D0(a5) */
    u8 is_pic;                          /* -$5F(a5) */
    s32 pos;

    h026_copy(0x50, local, name_len, name);
    /* $27A6: nome (8 car.) della sequenza di immagini caricata, vuoto se nessuna */
    if ((h026_compare_nocase(0x50, local, 8, (const char *)&g_h005[0x27A6]) == 1 &&
         /* $2486: id della sequenza caricata in $27BC (nome a $27A6), $FF nessuna */
         H005_B(0x2486) == id) || id == 0xFF) {
        return;
    }
    g_h042_m2 = (u8)(random_below(2) == 1);
    if (H005_B(0x24D4)) { /* $24D4: Animation on/off (Alter): piu' fotogrammi e "Loading..." */
        fill_text_cells(0, 0x18, 0, 0x28);
        ui_draw_text(0, 0x18, 0x0A, 0, 0x15, "Loading...Please Wait");
    }
    /* $27A6: nome (8 car.) della sequenza di immagini caricata, vuoto se nessuna */
    h026_copy(8, (char *)&g_h005[0x27A6], 0x50, local);
    H005_B(0x2486) = (u8)id; /* $2486: id della sequenza caricata in $27BC (nome a $27A6), $FF nessuna */
    is_pic = (u8)(h026_compare_nocase(0x50, local, 3, "PIC") == 1 ||
                  h026_compare_nocase(0x50, local, 5, "FINAL") == 1);
    /* $246E: disco dei dati / gruppo di risorse corrente (G_RESOURCE_GROUP) */
    format_number(1, num, (s32)H005_B(0x246E), 0, 0x0A, 1, '0');
    h026_append(0x50, local, 1, num);
    if (!dax_open(0x50, local, 4, ".daa", dir_raw, &file)) {
        console_write(0x2D, "Could not open indexed file in loadsequence!\n");
        return;
    }
    dir_size = COK_GET16(dir_raw);
    do {
        (void)dos_read(file, entry, 6);
        if (entry[0] == id) {
            break;
        }
        pos = dos_seek(file, 0, OFFSET_CURRENT);
    } while (pos < (s32)dir_size);
    if (entry[0] != id) {
        dos_close(file);
        return;
    }
    release_picture_set();
    /* $27A6: nome (8 car.) della sequenza di immagini caricata, vuoto se nessuna */
    h026_copy(8, (char *)&g_h005[0x27A6], name_len, name);
    H005_B(0x2486) = (u8)id; /* $2486: id della sequenza caricata in $27BC (nome a $27A6), $FF nessuna */
    (void)dos_seek(file, (s32)dir_size + (s32)COK_GET32(entry + 2),
                   OFFSET_BEGINNING);

    /* Intestazione. */
    (void)dos_read(file, head_size_raw, 2);
    head_size = COK_GET16(head_size_raw);
    packed = (u8 *)exec_alloc_mem(head_size, 0);
    (void)dos_read(file, packed, head_size);
    src = packed;
    dst = head;
    if (ilbm_unpack_row(&src, &dst, (s16)head_size, 0x56)) {
        console_write(0x25, "Error unpacking row in LoadSequence!\n");
    }
    exec_free_mem(packed, head_size);
    /* $52AE: palette corrente dello schermo, RGB4 (16 o 32 colori) */
    exec_copy_mem(head + 0x0A, &g_h005[0x52AE], 0x40);
    H005_SET_W(0x52AE, 0); /* $52AE: palette corrente dello schermo, RGB4 (16 o 32 colori) */

    /* Primo fotogramma. */
    packed = (u8 *)exec_alloc_mem(COK_GET16(head + 0x4A), 0);
    (void)dos_read(file, packed, COK_GET16(head + 0x4A));
    /* $27CA: tab. word per fotogramma (idx frame-1): durata in 1/10 s */
    (void)dos_read(file, &g_h005[SEQ_EXTRA], 2);
    g_pic_rec_27c6 = NULL;
    allocate_gfx_record(COK_GET16(head), COK_GET16(head + 2), 1, with_mask,
                        &g_pic_rec_27c2);
    g_pic_rec_27c2->w4 = COK_GET16(head + 4);
    g_pic_rec_27c2->w6 = COK_GET16(head + 6);
    plane_bytes = g_pic_rec_27c2->plane_bytes;
    planes = (u8 *)exec_alloc_mem(plane_bytes, 0);
    src = packed;
    dst = planes;
    if (ilbm_unpack_row(&src, &dst, (s16)COK_GET16(head + 0x4A),
                        (s16)plane_bytes)) {
        console_write(0x29, "Error calling UnPackRow in LoadSequence!\n");
    }
    exec_free_mem(packed, COK_GET16(head + 0x4A));
    color = (u8)(is_pic ? 0 : 0x0D);
    transfer_gfx_planes(planes, 0, 4, color, &g_pic_rec_27c2);
    g_h042_m1 = g_h042_m2;
    if (g_h042_m2) {
        mirror_record(&g_pic_rec_27c2);
    }
    frames = COK_GET16(head + 8);
    if (!H005_B(0x24D4) && is_pic) { /* $24D4: Animation on/off (Alter): piu' fotogrammi e "Loading..." */
        frames = 1;
    }
    if (frames > 6) {
        frames = 6;
    }
    /* $27BC: (word) fotogrammi della sequenza caricata (max 6), base del blocco */
    H005_SET_W(SEQ_COUNT, frames);
    H005_SET_W(SEQ_CURRENT, 1); /* $27BE: (word) fotogramma corrente dell'animazione della sequenza (1..n) */
    H005_SET_W(SEQ_LAST, 0); /* $27C0: (word) fotogramma attualmente in g_pic_rec_27c6 (0 nessuno) */
    if (frames >= 2) {
        allocate_gfx_record(COK_GET16(head), COK_GET16(head + 2), 1,
                            with_mask, &g_pic_rec_27c6);
        g_pic_rec_27c6->w4 = COK_GET16(head + 4);
        g_pic_rec_27c6->w6 = COK_GET16(head + 6);
        if (frames == 2) {
            packed = (u8 *)exec_alloc_mem(COK_GET16(head + 0x4C), 0);
            (void)dos_read(file, packed, COK_GET16(head + 0x4C));
            /* $27CC: (word) durata del 2o fotogramma (voce 2 della tabella $27CA) */
            (void)dos_read(file, &g_h005[SEQ_EXTRA + 2], 2);
            src = packed;
            dst = planes;
            (void)ilbm_unpack_row(&src, &dst, (s16)COK_GET16(head + 0x4C),
                                  (s16)plane_bytes);
            exec_free_mem(packed, COK_GET16(head + 0x4C));
            saved_mask = g_pic_rec_27c6->mask;
            g_pic_rec_27c6->mask = NULL;
            transfer_gfx_planes(planes, 0, 4, color, &g_pic_rec_27c6);
            if (g_h042_m2) {
                mirror_record(&g_pic_rec_27c6);
            }
            xor_bitmap(g_pic_rec_27c2->image, g_pic_rec_27c6->image);
            if (saved_mask != NULL) {
                g_pic_rec_27c6->mask = saved_mask;
                build_gfx_mask(color, g_pic_rec_27c6);
            }
            H005_SET_W(SEQ_LAST, 2); /* $27C0: (word) fotogramma attualmente in g_pic_rec_27c6 (0 nessuno) */
        } else {
            for (k = 2; k <= frames; ++k) {
                u16 size = COK_GET16(head + 0x4A + (k - 1) * 2);

                g_pic_buffers[k - 2] = (u8 *)exec_alloc_mem(size, 0);
                (void)dos_read(file, g_pic_buffers[k - 2], size);
                /* $27CA: tab. word per fotogramma (idx frame-1): durata in 1/10 s */
                (void)dos_read(file, &g_h005[SEQ_EXTRA + (k - 1) * 2], 2);
                /* $27DA: tab. 7 word: dim. compressa dei fotogrammi 2..n (idx frame-2) */
                H005_SET_W(SEQ_PSIZE + (k - 2) * 2, size);
            }
        }
    }
    if (planes != NULL) {
        exec_free_mem(planes, plane_bytes);
    }
    dos_close(file);
    if (H005_B(0x24D4)) { /* $24D4: Animation on/off (Alter): piu' fotogrammi e "Loading..." */
        fill_text_cells(0, 0x18, 0, 0x28);
    }
}

/*
 * PORT H042+$0B80: il record del fotogramma frame (1..conteggio) della
 * sequenza $27BC.  Il primo e quello gia' in g_pic_rec_27c6 con una pausa
 * di 11 tick; gli altri si decomprimono in g_pic_rec_27c6 come XOR col
 * primo.  Fuori dall'intervallo NULL.  La prima volta, se la sequenza va
 * specchiata, specchia i record gia' pronti.
 */
struct GfxRecord *sequence_frame(u16 frame)
{
    u8 *buf;                            /* -$4(a5) */
    u16 n;                              /* -$6(a5) */
    u8 *src;                            /* -$C(a5) */
    u8 *dst;                            /* -$10(a5) */
    struct BitMap *saved_mask;          /* -$14(a5) */

    if (g_h042_m2 && !g_h042_m1) {
        g_h042_m1 = 1;
        mirror_record(&g_pic_rec_27c2);
        /* $27BC: (word) fotogrammi della sequenza caricata (max 6), base del blocco */
        if (H005_W(SEQ_COUNT) == 2) {
            mirror_record(&g_pic_rec_27c6);
        }
    }
    /* $27BC: (word) fotogrammi della sequenza caricata (max 6), base del blocco */
    if (frame < 1 || frame > H005_W(SEQ_COUNT)) {
        return NULL;
    }
    /* $27C0: (word) fotogramma attualmente in g_pic_rec_27c6 (0 nessuno) */
    if (frame == 1 || frame == H005_W(SEQ_LAST)) {
        dos_delay(0x0B);
        return frame == 1 ? g_pic_rec_27c2 : g_pic_rec_27c6;
    }
    n = g_pic_rec_27c6->plane_bytes;
    buf = (u8 *)exec_alloc_mem(n, 0);
    src = g_pic_buffers[frame - 2];
    dst = buf;
    /* $27DA: tab. 7 word: dim. compressa dei fotogrammi 2..n (idx frame-2) */
    if (ilbm_unpack_row(&src, &dst, (s16)H005_W(SEQ_PSIZE + (frame - 2) * 2),
                        (s16)n)) {
        console_write(0x24, "Error in UnPackRow in loadSequence!\n");
    }
    saved_mask = g_pic_rec_27c6->mask;
    g_pic_rec_27c6->mask = NULL;
    transfer_gfx_planes(buf, 0, 4, 0, &g_pic_rec_27c6);
    if (g_h042_m1) {
        mirror_record(&g_pic_rec_27c6);
    }
    xor_bitmap(g_pic_rec_27c2->image, g_pic_rec_27c6->image);
    if (saved_mask != NULL) {
        g_pic_rec_27c6->mask = saved_mask;
        build_gfx_mask(0x0D, g_pic_rec_27c6);
    }
    H005_SET_W(SEQ_LAST, frame); /* $27C0: (word) fotogramma attualmente in g_pic_rec_27c6 (0 nessuno) */
    exec_free_mem(buf, n);
    return g_pic_rec_27c6;
}

/*
 * PORT H042+$0D70 (Load_HeadBody): carica testa e corpo (HEADn/BODYn.daa)
 * se diversi da quelli gia' caricati ($27B0, $27B6); $FF li lascia.
 */
void load_head_body(u16 head, u16 body)
{
    char num[2];                        /* -$2(a5) */
    char name[0x2A];                    /* -$2C(a5) */

    /* $246E: disco dei dati / gruppo di risorse corrente (G_RESOURCE_GROUP) */
    format_number(1, num, (s32)H005_B(0x246E), 0, 0x0A, 1, '0');
    /* $27B0: 2 voci da 6 byte (id + long gfx a +2): id HEAD caricato, $FF nessuno */
    if (head != 0xFF && (H005_B(0x27B0) == 0xFF || H005_B(0x27B0) != head)) {
        strcpy(name, "HEAD");
        h026_append(0x28, name, 1, num);
        load_indexed_gfx_record(0x28, name, head, 0, 0, &g_gfx_27b0[0]);
        if (g_gfx_27b0[0] == NULL) {
            show_message_wait(0x0E, 0, 0x0E, "head NOT found");
        }
        /* $27B0: 2 voci da 6 byte (id + long gfx a +2): id HEAD caricato, $FF nessuno */
        H005_B(0x27B0) = (u8)head;
    }
    /* $27B6: id del BODY caricato (2a voce da 6 byte di $27B0), $FF nessuno */
    if (body != 0xFF && (H005_B(0x27B6) == 0xFF || H005_B(0x27B6) != body)) {
        strcpy(name, "BODY");
        h026_append(0x28, name, 1, num);
        load_indexed_gfx_record(0x28, name, body, 0, 0, &g_gfx_27b0[1]);
        if (g_gfx_27b0[1] == NULL) {
            show_message_wait(0x0E, 0, 0x0E, "head not found");
        }
        H005_B(0x27B6) = (u8)body; /* $27B6: id del BODY caricato (2a voce da 6 byte di $27B0), $FF nessuno */
    }
}

/*
 * PORT H042+$0ED2: mostra testa (e con flag il corpo sotto) alla cella
 * (x, y), con la palette caricata ($522E -> $52AE).
 */
void draw_head_body(u16 x, u16 y, u8 flag)
{
    /* $522E: palette dell'immagine caricata, 32 colori RGB4 ($40 byte); $52AE: palette corrente
     * dello schermo, RGB4 (16 o 32 colori) */
    exec_copy_mem(&g_h005[0x522E], &g_h005[0x52AE], 0x40);
    copy_intuition_colors();
    begin_screen_update();
    if (flag) {
        show_head(g_gfx_27b0[0], x, y);
        show_body(g_gfx_27b0[1], x, y);
    } else {
        show_picture(x, y, 0, g_gfx_27b0[0]);
    }
    end_screen_update();
}

/*
 * PORT H042+$0F50 (Show3DSprite): il fotogramma 1..3 della sequenza
 * (sprite dell'incontro a distanza) mascherato nella vista.
 */
void show_3d_sprite(u16 frame)
{
    struct GfxRecord *rec;              /* -$6(a5) */

    if (frame < 1 || frame > 3) {
        console_writeln(0x1E, "Illegal range in Show3DSprite.");
        quit_game();
    }
    rec = sequence_frame(frame);
    if (rec != NULL) {
        /* $52AE: palette corrente dello schermo, RGB4 (16 o 32 colori) */
        graphics_load_rgb4(&g_screen->ViewPort, &g_h005[0x52AE], 0x20);
        (void)queue_bitplane_blit(rec->image, 0, 0, &g_screen->RastPort,
                                  0x18, 0x18, 0x58, 0x58, 0xCA,
                                  (u8 *)rec->mask->Planes[0]);
    }
}

/*
 * PORT H042+$1006 (Load_BigPicture): libera la sequenza e, se diversa da
 * quella caricata ($2484), carica l'immagine grande id di BIGPICn.daa in
 * $2798 con la sua palette ($522E -> $526E).
 */
void load_big_picture(u16 id)
{
    char name[0x2A];                    /* -$2C(a5) */
    char num[2];                        /* -$2E(a5) */
    u16 i;                              /* -$2(a5) */

    release_picture_set();
    if (H005_B(0x2484) == id) { /* $2484: id dell'immagine grande BIGPIC caricata ($FF nessuna) */
        return;
    }
    strcpy(name, "BIGPIC");
    /* $246E: disco dei dati / gruppo di risorse corrente (G_RESOURCE_GROUP) */
    format_number(1, num, (s32)H005_B(0x246E), 0, 0x0A, 1, '0');
    h026_append(0x28, name, 1, num);
    load_indexed_gfx_record(0x28, name, id, 0, 0, &g_gfx_2798);
    for (i = 0; i <= 0x1F; ++i) {
        /* $522E: palette dell'immagine caricata, 32 colori RGB4 ($40 byte); $526E: palette
         * dell'immagine grande (mappa all'aperto), 32 colori */
        H005_SET_W(0x526E + i * 2, H005_W(0x522E + i * 2));
    }
    H005_B(0x2484) = (u8)id; /* $2484: id dell'immagine grande BIGPIC caricata ($FF nessuna) */
}

/*
 * PORT H042+$10DC: mostra l'immagine grande (mappa all'aperto) nella
 * cornice dell'aperto, con la sua palette.
 */
void show_big_picture(void)
{
    copy_intuition_colors();
    begin_screen_update();
    draw_wild_frame();
    /* $526E: palette dell'immagine grande (mappa all'aperto), 32 colori */
    graphics_load_rgb4(&g_screen->ViewPort, &g_h005[0x526E], 0x20);
    restore_screen_cell(1, 1, g_gfx_2798);
    end_screen_update();
}
