/**
 * Follow 2  
 * based on code from Keith Peters. 
 * 
 * A two-segmented arm follows the cursor position. The relative
 * angle between the segments is calculated with atan2() and the
 * position calculated with sin() and cos().
 */
 
/** http://walter.bislins.ch/blog/index.asp?page=Schnittpunkte+zweier+Kreise+berechnen+(JavaScript) **/

 
PFont f;

PVector k1, k2, e1, e2, inter1, schnitt;
PVector calc = new PVector();
float dist = 1.0;
float r1 = 120.0;
float r2 = 120.0;
float xx, yy;

float[] x = new float[4];
float[] y = new float[4];
float[] ang = new float[3];
float segLength = 50;
float winkel2 = 0.0;

// timer Variables
int timer;
int wait = 1000;

void setup() {
  size(640, 360);
  strokeWeight(20.0);
  stroke(255, 100);
  
  k1 = new PVector(160, 80);
  k2 = new PVector(160, 80);
  e1 = new PVector(0, 0);
  e2 = new PVector(0, 0);
  inter1 = new PVector();
  schnitt = new PVector();
  
  // Create the font
  //printArray(PFont.list());
  f = createFont("SourceCodePro-Regular.ttf", 12);
  textFont(f);
  
  timer = millis();
}

void draw() {
  background(0);
  fill(255, 0 ,0);
  text(int(x[0]), 10, 20);
  text(int(y[0]), 70, 20);
  text(ang[0], 140, 20);
  fill(0, 255 ,0);
  text(int(x[1]), 10, 40);
  text(int(y[1]), 70, 40);
  text(ang[1], 140, 40);
  text(int(dist), 10, 60);
  text(int(xx), 70, 60);
  
  
  //dragSegment(0, mouseX, mouseY);
  //dragSegment(1, x[0], y[0]);
  
  ang[2] = map(mouseX, 0, 640, -PI, PI);
  wait = int(map(mouseY, 0, 360, 200, 2000));
  k1.x = 160 + cos(ang[2]) * r1;
  k1.y = 80 + sin(ang[2]) * r1;
  x[2] = 160 + cos(ang[2]) * r1;
  y[2] = 80 + sin(ang[2]) * r1;
  segment(160, 80, ang[2], 0, r1);
  stroke(0, 255, 0, 100);

  strokeWeight(1.0);
  noFill();
  ellipse(k1.x, k1.y, r1 * 2, r1 * 2);
  strokeWeight(20.0);
  
  if(millis() - timer >= wait){
    winkel2 += 0.1;
    timer = millis();
  }
  
  segment(310, 80, winkel2, 0, r2);
  stroke(0, 255, 0, 100);
  strokeWeight(1.0);
  noFill();
  
  k2.x = 310 + cos(winkel2) * r2;
  k2.y = 80 + sin(winkel2) * r2;
  ellipse(k2.x, k2.y, r2 * 2, r2 * 2);
  
  
  dist = PVector.dist(k1, k2);
  e1 = k2.copy();
  e1.sub(k1);
  e1.normalize();
  line(k1.x, k1.y, k1.x + e1.x * 20, k1.y + e1.y * 20);
  
  e2.set(-e1.y, e1.x);
  line(k1.x, k1.y, k1.x + e2.x * 20, k1.y + e2.y * 20);
  
  if( dist != 0 ){ //<>//
    xx = (r1 * r1 + dist * dist - r2 * r2) / (2 * dist);
    if((r1 * r1) > (xx * xx)){
      yy = sqrt((r1 * r1) - (xx * xx));
      PVector.add(k1, e1.mult(xx), inter1);
      PVector.add(inter1, e2.mult(yy), schnitt);
  
      ellipse(schnitt.x, schnitt.y, 5, 5);
    } else {
      yy = 0;
    }
  } else {
    xx = 0;
    yy = 0;
  }
 
  strokeWeight(20.0);
  if(yy != 0){
     line(k1.x, k1.y, schnitt.x, schnitt.y);
  } else {
      line(x[2], y[2], 320, 300);
  }
}

void dragSegment(int i, float xin, float yin) {
  float dx = xin - x[i];
  float dy = yin - y[i];
  ang[i] = atan2(dy, dx);  
  x[i] = xin - cos(ang[i]) * segLength;
  y[i] = yin - sin(ang[i]) * segLength;
  segment(x[i], y[i], ang[i], i, segLength);
}

void segment(float x, float y, float a, int i, float segl) {
  pushMatrix();
  translate(x, y);
  rotate(a);
  if( i == 0 ){
    stroke(255, 0 ,0 ,100);
  } else {
    stroke(0, 255, 0, 100);
  }
  line(0, 0, segl, 0);
  ellipse(0, 0, 10, 10);
  popMatrix();
}