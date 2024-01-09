extends Area2D

func _physics_process(delta):
	var enemiesInRange = get_overlapping_bodies() #this functions get all the enemies in the area
	if enemiesInRange.size() > 0: #why is this not lenghts???
		var target: CharacterBody2D = enemiesInRange.front()
		look_at(target.global_position)
		
