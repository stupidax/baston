extends Control

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Game.tscn")

func _on_join_pressed() -> void:
	Combat_Server.join_game()
	Combat_Server.player_loaded.rpc_id(1)

func _on_create_pressed() -> void:
	Combat_Server.create_game()
	Combat_Server.player_loaded.rpc_id(0)
