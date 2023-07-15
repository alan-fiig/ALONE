extends Control

func _ready():
	$BtnStart.grab_focus()
	
func _on_BtnStart_pressed():
	get_tree().change_scene("res://Assets/GUI/Menu.tscn")
