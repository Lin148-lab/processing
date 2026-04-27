/**
 * A Snake game based on ID randomness
 * name : Lin Jinhan
 * ID : 25125621
 */

int gridSize = 25;      // The size of each square
ArrayList<PVector> snake; // List of snake body coordinates
PVector food;           // Food coordinates
PVector direction;      // The current moving direction
PVector nextDirection;  // Preset next frame movement direction (to prevent 180-degree suicide)
int score = 0;
boolean gameOver = false;
int lastMoveTime = 0;   // Record the time of the last move
int moveInterval = 150; // The movement interval (in milliseconds), the smaller the value, the faster the snake
int studentID = 25125621;
int IDspeed;


void setup() {
  size(750, 750);
  frameRate(60);
  resetGame();
}

void draw() {
  background(30); // The background is dark grey
  
  if (!gameOver) {
    // Control the movement speed of the snake
    if (millis() - lastMoveTime > moveInterval) {
      updateSnake();
      lastMoveTime = millis();
    }
    drawGame();
  } else {
    showGameOver();
  }
}

// Initialize the game
void resetGame() {
  snake = new ArrayList<PVector>();
  snake.add(new PVector(10, 10)); // initial position
  direction = new PVector(1, 0);  // Initially move to the right


  nextDirection = new PVector(1, 0);
  score = 0;
  gameOver = false;
  spawnFood();
  IDspeed = (studentID / 100000) % 30;
  
} //<>//

// ganerate food
void spawnFood() {
  
  int cols = width / gridSize;
  int rows = height / gridSize;
  food = new PVector(floor(random(cols)), floor(random(rows)));
  
}

// Core logic: Update the state of the snake
void updateSnake() {
  direction.set(nextDirection); // Determine the direction of this step
  
  // Calculate the position of the new snake head
  PVector head = snake.get(snake.size() - 1).copy();
  head.add(direction);
  
  // 1. Collision detection: Wall impact
  if (head.x < 0 || head.x >= width/gridSize || head.y < 0 || head.y >= height/gridSize) {
    gameOver = true;
    return;
  }
  
  // 2. Collision detection: Hitting oneself
  for (PVector part : snake) {
    if (head.x == part.x && head.y == part.y) {
      gameOver = true;
      return;
    }
  }
  
  // 3.move and eat food
  snake.add(head); // add a new snake head
  if (head.x == food.x && head.y == food.y) {
    score++;
    
    if (score % 5 == 0 && moveInterval > 50) { //When the score reaches a multiple of 5, reduce the preset time interval to accelerate the snake
      moveInterval -= 10;
    }
    
    if (score == IDspeed && moveInterval > 50) {
      moveInterval -= 50;
    }
    
    spawnFood(); // Eating food, not removing the snake's tail (the body becomes longer)
  } else {
    snake.remove(0); // Didn't get to eat it. Delete the snake tail (keep the length)
  }
}

// draw
void drawGame() {
  // draw food
  fill(255, 0, 0);
  rect(food.x * gridSize, food.y * gridSize, gridSize-1, gridSize-1);
  
  // draw snaka
  fill(0, 255, 0);
  for (PVector p : snake) {
    rect(p.x * gridSize, p.y * gridSize, gridSize-1, gridSize-1);
  }
  
  // draw score
  fill(255);
  textSize(20);
  text("Score: " + score, 35, 30);
}

// Game end screen
void showGameOver() {
  background(0);
  fill(255);
  textAlign(CENTER);
  textSize(40);
  text("GAME OVER", width/2, height/2);
  textSize(20);
  text("Final Score: " + score, width/2, height/2 + 50);
  text("Click to Restart", width/2, height/2 + 100);
}

// input control
void keyPressed() {
  if (keyCode == UP && direction.y == 0){
     nextDirection.set(0, -1);
  }    
  if (keyCode == DOWN && direction.y == 0) {
    nextDirection.set(0, 1);
  }  
  if (keyCode == LEFT && direction.x == 0) {
    nextDirection.set(-1, 0);
  }  
  if (keyCode == RIGHT && direction.x == 0) {
    nextDirection.set(1, 0);
  } 
  
}

void mousePressed() {
  if (gameOver) resetGame();
}
