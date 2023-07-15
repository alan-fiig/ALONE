extends Camera2D

onready var rng = RandomNumberGenerator.new() # Para generar el temblor 
onready var player = get_tree().get_nodes_in_group("Player")[0] # Referencias al nodo player.


# Función creada para generar un número aleatorio.
func random(min_number, max_number):
	rng.randomize()
	var random = rng.randf_range(min_number, max_number)
	return random


func _process(_delta) -> void:
	global_position.x = player.global_position.x


func shake_camera(shake_power) -> void: 
	offset_h = random(-shake_power, shake_power) 
	offset_v = random(-shake_power, shake_power)


func screen_shacke(shake_lenght : float, shake_power : float, shake_priority : int) -> void:
	var current_shake_priority : int = 0
	
	if shake_priority > current_shake_priority:
		$Tween.interpolate_method(
			self, 
			"shake_camera", 
			shake_power, 
			0, 
			shake_lenght, 
			Tween.TRANS_SINE, 
			Tween.EASE_OUT 
		)
		$Tween.start()
