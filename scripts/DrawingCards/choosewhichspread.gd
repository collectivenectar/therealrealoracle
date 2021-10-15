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
signal pass_self_node(node)

func _ready():
	#for each spread type that comes stock, instance an hboxcontainer to hold that info
	for i in global._layout_states:
		var cont_inst : Control = load_a_spread_container.instance()
		$MarginContainer/VBoxContainer.add_child(cont_inst)
		#set the text of this hboxcont to the name of the spread found in global._layout_states
		cont_inst.get_child(1).get_child(0).text = i
		#infuse the hboxcont with spread info
		cont_inst.set_meta("custom or stock", "stock")
		cont_inst.set_meta("layout_state", global._layout_states.find(i))
		cont_inst.set_meta("total_cards", global._layout_states_cards_in_each[global._layout_states.find(i)])
		cont_inst.set_meta("spread_name", "blank")
		#cont_inst.connect("pass_self_node", cont_inst, "store_parent_node")
		#emit_signal("pass_self_node", self)
		cont_inst.connect("spread_chosen", self, "on_spread_chosen")
		
	#for each spread type that the user has created, create an hbox and layout instance
	if global.runtime_user_data.custom_spreads.keys().size() > 0:
		#for each stored user created spread, do these actions:
		for keys in global.runtime_user_data.custom_spreads.keys():
			var cont_inst : Control = load_a_spread_container.instance()
			#add spread title cont
			$MarginContainer/VBoxContainer.add_child(cont_inst)
			#set spread name equal to key
			cont_inst.get_child(1).get_child(0).text = keys
			#set cards_info_storage variable(a var is in each script attached to layout instance)
			#equal to the values present in user data spreads dictionary
			cont_inst.set_meta("custom or stock", "custom")
			cont_inst.set_meta("layout_state", 5)
			cont_inst.set_meta("total_cards", global.runtime_user_data.custom_spreads[keys].size())
			cont_inst.set_meta("spread_name", keys)
			#cont_inst.connect("pass_self_node", cont_inst, "store_parent_node")
			#emit_signal("pass_self_node", self)
			cont_inst.connect("spread_chosen", self, "on_spread_chosen")
	#hide scroll bars for scroll container
	$MarginContainer.get_v_scrollbar().add_stylebox_override('grabber', StyleBoxEmpty.new())
	$MarginContainer.get_v_scrollbar().add_stylebox_override('scroll', StyleBoxEmpty.new())



func on_spread_chosen(custom_or_stock_spread, position_in_storage, total_cards, spread_key):
	#once user chooses a spread, prepare the singleton for a scene change by storing the chosen
	#spread info in global.variables, then change_scene to choose your cards.tscn
	if custom_or_stock_spread == "custom":
		global.spread_state_set_to = 5
		global.total_cards_in_scene = total_cards
		global.choose_which_spread_key = spread_key
		get_tree().change_scene("res://scenes/DrawingCards/choose your cards.tscn")
	elif custom_or_stock_spread == "stock":
		global.spread_state_set_to = position_in_storage
		global.total_cards_in_scene = total_cards
		get_tree().change_scene("res://scenes/DrawingCards/choose your cards.tscn")
