#ifndef AOC_H
#define AOC_H

extern unsigned int str_len(const char *);
/* extern int stringDiff(const char *, const char *); */
extern unsigned int getUint(const char *, unsigned int *);
extern unsigned int get_ulong(const char *, unsigned long *);
extern unsigned int get_uint64(const char *, uint64_t*);
extern char *readLine(FILE *);

#endif
