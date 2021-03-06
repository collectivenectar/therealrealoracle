extends Control

onready var userhistory : PackedScene = preload("res://scenes/UserHistory/UserHistory.tscn")
onready var guidebook : PackedScene = preload("res://scenes/Guidebook/Guidebook.tscn")
onready var choosingspreads : PackedScene = preload("res://scenes/DrawingCards/choosewhichspread.tscn")
onready var deckcarousel : PackedScene = preload("res://scenes/DeckCarousel/DeckCarousel.tscn")
onready var choosecards : PackedScene = preload("res://scenes/DrawingCards/choose your cards.tscn")
onready var seecards : PackedScene = preload("res://scenes/DrawingCards/seeyourcards.tscn")

var chevronsup = preload("res://app icons/ChevronUp.png")
var chevronsdown = preload("res://app icons/ChevronDown.png")
var menu_hidden = false
var card_color1 = global.color_compliment
var instanceViewerChannel : int = 0
var instanceViewerChannels : Array = ["DrawingCards", "UserHistory", "DeckCarousel", "DeckGuide"]

func _ready():
	global.carousel_type_currently_is = 0
	var choosingspreadsinstance = choosingspreads.instance()
	choosingspreadsinstance.connect("spread_chosen", self, "_switch_to_choose_cards")
	$InstanceViewer.add_child(choosingspreadsinstance)

# All other scenes are loaded through the main menu.tscn, in and out of "InstanceViewer" node.
# This should simplify UI issues.

#func modal_exit_anim():
#	tween.interpolate_property($deckcorepopup, "rect_position:y", 0.0, rect_size.y, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.0)
#	tween.start()

#func _on_deckcorebutton_button_up():
#	deckcore.visible = false
#	$deckcorepopup.add_child(deckcore)
#	deckcore.connect("modal_exit", self, "modal_exit_anim")
#	deckcore.parent_storage = self
#	tween.interpolate_property($deckcorepopup, "rect_position:y", rect_size.y, 0.0, 0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.0)
#	deckcore.visible = true
#	tween.start()
	#manages the access to the 'deck core' this system here needs to be
	#access in many parts, so simplicity is key. a hash is stored, an image displayed
	#only while the image is still the seed. After which only the hash is saved,
	#and is only saved for a maximum 10 histories.
	
	#Currently I need to investigate the image processing for iphone and see what
	#formats I have access to and how that might affect working on an iphone 12
	#HEIC image.
	
	#next I need to build another dictionary into global to be saved for up to 10
	#seeds, and allow them to be navigated through with arrows. Display the date
	#it was generated, maybe a name? no image if the current seed is replaced, the
	#image is deleted and a new one is used for a hash.
	
	#Could allow for hashing other types of data, but for now a normal rng
	#and an image based rng will provide the best randomness. The only other
	#thing I could think of would be audio, but that looks sparse on godot.
	#and maybe swipe patterns?
	
	#I need to build an access point to the core not just from the main menu,
	#but also from the choose your cards section, so that a person can start over
	
	
	#I also want to consider the real deck 'technology' where you can have the
	#seed only be applied to the current arrangement of cards, not a clean and
	#ordered deck. This means every time you shuffled(unless you sort the deck)
	#you didn't start over, so it acts like a real life deck.
	
	#so to start:
#popup a window here, prompting with options:
# - start over/sort the deck(make it go by numerical order) for shuffling
# - Go back to a previous seed(don't change current order)
# - generate a new seed(take a picture and hash it)

func _on_Button_button_up():
	#this button hides the 3 button menu, by shifting the parent Control node down
	#about 250 pixels, then rotating the button image so the arrows point upwards
	#Look into alpha transitions for
	#blinking pattern as indicator of completion of the action, and look into
	#how I might animate the chevrons instead of just moving their location.
	#maybe squeeze the image around the y axis, then change image to up chevrons,
	#then unsqueeze the image around the y axis?
	
