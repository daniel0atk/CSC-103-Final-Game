class Enemy {
  // Variables
  int x, y;
  int w, h;
  boolean shouldRemove;
  int left, right, top, bottom; // Declare left, right, top, bottom as fields
  float speed = 2; // Speed at which the enemy follows the player
  color enemyColor; // Add color variable for enemy
  
  // Constructor
  Enemy(int startX, int startY, int startW, int startH, color c) {
    x = startX;
    y = startY;
    w = startW;
    h = startH;
    enemyColor = c; // Set enemy color
    shouldRemove = false;
    
    // Calculate left, right, top, bottom
    left = x - w/2;
    right = x + w/2;
    top = y - h/2;
    bottom = y + h/2;
  }

  void render() {
    rectMode(CENTER);
    fill(enemyColor); // Use enemy color
    rect(x, y, w, h); 
  }
  // Method to update enemy position to follow the player
  void followPlayer(Player player) {
    // Calculate the direction towards the player
    float dx = player.x - x;
    float dy = player.y - y;
    // Normalize the direction
    float dist = sqrt(dx*dx + dy*dy);
    dx /= dist;
    dy /= dist;
    // Move towards the player with a constant speed
    x += dx * speed;
    y += dy * speed;
    
    left = x - w/2;
    right = x + w/2;
    top = y - h/2;
    bottom = y + h/2;
  }
  
  // Method to check collision with other enemies and adjust position
  void avoidCollision(ArrayList<Enemy> enemies) {
    for (Enemy other : enemies) {
      if (other != this) {
        if (left < other.right &&
            right > other.left &&
            top < other.bottom &&
            bottom > other.top) {
          // Colliding with another enemy, adjust position
          if (x < other.x) {
            x -= 1;
          } else {
            x += 1;
          }
          if (y < other.y) {
            y -= 1;
          } else {
            y += 1;
          }
          
          // Recalculate boundaries
          left = x - w/2;
          right = x + w/2;
          top = y - h/2;
          bottom = y + h/2;
        }
      }
    }
  }
}
