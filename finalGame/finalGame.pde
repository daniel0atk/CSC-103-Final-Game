import processing.sound.*;

SoundFile slapSound;
SoundFile backgroundMusic;
SoundFile loseMusic;
SoundFile winMusic;


int state = 0;
int spaceBarCooldown = 500; // Cooldown period for the space bar in milliseconds (0.5 seconds)
int spaceBarCooldownStart = 0; // Variable to store the time when the space bar cooldown started

ArrayList<Enemy> enemyList;
ArrayList<Melee> meleeList;
Player p1;
Button startButton;

boolean spaceBarCooldownActive = false; // Flag to track if the space bar cooldown is active

PImage[] idleImages = new PImage[4];
PImage[] catOneImages = new PImage[2];
PImage[] catTwoImages = new PImage[2];
PImage[] catThreeImages = new PImage[2];

ArrayList<PImage> heartImages = new ArrayList<PImage>();
int heartSize = 30;
int heartSpacing = 10;

Animation idleAnimation;
Animation catOneAnimation;
Animation catTwoAnimation;
Animation catThreeAnimation;

PImage backgroundImage; // Declare a variable to store the background image
PImage startScreen;
PImage winScreen;
PImage loseScreen;

void setup() {
  size(800, 800); // Set the size of the sketch window
  imageMode(CENTER);
  
  slapSound = new SoundFile(this, "slap.mp3");
  backgroundMusic = new SoundFile(this, "backgroundMusic.mp3");
  backgroundMusic.amp(0.25);
  loseMusic = new SoundFile(this, "loseMusic.mp3");
  loseMusic.amp(0.25);
  winMusic = new SoundFile(this, "winMusic.mp3");
  winMusic.amp(0.25);


  
  PImage originalImage = loadImage("basement.png");
  // Resize the image to match the sketch window dimensions
  originalImage.resize(width, height);
  backgroundImage = originalImage;
  
  PImage startImage = loadImage("startScreen.jpg");
  startImage.resize(width, height);
  startScreen = startImage;
  
  PImage winImage = loadImage("winScreen.jpg");
  winImage.resize(width, height);
  winScreen = winImage;
  
  PImage loseImage = loadImage("loseScreen.jpg");
  loseImage.resize(width, height);
  loseScreen = loseImage;
  
  // Load heart images
  for (int i = 0; i < 3; i++) {
    heartImages.add(loadImage("heart.png"));
  }
  
  // initialize image array
  for (int i = 0; i < idleImages.length; i++){
    idleImages[i] = loadImage("mouseIdle/mouseIdle" + i + ".png"); 
  }
  
  for (int i = 0; i < catOneImages.length; i++){
    catOneImages[i] = loadImage("catOne/catOne" + i + ".png");
  }
  
  for (int i = 0; i < catTwoImages.length; i++){
    catTwoImages[i] = loadImage("catTwo/catTwo" + i + ".png");
  }

  
  for (int i = 0; i < catThreeImages.length; i++){
    catThreeImages[i] = loadImage("catThree/catThree" + i + ".png");
  }
  
  
  
  // initialize animation vars
  idleAnimation = new Animation(idleImages, 0.1, 3.0);
  catOneAnimation = new Animation(catOneImages, 0.03, 3.0);
  catTwoAnimation = new Animation(catTwoImages, 0.03, 3.0);
  catThreeAnimation = new Animation(catThreeImages, 0.03, 3.0);
  
  p1 = new Player(width/2, height/2, 50, 50, color(255)); // Initialize player at the center of the screen
  
  // Initialize enemies
  enemyList = new ArrayList<Enemy>();
  // Initialize 10 enemies
  for (int i = 0; i < 10; i++) {
    // Keep generating random positions until it's far enough from the player
    int enemyX, enemyY;
    do {
      enemyX = int(random(width));
      enemyY = int(random(height));
    } while (dist(enemyX, enemyY, p1.x, p1.y) < 150);  // Adjust distance as needed
    
    enemyList.add(new Enemy(enemyX, enemyY, 50, 50, color(255, 0, 0)));
  }
  
  meleeList = new ArrayList<Melee>();
  
  startButton = new Button(width/2, 720, 200, 70, color(255,100,255)); 
}

