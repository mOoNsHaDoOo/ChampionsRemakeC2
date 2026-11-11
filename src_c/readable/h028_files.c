/* H028: file, richieste disco, caricamento per ID e RLE dei DAX. */
#include "h028_files.h"
#include "h002_dos.h"
#include "h021_intuition.h"
#include "h026_string.h"
#include "h003_exec.h"
#include "h031.h"
#include "h040.h"
#include "h041.h"
#include "unported.h"
#include "h014.h"
#include "globals.h"
#include "h010_input.h"

u8  g_h028_mf9;                 /* -$F9(a4) */
struct BitMap *g_char_screen_s; /* -$AA(a4): "charS.LBM" */
struct BitMap *g_char_screen_t; /* -$AE(a4): "charT.LBM" */
char g_h028_m52[0x52];          /* -$52(a4): directory alternativa, mai
                                   scritta nell'asm, quindi sempre "" */

/* PORT H028+$01B8 */
void h028_init(void)
{
    g_h028_mf9 = 0;
    g_char_screen_s = NULL;
    g_char_screen_t = NULL;
}

/*
 * PORT H028+$02D0: 1 se Lock(name, ACCESS_READ) riesce (il lock viene
 * subito rilasciato), altrimenti 0.  L'originale copia prima il nome sullo
 * stack ((len + 1) arrotondato a pari); Lock legge solo fino al NUL, quindi
 * qui si passa direttamente la stringa.
 */
u8 file_exists(u16 len, const char *name)
{
    cok_bptr lock;

    (void)len;
    lock = dos_lock(name, ACCESS_READ);
    if (lock == 0) {
        return 0;
    }
    dos_unlock(lock);
    return 1;
}

/*
 * PORT H028+$01C6: richiesta "Retry"/"CANCEL" con il testo dato sulla
 * finestra del gioco (320x70).  Il risultato non e' usato.  L'originale
 * copia prima il testo sullo stack; qui si usa direttamente.  I primi due
 * argomenti non sono letti.
 */
void disk_request(u16 unused1, u16 unused2, u16 len, char *text)
{
    struct IntuiText body;
    struct IntuiText retry;
    struct IntuiText cancel;

    (void)len;
    (void)unused1;
    (void)unused2;
    body.FrontPen = 3;
    body.BackPen = 1;
    body.DrawMode = 1;
    body.LeftEdge = 0x0A;
    body.TopEdge = 0x0A;
    body.ITextFont = NULL;
    body.IText = (UBYTE *)text;
    body.NextText = NULL;

    retry.FrontPen = 2;
    retry.BackPen = 1;
    retry.DrawMode = 1;
    retry.LeftEdge = 3;
    retry.TopEdge = 3;
    retry.ITextFont = NULL;
    retry.IText = (UBYTE *)"Retry";
    retry.NextText = NULL;

    cancel = retry;
    cancel.IText = (UBYTE *)"CANCEL";

    (void)intuition_auto_request(g_window, &body, &retry, &cancel, 0x8000, 0,
                                 0x140, 0x46);
}

/*
 * PORT H028+$0408: divide name in volume/percorso fino ai primi ':' (dir),
 * nome (base) ed estensione dal primo '.' entro $4F caratteri (ext).  Senza
 * ':' base non viene scritta (come nell'originale: il ramo e' saltato).
 * L'originale lavora su una copia di name sullo stack; qui una copia locale
 * di $52 byte, che basta per i nomi passati dal gioco.
 */
static void split_resource_name(u16 name_len, const char *name,
                                u16 dir_max, char *dir, u16 base_max,
                                char *base, u16 ext_max, char *ext)
{
    char copy[0x52];
    s16 dot;
    s16 colon;
    s16 len;
    s16 i;

    h026_copy(sizeof(copy) - 1, copy, name_len, name);
    dot = h026_find_char(name_len, copy, '.', 0, 0x4F);
    len = (s16)h026_strlen(name_len, copy);
    if (dot >= 0) {
        h026_substr(ext_max, ext, name_len, copy, (u16)dot, (u16)(len - dot));
        h026_delete(name_len, copy, (u16)dot, (u16)(len - dot));
    } else {
        h026_copy(ext_max, ext, 0, "");
    }

    len = (s16)h026_strlen(name_len, copy);
    colon = 0;
    if (len > 0) {
        for (i = (s16)(len - 1); i >= 0; --i) {
            if (copy[i] == ':') {
                colon = (s16)(i + 1);
            }
        }
        h026_substr(base_max, base, name_len, copy, (u16)colon,
                    (u16)(len - colon));
        h026_delete(name_len, copy, (u16)colon, (u16)(len - colon));
    }
    h026_copy(dir_max, dir, name_len, copy);
}

