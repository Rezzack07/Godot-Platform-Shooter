extends Control   # atau CanvasLayer, sesuai node paling atas

func _on_RetryButton_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_MainMenuButton_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")

func _on_ExitButton_pressed():
	get_tree().quit()
const DEATH_Y = 1000  # batas jatuh (sesuaikan dengan level)

func _physics_process(delta):
	if global_position.y > DEATH_Y:
		game_over()

func game_over():
	get_tree().paused = true
	var go = preload("res://ui/gameover.tscn").instantiate()
	get_tree().get_root().add_child(go)
