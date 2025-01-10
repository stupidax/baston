extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Player.position.y > 18:
		$Player.position.y -= delta * 25
		if $Player.position.y < 18:
			$Player.position.y = 18
	if $Player2.position.y > 1:
		$Player2.position.y -= delta * 25
		if $Player2.position.y < 1:
			$Player2.position.y = 1
