extends TextureProgressBar

var health_component: HealthComponent
var max_health
var health

var camera: Camera3D
var enemy: Node3D


func _ready() -> void:
	camera = get_viewport().get_camera_3d().get_node(
		"Control/SubViewportContainer/SubViewport/MainCamera"
	)
	enemy = get_parent()
	health_component = enemy.get_node("HealthComponent")
	max_health = health_component.max_health
	health = health_component.health

	change_bar_size()

	health_component.health_decreased.connect(health_changed)
	health_component.health_increased.connect(health_changed)
	health_component.max_health_changed.connect(max_health_changed)


func _process(_delta: float) -> void:
	var screen_pos = camera.unproject_position(enemy.global_position + Vector3(0, 6, 0))
	visible = not camera.is_position_behind(enemy.global_position + Vector3(0, 6, 0))
	print(screen_pos)
	global_position = screen_pos
	#  you can adjust the position for visual clarity
	global_position += Vector2(-get_rect().size.x / 2, 0)
	var distance = camera.global_transform.origin.distance_to(enemy.global_transform.origin)
	print(
		(
			"var distance: "
			+ str(distance)
			+ " 2) "
			+ str(1.0 - distance)
			+ " 3) "
			+ str(20.0 / distance)
		)
	)
	var scale_factor = clamp(20.0 / distance, 0.1, 1.0)
	scale = Vector2(scale_factor, scale_factor)


func change_bar_size():
	value = health / max_health * 100


func health_changed():
	health = health_component.health
	change_bar_size()


func max_health_changed():
	max_health = health_component.max_health
	change_bar_size()
