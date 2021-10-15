extends Control

# additional information needed for scene:
# journal text
# date? or maybe just name of the saved reading?

#a preloaded scene which is for displaying a visual exampl of the spread type
onready var loadareading_scene : PackedScene = preload("res://scenes/Journal/loadareadingpanel.tscn")
onready var carousel : PackedScene = preload("res://scenes/DrawingCards/Carousels/JournalCarousel.tscn")
onready var cardnotecell : PackedScene = preload("res://scenes/Journal/cardnotecell.tscn")
#tween for animating transparency
onready var tween : Node = get_node("Tween")
#vars for storing spread data
var reading_name_temp : String
var child_path_storage : Node
var fade_toggle_filter : int = 0

func _ready():
	
	#READINGS HISTORY
	#set up the scrollboxcontainer so the sliders don't appear
	$TripleMenu/SavedSpreads/ScrollContainer.get_v_scrollbar().add_stylebox_override('grabber', StyleBoxEmpty.new())
	$TripleMenu/SavedSpreads/ScrollContainer.get_v_scrollbar().add_stylebox_override('scroll', StyleBoxEmpty.new())
	#onready load up the users saved information
	load_saves()
	#turn off visible popups
	$TripleMenu/SavedSpreads/areyousure.visible = false
	$TripleMenu/SavedSpreads/areyousure.modulate.a8 = 0
	$MenuBackground.modulate.a8 = 35
	
	#GUIDEBOOK
	
	
	#CARDCAROUSEL
	$TripleMenu/CardDeck/ScrollContainer/CardDeckVBox/CarouselCBox/CarouselContainer.add_child(carousel.instance())
	var cardnotecellinstance : Node = cardnotecell.instance()
	$TripleMenu/CardDeck/ScrollContainer/CardDeckVBox/CardDescriptionBox.add_child(cardnotecellinstance)
	$TripleMenu/CardDeck/ScrollContainer/CardDeckVBox/CardDescriptionBox.rect_size.x = rect_size.x
	cardnotecellinstance.connect("celladded", self, "_cell_added")
	
	#AUTOLAYOUT
#UI FUNCTIONS
#

#READINGSHISTORY FUNCTIONS
func load_saves():
	#check if the user data at runtime has anything
	if global.runtime_user_data.saved_readings.size() == 0:
		#if empty, load a placeholder panel here to show that there are none available to load
		var instance : Node = loadareading_scene.instance()
		$TripleMenu/SavedSpreads/ScrollContainer/VBoxContainer.add_child(instance)
		instance._setup_panel("no readings saved yet", "nothing")
	else:
		for i in global.runtime_user_data["saved_readings"].keys():
			#for each saved item 'key' (spread name) in the saved_readings dictionary, do these things:
			#create an instance of the loadareadingscene
			var instance : Node = loadareading_scene.instance()
			#add that instance to the vboxcontainer
			$TripleMenu/SavedSpreads/ScrollContainer/VBoxContainer.add_child(instance)
			#pass args to _setup_panel - i (which is the key(spread name) in the users saved data),
			#then [i][0] is the spread type? 1-5 currently, may be more when there are more stock spreads
			instance._setup_panel(i, i)
			instance.parent_storage(self)

func _tween_completed(_object, _key):
	if fade_toggle_filter == 0:
		$TripleMenu/SavedSpreads/areyousure.visible = false

func call_popup(readingnamestorage, reading_child_path):
	$TripleMenu/SavedSpreads/areyousure.visible = true
	fade_toggle_filter = 1
	tween.interpolate_property($TripleMenu/SavedSpreads/areyousure, "modulate:a8", null, 255, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	reading_name_temp = readingnamestorage
	child_path_storage = reading_child_path

func _on_yes_pressed():
	child_path_storage.queue_free()
	for values in global.runtime_user_data.saved_readings.keys():
		if values == reading_name_temp:
			global.runtime_user_data.saved_readings.erase(values)
			break
		else:
			pass
	global.save_user_data()
	fade_toggle_filter = 0
	tween.interpolate_property($TripleMenu/SavedSpreads/areyousure, "modulate:a8", null, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.connect("tween_completed", self, "_tween_completed")
	tween.start()

func _on_no_pressed():
	fade_toggle_filter = 0
	tween.interpolate_property($TripleMenu/SavedSpreads/areyousure, "modulate:a8", null, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.connect("tween_completed", self, "_tween_completed")
	tween.start()

func _on_backtomainmenu_pressed():
	get_tree().change_scene("res://scenes/mainmenu.tscn")

#GUIDEBOOK FUNCTIONS

#CARDCAROUSEL FUNCTIONS

func _cell_added():
	var additional : Node = cardnotecell.instance()
	$TripleMenu/CardDeck/ScrollContainer/CardDeckVBox/CardDescriptionBox.get_child_count()
	$TripleMenu/CardDeck/ScrollContainer/CardDeckVBox/CardDescriptionBox.add_child(additional)
	$TripleMenu/CardDeck/ScrollContainer/CardDeckVBox/CardDescriptionBox.move_child(additional, -1)
	additional.connect("celladded", self, "_cell_added")
