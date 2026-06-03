/**
 * Team member E: UIManager.pde
 * Class name: UIManager
 * Main job:
 * 1. drawStartScreen
 * 2. drawEndScreen
 * 3. drawCommonUI
 * 4. make buttons look better
 *
 * This class controls the main UI screens.
 * It draws background, title text, buttons, and small moving particles.
 */
class UIManager {
  // Basic colors used in the UI.
  color BG_COLOR = color(240, 248, 255);
  color ACCENT = color(70, 130, 180);
  color TEXT_COLOR = color(35, 35, 35);
  color HOVER = color(100, 160, 210);

  // Fonts for different text styles.
  PFont titleFont;
  PFont bodyFont;
  PFont btnFont;

  // Store all particles in one ArrayList, so we can update and draw them by loop.
  ArrayList<Particle> particles = new ArrayList<Particle>();

  // Initialize fonts and particles before drawing the UI.
  void init() {
    titleFont = createFont("Arial Bold", 42);
    bodyFont = createFont("Arial", 20);
    btnFont = createFont("Arial Bold", 22);

    // Clear old particles first, so it will not keep adding more particles.
    particles.clear();

    // Create 90 particles for the background animation.
    for (int i = 0; i < 90; i++) {
      particles.add(new Particle());
    }
  }

  // Draw the basic background and grid lines.
  void drawBackgroundBase() {
    background(BG_COLOR);

    // Draw light grid lines to make the screen not too empty.
    stroke(210, 225, 240, 90);
    strokeWeight(1);

    // Vertical grid lines.
    for (int x = 0; x < width; x += 50) {
      line(x, 0, x, height);
    }

    // Horizontal grid lines.
    for (int y = 0; y < height; y += 50) {
      line(0, y, width, y);
    }
  }

  // Draw common moving background objects.
  // This function can be reused by different screens.
  void drawCommonUI() {
    for (Particle p : particles) {
      p.update();
      p.display();
    }
  }

  // Draw title text at the middle of screen with given y position.
  void drawTitleText(String str, float y) {
    textFont(titleFont);
    textAlign(CENTER, CENTER);
    fill(TEXT_COLOR);
    text(str, width / 2, y);
  }

  // Draw the start page.
  void drawStartScreen() {
    drawBackgroundBase();
    drawCommonUI();

    drawTitleText("GENE EVOLUTION SIMULATOR", 180);

    // Show a short instruction under the title.
    textFont(bodyFont);
    fill(TEXT_COLOR);
    textAlign(CENTER, CENTER);
    text("Click start to enter the parent gene page", width / 2, 255);

    // Main start button.
    drawButton(460, 380, 280, 90, "START");
  }

  // Draw the result page for one generation.
  void drawGenResultScreen(FinalStats stats, int generation) {
    drawBackgroundBase();
    drawTitleText("GENERATION " + generation + " RESULT", 100);

    // White information box.
    fill(255);
    stroke(70);
    strokeWeight(2);
    rect(200, 160, 800, 340, 24);

    // Show the data of this generation.
    fill(TEXT_COLOR);
    textFont(bodyFont);
    textAlign(CENTER, CENTER);
    text("Survivors: " + stats.survivorCount, width/2, 220);
    text("Top 2 selected as parents for next generation", width/2, 250);
    text("Competition Frames: " + stats.timeCost, width/2, 280);
    text("Average Hand: " + nf(stats.avgHand, 1, 2) + "   Leg: " + nf(stats.avgLeg, 1, 2) +
      "   Temp: " + nf(stats.avgTemp, 1, 2) + "   Head: " + nf(stats.avgHead, 1, 2), width/2, 320);

    // Two buttons: continue simulation or stop simulation.
    drawButton(300, 450, 250, 70, "NEXT GENERATION");
    drawButton(650, 450, 250, 70, "END SIMULATION");
  }

  // Check if the mouse is on the NEXT GENERATION button.
  boolean isNextGenClicked() {
    return isMouseInRect(300, 450, 250, 70);
  }

  // Check if the mouse is on the END SIMULATION button.
  boolean isEndFromGenResultClicked() {
    return isMouseInRect(650, 450, 250, 70);
  }

  // Draw the final end page.
  void drawEndScreen(FinalStats stats) {
    drawBackgroundBase();
    drawCommonUI();

    drawTitleText("EVOLUTION RESULT", 120);

    // White box for final result data.
    fill(255);
    stroke(70);
    strokeWeight(2);
    rect(320, 190, 560, 330, 24);

    // Show final statistics.
    fill(TEXT_COLOR);
    textFont(bodyFont);
    textAlign(CENTER, CENTER);
    text("Survivors: " + stats.survivorCount, width / 2, 250);
    text("Competition Frames: " + stats.timeCost, width / 2, 285);
    text("Average Hand Length: " + nf(stats.avgHand, 1, 2), width / 2, 325);
    text("Average Leg Length: " + nf(stats.avgLeg, 1, 2), width / 2, 375);
    text("Average Temperature Gene: " + nf(stats.avgTemp, 1, 2), width / 2, 425);
    text("Average Head Size: " + nf(stats.avgHead, 1, 2), width / 2, 475);

    // Restart button can go back to start screen.
    drawButton(460, 585, 280, 80, "RESTART");
  }

  // Draw a small stop button on the top right.
  void drawStopButton() {
    drawButton(1030, 25, 130, 45, "STOP");
  }

  // Draw one button with hover effect.
  // x and y are the left-top position, w and h are width and height.
  void drawButton(float x, float y, float w, float h, String label) {
    // If mouse is inside button area, use hover color.
    boolean hover = isMouseInRect(x, y, w, h);

    fill(hover ? HOVER : ACCENT);
    stroke(255);
    strokeWeight(3);
    rect(x, y, w, h, 16);

    // Draw button label at center of the button.
    fill(255);
    textFont(btnFont);
    textAlign(CENTER, CENTER);
    text(label, x + w / 2, y + h / 2 + 1);
  }

  // Check if START button is clicked.
  boolean isStartClicked() {
    return isMouseInRect(460, 380, 280, 90);
  }

  // Check if RESTART button is clicked.
  boolean isRestartClicked() {
    return isMouseInRect(460, 585, 280, 80);
  }

  // General function to check if mouse is inside a rectangle.
  boolean isMouseInRect(float x, float y, float w, float h) {
    return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
  }

  // Inner class for one background particle.
  class Particle {
    float x;
    float y;
    float vx;
    float vy;
    float s;
    color c;

    // Create one particle with random position, speed, size, and color.
    Particle() {
      x = random(width);
      y = random(height);
      vx = random(-1.2, 1.2);
      vy = random(-1.2, 1.2);
      s = random(4, 10);
      c = color(random(100, 220), random(140, 240), 255, 110);
    }

    // Move the particle and bounce it when it reaches screen edge.
    void update() {
      x += vx;
      y += vy;

      // Change moving direction when the particle hits the border.
      if (x < 0 || x > width) vx *= -1;
      if (y < 0 || y > height) vy *= -1;
    }

    // Draw the particle as a small circle.
    void display() {
      noStroke();
      fill(c);
      ellipse(x, y, s, s);
    }
  }
}
