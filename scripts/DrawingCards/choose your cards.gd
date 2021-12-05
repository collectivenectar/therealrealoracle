extends Control


#onready var carousel_scene : PackedScene = preload("res://scenes/DrawingCards/Carousels/carouselhiddencards.tscn")
onready var carousel_scene : PackedScene = preload("res://scenes/DrawingCards/Carousels/CarouselFinite.tscn")
onready var layout_scene : PackedScene = preload("res://scenes/DrawingCards/ProgressIndicatorAccumulative.tscn")
onready var layout : Node = layout_scene.instance()
signal layout_update(progress)
signal layout_spread_state(state)

func _ready():
	_setup()

func _setup():
	var carousel : Node = carousel_scene.instance()
	$popupcontainer.visible = false
	$VBoxContainer.add_child(carousel)
	$VBoxContainer.move_child(carousel, 0)
	$VBoxContainer/CenterContainer.add_child(layout)
	yield(get_tree(), "idle_frame")
	carousel.connect("card_chosen", self, "_update_layout")
	connect("layout_spread_state", layout, "_set_card_layout")
	connect("layout_update", layout, "_card_progress")
	layout.connect("is_spread_full", self, "_if_spread_full")
	$currentchoiceUI/currentchoicevbox/spreadpositionlabel.bbcode_text = "[center]" + global.tarot_spread_info[global._layout_states.find(global.spread_state_set_to) - 1]['position titles'][global.current_card_in_spread] + "[/center]"
	
func _update_layout(progress):
	emit_signal("layout_update", progress)
	global.current_card_in_spread += progress
	var current_spread = global.tarot_spread_info[global.spread_state_set_to]['spread name']
	var spread_position = global.tarot_spread_info[global._layout_states.find(current_spread)]['position titles'][global.current_card_in_spread]
	$currentchoiceUI/currentchoicevbox/spreadpositionlabel.bbcode_text = "[center]" + spread_position + "[/center]"

func _if_spread_full():
	$popupcontainer.visible = true
	global.current_card_in_spread = 1
	
func _on_TextureButton_pressed():
	global.carousel_type_currently_is = 1
	get_tree().change_scene("res://scenes/DrawingCards/seeyourcards.tscn")
