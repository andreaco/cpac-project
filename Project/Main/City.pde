

int WALL = 0;
int STREET = 1;

void initCity() {
  // City initialization
  city = new City(CITY_COLS, CITY_ROWS);
}

class City {

  int[][] citySkeleton;
  int numRows, numCols;
  float blockWidth, blockHeight;

  ArrayList<Wall> walls;

  City(int numCols, int numRows) {
    this.numRows = numRows;
    this.numCols = numCols;

    this.blockWidth  = width  / (float)numCols;
    this.blockHeight = height / (float)numRows;

    generateCity();
  }

  void generateCity() {
    // Instantiate or reset structures
    walls = new ArrayList<Wall>();
    citySkeleton = new int[numCols][numRows];

    // Number of walkers and steps proportional to size
    int nWalkers = numRows;
    int nSteps = numRows*2;

    // For each walker
    for (int walker=0; walker < nWalkers; ++walker) {
      // Get a random position in the skeleton
      int posX = int(random(numCols));
      int posY = int(random(numRows));

      // Let the walker walk
      for (int step=0; step < nSteps; ++step) {
        // Set current cell as street
        citySkeleton[posX][posY] = STREET;

        // Make a step N, E, S or W
        int randomDirection =(int)random(4);
        final int N=0, E=1, S=2, W=3;
        switch(randomDirection) {
        case N:
          posY -= 1;
          break;
        case S:
          posY += 1;
          break;
        case E:
          posX += 1;
          break;
        case W:
          posX -= 1;
        }
        // Constrain in array limits
        posX = abs(posX%numCols);
        posY = abs(posY%numRows);
      }
    }

    // Create a fixed grid as roads and create rigid bodies for the world
    for (int row=0; row < numRows; ++row) {
      for (int col=0; col < numCols; ++col) {

        // Streets
        if (row % 10 == 0 || col % 10 == 5) {
          citySkeleton[row][col] = STREET;
        }
        if (row == 0 || col==0 || col==numCols-1 || row == numRows-1) {
          citySkeleton[row][col] = WALL;
        }

        // Rigid bodies
        if (citySkeleton[row][col] == WALL) {
          Wall wall = new Wall(col*blockWidth, row*blockHeight, blockWidth, blockHeight);
          walls.add(wall);
        }
      } // End For Cols
    } // End For Rows

  }

  void draw() {
 
    for (Wall w : walls) {
      w.display();
    }
  }
}
