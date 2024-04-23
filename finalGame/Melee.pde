class Melee {
  // Variables
  int x, y, d;
  boolean shouldRemove;
  int left, right, top, bottom;
  
  long startTime; // Variable to store the time when the melee object was created

  // Constructor
  Melee(int startX, int startY, int meleeDiameter) {
    x = startX;
    y = startY;
    d = meleeDiameter;
    shouldRemove = false;
    startTime = millis(); // Record the current time when the melee object is created
    
    left = x - d/2;
    right = x + d/2;
    top = y - d/2;
    bottom = y + d/2;
  }

  void render(Player player) {
    pushStyle(); // Save the current style settings
    noFill();
    stroke(255); // color for the melee circle outline
    strokeWeight(2);
    circle(player.x, player.y, d); // Draw circle around player
    popStyle(); // Restore the previous style settings
    
    /*
    The pushStyle and popStyle came from using ChatGPT, I wasn't sure how to make only the melee change colors. Prior to, it would change everything to match the style of the melee. :)
    OpenAI. (2024). ChatGPT (3.5) [Large language model]. https://chat.openai.com
    */
  }

 void hitEnemy(Enemy anEnemy) {
    // Check if the melee object intersects with the enemy
    if (left < anEnemy.right &&
        right > anEnemy.left &&
        top < anEnemy.bottom &&
        bottom > anEnemy.top) {
        // If the melee object intersects with the enemy, mark both for removal
        anEnemy.shouldRemove = true;
        shouldRemove = true;
        println("hit!");
    }
}

  void checkTimeToRemove() {
    // Check if half a second has elapsed since the melee object was created
    if (millis() - startTime > 500) {
      shouldRemove = true; // Mark the melee object for removal
    }
  }
}
