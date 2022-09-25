String[] shortcuts = {
  "Press (W) to convert 100 random agents to Aware state",
  "Press (S) to convert 100 random agents to Unaware state",
  "Press (D) to convert 1 random agent to Aware state",
  "Press (A) to convert 1 random agent to Unaware state",
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
}

void mousePressed() {
  if (mouseButton == LEFT) {
    population.convertArea(mouseX, mouseY, INFLUENCE_DIAM/2, 1.0f);
  }
  if (mouseButton == RIGHT) {
    population.convertArea(mouseX, mouseY, INFLUENCE_DIAM/2, -1.0f);
  }
}
