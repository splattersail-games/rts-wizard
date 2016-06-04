# Bitwizards

This document is not yet finalised.

The intention is to explicitly define the scope of the prototype

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->


- [Game](#game)
  - [Menu](#menu)
    - [Select a map](#select-a-map)
  - [Playing a game](#playing-a-game)
- [Gameplay spec](#gameplay-spec)
  - [The Player](#the-player)
    - [Health](#health)
    - [Movement speed](#movement-speed)
  - [Damage](#damage)
    - [Damage Types](#damage-types)
    - [Susceptibility and Wards](#susceptibility-and-wards)
  - [Status effects](#status-effects)
    - [Burning](#burning)
    - [Wet](#wet)
    - [Chilled](#chilled)
    - [Frozen](#frozen)
- [Controls](#controls)
- [Assets](#assets)
  - [Wizard Character](#wizard-character)
    - ["Basick" Blue](#basick-blue)
    - ["Basick" Red](#basick-red)
    - [Animation poses](#animation-poses)
    - [Healthbar](#healthbar)
    - [Player Name](#player-name)
    - [Current Spell overlay](#current-spell-overlay)
    - [Wards](#wards)
  - [Spells](#spells)
    - [Walls](#walls)
    - [Sprays](#sprays)
    - [Shield spells (E! and E)s](#shield-spells-e-and-es)
    - [Beams](#beams)
  - [HUD overlay](#hud-overlay)
    - [Minimap](#minimap)
    - [Elements](#elements)
      - [Default](#default)
      - [Currently Pressed](#currently-pressed)
      - [Cancels currently queued](#cancels-currently-queued)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Game
### Menu
#### Select a map
### Playing a game

## Gameplay spec
### The Player
The player has several important properties
#### Health
1500
#### Movement speed
60
### Damage
#### Damage Types
Damage types are super simple. Each element has its own damage type, and combinatorial elements like ice and steam, have their own damage type (whether or not any spell in the game deals that damage type)
#### Susceptibility and Wards
Damage in bitwizards is represented as integer values
When an entity takes damage:
- The damage value is multiplied by a susceptibility value between 0 and 1
- Susceptibility is 1 by default. Each element in a ward subtracts 0.5 susceptibility to that element

### Status effects
#### Burning
Fire DoT, to be declared in more detail
Cancelled by water or cold
#### Wet
More susceptible to lightning and cold, to be declared in more detail
cancelled by fire, cold transitions to a strong chill status
#### Chilled
Movement speed and cast times are slowed, to be declared in more detail
#### Frozen
Player is encased in ice and immune to all damage, except for the swiggity shatter
## Controls

## Assets
### Wizard Character
#### "Basick" Blue
![Basick 1](/resources/images/wizards/basick_blue.png)
#### "Basick" Red
![Basick 2](/resources/images/wizards/basick_red.png)
#### Animation poses
TODO!!!!
#### Healthbar
Handled dynamically in game
#### Player Name
Handled dynamically in game
#### Current Spell overlay
Handled dynamically in game
#### Wards
Coloured dynamically in game

![inner part of the ward](/resources/images/wards/inner_alpha.png)
![outer part of the ward](/resources/images/wards/outer_alpha.png)
### Spells
#### Walls
#### Sprays
#### Shield spells (E! and E)s
#### Beams
### HUD overlay
#### Minimap
#### Elements
These are the plain old element icons, they should inform the other icon types directly
Some things to consider:
- Each icon should be easily recognisable
- All eight icons should resolve to an aesthetically pleasing colour palette
- Icons should be relevant to the element being expressed
- The current icons are 45x44, this is only because the MWW icons were like that
  - Consider 48x48 or 64x64?

##### Default
![water](/resources/images/elements/water.png)
![life](/resources/images/elements/life.png)
![shield](/resources/images/elements/shield.png)
![cold](/resources/images/elements/cold.png)
![lightning](/resources/images/elements/lightning.png)
![death](/resources/images/elements/death.png)
![earth](/resources/images/elements/earth.png)
![fire](/resources/images/elements/fire.png)

##### Currently Pressed
These will show when the element is being pressed down

![water](/resources/images/elements/pressed/water.png)
![life](/resources/images/elements/pressed/life.png)
![shield](/resources/images/elements/pressed/shield.png)
![cold](/resources/images/elements/pressed/cold.png)
![lightning](/resources/images/elements/pressed/lightning.png)
![death](/resources/images/elements/pressed/death.png)
![earth](/resources/images/elements/pressed/earth.png)
![fire](/resources/images/elements/pressed/fire.png)

##### Cancels currently queued
These will show when the element will dequeue an element that is in the current spell

![water](/resources/images/elements/cancelling/water.png)
![life](/resources/images/elements/cancelling/life.png)
![shield](/resources/images/elements/cancelling/shield.png)
![cold](/resources/images/elements/cancelling/cold.png)
![lightning](/resources/images/elements/cancelling/lightning.png)
![death](/resources/images/elements/cancelling/death.png)
![earth](/resources/images/elements/cancelling/earth.png)
![fire](/resources/images/elements/cancelling/fire.png)