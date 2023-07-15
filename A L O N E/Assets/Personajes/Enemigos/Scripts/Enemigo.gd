extends KinematicBody2D
class_name BasicEnemy # Le damos un nombre de clase para que otros enemigos puedan heredar de esta.

onready var camera : Camera2D = get_tree().get_nodes_in_group("Camara")[0] 

const FLOOR = Vector2(0, -1)
const GRAVITY = 16

export(int, 1, 10) var health : int = 15

onready var motion : Vector2 = Vector2.ZERO
onready var can_move : bool = true
onready var direccion : int = 1

const MIN_SPEED = 30
const MAX_SPEED = 60
var speed : int

func _ready() -> void:
	get_node("AnimationPlayer").play("Correr")

func _process(_delta) -> void:
	attack_ctrl()
	patrol_ctrl()
	patrol_ctrl2()	
	
	if can_move: # Solo si can_move es igual a true es que el enemigo va a llamar a la función motion_ctrl.
		motion_ctrl()

func patrol_ctrl() -> void:		# Función para detectar al player
	if get_node("Raycast/Agro").is_colliding():
		if get_node("Raycast/Agro").get_collider().is_in_group("Player"):
			speed = MAX_SPEED			 
		else:
			speed = MIN_SPEED
	else:
		speed = MIN_SPEED


func patrol_ctrl2() -> void:	# Función para detectar al player por atras
	if get_node("Raycast/AgroAtras").is_colliding():
		if get_node("Raycast/AgroAtras").get_collider().is_in_group("Player"):
			direccion *= -1
			get_node("Raycast").scale.x *= -1
			$Golpes.cast_to.x *= -1
					
		
func attack_ctrl() -> void: # Función creada para controlar el ataque del enemigo.
	if 	health > 0:
		if get_node("Golpes").is_colliding():
			if get_node("Golpes").get_collider().is_in_group("Player"):
				can_move = false
				get_node("AnimationPlayer").play("Ataque")

func motion_ctrl() -> void:
	if direccion == 1: # Vamos a invertir los sprites en función de la dirección.
		get_node("Sprite").flip_h = false
	else:
		get_node("Sprite").flip_h = true
	
	# Si el enemigo colisiona con una pared o el raycast para detectar un precipicio no colisiona, entonces invertirá su dirección.
	if is_on_wall() or not get_node("Raycast/Precipicio").is_colliding():
		direccion *= -1
		get_node("Raycast").scale.x *= -1
		$Golpes.cast_to.x *= -1
	
	motion.y += GRAVITY
	motion.x = speed * direccion
	
	motion = move_and_slide(motion, FLOOR)


func damage_ctrl(damage) -> void:
	match can_move:
		true:
			if health > 0:
				health -= damage # Parámetro para definir la cantidad de vida que se elimina.
				get_node("AnimationPlayer").play("Hit")			 
			else:
				get_node("AnimationPlayer").play("Muerte")


func _on_AnimationPlayer_animation_started(anim_name): # Señal enviada cuando inicia X animación.
	match anim_name:
		"Hit":
			can_move = false # Bloqueamos el movimiento
			camera.screen_shacke(0.7, 0.8, 100)
		"Ataque": # El enemigo solo va a quitar vida al player cuando inicia la animación.
			get_node("Golpes").get_collider().damage_ctrl(1)
		"Muerte":
			get_node("Muerte").play()


func _on_AnimationPlayer_animation_finished(anim_name): # Señal enviada cuando finaliza X animación.
	match anim_name:
		"Hit":
			if health > 0:
				can_move = true # Si la vida es superior a 0, lo volvemos activar al terminar la animación.
				get_node("AnimationPlayer").play("Correr")
			else:
				get_node("AnimationPlayer").play("Muerte") # De lo contrario reproducimos la animación de muerte.
		"Ataque": # Y cuando termina de atacar, regresamos al enemigo a la normalidad.
			can_move = true
			get_node("AnimationPlayer").play("Correr")
		"Muerte":
			queue_free() # Al terminar la animación, se elimina.
