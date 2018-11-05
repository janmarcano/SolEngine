tool
extends EditorPlugin

func _enter_tree():
	add_custom_type("SolEngine", "Control", preload("sol_engine.gd"), preload("icon.png"))
	add_custom_type("ComicPage", "Control", preload("page.gd"), preload("icon.png"))
	add_custom_type("ComicPanel", "Control", preload("panel.gd"), preload("icon.png"))
	add_custom_type("PanelContent", "TextureRect", preload("panel_content.gd"), preload("icon.png"))
	add_custom_type("ParallaxPanelContent", "Control", preload("parallax_panel_content.gd"), preload("icon.png"))
	add_custom_type("ParallaxContentLayer", "TextureRect", preload("parallax_content_layer.gd"), preload("icon.png"))
	add_custom_type("SpeechBubble", "NinePatchRect", preload("speech_bubble.gd"), preload("icon.png"))
	pass

func _exit_tree():
	remove_custom_type("SolEngine")
	remove_custom_type("ComicPage")
	remove_custom_type("ComicPanel")
	remove_custom_type("PanelContent")
	remove_custom_type("ParallaxPanelContent")
	remove_custom_type("ParallaxContentLayer")
	remove_custom_type("SpeechBubble")
	pass