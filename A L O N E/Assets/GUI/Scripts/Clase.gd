extends Control

# Declare member variables here.
var dialog = [
	"Gracias a tu ayuda, Mark ha superado por completo sus inseguridades, ahora es un chico diferente, capaz de hablar con cualquiera sin ningún tipo de miedo o inseguridad.",
	"Mark \n¡Hola a todos! ¿de qué están hablando?",
	"Sakura \nHola Mark, estamos poniéndonos de acuerdo que al salir de clases vamos a ir al cine.",
	"Leo \nAsi es ¿te nos quieres unir Mark? Será divertido.",
	"Mark \n¡Por supuesto! (menciona lleno de felicidad).",
	"Laura \nExcelente nos vemos cuando terminen las clases.",
	"Mark finalmente ha logrado hacer nuevos amigos, ahora es un chico muy feliz que tiene amigos y lo más importante que nunca más se volverá a sentir solo, gracias a que ha superado todas sus inseguridades y miedos."		
]

var dialog_index = 0
var speed = 0.03
var finished = false


func _ready():
	$Control/RichTextLabel.bbcode_text = ""
	$Prota.visible = false
	$NPC1.visible = false
	$NPC2.visible = false
	$NPC3.visible = false
	load_dialog()
	
	
func _process(delta):
	$Control/Sprite.visible = finished
	$Control/Sprite/AnimationPlayer.play("Idle")
	
	if Input.is_action_just_pressed("ui_accept"):
		load_dialog()


func load_dialog():
	if dialog_index < dialog.size():
		finished = false
		if dialog_index > 0 && dialog_index < 5:
			$Prota.visible = true
			$NPC1.visible = true
			$NPC2.visible = true
			$NPC3.visible = true
		if dialog_index > 5:
			$Prota.visible = false
			$NPC1.visible = false
			$NPC2.visible = false
			$NPC3.visible = false
		$Control/RichTextLabel.bbcode_text = dialog[dialog_index]
		$Control/RichTextLabel.percent_visible = 0
		var tween_duration = speed * dialog[dialog_index].length()
		$Control/Tween.interpolate_property(
			$Control/RichTextLabel, "percent_visible", 0, 1, tween_duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		$Control/Tween.start()
	else: 
		get_tree().change_scene("res://Assets/GUI/End.tscn")
	dialog_index += 1 
	

func _on_Tween_tween_completed(object, key):
	finished = true
