/*FISH GENE EVOLUTION SIMULATION
  Based on Richard Dawkins "The Selfish Gene"
  
  Student: Qiu Dingqiang 832503118
  SEL
  
  Genetic Rules (Mendelian Inheritance):
  - G = High gene (Tall + Low speed)
  - g = Short gene (Short + High speed)
  - GG = High (H)
  - Gg = Moderate (M)   ← Heterozygote advantage in complex climate
  - gg = Short (S)
  - First generation: ONLY GG and gg (no Moderate)
  - Offspring follow real genetics (Punnett Square)
  - 70% mutation chance every birth
  - Press SPACE or N for next generation
 Rules:
  - 3 types of creatures: Moderate (M), High (H), Short (S)
  - Survival = 20% base + (speed * height) + food + climate effects
  - All get +10% from ground food, H and S get extra +5% from special food
  - Moderate always 10% in every weather
  - High and Short get  -27%  or -37% (different for each weather)
  - More complex climate = more bonus for Moderate
  - 5% mutation rate every generation
  - Press SPACE or N for next generation
*/

ArrayList<Creature> population = new ArrayList<Creature>();
int generation = 0;
float mutationRate = 0.05;   // 5% mutation

String[] climateTypes = {"Rainy", "Windy", "Hot", "Cold", "Dry", "Storm"};
ArrayList<String> currentClimates = new ArrayList<String>();

// Base parameters
float baseSurvival = 0.20;

void setup() {
  size(1200, 720);
  textAlign(CENTER);
  initFirstGeneration(120);   // First generation: only High and Short
  nextGeneration();
}

void draw() {
  background(240, 248, 255);
  displayInfo();
  displayCreatures();
  displayLegend();
}

void keyPressed() {
  if (key == ' ' || key == 'n' || key == 'N') {
    nextGeneration();
  }
}

// ==================== FIRST GENERATION ====================
void initFirstGeneration(int num) {
  population.clear();
  for (int i = 0; i < num; i++) {
    // Only GG or gg in first generation
    String genotype = random(1) < 0.5 ? "GG" : "gg";
    population.add(new Creature(genotype, random(width), random(height-250, height)));
  }
}

// ==================== NEXT GENERATION ====================
void nextGeneration() {
  generation++;
  generateRandomClimate();
  
  ArrayList<Creature> newPop = new ArrayList<Creature>();
  
  // Random mating
  for (int i = 0; i < population.size() * 1.5; i++) {   // more offspring
    Creature parent1 = population.get(int(random(population.size())));
    Creature parent2 = population.get(int(random(population.size())));
    
    String childGenotype = mendelianCross(parent1.genotype, parent2.genotype);
    
    // Mutation 5%
    if (random(1) < mutationRate) {
      childGenotype = mutate(childGenotype);
    }
    
    float survivalProb = calculateSurvival(childGenotype);
    
    if (random(1) < survivalProb) {
      newPop.add(new Creature(childGenotype, random(width), random(height-250, height)));
    }
  }
  
  // Keep population size reasonable
  while (newPop.size() < 60) {
    String g = random(1) < 0.5 ? "GG" : "gg";
    newPop.add(new Creature(g, random(width), random(height-250, height)));
  }
  
  population = newPop;
}

// Mendelian inheritance (Punnett Square logic)
String mendelianCross(String g1, String g2) {
  // Extract alleles
  char a1 = g1.charAt(0);
  char a2 = g1.charAt(1);
  char b1 = g2.charAt(0);
  char b2 = g2.charAt(1);
  
  // Random gamete from each parent
  char gamete1 = random(1) < 0.5 ? a1 : a2;
  char gamete2 = random(1) < 0.5 ? b1 : b2;
  
  // Combine and sort (GG, Gg, gg)
  if (gamete1 == gamete2) {
    return "" + gamete1 + gamete2;
  } else {
    return gamete1 < gamete2 ? "" + gamete1 + gamete2 : "" + gamete2 + gamete1;
  }
}

String mutate(String genotype) {
  if (random(1) < 0.5) {
    return "GG";
  } else if (random(1) < 0.5) {
    return "gg";
  } else {
    return "Gg";
  }
}

