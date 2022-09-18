
// Agents Collections
ArrayList<Agent> agents;
City city;


void setup() {
  size(860, 720, P3D);
  
  // Initialize OSC
  initOSC();
  
  // Initialize Box2D
  initBox2D();
  
  // City initialization
  city = new City(50, 50);
  
  // Agent Collection
  initAgents();
}


void draw() {
  // Update physical model
  box2d.step();
  
  // Semi-transparent background
  fill(0,100);
  rect(0, 0, width, height);
  
  // Draw city
  city.draw();
  
  // Update and draw agents
  for (Agent b : agents) {
    b.update(agents, city.walls);
    b.draw();
  }
  
}


void mousePressed() {
  //insert a new box
  if(mouseButton == LEFT){
    insertNewAgent(mouseX, mouseY);
  }
  
  for (Agent agent : agents) {
    agent.update(agents, city.walls);
  }
}
