class Player {
  // Variables
  int x, y, w, h;
  color c;

  int left, right, top, bottom;

  int speed = 5;
  
  int lives = 3; // Initial number of lives
  int hitsToLoseLife = 5; // Number of hits before losing a life
  int currentHits = 0; // Counter for current hits

  
  boolean isMovingUp, isMovingDown, isMovingLeft, isMovingRight;

  boolean isColliding = false; // Flag to track if player is colliding with an enemy

  boolean loseLife;
  
  boolean meleeAvailable = true;
  
  int hitCooldownTime = 1000; // Cooldown period for hits in milliseconds (1 second)
  long lastHitTime = 0; // Variable to store the time of the last hit
  
  boolean isHitCooldownOver() {
    return millis() - lastHitTime >= hitCooldownTime;
  }

  

  
  // Constructor
  Player(int startX, int startY, int startW, int startH, color startC) {
    
   loseLife = false;

    x = startX;
    y = startY;
    w = startW;
    h = startH;
    c = startC;
    
    isMovingLeft = false;
    isMovingRight = false;
    isMovingUp = false;
    isMovingDown = false;
    
    speed = 10;
    
    left = x - w/2;
    right = x + w/2;
    top = y - h/2;
    bottom = y + h/2;
  }
  
  // Method to reset the player's position
  void resetPosition(int newX, int newY) {
    x = newX;
    y = newY;
  }
  
  // Method to reset the hit cooldown timer
  void resetHitCooldown() {
    lastHitTime = millis();
  }
  
  // Functions
  void render() {
    rectMode(CENTER);
    fill(c);
    rect(x, y, w, h); 
  }
  
 void move(ArrayList<Enemy> enemies) {
  int newX = x;
  int newY = y;
  
  // Calculate the potential new position based on key inputs
  if (isMovingUp && y > h/2) newY -= speed;
  if (isMovingDown && y < height - h/2) newY += speed;
  if (isMovingLeft && x > w/2) newX -= speed;
  if (isMovingRight && x < width - w/2) newX += speed;
  
  // Check for collisions with enemies
  for (Enemy enemy : enemies) {
    if (newX - w/2 < enemy.right &&
        newX + w/2 > enemy.left &&
        newY - h/2 < enemy.bottom &&
        newY + h/2 > enemy.top) {
      // Collision detected with enemy, do not update position
      return;
    }
  }
  
  // Check for collisions with screen boundaries
  if (newX - w/2 < 0 || newX + w/2 > width || newY - h/2 < 0 || newY + h/2 > height) {
    // Collision detected with screen boundaries, do not update position
    return;
  }
  
  // Update the player's position
  x = newX;
  y = newY;
  
  left = x - w/2;
  right = x + w/2;
  top = y - h/2;
  bottom = y + h/2;
}


  // Method to use melee attack
  void useMelee() {
    if (meleeAvailable) {
      // Create a new melee object at the player's position
      Melee m1 = new Melee(x, y, 100); // Set the diameter of the melee circle
      meleeList.add(m1);
      meleeAvailable = false; // Set melee attack to unavailable
    }
  }

  // Method to check if melee attack is available
  boolean isMeleeAvailable() {
    return meleeAvailable;
  }
  
  // Method to reset melee attack availability (e.g., after cooldown period)
  void resetMeleeAvailability() {
    meleeAvailable = true;
  }
  
   void loseLife(Enemy anEnemy) {
    // Check if player is currently colliding and hit cooldown is over
    if (!isColliding &&
        isHitCooldownOver() &&
        top <= anEnemy.bottom &&
        bottom >= anEnemy.top &&
        left <= anEnemy.right &&
        right >= anEnemy.left) {
      
      // Set collision flag to true
      isColliding = true;

      // Increase hits counter
      currentHits++;
      println("Current hits: " + currentHits);

      // Check if enough hits to lose a life
      if (currentHits >= hitsToLoseLife) {
        // Reset hits counter
        currentHits = 0;

        // Check if lives are greater than 0
        if (lives > 0) {
          lives--; // Decrease life count
        }

        // Set loseLife flag to true
        loseLife = true;
      }

      // Reset hit cooldown
      resetHitCooldown();
    }

    // If not colliding anymore, reset collision flag
    if (isColliding &&
        (top > anEnemy.bottom ||
        bottom < anEnemy.top ||
        left > anEnemy.right ||
        right < anEnemy.left)) {
      isColliding = false;
    }
  }
}
