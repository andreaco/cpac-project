
class Population {
  ArrayList<Agent> agents;
  
  // variables to take count of the population
  float awarePop,  unawarePop, neutralPop;
  float unawareness, activity;
  
  void insertNewAgent(float x, float y) {
      Agent b = new Agent(box2d, cs, bd, P2W(x, y));
      
      // initial random force
      Vec2 force = new Vec2(random(-1,1), random(-1,1));     
      b.applyForce(force.mul(SCALEFORCE));
      
      agents.add(b);     
  }
  
  
  Population(int numAgents) {
    agents = new ArrayList<Agent>();
    
    for (int i=0; i < numAgents; ++i) {
      int col = int(random(city.numCols));
      int row = int(random(city.numRows));
      
      if (city.citySkeleton[col][row] == STREET){
        insertNewAgent(row*city.blockWidth, col*city.blockHeight);
      }
    }
    agents.get(0).awareness = +1.0f;
    agents.get(1).awareness = -1.0f;
  }
  
  Agent getRandomAgent() {
    return agents.get((int)random(agents.size()));
  }
   
  void draw() {
    // Update and draw agents
    this.awarePop = 0;
    this.unawarePop = 0;
    this.neutralPop = 0;
      
    for (Agent a : agents) {
      a.update(agents, city.walls);
      a.draw();
    }
    
    // these are used for controlling the musical effects through OSC
    this.unawareness = unawarePop / (awarePop + unawarePop);
    this.activity = 1-(neutralPop / (awarePop + unawarePop + neutralPop));
  }
}