/*
 * PORT H028+$0576: apre dir + name se esiste; 1 se l'handle non e' nullo.
 */
static u8 try_open(cok_bptr *file, u16 dir_len, const char *dir,
                   u16 name_len, const char *name)
{
    char path[0x52];

    h026_copy(0x50, path, dir_len, dir);
    h026_append(0x50, path, name_len, name);
    if (!file_exists(0x50, path)) {
        return 0;
    }
    *file = dos_open(path, MODE_OLDFILE);
    return (u8)(*file != 0);
}

/*
 * PORT H028+$05FA (Open_ResourceFile): cerca il file nella directory del
 * prefisso dei dati (con "DF0:" sostituito dal disco del gruppo di risorse
 * corrente: 1 "Disk Two:", 2 "Disk Three:") e poi nel volume del nome (o
 * nella directory alternativa del modulo se il nome non ne ha).  Se non lo
 * trova chiede di inserire il disco e riprova all'infinito: il ramo che
 * restituirebbe 0 nell'originale non e' raggiungibile (moveq #0 / tst.b /
 * beq).  Restituisce 1 con l'handle in *file.
 */
u8 open_resource_file(u16 name_len, const char *name, u16 msg_len,
                      const char *msg, u8 unused, cok_bptr *file)
{
    char ext[0x52];             /* -$14C(a5) */
    char base[0x52];            /* -$FA(a5) */
    char dir[0x52];             /* -$A8(a5) */
    char text[0x52];            /* -$56(a5) */
    char disk[0x16];            /* -$162(a5) */

    (void)unused;
    split_resource_name(name_len, name, 0x50, dir, 0x50, base, 0x50, ext);
    h026_append(0x50, base, 0x50, ext);
    if (h026_compare_nocase(0x50, dir, 0, "") == 1) {
        h026_copy(0x50, dir, 0x50, g_h028_m52);
    }
    h026_copy(0x14, disk, 0x50, G_DATA_PREFIX);
    if (h026_compare_nocase(0x14, disk, 4, "DF0:") == 1) {
        /* $246E: disco dei dati / gruppo di risorse corrente (G_RESOURCE_GROUP) */
        switch (G_RESOURCE_GROUP) {
        case 1:
            h026_copy(0x14, disk, 9, "Disk Two:");
            break;
        case 2:
            h026_copy(0x14, disk, 0x0B, "Disk Three:");
            break;
        default:
            break;
        }
    }
    for (;;) {
        if (try_open(file, 0x14, disk, 0x50, base)) {
            return 1;
        }
        if (try_open(file, 0x50, dir, 0x50, base)) {
            return 1;
        }
        h026_copy(0x50, text, msg_len, msg);
        disk_request(0x0E, 0, 0x50, text);
    }
}

/*
 * PORT H028+$09DC (DAX_DecompressRLE): decomprime *comp_size byte di src
 * in dst (al massimo *raw_size byte, altrimenti errore H014 "uncompress
 * overuns buffer>").  Byte n di controllo: 0..$7E = n+1 byte letterali;
 * $7F..$FE = il byte seguente ripetuto $100-n volte; $FF ripete il tipo
 * dell'ultimo controllo.  All'inizio quel tipo non e' inizializzato
 * nell'originale (word sullo stack); qui vale -1, cioe' "salta il byte",
 * il ramo predefinito della tabella.
 */
