String[] shortcuts = {
  "Press (W) to convert 100 random agents to Aware state",
  "Press (S) to convert 100 random agents to Unaware state",
  "Press (D) to convert 1 random agent to Aware state",
  "Press (A) to convert 1 random agent to Unaware state",
  "Press (1) to get into POSITIVE influence state",
  "Press (0) to get into NEGATIVE influence state",
  "Press (Z) to toggle input mode (hand/mouse)",
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
  
  // (1): Enter input mode group positive
  if(key == '1') {
    addGroupPositiveInfluence();
  }
  
  // (0): Enter input mode group negative
  if(key == '0') {
    addGroupNegativeInfluence();
  }
  
  // (Z): Toggle input mode
  if(key == 'z') {
    if(currentInput == HAND_INPUT) {
      currentInput = MOUSE_INPUT;
    }
    else if(currentInput == MOUSE_INPUT) {
      currentInput = HAND_INPUT;
    }
  }
}
