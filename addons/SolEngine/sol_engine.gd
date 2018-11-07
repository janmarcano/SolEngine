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

func _ready():
	self.get_rect().size = get_viewport().get_size()
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
			p.hide()
			self.connect("ended", p, "_on_ComicPage_ended")
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