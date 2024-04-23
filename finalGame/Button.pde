class Button {
  float x, y; // Position of the button
  float width, height; // Width and height of the button
  color buttonColor; // Color of the button
  boolean isButtonPressed = false; // Flag to track button press
  
  // Constructor for Button class
  Button(float posX, float posY, float buttonWidth, float buttonHeight, color col) {
    x = posX;
    y = posY;
    width = buttonWidth;
    height = buttonHeight;
    buttonColor = col;
  }
  
  // Function to draw the button
  void render() {
    rectMode(CENTER);
    fill(buttonColor);
    stroke(255);
    strokeWeight(2);
    rect(x, y, width, height, 15);
    
    // Draw the text "Start" on the button
    textAlign(CENTER, CENTER);
    fill(0);
    textSize(20);
    text("Start", x, y);
  }
  
  // Function to check if the button is pressed
  void checkPress() {
    if (mouseX >= x - width / 2 && mouseX <= x + width / 2 && mouseY >= y - height / 2 && mouseY <= y + height / 2 && mousePressed) {
      isButtonPressed = true;
    } else {
      isButtonPressed = false;
    }
  }
}