static void dax_decompress_rle(const u8 *src, u8 *dst, u16 *comp_size,
                               u16 *raw_size)
{
    static const char overrun[] = "uncompress overuns buffer>";
    u16 si = 0;                 /* -$2 */
    u16 di = 0;                 /* -$4 */
    u16 n;                      /* -$8 */
    s16 kind = -1;              /* -$A */
    u16 j;                      /* -$6 */

    do {
        n = src[si];
        if (n <= 0x7E) {
            kind = 0;
        } else if (n >= 0x7F && n <= 0xFE) {
            kind = 1;
        }
        if (kind == 0) {
            if ((u16)(di + n + 1) <= *raw_size) {
                /*
                 * L'ultimo controllo di alcuni blocchi dichiara piu' byte di
                 * quelli rimasti: l'originale li legge oltre il buffer
                 * compresso.  Qui si copiano solo i byte presenti (il
                 * buffer ha 2 byte di margine) e il resto resta a zero.
                 */
                u32 avail = (u32)*comp_size + 2 - (u32)(u16)(si + 1);
                u32 want = (u32)(u16)(n + 1);

                exec_copy_mem(src + (u16)(si + 1), dst + di,
                              want < avail ? want : avail);
            } else {
                error_message(0x1A, overrun, (u16)(di + n + 1 - *raw_size));
            }
            si = (u16)(si + n + 2);
            di = (u16)(di + n + 1);
        } else if (kind == 1) {
            n = (u16)(0x100 - n);
            for (j = 0; j <= (u16)(n - 1); ++j) {
                if ((u16)(di + j) < *raw_size) {
                    dst[(u16)(di + j)] = src[(u16)(si + 1)];
                } else if ((u16)(di + j) == *raw_size) {
                    /*
                     * L'originale ammette l'indice *raw_size (<=) e scrive un
                     * byte oltre il buffer, nel margine di arrotondamento di
                     * AllocMem; in C quel byte non esiste e la scrittura si
                     * salta.
                     */
                } else {
                    error_message(0x1A, overrun, (u16)(di + j - *raw_size));
                }
                if (j == 0xFFFF) {
                    break;
                }
            }
            si = (u16)(si + 2);
            di = (u16)(di + n);
        } else {
            ++si;
        }
    } while (si < *comp_size);
}

/*
 * PORT H028+$0B80: apre name+ext con Open_ResourceFile (messaggio del disco
 * del gruppo di risorse corrente, H005+$3E08 + 30 * (gruppo - 1)) e legge
 * la word della dimensione della directory (byte come nel file).
 */
u8 dax_open(u16 name_len, const char *name, u16 ext_len,
                   const char *ext, u8 *dir_size, cok_bptr *file)
{
    char path[0x52];

    h026_copy(0x50, path, name_len, name);
    h026_append(0x50, path, ext_len, ext);
    if (!open_resource_file(0x50, path, 0x1D,
                            /* $3E08: messaggi di inserimento disco, 30 byte per gruppo di risorse */
                            (const char *)&g_h005[0x3E08 +
                                /* $246E: disco dei dati / gruppo di risorse corrente
                                 * (G_RESOURCE_GROUP) */
                                (s32)((s16)(G_RESOURCE_GROUP - 1) * 0x1E)],
                            /* $24A4: uso: argomento ignorato di Open_ResourceFile; 1 caricando SPC */
                            H005_B(0x24A4), file)) {
        return 0;
    }
    (void)dos_read(*file, dir_size, 2);
    return 1;
}

/*
 * PORT H028+$0DD8 (DAX_LoadBlock): cerca id nella directory del contenitore
 * name+ext (voci da 9 byte: id, offset long, dimensione, dimensione
 * compressa), legge il blocco e lo decomprime in *data (*size byte, $100
 * in piu' della dimensione dichiarata).  I file ".dax" sono little-endian:
 * directory e voci vengono girate (H031).  Blocco non trovato: *size = 0 e
 * *data = NULL.  Un blocco compresso oltre $A000 byte e' un errore fatale
 * (H010+$0332).
 *
 * Differenza: l'originale legge i campi direttamente nelle variabili
 * (memoria big-endian); qui si leggono in buffer di byte decodificati con
 * COK_GET16/32, identico sull'Amiga e corretto sull'host.
 */
