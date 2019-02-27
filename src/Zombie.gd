extends KinematicBody2D

const SPEED = 22
var startPosX
var vitality = 100

enum {IDLE, RIGHT, LEFT}
var moveState = RIGHT

var motion = Vector2()

func _ready():
	set_fixed_process(true)
	startPosX = get_pos().x
	get_node("AnimatedSprite").play("Walk")
	
func _fixed_process(delta):
	if ((get_pos().x > startPosX + 70) && (moveState == RIGHT)):
		moveState = LEFT
	if ((get_pos().x < startPosX) && (moveState == LEFT)):
		moveState = RIGHT
		
	if moveState == RIGHT:
		motion.x = 25
		get_node("AnimatedSprite").set_flip_h(false)
	elif moveState == LEFT:
		motion.x = -25
		get_node("AnimatedSprite").set_flip_h(true)
	
	move_and_slide(motion)

func _on_hitbox_area_enter( area ):
	if area.is_in_group("fireballs"):
		vitality -= 30
		_die()
		
func _die():
	if vitality <= 0:
		queue_free()
