extends KinematicBody2D

const UP = Vector2(0, -1)
const MAX_SPEED = 200
const ACCELERATION = 50
const GRAVITY = 35
const JUMP_HEIGHT = 30

const FIREBALL_SCENE = preload("res://fireball.tscn")
var isReadyToShotFireball = true

var motion = Vector2()
var friction = false

var isFalling = false
var startFallingValue
var isDied = false
var damageWasJustTaken = false

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
		
	takeDamage()
	
	fireballs()

	motion = move_and_slide(motion, UP)
	
	antichamber()
	
##############################################################################
	
func walk():	
	if Input.is_action_pressed("ui_left"):
		motion.x = max(motion.x - ACCELERATION, -MAX_SPEED)
		
		get_node("Sprite").set_flip_h(true)
		get_node("Sprite").play("run")
		
		if sign (get_node("Position2D").get_pos().x) == 1:
			var posX = get_node("Position2D").get_pos().x
			get_node("Position2D").set_pos(Vector2(-posX, get_node("Position2D").get_pos().y))
		
	elif Input.is_action_pressed("ui_right"):
		motion.x = min(motion.x + ACCELERATION, MAX_SPEED)
		
		get_node("Sprite").set_flip_h(false)
		get_node("Sprite").play("run")
		
		if sign (get_node("Position2D").get_pos().x) == -1:
			var posX = get_node("Position2D").get_pos().x
			get_node("Position2D").set_pos(Vector2(-posX, get_node("Position2D").get_pos().y))
			
		
	else:
		friction = true
		motion.x = lerp(motion.x, 0, 0.2)
		get_node("Sprite").play("idle")
	
func jump(delta):
	if Input.is_action_pressed("ui_up"):
		if is_move_and_slide_on_floor():
			isJumpingNow = true
			jumpTime = 0
		else:
			if jumpTime < 0.13:
				jumpTime += delta
			else:
				isJumpingNow = false
	else:
		if isJumpingNow:
			isJumpingNow = false
			
	if isJumpingNow:
		motion.y =  -(JUMP_HEIGHT * 220 * jumpTime)
		
	if !is_move_and_slide_on_floor():
		jumpAndFall()
			
		
func jumpAndFall():
	if motion.y < 0:
		get_node("Sprite").play("jump")
	else:
		get_node("Sprite").play("falling")
		
	slide()
		

func slide():
	if friction == true:
		motion.x = lerp(motion.x, 0, 0.05)
		
func takeDamage():
	takeFallDamage()
	
	if playerData.vitality < 0:
		playerData.vitality = 0
		
	get_node("Interface/IntrefaceHolder/bars/life/heartCounter/CenterContainer/Label").set_text(str(int(playerData.vitality) ) )
	get_node("Interface/IntrefaceHolder/bars/life/ProgressBar").set_value(playerData.vitality)
		
	if playerData.vitality <= 0:
		get_node("Timer").start()
		get_node("Sprite").play("died")
		isDied = true
	

func takeFallDamage():
	if is_move_and_slide_on_floor():
		if isFalling:
			if get_pos().y - startFallingValue > 450:
				playerData.vitality -= (get_pos().y - startFallingValue - 450) / 3.5	
				isFalling = false
	else:
		if motion.y > 0 && !isFalling:
			isFalling = true
			startFallingValue = get_pos().y
			

func _on_Timer_timeout():
	get_tree().change_scene("res://GameOverScreen.tscn")
	
func antichamber():
	if get_pos().y > 2500:
		set_pos(Vector2(get_pos().x, -2000))
		
	if get_pos().y < -150 && get_pos().x > 2352:
		set_pos(Vector2(1300 ,get_pos().y))
		
func fireballs():
	if Input.is_action_pressed("shoot_fireball") && isReadyToShotFireball:
		var fireball = FIREBALL_SCENE.instance()
		
		fireball.set_pos(get_node("Position2D").get_global_pos())
		if sign (get_node("Position2D").get_pos().x) == 1:
			fireball._set_fireball_direction(1)
		else:
			fireball._set_fireball_direction(-1)
			
		get_parent().add_child(fireball)
		
		get_node("FireBallTimer").start()
		isReadyToShotFireball = false
		
func _on_FireBallTimer_timeout():
	isReadyToShotFireball = true

func _on_hitBox_body_enter( body ):
	if body.is_in_group("zombie"):
		playerData.vitality -= 40
		motion.x += 1700 * (-1 if body.get_pos().x > get_pos().x else 1)
		motion.y -= 400
