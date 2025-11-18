extends NodeState

@export var character_body_2d : CharacterBody2D
@export var flash_duration : float = 0.1
var timer : float = 0.0

func enter():
	timer = flash_duration
	if character_body_2d.has_node("AnimatedSprite2D"):
		var sprite = character_body_2d.get_node("AnimatedSprite2D")
		sprite.modulate = Color(1, 0.4, 0.4) # red flash

func on_process(delta: float):
	timer -= delta
	if timer <= 0:
		if character_body_2d.has_node("AnimatedSprite2D"):
			var sprite = character_body_2d.get_node("AnimatedSprite2D")
			sprite.modulate = Color(1, 1, 1)
		var fsm = get_parent() as NodeFiniteStateMachine
		fsm.transition_to("idle")

func on_physics_process(delta: float): pass
func exit(): pass
