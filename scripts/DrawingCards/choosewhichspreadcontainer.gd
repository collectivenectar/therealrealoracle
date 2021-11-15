extends Control



signal spread_chosen(position_in_storage, total_cards, spread_name)
var parent_node
onready var click_down_position : Vector2
onready var click_up_position : Vector2
onready var dragging : bool

func _ready():
	#This code is incomplete, remove .font_data() and rethink the logic. 
	#How do I call a property of "normal_font". Do I call the dynamic_font
	#property? Or am I already at that level to call a font property like 
	#get_string_size() or get_wordwrap_string_size()?
	pass

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
					emit_signal("spread_chosen", get_meta("layout_state"), get_meta("total_cards"), get_meta("spread_name"))
				elif abs(click_up_position.y - click_down_position.y) > 50:
					dragging = true
			elif abs(click_up_position.x - click_down_position.x) > 50:
					dragging = true
			else:
				print("choose spread container input test failed")
				
func _toggle_tail():
	#for the last container, I just need to get rid of the $panel to clean it up visually
	$vboxcontainer/CenterContainer/Panel.visible = false

func _set_card_number(card_number):
	var card_number_string : String = str(card_number)
	$MarginContainer/numberofcards.text = ":" + card_number_string
