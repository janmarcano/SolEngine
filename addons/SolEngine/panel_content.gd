#tool
extends Control

export var preview = false

#enum FadeInModes {}
#export(FadeInModes) var fade_in_mode
export var fade_in_duration = 0.5
export var intro_movement_distance = Vector2(0,0)
export var intro_movement_duration = 0.5

var tween

func _ready():
	tween = Tween.new()
	add_child(tween)
	modulate = Color(1, 1, 1, 0)
	pass

func motion():
#	tween.interpolate_property(self, position
	opacity_motion()
	tween.start()
	pass

func opacity_motion():
	tween.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), fade_in_duration, Tween.TRANS_SINE, Tween.EASE_OUT)