extends CanvasLayer

onready var player : KinematicBody2D = get_tree().get_nodes_in_group("Player")[0] # Cámara del Player


func _ready():
	get_node("AnimationPlayer").play("Inicio") # Comienza con la animación de inicio
	get_node("TextureProgress").max_value = 20


func _process(_delta):
	if is_instance_valid(player):
		get_node("TextureProgress").value = GLOBAL.health
		get_node("MoneyContainer/Label").text = str("x ") + str(GLOBAL.coins)	# Muestra las coins totales


func _on_TextureProgress_value_changed(value):
	if value <= 0:
		get_node("AnimationPlayer").play("GameOver") # Pantalla roja GAME OVER


func _on_AnimationPlayer_animation_started(anim_name):
	match anim_name:
		"GameOver": # Se pausa momentaneamente el juego por la animación
			get_tree().paused = true
			get_node("Control/VBoxContainer").visible = true # Se hace visible el mensaje
			get_node("Sonido/GameOver").play()  
		"Inicio": # Se oculta los textos al iniciar la animación
			get_node("Control/VBoxContainer").visible = false


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"Inicio": # Se quita la pausa
			get_tree().paused = false


func _on_GameOver_finished(): # Cuando termina la música se reinicia la escena.
	# Usamos call_deferred para hacer una llamada segura y que no arroje advertencias.
	get_tree().call_deferred("reload_current_scene")
	GLOBAL.health = 20
	GLOBAL.coins = 0
