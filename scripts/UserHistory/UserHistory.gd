extends Control


onready var loadareading_scene : PackedScene = preload("res://scenes/UserHistory/loadareadingpanel.tscn")

onready var tween : Node = get_node("Tween")

var reading_name_temp : String
var child_path_storage : Node
var fade_toggle_filter : int = 0

func _ready():
	#set up the scrollboxcontainer so the sliders don't appear
	$ScrollContainer.get_v_scrollbar().add_stylebox_override('grabber', StyleBoxEmpty.new())
	$ScrollContainer.get_v_scrollbar().add_stylebox_override('scroll', StyleBoxEmpty.new())
	#onready load up the users saved information
	load_saves()
	#turn off visible popups
	$areyousure.visible = false
	$areyousure.modulate.a8 = 0
	
func load_saves():
	#check if the user data at runtime has anything
	if global.runtime_user_data.saved_readings.size() == 0:
		#if empty, load a placeholder panel here to show that there are none available to load
		var instance : Node = loadareading_scene.instance()
		$ScrollContainer/VBoxContainer.add_child(instance)
		instance._setup_panel("no readings saved yet", "nothing")
	else:
		for i in global.runtime_user_data["saved_readings"].keys():
			#for each saved item 'key' (spread name) in the saved_readings dictionary, do these things:
			#create an instance of the loadareadingscene
			var instance : Node = loadareading_scene.instance()
			#add that instance to the vboxcontainer
			$ScrollContainer/VBoxContainer.add_child(instance)
			#pass args to _setup_panel - i (which is the key(spread name) in the users saved data),
			#then [i][0] is the spread type? 1-5 currently, may be more when there are more stock spreads
			instance._setup_panel(i, i)
			instance.parent_storage(self)
			
func _tween_completed(_object, _key):
	if fade_toggle_filter == 0:
		$areyousure.visible = false
		
func call_popup(readingnamestorage, reading_child_path):
	$areyousure.visible = true
	fade_toggle_filter = 1
	tween.interpolate_property($areyousure, "modulate:a8", null, 255, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
	reading_name_temp = readingnamestorage
	child_path_storage = reading_child_path
	
func _on_yes_pressed():
	child_path_storage.queue_free()
	for values in global.runtime_user_data.saved_readings.keys():
		if values == reading_name_temp:
			global.runtime_user_data.saved_readings.erase(values)
			break
		else:
			pass
	global.save_user_data()
	fade_toggle_filter = 0
	tween.interpolate_property($areyousure, "modulate:a8", null, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.connect("tween_completed", self, "_tween_completed")
	tween.start()

func _on_no_pressed():
	fade_toggle_filter = 0
	tween.interpolate_property($areyousure, "modulate:a8", null, 0, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.connect("tween_completed", self, "_tween_completed")
	tween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
