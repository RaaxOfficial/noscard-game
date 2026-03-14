extends Control


func _on_button_pressed() -> void:
	EventManager.treasure_room_exited.emit()
