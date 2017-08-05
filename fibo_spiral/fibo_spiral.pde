// shamelessly copied from https://www.openprocessing.org/sketch/154078.

float x,y, angle,radius=220;

void setup() {
  size(500, 500);
  background(255,255,255);
  //frameRate(5);
  colorMode(HSB,255,100,100);
}

void draw() {

  x = width/2 + cos(angle)*radius;
  y = height/2 + sin(angle)*radius;
  fill(frameCount%255,100,90);
  noStroke();
  quad(x, y, x, y+10, x+10, y+10, x+10, y);
  if (frameCount%15==0) radius -= 2;
  angle += radians(37.5);
  if (radius<10) noLoop();
}