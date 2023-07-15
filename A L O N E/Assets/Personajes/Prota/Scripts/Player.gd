extends KinematicBody2D
class_name Player

const SPEED = 128			# Velocidad del personaje
const FLOOR = Vector2(0, -1)
const GRAVITY = 20			# Gravedad del personaje
const JUMP_HEIGHT = 390		# Fuerza del salto
const BOUNCING_JUMP = 90	# Define la fuerza de rebote de la pared
const CAST_WALL = 10		# Distancia de colisión con la pared
const CAST_ENEMY = 40		# Distancia de colisión para los enemigos
onready var motion : Vector2 = Vector2.ZERO
var can_move : bool 		# Sirve para comprobar si el personaje puede moverse
var immunity : bool = false # Hace inmune al player


""" STATE MACHINE """ # Carga la máquina de estados para que se ejecuten las animaciones
var playback : AnimationNodeStateMachinePlayback


func _ready():
	playback = $AnimationTree.get("parameters/playback")
	playback.start("Reposo") 			# El personaje inicia con la animacion de reposo
	$AnimationTree.active = true 		# Se activan las animaciones
	 

func _process(_delta):
	motion_ctrl()
	direction_ctrl()
	jump_ctrl()
	attack_ctrl()
	

func get_axis() -> Vector2:	# Movimiento del personaje
	var axis = Vector2.ZERO
	axis.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	return axis
	
	
# La siguiente funcion describe el movimiento del personaje
func motion_ctrl():
	motion.y += GRAVITY
	
	if can_move: # El personaje solo podrá moverse si can_move es igual a true
		motion.x =  get_axis().x * SPEED
		
		if get_axis().x == 0:			# Animaciones del personaje
			playback.travel("Reposo")			
		elif get_axis().x == 1:
			playback.travel("Correr")
			$Sprite.flip_h = false
		elif get_axis().x == -1:
			playback.travel("Correr")
			$Sprite.flip_h = true
		
		match playback.get_current_node():	# Animación de partículas al caminar
			"Reposo":
				motion.x =  0
				$Particulas.emitting = false
			"Correr":
				$Particulas.emitting = true
			
	motion = move_and_slide(motion, FLOOR)
	
	# Código que hace posible que el player pueda bajarse de plataformas
	var slide_count = get_slide_count() # Cantidad de veces que el cuerpo colisiona 
	
	if slide_count: 
		var collision = get_slide_collision(slide_count - 1)	# 
		var collider = collision.collider
		
		# Si esta dentro del grupo Plataforma y presionamos abajo el player atraviesa la plataforma
		if collider.is_in_group("Plataforma") and Input.is_action_just_pressed("ui_down"):
			$CollisionShape2D.disabled = true
			$Timer.start()
	# ---------------------------------------------------------------------------------


func _on_Timer_timeout(): # Se vuelve a activar la plataforma para que no se traspase 
	$CollisionShape2D.disabled = false
	
	
func direction_ctrl(): 
	match $Sprite.flip_h:
		true:
			$RayParedes.cast_to.x = -CAST_WALL
			$RayEnemigos.cast_to.x = -CAST_ENEMY
		false:
			$RayParedes.cast_to.x = CAST_WALL
			$RayEnemigos.cast_to.x = CAST_ENEMY
		
		
# Función para que el personaje pueda saltar
func jump_ctrl():
	match is_on_floor():
		true: # Comprobación de si el personaje está tocando el suelo
			can_move = true  
			$RayParedes.enabled = false  
		
			if Input.is_action_just_pressed("Saltar"):
				$Sonidos/Saltar.play()
				motion.y -= JUMP_HEIGHT
			
		false: 
			$Particulas.emitting = false 
			$RayParedes.enabled = true 
		
			if motion.y < 0:
				playback.travel("Salto")
			else:
				playback.travel("Caida")
			
			if $RayParedes.is_colliding(): # Colisión con una pared
				#can_move = false
				
				var body = $RayParedes.get_collider() # Se guardan las colisiones
			
				# Se comprueba si el personaje esta tocando la pared para despues saltar en ella
				# Solo podrá saltar si la pared esta dentro del grupo I_Pared
				if body.is_in_group("I_Pared") and Input.is_action_just_pressed("Saltar"):
					$Sonidos/Saltar.play()
					can_move = false		# Hace posible que el jugador pueda avanzar despúes de saltar
					motion.y -= JUMP_HEIGHT
					
					if $Sprite.flip_h:
						motion.x += BOUNCING_JUMP
						$Sprite.flip_h = false
					else:
						motion.x -= BOUNCING_JUMP
						$Sprite.flip_h = true

# Función para los ataques del personaje
func attack_ctrl():
	var body = $RayEnemigos.get_collider()
	$RayEnemigos.enabled = true		# Activa la colisión con los enemigos
	if is_on_floor():
		if get_axis().x == 0 and Input.is_action_just_pressed("Ataque"):
			match playback.get_current_node():
				"Reposo":
					playback.travel("Ataque1")
					$Sonidos/Golpe.play()
					if $RayEnemigos.is_colliding(): 
						if body.is_in_group("Enemigos"):
							body.damage_ctrl(5)
				"Ataque1":
					playback.travel("Ataque2")
					$Sonidos/Espada2.play()
					if $RayEnemigos.is_colliding(): 
						if body.is_in_group("Enemigos"):
							body.damage_ctrl(5)
							
												
# Funciòn que maneja el daño recibido del personaje
func damage_ctrl(damage : int) -> void:
	match immunity:
		false: 			# Se recibe daño mientras el player no sea inmune
			GLOBAL.health -= damage 	# Se resta el daño a la salud
			get_node("AnimationPlayer").play("Daño") 	# Se reproduce la animación de daño
			get_node("Sonidos/Daño").play() 			# Se reproduce el sonido de daño
			immunity = true 	# Se hace inmune por breve tiempo
			
			
func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"Daño":
			immunity = false # # Y cuando termina deja de ser inmune.
