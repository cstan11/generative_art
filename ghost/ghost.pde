//Raven Kwok
//ravenkwok.com
//ravenkwok.tumblr.com
//twitter.com/ravenkwok
//facebook.com/ravenkwok.art
//Code originally written on Dec.6, 2010, posted on OpenProcessing.org on Jul.9, 2011, re-visited and re-posted on OpenProcessing.org on Jul.12, 2016.

Ptc [] ptcs;

float gMag = 1, gVelMax = 10, gThres, gThresT, gBgAlpha = 255, gBgAlphaT = 255;

void setup() {
  size(960, 720, P2D);
  frameRate(30);
  smooth();
  textSize(15);
  background(255);
  initPtcs(60);
  initSliders();
}
void draw() {

  gThres = lerp(gThres, gThresT, .02);
  gBgAlpha = lerp(gBgAlpha, gBgAlphaT, .02);
  gMag = sliderForce.value;
  
  updatePtcs();
  updateSliders();

  noStroke();
  fill(255, gBgAlpha);
  rect(0, 0, width, height);

  drawPtcs();
  drawCnts();
  drawSliders();
}
void initPtcs(int amt) {
  ptcs = new Ptc[amt];
  for (int i=0; i<ptcs.length; i++) {
    ptcs[i] = new Ptc();
  }
}

void updatePtcs() {
  if (onPressed) {
    for (int i=0; i<ptcs.length; i++) {
      ptcs[i].update(mouseX, mouseY);
    }
  } else {
    for (int i=0; i<ptcs.length; i++) {
      ptcs[i].update();
    }
  }
}

void drawPtcs() {
  for (int i=0; i<ptcs.length; i++) {
    ptcs[i].drawPtc();
  }
}

void drawCnts() {
  for (int i=0; i<ptcs.length; i++) {
    for (int j=i+1; j<ptcs.length; j++) {
      float d = dist(ptcs[i].pos.x, ptcs[i].pos.y, ptcs[j].pos.x, ptcs[j].pos.y);
      if (d<gThres) {
        float scalar = map(d, 0, gThres, 1, 0);
        ptcs[i].drawCnt(ptcs[j], scalar);
      }
    }
  }
}

class Ptc {

  PVector pos, pPos, vel, acc;
  float decay, weight, magScalar;

  Ptc() {
    pos = new PVector(random(width), random(height));
    pPos = new PVector(pos.x, pos.y);
    vel = new PVector(0, 0);
    acc = new PVector(0, 0);

    weight = random(1, 10);
    decay = map(weight, 1, 10, .95, .85);
    magScalar = map(weight, 1, 10, .5, .05);
  }

  void update(float tgtX, float tgtY) {
    
    pPos.set(pos.x, pos.y);
    
    acc.set(tgtX-pos.x, tgtY-pos.y);

    //Use normalize() instead in Java mode
    float accMag = sqrt(sq(acc.x)+sq(acc.y));
    acc.mult(1.0/accMag);
    //------------------------------
    acc.mult(gMag * magScalar);
    vel.add(acc);
    //Use limit() instead in Java mode
    float velMag = sqrt(sq(vel.x)+sq(vel.y));
    if(velMag>gVelMax) vel.mult(gVelMax/velMag);
    //------------------------------
    pos.add(vel);
    acc.set(0, 0, 0);
    boundaryCheck();
  }

  void update() {
    
    pPos.set(pos.x, pos.y);
    
    vel.add(acc);
    vel.mult(decay);
    pos.add(vel);
    acc.set(0, 0);

    boundaryCheck();
  }

  void drawPtc() {
    strokeWeight(weight);
    stroke(0, 255);
    if(onPressed)line(pos.x, pos.y, pPos.x, pPos.y);
    else point(pos.x, pos.y);
  }
  
