extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $bg_l1.position.y > 23:
		$bg_l1.position.y -= delta * 30
		if $bg_l1.position.y < 23:
			$bg_l1.position.y = 23
