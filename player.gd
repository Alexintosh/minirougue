extends CharacterBody2D

signal health_depleted
signal loot_collected
@export var max_health = 100
@export var health: float = 100.00

func _ready():
	%HurtBox.connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	print("Collided with body in group:", body.name)

func handle_animation():
	## Animations
	if velocity.length() > 0.0:	
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
		
func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * 600
	move_and_slide()
	handle_animation()
	
	## Hitbox
	const DAMAGE_RATE = 10.0
	var overllapping = %HurtBox.get_overlapping_bodies()
	
	if overllapping.size() > 0:
		var dmg_rate = 0
		
		#enemies have different damage rates
		for body in overllapping: 
			#priwnt("dmg_rate", body.to_string() )
			if("damage_rate" in body):
				dmg_rate += body.damage_rate;
			
			if body.is_in_group("loot"):
				body.loot()
				loot_collected.emit(body.value)
				
			if body.is_in_group("potion"):
				body.loot()
				health += body.value
				if(health > max_health): 
					health = max_health
		
		#print("dmg_rate", dmg_rate)
		health -= dmg_rate * delta
		%ProgressBar.value = health
		
		## Died?
		if health <= 0.0: 
			health_depleted.emit()
