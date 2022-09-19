

// TODO REFACTOR AND MOVE THESE FUNCTIONS
void insertNewAgent(float x, float y) {
    Agent b = new Agent(box2d, cs, bd, P2W(x, y));
    
    // initial random force
    Vec2 force = new Vec2(random(-1,1), random(-1,1));     
    b.applyForce(force.mul(SCALEFORCE));
    
    agents.add(b);     
}

void initAgents() {
  agents = new ArrayList<Agent>();
  
  for (int i=0; i < STARTING_AGENTS; ++i) {
    int col = int(random(city.numCols));
    int row = int(random(city.numRows));
    
    if (city.citySkeleton[col][row] == STREET){
      insertNewAgent(row*city.blockWidth, col*city.blockHeight);
    }
  }
  agents.get(0).awareness = +1.0f;
  agents.get(1).awareness = -1.0f;
}


/*
 * Agent Constants
 */
float COHESION_DIST = 3;
float AGENT_AVOID_DIST=3;
float WALL_AVOID_DIST= 2;
float INFECT_DIST = 2;
float ALIGN_DIST=3;
float TALK_DIST=0;
float MAX_VEL = 12;
float MAX_FORCE = 1.2; 
int RADIUS_AGENT = 2;
int SCALEFORCE = 100;
int STARTING_AGENTS = 800; 

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
      if (force.length() > MAX_FORCE) {
        force.normalize();
        force.mulLocal(MAX_FORCE);
      }
      this.body.applyForce(force, this.body.getWorldCenter());
      
      // Impose a maximum velocity
      Vec2 vel = this.body.getLinearVelocity();
      float speed = vel.length(); // magnitude of the vector
      if ( speed > MAX_VEL ){ 
        vel.normalize();
        this.body.setLinearVelocity( vel.mul(MAX_VEL) );
      }
    }
    
    
    
    // Rendering function
    void draw() {
      // Get Position in Pixels
      Vec2 posPixel = this.box2d.getBodyPixelCoord(this.body);
      
      //float intens = brightness(bg.get(int(posPixel.x), int(posPixel.y)));
      color col1 = bg.get(int(posPixel.x), int(posPixel.y));
      color col2 = bg2.get(int(posPixel.x), int(posPixel.y));
      colorMode(HSB, 255);
       // Draw Ellipse
      if (awareness > 0.5f) {
        //fill(0, 200, 255*intens, 4);
        fill(col1, 4);
      }
      else if (awareness < -0.5f) {
        //fill(120, 200, 255*intens, 4);
        fill(col2, 4);
      }
      else {
        fill(0, 0, 10, 0);
      }
      noStroke();
      ellipse(posPixel.x, posPixel.y, RADIUS_AGENT*random(40), RADIUS_AGENT*random(40));   
      
      // Draw Ellipse
      if (awareness > 0.5f) {
        //fill(0, 200, 255*intens, 10);
        fill(col1, 20);
        
      }
      else if (awareness < -0.5f) {
        //fill(120, 200, 255*intens, 10);
        fill(col2, 20);
      }
      else {
        fill(0, 0, 0, 20);
      }
      noStroke();
      ellipse(posPixel.x, posPixel.y, RADIUS_AGENT, RADIUS_AGENT);   
      
    }
   
    
    
    // Update function
    void update(ArrayList<Agent> agents, ArrayList<Wall> walls){
      // Temporary Variables
      Vec2 selfPos = this.body.getPosition();
      Vec2 selfVel = this.body.getLinearVelocity();
      
      Vec2 avoidForce  = new Vec2(0, 0);
      Vec2 alignForce  = new Vec2(0, 0);
      Vec2 followForce = new Vec2(0, 0);
      
      
      // Compute reaction to other agents
      for(Agent other: agents){
        // Skip when it's same agent
        if(this.body == other.body){ continue; }
        
        // Get other agent vectors
        Vec2 otherPos  = other.body.getPosition();
        Vec2 otherVel  = other.body.getLinearVelocity().clone();
        Vec2 direction = otherPos.sub(selfPos);
       
       
        // INFECTION
        if (direction.length() > 0 && direction.length() < INFECT_DIST) {
           if (other.awareness > 0.5) {
             //awareness += 0.002;
             awareness += 0.01;
           }
           else if (other.awareness < -0.5) {
             //awareness -= 0.002;
             awareness -= 0.01;
           }
           awareness = constrain(awareness, -1, 1);
         }
       
        
        // AVOIDANCE
        if(direction.length() < AGENT_AVOID_DIST) {
          if (awareness * other.awareness < 0) {
            direction.normalize();
            direction.mulLocal(-3);          
            avoidForce.addLocal(direction);
          }
          else {
            direction.normalize();
            direction.mulLocal(-1);          
            avoidForce.addLocal(direction);
          }
          
        }
        
        
        // ALIGN  
        if(direction.length() < ALIGN_DIST) {
          if ((other.awareness > 0.5f && awareness > 0.5f)) {
            otherVel.normalize();
            otherVel.mulLocal(2);
            alignForce.addLocal(otherVel);
          }
          else {
            otherVel.normalize();
            otherVel.mulLocal(0.1);
            alignForce.addLocal(otherVel);
          }
        }
        
        
        // COHESION
        if(direction.length() < COHESION_DIST){
          if ((other.awareness > 0.5f && awareness > 0.5f) ||
              (other.awareness < -0.5f && awareness < -0.5f)) {
                followForce.addLocal(otherPos.mul(0.01));
          }
        }
      } // End For Loop
      
      
      ////Avoid Boundaries
      
      for(int i=0; i<walls.size(); i++){
        Wall wall = walls.get(i);
        Vec2 wallPos = wall.body.getPosition();

        Vec2 direction = wallPos.sub(selfPos);

        if(direction.length() <WALL_AVOID_DIST & this.talking == false){
          
          avoidForce.addLocal(direction.mul(-10)); // 
        }
      } // End Boundaries
      
      
      // Apply forces
      if(avoidForce.length()>0) {
        this.applyForce(avoidForce);
      }
      if(alignForce.length()>0) {
        this.applyForce(alignForce);
      }
      //if(followForce.length()>0) {
      //  this.applyForce(followForce);
      //}
    }
    
    
    
    void kill(){
        this.box2d.destroyBody(this.body);
    }
}
