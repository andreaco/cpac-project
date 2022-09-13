import oscP5.*; // OscP5, OscMessage
import netP5.*; // NetAdress

// OSC Objects
OscP5 oscP5;
NetAddress netAddress;

// Agents
ArrayList<Agent> agents;
ArrayList<Agent> walls;


int[] palette = {#ff184c, #ff577d, #0a9cf5, #003062};
void setup() {
  size(800, 800, P2D);
  
  // Initialize OSC objects and address
  oscP5 = new OscP5(this, 12000);
  netAddress = new NetAddress("127.0.0.1", 12000);
  
  agents = new ArrayList<Agent>();
  walls = new ArrayList<Agent>();
  
  for (int i=0; i < 300; ++i) {
    agents.add(new Agent(random(width), random(height)));
  }
  agents.get(0).infected = 1.0f;
  agents.get(1).infected = 1.0f;
  agents.get(2).infected = 1.0f;
  agents.get(2).infected = -1.0f;
  
  int N = 20;
  for (int row=0; row <N; ++row) {
    for (int col=0; col <N; ++col) {
      if(row%3 == 0 || col%3 == 0 && random(1)>0.1 ) {
         Agent a = new Agent(col*width/N, row*height/N);
         a.acceleration.mult(0);
         a.velocity.mult(0);
         walls.add(a);
      }
         
    }
  }
  background(0);
  

}


void draw() {
  //background(0);
  noStroke();
  fill(0, 20);
  rect(0, 0, width, height);
  for (Agent agent : agents) {
    //agent.applyForce(agent.avoidWall(walls).mult(100));
    
    agent.applyForce(agent.avoid(agents));
    agent.applyForce(agent.cohesion(agents));
    agent.applyForce(agent.align(agents));
    //agent.applyForce(agent.avoid(walls));
    agent.update();
  }

  
  for (Agent agent : agents) {
    fill(255);
    agent.draw();
  }
  
  //for (Agent wall : walls) {
  //  wall.draw();
  //}
  //for (Agent wall : walls) {
  //  fill(255, 0, 0);
  //  wall.draw();
  //}
}


void oscEvent(OscMessage theOscMessage) {
  
}

void keyPressed() {
  if(key == '1') {
    int idx = int(random(0, agents.size()));
    agents.get(idx).infected = 1.0;
  }
  if(key == '0') {
    int idx = int(random(0, agents.size()));
    agents.get(idx).infected = -1.0;
  }
    
}
