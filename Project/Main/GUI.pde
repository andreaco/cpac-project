int STATE_IDLE = 0;
int STATE_ACTIVE = 1;
int NEWS_NEGATIVE = -1;
int NEWS_POSITIVE = +1;
int currentState = 0;
int currentNews = 1;

PFont boldFont;
float boxGUIWidth, boxGUIHeight;
float margin = 20;
float fontSize = 14;
void initGUI() {
  boldFont = createFont("Roboto-Bold.ttf", fontSize);
  textSize(fontSize);
  textFont(boldFont);
  
  String longest = "";
  for(int i=0; i < shortcuts.length; ++i) {
      if(shortcuts[i].length() > longest.length()) {
        longest = shortcuts[i]; 
      }
  }
  boxGUIWidth = textWidth(longest); 
  boxGUIHeight = fontSize * shortcuts.length;
}

void drawGUI() {
  
  if (DEBUG) {
    pushStyle();
    fill(100, 200);
    float padX = 0.9*margin;
    float padY = 0.9*margin;
    rect(margin-padX, margin-padY, boxGUIWidth+2*padX, boxGUIHeight+2*padY);
    
    textSize(fontSize);
    fill(0);
    for(int i = 0; i < shortcuts.length; ++i) {
      text(shortcuts[i], 20, 20+fontSize*(i+1)); 
    }
    popStyle();
    
    fill(150, 255, 150, 100); 
    ellipse(mouseX, mouseY, INFLUENCE_DIAM,  INFLUENCE_DIAM); 
  }
  else {
    if(currentState == STATE_ACTIVE) {
      pushStyle();
      fill(0, 100);
      rect(0, 0, width, height);
      blendMode(SCREEN);
      int numCircles = 20;
      for (int i=0; i < numCircles; ++i) {
        float perc = i / (float) numCircles;
        fill(150, 150, 150, 5); 
        ellipse(mouseX, mouseY, INFLUENCE_DIAM*perc,  INFLUENCE_DIAM*perc);
      }
      population.highlightArea(mouseX, mouseY, INFLUENCE_DIAM/2);
      popStyle();
    }
  }
  
}
