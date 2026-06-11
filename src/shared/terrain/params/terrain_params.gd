@tool
class_name TerrainParams
extends Resource

@export_range(-0.5, 0.5, 0.05) var height_displacement := -0.5

## The noise algorithm used to calculate elevation.
@export var noise: FastNoiseLite

@export var water: NoiseTexture2D
@export_range(0.0,1.0, 0.05) var water_threshold:= 0.8
@export_range(0.0,10.0, 0.5) var water_levels:= 1.0
## The material applied to the generated mesh surface.
## Expects a type of Material (e.g., StandardMaterial3D or ShaderMaterial).
@export var terrain_material: Material
