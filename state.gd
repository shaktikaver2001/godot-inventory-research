extends RefCounted
## Game rules are separate from the screen so they can be tested directly.
var wood: int = 0
var iron: int = 0
var swords: int = 0
var equipped: bool = false
var health: int = 100
var cooldown: float = 0.0

func collect(material: String) -> String:
	if material == "wood":
		wood += 1
	else:
		iron += 1
	return "Collected 1 " + material + "."

func craft() -> String:
	if wood < 3 or iron < 2:
		return "Not enough materials. A sword costs 3 wood and 2 iron."
	wood -= 3
	iron -= 2
	swords += 1
	return "Iron sword crafted! Equip it in your inventory."

func toggle_equipment() -> String:
	if swords == 0:
		return "Craft a sword first."
	equipped = not equipped
	return "Sword equipped. Attack is now 10." if equipped else "Sword removed. Attack is now 5."

func attack_power() -> int:
	return 10 if equipped else 5

func damage() -> String:
	health = maxi(0, health - 20)
	return "Training hit: -20 HP." if health > 0 else "Health is zero. Use Heal to recover."

func heal() -> String:
	if cooldown > 0:
		return "Heal is recharging."
	if health == 100:
		return "Already at full health."
	health = mini(100, health + 30)
	cooldown = 3.0
	return "Recovered 30 HP (maximum 100). Heal recharges in 3 seconds."

func tick(delta: float) -> void:
	cooldown = maxf(0, cooldown - delta)
