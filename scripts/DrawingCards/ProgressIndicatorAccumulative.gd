extends Control

onready var accentborder: StyleBoxFlat = load("res://resources/styleboxes/Color10-det8-bordw6-cornrad5.tres")
onready var complimentaryborder: StyleBoxFlat = load ("res://resources/styleboxes/Color30-det8-bordw0-cornrad5.tres")

var spread_state_set_to = int()
var cards_info_storage

var screensize : float #Vector2
var card_size_to_screen_size_ratio : float = 0.07
var card_y_to_x_ratio : float = 1.5
var card_size_x : float
var card_size_y : float
var card_spacing : float
var card_in_focus = 0

var indicator_spots : Array = []

signal is_spread_full


func _ready():
	prepare_indicators()
	

func prepare_indicators():
	screensize = 1080 #OS.get_screen_size() 
	var screen_center : float = screensize / 2
	card_size_x = screensize * card_size_to_screen_size_ratio
	card_size_y = card_size_x * card_y_to_x_ratio
	card_spacing = card_size_x
	$cards/Panel.rect_size.x = card_size_x
	$cards/Panel.rect_size.y = card_size_y
	for i in (global.total_cards_in_scene - 1):
		var copy : Panel = $cards/Panel.duplicate()
		$cards.add_child(copy)
		copy.set('custom_styles/panel', complimentaryborder)
	for i in $cards.get_child_count():
		var center_offset = (i - (($cards.get_child_count() - 0.5) / 2))
		$cards.get_child(i).rect_position.x = screen_center + (center_offset * (card_size_x + card_spacing))
		$cards.get_child(i).rect_position.y = 50
		indicator_spots.append(0)
	
func _card_progress(progress):
	if progress <= 0:
		#This spot is for when the scene loads, so I just need to confirm that I need
		#to use this to indicate that a card has not been chosen yet. Maybe an animation
		#to blink the spread slot that you are choosing for?
		if progress == -1:
			pass
			#this is for when undoing a card choice - hasn't been built but is needed
		else:
			pass
	else:
		if indicator_spots.has(1) == true:
			if indicator_spots.count(0) == 0:
				pass
				#emit signal to change scene to popup window for transition to next scene
			else:
				indicator_spots[indicator_spots.find_last(1) + 1] = 1
				if indicator_spots.count(0) == 0 :
					emit_signal("is_spread_full")
				else:
					pass
				#then emit signal to change indicator visibility
				#for individual indicators, I'll need to have 
				#indicator_spots[(indicator_spots.find_last(1) - 1)] = 0
				#to de-indicate the previous card. Would need logic for if progress <= 0:
			#search for the 1, find the index, change the element after that index to a 1,
			#and if necessary change the first '1' to a 0.
		else:
			indicator_spots[0] = 1
			#then emit signal to $cards.get_child(0) to change visuals
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
	
func undo_progress():
	#put code here for when reversing a card choice
	#_card_progress(-1)
	pass
