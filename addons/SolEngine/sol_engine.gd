tool
extends Control

# Configuration exports
export var advance_action = "ui_accept"

# Class imports
onready var ComicPage = preload("page.gd")

# Constants
const MAX_BGM_VOLUME = -6

# Enums
enum BGMState {SILENT, PLAYING, FADING_OUT}

# Internal vars
var pages = []
var current_page = 0
var is_page_playing = true
var bgm_player
var current_bgm = null
var bgm_status = SILENT
var tween

func _physics_process(delta):
	self.rect_size = get_viewport().get_visible_rect().size

func _enter_tree():
	if Engine.editor_hint:
		set_physics_process(true)

func _ready():
	if not Engine.editor_hint:
		bgm_player = AudioStreamPlayer.new()
		bgm_player.volume_db = MAX_BGM_VOLUME
		tween = Tween.new()
		tween.connect("tween_completed", self, "_on_tween_completed")
		if get_child_count() == 0:
			OS.alert("Configuration warning: SolEngine")
			print("Configuration warning: SolEngine")
			return
		for p in get_children():
			if not p is ComicPage:
				# TODO: show configuration warning
				OS.alert("Configuration warning: SolEngine")
				print("Configuration warning: SolEngine")
				break
			pages.push_back(p)
			p.hide()
			p.connect("done", self, "_on_page_done")
			p.connect("bgm_change", self, "_on_bgm_change")
		add_child(bgm_player)
		add_child(tween)
		play_page()

func _input(event):
	if event.is_action_pressed(advance_action) and not is_page_playing:
		finish_page()

func play_page():
	if current_page < pages.size():
		var page = pages[current_page]
		page.show()
		page.start_page()

func finish_page():
	pages[current_page].hide()
	current_page += 1
	play_page()

func _on_page_done():
	is_page_playing = false

func _on_bgm_change(new_bgm):
	current_bgm = new_bgm
	if bgm_status == SILENT:
		bgm_status = PLAYING
		bgm_player.stream = current_bgm
		bgm_player.play()
	else:
		bgm_status = FADING_OUT
		tween.interpolate_property(bgm_player, "volume_db", MAX_BGM_VOLUME, -80, 1.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)

func _on_tween_completed():
	bgm_player.stop()
	bgm_player.stream = current_bgm
	if current_bgm:
		bgm_status = PLAYING
		bgm_player.volume_db = MAX_BGM_VOLUME
		bgm_player.play()
	else:
		bgm_status = SILENT