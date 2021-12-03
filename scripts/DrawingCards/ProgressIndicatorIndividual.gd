extends Control

onready var accentborder: StyleBoxFlat = load("res://resources/styleboxes/Color10-det8-bordw6-cornrad5.tres")
onready var complimentaryborder: StyleBoxFlat = load ("res://resources/styleboxes/Color30-det8-bordw0-cornrad5.tres")

var spread_state_set_to = int()
var cards_info_storage : Array

var screensize : float #Vector2
var card_size_to_screen_size_ratio : float = 0.07
var card_y_to_x_ratio : float = 1.5
var card_size_x : float
var card_size_y : float
var card_spacing : float
var card_in_focus : int = 0

var indicator_spots : Array = []

signal is_spread_full
signal navigation_UI_update(buttonsvisible)


func _ready():
	prepare_indicators()

func prepare_indicators():
	screensize = 1080 #OS.get_screen_size() 
	var screen_center : float = screensize / 2
	card_size_x = screensize * card_size_to_screen_size_ratio
	card_size_y = card_size_x * card_y_to_x_ratio
	card_spacing = card_size_x / 2
	$cards/Panel.rect_size.x = card_size_x
	$cards/Panel.rect_size.y = card_size_y
	for i in (global.total_cards_in_scene - 1):
		var copy : Panel = $cards/Panel.duplicate()
		$cards.add_child(copy)
		copy.set('custom_styles/panel', complimentaryborder)
	for i in $cards.get_child_count():
		var center_offset = (i - (($cards.get_child_count() - 0.5)/2))
		$cards.get_child(i).rect_position.x = screen_center + (center_offset * (card_size_x + card_spacing))
		$cards.get_child(i).rect_position.y = 50
		indicator_spots.append(0)
	
func _card_progress(progress):
	if progress == 0:
		#This spot is for when the scene loads, so I just need to confirm that I need
		#this or don't need this to do something at runtime. Might not need it.
		#If progress is 0, the scene has begun, and I just need to indicate which
		#card the user is looking at.
		indicator_spots[0] = 1
	elif progress == 1:
		var last_focus = indicator_spots.find(1)
		indicator_spots[last_focus + 1] = 1
		indicator_spots[last_focus] = 0
	elif progress == -1:
		var last_focus = indicator_spots.find(1)
		indicator_spots[last_focus - 1] = 1
		indicator_spots[last_focus] = 0
	_update_panels()

func _update_panels():
	if indicator_spots.size() == $cards.get_child_count():
		for i in indicator_spots.size():
			if indicator_spots[i] == 0:
				$cards.get_child(i).set('custom_styles/panel', complimentaryborder)
			elif indicator_spots[i] == 1:
				$cards.get_child(i).set('custom_styles/panel', accentborder)
	else:
		print("array and panels count not equal")
	
func move_indicator():
	pass
