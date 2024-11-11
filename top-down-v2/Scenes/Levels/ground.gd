extends TileMapLayer
@onready var decorations: TileMapLayer = $"../Decorations"

func _use_tile_data_runtime_update(coords):
	if coords in decorations.get_used_cells_by_id(1):
		return true
	return false
	
func _tile_Data_runtime_update(coords: Vector2i, tile_data: TileData):
	if coords in decorations.get_used_cells_by_id(1):
		tile_data.set_navigation_polygon(0, null)
