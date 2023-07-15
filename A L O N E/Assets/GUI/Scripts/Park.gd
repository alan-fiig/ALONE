extends Control

var dialog = [
	"Mark \nEsto no puede seguir asi, necesito cambiar esto de mí, no puedo seguir evitando a todas las personas con las que me cruce.",
	"Mark \nNecesito empezar a superar mis inseguridades y llenarme de valor para empezar a formar relaciones si no siempre seré una persona solitaria y ¡no quiero eso!",
	"Ayuda a Mark a vencer sus inseguridades y lograr que pueda hacer amigos. Para lograrlo tendrás que superar distintos niveles y enemigos.",
	"Los enemigos reflejan todas las inseguridades que siente Mark y son la razón principal por la que siempre evita el contacto con las personas.",
	"Asi mismo Mark tiene una visión del mundo algo oscuro debido a que es una persona solitaria."
]

var dialog_index = 0
var speed = 0.03
var finished = false


func _ready():
	$Control/RichTextLabel.bbcode_text = ""
	load_dialog()
	
	
func _process(delta):
	$Control/Sprite.visible = finished
	$Control/Sprite/AnimationPlayer.play("Idle")
	
	if Input.is_action_just_pressed("ui_accept"):
		load_dialog()


func load_dialog():
	if dialog_index < dialog.size():
		finished = false
		if dialog_index > 1:
			$Prota.visible = false
		$Control/RichTextLabel.bbcode_text = dialog[dialog_index]
		$Control/RichTextLabel.percent_visible = 0
		var tween_duration = speed * dialog[dialog_index].length()
		$Control/Tween.interpolate_property(
			$Control/RichTextLabel, "percent_visible", 0, 1, tween_duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		$Control/Tween.start()
	else: 
		get_tree().change_scene("res://Assets/Game/Mundo/Level1.tscn")
	dialog_index += 1 
	
	
func _on_Tween_tween_completed(object, key):
	finished = true
