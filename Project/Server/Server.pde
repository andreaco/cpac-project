import oscP5.*; // OscP5, OscMessage
import netP5.*; // NetAdress

OscP5 oscP5;
NetAddress netAddress;

void setup() {
  size(400, 400);
  
  // Initialize OSC objects and address
  oscP5 = new OscP5(this, 12000);
  netAddress = new NetAddress("127.0.0.1", 12000);
}


void draw() {
  background(0);
}

void keyPressed() {
  OscMessage veridicityOscMsg = new OscMessage("/fake-news/veridicity");
  veridicityOscMsg.add(1);
  oscP5.send(veridicityOscMsg, netAddress);
}
