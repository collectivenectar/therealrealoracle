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
	
func _cell_added():
	var additional : Node = cardnotecell.instance()
	$ScrollContainer/CardDeckVBox/CardDescriptionBox.get_child_count()
	$ScrollContainer/CardDeckVBox/CardDescriptionBox.add_child(additional)
	$ScrollContainer/CardDeckVBox/CardDescriptionBox.move_child(additional, -1)
	additional.connect("celladded", self, "_cell_added")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
