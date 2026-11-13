/* H067: coins, gems, jewellery and sharing of money. */
#ifndef COK_H067_H
#define COK_H067_H

#include "character.h"

u16  max_carry(Character *c);                           /* H067+$01C8 */
u16  input_amount(u16 max, u16 len, const char *prompt, u16 pen);
                                                        /* H067+$044E */
void transfer_money(u8 coin, u16 amount, Character **to, Character **from);
                                                        /* H067+$06F8 */
void drop_money(u8 coin, u16 amount, Character *c);     /* H067+$0C8C */
u8   coin_type(u16 len, const char *text, u16 out_max, char *out);
                                                        /* H067+$0DCA */

u8   would_overload(Character *c, u16 amount, u16 *room); /* H067+$0232 */
u32  pool_value(void);                                  /* H067+$02AE */
void set_steel_only(u16 steel);                         /* H067+$032A */
void set_pool_steel(u16 steel);                         /* H067+$0374 */

void pool_party_money(void);             /* H067+$0794 */
void share_money(void);                  /* H067+$08CC */
void take_money_menu(void);              /* H067+$0F72 */
void has_treasure(u8 *money, u8 *items); /* H067+$11F4 */
void random_item(u16 type, CokItem *it); /* H067+$1292 */
void appraise_gems(u8 *redraw);          /* H067+$1D7C */
#endif
