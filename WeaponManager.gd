extends Node2D

onready var currentWeapon = $Knife

func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	currentWeapon.look_at(get_global_mouse_position())

func attack():
	if (currentWeapon is Weapon):
		currentWeapon.play_animation()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
