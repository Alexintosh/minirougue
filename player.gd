extends CharacterBody2D

signal health_depleted
signal loot_collected
@export var max_health = 100
@export var health: float = 100.00
@export var velocity_multiplier: float = 600

func _ready():
	%HurtBox.connect("body_entered", _on_body_entered)

func _on_body_entered(body): pass
	##print("Collided with body in group:", body.name)

func handle_animation():
	## Animations
	if velocity.length() > 0.0:	
		%HappyBoo.play_walk_animation()
	else:
		%HappyBoo.play_idle_animation()
		
func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var overlapping = %HurtBox.get_overlapping_bodies()
	velocity = direction * velocity_multiplier
	
	handle_collisions(overlapping, delta)
	move_and_slide()
	handle_animation()	
	
func handle_collisions(overlapping_bodies, delta):
	if overlapping_bodies.size() > 0:
		var dmg_rate = 0
		
		#enemies have different damage rates
		for body in overlapping_bodies: 
			#priwnt("dmg_rate", body.to_string() )
			if("damage_rate" in body):
				dmg_rate += body.damage_rate;
			
			handle_loot(body)
			handle_potions(body)
		
		#print("dmg_rate", dmg_rate)
		handle_damage(dmg_rate * delta)

func handle_loot(body):
	if body.is_in_group("loot"):
		body.loot()
		loot_collected.emit(body.value)

func handle_damage(value):
	health -= value
	%ProgressBar.value = health
	
	## Died?
	if health <= 0.0: 
		health_depleted.emit()

func handle_potions(body):
	if body.is_in_group("potion"):
		body.loot()
		health += body.value
		if(health > max_health): 
			health = max_health
