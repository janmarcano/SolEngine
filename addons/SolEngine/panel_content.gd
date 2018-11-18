tool
extends Control

# Export vars
export var preview = false setget _on_preview
export var fade_in_duration = 0.5
export var movement_duration = 0.5
export var movement_relative_initial_position = Vector2(0,0)
export var scaling_duration = 0.25
export var relative_initial_scale = Vector2(1,1)
export(AudioStream) var sound_effect
export var sound_effect_volume = 0.0
export(int, "Beginning", "End of Movement", "End of Scaling", "End of Fade In") var sound_effect_play_on = 0

# Internal vars
var tween
var tweens_to_completion
var sfx_player
var sfx_key_dictionary = {
	1 : ':rect_position',
	2 : ':rect_scale',
	3 : ':modulate'
}

# Signals
signal done

func _physics_process(delta):
	if self is TextureRect and self.texture != null:
		self.rect_size = get_texture().get_size()
		self.rect_pivot_offset = get_texture().get_size()/2
	else:
		self.rect_size = get_parent().rect_size

func _enter_tree():
	if Engine.editor_hint:
		set_physics_process(true)

func _ready():
	if not Engine.editor_hint:
		init()

func init():
	if (sound_effect):
		sfx_player = AudioStreamPlayer.new()
		sfx_player.stream = sound_effect
		sfx_player.volume_db = sound_effect_volume
		add_child(sfx_player)
	tween = Tween.new()
	tweens_to_completion = 0
	for duration in [fade_in_duration, movement_duration, scaling_duration]:
		if duration > 0:
			tweens_to_completion += 1
	tween.connect("tween_completed", self, "_on_tween_completed")
	add_child(tween)
	modulate = Color(1, 1, 1, 0)

func motion():
	if sound_effect and sound_effect_play_on == 0:
		sfx_player.play()
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

func play_sound_effect(key):
	if sfx_key_dictionary[sound_effect_play_on] == key:
		sfx_player.play()

func _on_preview(_preview):
	if _preview:
		preview = _preview
		init()
		motion()

func _on_tween_completed(object, key):
	if sfx_player and sound_effect_play_on:
		play_sound_effect(key)
	tweens_to_completion -= 1
	if tweens_to_completion == 0:
		if (preview):
			preview = false
		else:
			emit_signal("done")