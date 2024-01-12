extends Node2D

@export var fast_interval = 1.35
@export var slow_interval = 2.35

var score = 0
var gems = 0
var mobs_alive = 0
var max_mobs_simultaniusly = 50
var mob_spawned = 0
var mob_spawned_slowdown_start = 0
var mob_spawned_slowdown_finish = 0
var mob_slowdown = false
var gameover = false

func _ready():
	spawn()
	add_tress()
	
func spawn():	
	print("mobs_alive", mobs_alive)
	if mobs_alive >= max_mobs_simultaniusly: return
	
	if(mob_spawned % 100 == 0):
		mob_slowdown = true
		mob_spawned_slowdown_start = mob_spawned
		# We slow down spawning mobs during boss fights
		%Timer.wait_time = slow_interval
		#spawn_boss()
	
	spawn_mob()
	
func spawn_mob():
	var m = preload("res://mob.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	
	m.global_position = %PathFollow2D.global_position
	
	# Connect signal to change the score.
	m.connect("enemy_dead", self._on_enemy_dead)
	add_child(m)
	mobs_alive = mobs_alive + 1
	
func spawn_boss():
	var m = preload("res://mob_boss.tscn").instantiate()
	%PathFollow2D.progress_ratio = randf()
	
	m.global_position = %PathFollow2D.global_position
	
	# Connect signal to change the score.
	m.connect("enemy_dead", self._on_enemy_dead)
	add_child(m)
	
	mobs_alive = mobs_alive + 1

func _on_timer_timeout():
	spawn()

func _on_player_health_depleted():
	gameover = true
	%GameOver.get_child(0).get_child(0).text = "Game over \n Score: " + str(score)
	%GameOver.visible = true
	create_restart_timer()
	#get_tree().paused = true

func _on_enemy_dead(points, type, _position):
	if gameover: pass
	mobs_alive = mobs_alive - 1
	score += points

	# We reset spawn timer after Boss died
	if(type == "boss"): %Timer.wait_time = fast_interval
	
	#if randf() > 0.5:
	drop_gem(_position)
		
	#if randf() > 0.7:
	drop_potion(_position)
		
func drop_gem(_position):
	print("dropping gem")
	var gem = preload("res://gem.tscn").instantiate()
	var rand_y = randf_range(10, 150)
	var rand_x = randf_range(10, 150)
	gem.global_position = _position
	gem.global_position.x = gem.global_position.x + rand_x
	gem.global_position.y = gem.global_position.y + rand_y
	call_deferred("add_child", gem)

func drop_potion(_position):
	print("dropping potion")
	var heart = preload("res://heart_loot.tscn").instantiate()
	heart.global_position = _position
	heart.global_position.x = heart.global_position.x - 10
	call_deferred("add_child", heart)
	
func create_restart_timer():
	var timer = Timer.new()  # Create a new Timer instance
	timer.wait_time = 2  # Set the timer to wait for 5 seconds
	timer.one_shot = true  # Timer stops after ticking down once
	timer.connect("timeout", self.restart_game)  # Connect the timeout signal
	add_child(timer)  # Add the timer to the current node
	timer.start()  # Start the timer

func restart_game():
	get_tree().reload_current_scene()

func _on_player_loot_collected(value):
	gems += value
	
	if(gems % 2 == 0) :
		%Player/Gun.decrease_shooting_frequency(0.03)
	print(gems)

func add_tress():
	var viewport_size = get_viewport().content_scale_size

	# Number of trees to create
	var num_trees = 1000
	# Minimum and maximum positions for tree placement
	var min_pos = Vector2(-10000, -10000)
	var max_pos = Vector2(10000, 10000)

	for i in range(num_trees):
		# Instance a new tree
		var tree = preload("res://pine_tree.tscn").instantiate()
		
		# Randomly position the tree
		tree.position = Vector2(
			randf_range(min_pos.x, max_pos.x),
			randf_range(min_pos.y, max_pos.y)
		)

		# Add the tree to the CanvasLayer
		%TreeContainer.add_child(tree)
