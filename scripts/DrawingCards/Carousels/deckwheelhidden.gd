extends Control

# NEEDS CODE:

# SEE _gui_input(event): for comments

# SEE carousel_dragged_pos() for work on card images
# SEE on_button_pressed() for when card is added to the spread.
# needs to allow option to unselect before moving onwards to make
# the experience better. There is already a click check built in,
# i just need to connect the carousel movement to the ui

#


const card_width : int = 500
const card_h_separation : int = 100

onready var click_down_position : Vector2
onready var click_up_position : Vector2
onready var dragging : bool
onready var pressed : bool = false
onready var card: PackedScene = preload("res://scenes/card.tscn")

var card_zone : int = card_width + card_h_separation
var window_position : float = 0
var window_end_position : float = 0
var carousel_inertia_initial : float = 0
var animation_state : String = "inactive"

signal card_chosen(progress)
signal front_or_back(visible_face)

func _ready():
	global.draw()
	#res://lovedeckpng/lovedeckpng/01realreal.png
	for i in 5:
		var card_instance : Node = card.instance()
		get_child(i).add_child(card_instance)
		card_instance.set_meta("card_number", (i - 1))
		connect("front_or_back", card_instance, "front_or_back_visible")
		emit_signal("front_or_back", "back")
	_carousel_dragged_pos(window_position)

func _process(delta):
	if animation_state == "inertia":
		window_position = lerp(window_position, window_end_position, 4.0*delta)
		_carousel_dragged_pos(window_position)
		print(animation_state)
		if window_position == window_end_position:
			animation_state = "inactive"
			print(animation_state)

func _gui_input(event):
#	if event is InputEventScreenDrag:
#		animation_state = "dragging"
#		window_position += event.relative.x
#		_carousel_dragged_pos(window_position)
#		carousel_inertia_initial = event.relative.x
#	if event is InputEventScreenTouch:
#		if not event.is_pressed():
#			window_end_position = stepify(window_position,card_zone) + stepify(carousel_inertia_initial*20.0*1.8939,card_zone)
#			animation_state = "inertia"
#		if event.is_pressed():
#			animation_state = "inactive"
#			carousel_inertia_initial = 0
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		if event.button_index == BUTTON_LEFT and event.pressed:
			print(animation_state)
			pressed = true
			click_down_position = event.global_position
			animation_state = "inactive"
			carousel_inertia_initial = 0
		elif event.button_index == BUTTON_LEFT and !event.pressed:
			click_up_position = event.global_position
			print(animation_state)
			pressed = false
			window_end_position = stepify(window_position,card_zone) + stepify(carousel_inertia_initial*20.0*1.8939,card_zone)
			animation_state = "inertia"
			if abs(click_up_position.x - click_down_position.x) < 50:
				if abs(click_up_position.y - click_down_position.y) < 50:
					pass
#NEEDS CODE
#		Here is where you want to add code for if the user selects a card 
#		by tapping. Here you would maybe check position of the click, to filter
#		out obvious non selecting behavior. Allows also a deselect, and
#		if at all possible the select animation looks good, and can move with
#		the card as you spin it, and stays where it should.
				elif abs(click_up_position.y - click_down_position.y) > 50:
					dragging = true
			elif abs(click_up_position.x - click_down_position.x) > 50:
					dragging = true
	if event is InputEventMouseMotion:
		if pressed == true:
			animation_state = "dragging"
			window_position += event.relative.x
			_carousel_dragged_pos(window_position)
			carousel_inertia_initial = event.relative.x
		elif pressed == false:
			pass

func _carousel_dragged_pos(window_position):
	var window_offset : float = fmod(window_position, card_zone)
	var parent_center : float = (rect_size.x / 2.0) - (card_width * 0.5) - (card_zone * 2)
	for i in 5: get_child(i).rect_position = Vector2(parent_center + (card_zone * (i)) + window_offset, 0)
	for i in 5:
		var card_array_position : float = fposmod(int(window_position / card_zone) - (i - 2), global.deck_copy_converted.size())
		if global.deck_copy_chosen_states[card_array_position] == "unavailable":
			get_child(i).get_child(0)._card_available(false, i - 1)
		elif global.deck_copy_chosen_states[card_array_position] == "available":
			get_child(i).get_child(0)._card_available(true, i - 1)
			

func _on_Button_pressed():
	for i in 5:
		if get_child(i).rect_position.x >= 270 and get_child(i).rect_position.x <= 310:
			var card_array_position : float = fposmod(int(window_position / card_zone) - (i - 2), global.deck_copy_converted.size())
			if global.deck_copy_chosen_states[card_array_position] == "available":
				global.carousel_choice.append(card_array_position)
				global.deck_copy_chosen_states[card_array_position] = "unavailable"
				emit_signal("card_chosen", 1)
				_carousel_dragged_pos(window_position)
