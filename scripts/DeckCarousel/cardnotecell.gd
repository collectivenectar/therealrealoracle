extends Control

onready var tween : Tween = get_node("Tween")
var editing = false

signal celladded

func _ready():
	#dont forget to set up dimensions automatically
	$VBoxContainer/TextEdit.connect("pass_on_textedit_height", self, "_text_changed")

func _on_AddNote_pressed():
	$AddNote.visible = false
	tween.interpolate_property($Panel, "rect_position:x", null, 10, 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.2)
	tween.interpolate_property($Panel, "rect_min_size:x", null, 1060, 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.2)
	#connect("tween_completed", self, "_tween_completed")
	tween.start()
	$VBoxContainer/TextEdit.set_readonly(false)

func _on_Tween_tween_completed(object, key):
	if object == get_node("Panel") and key == ":rect_position:x" :
		tween.interpolate_property($Panel, "rect_min_size:y", 200, 300, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.2)
		tween.interpolate_property(self, "rect_min_size:y", 200, 300, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.2)
		tween.interpolate_property($VBoxContainer, "rect_min_size:y", 154, 250, 0.2, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.2)
		tween.start()
		$VBoxContainer.rect_min_size.y = $Panel.rect_size.y - 50
		
	elif object == get_node("Panel") and key == ":rect_min_size:y" :
		$Panel.rect_min_size.y = 300
		self.rect_min_size.y = 300
		$VBoxContainer.rect_min_size.y = 250
		$VBoxContainer/CenterContainer/TextureButton.visible = true
		emit_signal("celladded")

func _text_changed(height):
	rect_min_size.y = height + 50 + $VBoxContainer/CenterContainer/TextureButton.rect_size.y
	rect_size.y = height + 50 + $VBoxContainer/CenterContainer/TextureButton.rect_size.y
	$Panel.rect_min_size.y = height + 50 + $VBoxContainer/CenterContainer/TextureButton.rect_size.y
	$Panel.rect_size.y = height + 50 + $VBoxContainer/CenterContainer/TextureButton.rect_size.y
	update()


func _on_TextureButton_button_up():
	if $VBoxContainer/CenterContainer/TextureButton.texture_normal == preload("res://app icons/Edit.png"):
		editing = true
		$VBoxContainer/TextEdit.readonly = false
		$VBoxContainer/CenterContainer/TextureButton.texture_normal = preload("res://app icons/Check.png")
		$VBoxContainer/TextEdit.grab_focus()
	elif $VBoxContainer/CenterContainer/TextureButton.texture_normal == preload("res://app icons/Check.png"):
		editing = false
		$VBoxContainer/TextEdit.readonly = true
		$VBoxContainer/CenterContainer/TextureButton.texture_normal = preload("res://app icons/Edit.png")
