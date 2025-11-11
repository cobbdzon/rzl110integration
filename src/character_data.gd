extends Resource
class_name CharacterData

@export var displayName: String;

@export var isPlayer: bool = false;
@export var canMove: bool = true;
@export var cantMoveTime: float = 0;
@export var wishSprint: bool = false;
@export var wishDirection: Vector2 = Vector2.ZERO;

@export var CHAR_ACCEL: int = 1;
@export var CHAR_SPEED: int = 1;
@export var CHAR_SPRINT_SPEED: int = 2;

@export var lastScene: String;
@export var scenePosition: Vector2;
@export var lastAnimDir: String = "front";
@export var transitioningScene: bool = false;

@export var hasStick: bool = false;
@export var questState: int = 0;
