extends Node2D

class_name Weapon

export var damage: int = 1

onready var anim = get_node("AnimatedSprite")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func play_animation():
	anim.play("attack")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#
func _on_AnimatedSprite_animation_finished():
	anim.stop()
