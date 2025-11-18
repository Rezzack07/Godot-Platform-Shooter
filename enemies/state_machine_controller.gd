extends Node

@export var node_finite_state_machine : NodeFiniteStateMachine
@export var health_amount : int = 25
var enemy_death_effect = preload("res://enemies/enemy_death_effect.tscn")

func _on_attack_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		node_finite_state_machine.transition_to("attack")


#func _on_attack_area_2d_body_exited(body: Node2D) -> void:
#	if body.is_in_group("Player"):
#		node_finite_state_machine.transition_to("idle")


func _on_hurt_area_2d_area_entered(area: Area2D) -> void:
	print("Hurtbox area entered")
	if area.get_parent().has_method("get_damage_amount"):
		var node = area.get_parent() as Node
		health_amount -= 1
		print("Health amount:", health_amount)
		
		if health_amount <= 0:
			print("dead:")
			var enemy_death_effect_instance = enemy_death_effect.instantiate() as Node2D
			enemy_death_effect_instance.global_position = get_parent().global_position + Vector2(0, 0)
			get_parent().add_child(enemy_death_effect_instance)
			get_parent().queue_free()
