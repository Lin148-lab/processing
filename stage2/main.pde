/**
 * filename: main.pde
 * Module: Main Program Entry and State Machine
 * Function: Manage global game status, module instances, 
 cross-generation data transmission and state switching logic
 */
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

final int STAGE_START = 0;
final int STAGE_PARENTS = 1;
final int STAGE_OFFSPRING = 2;
final int STAGE_ENV_SELECT = 3;
final int STAGE_COMPETE = 4;
final int STAGE_END = 5;
final int STAGE_GEN_RESULT = 6;

int gameState = STAGE_START;// Current game status
int currentGeneration = 1;

// Global module instance
UIManager uiManager;
ParentGenerator parentGenerator;
EvolutionEngine evolutionEngine;
EnvironmentManager environmentManager;
SimulationCore simulationCore;
ArrayList<Creature> lastSurvivors;

// Cross-module data sharing
ParentData sharedParentData;
FinalStats finalStats;

/**
 * Initialization: 
 Create all module instances and set the canvas size
 */
void setup() {
  size(1200, 800);
  smooth();

  uiManager = new UIManager();
  uiManager.init();

  parentGenerator = new ParentGenerator();
  evolutionEngine = new EvolutionEngine();
  environmentManager = new EnvironmentManager();
  simulationCore = new SimulationCore();

  finalStats = new FinalStats();
}

/**
 * Per-frame rendering: 
 Call the corresponding display method based on the current game state
 */
void draw() {
  background(255);

  switch(gameState) {
  case STAGE_START:
    uiManager.drawStartScreen();
    break;

  case STAGE_PARENTS:
    parentGenerator.displayPage();
    uiManager.drawCommonUI();
    break;

  case STAGE_OFFSPRING:
    evolutionEngine.displayOffspringPage();
    uiManager.drawCommonUI();
    break;

  case STAGE_ENV_SELECT:
    environmentManager.displayEnvSelection();
    uiManager.drawCommonUI();
    break;

  case STAGE_COMPETE:
    runCompetitionStage();
    uiManager.drawCommonUI();
    uiManager.drawStopButton();
    break;

  case STAGE_END:
    uiManager.drawEndScreen(finalStats);
    break;

  case STAGE_GEN_RESULT:
    uiManager.drawGenResultScreen(finalStats, currentGeneration);
    uiManager.drawCommonUI();
    break;
  }
}

/**
 * Frame logic in the competition stage
 * Responsible for: drawing environmental background, initializing simulation, 
 running simulation and automatic termination detection
 * Automatic termination condition: When the number of survivors ≤ 4, 
 select the top 2 as parents and enter the generation result page
 */
void runCompetitionStage() {
  environmentManager.drawBackground();

  if (!simulationCore.initialized) {
    simulationCore.prepareSimulation(evolutionEngine.offspringList);
  }

  simulationCore.runSimulation(environmentManager.currentEnvTemp, environmentManager.foodList);

  if (simulationCore.isSimulationOver()) {
    ArrayList<Creature> survivors = simulationCore.getCurrentSurvivors();

    Collections.sort(survivors, new Comparator<Creature>() {
      public int compare(Creature a, Creature b) {
        float scoreA = a.getStrengthScore();
        float scoreB = b.getStrengthScore();
        if (scoreA > scoreB) return -1;
        else if (scoreA < scoreB) return 1;
        else return 0;
      }
    }
    );

    if (survivors.size() >= 2) {
      ParentData pd = new ParentData();
      Creature pA = survivors.get(0);
      Creature pB = survivors.get(1);
      pd.pA_hand = pA.hand;
      pd.pA_leg = pA.leg;
      pd.pA_temp = pA.temp;
      pd.pA_head = pA.head;
      pd.pB_hand = pB.hand;
      pd.pB_leg = pB.leg;
      pd.pB_temp = pB.temp;
      pd.pB_head = pB.head;
      sharedParentData = pd;
    } else {
      println("Warning: Not enough survivors, using last parents.");
    }

    finalStats = simulationCore.getFinalStats();
    gameState = STAGE_GEN_RESULT;
  }
}

/**
 * Mouse click processing: 
 Respond to user interactions based on the current game state
 */
void mousePressed() {
  switch(gameState) {
  case STAGE_START:
    if (uiManager.isStartClicked()) {
      parentGenerator.generateParents();
      sharedParentData = parentGenerator.parentData;
      gameState = STAGE_PARENTS;
    }
    break;

  case STAGE_PARENTS:
    if (parentGenerator.checkGenerateClick()) {
      evolutionEngine.generateOffspring(sharedParentData);
      gameState = STAGE_OFFSPRING;
    }
    break;

  case STAGE_OFFSPRING:
    if (evolutionEngine.checkGenerateEnvClick()) {
      if (environmentManager.environmentLocked) {
        simulationCore.reset();
        simulationCore.prepareSimulation(evolutionEngine.offspringList);
        gameState = STAGE_COMPETE;
      } else {
        gameState = STAGE_ENV_SELECT;
      }
    }
    break;

  case STAGE_ENV_SELECT:
    if (environmentManager.checkColdClick()) {
      environmentManager.selectEnvironment(0);
      simulationCore.reset();
      gameState = STAGE_COMPETE;
    } else if (environmentManager.checkNormalClick()) {
      environmentManager.selectEnvironment(1);
      simulationCore.reset();
      gameState = STAGE_COMPETE;
    } else if (environmentManager.checkHotClick()) {
      environmentManager.selectEnvironment(2);
      simulationCore.reset();
      gameState = STAGE_COMPETE;
    }
    break;

  case STAGE_COMPETE:
    if (simulationCore.checkStopClick()) {
      ArrayList<Creature> survivors = simulationCore.forceStopAndGetSurvivors();
      if (survivors.size() >= 2) {
        ParentData pd = new ParentData();
        Creature pA = survivors.get(0);
        Creature pB = survivors.get(1);
        pd.pA_hand = pA.hand;
        pd.pA_leg = pA.leg;
        pd.pA_temp = pA.temp;
        pd.pA_head = pA.head;
        pd.pB_hand = pB.hand;
        pd.pB_leg = pB.leg;
        pd.pB_temp = pB.temp;
        pd.pB_head = pB.head;
        sharedParentData = pd;
      } else {
        finalStats = simulationCore.getFinalStats();
        gameState = STAGE_END;
        break;
      }
      finalStats = simulationCore.getFinalStats();
      gameState = STAGE_GEN_RESULT;
    }
    break;

  case STAGE_END:
    if (uiManager.isRestartClicked()) {
      resetGame();
    }
    break;

  case STAGE_GEN_RESULT:
    if (uiManager.isNextGenClicked()) {
      if (sharedParentData != null) {
        evolutionEngine.generateOffspring(sharedParentData);
        currentGeneration++;
        simulationCore.reset();
        environmentManager.resetFoods();
        gameState = STAGE_OFFSPRING;
      } else {
        println("No parent data available!");
      }
    } else if (uiManager.isEndFromGenResultClicked()) {  
      gameState = STAGE_END;
    }
    break;
  }
}

/**
 * Reset the entire game
 * Reinstantiate all modules, reset all values to zero, 
 and revert the status to the initial state
 */
void resetGame() {
  parentGenerator = new ParentGenerator();
  evolutionEngine = new EvolutionEngine();
  environmentManager = new EnvironmentManager();
  simulationCore = new SimulationCore();
  finalStats = new FinalStats();
  sharedParentData = null;
  gameState = STAGE_START;
  currentGeneration = 1;
}
