tool
extends Control

# Configuration exports
export var advance_action = "ui_accept"

# Class imports
onready var ComicPage = preload("page.gd")

# Internal vars
var pages = []
var current_page

func _ready():
	if not Engine.editor_hint:
		self.get_rect().size = get_viewport().get_size()
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
		_on_ComicPage_ended()
		set_process(true)

func _process(delta):
	if Engine.editor_hint:
		self.get_rect().size = get_viewport().get_size()
	if Input.is_action_just_pressed(advance_action):
		current_page.advance()
		pass

func _on_ComicPage_ended():
	if pages.size():
		current_page = pages[0]
		current_page.show()
		pages.pop_front()