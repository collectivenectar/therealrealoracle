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
	var lg_font = DynamicFont.new()
	var md_font = DynamicFont.new()
	var sm_font = DynamicFont.new()
	var lgFontCardRatio : float = 0.1
	var mdFontCardRatio : float = 0.075
	var smFontCardRatio : float = 0.05
	lg_font.font_data = load("res://fonts/Kollektif-Bolt.ttf")
	md_font.font_data = load("res://fonts/Kollektif-Bolt.ttf")
	sm_font.font_data = load("res://fonts/Kollektif-Bolt.ttf")
	lg_font.size = self.rect_min_size.x * lgFontCardRatio
	md_font.size = self.rect_min_size.x * mdFontCardRatio
	sm_font.size = self.rect_min_size.x * smFontCardRatio
	$Front/DescriptionContainer/HBoxContainer/VBoxContainer/LargeDescription.set("custom_fonts/font", lg_font)
	$Front/DescriptionContainer/HBoxContainer/VBoxContainer/SmallDescription.set("custom_fonts/font", md_font)
	$Front/VBoxContainer/HBoxContainer/CardNumber.set("custom_fonts/font", sm_font)
	$Front/VBoxContainer/HBoxContainer/RH.set("custom_fonts/font", sm_font)
	lg_font.update_changes()
	md_font.update_changes()
	sm_font.update_changes()

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
