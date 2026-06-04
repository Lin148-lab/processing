# processing
# Visualising Evolution using Processing

**Team ID:** T5  
**Mentor:** Chris Roadknight  

## Project Description

An interactive evolution simulator built with Processing. Users select an environment (cold/normal/hot) and observe how a population of 100 creatures evolves over generations. Each creature has four heritable traits: hand length, leg length, temperature preference, and head size. The simulation incorporates energy consumption, food competition (with height‑based access), and a multi‑generational cycle where the two fittest survivors become parents of the next generation.

The evolutionary speed is quantified by **competition frames** – the time (number of frames) needed to reduce the population from 100 to 4 survivors.

## Features

- Random parent generation with visual gene cards.
- Offspring generation via hybridisation + mutation (100 individuals).
- Three environment types: Cold (-10°C), Normal (20°C), Hot (40°C).
- Real‑time competition: movement, energy loss, food competition (high/low zones).
- Multi‑generational loop: top 2 survivors become next parents.
- Statistics dashboard: competition frames, average genes, survivor count per generation.

## Requirements

- [Processing 4.x](https://processing.org/download) (Java mode)
- No additional libraries are required.

## How to Run

1. Clone or download this repository.
2. Open the main file `main.pde` in Processing.
3. Press the **Run** button (triangle icon in the top‑left corner).
4. Follow the on‑screen buttons:

   - **START** → generate random parents.
   - **GENERATE OFFSPRING** → create 100 children.
   - **GENERATE ENVIRONMENT** (first generation only) → choose cold/normal/hot.
   - The competition runs automatically until ≤4 survivors remain.
   - **NEXT GENERATION** → continue evolution.
   - **END SIMULATION** → view final results.

- You can click **STOP** at any time during competition to force‑end the current generation.

## File Structure

| File               | Responsibility                              |
|--------------------|---------------------------------------------|
| `main.pde`         | State machine, global variables, reset      |
| `parent.pde`       | Parent data, random gene generation, display|
| `offspring.pde`    | Hybridisation + mutation, 100 offspring grid|
| `creature.pde`     | Creature class, movement, energy, drawing   |
| `environment.pde`  | Environment temperature, food (fixed grid)  |
| `competition.pde`  | Simulation core, energy update, food fights |
| `UI.pde`           | All UI components, buttons, particle effect |

## Evaluation Metrics

We measured evolution under the **Normal (20°C)** environment over 10 generations:

- **Competition frames** increased from 294 → 479 (+63%), showing improved survival.
- **Average temperature gene** rose from 1.06°C → 21.76°C, approaching ambient temperature (20°C).
- **Hand length** and **leg length** also increased, enhancing food access and mobility.

These results satisfy the instructor’s two indicators:  
(1) longer survival time for a fixed number of survivors, and (2) more survivors within a fixed time.


## References

- Processing Foundation. (2024). *Processing Reference*. https://processing.org/reference/

## Team Contributions

| Member | Role | Main files |
|--------|------|-------------|
| Leader | State machine, integration, reset | `main.pde` |
| A | Parent generation, gene display | `parent.pde` |
| B | Offspring generation, creature class | `offspring.pde`, `creature.pde` |
| C | Environment, food system | `environment.pde` |
| D | Competition simulation, energy, stats | `competition.pde` |
| E | UI, buttons, animations | `UI.pde` |

## License

This project is for educational purposes only.
