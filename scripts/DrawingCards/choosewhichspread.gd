extends Control

#Comments: 

#NOTE: Rebuild this scene, the progress indicator is no longer necessary, after
#discussion, want to do this with mostly text, maybe a few icons or something, but
#just describe the spread, how many cards, spread name, maybe the type, that's it.
#don't reinvent the wheel here.

#Maybe considering also adding a filter to
#change the top couple of readings  to the most recently used

#load hbox_cont and layout_scene for instantiation into this scene. layouts are
#visual representations of the card arrangements, hbox_conts are the parent containers
#for the names of the spreads, the buttons, and the layouts as well
onready var load_a_spread_container : PackedScene = preload("res://scenes/DrawingCards/loadaspreadcontainer.tscn")

func _ready():
	#for each spread type that comes stock, instance an hboxcontainer to hold that info
	for i in global._layout_states:
		var cont_inst : Control = load_a_spread_container.instance()
		$MarginContainer/VBoxContainer/CenterContainer/SpreadTypes.add_child(cont_inst)
		#set the text of this hboxcont to the name of the spread found in global._layout_states
		cont_inst.get_child(1).get_child(0).text = i
		#infuse the hboxcont with spread info
		cont_inst.set_meta("layout_state", global._layout_states.find(i))
		cont_inst.set_meta("total_cards", global._layout_states_cards_in_each[global._layout_states.find(i)])
		cont_inst.set_meta("spread_name", global._layout_states[global._layout_states.find(i)])
		cont_inst.get_child(1).get_child(1).bbcode_text = "[center]" + global.tarot_spread_info[global._layout_states.find(i)]['spread description'] + "[/center]"
		cont_inst.connect("spread_chosen", self, "on_spread_chosen")
	$MarginContainer.get_v_scrollbar().add_stylebox_override('grabber', StyleBoxEmpty.new())
	$MarginContainer.get_v_scrollbar().add_stylebox_override('scroll', StyleBoxEmpty.new())

func on_spread_chosen(position_in_storage, total_cards, spread_key):
	#once user chooses a spread, prepare the singleton for a scene change by storing the chosen
	#spread info in global.variables, then change_scene to choose your cards.tscn
	global.spread_state_set_to = position_in_storage
	global.total_cards_in_scene = total_cards
	get_tree().change_scene("res://scenes/DrawingCards/choose your cards.tscn")
