extends Control

onready var card : PackedScene = preload("res://scenes/Card.tscn")

var screen_size : Vector2 = Vector2(1080, 1920)
var card_screen_width_ratio : float = 0.7
var card_spacing_card_width_ratio : float = 0.1
var card_width_height_ratio : float = 0.625
var card_width : float
var card_height : float
var card_spacing : float
var card_zone : float

#input event handling variables for the carousel
var carousel_inertia_initial : float = 0
onready var click_down_position : Vector2
onready var click_up_position : Vector2
onready var dragging : bool
onready var pressed : bool = false

#carousel position and inertia related vars
var carousel_sections : int
var animation_end_position : float = 0
var animation_state : String = "inactive"
onready var carousel_position : float = 0.0
var last_card_in_carousel : int

#signal for when a user has clicked the 'add card' button for the middle card
#signal card_chosen(progress)

func _ready():
	_carousel_sizing_setup()
	_instance_cards()
	_scene_type_check()
	_carousel_card_position_manager(carousel_position)

func _carousel_sizing_setup():
	card_width = screen_size.x * card_screen_width_ratio
	card_height = card_width / card_width_height_ratio
	card_spacing = card_width * card_spacing_card_width_ratio
	card_zone = card_width + card_spacing
	self.rect_min_size = Vector2(screen_size.x, card_height)

func _instance_cards():
	for i in .get_child_count():
		var card_instance = card.instance()
		.get_child(i).add_child(card_instance)
		.get_child(i).rect_min_size = Vector2(card_width, card_height)
		card_instance._set_sizing(card_width_height_ratio, card_width)
		card_instance._front_or_back_visible(global.card_side_displayed)

func _scene_type_check():
	if global.carousel_types[global.carousel_type_currently_is] == "CHOOSING":
		global.draw()
		last_card_in_carousel = global.deck_copy_converted.size()
		#carousel position can't start at 0, since carousel is moved by swiping from
		#right to left, and decreases carousel_position from max carousel value to 0
		#for journal, might consider starting at midpoint, but will decide after completing
		#design
		carousel_position = last_card_in_carousel * card_zone - 1
	elif global.carousel_types[global.carousel_type_currently_is] == "REVEALING":
		last_card_in_carousel = global.total_cards_in_scene
		carousel_position = last_card_in_carousel * card_zone
	elif global.carousel_types[global.carousel_type_currently_is] == "JOURNAL":
		last_card_in_carousel = global.livedeck.size()
		carousel_position = last_card_in_carousel * card_zone

func _carousel_card_position_manager(global_carousel_position):
	#local_position normalizes the current carousel position from the global position to the
	#local relative value for movement taking place(it subtracts
	#all whole multiples of card_zone from global_carousel_position)
	var local_position : float = fmod(global_carousel_position, card_zone)
	#zero card position offsets the whole thing by taking midpoint of screen and offsetting by
	#approximately 2 card zone lengths plus adjustments. There are 5 cards in the scene, this is just setting it up
	#so the first card goes left of midscreen by a little less than half of the total visible cards,
	#(rect_size.x / 2.0) - (card_width * 0.5) is an important adjustment, so pay attention
	#it would place the card at the left edge of screen otherwise
	var zero_card_position : float = (rect_size.x / 2.0) - (card_width * 0.5) - (card_zone * 2)
	#for each card, place it according to window position then add a card length multiplier
	#according to its order out of 5 cards
	for i in 5:
		get_child(i).rect_position = Vector2(zero_card_position + (card_zone * (i)) + local_position, 0)
		#if the array position of that card reaches the bounds, make it invisible
		#otherwise make it visible
		if (int(global_carousel_position / card_zone) - (i - 2)) > last_card_in_carousel:
			get_child(i).visible = false
		elif (int(global_carousel_position / card_zone) - (i - 2)) < 0:
			get_child(i).visible = false
		else:
			get_child(i).visible = true
	#for each card, set its text according to the window_position, correlating to the
	#deck data array - in this case, an unshuffled reference-only copy of the deck.
	for i in 5:
		#calculate the cards virtual position in the livedeck array by the same logic as before
		var deck_array_position : float = fposmod(int(global_carousel_position / card_zone) - (i - 2), global.deck_copy_converted.size())
		#store each text string first
		var largetext : String = "[center]" + global.livedeck[deck_array_position]['description1'] + "[/center]"
		var smalltext : String = "[center]" + global.livedeck[deck_array_position]['description2'] + "[/center]"
		var cardnumber : String = global.livedeck[deck_array_position]['name']
		#pass each through using that card instances local method
		get_child(i).get_child(0)._set_text(largetext, smalltext, cardnumber)

