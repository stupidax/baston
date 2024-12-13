extends Control

#Life variable
var juicy_update = false
var life_speed = 10
var life_timer = 0.4

#Shield variable
var shield_modulate1 = true
var shield_modulate_value1 = 1
var shield_modulate2 = true
var shield_modulate_value2 = 1
var blocking_P1 = false
var blocking_P2 = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Global/Life_bar/Timer.wait_time = life_timer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("test_1"):
		player_change_life("gain",30,1)
	if Input.is_action_just_pressed("test_2"):
		player_change_life("lose",randi()%5+1,1)
	if Input.is_action_pressed("test_3"):
		player_blocking(1,5,delta)
		if !blocking_P1:
			blocking_P1 = true
			print("P1 Blocking.")
	if blocking_P1 and !Input.is_action_pressed("test_3"):
		blocking_P1 = false
		print("P1 is not Blocking.")
	#if juicy_update:
	#update_juicy_life(delta)
	#Shield
	if Input.is_action_just_pressed("test_4"):
		player_blocking(2,5,delta)
	if !blocking_P1:
		shield_regen(1,5,delta)
	if !blocking_P2:
		shield_regen(2,5,delta)
	shield_limit(delta)

func player_change_life(p_change,p_value,p_player):
	match p_player:
		1:
			if p_change == "gain":
				$Global/Life_bar/juice_life_P1/Life_P1.value += p_value
			else:
				$Global/Life_bar/juice_life_P1/Life_P1.value -= p_value
		2:
			if p_change == "gain":
				$Global/Life_bar/juice_life_P2/Life_P2.value += p_value
			else:
				$Global/Life_bar/juice_life_P2/Life_P2.value -= p_value
	$Global/Life_bar/Timer.wait_time = life_timer
	$Global/Life_bar/Timer.start()
	juicy_update = false
	if $Global/Life_bar/juice_life_P1.value < $Global/Life_bar/juice_life_P1/Life_P1.value:
		$Global/Life_bar/juice_life_P1.value = $Global/Life_bar/juice_life_P1/Life_P1.value
	if $Global/Life_bar/juice_life_P2.value < $Global/Life_bar/juice_life_P2/Life_P2.value:
		$Global/Life_bar/juice_life_P2.value = $Global/Life_bar/juice_life_P2/Life_P2.value

#func update_juicy_life(delta):
	#if $Global/Life_bar/juice_life_P1.value > $Global/Life_bar/juice_life_P1/Life_P1.value:
		#if $Global/Life_bar/juice_life_P1.value - $Global/Life_bar/juice_life_P1/Life_P1.value > 10:
			#$Global/Life_bar/juice_life_P1.value -= 4 * snapped(life_speed * delta,0.1)
		#elif $Global/Life_bar/juice_life_P1.value - $Global/Life_bar/juice_life_P1/Life_P1.value > 5:
			#$Global/Life_bar/juice_life_P1.value -= 2 * snapped(life_speed * delta,0.1)
		#elif $Global/Life_bar/juice_life_P1.value - $Global/Life_bar/juice_life_P1/Life_P1.value > 0:
			#$Global/Life_bar/juice_life_P1.value -= 1 * snapped(life_speed * delta,0.1)
	#if $Global/Life_bar/juice_life_P2.value > $Global/Life_bar/juice_life_P2/Life_P2.value:
		#if $Global/Life_bar/juice_life_P2.value - $Global/Life_bar/juice_life_P2/Life_P2.value > 10:
			#$Global/Life_bar/juice_life_P2.value -= 4 * snapped(life_speed * delta,0.1)
		#elif $Global/Life_bar/juice_life_P2.value - $Global/Life_bar/juice_life_P2/Life_P2.value > 5:
			#$Global/Life_bar/juice_life_P2.value -= 2 * snapped(life_speed * delta,0.1)
		#elif $Global/Life_bar/juice_life_P2.value - $Global/Life_bar/juice_life_P2/Life_P2.value > 0:
			#$Global/Life_bar/juice_life_P2.value -= 1 * snapped(life_speed * delta,0.1)

func _on_timer_timeout() -> void:
	#juicy_update = true
	$Global/Life_bar/juice_life_P2.value = $Global/Life_bar/juice_life_P2/Life_P2.value
	$Global/Life_bar/juice_life_P1.value = 	$Global/Life_bar/juice_life_P1/Life_P1.value

func shield_limit(delta):
	#P1:
	if $Global/Shield_bar/shield_P1.value < 5:
		if $Global/Shield_bar/shield_P1.get_modulate()[0] <= 1.5 and shield_modulate1:
			shield_modulate_value1 += 5 * delta
			if shield_modulate_value1 >= 1.5:
				shield_modulate1 = not shield_modulate1
		elif $Global/Shield_bar/shield_P1.get_modulate()[0] >= 0.8 and !shield_modulate1:
			shield_modulate_value1 -= 5 * delta
			if shield_modulate_value1 <= 0.8:
				shield_modulate1 = not shield_modulate1
	#if $Global/Shield_bar/shield_P1.value < 5:
		#if $Global/Shield_bar/shield_P1.get_modulate()[0] <= 1.5 and !shield_modulate1:
			#shield_modulate_value1 += 5 * delta
			#if shield_modulate_value1 >= 1.5:
				#shield_modulate1 = true
		#elif $Global/Shield_bar/shield_P1.get_modulate()[0] >= 0.8 and shield_modulate1:
			#shield_modulate_value1 -= 5 * delta
			#if shield_modulate_value1 <= 0.8:
				#shield_modulate1 = false
		$Global/Shield_bar/shield_P1.set_modulate(Color(shield_modulate_value1,shield_modulate_value1,shield_modulate_value1,1))
	else :
		$Global/Shield_bar/shield_P1.set_modulate(Color(1,1,1,1))

func player_blocking(p_player, p_shield, delta):
	match p_player:
		1:
			$Global/Shield_bar/shield_P1.value -= snapped(p_shield * delta,0.1)
		2:
			$Global/Shield_bar/shield_P2.value -= snapped(p_shield * delta,0.1)

func shield_regen(p_player,p_shield_regen, delta):
	match p_player:
		1:
			$Global/Shield_bar/shield_P1.value += snapped(delta * p_shield_regen,0.1)

func player_change_shield(p_change,p_value,p_player):
	match p_player:
		1:
			if p_change == "gain":
				$Global/Shield_bar/shield_P1.value += p_value
			else:
				$Global/Shield_bar/shield_P1.value -= p_value
		2:
			if p_change == "gain":
				$Global/Shield_bar/shield_P2.value += p_value
			else:
				$Global/Shield_bar/shield_P2.value -= p_value
