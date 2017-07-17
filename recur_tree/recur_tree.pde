
// things to do: Add display for A.
// Do dynamic colour change for line drawing


float theta;
float R=0;
float G=0;
float B=100;

void setup() {
  size(1280, 720);
}

void draw() {
  background(255);
  frameRate(40);
  stroke(R, G, B);
  // Let's pick an angle 0 to 90 degrees based on the mouse position
  float a = (mouseX / (float) width) * 90f;
  // Convert it to radians
  theta = radians(a);
  // Start the tree from the bottom of the screen
  translate(width/2, height/1.3);
  // Draw a line 120 pixels
  line(0, 0, 0, -120);
  // Move to the end of that line
  translate(0, -120);
  // Start the recursive branching!
  branch(180);
}

void branch(float h) {

  //R *= 100;
  //G *= 200;
  //B *= 300;

  // Each branch will be 2/3rds the size of the previous one
  h *= 0.7;

  // All recursive functions must have an exit condition!!!!
  // Here, ours is when the length of the branch is 2 pixels or less
  if (h > 1) {
    pushMatrix();    // Save the current state of transformation (i.e. where are we now)
    rotate(theta);   // Rotate by theta
    line(0, 0, 0, -h);  // Draw the branch
    translate(0, -h); // Move to the end of the branch
    branch(h);       // Ok, now call myself to draw two new branches!!
    popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state

    // Repeat the same thing, only branch off to the "left" this time!
    pushMatrix();
    rotate(-theta);
    line(0, 0, 0, -h);
    translate(0, -h);
    branch(h);
    popMatrix();
    
  }
}