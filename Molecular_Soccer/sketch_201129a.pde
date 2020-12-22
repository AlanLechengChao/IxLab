import processing.sound.*;
SoundFile file;
SoundFile win;
//SoundFile blob;
import processing.serial.*;

String myString = null;
Serial myPort;


int NUM_OF_VALUES = 10;   /** YOU MUST CHANGE THIS ACCORDING TO YOUR PROJECT **/
int[] sensorValues; 

PImage soccer;
Ball ball;
PVector loc;
PVector gravity = new PVector(0, 10);

boolean playState = true;
int count = 0;
int left_score = 0;
int right_score = 0;

float[][] trails = new float[100][2];

Player[] players = new Player[10];
String goalSide;
PFont arcade;
int winningHue;

void setup() {
  fullScreen();
  arcade = createFont("ArcadeClassic", 32);
  //size(1200, 675);
  setupSerial();
  loc = new PVector(width/2,height/2);
  //fullScreen();
  //pixelDensity(2);
  ball = new Ball(loc);
  rectMode(CORNERS);
  win = new SoundFile(this, "win.wav");
  //blob = new SoundFile(this, "blob.wav");
  file = new SoundFile(this, "378355__13gpanska-lakota-jan__bouncing-football-ball-off-the-ground.wav");
  players[0] = new Player(new PVector(310, height/2 - 117.5), 1);
  players[1] = new Player(new PVector(310, height/2 + 117.5), 1);
  players[2] = new Player(new PVector(550, height/2 - 280), 1);
  players[3] = new Player(new PVector(550, height/2 + 280), 1);
  players[4] = new Player(new PVector(width/2 + 200, height/2), 1);
  
  players[5] = new Player(new PVector(width-310, height/2 - 117.5), 2);
  players[6] = new Player(new PVector(width-310, height/2 + 117.5), 2);
  players[7] = new Player(new PVector(width - 550, height/2 - 280), 2);
  players[8] = new Player(new PVector(width-550, height/2 + 280), 2);
  players[9] = new Player(new PVector(width/2-200, height/2), 2);
}

void draw() {
  background(240);
  updateSerial();
  println(frameRate);
  //printArray(sensorValues);
  push();
  //textFont(arcade);
  fill(255, 0,0, 40);
  textSize(800);
  textAlign(CENTER);
  text(left_score, width/2 - 350, height - 200);
  fill(0, 0, 255, 40);
  text(right_score, width/2 + 350, height - 200);
  pop();
  drawCourt();
  for (int i = 0; i < players.length; i++) {
    players[i].run();
  }
  if (playState){

  //println(mouseX, ",", mouseY);


  //println(frameRate);
  gravity.y = 20*noise(frameCount) - 10;
  ball.applyForce(gravity);
  int head = frameCount%100;
  trails[head][0] = ball.location.x;
  trails[head][1] = ball.location.y;
  push();
  colorMode(HSB);
  for (int i = 0; i < trails.length; i++) {
    float dia;
    if (i >= head) {
      dia = 0.3*(head - i);
    }else{
      dia = 0.3*(head - (i+100));
    }
    fill(30, 200, 255, 80);
    circle(trails[i][0], trails[i][1], dia);
  }
  pop();
  ball.run();
  
  if (ball.location.x <= ball.size/2 + 133 ||  ball.location.x >= width - ball.size/2 - 133) {
    ball.velocity.x *= -1;
    file.play();
    ball.hue += random(200);
    if (ball.location.x < 133) {
      ball.location.x = ball.size/2 + 20;
    }else if (ball.location.x > width - 133) {
      ball.location.x = width - ball.size/2 - 20;
    }
      if (ball.location.y > height/2 - 200 && ball.location.y < height/2 + 200 && ball.location.x < width/2) {
    right_score += 1;
    goalSide = "Blue";
    playState = false;
    //ball.velocity.mult(0);
    push();
    fill(255,0,0);
    rect(0, height/2 - 200, 133, height/2 + 200);
    pop();
  }
  if (ball.location.y > height/2 - 200 && ball.location.y < height/2 + 200 && ball.location.x > width/2) {
    //ball.velocity.mult(0);
    left_score += 1;
    goalSide = "Red";
    playState = false;
    push();
    fill(255,0,0);
    rect(width-133, height/2 - 200, width, height/2 + 200);
    pop();
  }
  }
  if (ball.location.y <= ball.size/2 + 5 ||  ball.location.y >= height - ball.size/2 -5) {
    ball.velocity.y *= -1;
    file.play();
    ball.hue += random(200);
    if (ball.location.y < 5) {
      ball.location.y = ball.size/2 + 20;
    }else if (ball.location.y > height - 5) {
      ball.location.y = height - ball.size/2 - 20;
    }
  }
  

  
  //println(keyPressed);
  for (int i = 0; i < players.length; i++) {
    //players[i].run();
    players[i].bounce(ball);
    //if (i != 9) {
    //  players[i].reactSize(i == Character.getNumericValue(key) - 1 && keyPressed);
    //}else{
    //  players[i].reactSize(0 == Character.getNumericValue(key) && keyPressed);
    //}
    players[i].reactSize(parseBoolean(sensorValues[i]));
    
    
  }
  }
  else{
    if (!win.isPlaying()){
      win.play();
    }
    
    count += 1;
    push();
    colorMode(HSB);
    winningHue += round(10*noise(frameCount));
    winningHue %= 360;
    fill(winningHue, 150, 230);

    textFont(arcade);
    textAlign(CENTER);
    textSize(200);
    text(goalSide + " Scores", width/2, height/2 + 50*noise(frameCount*0.1) - 25);
    //println(count);
    pop();
    if (count > 180) {
      playState = true;
      win.stop();
      count = 0;
      ball.location.x = width/2;
      ball.location.y = height/2;
      ball.velocity.mult(0.2);
      //ball.velocity.y = random(-1,1);
    }
  }
}


