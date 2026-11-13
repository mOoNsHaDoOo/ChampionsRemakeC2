/* H071: shop and buying of items. */
#ifndef COK_H071_H
#define COK_H071_H
#include "character.h"
void h071_init(void);                   /* H071+$011C */
void take_item(CokItem *it, u8 *fail);  /* H071+$047C */
void shop(void);                        /* H071+$092C */
#endif
