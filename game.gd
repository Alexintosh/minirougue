extends Node2D

func _ready():
	spawn_mob()
	spawn_mob()
	spawn_mob()
	spawn_mob()
	spawn_mob()
	spawn_mob()
	spawn_mob()

func spawn_mob():
	var m = preload("res://mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	
	m.global_position = %PathFollow2D.global_position
	add_child(m)


func _on_timer_timeout():
	spawn_mob()


func _on_player_health_depleted():
	%GameOver.visible = true
	get_tree().paused = true
