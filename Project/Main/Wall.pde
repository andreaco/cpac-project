
class Wall {
  float x, y;
  float w, h;

  Body body;
  
  Wall(float x_, float y_, float w_, float h_, color c_) {
    this(x_, y_, w_, h_);
  }
  
  Wall(float x_, float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;

    BodyDef bd = new BodyDef();
    bd.position.set(P2W(x, y));

    bd.type = BodyType.STATIC;
    body = box2d.createBody(bd);

    float box2dW = P2W(w/2);
    float box2dH = P2W(h/2);
    PolygonShape ps = new PolygonShape();

    ps.setAsBox(box2dW, box2dH);

    body.createFixture(ps, 1);
  }

  void display() {
    
    if(!DEBUG) {
      canvas.pushStyle();
      canvas.noStroke();
      canvas.rectMode(CENTER);
      //fill(80*noise(x+frameCount, y+frameCount), 2);
      canvas.fill(0,2);
      canvas.ellipse(x, y, random(0.6, 1.5)*w*3, random(0.6, 1.5)*h*3);
      canvas.popStyle();
    }
    else {
      pushStyle();
      fill(255);
      noStroke();
      rectMode(CENTER);
      rect(x, y, w*0.9, h*0.9);
      popStyle();
    }
    
  }
}
