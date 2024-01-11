extends Node2D

var score = 0
var mob_spawned = 0
var mob_spawned_slowdown_start = 0
var mob_spawned_slowdown_finish = 0
var mob_slowdown = false
var gameover = false

func _ready():
	spawn_boss()
	spawn()
	spawn()
	spawn()
	spawn()
	

func spawn():	
	mob_spawned += 1
	
	if(mob_spawned % 100 == 0):
		mob_slowdown = true
		mob_spawned_slowdown_start = mob_spawned
		# We slow down spawning mobs during boss fights
		%Timer.wait_time = 2.5
		spawn_boss()
	
	spawn_mob()
	
func spawn_mob():
	var m = preload("res://mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	
	m.global_position = %PathFollow2D.global_position
	
	# Connect signal to change the score.
	m.connect("enemy_dead", self._on_enemy_dead)
	add_child(m)
	
func spawn_boss():
	var m = preload("res://mob_boss.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	
	m.global_position = %PathFollow2D.global_position
	
	# Connect signal to change the score.
	m.connect("enemy_dead", self._on_enemy_dead)
	add_child(m)

func _on_timer_timeout():
	spawn()

func _on_player_health_depleted():
	gameover = true
	%GameOver.get_child(0).get_child(0).text = "Game over \n Score: " + str(score)
	%GameOver.visible = true
	create_restart_timer()
	#get_tree().paused = true
	

func _on_enemy_dead(points, type):
	if gameover: pass
	score += points

	# We reset spawn timer after Boss died
	if(type == "boss"): %Timer.wait_time = 0.35

func create_restart_timer():
	var timer = Timer.new()  # Create a new Timer instance
	timer.wait_time = 2  # Set the timer to wait for 5 seconds
	timer.one_shot = true  # Timer stops after ticking down once
	timer.connect("timeout", self.restart_game)  # Connect the timeout signal
	add_child(timer)  # Add the timer to the current node
	timer.start()  # Start the timer

func restart_game():
	get_tree().reload_current_scene()
