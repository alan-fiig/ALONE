extends Area2D

onready var active : bool = true		# Evita que se puedan recojer 2 veces

func _ready() -> void:
	$AnimationPlayer.play("Girar")


func _on_Life_body_entered(body):
	if body.is_in_group("Player"):
		if GLOBAL.health < 20:
			$AnimationPlayer.play("Recojer")


func _on_AnimationPlayer_animation_started(anim_name):
	match anim_name:
		"Recojer":
			if active:
				active = false
				$AudioStreamPlayer.play()
				GLOBAL.health += 1


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"Recojer":
			queue_free()
