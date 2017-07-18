// This code is a modification of the rcursive tree example in https://processing.org/examples/tree.html
// things to do: Add display for A.
// Do dynamic colour change for line drawing


float theta;
float R=0;
float G=0;
float B=0;

void setup() {
  size(1920, 1080);
}

void draw() {
  background(255);
  frameRate(30);
  // Let's pick an angle 0 to 90 degrees based on the mouse position
  float a = (mouseX / (float) width) * 90f;
  
  stroke(a, 0, 0);
  // Convert it to radians
  theta = radians(a*4);
  // Start the tree from the bottom of the screen
  translate(width/2, height/1.5);
  // Draw a line 120 pixels
  line(0, 0, 0, -120);
  // Move to the end of that line
  translate(0, -120);
  // Start the recursive branching!
  branch(180);
}

void branch(float h) {


  // Each branch will be 2/3rds the size of the previous one
  h *= 0.73;

  // All recursive functions must have an exit condition!!!!
  // Here, ours is when the length of the branch is 2 pixels or less
  if (h > 2) {
    pushMatrix();    // Save the current state of transformation (i.e. where are we now)
    rotate(theta);   // Rotate by theta
    line(0, 0, 0, -h);  // Draw the branch
    translate(10, -h); // Move to the end of the branch
    branch(h);       // Ok, now call myself to draw two new branches!!
    popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state

    // Repeat the same thing, only branch off to the "left" this time!
    pushMatrix();
    rotate(-theta);
    line(0, 0, 0, -h);
    translate(-10, -h);
    branch(h);
    popMatrix();

    

    
  }
}