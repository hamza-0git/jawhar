#ifndef STDIO_H
#define STDIO_H
extern long write(int fd, const void *buf, unsigned long count);
extern void exit(int status);

int putchar(int c) {
  char ch = (char)c;
  return write(1, &ch, 1) == 1 ? (unsigned char)c : -1;
}

#endif
