tool
extends Control

# Class imports
onready var ComicPanel = preload("panel.gd")

# Internal vars
var panels = []
var current_panel = 0

# Signals
signal done

func _physics_process(delta):
	self.rect_size = get_viewport().get_visible_rect().size

func _enter_tree():
	if Engine.editor_hint:
		set_physics_process(true)

func _ready():
	if not Engine.editor_hint:
		if get_child_count() == 0:
			OS.alert("Configuration warning: ComicPage")
			print("Configuration warning: ComicPage")
			return
		for p in get_children():
			if not p is ComicPanel:
				# TODO: show configuration warning
				OS.alert("Configuration warning: ComicPage")
				print("Configuration warning: ComicPage")
				break
			panels.push_back(p)
			p.connect("done", self, "_on_panel_done")

func _draw():
	var size = rect_size
#	print(size)
	draw_line(Vector2(size.x/2,0), Vector2(size.x/2,size.y), Color(0,0,0), 1.0, true)

func play_panel():
	if current_panel < panels.size():
		panels[current_panel].play_content()
	else:
		emit_signal("done")

func _on_panel_done():
	current_panel += 1
	play_panel()