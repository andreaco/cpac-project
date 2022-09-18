import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

// Box2D Objects 
Box2DProcessing box2d;
BodyDef bd;
CircleShape cs;

// Box2D Setup
void initBox2D() {
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.setGravity(0, 0);
  bd= new BodyDef();
  bd.type= BodyType.DYNAMIC;
  cs  = new CircleShape();
  cs.m_radius = P2W(RADIUS_AGENT/2);
  bd.linearDamping=0;
}
