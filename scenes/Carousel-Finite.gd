extends Control

onready var card : PackedScene = preload("res://scenes/Card.tscn")

#var screen_size : Vector2 = OS.get_screen_size()
var screen_size : Vector2 = Vector2(1080, 1920)
var card_to_screen_ratio : float = 0.7

func _ready():
	for i in global.livedeck:
		var card_instance = card.instance()
		$cardcarousel/carouselslots.add_child(card_instance)
		var largetext = "[center]" + i['description1'] + "[/center]"
		var smalltext = "[center]" + i['description2'] + "[/center]"
		var cardnumber = i['name']
		card_instance._set_text(largetext, smalltext, cardnumber)
		$cardcarousel.rect_min_size = screen_size
		$cardcarousel/carouselslots.rect_min_size = screen_size
		$cardcarousel/carouselslots.set("custom_constants/separation", 50)
