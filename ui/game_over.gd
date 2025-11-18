extends CanvasLayer


func _on_exit_button_pressed() -> void:
	GameManager.exit_game()

func _on_restart_button_pressed() -> void:
	get_tree().paused = false  # Unpause first
	queue_free()
	get_tree().change_scene_to_file("res://levels/level(r).tscn")
	
