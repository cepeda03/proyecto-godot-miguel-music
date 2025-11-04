extends Node2D

@export var mob_scene: PackedScene
var score: int = 0

@onready var mob_spawn_location: PathFollow2D = $MobPath/MobSpawnLocation

func _ready() -> void:
	randomize()
	new_game()


func _on_player_hit() -> void:
	game_over()

func game_over() -> void:
	$Music.stop()
	$DeathSound.play()
	$HUD.show_game_over()
	$ScoreTimer.stop()
	$MobTimer.stop()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func new_game() -> void:
	$Music.play()
	$HUD.update_score(score)
	$HUD.hide_message()
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	get_tree().call_group("mobs", "queue_free")

func _on_mob_timer_timeout() -> void:
	var mob := mob_scene.instantiate() as RigidBody2D
	add_child(mob)

	mob_spawn_location.progress_ratio = randf()

	var direction := mob_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)

	mob.position = mob_spawn_location.position
	mob.rotation = direction

	mob.gravity_scale = 0.0
	mob.linear_damp = 0.0
	mob.angular_damp = 0.0
	mob.linear_velocity = Vector2(randf_range(150.0, 250.0), 0.0).rotated(direction)
	mob.sleeping = false

func _on_score_timer_timeout() -> void:
	$HUD.update_score(score)
	score += 1

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
