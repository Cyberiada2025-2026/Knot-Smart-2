class_name TileInfo
extends Resource

enum PlacementRule {
	FLAT,
	SLOPE_X,
	SLOPE_Z,
	BLOCKED,
}

var height: float
var objects: Array[MeshInstance3D]
var placement_rule: PlacementRule
var is_water: bool


func _init(
	_height: float = 0.0,
	_placement_rule: PlacementRule = PlacementRule.FLAT,
	_objects: Array[MeshInstance3D] = [],
):
	self.height = _height
	self.placement_rule = _placement_rule
	self.objects = _objects
	self.is_water = false
