#include <stdbool.h>
#include "stdint.h"
#include "string.h"
#include "terminal.h"
 
#if defined(__linux__)
#error "You are not using a cross-compiler, you will most certainly run into trouble"
#endif
 
void kmain(void) 
{
	init_term();
	terminal_write_string("HELLO MY KERNEL!\r\nAnother try\n");
}
