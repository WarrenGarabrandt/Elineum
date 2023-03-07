extends Node2D

@export
var player_char: Node2D

func _process(delta):
	if player_char != null:
		player_char.HoldGround = Input.is_action_pressed("hold_ground")
		if Input.is_action_pressed("attack"):
			player_char.NextDesiredInput = "attack"
		elif Input.is_action_pressed("move_down"):
			player_char.NextDesiredInput = "move_down"
		elif Input.is_action_pressed("move_right"):
			player_char.NextDesiredInput = "move_right"
		elif Input.is_action_pressed("move_left"):
			player_char.NextDesiredInput = "move_left"
		elif Input.is_action_pressed("move_up"):
			player_char.NextDesiredInput = "move_up"
		else:
			player_char.NextDesiredInput = ""
