#include <stdio.h>
#include <stdint.h>
#include "../include/aoc.h"
#define MAX 24

typedef uint64_t u64;

typedef struct equation equation;
struct equation {
  unsigned int size;
  u64 target;
  u64 numbers[MAX];
};

void
init_equation(equation *e)
{
  e->size=0; e->target=0;
  for(int i=0;i<MAX;i++) e->numbers[i] = 0;
  return;
}

u64 concat(u64 i, u64 j)
{
  u64 pow = 10;
  while(j>=pow) pow *= 10;
  return i*pow+j;
}

unsigned int
process(equation *e,unsigned int index,u64 res,unsigned int part)
{

  /* we have done all the numbers */
  if(index==e->size) return res==e->target ? 1: 0;

  /* we are larger than the target */
   if(res > e->target) return 0;

  if(index==0) res += e->numbers[index++]; 

  /* Let's get recrusive! */
  if(process(e,index+1,res + e->numbers[index],part)==1) return 1;
  if(process(e,index+1,res * e->numbers[index],part)==1) return 1;
  if(part==2) 
     if(process(e,index+1,concat(res,e->numbers[index]),part)==1) return 1;
 
  return 0;
}

int
main(int argc, char *argv[])
{

  FILE *file = stdin;
  char *line;
  equation e;
  u64 total1,total2 = 0;

  while((line=readLine(file))!=0){
    init_equation(&e);
    char *s = line;
    s = s + get_uint64(s,&e.target);
    if(*s!=':') { printf("error reading line *line\n"); return 1; }
    ++s; 
    /* we have the target, let's read the numbers */
    do { 
      while(*s==' ') ++s;
      s = s + get_uint64(s,&e.numbers[e.size++]);
    } while(*s);
    if(process(&e,0,0,1)>0) total1 += e.target;
    if(process(&e,0,0,2)>0) total2 += e.target;
    ++s;
  }

  printf("part1 total: %llu\n",total1);
  printf("part1 total: %llu\n",total2);

  return 0;
}