void drawCourt () {
  pushStyle();
  stroke(120);
  noFill();
  strokeWeight(3);
  
  line(133, 5, 133, height - 5);
  line(width - 133, 5, width - 133, height - 5);
  line(133, 5, width -133, 5);
  line(133, height-5, width -133, height-5);
  strokeWeight(1);
  //rect(2, 382, 30, 468);
  
  rect(133, height/2 - 200, 94, height/2 + 200);
  rect(133, height/2 - 350, 215, height/2 + 350);
  
  //rect(width-2, 382, width-30, 468);
  rect(width-133, height/2 - 200, width-94, height/2 + 200);
  rect(width-133, height/2 - 350, width-215, height/2 + 350);
  ellipse(width/2, height/2, 200, 200);
  line(width/2, 5, width/2, height-5);
  push();
  stroke(0, 200, 200);
  strokeWeight(5);
  line(133, height/2 - 200, 133, height/2 + 200);
  line(width - 133, height/2 - 200, width-133, height/2 + 200);
  pop();
  popStyle();
}



void setupSerial() {
  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[ 3 ], 9600);
  // WARNING!
  // You will definitely get an error here.
  // Change the PORT_INDEX to 0 and try running it again.
  // And then, check the list of the ports,
  // find the port "/dev/cu.usbmodem----" or "/dev/tty.usbmodem----" 
  // and replace PORT_INDEX above with the index number of the port.

  myPort.clear();
  // Throw out the first reading,
  // in case we started reading in the middle of a string from the sender.
  myString = myPort.readStringUntil( 10 );  // 10 = '\n'  Linefeed in ASCII
  myString = null;
  
  sensorValues = new int[NUM_OF_VALUES];
}



void updateSerial() {
  while (myPort.available() > 0) {
    myString = myPort.readStringUntil( 10 ); // 10 = '\n'  Linefeed in ASCII
    if (myString != null) {
      String[] serialInArray = split(trim(myString), ",");
      if (serialInArray.length == NUM_OF_VALUES) {
        for (int i=0; i<serialInArray.length; i++) {
          sensorValues[i] = int(serialInArray[i]);
        }
      }
    }
  }
}
