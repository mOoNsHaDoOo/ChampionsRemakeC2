/* H050: exec adapters for messages. */
#ifndef COK_H050_H
#define COK_H050_H

#include "cok.h"

struct Message *exec_get_msg(struct MsgPort *port);     /* H050+$002A */
void exec_reply_msg(struct Message *msg);               /* H050+$0064 */
struct Message *exec_wait_port(struct MsgPort *port);   /* H050+$0076 */

#endif
