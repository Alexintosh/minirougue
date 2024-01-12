#extends CharacterBody2D
extends "res://mob.gd"

func _ready():
	%Slime.play_walk()
	health = 25
	velocity_factor = 300
	damage_rate = 500
	points_to_player = 100
	label = "boss"
