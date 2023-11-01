#include "stdio.h"
#include "x86_video.h"

void putc(char c){
    x86_Video_Teletype_Print_Char(c);
}

void puts(char *str){
    while(*str){
        putc(*str);
        str++;
    }
}