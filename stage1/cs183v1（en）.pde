//Liu Shutong
//832003117
ArrayList<Creature> population;
int globalIdCounter = 1; 
int maxGenerationAlive = 1; 

// 用于鼠标点击繁殖的选中状态
Creature parent1 = null;
Creature parent2 = null;

void setup() {
  size(800, 600);
  colorMode(HSB, 255, 255, 255); // 使用 HSB 色彩模式方便根据基因映射颜色
  
  population = new ArrayList<Creature>();
  
  // 初始化第一代生物 (生成10个作为初始种群)
  for (int i = 0; i < 10; i++) {
    DNA initialDNA = new DNA(); // 随机基因
    population.add(new Creature(initialDNA, random(width), random(height), globalIdCounter, 1));
    globalIdCounter++;
  }
}

void draw() {
  background(245); // 浅灰色背景
  
  // ================= UI 提示信息 =================
  fill(0);
  textSize(16);
  textAlign(LEFT);
  text("最高代数 (Max Gen): " + maxGenerationAlive, 20, 30);
  text("当前种群数量: " + population.size(), 20, 50);
  text("操作: 点击两个不同的生物进行繁殖", 20, 70);
  
  // 显示当前选中的父母
  if (parent1 != null) text("已选父本1: ID " + parent1.id, 20, 90);
  if (parent2 != null) text("已选父本2: ID " + parent2.id, 20, 110);

  // ================= 更新与绘制生物 =================
  for (Creature c : population) {
    c.update();
    c.checkEdges();
    
    // 如果该生物被选中，画一个加粗的黑色虚线光圈高亮显示
    if (c == parent1 || c == parent2) {
      noFill();
      stroke(0);
      strokeWeight(2);
      ellipse(c.pos.x, c.pos.y, c.size * 2.5, c.size * 2.5);
    }
    
    c.display();
  }
}

// 鼠标点击事件：处理选择和繁殖
void mousePressed() {
  Creature clickedCreature = null;
  
  // 检查哪个生物被点击了（从后往前遍历，优先选中上层的）
  for (int i = population.size() - 1; i >= 0; i--) {
    Creature c = population.get(i);
    // 判断鼠标是否在生物的判定范围内（以火柴人为中心）
    if (dist(mouseX, mouseY, c.pos.x, c.pos.y) < c.size) {
      clickedCreature = c;
      break;
    }
  }
  
  if (clickedCreature != null) {
    if (parent1 == null) {
      parent1 = clickedCreature;
    } else if (parent1 != clickedCreature && parent2 == null) {
      parent2 = clickedCreature;
      
      // 两个父本都选好了，触发繁殖！
      reproduce(parent1, parent2);
      
      // 繁殖后清空选择，准备下一次点击
      parent1 = null;
      parent2 = null;
    }
  } else {
    // 点击空白处取消选择
    parent1 = null;
    parent2 = null;
  }
}

// 繁殖函数
void reproduce(Creature p1, Creature p2) {
  // 1. 基因交叉与突变 (5% 突变率)
  DNA childDNA = p1.dna.crossover(p2.dna);
  childDNA.mutate(0.05); 
  
  // 2. 确定子代的代数
  int childGen = max(p1.generation, p2.generation) + 1;
  if (childGen > maxGenerationAlive) {
    maxGenerationAlive = childGen;
  }
  
  // 3. 生成子代（位置在两代父母的中间）
  float childX = (p1.pos.x + p2.pos.x) / 2;
  float childY = (p1.pos.y + p2.pos.y) / 2;
  Creature child = new Creature(childDNA, childX, childY, globalIdCounter, childGen);
  globalIdCounter++;
  
  population.add(child);
  
  // 4. 执行代数淘汰（如果出现了 N 代，N-3 代及以前的生物死亡）
  cullOldGenerations();
}

// 淘汰老一代生物
void cullOldGenerations() {
  // 必须倒序遍历 ArrayList 才能在循环中安全删除元素
  for (int i = population.size() - 1; i >= 0; i--) {
    Creature c = population.get(i);
    if (c.generation <= maxGenerationAlive - 3) {
      population.remove(i);
    }
  }
}

