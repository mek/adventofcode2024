#include <stdio.h>
#include <string.h>

// max size of our matrix is MAX x MAX
#define MAX 1024
char matrix[MAX][MAX];

enum SearchDirections{
  VERT=0,
  HORZ,
  LDIAG,
  RDIAG,
} SearchDirections;
#define SearchDirectionCount 4

struct Point {
  int x;
  int y;
};
struct Point directions[SearchDirectionCount];

void
init_search_directions(){
  directions[VERT].x  =  0; directions[VERT].y  =  1;
  directions[HORZ].x  =  1; directions[HORZ].y  =  0;
  directions[LDIAG].x =  1; directions[LDIAG].y =  1;
  directions[RDIAG].x = -1; directions[RDIAG].y =  1;
}

int rows = 0 ;
int cols = 0;

char *string = "XMAS";
char *string2 = "MAS";

int part1total = 0;
int part2total = 0;

void
print(void)
{
  int i,j = 0;
  for(i=0;i<rows;i++) {
    for(j=0;j<cols;j++) printf("%c",matrix[i][j]);
    printf("\n");
  }
  return;
}

int
str_check(const char *s, const char *t)
{
  int i, res;

  if(strlen(s)!=strlen(t)) return 0;

  res = 1; /* assume success */
  for(i=0;i<strlen(s);i++)
    if(s[i]!=t[i]) {
      res = 0;
      break;
    }
  if(res==1) return 1; /* match found, skip revese search */

  for(i=0;i<strlen(s);i++) if(s[i]!=t[strlen(t)-1-i]) return 0;
  
  return 1;
}

char
get_matrix_value(int x, int y)
{
  if(x<0 || x>cols-1 || y<0 || y>rows-1) return ' ';
  return matrix[x][y];
}

void
search(int x, int y,const char *s,int part){
 
  int j;
  int xinc,yinc;
  char str[strlen(s)];
  enum SearchDirections i,start;
  
  if(part==1) start = VERT;
  if(part==2) start = LDIAG;

  for(i=start;i<SearchDirectionCount;i++) {
    xinc = directions[i].x; yinc = directions[i].y;   
    for(j=0;j<strlen(s);j++) str[j]=get_matrix_value(x+(j*xinc),y+(j*yinc));
    str[j]='\0';
    if(str_check(string,str)) part1total++;
  }
  return;
}
  

void
part2(int x, int y)
{
  char s[strlen(string2)];
  
  s[0]=matrix[x-1][y-1]; s[1]=matrix[x][y]; s[2]=matrix[x+1][y+1];
  if(!str_check(string2,s)) return;
  
  s[0]=matrix[x+1][y-1];s[1]=matrix[x][y]; s[2]=matrix[x-1][y+1];
  if(!str_check(string2,s)) return;
  
  part2total++;
  return;
}
void
check(void)
{
  int i,j;

  for(i=0;i<rows;i++)
    for(j=0;j<cols;j++) {
      search(i,j,string,1);
      if(i>0 && i<rows-1 && j>0 && j<cols-1 && matrix[i][j]=='A')
          part2(i,j);
    }
    
  return;
}


int
main(void)
{
  char c;
  int oldcols = 0;

  init_search_directions();

  /* read in the data, store in matrix */
  rows = 0; cols = 0;
  while((c=getchar())!=EOF){
    if(feof(stdin)) break;
    if(c=='\n') { 
      rows++; 
      oldcols = cols;
      cols=0;
      continue; 
    /* x = cols
     * y = rows
     */}
    matrix[rows][cols]=c;
    cols++;
  }  
  cols = oldcols;
  check();
  printf("part1 total: %d\n",part1total);
  printf("part2 total: %d\n",part2total);

  return 0;
}