// ==================== SURVIVAL CALCULATION ====================
float calculateSurvival(String genotype) {
  char type = getPhenotype(genotype);   // G/G -> H, G/g -> M, g/g -> S
  
  float speedContrib = (type == 'H') ? 0.40 : (type == 'M') ? 0.70 : 0.90;
  float heightContrib = (type == 'H') ? 0.90 : (type == 'M') ? 0.50 : 0.40;
  
  float traitScore = speedContrib * heightContrib;
  float survival = baseSurvival + traitScore;
  
  // Food: all get +10% ground food, H and S get +5% special
  survival += 0.10;
  if (type == 'H' || type == 'S') survival += 0.05;
  
  // Climate effects
  float climateMod = 0;
  int complexity = currentClimates.size();
  for (String c : currentClimates) {
    climateMod += getClimateEffect(c, type);
  }
  survival += climateMod;
  
  // Complexity bonus for Moderate (Gg)
  if (type == 'M') {
    if (complexity == 2) survival += 0.08;
    if (complexity >= 3) survival += 0.15;
  }
  
  return constrain(survival, 0.0, 1.0);
}

char getPhenotype(String genotype) {
  if (genotype.equals("GG")) return 'H';
  if (genotype.equals("gg")) return 'S';
  return 'M';   // Gg
}

float getClimateEffect(String climate, char type) {
  if (type == 'M') return 0.10;   // always -10% for Moderate
  
  // High and Short different effects
  if (climate.equals("Rainy"))  return (type == 'H') ? -0.57 : -0.37;
  if (climate.equals("Windy"))  return (type == 'H') ? -0.37 : -0.57;
  if (climate.equals("Hot"))    return (type == 'H') ? -0.57 : -0.37;
  if (climate.equals("Cold"))   return (type == 'H') ? -0.37 : -0.57;
  if (climate.equals("Dry"))    return (type == 'H') ? -0.57 : -0.37;
  if (climate.equals("Storm"))  return (type == 'H') ? -0.57 : -0.37;
  return 0;
}

void generateRandomClimate() {
  currentClimates.clear();
  int num = int(random(1, 4));   // 1~3 climates
  for (int i = 0; i < num; i++) {
    String c = climateTypes[int(random(climateTypes.length))];
    if (!currentClimates.contains(c)) currentClimates.add(c);
  }
}

// ==================== CREATURE CLASS ====================
class Creature {
  String genotype;
  char type;
  float x, y;
  color col;
  
  Creature(String g, float x_, float y_) {
    genotype = g;
    type = getPhenotype(g);
    x = x_;
    y = y_;
    
    if (type == 'M') col = color(0, 100, 200);     // Blue - Moderate
    else if (type == 'H') col = color(180, 0, 0);  // Red - High
    else col = color(0, 180, 0);                   // Green - Short
  }
}

// ==================== DISPLAY ====================
void displayCreatures() {
  for (Creature c : population) {
    stroke(c.col);
    strokeWeight(5);
    float bodyHeight = (c.type == 'H') ? 58 : (c.type == 'S') ? 28 : 42;
    
    // body
    line(c.x, c.y, c.x, c.y - bodyHeight);
    // head
    fill(c.col);
    ellipse(c.x, c.y - bodyHeight - 8, 20, 20);
    // legs
    line(c.x-8, c.y, c.x-16, c.y+12);
    line(c.x+8, c.y, c.x+16, c.y+12);
    
    // show genotype
    fill(0);
    textSize(11);
    text(c.genotype, c.x, c.y - bodyHeight - 25);
  }
}

void displayInfo() {
  fill(0);
  textSize(24);
  text("SELFISH GENE EVOLUTION - Mendelian Genetics", width/2, 40);
  
  textSize(18);
  text("Generation: " + generation + "   Population: " + population.size(), width/2, 75);
  
  // Count types
  int nH = 0, nM = 0, nS = 0;
  for (Creature c : population) {
    if (c.type == 'H') nH++;
    else if (c.type == 'M') nM++;
    else nS++;
  }
  
  text("High(GG): " + nH + "   Moderate(Gg): " + nM + "   Short(gg): " + nS, width/2, 105);
  text("Current Climate: " + currentClimates, width/2, 135);
  
  textSize(15);
  text("Press SPACE or N → Next Generation", width/2, height - 25);
}

void displayLegend() {
  textSize(16);
  fill(180,0,0);   text("H = GG  High (Tall, Low speed)", 180, height-110);
  fill(0,100,200); text("M = Gg  Moderate (Balanced)", 180, height-80);
  fill(0,180,0);   text("S = gg  Short (Fast)", 180, height-50);
}
