#ifndef _STRING_H
#define _STRING_H

#ifndef _SIZE_T
#define _SIZE_T
typedef unsigned long size_t;
#endif

static inline void * memcpy(void *dest, const void *src, size_t n)
{
const char * sp = (const char *)src;
char *dp = (char *) dest;
for(size_t i = 0; i < n; i++) 
dp[i] = sp[i];
return dp;
}

static inline void * memset(void *dest, int val, size_t n)
{
char * dp = (char *)dest;
for(size_t i = 0; i < n; i++)
dp[i] = (char)val;
return dest;
}

static inline unsigned short * memsetw(unsigned short *dest, unsigned short val, size_t n)
{
unsigned short * dp = (unsigned short *)dest;
for(size_t i = 0; i < n; i++)
dp[i] = val;
return dp;
}

static inline size_t strlen(const char *str)
{
size_t len = 0;
while(str[len]) 
len++;
return len;
}

static inline char * strcpy(char * dest, const char * src)
{
char * dp = dest;
while ((*dp++ = *src++) != '\0')
;
return dest;
}

static inline int strcmp(const char * dest, const char * src)
{
const unsigned char * sp = (const unsigned char *) src;
const unsigned char * dp = (const unsigned char *) dest;

for ( ; *dp == *sp; dp++, sp++)
if (*dp == '\0')
return 0;
return *dp - *sp;
}

#endif
