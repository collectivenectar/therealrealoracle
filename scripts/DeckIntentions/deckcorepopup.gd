extends Control

onready var tween = get_node("Tween")
onready var parent_storage : Node
signal modal_exit
var _picker = null

func _ready():
	var lenscovermargin : float = 100.0
	$LensCover.margin_bottom = 0.0
	$LensCover.margin_top = lenscovermargin / 2.0
	$LensCover.margin_left = lenscovermargin / 2.0
	$LensCover.margin_right = lenscovermargin / 2.0
	$LensCover.rect_position = Vector2(0 + (lenscovermargin / 2.0), 0.0 + (lenscovermargin))
	if Engine.has_singleton("PhotoPicker"):
		_picker = Engine.get_singleton("PhotoPicker")
		_picker.connect("image_picked", self, "_image_picked")
		_picker.connect("permission_updated", self, "_permission_updated")
		print("registering photo picker")
	else:
		print("no photo picker")

func _image_picked(image):
	var texture : ImageTexture = ImageTexture.new()
	var icon : Node = parent_storage.get_child(0)
	print(icon)
	texture.create_from_image(image)
	icon.texture = texture

func _permission_updated(target, status):
	match (target):
		_picker.PERMISSION_TARGET_PHOTO_LIBRARY:
			print("photo library")
		_picker.PERMISSION_TARGET_CAMERA:
			print("camera")
	
	match (status):
		_picker.PERMISSION_STATUS_UNKNOWN:
			print("unknown")
		_picker.PERMISSION_STATUS_ALLOWED:
			print("allowed")
		_picker.PERMISSION_STATUS_DENIED:
			print("denied")

func _on_Button_button_down():
	_picker.present(_picker.SOURCE_SAVED_PHOTOS_ALBUM);
	_picker.present(_picker.SOURCE_CAMERA_REAR);
	_picker.present(_picker.SOURCE_CAMERA_FRONT);

	print(_picker.permission_status(_picker.PERMISSION_TARGET_CAMERA))
	print(_picker.permission_status(_picker.PERMISSION_TARGET_PHOTO_LIBRARY))

	_picker.request_permission(_picker.PERMISSION_TARGET_CAMERA)
	_picker.request_permission(_picker.PERMISSION_TARGET_PHOTO_LIBRARY)


func _on_generatenewseed_button_up():
	_picker.present(_picker.SOURCE_SAVED_PHOTOS_ALBUM);
	_picker.present(_picker.SOURCE_CAMERA_REAR);
	_picker.present(_picker.SOURCE_CAMERA_FRONT);

	print(_picker.permission_status(_picker.PERMISSION_TARGET_CAMERA))
	print(_picker.permission_status(_picker.PERMISSION_TARGET_PHOTO_LIBRARY))

	_picker.request_permission(_picker.PERMISSION_TARGET_CAMERA)
	_picker.request_permission(_picker.PERMISSION_TARGET_PHOTO_LIBRARY)
	
	
	# 1 Popup of prompt - 'If you want to generate a new seed, just snap a photo
	# of something that represents your question, or your intention. This will be
	# used to generate a fancy number - which will come in handy when you shuffle.
	# So, in a way, each time you shuffle, this image will be determining which 
	# cards come out.
	
	# side info (? button) :
	# if a real physical deck isn't being shuffled when you draw cards, then you're
	# only getting what's called 'pseudorandom.' Without getting into mathematics,
	# this only tries to mimic the 'randomness' that exists in the physical world.
	# So, the only way to get truly random results each time is to use data from the real 
	# random world. The easiest way to do this is to take a picture, which has tons of 
	# real, physical world randomness. It works best when your the images you
	#  use actually photograph the subject of your questions or intentions you 
	# have when you want to sit down and use the deck. You could start with a 
	# selfie, for self development, or any other image you want to focus on when 
	# pulling cards from this deck. You don't have to change the core every time you
	# draw a card, and at the most you could change the core every time you sit down to 
	# do readings for yourself, if you want to reflect the moment you are in and 
	# the questions you have.
	
	# 2 User selects continue. Second prompt, to maybe point out what the user
	# needs to do to snap a picture.
	
	# 3 User clicks a button/snaps a picture (here may be the option to change
	#camera feeds, or maybe to consider just accessing a modal popup for camera
	#access? find out if there is one.
	
	# 4 The image is saved, loaded as the background image for the core
	
	# 5 The image data is hashed, a new key is generated.
	
	# 6 The hash key is store as the first in an array of dicts. Each dict has
	# the hash key, the user generated name of the key, and the date the key
	# was generated.
	
	# 7 Confirm prompt - 'Is this what you want to use to shuffle for now?'
	# yes || no 
	
	# RNG seed in global script is changed from random() source to hash key source.
	# Image and hash seed are stored in user://data - saved cores
	
	pass # Replace with function body.


func _on_previousseed_button_up():
	#this is still a maybe feature - Debating about if storing past hashes
	#is even helpful to someone who needs honesty?
	
	#I'll call it 'seed recovery' - I can recover the last ten seeds, but only the
	#random seed code, not the original image. There are limits to this 'futuristic
	#technology' I think saving the deck history could be useful, but really sort
	#of inconvenient. Could lead to good experimentation though.
	
	#navigate through previous 10 seeds
	#popup to show dates and names of hashes
	#select hash through confirmation (ok/no)
	#save current hash (name + date + hash number)
	#replace current seed with one from storage
	#replace image with 'old seed' placeholder
	#set seed up to be used in shuffle()
	pass # Replace with function body.


func _on_startoverdeckorder_button_up():
	#set deck order to numerical order. Deck will be shuffled according to customer seed or
	#pseudorandom provided.
	pass # Replace with function body.


func _on_exit_modal_button_up():
	emit_signal("modal_exit")
	print("tried")
