//Student Name: Xukun Liang
//MU ID: 25126873
//In this sketch I only realize the arm length crossover and mutate function...

ArrayList<man> population;
int generation = 1;

void setup() {
  size(1000,600);
  population = new ArrayList<man>();
  population.add(new man(40));
  population.add(new man(60));
}

void draw() {
  background(255);
  drawTitle();
  drawImformation();
  drawPopulation();
}

//The method below is writtend by ChatGPT based on the variable I settled
//since I don't know the functions to do parents selection.

man selectParent() {
  float totalFitness = 0;
  for (man s : population) {
    totalFitness += s.armLength;
  }

  float r = random(totalFitness);
  float sum = 0;

  for (man s : population) {
    sum += s.armLength;
    if (sum > r) return s;
  }

  return population.get(0);
}

//AI wretten ahead.

//lerp() function is also the function which GPT told me that can realize crossover... 

float crossover(float a, float b) {
  return lerp(a, b, random(1));
}

float mutate(float val) {
  float mutateRate = 0.15;
  if (random(1) < mutateRate) {
    val += random(-20, 20);
  }
  return val;
}

void evolve() {
  ArrayList<man> nextGen = new ArrayList<man>();
  int targetSize = 0;

  if (generation<3) {
    targetSize = population.size()*2;
  } else {
    targetSize = 8;
  }

  for (int i = 0; i<targetSize; i++) {
    man p1 = selectParent();
    man p2 = selectParent();
    
    float childArm = crossover(p1.armLength, p2.armLength);
    childArm = mutate(childArm);
    nextGen.add(new man(childArm));
  }
  population = nextGen;
  generation++;
}

void drawTitle() {
  fill(0);
  textAlign(CENTER);
  textSize(24);
  text("Selfish Gene", width / 2, 40);
}

void drawImformation() {
  textSize(16);
  text("Generation: " + generation + "   (Press 'SPACE' to continue)", width / 2, 80);
}

void drawPopulation() {
  int n = population.size();

  float space = width/(n+1);

  for (int i = 0; i<n; i++) {
    float x = space*(i+1);
    float y = height*0.65;

    population.get(i).display(x, y);
  }
}

class man {
  float armLength;

  man(float armLength) {
    this.armLength = armLength;
  }

  void display(float x, float y) {
    stroke(2);

//Head
    ellipse(x, y-40, 20, 20);

//Body
    line(x, y-30, x, y);    

//Legs
    line(x, y, x-10, y + 20);
    line(x, y, x+10, y + 20);

//Arms
    line(x, y-20, x - armLength/2, y-20);
    line(x, y-20, x + armLength/2, y-20);

    fill(0);
    
    if(armLength>100) fill(255, 0, 0);
    
    textSize(10);
    textAlign(CENTER);
    text(armLength, x, y+35);
    fill(0);
  }
}
