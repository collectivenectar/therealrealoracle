extends Control

onready var carousel : PackedScene = preload("res://scenes/DrawingCards/Carousels/CarouselFinite.tscn")
onready var cardnotecell : PackedScene = preload("res://scenes/DeckCarousel/cardnotecell.tscn")
onready var cardnotecellmanager : PackedScene = preload("res://scenes/DeckCarousel/cardnotecellManager.tscn")
onready var tween : Node = get_node("Tween")

var card_note_cell_manager_node : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	_scene_prep()
	
func _scene_prep():
	var carousel_instance = carousel.instance()
	$ScrollContainer/CardDeckVBox/CarouselCBox/CarouselContainer.add_child(carousel_instance)
	var cardnotecellmanagerinstance = cardnotecellmanager.instance()
	$ScrollContainer/CardDeckVBox.add_child(cardnotecellmanagerinstance)
	card_note_cell_manager_node = cardnotecellmanagerinstance
	cardnotecellmanagerinstance.rect_size.x = rect_size.x
#	var cardnotecellinstance : Node = cardnotecell.instance()
#	$ScrollContainer/CardDeckVBox/CardNotesBox.add_child(cardnotecellinstance)
#	$ScrollContainer/CardDeckVBox/CardNotesBox.rect_size.x = rect_size.x
#	cardnotecellinstance.connect("celladded", self, "_cell_added")
	$ScrollContainer.get_v_scrollbar().add_stylebox_override('grabber', StyleBoxEmpty.new())
	$ScrollContainer.get_v_scrollbar().add_stylebox_override('scroll', StyleBoxEmpty.new())
	$ScrollContainer/CardDeckVBox/CarouselCBox/CarouselContainer.rect_min_size = Vector2(carousel_instance.screen_size.x, carousel_instance.card_height)
	carousel_instance.connect("card_note_cell_push", self, "_on_carousel_slowed")
	carousel_instance.connect("carousel_moving", self, "_on_carousel_moved")
	#whatever notes exist for the card that is shown first here, needs to be
	#loaded. In fact, it may be helpful to be sure that user notes are preloaded
	#in some way to make it quick. I'll need to write something that:
	#
	#relays information from the carousel to DeckCarousel, which then sends that
	#info to the instance of cardnotecellManager.
	#cardnotecellManager then instances however many user note cells there are 
	#for the current card, and changes the text to reflect stored data.

func _on_carousel_moved():
	card_note_cell_manager_node._clear_cells()

func _on_carousel_slowed(center_card):
	card_note_cell_manager_node._populate_user_notes(center_card)