void dax_load_block(u16 name_len, const char *name, u16 ext_len,
                    const char *ext, u16 id, u16 *size, u8 **data)
{
    cok_bptr file;              /* -$14 */
    u8 dir_raw[2];              /* -$16 */
    u16 dir_size;
    u8 entry_id = 0;            /* -$B */
    u8 offset_raw[4];           /* -$A */
    u8 size_raw[2];
    u8 comp_raw[2];             /* -$2 */
    u16 comp_size;
    u16 comp_saved;             /* -$4 */
    u16 count = 0;              /* -$78 */
    int little = h026_compare_nocase(ext_len, ext, 4, ".dax") == 1;

    if (!dax_open(name_len, name, ext_len, ext, dir_raw, &file)) {
        error_message(0x13, "could not open file", 0);
        *size = 0;
        *data = NULL;
        return;
    }
    if (little) {
        h031_swap_word(dir_raw);
    }
    dir_size = COK_GET16(dir_raw);
    if (little) {
        dir_size = (u16)(dir_size + 2);
    }
    for (;;) {
        ++count;
        (void)dos_read(file, &entry_id, 1);
        (void)dos_read(file, offset_raw, 4);
        (void)dos_read(file, size_raw, 2);
        (void)dos_read(file, comp_raw, 2);
        if (h026_compare_nocase(ext_len, ext, 4, ".dax") == 1) {
            h031_swap_word(size_raw);
            h031_swap_word(comp_raw);
            h031_swap_long(offset_raw);
        }
        *size = (u16)(COK_GET16(size_raw) + 0x100);
        comp_size = COK_GET16(comp_raw);
        if (comp_size > 0xA000 && entry_id == id) {
            dos_close(file);
            quit_game();
        }
        if (count > 0x3E7) {
            error_message(0x1C, "large limit in getdatablock>", count);
        }
        if (entry_id == id) {
            break;
        }
        if (!(dos_seek(file, 0, OFFSET_CURRENT) < (s32)dir_size)) {
            break;
        }
    }
    if (entry_id != id) {
        *size = 0;
        *data = NULL;
        dos_close(file);
        return;
    }
    /*
     * Due byte in piu' (azzerati): la decompressione puo' leggere il byte
     * dopo l'ultimo controllo, che nell'originale e' il margine di AllocMem.
     */
    g_dax_buffer = (u8 *)exec_alloc_mem((u32)comp_size + 2, COK_MEMF_CLEAR);
    *data = (u8 *)exec_alloc_mem(*size, COK_MEMF_CLEAR);
    (void)dos_seek(file, (s32)(dir_size + COK_GET32(offset_raw)),
                   OFFSET_BEGINNING);
    (void)dos_read(file, g_dax_buffer, comp_size);
    dos_close(file);
    comp_saved = comp_size;
    dax_decompress_rle(g_dax_buffer, *data, &comp_size, size);
    exec_free_mem(g_dax_buffer, (u32)comp_saved + 2);
}

/*
 * PORT H028+$0D74: se caricate (flag -$F9), libera le due schermate dei
 * personaggi (charS/charT: piani con H041+$00BE, BitMap di $28 byte).
 */
void free_char_screens(void)
{
    if (!g_h028_mf9) {
        return;
    }
    if (g_char_screen_s != NULL) {
        sized_free(g_char_screen_s->Planes[0]);
        exec_free_mem(g_char_screen_s, sizeof(struct BitMap));
    }
    if (g_char_screen_t != NULL) {
        sized_free(g_char_screen_t->Planes[0]);
        exec_free_mem(g_char_screen_t, sizeof(struct BitMap));
    }
    g_h028_mf9 = 0;
}

/*
 * PORT H028+$0C68: carica l'immagine ILBM name (parametro per valore) in
 * una BitMap nuova (*bitmap, $28 byte) con i piani di H041+$004A; i suoi
 * 32 colori vanno in H005+$522E ($40 byte), poi H005+$523E = colore 0 e
 * colore 0 = nero.  Messaggio del disco H005+$3E08.
 */
static void load_char_screen(u16 name_len, const char *name,
                             struct BitMap **bitmap)
{
    ILBMFrame frame;                    /* -$6e(a5) */
    cok_bptr file = 0;                  /* -$4(a5) */
    u16 i;

    *bitmap = (struct BitMap *)exec_alloc_mem(sizeof(struct BitMap),
                                              COK_MEMF_CLEAR);
    if (open_resource_file(name_len, name, 0x1D,
                           /* $3E08: messaggi di inserimento disco, 30 byte per gruppo di risorse */
                           (const char *)&g_h005[0x3E08], 0, &file) &&
        file != 0) {
        (void)read_ilbm(file, *bitmap, &frame, sized_alloc_chip);
        /*
         * CopyMem dei colori: nel frame sono word native, in H005
         * big-endian (sull'Amiga e' la stessa copia di $40 byte).
         */
        for (i = 0; i < 0x20; ++i) {
            /* $522E: palette dell'immagine caricata, 32 colori RGB4 ($40 byte) */
            H005_SET_W(0x522E + i * 2, frame.color_map[i]);
        }
        /* $522E: palette dell'immagine caricata, 32 colori RGB4 ($40 byte); $523E: (word) colore 8
         * della palette $522E (copia del colore 0) */
        H005_SET_W(0x523E, H005_W(0x522E));
        H005_SET_W(0x522E, 0); /* $522E: palette dell'immagine caricata, 32 colori RGB4 ($40 byte) */
        dos_close(file);
    }
}

