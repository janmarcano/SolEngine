tool
extends Control

# Class imports
onready var PanelContent = preload("panel_content.gd")

# Internal vars
var contents = []
var current_content = 0

# Signals
signal done

func _draw():
	if Engine.editor_hint:
		draw_rect(Rect2(Vector2(0,0), rect_size), Color(224,111,139), false)

func _physics_process(delta):
	update()

func _enter_tree():
	if Engine.editor_hint:
		set_physics_process(true)

func _ready():
	if not Engine.editor_hint:
		if get_child_count() == 0:
			OS.alert("Configuration warning: ComicPanel")
			print("Configuration warning: ComicPanel")
			return
		for c in get_children():
			if not c is PanelContent:
				# TODO: show configuration warning
				OS.alert("Configuration warning: ComicPanel")
				print("Configuration warning: ComicPanel")
				break
			contents.push_back(c)
			c.connect("done", self, "_on_content_done")

func play_content():
	if current_content < contents.size():
		contents[current_content].motion()
	else:
		emit_signal("done")

func _on_content_done():
	current_content += 1
	play_content()