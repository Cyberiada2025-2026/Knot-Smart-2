@tool
class_name TerrainGenerator
extends Node

@export var terrain_params: TerrainParams

var world_generation_params: WorldGenerationParams
var blueprint: MapTileData
var texture_data: Dictionary[Color, Material] = {}

func run_generation(manager: GridGenerationPipeline) -> void:
	blueprint = manager.blueprint
	world_generation_params = manager.world_generation_params

	var noise_image: Image = null
	var water_image: Image = null
	var textures_map: Image = null
	var noise_width: int = 0
	var noise_height: int = 0
	var img_width: int = 0
	var img_height: int = 0
	var txt_width: int = 0
	var txt_height: int = 0
	
	for data in terrain_params.textures:
		texture_data[data.color] = data.material
	
	if !terrain_params.noise:
		return
		
	noise_image = terrain_params.noise.get_image()
	noise_width = noise_image.get_width()
	noise_height = noise_image.get_height()
	
	
	if terrain_params.water:
		water_image = terrain_params.water.get_image()
		img_width = water_image.get_width()
		img_height = water_image.get_height()
	if terrain_params.texture_map:			
		textures_map = terrain_params.texture_map.get_image()
		txt_width = textures_map.get_width()
		txt_height = textures_map.get_height()

	for x in blueprint.world_size:
		for z in blueprint.world_size:
			var coord = Vector2i(x, z)

			var raw_val = noise_image.get_pixel(x % noise_width, z % noise_height).v
			if x % 2 == 1 and z % 2 == 1:
				raw_val = noise_image.get_pixel((x - 1) % noise_width, (z - 1) % noise_height).v
			elif x % 2 == 1:
				raw_val = noise_image.get_pixel((x - 1) % noise_width, z  % noise_height).v
			elif z % 2 == 1:
				raw_val = noise_image.get_pixel(x % noise_width, (z - 1) % noise_height).v

			var normalized = (raw_val + 1) / 2.0
			var level = floor(
				(normalized + terrain_params.height_displacement)
				* world_generation_params.map_height
			)

			var is_water = false
			if water_image and terrain_params.water: 
				var sample_x = x % img_width
				var sample_y = z % img_height
				
				var water_noise_val = water_image.get_pixel(sample_x, sample_y).r
				#print(water_noise_val, "val")
				if water_noise_val > terrain_params.water_threshold:
					is_water = true
					level -= terrain_params.water_levels 
					
			var final_height = level * world_generation_params.tile_height
			
			blueprint.data[coord].height = final_height
			blueprint.data[coord].is_water = is_water
			
			if is_water:
				pass
				#print("wateer", coord)
				blueprint.data[coord].placement_rule = TileInfo.PlacementRule.BLOCKED


	for x in blueprint.world_size:
		for z in blueprint.world_size:
			var coord = Vector2i(x, z)
			var tile = blueprint.data[coord]

			var mi = MeshInstance3D.new()
			mi.mesh = generate_tile_mesh(coord)
			mi.position = Vector3(0, -tile.height, 0)

			if terrain_params.terrain_material:
				mi.material_override = terrain_params.terrain_material
			if terrain_params.texture_map:
				var pix = textures_map.get_pixel(x % txt_width, z % txt_height)
				if texture_data.has(pix):
						mi.material_override = texture_data[pix]

			mi.create_trimesh_collision()
			for child in mi.get_children():
				if child is StaticBody3D:
					child.set_collision_layer_value(9, 1)

			tile.objects.clear()
			tile.objects.append(mi)


func generate_tile_mesh(coord: Vector2i) -> Mesh:
	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	var x = coord.x
	var z = coord.y
	var ts = world_generation_params.tile_size

	var h0 = blueprint.get_height(Vector2i(x, z))  
	var h1 = blueprint.get_height(Vector2i(x + 1, z))  
	var h2 = blueprint.get_height(Vector2i(x, z + 1))  
	var h3 = blueprint.get_height(Vector2i(x + 1, z + 1))  
	
	blueprint.data[coord].height = min(h0,h1,h2,h3)
		
	var v0 = Vector3(0, h0, 0)
	var v1 = Vector3(ts, h1, 0)
	var v2 = Vector3(0, h2, ts)
	var v3 = Vector3(ts, h3, ts)

	var n1 = add_triangle(st, [v0, v1, v2])
	var n2 = add_triangle(st, [v1, v3, v2])

	slopify(n1, n2, coord)

	st.generate_tangents()
	return st.commit()


func add_triangle(st: SurfaceTool, vertices: Array) -> Vector3:
	var normal = ((vertices[2] - vertices[0]).cross(vertices[1] - vertices[0])).normalized()
	for v in vertices:
		var uv = Vector2(v.x, v.z) / float(world_generation_params.tile_size)
		st.set_normal(normal)
		st.set_uv(uv)
		st.add_vertex(v)
	return normal


func slopify(n1: Vector3, n2: Vector3, coord: Vector2i):
	var tile = blueprint.data[coord]
	
	if tile.is_water:
		return 

	var n = abs(n1)

	if n1 != n2 and n1 != Vector3.ZERO:
		tile.placement_rule = TileInfo.PlacementRule.BLOCKED
	elif n.y == 1.0:
		tile.placement_rule = TileInfo.PlacementRule.FLAT
	elif n.x == 0.0:
		tile.placement_rule = TileInfo.PlacementRule.SLOPE_X
	elif n.z == 0.0:
		tile.placement_rule = TileInfo.PlacementRule.SLOPE_Z
