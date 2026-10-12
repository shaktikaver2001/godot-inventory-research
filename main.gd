extends Control
const GameState = preload("res://state.gd")
var game = GameState.new()
var hp: ProgressBar
var stats: Label
var inventory: Label
var message: Label
var heal_button: Button
var equip_button: Button
var quest: Label
var filter: OptionButton

func _ready() -> void:
	var theme_resource = Theme.new()
	theme_resource.default_font_size = 18
	theme = theme_resource
	var margin = MarginContainer.new()
	margin.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	for edge in ["left", "top", "right", "bottom"]:
		margin.add_theme_constant_override("margin_" + edge, 30)
	add_child(margin)
	var root = VBoxContainer.new()
	root.add_theme_constant_override("separation", 16)
	margin.add_child(root)
	label(root, "GODOT RESEARCH LAB  /  01", 15, Color("7bdcbb"))
	label(root, "Forge & Field", 38)
	label(root, "Gather materials. Craft your first sword. Make it yours.", 18, Color("aab9ce"))
	var hud = card(root)
	stats = label(hud, "", 22)
	hp = ProgressBar.new()
	hp.custom_minimum_size.y = 22
	hp.show_percentage = false
	hud.add_child(hp)
	var health_actions = HBoxContainer.new()
	hud.add_child(health_actions)
	button(health_actions, "Take damage  −20", func(): report(game.damage()))
	heal_button = button(health_actions, "Heal  +30", func(): report(game.heal()))
	button(health_actions, "Reset demo", reset)
	var columns = HBoxContainer.new()
	columns.add_theme_constant_override("separation", 16)
	root.add_child(columns)
	var gather = card(columns)
	label(gather, "01  GATHER", 16, Color("7bdcbb"))
	label(gather, "Field supplies", 25)
	label(gather, "Collect ingredients for the forge.", 16)
	button(gather, "Collect wood  +1", func(): report(game.collect("wood")))
	button(gather, "Collect iron  +1", func(): report(game.collect("iron")))
	var forge = card(columns)
	label(forge, "02  CRAFT", 16, Color("f0bc76"))
	label(forge, "Iron sword", 25)
	label(forge, "Recipe: 3 wood + 2 iron\nEquipment bonus: +5 attack", 16)
	button(forge, "Craft sword", func(): report(game.craft()))
	var bag = card(columns)
	label(bag, "03  EQUIP", 16, Color("a9baff"))
	label(bag, "Your inventory", 25)
	filter = OptionButton.new()
	for title in ["All items", "Materials", "Weapons"]:
		filter.add_item(title)
	filter.item_selected.connect(func(_index): refresh())
	bag.add_child(filter)
	inventory = label(bag, "", 18)
	inventory.custom_minimum_size.y = 92
	equip_button = button(bag, "Equip sword", func(): report(game.toggle_equipment()))
	quest = label(root, "", 18, Color("7bdcbb"))
	var feedback = card(root)
	label(feedback, "ACTIVITY", 14, Color("aab9ce"))
	message = label(feedback, "Welcome! Try crafting before collecting materials to test the recipe check.", 18)
	label(root, "Prototype scope: HUD • inventory filtering • crafting validation • equipment stats", 14, Color("aab9ce"))
	refresh()

func _process(delta: float) -> void:
	game.tick(delta)
	if heal_button:
		heal_button.text = "Heal  +30" if game.cooldown <= 0 else "Heal  %.1fs" % game.cooldown
		heal_button.disabled = game.cooldown > 0

func report(text: String) -> void:
	message.text = text
	refresh()

func reset() -> void:
	game = GameState.new()
	filter.select(0)
	report("Demo reset. Gather 3 wood and 2 iron to begin.")

func refresh() -> void:
	hp.value = game.health
	stats.text = "HEALTH  %d / 100                  ATTACK  %d                  %s" % [game.health, game.attack_power(), "IRON SWORD" if game.equipped else "UNARMED"]
	var rows: Array[String] = []
	if filter.selected != 2:
		rows.append("Wood     × %d\nIron        × %d" % [game.wood, game.iron])
	if filter.selected != 1:
		rows.append("Sword    × %d" % game.swords)
	inventory.text = "\n".join(rows)
	equip_button.text = "Unequip sword" if game.equipped else "Equip sword"
	quest.text = "OBJECTIVE COMPLETE  /  First sword equipped" if game.equipped else "OBJECTIVE  /  Gather → craft → equip your first sword"

func label(parent: Node, text: String, font_size: int = 18, color: Color = Color("edf2fa")) -> Label:
	var item = Label.new()
	item.text = text
	item.add_theme_font_size_override("font_size", font_size)
	item.add_theme_color_override("font_color", color)
	parent.add_child(item)
	return item

func button(parent: Node, text: String, action: Callable) -> Button:
	var item = Button.new()
	item.text = text
	item.custom_minimum_size = Vector2(0, 44)
	item.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	item.pressed.connect(action)
	parent.add_child(item)
	return item

func card(parent: Node) -> VBoxContainer:
	var panel = PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var style = StyleBoxFlat.new()
	style.bg_color = Color("172232")
	style.set_corner_radius_all(12)
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 16
	style.content_margin_bottom = 16
	panel.add_theme_stylebox_override("panel", style)
	parent.add_child(panel)
	var content = VBoxContainer.new()
	content.add_theme_constant_override("separation", 12)
	panel.add_child(content)
	return content
