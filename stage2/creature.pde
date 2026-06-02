/**
 * 组员B：Creature.pde////////////////
 * 个体类
 * 注意字段名已和组员D统一
 */
class Creature {
  public float hand;                                                             //hand
  public float leg;                                                              //leg
  public float temp;                                                             //temperature
  public float head;                                                             //head

  public float energy;                                                            //emergy
  public float x;                                                                 //location
  public float y;                                                                 //location
  public float speedX;                                                            //speed
  public float speedY;                                                            //speed
  public boolean alive;                                                           //survival status

  Creature(float hand, float leg, float temp, float head) {
    this.hand = hand;                                                             // Assign genetic genes 
    this.leg = leg;
    this.temp = temp;
    this.head = head;

    energy = 100;                                                                // Initial energy value is fixed at 100 
    x = random(80, width - 80);                                                  // Randomly generate initial coordinates within the limited range of the canvas
    y = random(120, height - 80);

    float maxSpeed = map(leg, 20, 160, 0.6, 2.8);                               // Generate maximum movement speed based on the leg genes
    speedX = random(-maxSpeed, maxSpeed);                                       // Initial speed
    speedY = random(-maxSpeed, maxSpeed);
    alive = true;                                                               // The initial state is alive
  }

  void display() {
    if (!alive) return;                                                         // If people die, exiting the drawing logic directly

    float rr = map(temp, -20, 50, 80, 255);                                     // Map body temperature values to RGB colors 
    float bb = map(temp, -20, 50, 255, 80);

    stroke(30);
    strokeWeight(2);
    fill(rr, 145, bb);

    ellipse(x, y - 14, head * 0.5, head * 0.5);                                 // Draw lines for the head, torso, arms, and legs
    line(x, y, x, y + 24);

    line(x, y + 5, x - hand * 0.18, y + 10);
    line(x, y + 5, x + hand * 0.18, y + 10);

    line(x, y + 24, x - leg * 0.14, y + 24 + leg * 0.22);
    line(x, y + 24, x + leg * 0.14, y + 24 + leg * 0.22);

    noStroke();                                                                 // Draw the background color and current value of the energy progress bar
    fill(255, 230, 80);
    rect(x - 16, y - 42, 32, 5);
    fill(90, 220, 120);
    rect(x - 16, y - 42, map(energy, 0, 100, 0, 32), 5);
  }

  void drawMini(float px, float py) {                                          // Temperature mapping color scheme
    float rr = map(temp, -20, 50, 80, 255);
    float bb = map(temp, -20, 50, 255, 80);
    noStroke();
    fill(rr, 145, bb);
    ellipse(px, py, 16, 16);
  }

  float getFoodRange() {                                                        // Calculate foraging range 
    return head * 0.4 + hand * 0.35 + 15;
  }

  float getReachHeight() {                                                     // Calculate limb reach height
    return hand + leg;
  }

  float getStrengthScore() {                                                  // Calculate strength score
    return hand * 0.4 + leg * 0.3 + head * 0.3;
  }
}
