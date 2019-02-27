extends Area2D

const SPEED = 570
var velocity = Vector2()
var direction = 1


func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	
func _set_fireball_direction(dir):
	direction = dir
	if dir == -1:
		get_node("Sprite").flip_h = true
	elif dir == 1:
		get_node("Sprite").flip_h = false

func _on_VisibilityNotifier2D_exit_screen():
	queue_free()

func _on_fireball_body_enter( body ):
	queue_free()
