
// Input x,y
float inputX = 0;
float inputY = 0;

// Input FSM
int HAND_INPUT = 0;
int MOUSE_INPUT = 1;
int currentInput = HAND_INPUT;


void updateInputXY() {
  if(currentInput == HAND_INPUT) {
    inputX = handPosX;
    inputY = handPosY;
  }
  if(currentInput == MOUSE_INPUT) {
    inputX = mouseX;
    inputY = mouseY;
  }
}

void updateOpenHandInput() {
  
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
    }
  } 
}
