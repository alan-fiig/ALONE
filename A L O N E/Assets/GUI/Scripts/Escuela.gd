extends Control

var dialog = [
	"Gracias a tu ayuda Mark logro sobrevivir un día más",
	"Mark \nMuchas gracias por ayudarme, en verdad lo aprecio, no muchas personas tienen el tiempo para ayudar a una persona que se encuentre en mi situación.",
	"Mark \nGracias a tu apoyo logre pasar un mejor día."
]

var dialog_index = 0
var speed = 0.03
var finished = false

func _ready():
	$Control/RichTextLabel.bbcode_text = ""
	$Prota.visible = false
	load_dialog()
	
func _process(delta):
	$Control/Sprite.visible = finished
	$Control/Sprite/AnimationPlayer.play("Idle")
	
	if Input.is_action_just_pressed("ui_accept"):
		load_dialog()

func load_dialog():
	if dialog_index < dialog.size():
		finished = false
		if dialog_index > 0 && dialog_index < 4:
			$Prota.visible = true
			
		if dialog_index > 3:
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
		get_tree().change_scene("res://Assets/GUI/End.tscn")
	dialog_index += 1 
	
func _on_Tween_tween_completed(object, key):
	finished = true
