extends Control

# this is where users will likely spend most of their time. Consider this scene
# the most important in terms of efficiency and UX. One other scene is instanced
# in, the layout progress scene which is essentially the same as before, 
# only on starting this scene card_layout_progress starts at 0?
#if I run into trouble with the layout scene and showing progress, I have an idea
#for how to maybe do this simply:

#create an array of arrays, with the first array being each card, and each sub
#array being a container for that card information, i.e. the cards_info_storage
#variable or something. Then any changes that need to be made are done to the array
#and adding or removing cards is done through array.methods

onready var layout_scene : PackedScene = preload("res://scenes/DrawingCards/ProgressIndicatorIndividual.tscn")
onready var layout : Node = layout_scene.instance()
onready var card : PackedScene = preload("res://scenes/card.tscn")
onready var card_instance : Node = card.instance()
onready var tween : Node = get_node("Tween")

var window_position : float = 0.0
var card_width : int = 500
var card_h_separation : int = 100
var card_zone : int = card_width + card_h_separation
var date_time : Dictionary

signal layout_update(progress)
signal layout_spread_state(state)

func _ready():
	#add the layout container
	$VBoxContainer/CenterContainer.add_child(layout)
	#connect the signals between the parent scene and the layout scene
	connect("layout_update", layout, "_card_progress")
	#update that layout by setting it to 0(the beginning_)
	_update_layout(0)
	#set the virtual carousel to 0
	#set centercontainer transparency to %100
	$CenterContainer.modulate.a8 = 0
	#disable scrollbar visibility
	$CenterContainer/ScrollContainer.get_v_scrollbar().add_stylebox_override('grabber', StyleBoxEmpty.new())
	$CenterContainer/ScrollContainer.get_v_scrollbar().add_stylebox_override('scroll', StyleBoxEmpty.new())
	var card_left = card_instance.duplicate()
	card_left._front_or_back_visible("front")
	$cardleft.add_child(card_left)
	var card_center = card_instance.duplicate()
	card_center._front_or_back_visible("front")
	$cardcenter.add_child(card_center)
	var card_right = card_instance.duplicate()
	card_right._front_or_back_visible("front")
	$cardright.add_child(card_right)
	var texturerect_card = card_instance.duplicate()
	texturerect_card._front_or_back_visible("front")
	$CenterContainer/ScrollContainer/VBoxContainer/TextureRect.add_child(texturerect_card)
	_virtual_carousel(window_position)
	
func _update_layout(progress):
	# catches signal from carouseldisplayedcards.tscn to relay to cardlayoutprogress.tscn
	layout._card_progress(progress)
	global.current_card_in_spread += progress
	print((global.current_card_in_spread - 2))
	var current_spread = global.tarot_spread_info[global.spread_state_set_to]['spread name']
	var spread_position = global.tarot_spread_info[global._layout_states.find(current_spread)]['position titles'][(global.current_card_in_spread - 2)]
	$spreadposition.bbcode_text = "[center]" + spread_position + "[/center]"

func _on_left_pressed():
	#update layout when looking through cards in the spread
	_virtual_carousel(-1)
	_update_layout(-1)

func _on_right_pressed():
	#update layout when looking through cards in the spread
	_virtual_carousel(1)
	_update_layout(1)

func _end_reached(_position):
	pass

func _if_spread_full():
	pass

