extends Area2D

func _physics_process(delta):
	var enemiesInRange = get_overlapping_bodies() #this functions get all the enemies in the area
	if enemiesInRange.size() > 0: #why is this not lenghts???
		var target: CharacterBody2D = enemiesInRange.front()
		look_at(target.global_position)
		
func shoot():
	const BULLET = preload("res://bullet.tscn")
	var nb = BULLET.instantiate() # new bullet
	nb.global_position = %ShootingPoint.global_position
	nb.global_rotation = %ShootingPoint.global_rotation
	%ShootingPoint.add_child(nb)

func _on_timer_timeout():
	shoot()
