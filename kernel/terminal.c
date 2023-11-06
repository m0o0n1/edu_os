#include "terminal.h"

static size_t terminal_col = 0;
static size_t terminal_row = 0;
uint16_t *p_vmemory = (uint16_t *)0xb8000;

inline uint16_t terminal_pack_char(uint8_t ch, uint8_t color){
    return (uint16_t) color << 8 | (uint16_t) ch;
}

inline uint8_t terminal_pack_color(enum vga_color fg, enum vga_color bg){
    return (uint8_t)bg << 4 | (uint8_t)fg;
}

void terminal_put_char(uint8_t c, uint8_t x, uint8_t y){
    if(c == '\n')
        terminal_col++;
    else if(c == '\r')
        terminal_row = 0;
    else {
        const size_t index = y * VGA_WIDTH + x;
        p_vmemory[index] = terminal_pack_char(c, terminal_pack_color(VGA_COLOR_GREEN, VGA_COLOR_BLACK));

        terminal_row++;
    }
    if(terminal_row == VGA_WIDTH){
        terminal_row = 0;
        if(++terminal_col == VGA_HEIGHT)
            terminal_col = 0;
    }            // TODO: SCROLLING
}

void terminal_write_string(const char *str){
    for(size_t i = 0; i < strlen(str); i++)
        terminal_put_char(str[i], terminal_row, terminal_col);  // some shit is here
}

void init_term(void){
    terminal_col = 0;
    terminal_row = 0;

    p_vmemory = (uint16_t *)0xb8000; 

    for(size_t y = 0; y < VGA_WIDTH; y++){
        for(size_t x = 0; x < VGA_HEIGHT; x++){
            const uint32_t index = y * VGA_WIDTH + x;
            p_vmemory[index] = terminal_pack_char(' ', terminal_pack_color(VGA_COLOR_GREEN, VGA_COLOR_BLACK));
        }
    }
}