extends Node2D

var currentShakePriority = 0

func _ready():
	pass
	
func moveCamera(vector):
	get_parent().get_node("player/Camera2D").set_offset(Vector2(rand_range(-vector.x, vector.x), rand_range(-vector.y, vector.y)))

func screenShake(shake_lenght, shake_power, shake_priority):
	if shake_priority > currentShakePriority:
		currentShakePriority = shake_priority
		print("screen shake")
		get_node("tween").interpolate_method(self, "moveCamera", Vector2(shake_power, shake_power), Vector2(0, 0), shake_lenght, Tween.TRANS_SINE, Tween.EASE_OUT, 0)
		get_node("tween").start()

func _on_tween_tween_complete( object, key ):
	currentShakePriority = 0
