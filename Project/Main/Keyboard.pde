String[] shortcuts = {
  "Press (W) to convert 100 random agents to Aware state",
  "Press (S) to convert 100 random agents to Unaware state",
  "Press (D) to convert 1 random agent to Aware state",
  "Press (A) to convert 1 random agent to Unaware state",
  "Press (1) to get into POSITIVE influence state",
  "Press (0) to get into NEGATIVE influence state",
  "Press (SPACE) to toggle DEBUG mode",
};

void keyPressed() {
  
  // (W): 100 random agents get awareness +1.0f
  if(key == 'w') {
    for (int i = 0; i < 100; i++) {
      Agent a = population.getRandomAgent();
      a.awareness = 1.0;
    } 
  }
  
  // (S): 100 random agents get awareness -1.0f
  if(key == 's') {
    for (int i = 0; i < 100; i++) {
      Agent a = population.getRandomAgent();
      a.awareness = -1.0;
    } 
  }
  
  // (D): 1 random agent gets awareness +1.0f
  if(key == 'd') {
    Agent a = population.getRandomAgent();
    a.awareness = 1.0;
  }
  
  // (A): 1 random agent gets awareness -1.0f
  if(key == 'a') {
    Agent a = population.getRandomAgent();
    a.awareness = -1.0;
  }
   
  // (SPACE): Toggle debug mode
  if(key == ' ') {
    background(0);
    DEBUG = !DEBUG;
  }
  
  if(key == '1') {
    addGroupPositiveInfluence();
  }
  if(key == '0') {
    addGroupNegativeInfluence();
  }
}


void mousePressed() {
  if (currentInput == MOUSE_INPUT){
    if(currentState == STATE_GROUP_ACTIVE) {
      boolean converted = false;
    
      converted = population.convertArea(mouseX, mouseY, INFLUENCE_DIAM/2, currentInfluence);
  
      // If at least one converted, go back to idle state
      if(converted) {
        currentState = STATE_IDLE;
      }
    }
    if(currentState == STATE_SINGLE_ACTIVE) {
      boolean converted = false;
      
      converted = population.convertSingle(mouseX, mouseY, INFLUENCE_DIAM/2, currentInfluence);
  
      // If at least one converted, go back to idle state
      if(converted) {
        currentState = STATE_IDLE;
      }
    }} 
}
