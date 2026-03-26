class_name StatusView
extends Control

const STATUS_TOOLTIP = preload("uid://di0v1od0xm6bd")

var showing: bool = false

func _ready() -> void:
	for tooltip: StatusTooltip in get_children():
		tooltip.queue_free()
	
	EventManager.status_tooltip_requested.connect(_on_status_tooltip_requested)

func show_view(status: Status) -> void:
	if showing:
		return
	
	var new_status_tooltip := STATUS_TOOLTIP.instantiate() as StatusTooltip
	add_child(new_status_tooltip)
	new_status_tooltip.status = status
	new_status_tooltip.global_position = get_global_mouse_position()
	show()

func hide_view() -> void:
	if not showing:
		return
	
	for tooltip: StatusTooltip in get_children():
		tooltip.queue_free()
	hide()

func _on_status_tooltip_requested(status: Status) -> void:
	if showing:
		hide_view()
		showing = false
	else:
		show_view(status)
		showing = true
