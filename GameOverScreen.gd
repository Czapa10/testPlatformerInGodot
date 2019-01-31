extends Control

func _on_PlayAgainButton_pressed():
	get_tree().change_scene("res://World.tscn")

func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://Start menu.tscn")
