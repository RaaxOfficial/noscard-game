extends Node


func display_number(value: int, position: Vector2, offset: int, is_critical: bool = false):
	var number = Label.new()
	number.global_position = position
	number.global_position.y -= offset
	number.text = str(value)
	number.z_index = 5
	number.label_settings = LabelSettings.new()
	
	var color = Color.WHITE
	if is_critical:
		color = Color.RED
	
	if value == 0:
		color = Color.TRANSPARENT
	
	number.label_settings.font_color = color
	number.label_settings.font_size = 12
	number.label_settings.outline_color = Color.BLACK
	number.label_settings.outline_size = 1
	
	call_deferred("add_child", number)
	
	await number.resized
	number.pivot_offset = Vector2(number.size / 2)
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		number, "position:y", number.position.y - 32, 0.15
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		number, "position:y", number.position.y, 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.15)
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.25)
	
	await tween.finished
	number.queue_free()
