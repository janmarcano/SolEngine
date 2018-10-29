#tool
extends Control

# Class imports
onready var ComicPanel = preload("panel.gd")

# Internal vars
var panels = []
var current_panel

# Signals
signal ended

func _ready():
	if get_child_count() == 0:
		OS.alert("Configuration warning: ComicPage")
		print("Configuration warning: ComicPage")
		return
	for p in get_children():
		if not p is ComicPanel:
			# TODO: show configuration warning
			OS.alert("Configuration warning: ComicPage")
			print("Configuration warning: ComicPage")
			break
#		p.hide()
		panels.push_back(p)
#	_on_ComicPanel_ended()
	set_process(true)

func advance():
	pass