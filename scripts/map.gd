extends Node2D

@export var width: int 	= 16
@export var height: int = 16

const EVEN_TILE_ID: int = 0
const ODD_TILE_ID: int 	= 1
const FOOD_ITEM_ID: int = 0
const ATLAS_DEFAULT := Vector2i(0,0)

@onready var map_items: TileMapLayer = $"Map - items"
@onready var map_background: TileMapLayer = $"Map - background"

var item_seed: RandomNumberGenerator

func _initialise_background() -> void:
	for w in width:
		for h in height:
			var coords := Vector2i(w, h);
			
			if (w + h) % 2 == 0:
				map_background.set_cell(coords, EVEN_TILE_ID, ATLAS_DEFAULT);
			else:
				map_background.set_cell(coords, ODD_TILE_ID, ATLAS_DEFAULT);


func _place_next_item():
	var x: int = item_seed.randi_range(0, width)
	var y: int = item_seed.randi_range(0, height)
	var coords := Vector2i(x, y)
	
	map_items.set_cell(coords, FOOD_ITEM_ID, ATLAS_DEFAULT)

func _initialise_item() -> void:
	item_seed = RandomNumberGenerator.new()
	_place_next_item()

func _initialise_map() -> void:
	_initialise_background()
	_initialise_item()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	_initialise_map()
