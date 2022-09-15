// Constants
int WALL = 0;
int STREET = 1;
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
    int nSteps = numRows;

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

        // Rigid bodies
        if (citySkeleton[row][col] == WALL) {
          Wall wall = new Wall(col*blockWidth, row*blockHeight, blockWidth*1.1, blockHeight*1.1);
          walls.add(wall);
        }
      } // End For Cols
    } // End For Rows

    // Add boundaries at margins

    walls.add(new Wall(0, 0, 10, height*2, #000000));  // North
    walls.add(new Wall(0, 0, width*2, 10, #000000)); // West
    walls.add(new Wall(width, 0, 10, height*2, #000000));  // East
    walls.add(new Wall(0, height, width*2, 10, #000000));
  }

  void draw() {
    for (Wall w : walls) {
      w.display();
    }
  }
}



class Wall {

  float x, y;
  float w, h;
  color c = #444444;

  Body b;
  
  Wall(float x_, float y_, float w_, float h_, color c_) {
    this(x_, y_, w_, h_);
    c = c_;
  }
  Wall(float x_, float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;

    BodyDef bd = new BodyDef();
    bd.position.set(P2W(x, y));

    bd.type = BodyType.STATIC;
    b = box2d.createBody(bd);

    float box2dW = P2W(w/2);
    float box2dH = P2W(h/2);
    PolygonShape ps = new PolygonShape();

    ps.setAsBox(box2dW, box2dH);

    b.createFixture(ps, 1);
  }

  void display() {

    noStroke();
    fill(c);
    int currentRectMode = getGraphics().rectMode;
    rectMode(CENTER);
    rect(x, y, w*1.1, h*1.1, 10);
    rectMode(currentRectMode);
  }
}
