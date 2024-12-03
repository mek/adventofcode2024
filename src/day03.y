%{

#include <stdio.h>

#define DISABLED 0
#define ENABLED 1

extern int yylex(void);
extern int yyparse(void);
extern void yyerror(char *);
extern void warn(char *, char *);
extern void process(int, int);
extern void calc(void);
extern int state;

%}

%union { 
  int num;
}

%token MUL
%token <num> NUM
%token COMMA LP RP
%token DO DONT
%token OTHER

%%

input:
  | input expr
  | input error
  ;

expr: MUL LP NUM COMMA NUM RP { process($3,$5); }
  |MUL LP NUM COMMA NUM OTHER 
  |MUL LP NUM COMMA OTHER 
  |MUL LP NUM OTHER 
  |MUL LP OTHER 
  |MUL OTHER 
  |DO                         { state = ENABLED;  }
  |DONT                       { state = DISABLED; }
  |OTHER
  ; 

%%

#include <stdio.h>
#include <stdlib.h>

char *progname;
int state=ENABLED;
int total[2]={0,0};
int linenum = 1; /* we aren't checking for line, assume one line */

void
yyerror(char *msg) { return; } /* ignore yacc errors */

void
warn(char *msg, char *extra)
{
  fprintf(stderr,"%s: %s",progname,msg);
  if(extra)
    fprintf(stderr," %s",extra);
  fprintf(stderr," near line %d\n",linenum);
  return;
}

void
process(int x, int y)
{
  total[0] += (x*y); /* part 1 */
  total[1] += (x*y) * state; /* part 2 */
  return;
}

int
main(int argc, char* argv[])
{
  progname = argv[0];

  yyparse();
  
  for(int i = 0;i<2;i++)
    printf("part%d total: %d\n",i+1,total[i]);

  return 0;
}
