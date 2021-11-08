extends Control

onready var carousel : PackedScene = preload("res://scenes/DrawingCards/Carousels/JournalCarousel.tscn")
onready var cardnotecell : PackedScene = preload("res://scenes/DeckCarousel/cardnotecell.tscn")

onready var tween : Node = get_node("Tween")

# Called when the node enters the scene tree for the first time.
func _ready():
	$ScrollContainer/CardDeckVBox/CarouselCBox/CarouselContainer.add_child(carousel.instance())
	var cardnotecellinstance : Node = cardnotecell.instance()
	$ScrollContainer/CardDeckVBox/CardDescriptionBox.add_child(cardnotecellinstance)
	$ScrollContainer/CardDeckVBox/CardDescriptionBox.rect_size.x = rect_size.x
	cardnotecellinstance.connect("celladded", self, "_cell_added")
	$ScrollContainer.get_v_scrollbar().add_stylebox_override('grabber', StyleBoxEmpty.new())
	$ScrollContainer.get_v_scrollbar().add_stylebox_override('scroll', StyleBoxEmpty.new())
	#whatever notes exist for the card that is shown first here, needs to be
	#loaded. In fact, it may be helpful to be sure that user notes are preloaded
	#in some way to make it quick. I'll need to write something that:
	#
	#relays information from the carousel to the carddescriptionbox, creating
	#an instance of cardnotecell for each user note, then copying the usernotes
	#into the cardnotecell richtextbox. This will all need to be done so that the
	#user notes end up above the 'add note' button.
	
func _cell_added():
	var additional : Node = cardnotecell.instance()
	$ScrollContainer/CardDeckVBox/CardDescriptionBox.get_child_count()
	$ScrollContainer/CardDeckVBox/CardDescriptionBox.add_child(additional)
	var end_position : int = $ScrollContainer/CardDeckVBox/CardDescriptionBox.get_child_count() - 1
	$ScrollContainer/CardDeckVBox/CardDescriptionBox.move_child(additional, end_position)
	additional.connect("celladded", self, "_cell_added")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
