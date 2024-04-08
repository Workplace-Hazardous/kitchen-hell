extends "res://items/collectable.gd"

@onready var animation = $AnimationPlayer

func collect():
	animation.play("pickUp")
	await animation.animation_finished
	super.collect()
