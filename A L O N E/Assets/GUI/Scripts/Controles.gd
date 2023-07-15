extends Control



 
func _on_Button_pressed():
	get_tree().change_scene("res://Assets/GUI/Menu.tscn")


func _on_Timer_timeout():
	$Back/Button.grab_focus()
