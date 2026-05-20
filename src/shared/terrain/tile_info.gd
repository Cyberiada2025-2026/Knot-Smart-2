class_name TileInfo
extends Resource

enum PlacementRule {
	FLAT,
	SLOPE_X,
	SLOPE_Z,
	BLOCKED,
}

enum Type {
	TERRAIN,
	ROAD,
	BUILDING,
}

var height: float
var objects: Array[MeshInstance3D]
var scenes: Array[SceneData]
var placement_rule: PlacementRule
var tile_type: Type


func _init(
	_height: float = 0.0,
	_placement_rule: PlacementRule = PlacementRule.FLAT,
	_objects: Array[MeshInstance3D] = [],
	_scenes: Array[SceneData] = [],
	_tile_type = Type.TERRAIN
):
	self.height = _height
	self.placement_rule = _placement_rule
	self.objects = _objects
	self.scenes = _scenes
	self.tile_type = _tile_type
