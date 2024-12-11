extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("test_1"):
		player_change_life("gain",randi()%10+1,1)
	if Input.is_action_just_pressed("test_2"):
		player_change_life("lose",randi()%10+1,1)

func player_change_life(p_change,p_life,p_player):
	match p_player:
		1:
			if p_change == "gain":
				$Global/Life_bar/juice_life_P1/Life_P1.value += p_life
			else:
				$Global/Life_bar/juice_life_P1/Life_P1.value -= p_life
		2:
			if p_change == "gain":
				$Global/Life_bar/juice_life_P2/Life_P2.value += p_life
			else:
				$Global/Life_bar/juice_life_P2/Life_P2.value -= p_life

func _on_timer_timeout() -> void:
	if $Global/Life_bar/juice_life_P1.value > $Global/Life_bar/juice_life_P1/Life_P1.value:
		$Global/Life_bar/juice_life_P1.value -= 1
	if $Global/Life_bar/juice_life_P2.value > $Global/Life_bar/juice_life_P2/Life_P2.value:
		$Global/Life_bar/juice_life_P2.value -= 1
	if $Global/Life_bar/juice_life_P1.value < $Global/Life_bar/juice_life_P1/Life_P1.value:
		$Global/Life_bar/juice_life_P1.value = $Global/Life_bar/juice_life_P1/Life_P1.value
	if $Global/Life_bar/juice_life_P2.value < $Global/Life_bar/juice_life_P2/Life_P2.value:
		$Global/Life_bar/juice_life_P2.value = $Global/Life_bar/juice_life_P2/Life_P2.value
