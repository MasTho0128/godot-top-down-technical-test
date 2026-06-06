# Godot Top-Down 2D — Technical Exercise

## Overview

This project was developed as a technical exercise in Godot 4 focused on creating a top-down 2D gameplay experience. The main objective was to build a clear, functional, and maintainable gameplay foundation that demonstrates proficiency with the engine, project organization, separation of responsibilities, reusable systems, and gameplay architecture.

The implementation is centered around three core pillars:

* A controllable player character driven by a custom finite state machine (FSM).
* A warrior enemy featuring patrol, detection, chase, and attack behaviors.
* A modular combat system built with reusable and decoupled components.

Additionally, the project includes audiovisual feedback systems designed to improve gameplay readability and responsiveness.

---

## Implemented Features

### Player

* Four-directional movement using keyboard input.
* Custom finite state machine with the following states:

  * `Idle`
  * `Walk`
  * `Attack`
  * `Hurt`
  * `Dead`
* Health system integrated with a UI life bar.
* Visual damage feedback using a shader-based hit flash effect.
* Health recovery through collectible healing items.
* Death flow integrated with game-over UI handling.

### Warrior Enemy

* Patrol behavior using configurable waypoint routes.
* Player detection through dedicated detection areas.
* Dynamic chase and attack behavior based on target distance.
* Modular AI structure composed of patrol and combat components.
* Randomized starting health between 1 and 2 points.
* Enemy life bar adapted from the shared health UI logic.
* Reuse of a single locomotion animation for both walking and running by varying playback speed:

  * Walk: 12 FPS
  * Run: 24 FPS

This approach reinforces the perception of acceleration while avoiding duplicated animation resources.

### Combat System

The combat system is built around reusable components:

* `HealthComponent`

  * Manages health values.
  * Emits signals for damage, healing, health changes, and death.

* `HitboxComponent`

  * Responsible for dealing damage.

* `HurtboxComponent`

  * Responsible for receiving damage and reacting to hitboxes.

* `CombatComponent`

  * Handles enemy detection, chasing, attack logic, and combat interactions.

* `PatrolComponent`

  * Manages waypoint navigation and patrol routes.

### Enemy AI

The warrior enemy combines a Behavior Tree implemented through LimboAI with component-based gameplay systems.

This separation allows high-level decision making to remain independent from concrete gameplay responsibilities such as patrol movement and combat execution.

The project intentionally demonstrates two complementary behavior architectures:

* A custom FSM for the player.
* A hybrid enemy architecture based on Behavior Trees and modular gameplay components.

### Audiovisual Feedback

* Camera shake when receiving damage.
* Shader-based damage flash effect.
* Positional audio for environmental and combat sounds.
* Sound pitch randomization for increased audio variety.
* Death transition flow before displaying the game-over interface.

### World and Environment

* Navigable level built using `TileMapLayers`.
* Environment elements instanced as independent scenes for easier reuse and placement.
* Configurable patrol zones adapted to level design requirements.

---

## How to Open and Run

### Requirements

* Godot `4.6.2`
* `LimboAI` addon

### Setup

1. Open Godot.
2. Import the project folder or open `project.godot`.
3. Run the main scene configured in the project.

### Quick Test

Once the game starts:

* Move the player around the level.
* Engage the warrior enemy.
* Test combat interactions.
* Collect healing items.
* Observe enemy patrol, detection, chase, and attack behavior.
* Verify health UI updates and audiovisual feedback systems.

---

## Controls

| Action        | Input                            |
| ------------- | -------------------------------- |
| Movement      | `W`, `A`, `S`, `D` or Arrow Keys |
| Attack        | `E`                              |
| Pick Up Items | Direct Contact                   |

---

## Addons and Dependencies

### LimboAI

Used for the warrior enemy Behavior Tree implementation and integrated AI resources.

### Assets

* Tiny Swords by Pixel Frog was used as the primary source of character and environment art assets.

---

## Design and Architecture Decisions

### Base `Actor` Class

A shared `Actor` base class centralizes common functionality between playable and non-playable entities.

This provides a consistent foundation for:

* Health management access.
* Combat-related node references.
* Shared actor functionality.

The result is a cleaner hierarchy and easier extensibility for future actors.

### Reusable Gameplay Components

Combat-related functionality was designed as reusable components to decouple specific responsibilities:

* Health management
* Damage application
* Damage reception

This modular approach improves maintainability and enables easy reuse across multiple entity types.

### Patrol and Combat Separation

Enemy behavior is divided into:

* `PatrolComponent`
* `CombatComponent`

This separation isolates navigation logic from detection, chasing, and attacking behavior, allowing the main enemy actor to focus on coordination, state transitions, and animation control.

### Two Behavior Architecture Approaches

The project intentionally showcases two different behavior organization strategies:

#### Player

A custom node-based finite state machine.

#### Enemy

A modular architecture where:

* Patrol and combat are delegated to specialized components.
* High-level decision making is coordinated through a Behavior Tree and the warrior actor.

This demonstrates flexibility in selecting the most appropriate architecture for different gameplay entities.

### Centralized Global Events

A global `GameEvents` autoload is used to centralize shared game events such as:

* Player death.
* Camera shake requests.

This reduces direct dependencies between gameplay systems, UI elements, and camera logic.

### Gameplay Feedback

Special attention was given to gameplay feedback through:

* Shader-based hit reactions.
* Camera shake.
* Positional audio.
* Pitch variation.
* Death transitions.

These systems improve combat readability and provide stronger player feedback during interactions.


## Final Notes

This project was developed as a technical assessment focused on demonstrating gameplay programming practices in Godot 4, with particular emphasis on reusable systems, modular architecture, clear separation of responsibilities, and maintainable code structure.

The current implementation provides a solid gameplay foundation that can be expanded with additional content, enemies, mechanics, and AI behaviors while preserving the existing architecture.
