extends Control

export var card_color1 : Color
export var card_color2 : Color
export var card_color3 : Color
onready var newstyleback: StyleBoxFlat = $Back/Panel.get_stylebox("panel").duplicate()
onready var newstylefront: StyleBoxFlat = $Front/Panel.get_stylebox("panel").duplicate()


# Called when the node enters the scene tree for the first time.
func _ready():
	_card_coloration_setup()

func _card_coloration_setup():
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
	$Front/VBoxContainer/HBoxContainer/CardNumber.add_color_override("default_color", card_color1)
	$Front/VBoxContainer/HBoxContainer/RH.add_color_override("default_color", card_color1)
	$Front/DescriptionContainer/HBoxContainer/VBoxContainer/LargeDescription.add_color_override("default_color", card_color1)
	$Front/DescriptionContainer/HBoxContainer/VBoxContainer/SmallDescription.add_color_override("default_color", card_color1)

func _front_or_back_visible(visible_side):
	if visible_side == "front":
		$Front.visible = true
		$Back.visible = false
	elif visible_side == "back":
		$Back.visible = true
		$Front.visible = false
	else:
		print("front_or_back signal problem")

func _set_sizing(cardWidthHeightRatio, cardWidth):
	var cardHeight = cardWidth / cardWidthHeightRatio
	self.rect_min_size = Vector2(cardWidth, cardHeight)
	$Front.rect_min_size = Vector2(cardWidth, cardHeight)
	var lg_font = $Front/DescriptionContainer/HBoxContainer/VBoxContainer/LargeDescription.get("custom_fonts/normal_font").duplicate()
	var md_font = $Front/DescriptionContainer/HBoxContainer/VBoxContainer/SmallDescription.get("custom_fonts/normal_font").duplicate()
	var sm_font1 = $Front/VBoxContainer/HBoxContainer/CardNumber.get("custom_fonts/normal_font").duplicate()
	var sm_font2 = $Front/VBoxContainer/HBoxContainer/RH.get("custom_fonts/normal_font").duplicate()
	var lgFontCardRatio : float = 0.1
	var mdFontCardRatio : float = 0.075
	var smFontCardRatio : float = 0.05
	lg_font.size = int(round(self.rect_min_size.x * lgFontCardRatio))
	md_font.size = int(round(self.rect_min_size.x * mdFontCardRatio))
	sm_font1.size = int(round(self.rect_min_size.x * smFontCardRatio))
	sm_font2.size = int(round(self.rect_min_size.x * smFontCardRatio))
	$Front/DescriptionContainer/HBoxContainer/VBoxContainer/LargeDescription.set("custom_fonts/normal_font", lg_font)
	$Front/DescriptionContainer/HBoxContainer/VBoxContainer/SmallDescription.set("custom_fonts/normal_font", md_font)
	$Front/VBoxContainer/HBoxContainer/CardNumber.set("custom_fonts/normal_font", sm_font1)
	$Front/VBoxContainer/HBoxContainer/RH.set("custom_fonts/normal_font", sm_font2)
	lg_font.update_changes()
	md_font.update_changes()
	sm_font1.update_changes()
	sm_font2.update_changes()

func _card_available(available, card_number):
	if card_number == self.get_meta("card_number"):
		if available == true:
			$Back/Top.visible = false
		elif available == false:
			$Back/Top.visible = true
	else:
		print(self.get_meta("card_number"))
		
func _set_text(text1, text2, cardnumber):
	$Front/DescriptionContainer/HBoxContainer/VBoxContainer/LargeDescription.clear()
	$Front/DescriptionContainer/HBoxContainer/VBoxContainer/SmallDescription.clear()
	$Front/VBoxContainer/HBoxContainer/CardNumber.clear()
	$Front/DescriptionContainer/HBoxContainer/VBoxContainer/LargeDescription.bbcode_text = text1
	$Front/DescriptionContainer/HBoxContainer/VBoxContainer/SmallDescription.bbcode_text = text2
	$Front/VBoxContainer/HBoxContainer/CardNumber.bbcode_text = cardnumber
