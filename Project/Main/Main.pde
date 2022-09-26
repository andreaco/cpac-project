PGraphics canvas;

// Init constants
int STARTING_AGENTS = 500; 
int CITY_ROWS = 50;
int CITY_COLS = 50;

float INFLUENCE_DIAM = 75;


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
  
  // Instantiate main canvas
  canvas = createGraphics(width, height);
}

void draw() {
  // Start drawing on canvas
  canvas.beginDraw();
  
  // Update physical model
  box2d.step();
  
  drawBackground();
  
  // Draw city
  city.draw();
  
  // Draw Population
  population.draw();
  
  // End drawing on canvas and display it
  canvas.endDraw();
  if (!DEBUG) image(canvas, 0, 0, width, height);
  
  // GUI
  drawGUI();
  
  // OSC effects
  population.updateAwarenessNumbers();
  sendEffect(population.unawareness, population.activity);
  
  if (openHand < 0 && currentState != STATE_IDLE && currentInput == HAND_INPUT){
   if(currentState == STATE_GROUP_ACTIVE) {
      boolean converted = false;
    
      converted = population.convertArea(handPosX, handPosY, INFLUENCE_DIAM/2, currentInfluence);
  
      // If at least one converted, go back to idle state
      if(converted) {
        currentState = STATE_IDLE;
      }
    }
    if(currentState == STATE_SINGLE_ACTIVE) {
      boolean converted = false;
      
      converted = population.convertSingle(handPosX, handPosY, INFLUENCE_DIAM/2, currentInfluence);
  
      // If at least one converted, go back to idle state
      if(converted) {
        currentState = STATE_IDLE;
      }
    }
  }
}
