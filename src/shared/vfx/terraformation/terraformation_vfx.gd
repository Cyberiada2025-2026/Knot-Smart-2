extends Node3D
class_name TerraformationVFX

const MIN_RADIUS = 0.01

@export var sphere_r: Node3D
@export var sphere_g: Node3D

@export var line_thickness: float
@export var max_radius: float
@export var growing_time: float

var radius: float
var growing: bool = false
var growing_timer: float = 0.0

func _ready():
	set_radius(MIN_RADIUS)

func _process(delta: float) -> void:
	if !growing:
		return

	var change: float = max_radius / growing_time * delta
	set_radius(radius + change)

	if growing_timer >= growing_time:
		growing = false
	growing_timer += delta

func set_radius(new_radius):
	radius = new_radius
	sphere_r.scale = radius * Vector3.ONE
	sphere_g.scale = radius * 0.999 * Vector3.ONE

func start_growing():
	set_radius(MIN_RADIUS)
	growing = true
	growing_timer = 0.0
