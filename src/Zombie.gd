extends KinematicBody2D

const GRAVITY = 35
export(int) var speed = 35
export(int) var vitality = 100
export(Vector2) var size = Vector2(1, 1)

var direction = 1 
var motion = Vector2()

var rayCastFloor
var rayCastWall

func _ready():
	set_fixed_process(true)
	get_node("AnimatedSprite").play("Walk")
	rayCastFloor = get_node("RayCastToFloor")
	rayCastWall = get_node("RayCastToWall")
	setSize()
	
func setSize():
	set_scale(size)
	
func _fixed_process(delta):
	motion.x = speed * direction
	motion.y += GRAVITY
		
	if direction == 1:
		get_node("AnimatedSprite").set_flip_h(false)
	else:
		get_node("AnimatedSprite").set_flip_h(true)
		
	if is_move_and_slide_on_floor():
		motion.y = 0
		
	if rayCastFloor.is_colliding() == false:
		reverseRayCasts()
	if rayCastWall.is_colliding():
		reverseRayCasts()
		
	move_and_slide(motion, Vector2(0, -1))

func reverseRayCasts():
	direction *= -1
	
	rayCastFloor.set_pos(-rayCastFloor.get_pos())
	rayCastWall.set_pos(-rayCastWall.get_pos())
	
	if direction == 1:
		rayCastWall.set_rot(0)
	else:
		rayCastWall.set_rot(180)

func _on_hitbox_area_enter( area ):
	if area.is_in_group("fireballs"):
		vitality -= 30
		_die()
		
func _die():
	if vitality <= 0:
		if size.x > 1 && size.y > 1:
			var shake = size.x * size.y
			get_tree().get_root().get_node("World/screenShake").screenShake(shake / 8, shake, 100)
		queue_free()
