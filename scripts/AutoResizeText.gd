extends RichTextLabel

#CLASS DESCRIPTION:

#This is designed to automatically respond to signals, and can be treated like a node.
#As a saved packedscene, you can attach this script to any RichTextLabel and
#Begin using it like an AutoResizeText Node. See instructions for setting up for
#signals and built in methods if you want to resize this in a dynamic way.

#SIGNALS SETUP :
#There are functions "" and "" which are capable of receiving the desired width and
#height. These will produce the desired dimension with the text at maximum size.
#Then there are the other functions which are useful for different purposes,
#like when wraparound is being used, and you want to auto adjust the height of
#the container to fit multiple lines of text.

#BUILT-IN METHODS :
#Use built in methods for non-instanced use of this node in a scene. Call the
#methods "" and "" directly instead of using a signal, and you provide the same
#args and get the same results. 

#Things I need to do this:
#How to access the font properties from here.
#All related resizing properties and methods
#How size flags can affect this. (rect_min_size for permanent 
#changes, everything else will pop out.)
#Count the lines, the width and height of each line, and
#The rect_size.x and y of self
#Compare the two and see what information you get when you do different things.

onready var non_bbcode_text : String

func _ready():
	bbcode_stripper(non_bbcode_text)
	print(self.get_font("normal_font"))
	pass # Replace with function body.

func bbcode_stripper(non_bbcode_text : String):
	var char_length : int = non_bbcode_text.length()
	print(char_length)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
