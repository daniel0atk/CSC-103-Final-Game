/*
Welcome to Darwin's Feline Frenzy!

Here you play as Darwin the mouse, and you have to defeat the vicious cats to secure your precious cheese!
The controlls are WASD for movement, and SPACE for attacking.

All you have to do is defeat all the cats, and victory is as good as yours!

Thanks for playing!

- Character Sprites and animations were done by me
- Background is borrowed from The Binding of Isaac
- Sounds and Music are royalty free.

*/


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
PImage[] winImages = new PImage[2];

PImage[] eatingImages = new PImage[4];
PImage[] dyingImages = new PImage[6];
PImage[] catOneImages = new PImage[2];
PImage[] catTwoImages = new PImage[2];
PImage[] catThreeImages = new PImage[2];
PImage[] startButtonImages = new PImage[6];
PImage[] cheeseImages = new PImage[3];

ArrayList<PImage> heartImages = new ArrayList<PImage>();
int heartSize = 30;
int heartSpacing = 10;

Animation idleAnimation;
Animation eatingAnimation;
Animation dyingAnimation;
Animation cheeseAnimation;
Animation buttonAnimation;
Animation winAnimation;
Animation catOneAnimation;
Animation catTwoAnimation;
Animation catThreeAnimation;

PImage backgroundImage; // Declare a variable to store the background image
PImage titleScreen;
PImage winScreen;
PImage loseScreen;

void setup() {
  size(1000, 1000); // Set the size of the sketch window
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
  
  PImage startImage = loadImage("titleScreen.png");
  startImage.resize(width, height);
  titleScreen = startImage;
  
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
  
  for (int i = 0; i < eatingImages.length; i++){
    eatingImages[i] = loadImage("mouseEating/mouseEating" + i + ".png"); 
  }
    for (int i = 0; i < dyingImages.length; i++){
    dyingImages[i] = loadImage("mouseDying/mouseDying" + i + ".png"); 
  }
    for (int i = 0; i < cheeseImages.length; i++){
    cheeseImages[i] = loadImage("cheese/cheese" + i + ".png"); 
  }
    for (int i = 0; i < winImages.length; i++){
    winImages[i] = loadImage("winMessage/winMessage" + i + ".png"); 
  }
    for (int i = 0; i < startButtonImages.length; i++){
    startButtonImages[i] = loadImage("startButton/startButton" + i + ".png"); 
  }
  
  
  // initialize animation vars
  idleAnimation = new Animation(idleImages, 0.1, 3.0);
  eatingAnimation = new Animation(eatingImages, 0.1, 3.0);
  winAnimation = new Animation(winImages, 0.1, 3.0);
  dyingAnimation = new Animation(dyingImages, 0.1, 3.0);
  cheeseAnimation = new Animation(cheeseImages, 0.1, 3.0);
  buttonAnimation = new Animation(startButtonImages, 0.1, 2.0);
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
  // Draw different screens based on game state
  switch (state) {
    case 0:
      drawTitleScreen();
      break;
    case 1:
      playLevel(1, catOneAnimation);
      break;
    case 2:
      playLevel(2, catTwoAnimation);
      break;
    case 3:
      playLevel(3, catThreeAnimation);
      break;
    case 4:
      drawWinScreen();
      break;
    case 5:
      drawLoseScreen();
      break;
  }
}

