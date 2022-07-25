class_name Wall
extends TileMap

const OFFSET_TO_IDX: Dictionary = {
	Vector2(0, -1): [1, 4, 7],
	Vector2(0, 1): [2, 5, 6],
	Vector2(-1, 0): [0, 4, 6],
	Vector2(1, 0): [3, 5, 7],
	Vector2(-1, -1): [0, 1, 4], # NW
	Vector2(-1, 1): [0, 2, 6],  # SW
	Vector2(1, -1): [1, 3, 7], # NE
	Vector2(1, 1): [2, 3, 5], # SE
}
const OFFSET_TO_QUARTERS: Dictionary = {
	Vector2(0, -1): PoolVector2Array([Vector2(0, 0), Vector2(1, 0)]),
	Vector2(0, 1): PoolVector2Array([Vector2(0, 1), Vector2(1, 1)]),
	Vector2(-1, 0): PoolVector2Array([Vector2(0, 0), Vector2(0, 1)]),
	Vector2(1, 0): PoolVector2Array([Vector2(1, 0), Vector2(1, 1)]),
	Vector2(-1, -1): PoolVector2Array([Vector2(0, 0)]),
	Vector2(-1, 1): PoolVector2Array([Vector2(0, 1)]),
	Vector2(1, -1): PoolVector2Array([Vector2(1, 0)]),
	Vector2(1, 1): PoolVector2Array([Vector2(1, 1)]),
}


func quarter_to_full(pos: Vector2) -> Vector2:
	return Vector2(int(pos.x)/2, int(pos.y)/2)


func has_wall(pos: Vector2, offset: Vector2):
	var result = true
	for q_offset in OFFSET_TO_QUARTERS[offset]:
		var q_pos = pos * 2 + q_offset
		result = OFFSET_TO_IDX[offset].has(get_cellv(q_pos)) and result
	return result


func test_has_wall(pos: Vector2):
	var no_wall = true
	for offset in OFFSET_TO_IDX.keys():
		if has_wall(pos, offset):
			print(pos, ' ', offset, ' has wall')
			no_wall = false
	if no_wall:
		print(pos, ' no wall')
