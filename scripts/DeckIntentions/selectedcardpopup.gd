extends Control
signal popup_node_path(path)

func _ready():
	emit_signal("popup_node_path", self)

func load_texture(texturepath):
	$ScrollContainer/VBoxContainer/TextureRect.texture = texturepath

func load_text(textpath):
	$ScrollContainer/VBoxContainer/RichTextLabel.text = textpath
