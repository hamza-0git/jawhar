#include <types.h>
#include <tty.h>
#include <keyboard.h>
void task_tty(int argc, char *argv) {
  while (1) {
    keyboard_read();
  }
}
