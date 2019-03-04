extends Control

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("pause"):
		switchingBetweenPauseAndGame()

func _on_ResumeButton_pressed():
	switchingBetweenPauseAndGame()

		
func switchingBetweenPauseAndGame():
	var isPaused = get_tree().is_paused()
		
	get_tree().set_pause(!isPaused)
	set_hidden(isPaused)


func _on_MainMenuButton1_pressed():
	saveAndLoad.save_game()
	get_tree().set_pause(false)
	get_tree().change_scene("res://Start menu.tscn")
