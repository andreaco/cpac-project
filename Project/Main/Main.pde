import oscP5.*; // OscP5, OscMessage
import netP5.*; // NetAdress

// OSC Objects
OscP5 oscP5;
NetAddress netAddress;

// Agents
Agent[] agents;

void setup() {
  size(400, 400);
  
  // Initialize OSC objects and address
  oscP5 = new OscP5(this, 12000);
  netAddress = new NetAddress("127.0.0.1", 12000);
  
  agents = new Agent[10];
  for (int i=0; i < agents.length; ++i) {
    agents[i] = new Agent();
  }
}


void draw() {
  background(0);
  
  for (Agent agent : agents) {
    agent.draw();
  }
}


void oscEvent(OscMessage theOscMessage) {
  println("Received an osc message.");
  for (Agent agent : agents) {
    agent.update();
  }
}
