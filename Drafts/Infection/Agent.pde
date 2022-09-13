int RADIUS_CIRCLE=10;
int LIMIT_VELOCITY=50;
float CONSTANT_ACC=100;

float alpha=0.1;  

float maxspeed = 1;
float maxforce = 0.025;
float swt = 55.0;


class Agent {
  // Agent Position, Velocity and Acceleration vectors
  PVector position;
  PVector velocity;
  PVector acceleration;
  
  // ??
  float r;
  
  // Infection status, -1.0f well informed, +1.0f conspiracy theorist
  float infected;
  
  /**
   * Constructor, instatiates physiscs vectors and infection
   */
  Agent(float x, float y) {
    // Set the position to the input
    this.position = new PVector(x, y);
    // Set random velocity
    this.velocity = new PVector(random(-1,1), random(-1,1));
    // No acceleration to begin with
    this.acceleration = new PVector(0, 0);
    
    // Set initial infection status
    this.infected = random(-0.2, 0.2f);
  }
  
  /**
   * Apply force utility function
   */
  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    this.acceleration.add(force);
  }
  
  /**
   * Computes steering vector towards target
   */
  PVector seek(PVector target) {
    // A vector pointing from the location to the target
    PVector desired = PVector.sub(target,position);  

    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired,velocity);
    steer.limit(maxforce);  // Limit to maximum steering force

    return steer;
  }
  
  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Agent> boids) {
    float neighbordist = 10.0;
    PVector steer = new PVector();
    int count = 0;
    for (Agent other : boids) {
      float d = PVector.dist(position,other.position);
      if ((d > 0) && (d < neighbordist)) {
        if (other.infected > 0.5f && infected > 0.5f) {
          steer.add(other.velocity);
          count++;
        }
      }
    }
    if (count > 0) {
      steer.div((float)count);
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }
  
  PVector cohesion (ArrayList<Agent> boids) {
    float neighbordist = 20.0;
    PVector sum = new PVector(0,0);   // Start with empty vector to accumulate all locations
    int count = 0;
    for (Agent other : boids) {
      float d = PVector.dist(position,other.position);
      if ((d > 0) && (d < neighbordist)) {
        if ((other.infected > 0.5f && infected > 0.5f) || (other.infected < -0.5f && infected < -0.5f)) {
          sum.add(other.position); // Add location
          count++;
        }
      }
    }
    if (count > 0) {
      sum.div((float)count);
      return seek(sum);  // Steer towards the location
    }
    return sum;
  }
  
  PVector avoid (ArrayList<Agent> agents) {
    float amount = 20.0;
    PVector steer = new PVector(0,0);
    int count = 0;
    
    for (Agent a: agents) {
      float d = PVector.dist(this.position, a.position);
      if ((d > 0) && (d < amount)) {
        if (a.infected > 0.5) {
          infected += a.infected / 20;
          
        }
        if (a.infected < -0.5) {
          infected += a.infected / 15;
        }
        infected = constrain(infected, -1, 1);
        PVector diff = PVector.sub(position, a.position);
        diff.normalize();
        diff.div(d);
        steer.add(diff);
        count++;
      }
    }
    if (count > 0) {
      steer.div((float) count);
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(this.velocity);
      steer.limit(maxforce);
    }
    
    return steer;
  }
  
  
  PVector avoidWall (int[] walls) {
    float amount = 30.0;
    PVector steer = new PVector(0,0);
    int count = 0;
    
    for (Agent a: agents) {
      //wallPosition
      float d = PVector.dist(this.position, a.position);
      if ((d > 0) && (d < amount)) {
        PVector diff = PVector.sub(position, a.position);
        diff.normalize();
        diff.div(d);
        steer.add(diff);
        count++;
      }
    }
    if (count > 0) {
      steer.div((float) count);
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(this.velocity);
      steer.limit(maxforce);
    }
    
    return steer;
  }
  
  void update(){
    this.velocity.add(this.acceleration);
    
    this.velocity.limit(maxspeed);
    this.position.add(this.velocity);
    this.acceleration.mult(0.0f);
    
    if(this.position.x > width)
      this.position.x = 0;
    else if(this.position.x < 0)
      this.position.x = width;
      
    if(this.position.y > height)
      this.position.y = 0;
    else if(this.position.y < 0)
      this.position.y = height;
      
  }
  
  void draw(){
    //fill(200);
    if (infected > 0.7f)
      fill(palette[0]);
    else if(infected > 0.5f) 
      fill(palette[1]);
    else if (infected < -0.5f)
      fill(palette[2]);
    else if (infected < -0.99) {
      fill(palette[3]);
    }
    else
      fill(180);
    ellipse(this.position.x, this.position.y, RADIUS_CIRCLE, RADIUS_CIRCLE);
  }

}
