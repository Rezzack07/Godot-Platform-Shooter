extends Node2D

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _on_timer_timeout() -> void:
	queue_free()
