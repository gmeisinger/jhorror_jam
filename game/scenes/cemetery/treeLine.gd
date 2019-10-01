extends Node2D

var tree_textures = [
preload("res://assets/images/environment/tree1.png"),
preload("res://assets/images/environment/tree2.png"),
preload("res://assets/images/environment/tree3.png"),
preload("res://assets/images/environment/tree4.png"),
preload("res://assets/images/environment/tree5.png"),
preload("res://assets/images/environment/tree6.png"),
preload("res://assets/images/environment/tree7.png")
]

var lightning_outline_class = preload("res://scenes/storm/lightningOutline.tscn")

export var area : Vector2 = Vector2(240,1000)
export var radius : float = 80.0

# this class was created by following along with this excellent video
# https://youtu.be/7WcmyxyFO7o
class PoissonDiscSampling:
	func generate_points(radius: float, sample_region_size: Vector2, num_samples_before_rejection: int = 30) -> Array:
		var cell_size : float = radius/sqrt(2)
		var columns = ceil(sample_region_size.x/cell_size)
		var rows = ceil(sample_region_size.y/cell_size)
		var grid = []
		for i in range(rows):
			var row = []
			for j in range(columns):
				row.append(0)
			grid.append(row)
		var points = []
		var spawn_points = []
		var radius_squared = radius*radius
		var loop_limit = columns*rows*100
		var loop_counter = 0
		
		spawn_points.append(sample_region_size/2.0)
		
		while spawn_points.size() > 0 && loop_counter < loop_limit:
			loop_counter += 1
			var spawn_index = randi() % spawn_points.size()
			var spawn_center = spawn_points[spawn_index]
			var candidate_accepted = false
			for i in range(num_samples_before_rejection):
				var angle : float = rand_range(0, 2*PI)
				var dir = Vector2(sin(angle), cos(angle))
				var candidate = spawn_center + dir * rand_range(radius, 2*radius)
				if(is_valid(candidate, sample_region_size, cell_size, points, grid, columns, rows, radius_squared)):
					points.append(candidate)
					spawn_points.append(candidate)
					grid[int(candidate.y/cell_size)][int(candidate.x/cell_size)] = points.size()
					candidate_accepted = true
					break
			if !candidate_accepted:
				spawn_points.remove(spawn_index)
		
		if loop_counter >= loop_limit:
			print("loop limit met for generationg points: limit=" + str(loop_limit) + " # of pts=" + str(points.size()))
		
		return points
		
	func is_valid(candidate, sample_region_size, cell_size, points, grid, columns, rows, radius_squared):
		if !(candidate.x >= 0.0 && candidate.x <= sample_region_size.x && candidate.y >= 0.0 && candidate.y <= sample_region_size.y):
			return false
		
		var cell_x = int(candidate.x/cell_size)
		var cell_y = int(candidate.y/cell_size)
		var search_start_x = max(0, cell_x - 2)
		var search_end_x = min(cell_x+2, columns-1)
		var search_start_y = max(0, cell_y- 2)
		var search_end_y = min(cell_y+2, rows-1)
		for x in range(search_start_x, search_end_x):
			for y in range(search_start_y, search_end_y):
				var point_index = grid[y][x]-1
				if point_index != -1:
					var distance_squared = candidate.distance_squared_to(points[point_index])
					if distance_squared < radius_squared:
						return false
		
		return true


class Vector2YSorter:
    static func sort(a, b):
        if a.y < b.y:
            return true
        return false

func _ready():
	call_deferred("populate_area")

func populate_area():
	var tic_start = OS.get_ticks_msec()
	var g = PoissonDiscSampling.new()
	var points = g.generate_points(radius, area, 60)
	points.sort_custom(Vector2YSorter.new(), "sort")
	for p in points:
		var tree_texture_index = randi()%tree_textures.size()
		var tree_texture = tree_textures[tree_texture_index]
		var tree_sprite = Sprite.new()
		tree_sprite.texture = tree_texture
		add_child(tree_sprite)
		tree_sprite.global_position = global_position + p
		tree_sprite.add_child(lightning_outline_class.instance())
	var tic_end = OS.get_ticks_msec()
	print(name + " populate_area time: " + str(tic_end-tic_start))
