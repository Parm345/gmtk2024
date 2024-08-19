extends Node2D

@onready var game:Node2D = $/root/Game;
@export var player:Node2D;
@export var map:TileMap;

@export var min_pos_t:Vector2 = Vector2.ZERO;
@export var max_pos_t:Vector2 = Vector2.ZERO;

