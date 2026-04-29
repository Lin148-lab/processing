// Name: Lin Jinhan
// MU: 25125621
ArrayList<Creature> creatures;
ArrayList<PVector> foods;

// --- Evolution Settings ---
int maxFood = 50;           // Maximum number of food pellets allowed on screen
int initialCreatures = 20;  // Starting population
int foodSpawnRate = 15;     // New food every 15 frames

void setup() {
  size(800, 600);
  creatures = new ArrayList<Creature>();
  foods = new ArrayList<PVector>();

  // Initialize the starting population with random positions
  for (int i = 0; i < initialCreatures; i++) {
    creatures.add(new Creature(random(width), random(height)));
  }
}

void draw() {
  background(30); 

  // 1. LIMIT FOOD GENERATION
  // Only add food if the current count is below the maxFood threshold
  if (frameCount % foodSpawnRate == 0 && foods.size() < maxFood) {
    foods.add(new PVector(random(width), random(height)));
  }

  // Draw food pellets
  fill(0, 255, 100);
  noStroke();
  for (PVector f : foods) {
    ellipse(f.x, f.y, 5, 5);
  }

  // 2. UPDATE AND FILTER POPULATION
  // Iterate backwards to safely remove dead creatures or add babies
  for (int i = creatures.size() - 1; i >= 0; i--) {
    Creature c = creatures.get(i);
    c.update();
    c.display();
    
    // Reproduction logic: If successful, a child is added to the list
    Creature baby = c.reproduce();
    if (baby != null) {
      creatures.add(baby);
    }

    // 3. RESOURCE COMPETITION
    // Creatures check for food collision
    for (int j = foods.size() - 1; j >= 0; j--) {
      if (dist(c.pos.x, c.pos.y, foods.get(j).x, foods.get(j).y) < 15) {
        c.eat();
        foods.remove(j); // Food is consumed and removed from environment
      }
    }

    // 4. NATURAL SELECTION
    // If energy hits zero, the creature is removed (dies)
    if (c.isDead()) {
      creatures.remove(i);
    }
  }

  // 5. DATA DISPLAY
  displayStats();
}

void displayStats() {
  fill(255);
  textSize(14);
  text("Population: " + creatures.size(), 20, 30);
  text("Food Count: " + foods.size() + " / " + maxFood, 20, 50);
  
  // Calculate average gene to observe convergence
  if (creatures.size() > 0) {
    float totalGene = 0;
    for (Creature c : creatures) totalGene += c.speedGene;
    float avg = totalGene / creatures.size();
    text("Average Speed Gene: " + nf(avg, 1, 2), 20, 70);
  }
}

class Creature {
  PVector pos;
  PVector vel; 
  float energy;
  float speedGene; // The inherited trait (speed)
  float size = 12;
  
  // Constructor for first generation
  Creature(float x, float y) {
    this(x, y, random(0.5, 5.0));  
  }
  
  // Constructor for offspring (inherits and mutates the gene)
  Creature(float x, float y, float parentGene) {
    pos = new PVector(x, y);
    
    // Genetic Mutation: Child's speed is similar to parent's but slightly varied
    speedGene = parentGene + random(-0.1, 0.1); 
    speedGene = max(0.5, speedGene); // Ensure speed isn't negative or zero
    
    vel = PVector.random2D(); 
    energy = 150; // Starting energy
  }
  
  void update() {
    // Movement logic
    PVector jitter = PVector.random2D();
    jitter.mult(0.2); 
    vel.add(jitter);
    vel.setMag(speedGene); // Speed is dictated by the gene
    
    pos.add(vel);
    
    // Boundary handling (Bounce)
    if (pos.x < 0 || pos.x > width) { vel.x *= -1; pos.x = constrain(pos.x, 0, width); }
    if (pos.y < 0 || pos.y > height) { vel.y *= -1; pos.y = constrain(pos.y, 0, height); }
    
    // ENERGY CONSUMPTION
    // Metabolism: faster creatures burn energy much quicker
    energy -= (0.1 + (speedGene * 0.15));
  }
  
  Creature reproduce() {
    // If a creature accumulates enough energy, it splits
    if (energy > 250) {
      energy -= 150; // Cost of reproduction
      return new Creature(pos.x, pos.y, speedGene);
    }
    return null;
  }
  
  void eat() {
    energy += 40; // Gain energy from food
    // Higher energy cap allows successful genes to dominate longer
    if (energy > 400) energy = 400; 
  }
  
  boolean isDead() {
    return energy <= 0;
  }
  
  void display() {
    // Color represents the gene: Blue = Slow/Low Energy, Red = Fast/High Energy
    float r = map(speedGene, 0.5, 5, 50, 255);
    float b = map(speedGene, 0.5, 5, 255, 50);
    fill(r, 100, b, 200); 
    noStroke();
    ellipse(pos.x, pos.y, size, size);
  }
}
