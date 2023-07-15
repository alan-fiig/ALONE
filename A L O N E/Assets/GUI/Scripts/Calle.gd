extends Control

# Declare member variables here.
var dialog = [
	"Mientras Mark iba rumbo a la escuela se encuentra a un compañero de su salón.",
	"Mark 	\nMmm… ahí delante esta mi compañero, mejor me voy por otro lado.",
	"Leo 	\nHola Mar… Bueno supongo que está ocupado."
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
		$Control/RichTextLabel.bbcode_text = dialog[dialog_index]
		$Control/RichTextLabel.percent_visible = 0
		var tween_duration = speed * dialog[dialog_index].length()
		$Control/Tween.interpolate_property(
			$Control/RichTextLabel, "percent_visible", 0, 1, tween_duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
		)
		$Control/Tween.start()
	else: 
		get_tree().change_scene("res://Assets/GUI/Park.tscn")
	dialog_index += 1 
	

func _on_Tween_tween_completed(object, key):
	finished = true
