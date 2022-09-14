import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

int RADIUS_BOID=20;
float SCALEFORCE=2000;
float DIST_TO_NEXT=50;
String filenames[];
Box2DProcessing box2d;
BodyDef bd;
Boundaries boundaries;
CircleShape cs;
ArrayList<Boid> boids;

Vec2 P2W(Vec2 in_value){
  return box2d.coordPixelsToWorld(in_value);
}

Vec2 P2W(float pixelX, float pixelY){
  return box2d.coordPixelsToWorld(pixelX, pixelY);
}

float P2W(float in_value){
  return box2d.scalarPixelsToWorld(in_value);
}

Vec2 W2P(Vec2 in_value){
  return box2d.coordWorldToPixels(in_value);
}

Vec2 W2P(float worldX, float worldY){
  return box2d.coordWorldToPixels(worldX, worldY);
}

float W2P(float in_value){
  return box2d.scalarWorldToPixels(in_value);
}


void setup() {
  size(720, 720);
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);
  boids=new ArrayList<Boid>();
  boundaries=new Boundaries(box2d, width, height);
  bd= new BodyDef();
  bd.type= BodyType.DYNAMIC;
  cs  = new CircleShape();
  cs.m_radius = P2W(RADIUS_BOID/2);
  bd.linearDamping=0;
}
void mousePressed() {
 if(mouseButton==LEFT){//insert a new box
    Boid b = new Boid(box2d, cs, bd, P2W(mouseX, mouseY));
    
    // initial random force
    Vec2 force = new Vec2(random(-1,1), random(-1,1));     
    b.applyForce(force.mul(SCALEFORCE));
    
    boids.add(b);     
  }
  if(mouseButton==RIGHT){ 
    ;
  }
}
 
void draw() {
  fill(0,50);
  rect(width/2, height/2, width, height);
  box2d.step();
  boundaries.draw();
  for (Boid b : boids) {
    b.update(boids, boundaries);
    b.draw();
  }
}