  void drawCnt(Ptc coPtc, float scalar) {
    strokeWeight((weight+coPtc.weight)*.5*scalar);
    stroke(0, 255*scalar);
    line(pos.x, pos.y, coPtc.pos.x, coPtc.pos.y);
  }

  void boundaryCheck() {
    if (pos.x > width) {
      pos.x = width;
      vel.x *= -1;
    } else if (pos.x < 0) {
      pos.x = 0;
      vel.x *= -1;
    }
    if (pos.y > height) {
      vel.y *= -1;
    } else if (pos.y < 0) {
      vel.y *= -1;
    }
  }
}
ArrayList <Slider> slidersList;

Slider sliderGhost, sliderThres, sliderForce;

void initSliders(){
  
  slidersList = new ArrayList<Slider>();
  
  sliderGhost = new Slider(100, 30, 120, 20);
  sliderGhost.setTag("Ghost");
  sliderGhost.setValue(32, 6, 255);
  sliderThres = new Slider(100, 55, 120, 20);
  sliderThres.setTag("Threshold");
  sliderThres.setValue(100, 0, 240);
  sliderForce = new Slider(100, 80, 120, 20);
  sliderForce.setTag("Force");
  sliderForce.setValue(1, -1, 1);
  
  slidersList.add(sliderGhost);
  slidersList.add(sliderThres);
  slidersList.add(sliderForce);
}


void updateSliders(){
  for(int i=0; i<slidersList.size(); i++){
    Slider slider = slidersList.get(i);
    if(slider.active){
      slider.update();
      break;
    }
  }
}

void drawSliders(){
  for(int i=0; i<slidersList.size(); i++){
    Slider slider = slidersList.get(i);
    slider.display();
  }
}

class Slider{
  
  PVector pos, nameTagPos, valueTagPos;
  float w, h, innerW, value, valueMin, valueMax;
  boolean active;
  String nameTag, valueTag;
  
  Slider(float x, float y, float w, float h){
    pos = new PVector(x, y);
    nameTagPos = new PVector(x-10, y);
    valueTagPos = new PVector(x+w*.5, y);
    this.w = w;
    this.h = h;
  }
  
  void setTag(String nameTag){
    this.nameTag = nameTag;
  }
  
  void setValue(float value, float valueMin, float valueMax){
    this.value = value;
    this.valueMin = valueMin;
    this.valueMax = valueMax;
    
    valueTag = str(round(value*100)/100);
    
    innerW = map(value, valueMin, valueMax, 0, w);
  }
  
  void update(){
    innerW = constrain(mouseX-pos.x, 0, w);
    value = map(innerW, 0, w, valueMin, valueMax);
    valueTag = str(round(value*100)/100);
  }
  
  void display(){
    noStroke();
    fill(0);
    rect(pos.x, pos.y, w, h);
    fill(255, 0, 0);
    rect(pos.x, pos.y, innerW, h);
    
    fill(255);
    rect(pos.x-10-textWidth(nameTag), pos.y, 10+textWidth(nameTag), h);
    
    fill(0);
    textAlign(RIGHT, TOP);
    text(nameTag, nameTagPos.x, nameTagPos.y);
    
    fill(255);
    textAlign(CENTER, TOP);
    text(valueTag, valueTagPos.x, valueTagPos.y);
  }
}
boolean onPressed;

void mousePressed(){
  
  for(int i=0; i<slidersList.size(); i++){
    Slider slider = slidersList.get(i);
    if(mouseX>slider.pos.x && mouseX<slider.pos.x+slider.w && mouseY>slider.pos.y && mouseY<slider.pos.y+slider.h){
      slider.active = true;
      return;
    }
  }
  
  onPressed = true;
  gThresT = sliderThres.value;
  gBgAlphaT = sliderGhost.value;
}

void mouseReleased(){
  
  for(int i=0; i<slidersList.size(); i++){
    Slider slider = slidersList.get(i);
    slider.active = false;
  }
  
  onPressed = false;
  gThresT = 0;
  gBgAlphaT = 255;
}