extends CharacterBody2D

signal health_depleted
var health: float = 100.00

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 600
	move_and_slide()

	## Animations
	if velocity.length() > 0.0:	
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
		
	
	## Hitbox
	const DAMAGE_RATE = 10.0
	var overllapping = %HurtBox.get_overlapping_bodies()
	
	if overllapping.size() > 0:
		var dmg_rate = 0
		
		#enemies have different damage rates
		for body in overllapping: dmg_rate += body.damage_rate;
		
		print("dmg_rate", dmg_rate)
		health -= dmg_rate * delta
		%ProgressBar.value = health
		
		## Died?
		if health <= 0.0: 
			health_depleted.emit()