// ==========================================
// DNA 类 (16位二进制基因)
// ==========================================
class DNA {
  int[] genes = new int[16];
  
  DNA() {
    for (int i = 0; i < 16; i++) genes[i] = int(random(2));
  }
  
  DNA(int[] newgenes) {
    genes = newgenes;
  }
  
  DNA crossover(DNA partner) {
    int[] childGenes = new int[16];
    int midpoint = int(random(16)); // 随机单点交叉
    for (int i = 0; i < 16; i++) {
      if (i > midpoint) childGenes[i] = this.genes[i];
      else              childGenes[i] = partner.genes[i];
    }
    return new DNA(childGenes);
  }
  
  void mutate(float mutationRate) {
    for (int i = 0; i < 16; i++) {
      if (random(1) < mutationRate) genes[i] = 1 - genes[i]; // 位翻转
    }
  }
}

// ==========================================
// Creature 生物类
// ==========================================
class Creature {
  DNA dna;
  PVector pos, vel;
  int id, generation;
  
  // 表现型
  float size;    // 影响火柴人大小
  float speed;   // 影响移动速度
  float vision;  // 视野（背后的淡色圆圈）
  color col;     // 颜色
  
  Creature(DNA _dna, float x, float y, int _id, int _gen) {
    dna = _dna;
    pos = new PVector(x, y);
    id = _id;
    generation = _gen;
    
    decodeDNA();
    
    // 给一个随机的初始移动方向，并根据基因速度设定快慢
    vel = PVector.random2D();
    vel.mult(speed);
  }
  
  // 将16位二进制切片并映射为物理属性
  void decodeDNA() {
    // 0-3位: 大小 (映射到 15 到 40 像素)
    int sizeVal = binaryToDec(dna.genes, 0, 4);
    size = map(sizeVal, 0, 15, 15, 40);
    
    // 4-7位: 速度 (将最高速度从3.0大幅下调到1.0，现在移速非常缓慢)
    int speedVal = binaryToDec(dna.genes, 4, 4);
    speed = map(speedVal, 0, 15, 0.1, 1.0); 
    
    // 8-11位: 视野 (映射到 40 到 100 半径)
    int visionVal = binaryToDec(dna.genes, 8, 4);
    vision = map(visionVal, 0, 15, 40, 100);
    
    // 12-15位: 颜色 (映射 HSB 的色相 0-255)
    int colorVal = binaryToDec(dna.genes, 12, 4);
    col = color(map(colorVal, 0, 15, 0, 255), 200, 200);
  }
  
  int binaryToDec(int[] genes, int start, int len) {
    int val = 0;
    for (int i = 0; i < len; i++) {
      val = (val << 1) | genes[start + i];
    }
    return val;
  }
  
  void update() {
    pos.add(vel);
  }
  
  // 边缘反弹
  void checkEdges() {
    if (pos.x < 0 || pos.x > width) vel.x *= -1;
    if (pos.y < 0 || pos.y > height) vel.y *= -1;
  }
  
  // 绘制生物
  void display() {
    pushMatrix();
    translate(pos.x, pos.y);
    
    // 1. 画视野圈 (降低了透明度，使其显得更柔和，不会喧宾夺主)
    noStroke();
    fill(col, 30); // 透明度设为 30
    ellipse(0, 0, vision * 2, vision * 2);
    
    // 2. 画火柴人主体
    stroke(col);
    strokeWeight(size / 8); 
    
    // 头
    fill(255);
    float headSize = size * 0.4;
    ellipse(0, -size * 0.5, headSize, headSize);
    
    // 躯干
    line(0, -size * 0.5 + headSize/2, 0, size * 0.2);
    
    // 胳膊
    line(0, -size * 0.2, -size * 0.3, 0);
    line(0, -size * 0.2, size * 0.3, 0);
    
    // 腿
    line(0, size * 0.2, -size * 0.3, size * 0.6);
    line(0, size * 0.2, size * 0.3, size * 0.6);
    
    // 3. 绘制 ID 和 代数 标签
    fill(0);
    noStroke();
    textAlign(CENTER);
    textSize(12);
    text("ID:" + id + " G" + generation, 0, -size * 0.8);
    
    popMatrix();
  }
}
