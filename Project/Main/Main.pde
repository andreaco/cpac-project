import oscP5.*; // OscP5, OscMessage
import netP5.*; // NetAdress
import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;


/**
 * OSCP5 Objects
 */
OscP5 oscP5;
NetAddress netAddress;

/**
 * Box2D Objects
 */
Box2DProcessing box2d;
BodyDef bd;
CircleShape cs;

/**
 * Agents Collections
 */
ArrayList<Agent> agents;
City city;

/**
 * Constants
 */
int RADIUS_AGENT = 10;
int SCALEFORCE = 2000;

void setup() {
  size(720, 720);
  
  // Initialize OSC objects and address
  oscP5 = new OscP5(this, 12000);
  netAddress = new NetAddress("127.0.0.1", 12000);
  
  // Box2D Setup
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);
  bd= new BodyDef();
  bd.type= BodyType.DYNAMIC;
  cs  = new CircleShape();
  cs.m_radius = P2W(RADIUS_AGENT/2);
  bd.linearDamping=0;
  
  // Agent Collection
  agents = new ArrayList<Agent>();
  
  city = new City(40, 40);
}


void mousePressed() {
  //insert a new box
 if(mouseButton == LEFT){
    Agent b = new Agent(box2d, cs, bd, P2W(mouseX, mouseY));
    
    // initial random force
    Vec2 force = new Vec2(random(-1,1), random(-1,1));     
    b.applyForce(force.mul(SCALEFORCE));
    
    agents.add(b);     
  }
  
  for (Agent agent : agents) {
    agent.update(agents);
  }
}

void oscEvent(OscMessage theOscMessage) {
  println("Received an osc message.");
  for (Agent agent : agents) {
    agent.update(agents);
  }
}

void draw() {
  
  fill(0,100);
  
  rect(0, 0, width, height);
  
  box2d.step();
  
  //boundaries.draw();
  
  for (Agent b : agents) {
    b.update(agents);
    b.draw();
  }
  
  city.draw();
}
