tool
extends Control

export var preview = false setget _on_preview

#enum FadeInModes {}
#export(FadeInModes) var fade_in_mode
export var fade_in_duration = 0.5
export var movement_duration = 0.5
export var movement_relative_initial_position = Vector2(0,0)
export var scaling_duration = 0.25
export var relative_initial_scale = Vector2(1,1)

var tween
var tweens_to_completion

signal done

func _ready():
	if not Engine.editor_hint:
		init()

func init():
	tween = Tween.new()
	tweens_to_completion = 0
	for duration in [fade_in_duration, movement_duration, scaling_duration]:
		if duration > 0:
			tweens_to_completion += 1
	tween.connect("tween_completed", self, "_on_tween_completed")
	add_child(tween)
	modulate = Color(1, 1, 1, 0)

func motion():
	scale_motion()
	position_motion()
	opacity_motion()
	tween.start()
	pass

func scale_motion():
	var goal_scale = self.rect_scale
	var initial_scale = self.rect_scale * relative_initial_scale
	tween.interpolate_property(self, "rect_scale", initial_scale, goal_scale, scaling_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

func position_motion():
	var goal_position = self.rect_position
	var initial_position = self.rect_position + movement_relative_initial_position
	tween.interpolate_property(self, "rect_position", initial_position, goal_position, movement_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

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
		if (preview):
			preview = false
		else:
			emit_signal("done")