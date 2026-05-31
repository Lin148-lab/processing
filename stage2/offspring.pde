/**
 * 组员B：EvolutionEngine.pde
 * 类名：EvolutionEngine
 * 核心任务：
 * 1. generateOffspring
 * 2. offspringList 存储100个子代
 * 3. displayOffspringPage 展示子代预览
 */
class EvolutionEngine {
  public ArrayList<Creature> offspringList;                                 //Store offspring data

  float btnX = 430;                                                         // Generate environment button position and size parameters
  float btnY = 680;
  float btnW = 340;
  float btnH = 65;

  EvolutionEngine() {
    offspringList = new ArrayList<Creature>();                             //Initialize the offspring storage list
  }

  // 【组员B】生成100个子代
  void generateOffspring(ParentData p) {
    offspringList.clear();                                                //clear data

    for (int i = 0; i < 100; i++) {                                       // Create 100 offspring in a loop
      float hand = inheritGene(p.pA_hand, p.pB_hand, 10);                 // Gene inheritance and hybridization mutation of hands, legs, body temperature, and head
      float leg  = inheritGene(p.pA_leg, p.pB_leg, 10);
      float temp = inheritGene(p.pA_temp, p.pB_temp, 6);
      float head = inheritGene(p.pA_head, p.pB_head, 8);

      hand = constrain(hand, 20, 160);                                    // Limit the range of gene values to avoid abnormalities in body size and temperature parameters
      leg  = constrain(leg, 20, 160);
      temp = constrain(temp, -20, 50);
      head = constrain(head, 15, 100);

      offspringList.add(new Creature(hand, leg, temp, head));             // Add the new individual to the offspring list
    }
  }

  // 【组员B】杂交+突变公式
  float inheritGene(float a, float b, float mutationRange) {
    float mixed = lerp(a, b, random(1));                                 // Random proportion linear fusion hybridization of parental genes
    if (random(1) < 0.15) {                                              // 15% probability of triggering gene mutation
      mixed += random(-mutationRange, mutationRange);
    }
    return mixed;
  }

  // 【组员B】子代预览页面
  void displayOffspringPage() {
    uiManager.drawBackgroundBase();                                      //draw background
    uiManager.drawTitleText("100 OFFSPRING GENERATED", 65);              //draw title

    fill(30);
    textAlign(CENTER, CENTER);
    textSize(18);
    text("Each circle represents one offspring preview", width / 2, 105);

    int cols = 10;                                                      // Child grid layout parameter: 10-column layout
    float startX = 115;
    float startY = 150;
    float gapX = 97;
    float gapY = 47;

    for (int i = 0; i < offspringList.size(); i++) {                   // Traverse all descendants and draw mini-entity previews according to their grid positions
      Creature c = offspringList.get(i);
      int col = i % cols;
      int row = i / cols;
      float x = startX + col * gapX;
      float y = startY + row * gapY;
      c.drawMini(x, y);
    }

    uiManager.drawButton(btnX, btnY, btnW, btnH, "GENERATE ENVIRONMENT");   // Draw the "Generate Environment" function button 
  }

  boolean checkGenerateEnvClick() {                                       // Check if the mouse has clicked the "Generate Environment" button
    return uiManager.isMouseInRect(btnX, btnY, btnW, btnH);
  }
}
