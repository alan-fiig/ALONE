extends Node2D

func _ready():
	$Puerta/Cambiar/AnimatedSprite.play("Cerrado")
		
		
func _on_Palanca_body_entered(body):
	if body.is_in_group("Player"):
		$Plataforma/AnimationPlayer.play("Movimiento")


func _on_Palanca2_body_entered(body):
	if body.is_in_group("Player"):
		$Plataforma2/AnimationPlayer.play("Movimiento")


func _on_Key_body_entered(body):
	if body.is_in_group("Player"):
		$Puerta/Cambiar/AnimatedSprite.play("Abierto")
		$Puerta/Cambiar/CollisionShape2D.disabled = true

func _on_Cambiar_body_entered(body):
	if	$Puerta/Cambiar/CollisionShape2D.disabled:
		if (body.get_name() == "Player2"):
			get_tree().change_scene("res://Assets/Game/Mundo/Boss1.tscn")
