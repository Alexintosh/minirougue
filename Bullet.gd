extends Area2D

var travelledDistance = 0

func _physics_process(delta):	
	const SPEED = 1000
	const MAX_RANGE = 1200
	
	
	# We want the bullet to have the same rotation of the gun, so we create a new Vector with the same rotation
	# Because the buller is spawed directly from the gun, we just need to take into consideration the current rotation
	var d = Vector2.RIGHT.rotated(rotation)
	position += d * SPEED * delta
	travelledDistance += SPEED * delta
	
	if travelledDistance > MAX_RANGE:
		# deleted the object
		queue_free()


func _on_body_entered(body):
	queue_free()
	if body.has_method("take_damage"):
		body.take_damage()
