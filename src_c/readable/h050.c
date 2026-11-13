/* H050: Exec adapters for messages. */
#include "h050.h"

/* PORT H050+$0004: rts. */
void h050_init(void)
{
}

/* PORT H050+$002A */
struct Message *exec_get_msg(struct MsgPort *port)
{
    return GetMsg(port);
}

/* PORT H050+$0064 */
void exec_reply_msg(struct Message *msg)
{
    ReplyMsg(msg);
}

/* PORT H050+$0076 */
struct Message *exec_wait_port(struct MsgPort *port)
{
    return WaitPort(port);
}
