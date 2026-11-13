/* H066: characters on disk and the character icon. */
#ifndef COK_H066_H
#define COK_H066_H

#include "character.h"
#include "h008.h"

void build_char_icon(u8 recolor);       /* H066+$0C34 */
void save_character(Character *c, u16 name_len, const char *name);
                                        /* H066+$1640 */
void list_saved_characters(CokMenuItem **names, CokMenuItem **files);
                                        /* H066+$03D0 */
void load_character(u16 name_len, const char *name, Character *c,
                    u8 unused, u8 save_disk);   /* H066+$1B0E */
void add_npc(u16 npc);                  /* H066+$276E */
void add_to_party(Character *c);        /* H066+$27EE */

void delete_character_files(Character *c);     /* H066+$1312 */

void save_game(void);                           /* H066+$3000 */

void load_game(void);                           /* H066+$291E */

void load_monster_record(u16 id, Character *c); /* H066+$1FDA */
#endif
