extends Area2D

var direction : int
onready var can_move : bool = true

func _ready() -> void:
	$AnimationPlayer.play("Hit")
	$Sonidos/Disparo.play()


func _process(delta) -> void:
	# Dispara en dirección del player
	if can_move:
		global_position.x += direction * delta


func _on_VisibilityNotifier2D_screen_exited():
	queue_free() # Si sale de pantalla, el disparo se elimina.


func _on_Hit_body_entered(body):
	if body.is_in_group("Enemigos"): # Si el cuerpo pertenece al grupo Enemigos.
		body.damage_ctrl(3) # Se llama a la función damage_ctrl de los enemigos
		$AnimationPlayer.play("Explosion")
		$Sonidos/Explosion.play()
		
	elif body.is_in_group("I_Pared"): # Si el cuerpo pertenece al grupo I_Pared
		$AnimationPlayer.play("Explosion")
		$Sonidos/Explosion.play()


func _on_AnimationPlayer_animation_started(anim_name):
	match anim_name:
		"Explosion":
			can_move = false


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"Explosion":
			queue_free()
