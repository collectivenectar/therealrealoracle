extends Control

export var card_color1 : Color
export var card_color2 : Color
export var card_color3 : Color
onready var newstyleback: StyleBoxFlat = $Back/Panel.get_stylebox("panel").duplicate()
onready var newstylefront: StyleBoxFlat = $Front/Panel.get_stylebox("panel").duplicate()


# Called when the node enters the scene tree for the first time.
func _ready():
	card_color1 = global.color_compliment
	card_color2 = global.color_dominant
	card_color3 = global.color_accent
	$Back/Bottom.material.set_shader_param("card_color1", card_color1)
	$Back/layer2.material.set_shader_param("card_color1", card_color1)
	$Back/layer3.material.set_shader_param("card_color1", card_color1)
	$Back/layer4.material.set_shader_param("card_color1", card_color1)
	$Front/Bottom.material.set_shader_param("card_color1", card_color1)
	$Back/Panel.add_stylebox_override("panel", newstyleback)
	$Front/Panel.add_stylebox_override("panel", newstylefront)
	newstyleback.bg_color = card_color2
	newstyleback.border_color = card_color1
	newstylefront.bg_color = card_color2
	newstylefront.border_color = card_color1
	$Front/CardNumber.add_color_override("default_color", card_color1)
	$Front/RH.add_color_override("default_color", card_color1)
	$Front/DescriptionContainer/LargeDescription.add_color_override("default_color", card_color1)
	$Front/DescriptionContainer/SmallDescription.add_color_override("default_color", card_color1)

func _front_or_back_visible(visible_side):
	if visible_side == "front":
		$Front.visible = true
		$Back.visible = false
	elif visible_side == "back":
		$Back.visible = true
		$Front.visible = false
	else:
		print("front_or_back signal problem")
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _card_available(available, card_number):
	if card_number == self.get_meta("card_number"):
		if available == true:
			$Back/Top.visible = false
		elif available == false:
			$Back/Top.visible = true
	else:
		print(self.get_meta("card_number"))
		
func _set_text(text1, text2, cardnumber):
	$Front/DescriptionContainer/LargeDescription.clear()
	$Front/DescriptionContainer/SmallDescription.clear()
	$Front/CardNumber.clear()
	$Front/DescriptionContainer/LargeDescription.bbcode_text = text1
	$Front/DescriptionContainer/SmallDescription.bbcode_text = text2
	$Front/CardNumber.bbcode_text = cardnumber
