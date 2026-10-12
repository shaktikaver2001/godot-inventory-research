extends SceneTree

func _init() -> void:
	var state = preload("res://state.gd").new()
	state.craft()
	assert(state.swords == 0 and state.wood == 0)
	state.toggle_equipment()
	assert(state.attack_power() == 5)
	for i in range(3):
		state.collect("wood")
	for i in range(2):
		state.collect("iron")
	state.craft()
	assert(state.swords == 1 and state.wood == 0 and state.iron == 0)
	state.toggle_equipment()
	assert(state.attack_power() == 10)
	state.toggle_equipment()
	assert(state.attack_power() == 5)
	for i in range(7):
		state.damage()
	assert(state.health == 0)
	state.heal()
	state.heal()
	assert(state.health == 30)
	for i in range(4):
		state.tick(3.0)
		state.heal()
	assert(state.health == 100)
	print("PASS: recipe validation, material spending, equipment, health bounds, cooldown")
	quit()
