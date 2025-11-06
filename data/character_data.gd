extends Resource
class_name CharacterData

@export var isPlayer: bool = false;
@export var wishSprint: bool = false;
@export var wishDirection: Vector2 = Vector2.ZERO;
@export var CHAR_SPEED: int = 1;
@export var CHAR_SPRINT_SPEED: int = 2;

@export var lastScene: String;
@export var scenePosition: Vector2;
@export var transitioningScene: bool = false;
