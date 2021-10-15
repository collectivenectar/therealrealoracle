extends Control

var readingnamestorage : String
var parent_storage_var : Node

func _ready():
	pass

func _setup_panel(readingname, spreadtype):
	if readingname == "no readings saved yet":
		$hboxcontainer/readinginfo/VBoxContainer/readingname.text = readingname
		$hboxcontainer/readinginfo/VBoxContainer/spreadtype.text = spreadtype
	else:
		$hboxcontainer/readinginfo/VBoxContainer/readingname.text = readingname
		$hboxcontainer/readinginfo/VBoxContainer/spreadtype.text = spreadtype
	readingnamestorage = readingname

func _on_loadthisreading_pressed():
	if readingnamestorage == "no readings saved yet":
		pass
	else:
		global.draw()
		global.spread_state_set_to = global.runtime_user_data["saved_readings"][readingnamestorage][0]
		for card in global.runtime_user_data.saved_readings[readingnamestorage][1]:
			for i in global.deck_copy_converted:
				if global.livedeck[i].name == card:
					global.carousel_choice.append(i)
					break
				else:
					pass
		global.total_cards_in_scene = global.runtime_user_data["saved_readings"][readingnamestorage][2]
		global.current_card_in_spread = 1
		get_tree().change_scene("res://scenes/DrawingCards/seeyourcards.tscn")

func parent_storage(parent):
	parent_storage_var = parent


func _on_delete_pressed():
	if readingnamestorage == "no readings saved yet":
		pass
	else:
		parent_storage_var.call_popup(readingnamestorage, self)
