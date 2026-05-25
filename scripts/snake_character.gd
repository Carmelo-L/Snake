extends CharacterBody2D

enum Direction {UP, DOWN, LEFT, RIGHT}

var speed: int = 50
var direction: Direction = Direction.RIGHT;
var directional_speed: int

func _move_snake(delta: float) -> void:
	if direction == Direction.UP or direction == Direction.DOWN:
		position.y += directional_speed * delta
	elif direction == Direction.LEFT or direction == Direction.RIGHT:
		position.x += directional_speed * delta


func _process(delta: float) -> void:
	_move_snake(delta)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("move_up"):
		direction = Direction.UP
		directional_speed = speed * -1
	elif event.is_action_pressed("move_down"):
		direction = Direction.DOWN
		directional_speed = speed
	elif event.is_action_pressed("move_left"):
		direction = Direction.LEFT
		directional_speed = speed * -1
	elif event.is_action_pressed("move_right"):
		direction = Direction.RIGHT
		directional_speed = speed
