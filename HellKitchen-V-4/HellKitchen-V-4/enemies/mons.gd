extends CharacterBody2D

@export var speed = 20
@export var limit = 0.5
@export var endPoint: Marker2D

@onready var animations = $AnimationPlayer

var startPosition: Vector2
var endPosition: Vector2

var isDead: bool = false

var playerChase = false
var player = null

func _ready():
	startPosition = position
	endPosition = endPoint.global_position

func changeDirection():
	var tempEnd: Vector2 = endPosition
	endPosition = startPosition
	startPosition = tempEnd

func updateVelocity():
	var moveDirection: Vector2 = endPosition - position
	if moveDirection.length() < limit:
		position =  endPosition
		#moveDirection = Vector2(0,0)
		changeDirection()
	
	velocity = moveDirection.normalized()*speed
	
func updateAnimation():	
	if velocity.length() == 0:
		if animations.is_playing():
			animations.stop()
	else:
		var direction: String = "Down"
		if velocity.x < 0:  direction = "Left"
		elif velocity.x > 0: direction = "Right"
		elif velocity.y < 0: direction = "Up"
		
		animations.play("walk"+direction)	
	
func _physics_process(delta):
	if isDead: return
	
	if (playerChase):
		position += (player.position - position)/50
		move_and_collide(Vector2(0,0))
	else:
		updateVelocity()
		move_and_slide()
		updateAnimation()
	



func _on_hurt_box_area_entered(area):
	if area == $hitBox: return
	print_debug("hurt!! mon")
	$hitBox.set_deferred("monitorable", false)
	$CollisionShape2D.set_deferred("monitorable", false)
	isDead = true
	animations.play("deathAnimation")
	await animations.animation_finished
	queue_free()


func _on_hurt_box_area_exited(area):
	pass # Replace with function body.


func _on_detection_area_body_entered(body):
	print(body)
	if (body.name == "Player"):
		player = body
		playerChase = true


func _on_detection_area_body_exited(body):
	if (body.name == "Player"):
		player = null
		playerChase = false

	
