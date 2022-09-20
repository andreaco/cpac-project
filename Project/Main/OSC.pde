import oscP5.*; // OscP5, OscMessage
import netP5.*; // NetAdress

// OSCP5 Objects
OscP5 oscP5;
NetAddress netAddress;

void initOSC() {
  // Initialize OSC objects and address
  //oscP5 = new OscP5(this, 12000);
  //netAddress = new NetAddress("127.0.0.1", 12000);
}

void oscEvent(OscMessage oscMsg) {
  println("Received an osc message");
}
