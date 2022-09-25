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
    currentNews = NEWS_POSITIVE;
    currentState = STATE_ACTIVE;
  }
  if(key == '0') {
    currentNews = NEWS_NEGATIVE;
    currentState = STATE_ACTIVE;
  }
}


void mousePressed() {
  
  if(currentState == STATE_ACTIVE) {
    boolean converted = false;
    if (mouseButton == LEFT) {
      converted = population.convertArea(mouseX, mouseY, INFLUENCE_DIAM/2, 1.0f);
    }
    if (mouseButton == RIGHT) {
      converted = population.convertArea(mouseX, mouseY, INFLUENCE_DIAM/2, -1.0f);
    }
    
    // If at least one converted, go back to idle state
    if(converted) {
      currentState = STATE_IDLE;
    }
  }
}
