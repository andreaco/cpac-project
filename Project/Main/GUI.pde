// Sketch State FSM
int STATE_IDLE = 0;
int STATE_GROUP_ACTIVE = 1;
int STATE_SINGLE_ACTIVE = 2;
int currentState = STATE_IDLE;

// Type of influence to apply
int INFLUENCE_NEGATIVE = -1;
int INFLUENCE_POSITIVE = +1;
int currentInfluence = 0;


// Font Settings
PFont boldFont;
float boxGUIWidth, boxGUIHeight;
float margin = 20;
float fontSize = 14;

// Init GUI
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

// Draw GUI Debug/Release
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
    
    if(currentState != STATE_IDLE && currentInfluence == INFLUENCE_POSITIVE) {
       fill(150, 150, 255, 100);
    }
    else if (currentState != STATE_IDLE && currentInfluence == INFLUENCE_NEGATIVE) {
       fill(255, 150, 150, 100);
    }
    else {
      fill(150, 150, 150, 100);
    }
    ellipse(inputX, inputY, INFLUENCE_DIAM,  INFLUENCE_DIAM);
    
  }
  else {
    if(currentState != STATE_IDLE) {
      pushStyle();
      fill(0, 100);
      rect(0, 0, width, height);
      blendMode(SCREEN);
      int numCircles = 20;
      for (int i=0; i < numCircles; ++i) {
        float perc = i / (float) numCircles;
        
        if(currentInfluence == INFLUENCE_POSITIVE) {
          fill(150, 150, 250, 5);
        } else if(currentInfluence == INFLUENCE_NEGATIVE) {
          fill(250, 150, 150, 5);
        }
        else {
           fill(150, 150, 150, 5);
        }
        ellipse(inputX, inputY, INFLUENCE_DIAM*perc,  INFLUENCE_DIAM*perc);
      }
      population.highlightArea(inputX, inputY, INFLUENCE_DIAM/2);
      
      popStyle();
    }
  }
  
}
