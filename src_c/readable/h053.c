/* H053: caricamento e gestione di sequenze/sprite per l'interfaccia. */
#include "h053.h"
#include "h003_exec.h"
#include "h035.h"
#include "globals.h"

/* PORT H053+$0004: link/unlk, nessun effetto. */
void h053_init(void)
{
}

/*
 * PORT H053+$0012: libera il blocco +$192, la lista degli oggetti (+$150),
 * quella degli effetti (+$E8) e il record, poi azzera *character.
 */
void free_character(Character **character)
{
    Character *c = *character;
    CokItem *item;
    CokEffect *effect;

    if (c->block_192 != NULL) {
        exec_free_mem(c->block_192, sizeof(CokTurn));   /* FreeMem($18) */
    }
    item = c->items;
    while (item != NULL) {
        CokItem *dead = item;

        item = item->next;
        exec_free_mem(dead, sizeof(CokItem));
    }
    effect = c->effects;
    while (effect != NULL) {
        CokEffect *dead = effect;

        effect = effect->next;
        exec_free_mem(dead, sizeof(CokEffect));
    }
    exec_free_mem(*character, sizeof(Character));
    *character = NULL;
}

/*
 * PORT H053+$00CA (corpo a $01E8): toglie dal party il personaggio
 * corrente e lo libera; il nuovo corrente e' il precedente (o il primo).
 * free_sprites: libera prima il suo insieme di sprite (+$143); con
 * keep_count = 0 cala il contatore di B+$67C.
 */
void remove_from_party(u8 keep_count, u8 free_sprites)
{
    Character *p;                       /* -$4(a5) */

    if (g_party_head == NULL) {
        return;
    }
    p = g_party_head;
    if (p != g_current_char) {
        while (p->next != g_current_char && p->next != NULL) {
            p = p->next;
        }
        if (p->next != NULL) {
            if (free_sprites) {
                /* pg+$143: posto delle icone 24x24 (0..7 nel party; $0A creazione, $0C editor) */
                free_sprite_set(g_current_char->b[0x143]);
            }
            p->next = g_current_char->next;
            free_character(&g_current_char);
            g_current_char = p;
            if (!keep_count) {
                COK_PUT16(g_state_b + 0x67C, /* B+$67C: (word) numero dei membri del party (max 8) */
                          (u16)(COK_GET16(g_state_b + 0x67C) - 1));
            }
        }
    } else {
        if (free_sprites) {
            /* pg+$143: posto delle icone 24x24 (0..7 nel party; $0A creazione, $0C editor) */
            free_sprite_set(g_current_char->b[0x143]);
        }
        g_party_head = g_current_char->next;
        p = g_current_char->next;
        free_character(&g_current_char);
        g_current_char = p;
        if (!keep_count) {
            COK_PUT16(g_state_b + 0x67C, /* B+$67C: (word) numero dei membri del party (max 8) */
                      (u16)(COK_GET16(g_state_b + 0x67C) - 1));
        }
    }
    if (g_current_char == NULL) {
        g_current_char = g_party_head;
    }
}
