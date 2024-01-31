extends Node2D

class_name Weapon

export var damage: int = 1
export var center: Vector2 = Vector2(0, 0)


onready var anim = get_node("AnimatedSprite")
onready var hitbox = get_node("HitboxComponent/CollisionShape2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_animation():
	hitbox.set_disabled(false)
	anim.play("attack")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_AnimatedSprite_animation_finished():
	hitbox.set_disabled(true)
	anim.stop()
