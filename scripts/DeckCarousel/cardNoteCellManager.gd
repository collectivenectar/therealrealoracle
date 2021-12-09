extends Container

onready var cardNoteCell : PackedScene = preload("res://scenes/DeckCarousel/cardnotecell.tscn")

func _ready():
	#here I would need to set whatever sizing requirements based on OS, etc
	#connect a signal from carousel to here for when carousel_position is being changed
	#
	pass



