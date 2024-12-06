#include <stdio.h>
#include <stdlib.h>
#include "../include/aoc.h"

int
main(int argc, char *argv[])
{
  FILE *file = stdin;
  char *line, *s;

  while((line=readLine(file))!=0){
     s = line;
     printf("length of string %s is %d\n",s,stringLen(s));
     free(line);
  }

  return 0;
}

