extends Node2D

var powerup : PackedScene = load("res://Assets/Personajes/Prota/Pet.tscn")


func _process(_delta):
	if GLOBAL.power_up and get_tree().get_nodes_in_group("Pet").size() <= 0:
		add_child(powerup.instance())

func _on_Cambiar_body_entered(body):
	if (body.get_name() == "Player"):
			get_tree().change_scene("res://Assets/GUI/Escuela.tscn")
