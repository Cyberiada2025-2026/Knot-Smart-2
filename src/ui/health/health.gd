extends Control

var player: Node
var health_component: HealthComponent
var max_health: float
var health_bar: Control
var health: float


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	health_component = player.get_node("HealthComponent")
	health_bar = get_child(0)
	max_health = health_component.max_health
	health = health_component.health
	health_component.health_decreased.connect(health_changed)
	health_component.health_increased.connect(health_changed)
	health_component.max_health_changed.connect(max_health_changed)


func health_changed() -> void:
	health_bar.value = health / max_health


func max_health_changed() -> void:
	max_health = health_component.max_health
