extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $bg_l3.position.y > -2:
		$bg_l3.position.y -= delta * 25
		if $bg_l3.position.y < -2:
			$bg_l3.position.y = -2
	if $bg_l2.position.y > -2:
		$bg_l2.position.y -= delta * 25
		if $bg_l2.position.y < -2:
			$bg_l2.position.y = -2
	if $bg_l1.position.y > 0:
		$bg_l1.position.y -= delta * 20
		if $bg_l1.position.y < 0:
			$bg_l1.position.y = 0
	if $bg_l4.position.y > 0:
		$bg_l4.position.y -= delta * 15
		if $bg_l4.position.y < 0:
			$bg_l4.position.y = 0
	if $bg_l5.position.y > 0:
		$bg_l5.position.y -= delta * 10
		if $bg_l5.position.y < 0:
			$bg_l5.position.y = 0
