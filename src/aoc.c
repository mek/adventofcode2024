#include <stdio.h>
#include <stdlib.h>

unsigned int
str_len(const char *str)
{

  const char *tmp;

  tmp = str;
  
  for(;;){
    if(!*tmp) return tmp - str;
    ++tmp;
    if(!*tmp) return tmp - str;
    ++tmp;
    if(!*tmp) return tmp - str;
    ++tmp;
    if(!*tmp) return tmp - str;
    ++tmp;
  }
}

unsigned int
getUint(const char *str, unsigned int *uint)
{

  unsigned int pos = 0;
  unsigned int result = 0;
  unsigned int c;

  while((c=(unsigned int) (unsigned char) (str[pos]-'0'))<10){
    result = result * 10 + c;
    ++pos;
  }

  *uint = result;
  return pos;

}

char
*readLine(FILE *file)
{

  char *buffer = NULL;
  char *new = NULL;
  unsigned int buffer_size = 0;
  unsigned int len = 0;
  unsigned char c;

  while((c=fgetc(file))!=EOF) {
    if(feof(file)) break;
    if(len+1>buffer_size){ /* need bigger buffer size */
      buffer_size = (buffer_size == 0) ? 32 : buffer_size * 2;
      new = realloc(buffer,buffer_size);
      if(!new){
        free(buffer);
        fprintf(stderr,"Could not resize buffer to read line. Exiting, sorry it didn't work out\n");
        exit(1);
      }
      buffer = new;
    }
    if(c=='\n'){ /* end of line, return the buffer */
      buffer[len]='\0';
      return buffer;
    }
    buffer[len++] = c;
  }

  if(len>0){ /* reached EOF without a newline */
    buffer[len]='\0';
    return buffer;
  }

  /* if we get there, we read len is zero and we are 
   * at the end of the file, we didn't get any data
   */
  free(buffer);
  return 0;
}
