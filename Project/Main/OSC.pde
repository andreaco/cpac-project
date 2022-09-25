import oscP5.*; // OscP5, OscMessage
import netP5.*; // NetAdress

// OSCP5 Objects
OscP5 oscP5;
NetAddress netAddress;
int PORT = 57120;


void initOSC() {
  // Initialize OSC objects and address
  oscP5 = new OscP5(this, 55000);
  netAddress = new NetAddress("127.0.0.1",PORT);
}

void oscEvent(OscMessage oscMsg) {
  println("Received an osc message");
}

void sendEffect(float unawareness_perc, float activity){
    OscMessage effect = 
            new OscMessage("/note_effect");    
    effect.add(unawareness_perc);
    effect.add(activity);    
    oscP5.send(effect, netAddress);
}

void shareButtonPressed(boolean isFake) {
  currentState = STATE_ACTIVE;
  currentNews = (isFake) ? NEWS_NEGATIVE : NEWS_POSITIVE;
}

void reportButtonPressed(boolean isFake) {
  currentState = STATE_ACTIVE;
  currentNews = (isFake) ? NEWS_POSITIVE : NEWS_NEGATIVE;
}
