extends Area2D

const SPEED = 570
var velocity = Vector2()

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	velocity.x = SPEED * delta
	translate(velocity)

func _on_VisibilityNotifier2D_exit_screen():
	queue_free()
