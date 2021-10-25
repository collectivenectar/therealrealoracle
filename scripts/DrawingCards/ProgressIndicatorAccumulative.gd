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
	for i in global.total_cards_in_scene:
		var copy : Panel = $cards/Panel.duplicate()
		$cards.add_child(copy)
		copy.set('custom_styles/panel', accentborder)
	for i in $cards.get_child_count():
		var center_offset = (i - (($cards.get_child_count() - 0.5)/2))
		$cards.get_child(i).rect_position.x = screen_center + (center_offset * (card_size_x + card_spacing))
		$cards.get_child(i).rect_position.y = 50
		indicator_spots.append(0)
	
func _card_progress(progress):
	if progress <= 0:
		#This spot is for when the scene loads, so I just need to confirm that I need
		#this or don't need this to do something at runtime. Might not need it.
		#If progress is 0, the scene has begun, and I just need to indicate which
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
				$cards.get_child(i).set('custom_styles/panel', accentborder)
			elif indicator_spots[i] == 1:
				$cards.get_child(i).set('custom_styles/panel', complimentaryborder)
	else:
		print("array and panels count not equal")

	#maybe use get_index() here as I need to find a different way to manage the card in focus
	#I dont want to do it blindly like last time. Maybe have set_meta and get_meta?
	#this way when the card is in focus, I can set_meta as "in_focus" = "true," or
	#maybe I can just update an array of dictionaries, each has the node_index and 
	#whether or not the card is in focus
	#it seems to me though that searching through a dictionary would be harder than digging
	#through a group of nodes for a get_meta that's true?
	
	
	
	#determine if the cards are being selected by the user, or being shown to the user
		# if get_meta("pulling_cards") == "false":
	
	#Set the color or indicator to the correct cards
	
func move_indicator():
	pass
	
# THESE LINES ARE JUST TO REMEMBER HOW TO CALL THE CURRENT SPREAD INFO FROM STORAGE
# TO DISPLAY THE CORRECT NUMBER OF CARD INDICATORS FOR THE SCENE
#	if configuration == 5:
#		#check to see if this layout is being instanced into a scene where the user
#		#is pulling cards. If only displaying cards, then the only scene this could be is
#		#the choose a spread scene. For the choose a spread scene, populate the layout
#		#scene using some stock app data and possible user generated spreads data.
#		#this scene doesn't have to think about that though, because the data is 
#		#automatically stored in cards_info_storage by the parent scene as soon as
#		#the parent scene is _ready()
#		if get_meta("pulling_cards") == "false":
#			#for each card in cards_info_storage, set it's position according to the stored data
#			for cards in cards_info_storage:
#				get_child(cards_info_storage.find(cards) + 1).rect_position = Vector2(cards[2][0], cards[2][0])
#			#for each card already in the scene, turn off visibility for remaining cards if
#			#there are more cards present in the scene than indicated by the spread information
#			#i.e. if the spread only has 3 cards, there are already 10 in this scene,
#			#so turn off visibility for the 7 remaining cards.
#			for child in range(1, get_child_count()):
#				if child > cards_info_storage.size():
#					get_child(child).visible = false
#		#if this scene is being instanced into a see your cards.tscn, then it is handled differently.
#		elif get_meta("pulling_cards") == "true":
#			#search through the user generated spreads for the key provided by global.choose_which_spread_key
#			#once found, store spread info in cards_info_storage, and set positions and visibility according to
#			#user spread data
#			for keys in global.runtime_user_data.custom_spreads:
#				if keys == global.choose_which_spread_key:
#					cards_info_storage = keys
#					for cards in cards_info_storage:
#						get_child(cards_info_storage.find(cards) + 1).rect_position = Vector2(cards[2][0], cards[2][0])
#					for child in range(1, get_child_count()):
#						if child > cards_info_storage.size():
#							get_child(child).visible = false
