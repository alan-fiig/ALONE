extends Area2D

onready var active : bool = true		# Evita que se puedan recojer 2 veces


func _ready() -> void:
	$AnimationPlayer.play("Cerrado")


func _on_Palanca_body_entered(body):
	if body.is_in_group("Player"):
		$AnimationPlayer.play("Abierto")


func _on_AnimationPlayer_animation_started(anim_name):
		match anim_name:
			"Abierto":
				if active:
					$AudioStreamPlayer.play()
					active = false


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"Abierto":
			$AnimationPlayer.play("Cerrado")
