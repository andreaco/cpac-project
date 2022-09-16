
int ROWS = 20;
int COLS = 20;
float blockWidth, blockHeight;
int[][] WORLD;

int HOUSE = 0;
int STREET = 1;

int NPEEPS = 10;
void setup() {
  size(800, 800);
  
  WORLD = new int[COLS][ROWS];
  
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
  
}

void mousePressed() {
  int x = int(COLS * mouseX / width);
  int y = int(ROWS * mouseY / width);
  
  if (WORLD[x][y] == STREET) {
    WORLD[x][y] = HOUSE;
  }
  else {
    WORLD[x][y] = STREET;
  }
   
  
}
