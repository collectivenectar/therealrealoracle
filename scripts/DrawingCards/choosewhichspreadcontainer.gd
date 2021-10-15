extends Control



signal spread_chosen(custom_or_stock_spread, position_in_storage, total_cards, spread_name)
var parent_node
onready var click_down_position : Vector2
onready var click_up_position : Vector2
onready var dragging : bool

func _ready():
	pass
				#emit_signal("spread_chosen", get_meta("custom or stock"), get_meta("layout_state"), get_meta("total_cards"), get_meta("spread_name"))


func store_parent_node(node):
	parent_node = node

func _on_spreadname_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			click_down_position = event.global_position
		elif event.button_index == BUTTON_LEFT and !event.pressed:
			click_up_position = event.global_position
			if abs(click_up_position.x - click_down_position.x) < 50:
				if abs(click_up_position.y - click_down_position.y) < 50:
					dragging = false
					emit_signal("spread_chosen", get_meta("custom or stock"), get_meta("layout_state"), get_meta("total_cards"), get_meta("spread_name"))
				elif abs(click_up_position.y - click_down_position.y) > 50:
					dragging = true
			elif abs(click_up_position.x - click_down_position.x) > 50:
					dragging = true
			else:
				print("choose spread container input test failed")
