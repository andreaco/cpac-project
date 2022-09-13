import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;


int ROWS = 20;
int COLS = 20;
float blockWidth, blockHeight;
int[][] WORLD;

int HOUSE = 0;
int STREET = 1;

int peepX[], peepY[], peepC[];
int NPEEPS = 10;
void setup() {
  size(800, 800);
  
  WORLD = new int[COLS][ROWS];
  peepX = new int[NPEEPS];
  peepY = new int[NPEEPS];
  peepC = new int[NPEEPS];
  
  int nwalkers = ROWS;
  int nsteps =ROWS;
  for (int walker=0; walker < nwalkers; ++walker) {
    int posX = int(random(COLS));
    int posY = int(random(ROWS)); 
    for (int step=0; step < nsteps; ++step) {
      WORLD[posX][posY] = STREET;
      int randomDirection =(int)random(4);
      final int N=0, E=1, S=2, W=3;
      switch(randomDirection) {
        case N:
          posY -= 1;
          posY = abs(posY%ROWS);
          break;
        case S:
          posY += 1;
          posY = abs(posY%ROWS);
          break;
        case E:
          posX += 1;
          posX = abs(posX%COLS);
          break;
        case W:
          posX -= 1;
          posX = abs(posX%COLS);
      } 
    }
  }
  
  for (int row=0; row < ROWS; ++row) {
    for (int col=0; col < COLS; ++col) {
      if(row%10 == 0 || col%10 == 5)
        WORLD[row][col] = STREET;
    }
  }
  
  for (int p=0; p<NPEEPS; ++p) {
    peepX[p] = int(random(COLS));
    peepY[p] = int(random(ROWS));
    peepC[p] = color(random(255),random(255),random(255));
  }

  
  
  blockWidth = width/(float)COLS;
  blockHeight = height/(float)ROWS;
  noStroke();
  
  frameRate(10);
}


void draw() {
  for (int row=0; row < ROWS; ++row) {
    for (int col=0; col < COLS; ++col) {
      if(WORLD[col][row] == STREET)
        fill(30, 200);
      else
        fill(185, 80, 80, 50);
        
      ellipse(col*blockWidth, row*blockHeight, blockWidth*1.5, blockHeight*1.5);
    }
  }
  
  for (int p=0; p<NPEEPS; ++p) {
    for (int i=0; i<1; ++i) {
      int randomDirection =(int)random(4);
      int oldX = peepX[p], oldY = peepY[p];
      final int N=0, E=1, S=2, W=3;
      switch(randomDirection) {
        case N:
          peepY[p] -= 1;
          peepY[p] = abs(peepY[p]%ROWS);
          break;
        case S:
          if (peepY[p] < ROWS) {
            peepY[p] += 1;
            peepY[p] = abs(peepY[p]%ROWS);
          }
          break;
        case E:
          peepX[p] += 1;
          peepX[p] = abs(peepX[p]%COLS);
          break;
        case W:
          peepX[p] -= 1;
          peepX[p] = abs(peepX[p]%COLS);
      } 
      if (WORLD[peepX[p]][peepY[p]] != STREET){
        peepX[p] = oldX; peepY[p] = oldY;
      }
     
    }
    fill(peepC[p]);
    ellipse(peepX[p]*blockWidth, peepY[p]*blockHeight, 10, 10);
  }
}
