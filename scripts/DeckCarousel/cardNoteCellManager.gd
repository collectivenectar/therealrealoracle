extends Container

onready var cardNoteCell : PackedScene = preload("res://scenes/DeckCarousel/cardnotecell.tscn")

#manager needs to clear, queue_free current cells, then recreate cells and populate if needed
#so I need a clear function, a storage unit for user notes, a receiving function for the
#parent to send new cell data into.

func _ready():
	#here I would need to set whatever sizing requirements based on OS, etc
	#connect a signal from carousel to here for when carousel_position is being changed
	var cardnotecellinstance : Node = cardNoteCell.instance()
	$VBoxContainer.add_child(cardnotecellinstance)
	cardnotecellinstance.connect("celladded", self, "_cell_added")
	cardnotecellinstance.connect("update_parent_rect_size", self, "_rect_min_size_calc")

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

func _clear_cells():
	for i in $VBoxContainer.get_child_count():
		$VBoxContainer.get_child(i).queue_free()
	#some sort of placeholder animation while carousel is moved?
		
func _populate_user_notes(notes:String):
	if int(notes) < 10:
		notes = "0" + notes
		print(notes)
		_cell_added()
	else:
		print(notes)
		_cell_added()

