extends Control

onready var card : PackedScene = preload("res://scenes/Card.tscn")

#dimensions for everything
var screen_size : Vector2 = Vector2(1080, 1920)
var card_screen_width_ratio : float = 0.7
var card_spacing_card_width_ratio : float = 0.1
var card_width_height_ratio : float = 0.625
var card_width : float
var card_height : float
var card_spacing : float
var card_zone : float
var zero_card_position : float

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
var scene_type : String

signal card_chosen

func _ready():
	_carousel_sizing_setup()
	_scene_type_check()
	_instance_cards()
	_carousel_card_position_manager(carousel_position)

func _carousel_sizing_setup():
	#set sizes according to a ratio between the OS.screen size and the card size
	card_width = screen_size.x * card_screen_width_ratio
	card_height = card_width / card_width_height_ratio
	card_spacing = card_width * card_spacing_card_width_ratio
	card_zone = card_width + card_spacing
	self.rect_min_size = Vector2(screen_size.x, card_height)

func _scene_type_check():
	#before setting the start position of the carousel, determine parameters of
	#the carousel scene - how many cards in the scene?
	scene_type = global.carousel_types[global.carousel_type_currently_is]
	print(scene_type)
	if scene_type == "CHOOSING":
		global.draw()
		last_card_in_carousel = global.deck_copy_converted.size() - 1
		#carousel position can't start at 0, since carousel is moved by swiping from
		#right to left, and decreases carousel_position from max carousel value to 0
		#for journal, might consider starting at midpoint, but will decide after completing
		#design
		carousel_position = (last_card_in_carousel * card_zone) - 1
		global.card_side_displayed = "back"
		return "CHOOSING"
	elif scene_type == "REVEALING":
		last_card_in_carousel = global.total_cards_in_scene - 1
		carousel_position = last_card_in_carousel * card_zone
		global.card_side_displayed = "front"
		return "REVEALING"
	elif scene_type == "JOURNAL":
		last_card_in_carousel = global.livedeck.size() - 1
		carousel_position = last_card_in_carousel * card_zone - 1
		global.card_side_displayed = "front"
		print("front")
		return "JOURNAL"

func _instance_cards():
	#bring the card.tscn packedscene in under each of the 5 card containers, and
	#set them up with proper size, front or back visible, etc.
	for i in 5:
		var card_instance = card.instance()
		.get_child(i).add_child(card_instance)
		.get_child(i).rect_min_size = Vector2(card_width, card_height)
		card_instance._set_sizing(card_width_height_ratio, card_width)
		card_instance._front_or_back_visible(global.card_side_displayed)
	$centerCardButton.rect_min_size = Vector2(card_width, card_width / card_width_height_ratio)
	$centerCardButton.rect_position = Vector2(rect_size.x / 2 - (card_width * 0.5), 0)


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
	zero_card_position = (rect_size.x / 2.0) - (card_width * 0.5) - (card_zone * 2)
	#for each card, place it according to window position then add a card length multiplier
	#according to its order out of 5 cards
	for i in 5:
		get_child(i).rect_position = Vector2(zero_card_position + (card_zone * (i)) + local_position, 0)
		#if the array position of that card reaches the bounds, make it invisible
		#otherwise make it visible
		if (int((global_carousel_position)/ card_zone) - (i - 2)) > last_card_in_carousel:
			get_child(i).visible = false
		elif (int(global_carousel_position / card_zone) - (i - 2)) < 0:
			get_child(i).visible = false
		else:
			get_child(i).visible = true
	#for each card, set its text according to the window_position, correlating to the
	#deck data array - in this case, an unshuffled reference-only copy of the deck.
	for i in 5:
		#store each text string first
		if scene_type == "CHOOSING":
			pass
		elif scene_type == "REVEALING":
			#calculate the cards virtual position in the livedeck array by the same logic as before
			var carousel_card_position : float = fposmod(int(global_carousel_position / card_zone) - (i - 2), global.deck_copy_converted.size())
			if carousel_card_position <= (global.total_cards_in_scene - 1):
				get_child(i).visible = true
				var card_info : Dictionary = global.livedeck[global.carousel_choice[carousel_card_position]]
				var largetext : String = "[center]" + card_info['description1'] + "[/center]"
				var smalltext : String = "[center]" + card_info['description2'] + "[/center]"
				var cardnumber : String = card_info['name']
				#pass each through using that card instances local method
				get_child(i).get_child(0)._set_text(largetext, smalltext, cardnumber)
		elif scene_type == "JOURNAL":
			#calculate the cards virtual position in the livedeck array by the same logic as before
			var carousel_card_position : float = fposmod(int(global_carousel_position / card_zone) - (i - 2), global.livedeck.size())
			var largetext : String = "[center]" + global.livedeck[carousel_card_position]['description1'] + "[/center]"
			var smalltext : String = "[center]" + global.livedeck[carousel_card_position]['description2'] + "[/center]"
			var cardnumber : String = global.livedeck[carousel_card_position]['name']
			#pass each through using that card instances local method
			get_child(i).get_child(0)._set_text(largetext, smalltext, cardnumber)

