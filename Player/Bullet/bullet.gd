extends AnimatedSprite2D
@onready var bullet: AnimatedSprite2D = $"."

var bulleet_impact_effect = preload("res://Player/Bullet/bullet_impact_effect.tscn")

var speed : int = 600
var direction : int
var damage_amount : int = 1

func _physics_process(delta: float):
	position.x += direction * speed * delta
	
	if direction != 0:
		bullet.flip_h = direction < 0

func _on_timer_timeout():
	queue_free() # Replace with function body.


func _on_hitbox_area_entered(area: Area2D) -> void:
	print("Bullet area entered")
	bullet_impact()


func _on_hitbox_body_entered(body: Node2D) -> void:
	print("Bullet body entered")
	bullet_impact()

func get_damage_amount() -> int:
	return damage_amount
	
func bullet_impact():
	var bulleet_impact_effect_instance = bulleet_impact_effect.instantiate() as Node2D
	bulleet_impact_effect_instance.global_position = global_position
	get_parent().add_child(bulleet_impact_effect_instance)
	queue_free()
