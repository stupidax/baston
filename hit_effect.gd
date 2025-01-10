extends AnimatedSprite2D

var anim_activ

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play(anim_activ)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func init(p_anim) -> void:
	anim_activ = p_anim

func _on_animation_finished() -> void:
	queue_free()
