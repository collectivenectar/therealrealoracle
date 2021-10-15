extends Control

const card_width : int = 300
const card_h_separation : int = 50
var card_zone : int = card_width + card_h_separation
var window_position : float = 0
signal button_visibility_toggle(position)


func _ready():
	_carousel_dragged_pos(window_position)

func _carousel_dragged_pos(window_position):
	var window_offset : float = fmod(window_position, card_zone)
	var parent_center : float = (rect_size.x / 2.0) - (card_width * 0.5)
	for i in 5: get_child(i).rect_position = Vector2(parent_center - (card_zone * (i - 2)) + window_offset, 0)
	for i in 5: 
		if -card_zone < get_child(i).rect_position.x and get_child(i).rect_position.x < rect_size.x:
			get_child(i).texture = global.carousel_choice[fposmod(int(window_position / card_zone) + (i - 2), global.carousel_choice.size())]['texture']
			get_child(i).get_child(0).text = str(global.carousel_choice[fposmod(int(window_position / card_zone) + (i - 2), global.carousel_choice.size())]['description'])
			if get_child(i).rect_position.x < (((rect_size.x - card_width) / 2)) and window_position >= 0:
				get_child(i).visible = false
				emit_signal("button_visibility_toggle", 0)
			elif get_child(i).rect_position.x < (((rect_size.x - card_width) / 2)) and window_position <= 0:
				get_child(i).visible = true
			elif abs((fposmod(int(window_position / card_zone) + (i - 2), global.carousel_choice.size()))) < 1 and get_child(i).rect_position.x >= ((rect_size.x + card_zone) / 2):
					get_child(i).visible = false
					emit_signal("button_visibility_toggle", 2)
			elif get_child(i).rect_position.x >= ((rect_size.x - card_zone) / 2) and get_child(i).rect_position.x <= ((rect_size.x + card_zone) / 2):
				global.current_cardid_in_center_card = global.carousel_choice[fposmod(int(window_position / card_zone) + (i - 2), global.carousel_choice.size())]
			
	
func _on_Button_pressed():
	pass
	
func _update_window_position(spread_position):
	window_position += spread_position * card_zone
	_carousel_dragged_pos(window_position)

#var window_position = 0

#func _ready():
	#$TextureRect.rect_position = Vector2( - (card_zone / 2), 50)
	#$TextureRect2.rect_position = Vector2((rect_size.x - card_zone) / 2, 50)
	#$TextureRect3.rect_position = Vector2(rect_size.x - (card_zone / 2), 50)
	#_virtual_carousel(window_position)

#func _virtual_carousel(direction):
	#window_position += direction
	#if window_position == 0:
		#$TextureRect.visible = false
	#if window_position >= 0 and window_position <= global.carousel_choice.size():
		#$TextureRect.visible = true
		#$TextureRect2.visible = true
		#$TextureRect3.visible = true
	#if window_position >= 0 and window_position == global.carousel_choice.size() + 1:
		#$TextureRect3.visible = false
	#$texturerect1.texture = global.carousel_choice[fposmod((global.current_card_in_spread - 1), (global.carousel_choice.size() + 1))]["texture"]
	#$texturerect2.texture = global.carousel_choice[fposmod(global.current_card_in_spread, (global.carousel_choice.size() + 1))]["texture"]
	#$texturerect3.texture = global.carousel_choice[fposmod((global.current_card_in_spread + 1), (global.carousel_choice.size() + 1))]["texture"]
