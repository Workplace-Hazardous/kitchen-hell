extends KinematicBody2D

var curHp : int = 10
var maxHp : int = 10
var moveSpeed : int = 250
var damage : int = 1

var gold : int = 0

var curLevel : int = 0
var curXp : int = 0
var xpToNextLevel : int = 50
var xpToLevelIncreaseRate : float = 1.2

var interactDist : int = 70

var vel : Vector2 = Vector2()
var facingDir : Vector2 = Vector2()
var facingDir2 : Vector2 = Vector2()
var facingAngleDeg : int = 0;

onready var rayCast = get_node("RayCast2D")
onready var anim = get_node("AnimatedSprite")
onready var ui = get_node("/root/MainScene/CanvasLayer/UI")
onready var weaponManager = get_node("WeaponManager")

func _ready ():
	ui.update_level_text(curLevel)
	ui.update_health_bar(curHp, maxHp)
	ui.update_xp_bar(curXp, xpToNextLevel)
	ui.update_gold_text(gold)
	
	

func _physics_process (delta):
	vel = Vector2()
	facingDir2 = get_global_mouse_position()
	var facing_angle_rad = atan2(position.y - get_global_mouse_position().y, 
		position.x - get_global_mouse_position().x)
	facingAngleDeg = int((rad2deg(facing_angle_rad)) + 360) % 360
	#inputs
	if Input.is_action_pressed("move_up"):
		vel.y -= 1
		facingDir = Vector2(0,-1)
	if Input.is_action_pressed("move_down"):
		vel.y += 1
		facingDir = Vector2(0,1)
	if Input.is_action_pressed("move_left"):
		vel.x -= 1
		facingDir = Vector2(-1,0)
	if Input.is_action_pressed("move_right"):
		vel.x += 1
		facingDir = Vector2(1,0)
	
	#normalize speed
	vel = vel.normalized()
	
	#move Player
	move_and_slide(vel * moveSpeed)

	manage_animations()

func manage_animations ():
	if facingAngleDeg >= 315 || facingAngleDeg <= 45:
		if (vel.x == 0 && vel.y == 0):
			play_animation("IdleLeft")
		else:
			play_animation("MoveLeft")
	elif facingAngleDeg > 45 && facingAngleDeg <= 135:
		if (vel.x == 0 && vel.y == 0):
			play_animation("IdleUp")
		else:
			play_animation("MoveUp")
	elif facingAngleDeg > 135 && facingAngleDeg <= 225:
		if (vel.x == 0 && vel.y == 0):
			play_animation("IdleRight")
		else:
			play_animation("MoveRight")
	elif facingAngleDeg > 225 && facingAngleDeg < 315:
		if (vel.x == 0 && vel.y == 0):
			play_animation("IdleDown")
		else:
			play_animation("MoveDown")

func _input (event):
	if event.is_action_pressed("attack"):
		weaponManager.attack()
	
func _process (delta):
	if Input.is_action_just_pressed("interact"):
		try_interact()
		
func try_interact():
	
	rayCast.cast_to = facingDir * interactDist
	
	if rayCast.is_colliding():
		if rayCast.get_collider() is KinematicBody2D:
			rayCast.get_collider().take_damage(damage)
		elif rayCast.get_collider().has_method("on_interact"):
			rayCast.get_collider().on_interact(self)
		
func play_animation (anim_name):
	if anim.animation != anim_name:
		anim.play(anim_name)


func give_xp (amount):
	curXp += amount
	ui.update_xp_bar(curXp, xpToNextLevel)
	
	if curXp > xpToNextLevel:
		level_up()

func level_up():
	var overflowXp = curXp - xpToNextLevel
	xpToNextLevel *= xpToLevelIncreaseRate
	curXp = overflowXp
	curLevel += 1
	
	ui.update_xp_bar(curXp, xpToNextLevel)
	ui.update_level_text(curLevel)
	
func give_gold (amount):
	gold += amount
	ui.update_gold_text(gold)
	
func take_damage (dmgToTake):
	curHp -= dmgToTake
	ui.update_health_bar(curHp,maxHp)
	
	if curHp <= 0:
		die()
		
func die():
	get_tree().reload_current_scene()