func _virtual_carousel(direction):
	#this manages the card positions in this scene, based on card size and number of cards
	#in this spread. Moving one card over means just moving the image resource from one
	#texture rect to another. When the user is at the beginning, there should be no option
	#to continue to the left, and the same for to the right if at the end.
	window_position += direction
	if window_position == 0:
		if global.carousel_choice.size() == 1:
			$cardleft.visible = false
			$left.visible = false
			$cardright.visible = false
			$right.visible = false
		else:
			$cardleft.visible = false
			$left.visible = false
			$cardright.visible = true
			$right.visible = true
	elif window_position > 0 and window_position < global.carousel_choice.size() - 1 :
		$cardleft.visible = true
		$cardcenter.visible = true
		$cardright.visible = true
		$left.visible = true
		$right.visible = true
	elif window_position > 0 and window_position == global.carousel_choice.size() - 1 :
		$cardright.visible = false
		$right.visible = false
		$cardleft.visible = true
		$left.visible = true
	var center_texture_number : float = fposmod(window_position, global.carousel_choice.size())
	$cardleft.get_child(0)._set_text(global.livedeck[global.deck_copy_converted[global.carousel_choice[center_texture_number - 1]]]['description1'], global.livedeck[global.deck_copy_converted[global.carousel_choice[center_texture_number - 1]]]['description2'], global.livedeck[global.deck_copy_converted[global.carousel_choice[center_texture_number - 1]]]['name'])
	$cardcenter.get_child(0)._set_text(global.livedeck[global.deck_copy_converted[global.carousel_choice[center_texture_number]]]['description1'], global.livedeck[global.deck_copy_converted[global.carousel_choice[center_texture_number]]]['description2'], global.livedeck[global.deck_copy_converted[global.carousel_choice[center_texture_number]]]['name'])
	if window_position < global.carousel_choice.size() - 1:
		$cardright.get_child(0)._set_text(global.livedeck[global.deck_copy_converted[global.carousel_choice[center_texture_number + 1]]]['description1'], global.livedeck[global.deck_copy_converted[global.carousel_choice[center_texture_number + 1]]]['description2'], global.livedeck[global.deck_copy_converted[global.carousel_choice[center_texture_number + 1]]]['name'])

func _tween_completed(_object, _key):
	#when toggling alpha on the popup, check for if animation is done before toggling visibility.
	if $closepopup.visible == false:
		$CenterContainer.visible = false
	else:
		pass

func _on_selectcentercard_pressed():
	#if a card is touched in this scene, display a close up view of the card, as well as text descriptions and
	#other functions related to exploring the card/deck/making notes on the deck etc
	$CenterContainer/ScrollContainer/VBoxContainer/TextureRect.get_child(0)._set_text(global.livedeck[global.deck_copy_converted[global.carousel_choice[window_position]]]['description1'], global.livedeck[global.deck_copy_converted[global.carousel_choice[window_position]]]['description2'], global.livedeck[global.deck_copy_converted[global.carousel_choice[window_position]]]['name'])
	$CenterContainer/ScrollContainer/VBoxContainer/RichTextLabel.text = global.livedeck[global.deck_copy_converted[global.carousel_choice[window_position]]]['description1']
	#unfortunately due to layering, I need to move the children around to get proper visibility
	#then move it back when the window is closed
	$closepopup.visible = true
	$CenterContainer.visible = true
	move_child($closepopup, 12)
	move_child($background, 9)
	tween.interpolate_property($CenterContainer, "modulate:a8", null, 255, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	tween.start()

func _on_closepopup_pressed():
	#see above comment
	$closepopup.visible = false
	move_child($background, 0)
	tween.interpolate_property($CenterContainer, "modulate:a8", null, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	tween.connect("tween_completed", self, "_tween_completed")
	tween.start()

func _on_savethisreading_pressed():
	#reveal the saving popup
	date_time = OS.get_datetime()
	$savereadingpopup.visible = true

func _on_submittext_pressed():
	#hide the saving popup and do something based on what the user selected:
	#but almost all options depend on saving the spread in user data
	$savereadingpopup.visible = false
	# eventually, journal?
	var reading_name : String = $savereadingpopup/enterreadingname.text
	var spread_state : int = global.spread_state_set_to
	global.carousel_converted.clear()
	global._compare_against_deck(0, "savetime")
	var carousel_converted : Array = global.carousel_converted
	var total_cards_in_scene : int = global.total_cards_in_scene
	global.runtime_user_data.saved_readings[reading_name] = [spread_state, carousel_converted, total_cards_in_scene]
	global.save_user_data()

func _on_backtomainmenu_pressed():
	#clear all data in the scene and make it ready for another reading
	global.clear_decks()
	global.current_card_in_spread = 0
	global.total_cards_in_scene = 0
	get_tree().change_scene("res://scenes/mainmenu.tscn")
