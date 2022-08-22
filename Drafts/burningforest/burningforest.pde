
int N = 50;
int M = 75;

float dx, dy;
int[][] forest;
color[] colorMap = {color(200, 0, 0),
                    color(0, 255, 0),
                    color(0, 0, 0)};
final int FIRE = 0;
final int TREE = 1;
final int DEAD = 2;

float probf = 0.00001;
float probp = 0.002;

float[][] plantSize;

PImage treePNG;
PImage groundPNG;
PImage firePNG;

void setup() {
  size(900, 600);
  //fullScreen();
  noStroke();
  
  plantSize = new float[M][N];
  
  forest = new int[M][N];
  dx = width  / (float)M;
  dy = height / (float)N;
  
  for (int i = 0; i < M; i++) {
    for (int j = 0; j < N; j++) {
      plantSize[i][j] = random(0.8, 2);
      forest[i][j] = floor(random(1, 3));
    }
  }
  forest[0][0] = FIRE;
  
  treePNG = loadImage("tree.png");
  groundPNG = loadImage("ground.jpg");
  firePNG = loadImage("fire.png");
  
  frameRate(24);
  background(58, 46, 39);

}

void draw() {
  fill(58, 46, 39, 50);
  rect(0, 0, width, height);
  tint(50, 25);
  image(groundPNG, 0, 0, width, height);
  tint(255);
  
  int[][] forestUpdate = new int[M][N];
  for (int i=0; i < M; i++) {
    forestUpdate[i] = forest[i].clone();
  }
  
  for (int i = 0; i < M; i++) {
    for (int j = 0; j < N; j++) {
      if (forest[i][j] == TREE) {
        tint(255, 180);
        image(treePNG, i*dx, j*dy, dx*plantSize[i][j], dy*plantSize[i][j]);
        tint(255);
      }
      else if (forest[i][j] == FIRE) {
        tint(random(128, 255), 200);
        image(firePNG, i*dx, j*dy, dx*random(0.5,3), dy*random(0.5,3));
        tint(255);
      }
      
      forestUpdate[i][j] = getState(forest, i, j);
    }
  }
  forest = forestUpdate;
}

int getState(int[][] forest, int i, int j) {
  // RULE 1
  if (forest[i][j] == FIRE) {
    return DEAD;
  }
  // RULE 2
  else if (forest[i][j] == TREE && hasBurningNeighbour(forest, i, j)) {
    return FIRE;
  }
  else if (forest[i][j] == DEAD && random(0,1) < probp) {
    return TREE;
  }
  else if (forest[i][j] == TREE && random(0,1) < probf) {
    return FIRE;
  }
  else {
    return forest[i][j];
  }
}

boolean hasBurningNeighbour(int[][] forest, int i, int j) {
  for (int m = -1; m <= 1; m++) {
    for (int n = -1; n <= 1; n++) {
      if (m+i >= 0 && n+j >= 0 && m+i <= M-1 && n+j <= N-1) {
        if(forest[m+i][n+j] == FIRE)
          return true;
      }
    }
  }
  return false;
}
