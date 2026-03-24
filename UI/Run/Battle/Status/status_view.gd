class_name StatusView
extends Control

const STATUS_TOOLTIP = preload("uid://di0v1od0xm6bd")

var is_visible: bool = false

func _ready() -> void:
	for tooltip: StatusTooltip in get_children():
		tooltip.queue_free()
	
	EventManager.status_tooltip_requested.connect(toggle_view)

func show_view(status: Status) -> void:
	if is_visible:
		return
	
	var new_status_tooltip := STATUS_TOOLTIP.instantiate() as StatusTooltip
	add_child(new_status_tooltip)
	new_status_tooltip.status = status
	new_status_tooltip.global_position = get_global_mouse_position()
	show()

func hide_view() -> void:
	if not is_visible:
		return
	
	for tooltip: StatusTooltip in get_children():
		tooltip.queue_free()
	hide()

func toggle_view(status: Status) -> void:
	if is_visible:
		hide_view()
		is_visible = false
	else:
		show_view(status)
		is_visible = true
