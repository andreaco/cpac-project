// Init constants
int STARTING_AGENTS = 500; 
int CITY_ROWS = 50;
int CITY_COLS = 50;

// DEBUG MODE
boolean DEBUG = false;

// Agents Collections
Population population;
City city;


void setup() {
  // Screen Size
  size(860, 720);
  //fullScreen();
  
  // Processing Settings
  smooth(8);
  frameRate(24);
  noCursor();
  background(0);
  randomSeed(1);
  
  // Initialize OSC
  initOSC();
  
  // Initialize Box2D
  initBox2D();
  
  // Load Textures
  initTextures();
  
  // Init GUI
  initGUI();
  
  // Initialize City Map
  city = new City(CITY_COLS, CITY_ROWS);
  
  // Initialize Population
  population = new Population(STARTING_AGENTS);
}

void draw() {
  // Update physical model
  box2d.step();
  
  drawBackground();
  
  // Draw city
  city.draw();
  
  // Draw Population
  population.draw();
  
  // GUI
  drawGUI();
  
  // OSC effects
  population.updateAwarenessNumbers();
  sendEffect(population.unawareness, population.activity);
}
