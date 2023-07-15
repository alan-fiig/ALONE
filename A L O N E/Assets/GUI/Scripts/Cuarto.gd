extends Control

# Declare member variables here.
var dialog = [
	"Mark \nHola mi nombre es Mark soy una persona sin hogar.",
	"Mark \nPaso todo el día recolectando cosas para poder sobrevivir día con día.",
	"Mark \n¿Podrías ayudarme a salir de esta situación?",
	"Ayuda a Mark a recoger monedas para cambiar su situación."]

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
