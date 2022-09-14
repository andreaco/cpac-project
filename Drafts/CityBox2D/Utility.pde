Vec2 P2W(Vec2 in_value){
  return box2d.coordPixelsToWorld(in_value);
}

Vec2 P2W(float pixelX, float pixelY){
  return box2d.coordPixelsToWorld(pixelX, pixelY);
}

float P2W(float in_value){
  return box2d.scalarPixelsToWorld(in_value);
}

Vec2 W2P(Vec2 in_value){
  return box2d.coordWorldToPixels(in_value);
}

Vec2 W2P(float worldX, float worldY){
  return box2d.coordWorldToPixels(worldX, worldY);
}

float W2P(float in_value){
  return box2d.scalarWorldToPixels(in_value);
}
