class FinalStats {
  float avgHand = 0;
  float avgLeg = 0;
  float avgTemp = 0;
  float avgHead = 0;
  int survivorCount = 0;
  int timeCost = 0;
}

/**
 * MUID:832503117
 * Team Member D: SimulationCore.pde
 * Class Name: SimulationCore
 * Core Tasks:
 * 1. runSimulation
 * 2. checkStopClick
 * 3. getFinalStats
 * 4. isSimulationOver
 */
class SimulationCore {
  public ArrayList<Creature> simCreatures;
  public boolean initialized;
  public boolean isRunning;
  public int competitionFrames;
  public ArrayList<Creature> lastSurvivors;

  float stopX = 1030;
  float stopY = 25;
  float stopW = 130;
  float stopH = 45;

  SimulationCore() {
    simCreatures = new ArrayList<Creature>();
    initialized = false;
    isRunning = true;
  }

  ArrayList<Creature> forceStopAndGetSurvivors() {
    isRunning = false;
    // Sort by strength score in descending order
    Collections.sort(simCreatures, new Comparator<Creature>() {
      public int compare(Creature a, Creature b) {
        float scoreA = a.getStrengthScore();
        float scoreB = b.getStrengthScore();
        if (scoreA > scoreB) return -1;
        else if (scoreA < scoreB) return 1;
        else return 0;
      }
    }
    );
    // Return the top two (if fewer than 2, return all)
    ArrayList<Creature> top = new ArrayList<Creature>();
    for (int i = 0; i < min(2, simCreatures.size()); i++) {
      top.add(simCreatures.get(i));
    }
    return top;
  }

  ArrayList<Creature> getCurrentSurvivors() {
    return simCreatures;
  }

  void reset() {
    simCreatures.clear();
    if (lastSurvivors != null) lastSurvivors.clear();
    initialized = false;
    isRunning = true;
    competitionFrames = 0;
  }

  // [Team Member D] Prepare simulation objects
  void prepareSimulation(ArrayList<Creature> sourceList) {
    lastSurvivors = null;
    simCreatures.clear();
    // Use a 10x10 grid to evenly distribute 100 creatures on the canvas (fixed positions)
    int cols = 10;
    int rows = 10;
    float startX = 80;
    float startY = 120;
    float stepX = (width - 160) / (cols - 1);
    float stepY = (height - 200) / (rows - 1);
    int idx = 0;
    for (Creature src : sourceList) {
      Creature c = new Creature(src.hand, src.leg, src.temp, src.head);
      int col = idx % cols;
      int row = idx / cols;
      c.x = startX + col * stepX;
      c.y = startY + row * stepY;
      simCreatures.add(c);
      idx++;
    }

    initialized = true;
    isRunning = true;
  }

  // [Team Member D] Per-frame simulation
  void runSimulation(float temp, ArrayList<Food> foods) {
    if (!isRunning) return;

    competitionFrames++;
    updateMovement();
    updateEnergy(temp);
    checkFoodCollision(foods);
    removeDead();
    displayCreatures();
  }

  // Random movement
  void updateMovement() {
    for (Creature c : simCreatures) {
      if (!c.alive) continue;
      if (random(1) < 0.03) {
        float maxSpeed = map(c.leg, 20, 160, 0.6, 2.8);
        c.speedX = random(-maxSpeed, maxSpeed);
        c.speedY = random(-maxSpeed, maxSpeed);
      }

      c.x += c.speedX;
      c.y += c.speedY;
      if (c.x < 30) {
        c.x = 30;
        c.speedX *= -1;
      }
      if (c.x > width - 30) {
        c.x = width - 30;
        c.speedX *= -1;
      }
      if (c.y < 90) {
        c.y = 90;
        c.speedY *= -1;
      }
      if (c.y > height - 30) {
        c.y = height - 30;
        c.speedY *= -1;
      }
    }
  }

  // Energy consumption
  void updateEnergy(float envTemp) {
    for (Creature c : simCreatures) {
      if (!c.alive) continue;
      float speed = dist(0, 0, c.speedX, c.speedY);
      float baseCost = 0.08;
      float moveCost = speed * 0.10;

      float tempPenalty;
      if (c.temp < envTemp) {
        tempPenalty = map(envTemp - c.temp, 0, 60, 0.03, 0.45);
      } else {
        tempPenalty = map(abs(envTemp - c.temp), 0, 60, 0.01, 0.25);
      }

      c.energy -= baseCost + moveCost + tempPenalty;
      if (c.energy < 0) {
        c.energy = 0;
      }
    }
  }

  // Food collision and contention
  void checkFoodCollision(ArrayList<Food> foods) {
    for (Food f : foods) {
      if (f.eaten) continue;
      ArrayList<Creature> contenders = new ArrayList<Creature>();

      for (Creature c : simCreatures) {
        if (!c.alive) continue;
        float range = c.getFoodRange();
        float d = dist(c.x, c.y, f.x, f.y);

        boolean canReach = true;
        if (f.isHigh) {
          canReach = c.getReachHeight() >= heightNeedForFood(f.y);
        }

        if (d <= range && canReach) {
          contenders.add(c);
        }
      }

      if (contenders.size() == 0) continue;
      Creature winner = determineWinner(contenders);
      float energyGain = f.nutrition;

      // Taller individuals have reduced efficiency when eating low-placed food
      if (!f.isHigh && winner
