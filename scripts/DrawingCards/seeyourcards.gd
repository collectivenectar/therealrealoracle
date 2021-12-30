extends Control

# this is where users will likely spend most of their time. Consider this scene
# the most important in terms of efficiency and UX. 

# Needs a redesign in some places to work with autosave and app lifecycle
# Currently to reload the scene, I'd need:

#	global.carousel_type_currently_is
#	global.carousel_choice
#	global.current_focus
#	global.card_side_displayed
#	global.total_cards_in_scene

onready var carousel_scene : PackedScene = preload("res://scenes/DrawingCards/Carousels/CarouselFinite.tscn")
onready var carousel_instance : Node = carousel_scene.instance()
onready var layout_scene : PackedScene = preload("res://scenes/DrawingCards/ProgressIndicatorIndividual.tscn")
onready var layout : Node = layout_scene.instance()
onready var card : PackedScene = preload("res://scenes/card.tscn")
#onready var card_instance : Node = card.instance()
onready var tween : Node = get_node("Tween")

signal layout_update(progress)
signal layout_spread_state(state)

func _ready():
	_scene_setup()

func _scene_setup():
	#add the layout container
	$VBoxContainer/CenterContainer.add_child(layout)
	#connect the signals between the parent scene and the layout scene
	connect("layout_update", layout, "_card_progress")
	layout.connect("navigation_UI_update", self, "_nav_buttons_visibility_toggle")
	#update that layout by setting it to 0(the beginning_)
	_update_layout(0)
	$carouselContainer.add_child(carousel_instance)
	#set the virtual carousel to 0
	#set centercontainer transparency to %100
	$CenterContainer.modulate.a8 = 0
	#disable scrollbar visibility
	$CenterContainer/ScrollContainer.get_v_scrollbar().add_stylebox_override('grabber', StyleBoxEmpty.new())
	$CenterContainer/ScrollContainer.get_v_scrollbar().add_stylebox_override('scroll', StyleBoxEmpty.new())
	var texturerect_card = card.instance()
	texturerect_card._front_or_back_visible("front")
	$CenterContainer/ScrollContainer/VBoxContainer/TextureRect.add_child(texturerect_card)
	texturerect_card._set_sizing(0.625, global.os_screen_size.x * 0.7)

func _update_layout(progress):
	# catches signal from carouseldisplayedcards.tscn to relay to cardlayoutprogress.tscn
	layout._card_progress(progress)
	global.current_card_in_spread += progress
	var current_spread = global.tarot_spread_info[global.spread_state_set_to]['spread name']
	var spread_position = global.tarot_spread_info[global._layout_states.find(current_spread)]['position titles'][(global.current_card_in_spread - 2)]
	$spreadposition.bbcode_text = "[center]" + spread_position + "[/center]"

func _on_left_pressed():
	#update layout when looking through cards in the spread
	carousel_instance._navigate_left_one()
	_update_layout(-1)

func _on_right_pressed():
	#update layout when looking through cards in the spread
	carousel_instance._navigate_right_one()
	_update_layout(1)

func _nav_buttons_visibility_toggle(buttonsvisiblepattern):
	if buttonsvisiblepattern == 0:
		$left.visible = false
		$right.visible = false
	elif buttonsvisiblepattern == 1:
		$left.visible = false
		$right.visible = true
	elif buttonsvisiblepattern == 2:
		$left.visible = true
		$right.visible = false
	elif buttonsvisiblepattern == 3:
		$left.visible = true
		$right.visible = true
	else:
		print("_nav_buttons_visibility_toggle buttonsvisible provided ", buttonsvisiblepattern)

func _on_selectcentercard_pressed():
	var card_stack_position = carousel_instance._center_card_query()
	var livedeck_card_ref = global.livedeck[global.carousel_choice[card_stack_position]]
	$CenterContainer/ScrollContainer/VBoxContainer/TextureRect.get_child(0)._set_text(livedeck_card_ref['description1'], livedeck_card_ref['description2'], livedeck_card_ref['name'])
	$CenterContainer/ScrollContainer/VBoxContainer/RichTextLabel.text = livedeck_card_ref['description1']
	$closepopup.visible = true
	$CenterContainer.visible = true
	move_child($closepopup, 12)
	move_child($background, 7)
	tween.interpolate_property($CenterContainer, "modulate:a8", null, 255, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	tween.start()

func _on_closepopup_pressed():
	#see above comment
	$closepopup.visible = false
	move_child($background, 0)
	tween.interpolate_property($CenterContainer, "modulate:a8", null, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	tween.connect("tween_completed", self, "_tween_completed")
	tween.start()

func _tween_completed(_object, _key):
	#when toggling alpha on the popup, check for if animation is done before toggling visibility.
	if $closepopup.visible == false:
		$CenterContainer.visible = false
	else:
		pass


func _on_savethisreading_pressed():
	#reveal the saving popup
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

#func _on_backtomainmenu_pressed():
#	#clear all data in the scene and make it ready for another reading
#	global.clear_decks()
#	global.current_card_in_spread = 0
#	global.total_cards_in_scene = 0
#	get_tree().change_scene("res://scenes/mainmenu.tscn")


#func _on_selectcentercard_gui_input(event):
#	if event is InputEventMouseButton && event.button_index == BUTTON_LEFT:
#		if event.pressed:
#			click_down_position = Vector2(0, 0)
#			click_down_position = event.global_position
#		elif !event.pressed:
#			click_up_position = Vector2(0, 0)
#			click_up_position = event.global_position
#			if abs(click_up_position.x - click_down_position.x) < 50:
#				if abs(click_up_position.y - click_down_position.y) < 50:
#