func _process(delta):
	#only active when someone has dragged and released carousel with momentum
	#that exceeds minimum threshold
	if animation_state == "released":
		#linear interpolation moves the carousel from the released position to a precalculated
		#end position over time, and since the difference decreases over time, the apparent
		#speed decreases as well, 4.0*delta is the weight.
		carousel_position = lerp(carousel_position, animation_end_position, 4.0*delta)
		#takes new window_position and pushes through _carousel_dragged_pos()
		_carousel_card_position_manager(carousel_position)
		#if the window_position has reached the end position, kill process
		if abs(animation_end_position - carousel_position) < 0.001:
			animation_state = "inactive"

func _gui_input(event):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		#if just pressed mouse click
		if event.button_index == BUTTON_LEFT && event.pressed:
			#set pressed to true, record start position, and set carousel momentum to 0
			#in case carousel was in motion, and kill animation state if "inertia"
			pressed = true
			click_down_position = event.global_position
			animation_state = "inactive"
			carousel_inertia_initial = 0
			print("inactive")
		#otherwise if button just released
		elif event.button_index == BUTTON_LEFT && !event.pressed:
			#store that end position, set pressed to false, and begin inertia calculation
			#i.e. calculate the end position based on current position, speed, and card + separation
			#width
			#once the calculation is done, begin inertial state for animation to take off
			click_up_position = event.global_position
			pressed = false
			animation_end_position = stepify(carousel_position, card_zone) + stepify(carousel_inertia_initial*20.0*1.8939,card_zone)
			animation_end_position = clamp(animation_end_position, 0, (last_card_in_carousel * card_zone))
			animation_state = "released"
			print("released")
			#this is for filtering out insufficient momentum to create inertia
			#set to filter for x or y changes, because I'm considering putting in
			#an animation for the user dragging a card or selecting a card for addition
			#to the spread 
	#if the user is currently moving the mouse
	if event is InputEventMouseMotion:
		#if the user is moving the mouse AND pressing
		if pressed == true:
			#set the state to dragging, and add the events position change to window_position
			#pass that window_position to _carousel_dragged_pos(), and then be sure
			#to store the most recent event position change data for calculation
			#of inertia in case the user is about to release
			animation_state = "dragging"
			carousel_position += event.relative.x
			carousel_position = clamp(carousel_position, 0, (last_card_in_carousel * card_zone))
			_carousel_card_position_manager(carousel_position)
			carousel_inertia_initial = event.relative.x
			print("dragging")
		elif pressed == false:
			pass

##if the user hits the add card button, find out which card is currently in the middle
##get it's data, and set the availability array position value for that card to unavailable
#func _on_Button_pressed():
#	for i in 5:
#		if get_child(i).rect_position.x >= 270 and get_child(i).rect_position.x <= 310:
#			var card_array_position : float = fposmod(int(window_position / card_zone) - (i - 2), global.deck_copy_converted.size())
#			if global.deck_copy_chosen_states[card_array_position] == "available":
#				global.carousel_choice.append(card_array_position)
#				global.deck_copy_chosen_states[card_array_position] = "unavailable"
#				emit_signal("card_chosen", 1)
#				_carousel_dragged_pos(window_position)
#			else:
#				print("deck_copy_chosen_states array indicates that card is unavailable")
