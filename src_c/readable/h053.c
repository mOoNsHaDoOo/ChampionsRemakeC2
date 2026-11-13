/* H053: loading and handling of sequences/sprites for the user interface. */
#include "h053.h"
#include "h003_exec.h"
#include "h035.h"
#include "globals.h"

/* PORT H053+$0004: link/unlk, no effect. */
void h053_init(void)
{
}

/*
 * PORT H053+$0012: frees the block +$192, the item list (+$150),
 * the effect list (+$E8) and the record, then clears *character.
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
 * PORT H053+$00CA (body at $01E8): removes the current character from the
 * party and frees it; the new current one is the previous one (or the first).
 * free_sprites: first frees its sprite set (+$143); with
 * keep_count = 0 it decrements the counter at B+$67C.
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
                /* pg+$143: slot of the 24x24 icons (0..7 in the party; $0A creation, $0C editor) */
                free_sprite_set(g_current_char->b[0x143]);
            }
            p->next = g_current_char->next;
            free_character(&g_current_char);
            g_current_char = p;
            if (!keep_count) {
                COK_PUT16(g_state_b + 0x67C, /* B+$67C: (word) number of party members (max 8) */
                          (u16)(COK_GET16(g_state_b + 0x67C) - 1));
            }
        }
    } else {
        if (free_sprites) {
            /* pg+$143: slot of the 24x24 icons (0..7 in the party; $0A creation, $0C editor) */
            free_sprite_set(g_current_char->b[0x143]);
        }
        g_party_head = g_current_char->next;
        p = g_current_char->next;
        free_character(&g_current_char);
        g_current_char = p;
        if (!keep_count) {
            COK_PUT16(g_state_b + 0x67C, /* B+$67C: (word) number of party members (max 8) */
                      (u16)(COK_GET16(g_state_b + 0x67C) - 1));
        }
    }
    if (g_current_char == NULL) {
        g_current_char = g_party_head;
    }
}
