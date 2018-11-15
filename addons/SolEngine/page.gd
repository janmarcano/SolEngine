tool
extends Control

# Class imports
onready var ComicPanel = preload("panel.gd")

# Export vars
export(Color) var background_color = Color(255, 255, 255) setget _on_background_color_change
export(Color) var layout_color = Color(0, 0, 0) setget _on_layout_color_change
export var page_padding = 20
export(AudioStream) var background_music
export var silence_background_music = false

# Internal vars
var panels = []
var current_panel = 0

# Signals
signal done
signal bgm_change

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
	draw_rect(get_rect(), background_color)
	if Engine.editor_hint:
		var size = rect_size
		size.x /= 2
		draw_line(Vector2(size.x,0), Vector2(size.x,size.y), layout_color, 2.0, true)
		var page_rect = Rect2(Vector2(page_padding,page_padding), size-Vector2(page_padding*2,page_padding*2))
		draw_rect(page_rect, layout_color, false)
		page_rect = Rect2(Vector2(size.x+page_padding,page_padding), size-Vector2(page_padding*2,page_padding*2))
		draw_rect(page_rect, layout_color, false)

func start_page():
	if background_music or silence_background_music:
		if silence_background_music:
			background_music = null
		emit_signal("bgm_change", background_music)
	play_panel()

func play_panel():
	if current_panel < panels.size():
		panels[current_panel].play_content()
	else:
		emit_signal("done")

func _on_panel_done():
	current_panel += 1
	play_panel()

func _on_background_color_change(_color):
	background_color = _color
	update()

func _on_layout_color_change(_color):
	layout_color = _color
	update()