class Ball {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float size;
  float mass = 30;
  int hue;

  Ball(PVector l) {
    acceleration = new PVector(0,0);
    velocity = new PVector(random(10),random(-2,0));
    location = l.get();
    size = 30;
    hue = 0;
  }

  void run() {
    update();
    display();
  }

  void applyForce(PVector force) {
    PVector f = force.get();
    f.div(mass);   
    acceleration.add(f);
  }

  // Method to update location
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
    velocity.limit(16);
    velocity.mult(0.999);
    //lifespan -= 2.0;
  }

  // Method to display
  void display() {
    push();
    stroke(0);
    strokeWeight(2);
    
    //noStroke();
    colorMode(HSB);
    fill(hue % 360, 200 , 255);
    ellipse(location.x,location.y,size,size);
    pop();
  }
  
  void setSize(float value) {
    size = value;
  }

  // Is the particle still useful?
  //boolean isDead() {
  //  if (lifespan < 0.0) {
  //    return true;
  //  } else {
  //    return false;
  //  }
  //}
}

class Player extends Ball {
  int side;
  float originalSize;
  Player(PVector l, int s) {
    super(l);
    this.setSize(130);
    originalSize = size;
    side = s;
    velocity = new PVector(0,0);
  }
  
  void display() {

    noStroke();
    if (side == 1) {
      fill(200, 0, 0, size * 1.1);
    }
    else if (side == 2) {
      fill(0, 0, 200, size* 1.1);
    }

    ellipse(location.x,location.y,size,size);

    if (size > 160) {
          push();
      for (int i = 0; i < 20; i++) {
      float d = map(i, 0, 20, 0, size);
      float op = map(d, 0, size, 80, 0);
      stroke(255, op);
      strokeWeight(20);
      noFill();
      circle(location.x,location.y,d);
      }
          pop();
    }

  }
  
  boolean checkPos(Ball other) {
    float dist = this.location.dist(other.location);
    if (dist <= (size + other.size)/2 + 2) {
      return true;
    }else{
      return false;
    }
  }
  
  void reactSize(boolean triggerState) {
    if (triggerState){

      //println("yes");
      //float rate = sensorValues[i] - pSensorValues[i];
      //rate = map(rate, 0, 1023, 30, 100);
      //if (!blob.isPlaying() || frameCount % 30 == 0){
      //  blob.play();
      //}
      size += 40;

    if (size > 300) {
        size = 300;
      }
    }
    else if (size > originalSize){
       size = lerp(size, originalSize, 0.03);
    }
  } 
  
  void bounce(Ball other) {
    if (this.checkPos(other)) {
      file.play();
      other.hue += random(200);
      PVector force = new PVector(other.location.x - location.x, other.location.y - location.y);
      float dist = this.location.dist(other.location);
      dist = dist / 2;
      force.normalize();
      force.mult((other.velocity.mag()+1) * dist);
      //force.mult(dist*100);
      other.applyForce(force);
    }
  }
}
