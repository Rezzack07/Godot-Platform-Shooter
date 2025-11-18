extends NodeState
@export var enemy_death_effect: PackedScene = preload("res://enemies/enemy_death_effect.tscn")

func enter() -> void:
	var enemy = get_parent().get_parent() # StateMachine → Enemy_Frog
	var effect = enemy_death_effect.instantiate()
	effect.global_position = enemy.global_position + Vector2(0, -20)
	enemy.get_parent().add_child(effect)
	enemy.queue_free()
