#include <stdio.h>
#include <stdlib.h> /* free */
#include <ctype.h>

#include "../include/aoc.h"

int
main(void)
{

  FILE *file = stdin;
  char *line;
  unsigned int x;
  unsigned int num; 
 
  while((line=readLine(file))!=0){

    printf("length of string %s is %d\n",line,stringLen(line));


    /* get the first number */
    x = getUint(line,&num);
    printf("Found %d in %s\n",num,line);

    /* show what is left */
    line += x;
    printf("left: %s\n",line);

    /* skip to the next number */
    while(*line==' ' || *line == '\t') ++line;
    printf("left: %s\n",line);
    printf("String length of %s is %d\n",line,stringLen(line));
 
    /* get the next number */ 
    x = getUint(line,&num);
    printf("Found %d in %s\n",num,line);

    line += x;
    printf("left: %s\n",line);
    printf("String length of %s is %d\n",line,stringLen(line));

    /* here we should be at the end of the string, if not
     * display an error
     */
    if(*line) printf("error: not at end of line");
    // free(line); /* we alloc memory for the line, so clear it */
  }

  return 0;

}
