#include <stdio.h>
#include <stdlib.h>
#include "../include/aoc.h"

/* setup our directions */
typedef enum {
  UP=0,
  DOWN,
  LEFT,
  RIGHT,
} dir;

/* setup the next direction */
dir next_dir[] = {
  RIGHT,
  LEFT,
  UP,
  DOWN,
}; 

/* define a position */  
typedef struct{
  int col;
  int row;
} pos;

/* define the guard, including their
 * current position, starting position
 * and the current direction that are moving
 */
typedef struct {
  pos position;
  pos start;
  dir direction;
} guard;

/* the field will consists of cells
 * which can have found states
 * FREE - nothing in a cell
 * BUSY - object that will force guard to turn
 * VISITED - guard has been there at least once.
 * ADD - additional obstruction
 */
typedef enum { 
  FREE=0,
  BUSY,
  VISITED,
  ADD, /* for the what we'll be adding */
} cell;

/* define the field */ 
typedef struct{
  cell** cells; /* hold the status   */
  int rows;     /* total rows (y)    */
  int cols;     /* total columns (x) */
} field ;

/* we'll set this in the global scope */
field f = {NULL,0.0};
guard g;

/* when we update the guard (position or direction)
 * call this, so we can update where the guard as 
 * been
 * Note: start position should be updated when 
 * reading in the map.
 */
void
update_guard(pos p, dir d){ /* update the guard */
 
  /* update the position and direction */ 
  g.position = p;
  g.direction = d;

  /* mark the cell as visited by the guard */
  f.cells[p.row][p.col] = VISITED;

  return;
}

/* check if we are outside the field */
unsigned int
in_field(int row, int col){ /* are we within the field */
  return row>=0 && row<f.rows && col>=0 && col<f.cols;
}

/* after reading in a line of the map, add it to the field */
void
insert_line(const char *line){
  
  unsigned int cols = str_len(line);
  unsigned int i;
  
  f.cells = realloc(f.cells, (f.rows + 1)*sizeof(cell*));
  if(!f.cells){
    printf("Trouble reallocation memory for field cells\n");
    exit(1);
  }

  f.cells[f.rows] = malloc(cols*sizeof(cell));
  if(!f.cells[f.rows]){
    printf("Trouble allocating memory for rows\n");
    exit(1);
  }

  for(i=0;i<cols;i++)
    switch(line[i]){
    case '.': f.cells[f.rows][i] = FREE; break;
    case '#': f.cells[f.rows][i] = BUSY; break;
    case '^': update_guard((pos){i,f.rows},UP); g.start = (pos){i,f.rows}; break;
    }
  f.cols = cols;
  f.rows++;
  
  return;
}

/* print out the field */
void
print(void){
  for(int row=0;row<f.rows;row++){
    for(int col=0;col<f.cols;col++) {
      switch(f.cells[row][col]){
      case FREE: 
        if(g.position.col==col && g.position.row==row){
          printf("^");
        } else {
          printf(".");
        }
        break;
      case BUSY: printf("#"); break;
      case VISITED: printf("X"); break;
      case ADD: printf("A"); break;
      default: printf("?");
      }
    }
    printf("\n");
  }
  return;
}

unsigned int
visited(void){ /* find the number of cells visited */
  unsigned int total = 0;
  for(int row=0;row<f.rows;row++) for(int col=0;col<f.cols;col++)
      if(f.cells[row][col] == VISITED) total++;
  return total;
}

/* move around the field until they guard gets out
 * or we get caught in a loop 
 */
unsigned int
move(void){
  /* to make sure I don't get stuck in a infinite loop
   * let's create a quick grid to store when a guard
   * visits a location AND his direction. If they hit 
   * the same position going in the same direction
   * they are in a loop.
   */
  int cells_visited[f.rows][f.cols];
  for(int row=0;row<f.rows;row++) for(int col=0;col<f.cols;col++)
      cells_visited[row][col] = -1; /* hasn't visited */
  pos next;

  for(;;){
    switch(g.direction){
    case UP: next.col = g.position.col; next.row = g.position.row-1; break;
    case DOWN: next.col = g.position.col; next.row = g.position.row+1; break;
    case RIGHT: next.col = g.position.col+1; next.row = g.position.row; break;
    case LEFT: next.col = g.position.col-1; next.row = g.position.row; break;
    }
    if(!in_field(next.row,next.col)) break; /* moved off the field */

    /* check if next position is available */
    /* rows have the columns in them */
    if(f.cells[next.row][next.col]!=BUSY && f.cells[next.row][next.col]!=ADD) { 
      update_guard(next,g.direction);
      if(cells_visited[next.row][next.col] == g.direction) return 0; /* in a loop */
      cells_visited[g.position.row][g.position.col] = g.direction;
    } else { 
      update_guard(g.position,next_dir[g.direction]);
    } 
  }
  return 1; /* guard made it out */
}

void
reset_cells(void){ /* changed VISITED and ADD back to FREE */
  for(int row=0;row<f.rows;row++) for(int col=0;col<f.cols;col++) 
      switch(f.cells[row][col]){
      case VISITED: f.cells[row][col] = FREE; break;
      case ADD: f.cells[row][col] = FREE; break;
      default: break;
      }
  return;
}

void
freecells(void){
  for(int i=0;i<f.rows;i++) free(f.cells[i]);
  free(f.cells);
  return;
}

int
main(int argc, char *argv[])
{
  FILE *file = stdin;
  char *line;
  unsigned oldcol = 0;
  /* field is defined globally, but we'll need to allocate memory */
    
  /* read in map */
  while((line=readLine(file))!=0){
     insert_line(line);
     
     if(oldcol && oldcol != str_len(line)){ /* once we establish col size, check it */
       printf("Expected %d columns and got %d in row %d\n",oldcol,str_len(line),f.rows);
       return 1;
     }
     oldcol = str_len(line);
     free(line);
  }
  // print();
  
  move(); /* part one */
  printf("part1 total: %d\n",visited());

  /* add new obstruction, start at 0-0 -> f.rows, f.cols
   * skip the guard starting position. 
   * skip the busy positions
   * reset field before solving.
   * also update guard to start position and direction UP
   */ 
  int part2 = 0;
  for(int row=0;row<f.rows;row++) for(int col=0;col<f.cols;col++) {
      if(row == g.start.row && col == g.start.col) continue;
      if(f.cells[row][col]==BUSY) continue;
      reset_cells();
      update_guard(g.start,UP);
      f.cells[row][col] = ADD;
      if(!move()) part2++; /* 0 = loop */
    }

  printf("part2 total: %d\n",part2);

  freecells();

  return 0;
}