/*
 * PORT H028+$0D36: carica una sola volta (flag -$F9) le schermate dei
 * personaggi "charS.LBM" e "charT.LBM".
 */
void load_char_screens(void)
{
    if (g_h028_mf9) {
        return;
    }
    load_char_screen(9, "charS.LBM", &g_char_screen_s);
    load_char_screen(9, "charT.LBM", &g_char_screen_t);
    g_h028_mf9 = 1;
}

/* -$F8(a4): FileInfoBlock di H028+$033E. */
static cok_fib *s_fib;

/*
 * PORT H028+$033E: in out il nome del volume dei primi 4 caratteri di path
 * (parametro per valore): Lock e Examine del FileInfoBlock ($104 byte).
 */
void get_volume_name(char *out, u16 path_len, const char *path)
{
    char head[0x51];                    /* -$52(a5) */
    cok_bptr lock;                      /* -$56(a5) */

    s_fib = (cok_fib *)exec_alloc_mem(sizeof(cok_fib), COK_MEMF_CLEAR);
    h026_substr(0x50, head, path_len, path, 0, 4);
    lock = dos_lock(head, ACCESS_READ);
    (void)dos_examine(lock, s_fib);
    dos_unlock(lock);
    /*
     * L'originale libera il blocco e poi ne legge il nome (sull'Amiga resta
     * intatto); qui il nome si copia prima di liberarlo.
     */
    h026_copy(0x50, out, 0x6B, s_fib->fib_FileName);
    exec_free_mem(s_fib, sizeof(cok_fib));
}

/*
 * PORT H028+$07E0: copia in out la stringa str (per valore) senza le
 * occorrenze di pat (confronto senza maiuscole).  L'indice salta la
 * lunghezza di pat dopo ogni cancellazione e la lunghezza non e'
 * ricalcolata: come nell'originale l'ultima posizione non e' controllata.
 */
void remove_substring(u16 str_len, const char *str, u16 pat_len,
                      const char *pat, u16 out_max, char *out)
{
    char s[0x100];                      /* copia per valore */
    char part[0x51];                    /* -$58(a5) */
    u16 plen;                           /* -$4(a5) */
    u16 diff;                           /* -$2(a5) */
    u16 i;                              /* -$6(a5) */

    memcpy(s, str, (size_t)str_len + 1 < sizeof(s) ? (size_t)str_len + 1 :
                                                     sizeof(s));
    plen = h026_strlen(pat_len, pat);
    diff = (u16)(h026_strlen(str_len, s) - plen);
    i = 0;
    while (i < diff) {
        h026_substr(0x50, part, str_len, s, i, plen);
        if (h026_compare_nocase(0x50, part, pat_len, pat) == 1) {
            h026_delete(str_len, s, i, plen);
            i = (u16)(i + plen);
        } else {
            ++i;
        }
    }
    h026_copy(out_max, out, str_len, s);
}

/*
 * PORT H028+$08F0: nome di file dal nome del personaggio (per valore):
 * tolti " .*,?/#:;|", al massimo 8 caratteri.
 */
void make_file_name(u16 name_len, const char *name, u16 out_max, char *out)
{
    static const char bad[10] = { ' ', '.', '*', ',', '?', '/', '#', ':',
                                  ';', '|' };   /* -$a(a5) */
    char copy[0x100];
    char tmp[0x51];                     /* -$5e(a5) */
    char one[2];                        /* -$b0(a5) */
    u16 i;                              /* -$c(a5) */

    memcpy(copy, name, (size_t)name_len + 1 < sizeof(copy) ?
                       (size_t)name_len + 1 : sizeof(copy));
    one[1] = 0;
    for (i = 1; i <= 0x0A; ++i) {
        one[0] = bad[i - 1];
        remove_substring(name_len, copy, 0x50, one, 0x50, tmp);
        h026_copy(name_len, copy, 0x50, tmp);
    }
    h026_substr(out_max, out, name_len, copy, 0, 8);
}

/* PORT H028+$1098: disco dei dati dal valore v ((v+2)/3); il precedente in $246D. */
void set_data_disk(u8 v)
{
    /* $246D: disco dei dati precedente (copia di +$246E); $246E: disco dei dati / gruppo di risorse
     * corrente (G_RESOURCE_GROUP) */
    H005_B(0x246D) = H005_B(0x246E);
    /* $246E: disco dei dati / gruppo di risorse corrente (G_RESOURCE_GROUP) */
    H005_B(0x246E) = (u8)((u16)(v + 2) / 3);
}
