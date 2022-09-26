import oscP5.*; // OscP5, OscMessage
import netP5.*; // NetAdress

// OSCP5 Objects
OscP5 oscP5;
NetAddress netAddress;
int OUT_PORT = 57120;
int IN_PORT  = 55000;


void initOSC() {
  // Initialize OSC objects and address
  
  // INPUT
  oscP5 = new OscP5(this, IN_PORT);
  
  // OUTPUT
  netAddress = new NetAddress("127.0.0.1",OUT_PORT);
}

void oscEvent(OscMessage oscMsg) {
 
  if(oscMsg.checkAddrPattern("/website/news")==true) {
    /* check if the typetag is the right one. */
    if(oscMsg.checkTypetag("ss")) {
      
      String receivedInfluence = oscMsg.get(0).stringValue();
      String influenceSize = oscMsg.get(1).stringValue();
      if(receivedInfluence.equals("positiveMessage")) {
        if(influenceSize.equals("single")) {
          addSinglePositiveInfluence();
        }
        else {
          addGroupPositiveInfluence();
        }
      }
      if(receivedInfluence.equals("negativeMessage")) {
        if(influenceSize.equals("single")) {
          addSingleNegativeInfluence();
        }
        else {
          addGroupNegativeInfluence();
        }
      }  
      
      println("Received reaction: "+ receivedInfluence);
      return;
    }  
  } 
  println("### received an osc message. with address pattern "+ oscMsg.addrPattern());
  
}

void sendEffect(float unawareness_perc, float activity){
    OscMessage effect = 
            new OscMessage("/supercollider/note_effect");    
    effect.add(unawareness_perc);
    effect.add(activity);    
    oscP5.send(effect, netAddress);
}

void sendNotificationSound(String influence){
    OscMessage msg = new OscMessage("/supercollider/notification");    
    msg.add(influence);
    oscP5.send(msg, netAddress);
}


void addGroupPositiveInfluence() {
  sendNotificationSound("positive");
  println("Adding positive influence..");
  currentState = STATE_GROUP_ACTIVE;
  currentInfluence = INFLUENCE_POSITIVE;
}

void addSinglePositiveInfluence() {
  sendNotificationSound("positive");
  println("Adding positive influence..");
  currentState = STATE_SINGLE_ACTIVE;
  currentInfluence = INFLUENCE_POSITIVE;
}

void addGroupNegativeInfluence() {
  sendNotificationSound("negative");
  println("Adding negative influence..");
  currentState = STATE_GROUP_ACTIVE;
  currentInfluence = INFLUENCE_NEGATIVE;
}
void addSingleNegativeInfluence() {
  sendNotificationSound("negative");
  println("Adding negative influence..");
  currentState = STATE_SINGLE_ACTIVE;
  currentInfluence = INFLUENCE_NEGATIVE;
}
