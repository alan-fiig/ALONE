extends Node2D


func _ready():
	$Plataforma/AnimationPlayer.play("Movimiento")
	$Puerta/Cambiar/AnimatedSprite.play("Cerrado")
	$Puerta/Cambiar/CollisionShape2D.disabled = true

func _process(delta): 
	next()


func next():
	if GLOBAL.boss1 <= 0:
		$Puerta/Cambiar/AnimatedSprite.play("Abierto")
		$Puerta/Cambiar/CollisionShape2D.disabled = false


func _on_Cambiar_body_entered(body):
	if	$Puerta/Cambiar/CollisionShape2D.disabled == false:
		if (body.get_name() == "Player2"):
			get_tree().change_scene("res://Assets/GUI/Clase.tscn")
			pass
