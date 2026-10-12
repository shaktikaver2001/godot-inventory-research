# Forge & Field — Godot inventory lab

A small interactive Godot 4 / GDScript prototype for exploring HUDs, inventory, crafting, and equipment. Developed with AI assistance for the Horse_Plinko research milestone.

## Run

Download or clone the repository. In Godot 4.7, click Import, select `project.godot`, then press F5. No external assets, plugins, or package downloads are required. The original prototype's rules and startup were tested in Godot 4.6.2; the project configuration has since been upgraded to 4.7.

The local `Run Demo.cmd` and `Open Editor.cmd` shortcuts are specific to the development computer and are not needed to run the shared project.

## Try it

1. Click Craft sword before collecting anything: the recipe is rejected.
2. Collect wood three times and iron twice.
3. Craft a sword. Ingredients are consumed and the sword counter increases.
4. Equip it. Attack changes from 5 to 10. Unequip it to return to 5.
5. Filter the inventory between all items, materials, and weapons.
6. Take damage, then heal. Healing is capped at 100 and has a three-second cooldown.
7. Reset to restore the starting state.

## How it works

- `main.tscn` is the starting scene with a Control node.
- `main.gd` builds the screen from Godot containers, labels, buttons, a ProgressBar, and an OptionButton. A button's `pressed` signal calls a game rule, then refreshes the screen.
- `state.gd` holds material counts, health, cooldown, and equipment. `craft()` validates ingredients before spending them. `attack_power()` derives attack from equipment, preventing repeated equip clicks from stacking bonuses.
- `_process(delta)` counts down the cooldown using elapsed seconds rather than frame count.
- `test_state.gd` checks insufficient materials, ingredient consumption, equip/unequip, health bounds, and cooldown behavior.

This is a UI prototype, not the full team's game. It does not implement movement, drag-and-drop equipment, a world map, saving, or enemy combat. It explores parts of requirements 1.2, 1.6, and 2.3.

## Research and learning

Read the code, run the demo, and make a change you can explain. For example, add a shield recipe with its own defense stat, or introduce a third material. Keep genuine incremental commits as you work; do not invent earlier development history.

Useful official references:
- [Signals](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html)
- [Containers](https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html)
- [GDScript basics](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html)

## Submission still needed

Create a personal GitHub repository, add this project, and make multiple meaningful commits while learning and improving it. Record a short video showing your running demo. Then create `Research Milestone: shaktikaver2001` in the team repository with the personal repository URL and your video, assigning or mentioning the instructors.

## Suggested video outline

Use your own words and only claim work and understanding you actually have:

1. Introduce the prototype and disclose AI assistance.
2. Demonstrate a failed recipe, gathering, successful crafting, and equipping.
3. Show filtering, health limits, and the cooldown.
4. Open `state.gd` and explain the recipe condition and the derived attack stat.
5. Show a change you made and explain a tradeoff: UI generated in code is compact, but editor-built scenes would be easier to adjust visually.
