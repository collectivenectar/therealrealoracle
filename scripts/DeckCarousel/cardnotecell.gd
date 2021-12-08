extends Control

onready var tween : Tween = get_node("Tween")
signal celladded

func _ready():
	#dont forget to set up dimensions automatically
	pass

func _on_AddNote_pressed():
	$AddNote.modulate.a = 0
	tween.interpolate_property($Panel, "rect_position:x", null, 10, 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.2)
	tween.interpolate_property($Panel, "rect_min_size:x", null, 1060, 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.2)
	#connect("tween_completed", self, "_tween_completed")
	tween.start()

func _on_Tween_tween_completed(object, key):
	if object == get_node("Panel") and key == ":rect_position:x" :
		tween.interpolate_property($Panel, "rect_min_size:y", 200, 300, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.2)
		tween.interpolate_property(self, "rect_min_size:y", 200, 300, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.2)
		tween.interpolate_property($VBoxContainer, "rect_min_size:y", 154, 250, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.2)
		tween.start()
		$VBoxContainer/HBoxContainer/EditNote.visible = true
		$VBoxContainer.rect_min_size.y = $Panel.rect_size.y - 50
		
	elif object == get_node("Panel") and key == ":rect_min_size:y" :
		$Panel.rect_min_size.y = 300
		self.rect_min_size.y = 300
		$VBoxContainer.rect_min_size.y = 250
		
		emit_signal("celladded")


func _on_EditNote_button_up():
	#here the user can add their personal notes to each card, so there needs to
	#be a connection to the userdata.
	pass # Replace with function body.
