tool
extends Control

# Class imports
onready var PanelContent = preload("panel_content.gd")

# Export vars
export var delay_before_starting = 0.5

# Internal vars
var contents = []
var current_content = 0
var timer

# Signals
signal done

func _draw():
	if Engine.editor_hint:
		draw_rect(Rect2(Vector2(1,1), rect_size-Vector2(2,2)), Color(21,215,215), false)

func _physics_process(delta):
	update()

func _enter_tree():
	rect_clip_content = true
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
		timer = Timer.new()
		timer.one_shot = true
		timer.wait_time = delay_before_starting
		timer.connect("timeout", self, "_on_Timer_delay_timeout")
		add_child(timer)

func start_content():
	timer.start()

func play_content():
	if current_content < contents.size():
		contents[current_content].motion()
	else:
		emit_signal("done")

func _on_content_done():
	current_content += 1
	play_content()

func _on_Timer_delay_timeout():
	play_content()