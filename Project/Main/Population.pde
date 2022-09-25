
class Population {
  ArrayList<Agent> agents;
  
  // variables to take count of the population
  int awarePop,  unawarePop, neutralPop;
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
      else {
        i--;
      }
    }
    agents.get(0).awareness = +1.0f;
    agents.get(1).awareness = -1.0f;
  }
  
  Agent getRandomAgent() {
    return agents.get((int)random(agents.size()));
  }
  
  void updateAwarenessNumbers() {
    this.awarePop = 0;
    this.unawarePop = 0;
    this.neutralPop = 0;
    
    for (Agent a : agents) {
      
      if (a.awareness > 0.5) {
        awarePop++;
      }
      else if (a.awareness < -0.5) {
        unawarePop++;
      }
      else {
        neutralPop++;
      }
    }
    // these are used for controlling the musical effects through OSC
    this.unawareness = (float)unawarePop / (float)(awarePop + unawarePop);
    this.activity = 1 - ((float)neutralPop / (float)(awarePop + unawarePop + neutralPop));
    
    if (DEBUG) {
      println("Aware: " + awarePop + "| Unaware: " + unawarePop + "| Neutral: " + neutralPop);
      println("Total: " + (awarePop + unawarePop + neutralPop));
      println();
      println("Unawareness: " + unawareness + "| Activity: " + activity);
    }
  }
  
  boolean convertArea(float x, float y, float ray, float awareness) {
    boolean converted = false;
    Vec2 pointerPos = new Vec2(x, y);
    for (Agent a : agents) {
      Vec2 agentPos = W2P(a.body.getPosition());
      float distance = agentPos.sub(pointerPos).length();
      if(distance < ray) {
        awareness = constrain(awareness, -1.0, 1.0);
        a.awareness = awareness;
        converted = true;
      }
    }
    return converted;
  }
  
  boolean convertSingle(float x, float y, float ray, float awareness) {
    boolean converted = false;
    Vec2 pointerPos = new Vec2(x, y);
    for (Agent a : agents) {
      Vec2 agentPos = W2P(a.body.getPosition());
      float distance = agentPos.sub(pointerPos).length();
      if(distance < ray) {
        awareness = constrain(awareness, -1.0, 1.0);
        a.awareness = awareness;
        converted = true;
        break;
      }
    }
    return converted;
  }
  
  void highlightArea(float x, float y, float ray) {
    pushStyle();
    colorMode(HSB);
    Vec2 pointerPos = new Vec2(x, y);
    for (Agent a : agents) {
      Vec2 agentPos = W2P(a.body.getPosition());
      float distance = agentPos.sub(pointerPos).length();
      if(distance < ray) {
        float brightness = ((ray-distance)/ray);
        color c = color(180);
        if (a.awareness > +0.5) c = water.get(int(agentPos.x), int(agentPos.y));
        if (a.awareness < -0.5) c = fire.get(int(agentPos.x), int(agentPos.y));
        c = color(hue(c), saturation(c), brightness*brightness(c));
        fill(c);
        ellipse(agentPos.x, agentPos.y, RADIUS_AGENT, RADIUS_AGENT);
      }
    }
    popStyle();
  }
  
  void draw() {
    // Update and draw agents
    
    for (Agent a : agents) {
      a.update(agents, city.walls);
      a.draw();
    }
  }
}
