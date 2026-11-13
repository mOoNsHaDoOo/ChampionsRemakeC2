/* H053: management of the character records. */
#ifndef COK_H053_H
#define COK_H053_H

#include "character.h"

void free_character(Character **character);    /* H053+$0012 */

void remove_from_party(u8 keep_count, u8 free_sprites); /* H053+$00CA */

#endif
