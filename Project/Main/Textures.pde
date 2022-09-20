PImage water, fire;
PImage texture;

void initTextures() {
  fire    = loadImage("fire.jpg");
  water   = loadImage("water.jpg");
  texture = loadImage("paper_texture.jpg");
  water.resize(width,height);
  fire.resize(width,height);
  texture.resize(width, height);
}
