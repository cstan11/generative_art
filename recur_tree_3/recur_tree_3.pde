// This code is a modification of the rcursive tree example in https://processing.org/examples/tree.html
// things to do: figure out a way to do infinite loop for the b range e.g bounce between -100 to 100
// things to do: simplify the maths calculation  
// perhaps better taste for colour wheel 


float theta;
float b=-10000; 

void setup() {
  size(980, 980);
}

void draw() {
  background(255);
  frameRate(50);
  // Let's pick an angle 0 to 90 degrees based on the mouse position
  // b represents the length of the auto movement, b + to adjust the speed of transformation
  if (b < 10000) {
    b = b + 10;
    //float a = (b / (float) width) * 90f;
    //float a = b / 40f;
    float a = (mouseX / (float) width) * 90f;
    //float a = 173.125;

    // display counter
    textSize(15);
    text(b, 10, 30); 
    fill(0, 102, 153);


    //this is for the color rotation
    //stroke((a+20)/2, a/1.2, a/2.5);

    //stroke(0, 0, 0);

    // Convert it to radians
    theta = radians(a*8);
    // Start the tree from the bottom of the screen
    translate(width/2, height/2);
    // Draw a line 120 pixels
    //line(0, 0, 0, -60);
    // Move to the end of that line
    //translate(0, -60);
    // Start the recursive branching!
    branch(140);
    //saveFrame();
  }
}

void branch(float h) {

  // Each branch will be 2/3rds the size of the previous one
  h *= 0.75;

  // All recursive functions must have an exit condition!!!!
  // Here, ours is when the length of the branch is 2 pixels or less
  if (h > 4) {
    pushMatrix();    // Save the current state of transformation (i.e. where are we now)
    rotate(-theta);   // Rotate by theta
    stroke(h*20, h, 0); // changing colour wheel via branching
    line(0, h/3, h/3, 0);  // Draw the branch
    translate(-h/2, -h/2); // Move to the end of the branch
    branch(h);       // Ok, now call myself to draw two new branches!!
    popMatrix();     // Whenever we get back here, we "pop" in order to restore the previous matrix state

    // Repeat the same thing, only branch off to the "left" this time!
    pushMatrix();
    rotate(theta);
    stroke(0, h, h*40); // changing colour wheel via branching
    line(h/3, 0, 0, h/3);
    translate(h/2, -h/2); // Move to the end of the branch
    branch(h);
    popMatrix();
  }
}