extends Area2D

func _ready():
	$AnimationPlayer.play("Buy")


func _on_PowerUp_body_entered(body):
	if body.is_in_group("Player"):
		if GLOBAL.coins >= 100:
			$AnimationPlayer.play("Eliminar")
			$AudioStreamPlayer.play()
			GLOBAL.coins -= 100
			if not GLOBAL.power_up:
				GLOBAL.power_up = true
		else:
			pass

func _on_AudioStreamPlayer_finished():
	queue_free()
