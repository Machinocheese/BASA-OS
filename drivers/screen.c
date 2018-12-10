/* This file will deal with all of the screen functions */
#include "screen.h"
#include "port.h"

int get_cursor_offset();

/*  This function is here to get the postition of the cursor currently.
    The way we do this is one byte at a time. So we first get the high byte
    and then the low byte and add them together and return that sum.
*/
int get_cursor_offset(){
    port_byte_out(REG_SCREEN_CTRL, 14);//'14' here is to get the high byte first
    int offset = port_byte_in(REG_SCREEN_DATA)<<8;//High byte is retrieved and moved to place
    port_byte_out(REG_SCREEN_CTRL,15);//'15' is to get the low byte
    offset += port_byte_in(REG_SCREEN_DATA);

    /* NOTE: This '* 2' might actually vary per our setup */
    return offset * 2; //position * size of character cell 
}