void draw() {
  background(startScreen);
  
  if (spaceBarCooldownActive && millis() - spaceBarCooldownStart >= spaceBarCooldown) {
    spaceBarCooldownActive = false; // Reset space bar cooldown if cooldown period has elapsed
  }
  
   if (backgroundMusic.isPlaying() == false){
   backgroundMusic.play(); 
  }
  
  switch (state){
    //start screen (state 0)
    case 0:
      startButton.render(); // Render the start button
      startButton.checkPress();
      if (startButton.isButtonPressed) {
        state = 1;
        // Reset player position to the middle when state changes
        p1.resetPosition(width/2, height/2);
      }   
      break;     
    case 1:
      background(backgroundImage);

      idleAnimation.display(p1.x, p1.y);
      idleAnimation.isAnimating = true;
      p1.move(enemyList);
      
      // Make enemies follow the player and avoid collision
      for (Enemy anEnemy : enemyList) {
        anEnemy.followPlayer(p1);
        anEnemy.avoidCollision(enemyList);
        catOneAnimation.display(anEnemy.x, anEnemy.y);
        catOneAnimation.isAnimating = true;
        
        p1.loseLife(anEnemy);
      }
      
      renderHearts(p1.lives);
      
      // Check if player has lost all lives
      if (p1.lives <= 0) {
        state = 5; // Change to game over state
      }
      
      // Render and check collision for each melee object
      for (int i = meleeList.size() - 1; i >= 0; i--) {
        Melee aMelee = meleeList.get(i);
        aMelee.render(p1);
        for (Enemy anEnemy : enemyList) {
          aMelee.hitEnemy(anEnemy);
        }
        if (aMelee.shouldRemove) {
          meleeList.remove(i);
        } else {
          aMelee.checkTimeToRemove();
        }
      }
    
      // Remove enemies if necessary
      for (int i = enemyList.size() - 1; i >= 0; i--) {
        Enemy anEnemy = enemyList.get(i);
        if (anEnemy.shouldRemove) {
          enemyList.remove(i);
        }
      }
    
      // Check if all enemies are defeated
      if (enemyList.isEmpty()) {
        state = 2; // Change state to indicate level two
        // Reset player position to the middle when state changes
        p1.resetPosition(width/2, height/2);
      }
      break;
    // level two (state 2)
    case 2:
      background(backgroundImage);

      idleAnimation.display(p1.x, p1.y);
      idleAnimation.isAnimating = true;
      p1.move(enemyList);
      catTwoAnimation.update(); // Ensure animation update

      
      // Increase the number of enemies for level 2
      if (enemyList.isEmpty()) {
        for (int i = 0; i < 15; i++) { // Adjust the number of enemies as needed
          int enemyX, enemyY;
          do {
            enemyX = int(random(width));
            enemyY = int(random(height));
          } while (dist(enemyX, enemyY, p1.x, p1.y) < 200);  // Adjust distance as needed
          
          enemyList.add(new Enemy(enemyX, enemyY, 50, 50, color(0, 255, 0)));
        }
      }
      
      // Increase the speed of enemies for level 2
      for (Enemy anEnemy : enemyList) {
        anEnemy.speed = 3; // Adjust the speed as needed
        anEnemy.followPlayer(p1);
        anEnemy.avoidCollision(enemyList);
        catTwoAnimation.display(anEnemy.x, anEnemy.y);
        catTwoAnimation.isAnimating = true;

        p1.loseLife(anEnemy);
      }
      
      renderHearts(p1.lives);
      
      // Check if player has lost all lives
      if (p1.lives <= 0) {
        state = 5; // Change to game over state
      }
    
      // Render and check collision for each melee object
      for (int i = meleeList.size() - 1; i >= 0; i--) {
        Melee aMelee = meleeList.get(i);
        aMelee.render(p1);
        for (Enemy anEnemy : enemyList) {
          aMelee.hitEnemy(anEnemy);
        }
        if (aMelee.shouldRemove) {
          meleeList.remove(i);
        } else {
          aMelee.checkTimeToRemove();
        }
      }
    
      // Remove enemies if necessary
      for (int i = enemyList.size() - 1; i >= 0; i--) {
        Enemy anEnemy = enemyList.get(i);
        if (anEnemy.shouldRemove) {
          enemyList.remove(i);
        }
      }
    
      // Check if all enemies are defeated in level two
      if (enemyList.isEmpty()) {
        state = 3;
        // Reset player position to the middle when state changes
        p1.resetPosition(width/2, height/2);
      }
      break;
    // state 3
    case 3:
      background(backgroundImage);

      idleAnimation.display(p1.x, p1.y);
      idleAnimation.isAnimating = true;
      p1.move(enemyList);

      
      // Increase the number of enemies for level 3
      if (enemyList.isEmpty()) {
        for (int i = 0; i < 25; i++) { // Adjust the number of enemies as needed
          int enemyX, enemyY;
          do {
            enemyX = int(random(width));
            enemyY = int(random(height));
          } while (dist(enemyX, enemyY, p1.x, p1.y) < 400);  // Adjust distance as needed
          
          enemyList.add(new Enemy(enemyX, enemyY, 50, 50, color(0, 0, 55)));
        }
      }
      
      // Increase the speed of enemies for level 3
      for (Enemy anEnemy : enemyList) {
        anEnemy.speed = 5; // Adjust the speed as needed
        anEnemy.followPlayer(p1);
        anEnemy.avoidCollision(enemyList);
        catThreeAnimation.display(anEnemy.x, anEnemy.y);
        catThreeAnimation.isAnimating = true;
      
        p1.loseLife(anEnemy);
      }
      
      renderHearts(p1.lives);
      
      // Check if player has lost all lives
      if (p1.lives <= 0) {
        state = 5; // Change to game over state
      }
    
      // Render and check collision for each melee object
      for (int i = meleeList.size() - 1; i >= 0; i--) {
        Melee aMelee = meleeList.get(i);
        aMelee.render(p1);
        for (Enemy anEnemy : enemyList) {
          aMelee.hitEnemy(anEnemy);
        }
        if (aMelee.shouldRemove) {
          meleeList.remove(i);
        } else {
          aMelee.checkTimeToRemove();
        }
      }
    
      // Remove enemies if necessary
      for (int i = enemyList.size() - 1; i >= 0; i--) {
        Enemy anEnemy = enemyList.get(i);
        if (anEnemy.shouldRemove) {
          enemyList.remove(i);
        }
      }
    
      // Check if all enemies are defeated in level two
      if (enemyList.isEmpty()) {
        state = 4;
        // Reset player position to the middle when state changes
        p1.resetPosition(width/2, height/2);
      }
      break;
    // state 4
    case 4:
      background(winScreen);
       backgroundMusic.pause();
      if (winMusic.isPlaying() == false){
      winMusic.play();
    }      
      break;
      
    case 5:
      background(loseScreen);
      backgroundMusic.pause();
      if (loseMusic.isPlaying() == false){
      loseMusic.play();
    }
      break;
  }
}

void renderHearts(int numHearts) {
  for (int i = 0; i < numHearts; i++) {
    image(heartImages.get(i), width - (i * (heartSize + heartSpacing)) - heartSize, heartSize);
  }
}

void keyPressed() {
  if (key == 'w' || key == 'W') {
    p1.isMovingUp = true;
  }  
  if (key == 's' || key == 'S') {
    p1.isMovingDown = true;
  }  
  if (key == 'd' || key == 'D') {
    p1.isMovingRight = true;
  }  
  if (key == 'a' || key == 'A') {
    p1.isMovingLeft = true;
  } 
  if (!spaceBarCooldownActive && key == ' ') { // Check if space bar cooldown is not active and space bar is pressed
    // Create a new melee object at the player's position
    p1.useMelee();
    slapSound.play();
  }
}

void keyReleased() {
  if (key == 'w' || key == 'W') {
    p1.isMovingUp = false;
  }  if (key == 's' || key == 'S') {
    p1.isMovingDown = false;
  }  if (key == 'd' || key == 'D') {
    p1.isMovingRight = false;
  } if (key == 'a' || key == 'A') {
    p1.isMovingLeft = false;
  }  if (key == ' ') {
    p1.resetMeleeAvailability();
  }
}
