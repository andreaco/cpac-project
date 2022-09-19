
// Agents Collections
ArrayList<Agent> agents;
City city;


void setup() {
  //size(860, 720, P3D);
  fullScreen();
  //smooth(8);
  // Initialize OSC
  initOSC();
  
  // Initialize Box2D
  initBox2D();
  
  // City initialization
  city = new City(50, 50);
  
  // Agent Collection
  initAgents();
  background(0);
  //bg = loadImage("gray_texture.jpg");
  bg2 = loadImage("fire.jpg");
  bg = loadImage("water.jpg");
  bg.resize(width,height);
  bg2.resize(width,height);
  
  
  texture = loadImage("paper_texture.jpg");
  texture.resize(width, height);
  
  
  city.draw();
  city.draw();
  city.draw();
  city.draw();
  city.draw();
}


PImage bg, bg2;
PImage texture;
void draw() {

  // Update physical model
  box2d.step();
  // Draw city
  if(frameCount % 1 == 0) {
    //fill(0, 5);
    //rect(0, 0, width, height);
    city.draw();
  }
  
  //rect(0, 0, width, height);
  
  // Update and draw agents
  for (Agent b : agents) {
    b.update(agents, city.walls);
    b.draw();
  }

  
  //filter();
  // Semi-transparent background
  tint(10,3);
  image(texture,0,0);
}


void keyPressed() {
  //insert a new box
  if(key == 'w'){
    for (int i = 0; i < 100; i++) {
      Agent a = agents.get((int)random(agents.size()));
      a.awareness = 1.0;
    } 
  }
  
  if(key == 's'){
    for (int i = 0; i < 100; i++) {
      Agent a = agents.get((int)random(agents.size()));
      a.awareness = -1.0;
    } 
  }
  
  if(key == 'a'){
    Agent a = agents.get((int)random(agents.size()));
    a.awareness = -1.0;
  }
  
  if(key == 'd'){
    Agent a = agents.get((int)random(agents.size()));
    a.awareness = 1.0;
  }
  
  if(key == '1'){
    city.generateCity();
  }
}