void keyPressed() {
  if (key == 'w' || key == 'W') {
    p1.isMovingUp = true;
  }  if (key == 's' || key == 'S') {
    p1.isMovingDown = true;
  }  if (key == 'd' || key == 'D') {
    p1.isMovingRight = true;
  }  if (key == 'a' || key == 'A') {
    p1.isMovingLeft = true;
  } if (!spaceBarCooldownActive && key == ' ') { // Check if space bar cooldown is not active and space bar is pressed
    // Create a new melee object at the player's position
    p1.useMelee();
    slapSound.play();
  } if (key == 'R' || key == 'r'){
     state = 0; 
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

void drawTitleScreen() {
  
  if (backgroundMusic.isPlaying() == false){
      backgroundMusic.play();
   }
  
  // Draw the start screen
  background(titleScreen);
  // Render the start button animation
  buttonAnimation.display(startButton.x, startButton.y);
  buttonAnimation.isAnimating = true;
  // Check if the start button is pressed
  if (mousePressed && mouseX > startButton.x - startButton.width/2 && mouseX < startButton.x + startButton.width/2 && mouseY > startButton.y - startButton.height/2 && mouseY < startButton.y + startButton.height/2) {
    state = 1;
  }   
}

void drawWinScreen() {
  // Draw the win screen
  background(backgroundImage);
  eatingAnimation.display(width/2, height/2);
  eatingAnimation.isAnimating = true;
  cheeseAnimation.display(width/2 + 50, height/2 - 50);
  cheeseAnimation.isAnimating = true;
  winAnimation.display(width/2, height/2 - 200);
  winAnimation.isAnimating = true;

    winMusic.pause();
      if (winMusic.isPlaying() == false){
      winMusic.play();
    }
}

void drawLoseScreen() {
  // Draw the lose screen
   background(backgroundImage);
   
   catOneAnimation.display(width/2, height/2);
   catOneAnimation.isAnimating = true;
   dyingAnimation.display(width/2, height/2 + 100);
   dyingAnimation.isAnimating = true;
  
   backgroundMusic.pause();
      
      if (loseMusic.isPlaying() == false){
      loseMusic.play();
    }
}

void playLevel(int level, Animation catAnimation) {
  // Play a specific level of the game
   
  background(backgroundImage);
  idleAnimation.display(p1.x, p1.y);
  idleAnimation.isAnimating = true;
  p1.move(enemyList);

  handleEnemies(catAnimation);
  renderHearts(p1.lives);
  handleMeleeAttacks();

  if (p1.lives <= 0) {
    state = 5; // Change to game over state
  } else if (state == level) {
    // Check if all enemies in the current level are defeated
    boolean allEnemiesDefeated = true;
    for (Enemy enemy : enemyList) {
      if (!enemy.shouldRemove) {
        allEnemiesDefeated = false;
        break;
      }
    }
    if (allEnemiesDefeated) {
      if (level < 3) {
        state = level + 1; // Transition to the next level
        // Reset player position to the middle when state changes
        p1.resetPosition(width/2, height/2);
        // Initialize enemies for the next level
        initializeEnemiesForNextLevel(level + 1);
      } else {
        state = 4; // Go to the win screen
      }
    }
  }
}

void initializeEnemiesForNextLevel(int nextLevel) {
  enemyList.clear(); // Clear the current enemy list
  int numEnemies = 10 + (5 * (nextLevel - 1)); // Adjust number of enemies based on level
  for (int i = 0; i < numEnemies; i++) {
    int enemyX, enemyY;
    do {
      enemyX = int(random(width));
      enemyY = int(random(height));
    } while (dist(enemyX, enemyY, p1.x, p1.y) < 150); // Adjust distance as needed
    int enemyColor = color(255, 0, 0);
    if (nextLevel == 2) {
      enemyColor = color(0, 255, 0);
    } else if (nextLevel == 3) {
      enemyColor = color(0, 0, 255);
    }
    enemyList.add(new Enemy(enemyX, enemyY, 50, 50, enemyColor));
  }
}

void handleEnemies(Animation catAnimation) {
  // Handle enemy actions and rendering
  for (Enemy anEnemy : enemyList) {
    anEnemy.followPlayer(p1);
    anEnemy.avoidCollision(enemyList);
    catAnimation.display(anEnemy.x, anEnemy.y);
    catAnimation.isAnimating = true;
    p1.loseLife(anEnemy);
  }

  // Check if all enemies are defeated
  if (enemyList.isEmpty()) {
    if (state < 3) {
      state++; // Transition to the next level
    } else {
      state = 4; // Go to the win screen
    }
    // Reset player position to the middle when state changes
    p1.resetPosition(width/2, height/2);
  }
}

void handleMeleeAttacks() {
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
}    

void renderHearts(int numHearts) {
  // Render player's remaining lives as hearts
  for (int i = 0; i < numHearts; i++) {
    image(heartImages.get(i), width - (i * (heartSize + heartSpacing)) - heartSize, heartSize);
  }
}
