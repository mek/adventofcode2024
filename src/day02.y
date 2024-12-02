%{

#include <stdio.h>

#define YYSTYPE int

extern int yylex(void);
extern int yyparse(void);
extern void yyerror(char *);
extern void warn(char *, char *);
extern void process(int);
extern void calc(void);

%}

%token NUM

%%

statement: /* nothing */
  | statement NUM  { process($2); }
  | statement '\n' { calc();      }         

%%

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

#define INCREASE 1
#define DECREASE 2
#define CONSTANT 3

char *progname;
int linenum = 0;
int lastnum;
int lastdiff;
int numcount = 0;
int badcount = 0;
int safecount = 0; 
int tolerance;
int rate; /* after the first num, we'll see if we go up or down */

int
yylex(void)
{
  int c;

    while((c=getchar()) == ' ' || c == '\t')
    ;

  if(isdigit(c)){
    yylval = 0;
    do{
      yylval = (10 * yylval) + (c - '0');
      c = getchar();
    } while (isdigit(c));
    ungetc(c,stdin);
    return NUM;
  }

  if(c==EOF) return 0;
  if(c=='\n') linenum++;
  return c;
}

void
yyerror(char *msg)
{
  warn(msg,(char *)0);
}

void
warn(char *msg, char *extra)
{
  fprintf(stderr,"%s: %s",progname,msg);
  if(extra)
    fprintf(stderr," %s",extra);
  fprintf(stderr," near line %d\n",linenum);
}

int
getRate(int delta)
{
  if(delta==0) return CONSTANT;
  if(delta>0)  return DECREASE;
  return INCREASE;
}
 
void
process(int i)
{

  if(numcount==0) badcount = 0; /* first number of the sequence */

  lastdiff = lastnum - i;

  if(numcount==1){ /* second number, setup some values */
    rate = getRate(lastdiff);
    if(rate==CONSTANT || abs(lastdiff)>3) {
      badcount++;
      rate = 0;
      numcount = 0; /* first number was bad, use next num in list */
    }
  }

  if(numcount>1)
    if(getRate(lastdiff)!=rate || abs(lastdiff)>3)
      badcount++;

  lastnum = i;
  numcount++;

  return;
}

void
calc(void)
{
   if(badcount <= tolerance)  safecount++; 

   badcount = 0;
   numcount = 0;
   lastnum = 0;
   lastdiff = 0;
   
   return;
}
 
int
main(int argc, char* argv[])
{
  int part;
  progname = argv[0];

  while(argc>1 && argv[1][0] == '-'){
    part = atoi(&argv[1][1]);
    argc--;
    argv++;
  }  
  if(argc!=1 || (part!=1 && part!=2)){
    fprintf(stderr,"usage: %s [-1|-2]\n",progname);
    return 1;
  }
  tolerance = part - 1;

  yyparse();

  printf("part%d total: %d\n",part,safecount);

  return 0;
}