func _process(delta):
	#only active when someone has dragged and released carousel with momentum
	#that exceeds minimum threshold
	if animation_state == "released" && !pressed:
		#linear interpolation moves the carousel from the released position to a precalculated
		#end position over time, and since the difference decreases over time, the apparent
		#speed decreases as well, 4.0*delta is the weight.
		carousel_position = lerp(carousel_position, animation_end_position, 4.0*delta)
		#takes new window_position and pushes through _carousel_dragged_pos()
		_carousel_card_position_manager(carousel_position)
		#if the window_position has reached the end position, kill process
		if abs(animation_end_position - carousel_position) < 0.001:
			animation_state = "inactive"

func _on_cardContainer_gui_input(event):
	#moved this out of _gui_input(event) due to handling issues. This is for when
	#user has dragged or clicked, so this may produce issues when clicking up
	#in other scenes? have to see.
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		#if just pressed mouse click
		if event.button_index == BUTTON_LEFT && event.pressed:
			#set pressed to true, record start position, and set carousel momentum to 0
			#in case carousel was in motion, and kill animation state if "inertia"
			pressed = true
			animation_state = "inactive"
			carousel_inertia_initial = 0.0
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && !event.pressed:
			#store that end position, set pressed to false, and begin inertia calculation
			#i.e. calculate the end position based on current position, speed, and card + separation
			#width
			#once the calculation is done, begin inertial state for animation to take off
			pressed = false
			animation_end_position = stepify(carousel_position, card_zone) + stepify(carousel_inertia_initial * 20.0 * 1.8939, card_zone)
			animation_end_position = clamp(animation_end_position, 0, (last_card_in_carousel * card_zone - 1))
			animation_state = "released"
	if event is InputEventMouseMotion:
		#if the user is moving the mouse AND pressing
		if pressed == true:
			#set the state to dragging, and add the events position change to window_position
			#pass that window_position to _carousel_dragged_pos(), and then be sure
			#to store the most recent event position change data for calculation
			#of inertia in case the user is about to release
			carousel_inertia_initial = 0.0
			animation_state = "dragging"
			carousel_position += event.relative.x
			#minus one here might seem weird but without it the first card has visibility issues
			#related to last_card_in_carousel
			carousel_position = clamp(carousel_position, 0, (last_card_in_carousel * card_zone - 1))
			_carousel_card_position_manager(carousel_position)
			carousel_inertia_initial = event.relative.x
		elif pressed == false:
			pass

func _navigate_right_one():
	#api for parent scenes to navigate carousel by one card right
	animation_end_position = stepify(carousel_position, card_zone) - card_zone
	animation_end_position = clamp(animation_end_position, 0, (last_card_in_carousel * card_zone - 1))
	animation_state = "released"
	
func _navigate_left_one():
	#api for parent scenes to navigate carousel by one card left
	animation_end_position = stepify(carousel_position, card_zone) + card_zone
	animation_end_position = clamp(animation_end_position, 0, (last_card_in_carousel * card_zone - 1))
	animation_state = "released"

func _center_card_query():
	#api for requesting info about current centered card. Return -99.9 if not aligned,
	#return 99.9 if unavailable, return float value of relative position in the stack of cards
	#remember that this doesn't return the card info, but the position in the stack of cards.
	#depending on the scene, this will still need to be used along with the temp array
	#that's holding the scenes card information.
	var result: float
	var center_position = zero_card_position + (card_zone * 2) - 1
	for i in 5:
		if get_child(i).rect_position.x >= (center_position - 10) and get_child(i).rect_position.x <= (center_position + 10):
			var card_array_position : float = fposmod(int(carousel_position / card_zone) - (i - 2), global.deck_copy_converted.size())
			if global.deck_copy_chosen_states[card_array_position] == "available":
				result = card_array_position
				global.deck_copy_chosen_states[card_array_position] = "unavailable"
			elif global.deck_copy_chosen_states[card_array_position] == "unavailable":
				result = 99
			else:
				print("_center_card_query : card_array_position or chosen states problem")
	if result == null:
		result = -99
	return result
	

func _on_centerCardButton_gui_input(event):
	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
		if event.pressed:
			click_down_position = Vector2(0, 0)
			click_down_position = event.global_position
		elif !event.pressed:
			click_up_position = Vector2(0, 0)
			click_up_position = event.global_position
			if abs(click_up_position.x - click_down_position.x) < 50:
				if abs(click_up_position.y - click_down_position.y) < 50:
					var center_card_deck_position = _center_card_query()
					if center_card_deck_position > global.livedeck.size():
						pass #this is where I would trigger an 'card unavailable' message?
					elif center_card_deck_position < 0 :
						print("center card query resulted in null position")
					else:
						var deck_copy_position = global.deck_copy_converted[center_card_deck_position]
						global.carousel_choice.append(deck_copy_position)
						emit_signal("card_chosen", 1)
