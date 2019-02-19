extends KinematicBody2D

const UP = Vector2(0, -1)
const MAX_SPEED = 200
const ACCELERATION = 50
const GRAVITY = 25
const JUMP_HEIGHT = 30

var life = 100
var motion = Vector2()
var friction = false

var isFalling = false
var startFallingValue
var isDied = false

var jumpTime = 0
var shouldAddToJumpTime = false
var isJumpingNow = false

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	motion.y += GRAVITY
	friction = false
	
	if isDied:
		return
			
	walk()
	
	jump(delta)
		
	takeFallDamage()

	motion = move_and_slide(motion, UP)
	
	if get_pos().y > 2500:
		set_pos(Vector2(get_pos().x, -2000))
		
		
	if get_pos().y < -150 && get_pos().x > 2352:
		set_pos(Vector2(1300 ,get_pos().y))
	
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
	
func jump(delta):
	if Input.is_action_pressed("ui_up"):
		if is_move_and_slide_on_floor():
			isJumpingNow = true
			jumpTime = 0
		else:
			if jumpTime < 0.5:
				jumpTime += delta
			else:
				isJumpingNow = false
	else:
		if isJumpingNow:
			isJumpingNow = false
			
	if isJumpingNow:
		motion.y -= jumpTime * JUMP_HEIGHT
		
	jumpAndFall()
	
	print("shouldAddToJumpTime: ", shouldAddToJumpTime)
	print("jumpTime: ", jumpTime)
	print("motion.y: ", motion.y)
			
		
func jumpAndFall():
	if motion.y < 0:
		get_node("Sprite").play("jump")
	else:
		get_node("Sprite").play("falling")
		
	slide()
		

func slide():
	if friction == true:
		motion.x = lerp(motion.x, 0, 0.05)
		

func takeFallDamage():
	if is_move_and_slide_on_floor():
		if isFalling:
			if get_pos().y - startFallingValue > 450:
				life -= (get_pos().y - startFallingValue - 450) / 3.5
				if life < 0:
					life = 0
				
				get_node("Interface/IntrefaceHolder/bars/life/heartCounter/CenterContainer/Label").set_text(str(int(life) ) )
				get_node("Interface/IntrefaceHolder/bars/life/ProgressBar").set_value(life)
			
			if life <= 0:
				get_node("Timer").start()
				get_node("Sprite").play("died")
				isDied = true
				
			isFalling = false
	else:
		if motion.y > 0 && !isFalling:
			isFalling = true
			startFallingValue = get_pos().y

func _on_Timer_timeout():
	get_tree().change_scene("res://GameOverScreen.tscn")
	
	#if shouldAddToJumpTime:
		#jumpTime += delta
	
	#if is_move_and_slide_on_floor():
		#if Input.is_action_pressed("ui_up"):
			#shouldAddToJumpTime = true
			
	#if !Input.is_action_pressed("ui_up"):
		#if shouldAddToJumpTime == true:
			#motion.y = -jumpTime
			#jumpTime = 0
		#shouldAddToJumpTime = false
		
	#if jumpTime == 700:
		#motion.y = 700
		#shouldAddToJumpTime = false
		#jumpTime = 0
