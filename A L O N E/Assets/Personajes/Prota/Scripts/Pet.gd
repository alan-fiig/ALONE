extends Area2D

var Shoot : PackedScene = load("res://Assets/Personajes/Prota/Hit.tscn")

onready var player : KinematicBody2D = get_tree().get_nodes_in_group("Player")[0] # Hace refencia al nodo Player
var motion : float	# Sirve para mover el fantasma

func _ready():
	GLOBAL.power_up = true # Cuando entra en pantalla powerful_shot es igual a true.
	global_position = Vector2(player.global_position.x, player.global_position.y - 8)
	$AnimatedSprite.play("Pet") # Inicia la animación


func _process(_delta) -> void: # Se llaman las funciones 
	if  is_instance_valid(player):	# Lo siguiente sucede solo si el player sigue con vida
		motion_ctrl()
		tween_ctrl()
		
		if Input.is_action_just_pressed("Disparo"):
			shoot_ctrl()

func motion_ctrl() -> void:		# Se conoce la dirección del player para posicionar la pet de la misma manera
	if player.get_node("Sprite").flip_h:
		scale.x = -1
		motion = player.global_position.x + 22
	else:
		scale.x = 1
		motion = player.global_position.x - 22


func tween_ctrl() -> void:		# Proveé una animación suave al la pet
	$Tween.interpolate_property(
		self, 				# Se afecta el propio nodo
		"global_position", 	# Propiedad afectada 
		global_position, 	# Valor inicial
		Vector2(motion, player.global_position.y - 8), 	# Valor final
		0.2, 				# Tiempo que transcurre entre uno y otro
		Tween.TRANS_SINE, 	# Transición inicial
		Tween.EASE_OUT 		# Transición final
	)
	$Tween.start()


func shoot_ctrl():
	var shoot = Shoot.instance()		# Se guarda la referencia de la escena Hit
	shoot.global_position = $Spawn.global_position
	
	if player.get_node("Sprite").flip_h:
		shoot.scale.x = -1
		shoot.direction = -224
	else:
		shoot.scale.x = 1
		shoot.direction = 224
	
	get_tree().call_group("Nivel", "add_child", shoot)


func _on_Pet_tree_exited():
	GLOBAL.power_up = false
