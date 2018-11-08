tool
extends "panel_content.gd"

const ParallaxContent = preload("parallax_content_layer.gd")

var container
var viewport
var camera
var background
var layers = []

func init():
	sfx_key_dictionary = { 
		1 : ':position',
		2 : ':zoom',
		3 : ':modulate'
	}
	.init()
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
			if not Engine.editor_hint:
				self.remove_child(l)
			layer.add_child(l)
			background.add_child(layer)
	viewport.add_child(camera)
	viewport.add_child(background)
	container.add_child(viewport)
	add_child(container)
	set_process(true)

func scale_motion():
	var goal_zoom = camera.zoom
	var initial_zoom = camera.zoom * relative_initial_scale
	tween.interpolate_property(camera, "zoom", initial_zoom, goal_zoom, scaling_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

func position_motion():
	var goal_position = camera.position
	var initial_position = camera.position + movement_relative_initial_position
	tween.interpolate_property(camera, "position", initial_position, goal_position, movement_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
