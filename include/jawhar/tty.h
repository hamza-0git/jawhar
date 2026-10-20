#ifndef _TTY_H
#define _TTY_H
#include<stdio.h>
#include<stdarg.h>
#include<stdint.h>
#define BUF_SIZE   1024
typedef struct {
  uint8_t orig_x;
  uint8_t orig_y;
} screen_info;

void tty_init();
void tty_write();
void tty_read();
#endif
