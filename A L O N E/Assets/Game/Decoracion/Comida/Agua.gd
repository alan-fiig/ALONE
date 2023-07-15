extends Area2D

export(String, "Comida") var type : String		# Valor que se le da segun que elemento sea
onready var active : bool = true		# Evita que se puedan recojer 2 veces

func _ready() -> void:
	$AnimationPlayer.play("Reposo")

func _on_Agua_body_entered(body):
	if body.is_in_group("Player"):
		$AnimationPlayer.play("Eliminar")


func _on_AnimationPlayer_animation_started(anim_name):
	match anim_name:
		"Eliminar":
			if active:
				$AudioStreamPlayer.play()
				active = false
			
				match type:
					"Comida":
						GLOBAL.coins += -50

func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"Eliminar":
			queue_free()

