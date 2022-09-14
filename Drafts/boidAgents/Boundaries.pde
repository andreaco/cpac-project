class Boundaries{
    float w;
    float h;
    int WEIGHT=5;
    int NBOUNDARIES = 12;
    Body[] bodies;
    Box2DProcessing  box2d;
    Boundaries(Box2DProcessing  box2d, float w, float h){
        this.box2d = box2d;
        this.w=w;
        this.h=h;
        BodyDef[] bds=new BodyDef[NBOUNDARIES]; //left, rigth, top, bottom
        PolygonShape[] pss=new PolygonShape[NBOUNDARIES];
        this.bodies= new Body[NBOUNDARIES];
        for(int i=0; i<NBOUNDARIES; i++){
          bds[i]=new BodyDef();
          pss[i]=new PolygonShape();
          bds[i].type= BodyType.STATIC;
          if(i<2){
            pss[i].setAsBox(box2d.scalarPixelsToWorld(this.WEIGHT/2),box2d.scalarPixelsToWorld(this.h/2));           
            bds[i].position.set(box2d.coordPixelsToWorld(i*this.w, this.h/2));
          }
          else if(i>=2 & i<4){
            pss[i].setAsBox(box2d.scalarPixelsToWorld(this.w/2),box2d.scalarPixelsToWorld(this.WEIGHT/2));   
            bds[i].position.set(box2d.coordPixelsToWorld(this.w/2, this.h*(i-2)));
          }
          else if(i==4){
            pss[i].setAsBox(box2d.scalarPixelsToWorld(this.WEIGHT/2),box2d.scalarPixelsToWorld(this.h/6));   
            bds[i].position.set(box2d.coordPixelsToWorld(this.w/3, 0.5*this.h/3));
          }
          else if(i==5){
            pss[i].setAsBox(box2d.scalarPixelsToWorld(this.WEIGHT/2),box2d.scalarPixelsToWorld(this.h/6));   
            bds[i].position.set(box2d.coordPixelsToWorld(2*this.w/3, 0.5*this.h/3));
          }
          else if(i==6){
            pss[i].setAsBox(box2d.scalarPixelsToWorld(this.WEIGHT),box2d.scalarPixelsToWorld(this.h/6));   
            bds[i].position.set(box2d.coordPixelsToWorld(this.w/3, this.h - this.h/6));
          }
          else if(i==7){
            pss[i].setAsBox(box2d.scalarPixelsToWorld(this.WEIGHT/2),box2d.scalarPixelsToWorld(this.h/6));   
            bds[i].position.set(box2d.coordPixelsToWorld(2*(this.w/3), this.h - this.h/6));
          }
          else if(i==8){
            pss[i].setAsBox(box2d.scalarPixelsToWorld(this.w/6),box2d.scalarPixelsToWorld(this.WEIGHT/2));   
            bds[i].position.set(box2d.coordPixelsToWorld(0.5*(this.w/3), this.h/3));
          }
          else if(i==9){
            pss[i].setAsBox(box2d.scalarPixelsToWorld(this.w/6),box2d.scalarPixelsToWorld(this.WEIGHT/2));   
            bds[i].position.set(box2d.coordPixelsToWorld(0.5*(this.w/3), 2*this.h/3));
          }
          else if(i==10){
            pss[i].setAsBox(box2d.scalarPixelsToWorld(this.w/6),box2d.scalarPixelsToWorld(this.WEIGHT/2));   
            bds[i].position.set(box2d.coordPixelsToWorld(this.w - this.w/6, this.h/3));
          }
          else if(i==11){
            pss[i].setAsBox(box2d.scalarPixelsToWorld(this.w/6),box2d.scalarPixelsToWorld(this.WEIGHT/2));   
            bds[i].position.set(box2d.coordPixelsToWorld(this.w - this.w/6, 2*this.h/3));
          }
          
          this.bodies[i] = this.box2d.createBody(bds[i]);
          this.bodies[i].createFixture(pss[i], 1);
          this.bodies[i].setUserData(null);

        }
    }
    void draw(){
      fill(255,150,150);
        stroke(0);
        rectMode(CENTER);        
      for (int i=0; i<NBOUNDARIES; i++){
        Vec2 pos=this.box2d.getBodyPixelCoord(this.bodies[i]); 
        if(i<2)                   rect(pos.x, pos.y, this.WEIGHT, this.h);
        else if(i>=2 & i<4)       rect(pos.x, pos.y, this.w, this.WEIGHT);
        else if(i==4)             rect(pos.x, pos.y, this.WEIGHT, this.h/3);
        else if(i==5)             rect(pos.x, pos.y, this.WEIGHT, this.h/3);
        else if(i==6)             rect(pos.x, pos.y, this.WEIGHT, this.h/3);
        else if(i==7)             rect(pos.x, pos.y, this.WEIGHT, this.h/3);
        else if(i==8)             rect(pos.x, pos.y, this.w/3, this.WEIGHT);
        else if(i==9)             rect(pos.x, pos.y, this.w/3, this.WEIGHT);
        else if(i==10)            rect(pos.x, pos.y, this.w/3, this.WEIGHT);
        else if(i==11)            rect(pos.x, pos.y, this.w/3, this.WEIGHT);
        
      }    
    }
}
