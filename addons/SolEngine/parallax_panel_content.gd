tool
extends "panel_content.gd"

const ParallaxContent = preload("parallax_content.gd")

var container
var viewport
var camera
var background
var layers = []

func _enter_tree():
	set_clip_contents(true)
	pass

func _ready():
	if not Engine.editor_hint:
		container = ViewportContainer.new()
		container.stretch = true
		container.rect_size = self.rect_size
		viewport = Viewport.new()
		viewport.transparent_bg = true
		camera = Camera2D.new()
		camera.anchor_mode = Camera2D.ANCHOR_MODE_FIXED_TOP_LEFT
		camera.make_current()
		camera.drag_margin_h_enabled = false
		camera.drag_margin_v_enabled = false
		background = ParallaxBackground.new()
		for c in get_children():
			layers.push_back(c)
	
		for l in layers:
			if l is ParallaxContent:
				var layer = ParallaxLayer.new()
				layer.motion_scale = l.parallax_scale
				self.remove_child(l)
				layer.add_child(l)
				background.add_child(layer)
		viewport.add_child(camera)
		viewport.add_child(background)
		container.add_child(viewport)
		add_child(container)
		motion()
		set_process(true)
	pass

func _process(delta):
#	camera.global_position = get_global_mouse_position()
	pass

func motion():
	var goal_pos = camera.position
	var from_pos = camera.position - intro_movement_distance
	tween.interpolate_property(camera, "position", from_pos, goal_pos, intro_movement_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	opacity_motion()
	tween.start()
#	pass

