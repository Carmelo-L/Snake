extends CharacterBody2D

enum Direction {UP, DOWN, LEFT, RIGHT}

const TILE_PIX: int = 16
const ONE_DP: float = 0.1
const REVERSE: int 	= -1

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var speed: int 				= 50
var direction: Direction 	= Direction.RIGHT;
var directional_speed: int 	= speed

var movement_queue: Array[Dictionary] = []
#var movement_event: Dictionary 		= {
#	"direction": Direction.RIGHT,
#	"directional_speed": 0,
#}


func _is_direction_vertical(direction: Direction) -> bool:
	return direction == Direction.UP or direction == Direction.DOWN

func _is_direction_horizontal(direction: Direction) -> bool:
	return direction == Direction.LEFT or direction == Direction.RIGHT

func _move_snake(delta: float) -> void:
	if _is_direction_vertical(direction):
		position.y += directional_speed * delta
	elif _is_direction_horizontal(direction):
		position.x += directional_speed * delta

func _is_valid_turn(new_direction: Direction) -> bool:
	if _is_direction_vertical(direction):
		if new_direction == Direction.LEFT or new_direction == Direction.RIGHT:
			return true
	elif _is_direction_horizontal(direction):
		if new_direction == Direction.UP or new_direction == Direction.DOWN:
			return true
	return false

# Gets remainder of the division between the axis position and the pixel width of a tile
	# This tells us how far within a tile the snake has travelled 
	# This info is then used to find the start and end of the current tile 
	# and return which one the snake is closest to. Only works on positive directions (DOWN, RIGHT)
	# e.g. if the snake's x position is 33.34554, it means it is 1.34554 pixels into a tile which starts at 
	# 32 pixels and ends at 48 pixels
func _positive_turn(pos: float) -> float:
	var current_tile_progress: float	= fmod(pos, TILE_PIX)
	var current_tile_start: float	 	= pos - current_tile_progress
	var current_tile_end: float	 		= pos + (TILE_PIX - current_tile_progress)
	return clamp(current_tile_progress, current_tile_start, current_tile_end)

# does the same thing as _positive_turn except for negative directions (UP, LEFT)
func _negative_turn(pos: float) -> float:
	var current_tile_progress: float	= fmod(pos, TILE_PIX)
	var current_tile_start: float	 	= pos + (TILE_PIX - current_tile_progress)
	var current_tile_end: float	 		= pos - current_tile_progress
	return clamp(current_tile_progress, current_tile_start, current_tile_end)

func _turn_snake(new_direction: Direction, new_d_speed: int) -> void:
	if !_is_valid_turn(new_direction):
		return
	
	if direction == Direction.UP:
		position.y = _negative_turn(position.y)
		animation_player._rotate_left()
	elif direction == Direction.DOWN:
		position.y = _positive_turn(position.y)
		animation_player._rotate_right()
	elif direction == Direction.LEFT:
		position.x = _negative_turn(position.x)
		animation_player._rotate_left()
	elif direction == Direction.RIGHT:
		position.x = _positive_turn(position.x)
		animation_player._rotate_right()

	direction = new_direction
	directional_speed = new_d_speed


func _process(delta: float) -> void:
	_move_snake(delta)

func _input(event: InputEvent) -> void:

	if event.is_action_pressed("move_up"):
		_turn_snake(Direction.UP, speed * REVERSE)
	elif event.is_action_pressed("move_down"):
		_turn_snake(Direction.DOWN, speed)
	elif event.is_action_pressed("move_left"):
		_turn_snake(Direction.LEFT, speed * REVERSE)
	elif event.is_action_pressed("move_right"):
		_turn_snake(Direction.RIGHT, speed)
