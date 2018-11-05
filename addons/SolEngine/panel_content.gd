#tool
extends Control

export var preview = false setget _on_preview

#enum FadeInModes {}
#export(FadeInModes) var fade_in_mode
export var fade_in_duration = 0.5
export var intro_movement_distance = Vector2(0,0)
export var intro_movement_duration = 0.5

var tween
var tweens_to_completion

func _ready():
	if not Engine.editor_hint:
		init()

func init():
	tween = Tween.new()
	tweens_to_completion = 2
	tween.connect("tween_completed", self, "_on_tween_completed")
	add_child(tween)
	modulate = Color(1, 1, 1, 0)

func motion():
#	tween.interpolate_property(self, position
	opacity_motion()
	tween.start()
	pass

func opacity_motion():
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), fade_in_duration, Tween.TRANS_SINE, Tween.EASE_OUT)

func _on_preview(_preview):
	if _preview:
		preview = _preview
		init()
		motion()

func _on_tween_completed(object, key):
	tweens_to_completion -= 1
	if tweens_to_completion == 0:
		print('completion!')
		preview = false