//Name: Liang Xukun
//MU ID: 25126873

class ParentData {
  public float pA_hand;
  public float pA_leg;
  public float pA_temp;
  public float pA_head;

  public float pB_hand;
  public float pB_leg;
  public float pB_temp;
  public float pB_head;
}

class ParentGenerator {
  public ParentData parentData;

  float btnX = 450;
  float btnY = 680;
  float btnW = 300;
  float btnH = 65;

  ParentGenerator() {
    parentData = new ParentData();
  }

  //Generate parent gene randomly
  void generateParents() {
    parentData.pA_hand = random(30, 120);
    parentData.pA_leg  = random(30, 120);
    parentData.pA_temp = random(-10, 40);
    parentData.pA_head = random(20, 80);

    parentData.pB_hand = random(30, 120);
    parentData.pB_leg  = random(30, 120);
    parentData.pB_temp = random(-10, 40);
    parentData.pB_head = random(20, 80);
  }

  // Parent gene display page
  void displayPage() {
    uiManager.drawBackgroundBase();
    uiManager.drawTitleText("PARENT GENE DATA", 70);

    drawParentCard(180, 170, "Parent A", parentData.pA_hand, parentData.pA_leg, parentData.pA_temp, parentData.pA_head);
    drawParentCard(700, 170, "Parent B", parentData.pB_hand, parentData.pB_leg, parentData.pB_temp, parentData.pB_head);

    uiManager.drawButton(btnX, btnY, btnW, btnH, "GENERATE OFFSPRING");
  }

  void drawParentCard(float x, float y, String title, float hand, float leg, float temp, float head) {
    fill(255);
    stroke(60);
    strokeWeight(2);
    rect(x, y, 320, 380, 20);

    fill(30);
    textAlign(CENTER, CENTER);
    textSize(28);
    text(title, x + 160, y + 35);

    textSize(20);
    text("Hand Length: " + nf(hand, 1, 1), x + 160, y + 95);
    text("Leg Length: " + nf(leg, 1, 1), x + 160, y + 140);
    text("Adapt Temp: " + nf(temp, 1, 1), x + 160, y + 185);
    text("Head Size: " + nf(head, 1, 1), x + 160, y + 230);

    drawSimpleParent(x + 160, y + 315, hand, leg, head, temp);
  }

  void drawSimpleParent(float cx, float cy, float hand, float leg, float head, float temp) {
    float rr = map(temp, -10, 40, 80, 255);
    float bb = map(temp, -10, 40, 255, 80);

    stroke(40);
    strokeWeight(3);
    fill(rr, 130, bb);
    ellipse(cx, cy - 60, head, head);
    line(cx, cy - 25, cx, cy + 40);
    line(cx, cy, cx - hand * 0.45, cy + 10);
    line(cx, cy, cx + hand * 0.45, cy + 10);
    line(cx, cy + 40, cx - leg * 0.28, cy + 40 + leg * 0.55);
    line(cx, cy + 40, cx + leg * 0.28, cy + 40 + leg * 0.55);
  }

  // Continue if click the bottom
  boolean checkGenerateClick() {
    return uiManager.isMouseInRect(btnX, btnY, btnW, btnH);
  }
}
