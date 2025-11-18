extends Node2D

@export var award_amount : int = 1
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var label: Label = $Label

func _ready():
	# ✅ ADDED — make award_amount follow the label's value automatically
	if label.text.is_valid_int():
		award_amount = int(label.text)           # ✅ ADDED
	else:
		label.text = str(award_amount)           # ✅ ADDED

	label.hide()

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		print("Coin value:", award_amount)
		
		animated_sprite_2d.hide()
		label.text = str(award_amount)
		CollectibleManager.give_pickup_award(award_amount)
		
		label.show()
		
		var tween = get_tree().create_tween()
		tween.tween_property(label, "position", label.position + Vector2(0, -10), 0.5).from_current()
		tween.tween_callback(queue_free)
