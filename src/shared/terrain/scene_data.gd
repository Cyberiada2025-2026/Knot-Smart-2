class_name SceneData
extends Resource

var scene: PackedScene
var transform: Transform3D


func _init(_scene: PackedScene, _transform: Transform3D = Transform3D()):
	self.scene = _scene
	self.transform = _transform
