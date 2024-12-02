%{

#define YYSTYPE int

extern int yylex(void);
extern int yyparse(void);
extern void yyerror(char *);
extern void warn(char *, char *);
extern void process(int, int);

%}

%token NUM

%%

statement: /* nothing */
  | statement NUM NUM '\n' { process($2,$3); }

%%

#include <stdio.h>
#include <ctype.h>
#include <stdlib.h>

#define COLS 2
#define LEFT 0
#define RIGHT 1

char *progname;
int linenum = 0;

typedef struct Node Node;
struct Node {
  int data;
  struct Node* next;
};

Node* data[COLS];


int
count(Node* head, int v)
{
  Node *n = head;
  int count = 0;
  while(n!=0){
    if(n->data == v) count++;
    n = n->next;
  }
  return count;
}

Node*
create(int v) /* create a new node with value v */
{
  Node* new = (Node *)(malloc(sizeof(Node)));
  if(!new){
    perror("Failed to allocate memory for new node");
    exit(1);
  }
  new->data = v;
  return new;
}

void
insert(Node** head, int v) /* insert a value v into a node */
{
  Node* new = create(v);

  /* check if the new node is the new head */
  if(*head == 0 || (*head)->data >= v){
    new->next = *head;
    *head = new;
     return;
  }

  /* loop through the node, until we find a place for 
     the new node */
  Node *cur = *head;
  while(cur->next != 0 && cur->next->data < v)
    cur = cur->next;

  new->next = cur->next;
  cur->next = new;

  return;
}

void
print(Node* head)
{
  Node* cur = head;
  while(cur!=0) {
    printf("%d\n",cur->data);
    cur=cur->next;
  }

  return;
}

unsigned long 
total(void)
{
  Node* l = data[LEFT];
  Node* r = data[RIGHT];
  unsigned long sum = 0;

  while(l!=0){
    sum += abs(l->data - r->data);
    l = l->next; r = r->next;
  }
  return sum;
}

unsigned long
freq(void)
{
  Node* l = data[LEFT];
  Node* r = data[RIGHT];
  unsigned long sum = 0;

  while(l!=0){
    sum += l->data * count(r,l->data);
    l = l->next;
  }
  return sum;
}

void
freenodes(Node *head)
{
  Node* n = head;
  while(n!=0){
    Node* tmp = n;
    n = n->next;
    free(tmp);
  }
  return;
}

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

void
process(int x, int y)
{
  insert(&data[LEFT],x);
  insert(&data[RIGHT],y);
}

int
main(int argc, char* argv[])
{
  progname = argv[0];
  yyparse();
  printf("part1 total: %lu\n",total());
  /* for part two, we need the frequency of the values in 
     column one as they appear in column 2 */
  printf("part2 total: %lu\n",freq());
  freenodes(data[LEFT]);
  freenodes(data[RIGHT]);
  return 0;
}
