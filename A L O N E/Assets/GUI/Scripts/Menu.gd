extends Control


func _on_BtnStart_pressed():
	get_tree().change_scene("res://Assets/GUI/Cuarto.tscn")


func _on_BtnControles_pressed():
	get_tree().change_scene("res://Assets/GUI/Controles.tscn")


func _on_BtnSalir_pressed():
	get_tree().quit()
