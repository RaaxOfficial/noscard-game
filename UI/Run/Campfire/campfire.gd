extends Control


func _on_button_pressed() -> void:
	EventManager.campfire_exited.emit()
