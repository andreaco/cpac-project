// Agent Interaction Constants
float COHESION_DIST = 3;
float AGENT_AVOID_DIST=3;
float WALL_AVOID_DIST= 2;
float ALIGN_DIST=3;
float INFECT_DIST = 2;

// Agents Physical Constants
float MAX_VEL = 12;
float MAX_FORCE = 1.2; 
int RADIUS_AGENT = 2;
int SCALEFORCE = 100;


class Agent {
    // Agent Physical Properties
    Body body;
    Box2DProcessing  box2d;
    
    // Awareness
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
      this.awareness = 0.0f;
    }
    
    
    
    // Apply Force Utility Function
    void applyForce(Vec2 force){
      // Clip force to a maximum
      if (force.length() > MAX_FORCE) {
        force.normalize();
        force.mulLocal(MAX_FORCE);
      }
      
      // Apply force
      this.body.applyForce(force, this.body.getWorldCenter());
      
      // Impose a maximum velocity
      Vec2 vel = this.body.getLinearVelocity();
      float speed = vel.length(); // magnitude of the vector
      if ( speed > MAX_VEL ){ 
        vel.normalize();
        this.body.setLinearVelocity( vel.mul(MAX_VEL) );
      }
    }
   
    
    // Infection
    void computeInfection(Agent other) {
      // Get other agent vectors
      Vec2 selfPos = this.body.getPosition();
      Vec2 otherPos  = other.body.getPosition();
      Vec2 direction = otherPos.sub(selfPos);
      
      // Infection
      if (direction.length() > 0 && direction.length() < INFECT_DIST) {
         if (other.awareness > 0.5) {
           awareness += 0.001;
         }
         else if (other.awareness < -0.5) {
           awareness -= 0.001;
         }
         awareness = constrain(awareness, -1, 1);
       }
    }
    
    // Agent Avoidance
    void computeAvoidance(Agent other, Vec2 avoidForce) {
      // Get other agent vectors
      Vec2 selfPos = this.body.getPosition();
      Vec2 otherPos  = other.body.getPosition();
      Vec2 direction = otherPos.sub(selfPos);
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
    }
    
    // Alignment
    void computeAlignment(Agent other, Vec2 alignForce) {
       // Get other agent vectors
      Vec2 selfPos = this.body.getPosition();
      Vec2 otherPos  = other.body.getPosition();
      Vec2 direction = otherPos.sub(selfPos);
      Vec2 otherVel  = other.body.getLinearVelocity().clone();

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
    }
    
    // Wall Avoidance
    void computeAvoidance(Wall wall, Vec2 avoidForce) {
      Vec2 selfPos = this.body.getPosition();

      Vec2 wallPos = wall.body.getPosition();
      Vec2 direction = wallPos.sub(selfPos);

      if(direction.length() <WALL_AVOID_DIST){
        avoidForce.addLocal(direction.mul(-10));
      }
    }
    
    // Update function
    void update(ArrayList<Agent> agents, ArrayList<Wall> walls){
      // Forces
      Vec2 avoidForce  = new Vec2(0, 0);
      Vec2 alignForce  = new Vec2(0, 0);
      
      // Compute reaction to other agents
      for(Agent other: agents){
        // Skip when it's same agent
        if(this.body == other.body){ continue; }
        // Infection
        computeInfection(other);
        // Avoidance
        computeAvoidance(other, avoidForce);
        // Alignment  
        computeAlignment(other, alignForce);
      }
      
      //Avoid Boundaries
      for(int i=0; i < walls.size(); i++){
        Wall wall = walls.get(i);
        computeAvoidance(wall, avoidForce);
      }
      
      // Apply forces
      if(avoidForce.length()>0) { this.applyForce(avoidForce); }
      if(alignForce.length()>0) { this.applyForce(alignForce); }
    }
    
    
    void renderAware(Vec2 position) {
      if(!DEBUG) {
        canvas.noStroke();
        // Get color from texture
        color awareColor = water.get(int(position.x), int(position.y));
        
        // Glow
        canvas.fill(awareColor, 4);
        canvas.ellipse(position.x, position.y, RADIUS_AGENT*random(15), RADIUS_AGENT*random(15));
        
        // Light Source 
        canvas.fill(awareColor, 20);
        canvas.ellipse(position.x, position.y, RADIUS_AGENT, RADIUS_AGENT);
      }
      else {
        fill(0, 255, 0);
        ellipse(position.x, position.y, RADIUS_AGENT*2, RADIUS_AGENT*2);
      }
    }
    
    void renderNeutral(Vec2 position) {
      if(!DEBUG) {
        canvas.noStroke();
        // TODO: tune the visibility of neutral agents
        float visibility = 50;
        canvas.fill(visibility, 10);
        canvas.ellipse(position.x, position.y, RADIUS_AGENT, RADIUS_AGENT);
      }
      else {
        fill(200, 200, 200);
        ellipse(position.x, position.y, RADIUS_AGENT*2, RADIUS_AGENT*2);
      }
    }
    
    void renderUnaware(Vec2 position) {
      if(!DEBUG) {
        canvas.noStroke();
        // Get color from texture
        color unawareColor = fire.get(int(position.x), int(position.y));
        
        // Glow
        canvas.fill(unawareColor, 4);
        canvas.ellipse(position.x, position.y, RADIUS_AGENT*random(15), RADIUS_AGENT*random(15));
        
        // Light Source 
        canvas.fill(unawareColor, 20);
        canvas.ellipse(position.x, position.y, RADIUS_AGENT, RADIUS_AGENT);
      }
      else {
        fill(255, 0, 0);
        ellipse(position.x, position.y, RADIUS_AGENT*2, RADIUS_AGENT*2);
      }
    }
    
    // Rendering function
    void draw() {
      canvas.pushStyle();
      
      // Get Position in Pixels
      Vec2 posPixel = this.box2d.getBodyPixelCoord(this.body);
      
      if (awareness > 0.5f) {
        renderAware(posPixel);
      }
      else if (awareness < -0.5f) {
        renderUnaware(posPixel);
      }
      else {
        renderNeutral(posPixel);
      }
      
      canvas.popStyle();
    }
}
