/* H092: Helpers for Exec lists. */
#include "h092.h"

/* PORT H092+$0004: rts. */
void h092_init(void)
{
}

#ifdef COK_AUDIO
/* PORT H092+$007A: NewList: empty list (head -> tail, null tail). */
void exec_new_list(struct List *list)
{
    list->lh_Head = (struct Node *)&list->lh_Tail;
    list->lh_Tail = NULL;
    list->lh_TailPred = (struct Node *)&list->lh_Head;
}
#endif
