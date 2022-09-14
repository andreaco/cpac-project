
float BOID_AVOID_DIST=10;
float WALL_AVOID_DIST=5;
float ALIGN_DIST=0;
float TALK_DIST=5;

class Boid{
    Body body;
    Box2DProcessing  box2d;
    color defColor = color(200, 200, 200);
    color contactColor;
    boolean talking; // determines if the boid is talking to others
    Boid partner;
    
    Boid(Box2DProcessing  box2d, CircleShape ps, BodyDef bd, Vec2 position){
        this.box2d = box2d;    
        bd.position.set(position);
        this.body = this.box2d.createBody(bd);
        this.body.m_mass=1;
        this.body.createFixture(ps, 1);
        this.body.getFixtureList().setRestitution(0.8);
        this.body.getFixtureList().setFriction(0);
        this.body.setUserData(this); 
        this.talking =false;
    }
    void applyForce(Vec2 force){
      this.body.applyForce(force, this.body.getWorldCenter());      
    }
    void draw(){
        Vec2 posPixel=this.box2d.getBodyPixelCoord(this.body);
       
        fill(this.defColor);
        noStroke();
        ellipse(posPixel.x, posPixel.y, RADIUS_BOID, RADIUS_BOID);     
    }
    
    void update(ArrayList<Boid> boids, Boundaries walls){
      Vec2 myPosW=this.body.getPosition();
      Vec2 myVel=this.body.getLinearVelocity().clone();
      Vec2 otherPosW;
      Vec2 otherVel;
      Vec2 direction;
      float m;
      Vec2 align_force=new Vec2(0,0);
      Vec2 avoid_force=new Vec2(0,0);
      Vec2 stop_force=new Vec2(0,0);

      
      for(Boid other: boids){        
        if(this.body==other.body){continue;}
        otherPosW=other.body.getPosition();
        otherVel=other.body.getLinearVelocity().clone();
        direction= otherPosW.sub(myPosW);
        float test = 0;
       
        
        /*AVOID_FORCE: 
          goes away from boids that are closer
          than AVOID_DIST;*/
          
        if(direction.length()<BOID_AVOID_DIST & this.talking == false){
          m = 20/direction.clone().normalize();
          avoid_force.addLocal(direction.mul(-m));
          //println("m = " + m);
          //println("avoid_force = " + avoid_force);
          //println("direction = " + direction.mul(-m));
        }
        
        /*ALIGN_FORCE: 
          align your velocity to boids' 
          velocities that are closer 
          than ALIGN_DIST
          but further than AVOID_DIST */
          
        else if(direction.length()<ALIGN_DIST & this.talking == false){
          otherVel.normalize();
          otherVel.mulLocal(2);
          align_force.addLocal(otherVel);
          //println("Aligning to other boids");
        }
        
        // talking probability
        if(direction.length()<TALK_DIST & this.talking == false & other.talking == false){
            if(random(100) < 1){
              this.talking = true;
              other.talking = true;}
              this.partner = other;
              other.partner = this;
        }
        
        if(this.talking == true){
          if(myVel.length() != 0){
            Vec2 damping = new Vec2(0,0);
            damping = myVel.clone();
            damping.mulLocal(-10);
            stop_force.addLocal(damping);
            this.defColor = color(200, 50, 50);
            println("myVel " + myVel);
          }
          else{
            if(random(100) < 0.05){
              this.talking = false;
              this.partner.talking = false;
              this.defColor = color(200, 200, 200);
              this.partner.defColor = color(200, 200, 200);
              
              Vec2 force = new Vec2(random(-1,1), random(-1,1));
              this.applyForce(force.mul(2000));
              Vec2 force2 = new Vec2(random(-1,1), random(-1,1));
              this.partner.applyForce(force2.mul(2000));
            }
          }
      }
          
        
      }
      
      /*
      Avoid Boundaries
      */
      for(int i=0; i<walls.bodies.length; i++){
        Vec2 distance2 = new Vec2(0,0);
        Fixture wallsFix;
        float distance;
        wallsFix = walls.bodies[i].getFixtureList();
        distance = wallsFix.computeDistance(myPosW,10,distance2); //distance 2 is the vector normal to the boundary?
        //println(" wallPos " + i + " = " + walls.bodies.length);
        
        if(distance<WALL_AVOID_DIST & this.talking == false){
          //direction.normalize();
          m = 150/distance;
          avoid_force.addLocal(distance2.mul(m)); // 
          //println("Avoiding other boid!");
        }
      }
      
      if(avoid_force.length()>0){
      this.applyForce(avoid_force);
      //println("avoiding");
    }
      if(align_force.length()>0){this.applyForce(align_force);}
      if(stop_force.length()>0){this.applyForce(stop_force);}
    }
    
    void kill(){
        this.box2d.destroyBody(this.body);
    }

   
}