#	UPDATE: Was thinking I could separate the chevron node from the actual menu bar,
#	this way I can have animations move up and down the y axis. Maybe once the user
#	touches it, it pops down/up and then a little inertia as the chevrons, 'catch up'
	if menu_hidden == false:
		$MenuUI.rect_position.y = 1945
		$HideMenu.icon = chevronsup
		$HideMenu.rect_position.y = 1780
		menu_hidden = true
	elif menu_hidden == true:
		$MenuUI.rect_position.y = 1720
		$HideMenu.icon = chevronsdown
		$HideMenu.rect_position.y = 1620
		menu_hidden = false

func _on_Draw_pressed():
	if instanceViewerChannel == 0:
		#here I run autosave or anything else
		pass
	global.carousel_type_currently_is = 0
	var choosingspreadsinstance = choosingspreads.instance()
	choosingspreadsinstance.connect("spread_chosen", self, "_switch_to_choose_cards")
	instanceViewerChannel = 0
	if $InstanceViewer.get_child_count() == 0:
		$InstanceViewer.add_child(choosingspreadsinstance)
	elif $InstanceViewer.get_child_count() >= 0:
		for i in $InstanceViewer.get_child_count():
			$InstanceViewer.get_child(i).queue_free()
		$InstanceViewer.add_child(choosingspreadsinstance)

func _on_History_pressed():
	if instanceViewerChannel == 0:
		#here I run autosave or anything else
		pass
	global.carousel_type_currently_is = 1
	var userhistoryinstance = userhistory.instance()
	if $InstanceViewer.get_child_count() == 0:
		$InstanceViewer.add_child(userhistoryinstance)
	elif $InstanceViewer.get_child_count() >= 0:
		for i in $InstanceViewer.get_child_count():
			$InstanceViewer.get_child(i).queue_free()
		$InstanceViewer.add_child(userhistoryinstance)

func _on_Guidebook_pressed():
	if instanceViewerChannel == 0:
		#here I run autosave or anything else
		pass
	var guidebookinstance = guidebook.instance()
	if $InstanceViewer.get_child_count() == 0:
		$InstanceViewer.add_child(guidebookinstance)
	elif $InstanceViewer.get_child_count() >= 0:
		for i in $InstanceViewer.get_child_count():
			$InstanceViewer.get_child(i).queue_free()
		$InstanceViewer.add_child(guidebookinstance)

func _on_Deck_pressed():
	if instanceViewerChannel == 0:
		#here I run autosave or anything else
		pass
	global.carousel_type_currently_is = 2
	var deckcarouselinstance = deckcarousel.instance()
	if $InstanceViewer.get_child_count() == 0:
		$InstanceViewer.add_child(deckcarouselinstance)
	elif $InstanceViewer.get_child_count() >= 0:
		for i in $InstanceViewer.get_child_count():
			$InstanceViewer.get_child(i).queue_free()
		$InstanceViewer.add_child(deckcarouselinstance)

func _switch_to_choose_cards():
	var chooseCardsInstance : Node = choosecards.instance()
	chooseCardsInstance.connect("cards_chosen", self, "_switch_to_show_cards")
	if $InstanceViewer.get_child_count() == 0:
		$InstanceViewer.add_child(chooseCardsInstance)
	elif $InstanceViewer.get_child_count() >= 0:
		for i in $InstanceViewer.get_child_count():
			$InstanceViewer.get_child(i).queue_free()
		$InstanceViewer.add_child(chooseCardsInstance)

func _switch_to_show_cards():
	var seeCardsInstance : Node = seecards.instance()
	if $InstanceViewer.get_child_count() == 0:
		$InstanceViewer.add_child(seeCardsInstance)
	elif $InstanceViewer.get_child_count() >= 0:
		for i in $InstanceViewer.get_child_count():
			$InstanceViewer.get_child(i).queue_free()
		$InstanceViewer.add_child(seeCardsInstance)
