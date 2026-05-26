extends CharacterBody2D

enum Direction {UP, DOWN, LEFT, RIGHT}

const TILE_PIX: int = 16

var speed: int = 50
var direction: Direction = Direction.RIGHT;
var directional_speed: int = speed

var movement_queue: Array[Dictionary] = []
var movement_event: Dictionary = {
	"direction": Direction.RIGHT,
	"directional_speed": 0,
}


func _move_snake(delta: float) -> void:
	if direction == Direction.UP or direction == Direction.DOWN:
		position.y += directional_speed * delta
	elif direction == Direction.LEFT or direction == Direction.RIGHT:
		position.x += directional_speed * delta


func _process(delta: float) -> void:
	print(position.x, " ", position.y)

	if fmod(snapped(position.x, 0.1), TILE_PIX) == 0 and fmod(snapped(position.y, 0.1), TILE_PIX) == 0:
		var m = movement_queue.pop_front()
		if (m != null):
			movement_event = m
			direction = movement_event.direction
			directional_speed = movement_event.directional_speed
		
	_move_snake(delta)

func _input(event: InputEvent) -> void:

	if event.is_action_pressed("move_up"):
		movement_event.direction = Direction.UP
		movement_event.directional_speed = speed * -1
	elif event.is_action_pressed("move_down"):
		movement_event.direction = Direction.DOWN
		movement_event.directional_speed = speed
	elif event.is_action_pressed("move_left"):
		movement_event.direction = Direction.LEFT
		movement_event.directional_speed = speed * -1
	elif event.is_action_pressed("move_right"):
		movement_event.direction = Direction.RIGHT
		movement_event.directional_speed = speed
	
	movement_queue.append(movement_event)
