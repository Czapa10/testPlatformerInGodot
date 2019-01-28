extends KinematicBody2D

const UP = Vector2(0, -1)
const MAX_SPEED = 200
const ACCELERATION = 50
const GRAVITY = 20
const JUMP_HEIGHT = 700

var motion = Vector2()
var friction = false

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	motion.y += GRAVITY
	friction = false
			
	walk()
	
	if is_move_and_slide_on_floor():
		jump()
	else:
		fall()
		slide()

	motion = move_and_slide(motion, UP)
	
##############################################################################
	
func walk():
	if Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
		
		get_node("Sprite").set_flip_h(true)
		get_node("Sprite").play("run")
		
	elif Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
		
		get_node("Sprite").set_flip_h(false)
		get_node("Sprite").play("run")
		
	else:
		friction = true
		get_node("Sprite").play("idle")
	
func jump():
	if Input.is_action_pressed("ui_up"):
			motion.y = -JUMP_HEIGHT
	if friction == true:
		motion.x = lerp(motion.x, 0, 0.2)
		
func fall():
	if motion.y < 0:
		get_node("Sprite").play("jump")
	else:
		get_node("Sprite").play("falling")
		

func slide():
	if friction == true:
		motion.x = lerp(motion.x, 0, 0.05)