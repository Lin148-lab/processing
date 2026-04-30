//832503109 Hu Hongyi
ArrayList<Creature> creatures;
int statsWidth = 150;
boolean isBreeding;
boolean finishBreed;
int breedTime;
PVector breedCenter;

void setup() {
  size(1050, 600);
  creatures = new ArrayList<>();
  creatures.add(new Creature(150, 300));
  creatures.add(new Creature(450, 300));
  isBreeding = false;
  finishBreed = false;
  breedTime = 0;
}

void draw() {
  background(20);
  
  if(!finishBreed && !isBreeding){
    autoApproach();
  }

  for (Creature c : creatures) {
    c.show();
  }

  if(isBreeding && !finishBreed){
    breedAnimation();
  }

  drawUI();
}

void autoApproach() {
  Creature c1 = creatures.get(0);
  Creature c2 = creatures.get(1);
  PVector dir = PVector.sub(c2.pos, c1.pos);
  dir.mult(0.02);
  c1.pos.add(dir);
  c2.pos.sub(dir);
  
  if (PVector.dist(c1.pos, c2.pos) < 70) {
    isBreeding = true;
    breedCenter = new PVector((c1.pos.x + c2.pos.x) / 2, (c1.pos.y + c2.pos.y) / 2);
  }
}

void breedAnimation() {
  breedTime++;
  stroke(120, 220, 255);
  strokeWeight(2);
  noFill();
  float r = breedTime * 1.8;
  ellipse(breedCenter.x, breedCenter.y, r, r);
  strokeWeight(1);

  if (breedTime >= 45) {
    creatures.add(new Creature(breedCenter.x, breedCenter.y));
    isBreeding = false;
    finishBreed = true;
  }
}

class Creature {
  PVector pos;
  Creature(float x, float y) {
    pos = new PVector(x, y);
  }
  void show() {
    fill(70, 190, 230);
    noStroke();
    beginShape();
    vertex(pos.x, pos.y - 12);
    vertex(pos.x - 10, pos.y + 8);
    vertex(pos.x + 10, pos.y + 8);
    endShape(CLOSE);
  }
}

void drawUI() {
  fill(35, 35, 35);
  noStroke();
  rect(width - statsWidth, 0, statsWidth, height);
  fill(255);
  textSize(14);
  textAlign(LEFT, TOP);
  int x = width - statsWidth + 15;

  text("Population: " + creatures.size(), x, 30);
  text("Gen 1 → Gen 2", x, 60);
  
  if(isBreeding){
    text("Breeding...", x, 90);
  }else if(finishBreed){
    text("Breed Finished", x, 90);
  }else{
    text("Waiting", x, 90);
  }
}
