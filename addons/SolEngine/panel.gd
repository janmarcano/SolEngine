#tool
extends Control

# Class imports
onready var PanelContent = preload("panel_content.gd")

# Internal vars
var contents = []
var current_content = 0

# Signals
signal done

func _ready():
	if get_child_count() == 0:
		OS.alert("Configuration warning: ComicPanel")
		print("Configuration warning: ComicPanel")
		return
	for p in get_children():
		if not p is PanelContent:
			# TODO: show configuration warning
			OS.alert("Configuration warning: ComicPanel")
			print("Configuration warning: ComicPanel")
			break
#		p.hide()
		contents.push_back(p)
#	_on_ComicPanel_ended()
	set_process(true)

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		advance()

func advance():

	pass