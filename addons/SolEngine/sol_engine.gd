tool
extends Control

# Configuration exports
export var advance_action = "ui_accept"

# Class imports
onready var ComicPage = preload("page.gd")

# Internal vars
var pages = []
var current_page = 0
var is_page_playing = true

func _physics_process(delta):
	self.rect_size = get_viewport().get_visible_rect().size

func _enter_tree():
	if Engine.editor_hint:
		set_physics_process(true)

func _ready():
	if not Engine.editor_hint:
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
		play_page()

func _input(event):
	if event.is_action_pressed(advance_action) and not is_page_playing:
		finish_page()

func play_page():
	if current_page < pages.size():
		var page = pages[current_page]
		page.show()
		page.play_panel()

func finish_page():
	pages[current_page].hide()
	current_page += 1
	play_page()

func _on_page_done():
	is_page_playing = false