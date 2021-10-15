extends Control

onready var image1 = preload("res://icons/are you ready button.png")
onready var image2 = preload("res://icons/heart.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_shufflefromimage1_pressed():
	var image_1_as_image = image1.get_data()
	var image_1_as_pool_byte_a = image_1_as_image.data.data
	var image_1_hash = hash(image_1_as_pool_byte_a)
	$rn/randomnumber.text = str(image_1_hash)
	seed(image_1_hash)
	var deck_copy = global.deck.duplicate()
	deck_copy.shuffle()
	var deck_copy_indexed = []
	for i in deck_copy:
		deck_copy_indexed.append(global.deck.find(i))
	$sai/shuffledarrayindexes.text = str(deck_copy_indexed)
	print(image_1_as_image)

func _on_shufflefromimage2_pressed():
	var image_1_as_image = image2.get_data()
	var image_1_as_pool_byte_a = image_1_as_image.data.data
	var image_1_hash = hash(image_1_as_pool_byte_a)
	$rn/randomnumber.text = str(image_1_hash)
	seed(image_1_hash)
	var deck_copy = global.deck.duplicate()
	deck_copy.shuffle()
	var deck_copy_indexed = []
	for i in deck_copy:
		deck_copy_indexed.append(global.deck.find(i))
	$sai/shuffledarrayindexes.text = str(deck_copy_indexed)
