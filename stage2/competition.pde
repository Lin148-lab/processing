class FinalStats {
  float avgHand = 0;
  float avgLeg = 0;
  float avgTemp = 0;
  float avgHead = 0;
  int survivorCount = 0;
  int timeCost = 0;
}

/**
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
    // Return the top two (if less than 2, return all)
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
    for (Creature src : sourceList) {
      Creature c = new Creature(src.hand, src.leg, src.temp, src.head);
      c.x = random(80, width - 80);
      c.y = random(120, height - 80);
      simCreatures.add(c);
    }

    initialized = true;
    isRunning = true;
  }

  // [Team Member D] Simulate per frame
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

  // Food collision and competition
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

      // High-stature individuals have lower efficiency when eating low-placed food
      if (!f.isHigh && winner.hand + winner.leg > 200) {
        energyGain *= 0.6;
      }

      winner.energy += energyGain;
      if (winner.energy > 100) {
        winner.energy = 100;
      }

      f.eaten = true;
    }
  }

  // Required reachable height for high-placed food
  float heightNeedForFood(float y) {
    return map(y, 100, environmentManager.highFoodLineY, 140, 40);
  }

  // Determine the winner of competition
  Creature determineWinner(ArrayList<Creature> contenders) {
    Creature best = contenders.get(0);
    float bestScore = getStrength(best);
    for (int i = 1; i < contenders.size(); i++) {
      Creature c = contenders.get(i);
      float score = getStrength(c);
      if (score > bestScore) {
        best = c;
        bestScore = score;
      }
    }

    return best;
  }

  float getStrength(Creature c) {
    return c.hand * 0.4 + c.leg * 0.3 + c.head * 0.3 + random(-8, 8);
  }

  // Remove dead creatures
  void removeDead() {
    for (int i = simCreatures.size() - 1; i >= 0; i--) {
      Creature c = simCreatures.get(i);
      if (c.energy <= 0) {
        c.alive = false;
        simCreatures.remove(i);
      }
    }

    if (simCreatures.size() == 2 && (lastSurvivors == null || lastSurvivors.size() != 2)) {
      lastSurvivors = new ArrayList<Creature>();
      for (Creature c : simCreatures) {
        // Deep copy to avoid subsequent reference issues
        lastSurvivors.add(new Creature(c.hand, c.leg, c.temp, c.head));
      }
    }
  }

  void displayCreatures() {
    for (Creature c : simCreatures) {
      c.display();
    }
  }

  // [Team Member D] Stop button click
  boolean checkStopClick() {
    if (uiManager.isMouseInRect(stopX, stopY, stopW, stopH)) {
      isRunning = false;
      return true;
    }
    return false;
  }

  // [Team Member D] Final average genes
  FinalStats getFinalStats() {
    FinalStats stats = new FinalStats();
    if (simCreatures.size() == 0) return stats;

    float sumHand = 0;
    float sumLeg = 0;
    float sumTemp = 0;
    float sumHead = 0;

    for (Creature c : simCreatures) {
      sumHand += c.hand;
      sumLeg += c.leg;
      sumTemp += c.temp;
      sumHead += c.head;
    }

    int n = simCreatures.size();
    stats.avgHand = sumHand / n;
    stats.avgLeg = sumLeg / n;
    stats.avgTemp = sumTemp / n;
    stats.avgHead = sumHead / n;
    stats.survivorCount = n;
    stats.timeCost = competitionFrames;

    return stats;
  }

  // [Team Member D] Automatic termination condition
  boolean isSimulationOver() {
    return simCreatures.size() <= 4;
  }
}
