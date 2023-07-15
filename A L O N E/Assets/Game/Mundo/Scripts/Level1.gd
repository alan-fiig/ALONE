extends Node2D

func _ready():
	$Puerta/AnimationPlayer.play("Cerrado")
	
	
func _on_Palanca_body_entered(body):
	if body.is_in_group("Player"):
		$Plataforma/AnimationPlayer.play("Movimiento")


func _on_Palanca2_body_entered(body):
	if body.is_in_group("Player"):
		$Plataforma2/AnimationPlayer.play("Movimiento")


func _on_Cambiar_body_entered(body):
	if	$Puerta/Cambiar/CollisionShape2D.disabled:
		if (body.get_name() == "Player"):
			get_tree().change_scene("res://Assets/Game/Mundo/Shop.tscn")


func _on_Key_body_entered(body):
	if body.is_in_group("Player"):
		$Puerta/AnimationPlayer.play("Abierto")
		$Puerta/Cambiar/CollisionShape2D.disabled = true
