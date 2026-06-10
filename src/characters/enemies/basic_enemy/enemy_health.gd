extends Control

@export var health: HealthComponent
@export var character: Node
var camera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	camera = get_viewport().get_camera_3d()
	health.health_changed.connect(change_health_bar)

func change_health_bar():
	get_child(0).set_value_no_signal((health.health/health.max_health)*100)

func _process(delta: float) -> void:
	var screen_pos = camera.unproject_position(character.global_position + Vector3(0, 2, 0))
	global_position = screen_pos
	global_position += Vector2(-get_rect().size.x / 2, 0)
	#var distance = camera.global_transform.origin.distance_to(character.global_transform.origin)
	#var scale_factor = clamp(1.0 - distance / 100.0, 0.11, 2.0)
	#scale = Vector2(scale_factor, scale_factor)
