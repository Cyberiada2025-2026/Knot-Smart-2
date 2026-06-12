@tool
class_name DecimateBuilding
extends Node3D


@export_tool_button("Decimate") var execute_btn = execute_decimate

@export_range(0.0, 1.0) var removal_chance = 0.0

var random = RandomNumberGenerator.new()


func execute_decimate():
	random.set_seed(2137)
	var building = get_parent().get_node("GeneratedBuilding")
	var gridmaps = []
	for child in building.get_children():
		if child is GridMap:
			gridmaps.append(child)

	decimate(gridmaps)


func decimate(gridmaps):
	var cells = gridmaps.reduce(func(acc, gridmap): return acc + gridmap.get_used_cells(), [])
	cells.sort_custom(func(v1, v2): return v1.y > v2.y)

	var max_floor = cells[0].y
	for cell in cells:
		if cell.y < max_floor:
			break

		remove_from_top(gridmaps, cell)


func remove_from_top(gridmaps, start_position: Vector3):
	var removed_cell = start_position

	while (random.randf() < removal_chance and removed_cell.y >= 0):
		print("Removing cell:")
		print(removed_cell)
		for gridmap in gridmaps:
			gridmap.set_cell_item(removed_cell, GridMap.INVALID_CELL_ITEM)
		removed_cell.y -= 1
