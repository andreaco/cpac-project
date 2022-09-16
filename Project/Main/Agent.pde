/*
 * Agent Constants
 */
float BOID_AVOID_DIST=1;
float WALL_AVOID_DIST=1;
float INFECT_DIST = 1;
float ALIGN_DIST=2;
float TALK_DIST=0;
float MAX_VEL = 0.1;

class Agent {
    // Agent Properties
    Body body;
    Box2DProcessing  box2d;
    
    color defColor = color(200, 200, 200);
    color contactColor;
    boolean talking; // determines if the boid is talking to others
    Agent partner;
    
    float awareness;
    
    // Constructor
    Agent(Box2DProcessing  box2d, CircleShape ps, BodyDef bd, Vec2 position){
      // Box2D
      this.box2d = box2d;    
        
      // Body
      bd.position.set(position);
      this.body = this.box2d.createBody(bd);
      this.body.m_mass=1;
      this.body.createFixture(ps, 1);
      this.body.getFixtureList().setRestitution(0.8);
      this.body.getFixtureList().setFriction(0);
      this.body.setUserData(this); 
      
      // Agent Variables
      this.talking = false;
      this.awareness = 0.0f;
    }
    
    // Apply Force Utility Function
    void applyForce(Vec2 force){
      this.body.applyForce(force, this.body.getWorldCenter());
      
      // Impose a maximum velocity
      Vec2 vel = this.body.getLinearVelocity();
      float speed = vel.length(); // magnitude of the vector
      if ( speed > MAX_VEL ){ 
        vel.normalize();
        this.body.setLinearVelocity( vel.mul(MAX_VEL) );}
    }
    
    // Rendering function
    void draw() {
      // Get Position in Pixels
      Vec2 posPixel = this.box2d.getBodyPixelCoord(this.body);
     
      // Draw Ellipse
      if (awareness > 0.5f) {
        fill(255, 0, 0);
      }
      else if (awareness < -0.5f) {
        fill(0, 255, 0);
      }
      else {
        fill(this.defColor);
      }
      noStroke();
      ellipse(posPixel.x, posPixel.y, RADIUS_AGENT, RADIUS_AGENT);     
    }
    
    // Update function
    void update(ArrayList<Agent> agents, ArrayList<Wall> walls){
      // Temporary Variables
      Vec2 myPosW = this.body.getPosition();
      Vec2 myVel  = this.body.getLinearVelocity().clone();
      float m;
      
      Vec2 align_force = new Vec2(0, 0);
      Vec2 cohesion_force = new Vec2(0, 0);
      Vec2 avoid_force = new Vec2(0, 0);
      Vec2 stop_force  = new Vec2(0, 0);

      
      // Compute reaction to other agents
      for(Agent other: agents){
        // Skip when it's same agent
        if(this.body == other.body){ continue; }
        
        // Get other agent vectors
        Vec2 otherPosW = other.body.getPosition();
        Vec2 otherVel  = other.body.getLinearVelocity().clone();
        Vec2 direction = otherPosW.sub(myPosW);
       
        /*
         * INFECTION
         */
         if (direction.length() > 0 && direction.length() < INFECT_DIST) {
           if (other.awareness > 0.5) {
             awareness += 0.01;
           }
           if (other.awareness < -0.5) {
             awareness -= 0.01;
           }
           awareness = constrain(awareness, -1, 1);
         }
       
        /*
         * AVOIDANCE 
         * Avoid other agents that closer than AVOID_DIST
         */
        if(direction.length() < BOID_AVOID_DIST & this.talking == false){
          m = 1/direction.clone().normalize();
          avoid_force.addLocal(direction.mul(-m));
        }
        
        /* 
         * ALIGNMENT 
         * align your velocity to boids' 
         * velocities that are closer 
         * than ALIGN_DIST
         * but further than AVOID_DIST
         */
          
        if(direction.length()<ALIGN_DIST & this.talking == false){
          otherVel.normalize();
          otherVel.mulLocal(2);
          align_force.addLocal(otherVel);
        }
        
        /**
         * COHESION
         */ 
        if(direction.length() > 0 && direction.length()<ALIGN_DIST){
          int count = 0;
          if ((other.awareness > 0.5f && awareness > 0.5f) ||
              (other.awareness < 0.5f && awareness < 0.5f)){
                cohesion_force.addLocal(otherPosW);
                count++;
          }
          if (count > 0) {
            cohesion_force.mul(1.0f/(float)count);
          }
        }

        
        //// TALKING
         
        //if(direction.length()<TALK_DIST & this.talking == false & other.talking == false){
        //    if(random(100) < 1){
        //      this.talking = true;
        //      other.talking = true;
        //      this.partner = other;
        //      other.partner = this;}
        //}
        //if(this.talking == true) {
        //  if(myVel.length() != 0) {
        //    Vec2 damping = new Vec2(0,0);
        //    damping = myVel.clone();
        //    damping.mulLocal(-10);
        //    stop_force.addLocal(damping);
        //    this.defColor = color(200, 50, 50);
        //  }
        //  else if(random(100) < 0.05) {
        //      this.talking = false;
        //      this.partner.talking = false;
        //      this.defColor = color(200, 200, 200);
        //      this.partner.defColor = color(200, 200, 200);
              
        //      Vec2 force = new Vec2(random(-1,1), random(-1,1));
        //      this.applyForce(force.mul(2000));
        //      Vec2 force2 = new Vec2(random(-1,1), random(-1,1));
        //      this.partner.applyForce(force2.mul(2000));
        //  }
          
        //} // End Talking
      } // End For Loop
      
      
      //Avoid Boundaries
      
      for(int i=0; i<walls.size(); i++){
        Vec2 distance2 = new Vec2(0,0);
        Fixture wallsFix;
        float distance;
        wallsFix = walls.get(i).b.getFixtureList();
        distance = wallsFix.computeDistance(myPosW,10,distance2); //distance 2 is the vector normal to the boundary?
        
        if(distance<WALL_AVOID_DIST & this.talking == false){
          //direction.normalize();
          m = 1/distance;
          avoid_force.addLocal(distance2.mul(m)); // 
          //println("Avoiding other boid!");
        }
      } // End Boundaries
      
      
      // Apply forces
      if(avoid_force.length()>0) {
        this.applyForce(avoid_force);
      }
      if(align_force.length()>0) {
        this.applyForce(align_force);
      }
      if(stop_force.length()>0) {
        this.applyForce(stop_force);
      }
      if(cohesion_force.length()>0) {
        this.applyForce(cohesion_force);
      }
    }
    
    void kill(){
        this.box2d.destroyBody(this.body);
    }
}
