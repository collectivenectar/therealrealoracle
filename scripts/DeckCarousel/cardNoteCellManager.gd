extends Container

onready var cardNoteCell : PackedScene = preload("res://scenes/DeckCarousel/cardnotecell.tscn")

func _ready():
	#here I would need to set whatever sizing requirements based on OS, etc
	#connect a signal from carousel to here for when carousel_position is being changed
	var cardnotecellinstance : Node = cardNoteCell.instance()
	$VBoxContainer.add_child(cardnotecellinstance)
	cardnotecellinstance.connect("celladded", self, "_cell_added")

func _cell_added():
	var additional : Node = cardNoteCell.instance()
	$VBoxContainer.add_child(additional)
	var end_position : int = $VBoxContainer.get_child_count()
	$VBoxContainer.move_child(additional, end_position + 1)
	additional.connect("celladded", self, "_cell_added")
	_rect_min_size_calc()
	
func _rect_min_size_calc():
	var total_y_size : float
	for i in $VBoxContainer.get_child_count():
		total_y_size += $VBoxContainer.get_child(i).rect_size.y
		total_y_size += 5
	total_y_size -= 5
	rect_min_size.y = total_y_size


