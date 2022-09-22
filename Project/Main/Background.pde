void drawBackground() {
  if (!DEBUG) {
    canvas.fill(0, 5);
    canvas.rect(0, 0, width, height);
  }
  else {
    background(0);
  }
}
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
  }
  
}
