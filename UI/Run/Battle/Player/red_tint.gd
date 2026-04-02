extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var timer: Timer = $Timer

func _ready() -> void:
	EventManager.player_hurt.connect(_on_player_hurt)
	timer.timeout.connect(_on_timer_timeout)

func _on_player_hurt(_damage: int) -> void:
	color_rect.color.a = 0.25
	timer.start()

func _on_timer_timeout() -> void:
	color_rect.color.a = 0.0
