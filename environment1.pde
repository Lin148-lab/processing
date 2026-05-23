class Food {
  public float x;
  public float y;
  public boolean isHigh;
  public boolean eaten;
  public float nutrition;

  // Constructor of food object
  Food(float x, float y, boolean isHigh) {
    this.x = x;
    this.y = y;
    this.isHigh = isHigh;
    this.eaten = false;
    this.nutrition = isHigh ? 22 : 16;
  }

  // Render food graphic
  void display() {
    if (eaten) return;

    noStroke();
    if (isHigh) {
      fill(70, 180, 255);
    } else {
      fill(80, 220, 100);
    }
    ellipse(x, y, 14, 14);
  }
}

/**
 * Member C: EnvironmentManager.pde
 * Class Name: EnvironmentManager
 * Core Functions:
 * 1. displayEnvSelection
 * 2. drawBackground
 * 3. currentEnvTemp
 * 4. foodList
 */
class EnvironmentManager {
  public float currentEnvTemp = 20;
  public ArrayList<Food> foodList;
  public int currentEnvType = 1;
  public float highFoodLineY = 300;
  public boolean environmentLocked;

  float coldX = 170;
  float normalX = 490;
  float hotX = 810;
  float btnY = 340;
  float btnW = 220;
  float btnH = 110;

  // Constructor
  EnvironmentManager() {
    foodList = new ArrayList<Food>();
    environmentLocked = false;
  }

  // Reset all food while keeping current temperature
  void resetFoods() {
    foodList.clear();
    generateFoods(50);
  }

  // Show environment selection interface
  void displayEnvSelection() {
    uiManager.drawBackgroundBase();
    uiManager.drawTitleText("SELECT ENVIRONMENT", 110);

    uiManager.drawButton(coldX, btnY, btnW, btnH, "COLD");
    uiManager.drawButton(normalX, btnY, btnW, btnH, "NORMAL");
    uiManager.drawButton(hotX, btnY, btnW, btnH, "HOT");

    fill(30);
    textAlign(CENTER, CENTER);
    textSize(22);
    text("Cold  -10", coldX + btnW / 2, btnY + 72);
    text("Normal  20", normalX + btnW / 2, btnY + 72);
    text("Hot  40", hotX + btnW / 2, btnY + 72);
  }

  // Detect cold area button click
  boolean checkColdClick() {
    return uiManager.isMouseInRect(coldX, btnY, btnW, btnH);
  }

  // Detect normal area button click
  boolean checkNormalClick() {
    return uiManager.isMouseInRect(normalX, btnY, btnW, btnH);
  }

  // Detect hot area button click
  boolean checkHotClick() {
    return uiManager.isMouseInRect(hotX, btnY, btnW, btnH);
  }

  // Choose environment type and spawn food
  void selectEnvironment(int type) {
    currentEnvType = type;
    foodList.clear();

    if (type == 0) {
      currentEnvTemp = -10;
    } else if (type == 1) {
      currentEnvTemp = 20;
    } else {
      currentEnvTemp = 40;
    }
    
    generateFoods(50);
    environmentLocked = true;
  }

  // Draw scene background and all food items
  void drawBackground() {
    if (currentEnvType == 0) {
      background(185, 225, 255);
    } else if (currentEnvType == 1) {
      background(205, 235, 200);
    } else {
      background(245, 190, 140);
    }

    stroke(255, 180);
    strokeWeight(2);
    line(0, highFoodLineY, width, highFoodLineY);

    fill(255);
    textAlign(LEFT, CENTER);
    textSize(18);
    text("High Food Zone", 20, highFoodLineY - 15);
    text("Low Food Zone", 20, highFoodLineY + 20);

    fill(40);
    text("Environment Temperature: " + nf(currentEnvTemp, 1, 1), 20, 40);

    for (Food f : foodList) {
      f.display();
    }

    updateFoods();
  }

  // Spawn initial food objects with fixed quantity
  void generateFoods(int count) {
    for (int i = 0; i < count; i++) {
      boolean isHigh = random(1) < 0.45;
      float fx = random(80, width - 80);
      float fy;

      if (isHigh) {
        fy = random(100, highFoodLineY - 30);
      } else {
        fy = random(highFoodLineY + 30, height - 60);
      }

      foodList.add(new Food(fx, fy, isHigh));
    }
  }

  // Dynamically replenish food resources
  void updateFoods() {
    int aliveFoodCount = 0;

    for (Food f : foodList) {
      if (!f.eaten) {
        aliveFoodCount++;
      }
    }

    if (aliveFoodCount < 25 && random(1) < 0.08) {
      boolean isHigh = random(1) < 0.45;
      float fx = random(80, width - 80);
      float fy;

      if (isHigh) {
        fy = random(100, highFoodLineY - 30);
      } else {
        fy = random(highFoodLineY + 30, height - 60);
      }

      foodList.add(new Food(fx, fy, isHigh));
    }
  }
}
