extends KinematicBody2D

const SPEED = 60#22
const GRAVITY = 35

var vitality = 100
var direction = 1 
var motion = Vector2()

var rayCastFloor
var rayCastWall

func _ready():
	set_fixed_process(true)
	get_node("AnimatedSprite").play("Walk")
	rayCastFloor = get_node("RayCastToFloor")
	rayCastWall = get_node("RayCastToWall")
	
func _fixed_process(delta):
	motion.x = SPEED * direction
	motion.y += GRAVITY
		
	if direction == 1:
		get_node("AnimatedSprite").set_flip_h(false)
	else:
		get_node("AnimatedSprite").set_flip_h(true)
		
	if is_move_and_slide_on_floor():
		motion.y = 0
		
	if rayCastFloor.is_colliding() == false:
		direction *= -1
		rayCastFloor.set_pos(-rayCastFloor.get_pos())
		
	if rayCastWall.is_colliding():
		print("is colliding with wall")
		direction *= -1
		#if direction == 1:
		#	rayCastWall.set_rot(0)
		#else:
		#	rayCastWall.set_rot(180)
	
	move_and_slide(motion, Vector2(0, -1))

func _on_hitbox_area_enter( area ):
	if area.is_in_group("fireballs"):
		vitality -= 30
		_die()
		
func _die():
	if vitality <= 0:
		queue_free()
