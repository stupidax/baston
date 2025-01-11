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
var shield_break_P1 = false
var shield_break_P2 = false
var shield_reset_P1 = 3
var shield_reset_P2 = 3
var can_block_P1 = true
var can_block_P2 = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Global/Life_bar/Timer_P1.wait_time = life_timer
	$Global/Life_bar/Timer_P2.wait_time = life_timer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("test_1"):
		player_change_life("gain",30,1)
	if Input.is_action_just_pressed("test_2"):
		player_change_life("lose",randi()%5+1,1)
	#if juicy_update:
	#update_juicy_life(delta)
	#Shield
	if Input.is_action_pressed("test_3") and can_block_P1:
		player_blocking(1,2,delta)
		if !blocking_P1:
			blocking_P1 = true
			print("P1 Blocking.")
	if blocking_P1 and !Input.is_action_pressed("test_3"):
		blocking_P1 = false
		print("P1 is not Blocking.")
	if !blocking_P1 and !shield_break_P1:
		shield_regen(1,1,delta)
	if !blocking_P2 and !shield_break_P2:
		shield_regen(2,1,delta)
	#shield break and reset
	if !shield_break_P1:
		shield_limit(1,delta)
		shield_break(1)
	elif shield_break_P1:
		shield_reset(1,delta)
	if !shield_break_P2:
		shield_limit(2,delta)
		shield_break(2)
	elif shield_break_P2:
		shield_reset(2,delta)

func player_change_life(p_change,p_value,p_player):
	match p_player:
		1:
			if p_change == "gain":
				$Global/Life_bar/juice_life_P1/Life_P1.value += p_value
			else:
				$Global/Life_bar/juice_life_P1/Life_P1.value -= p_value
			$Global/Life_bar/Timer_P1.wait_time = life_timer
			$Global/Life_bar/Timer_P1.start()
		2:
			if p_change == "gain":
				$Global/Life_bar/juice_life_P2/Life_P2.value += p_value
			else:
				$Global/Life_bar/juice_life_P2/Life_P2.value -= p_value
			$Global/Life_bar/Timer_P2.wait_time = life_timer
			$Global/Life_bar/Timer_P2.start()

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

func shield_limit(p_player,delta):
	match p_player:
		1:
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
				$Global/Shield_bar/shield_P1.set_modulate(Color(shield_modulate_value1,shield_modulate_value1,shield_modulate_value1,1))
			else :
				$Global/Shield_bar/shield_P1.set_modulate(Color(1,1,1,1))
		2:
			#P2:
			if $Global/Shield_bar/shield_P2.value < 5:
				if $Global/Shield_bar/shield_P2.get_modulate()[0] <= 1.5 and shield_modulate2:
					shield_modulate_value2 += 5 * delta
					if shield_modulate_value2 >= 1.5:
						shield_modulate2 = not shield_modulate2
				elif $Global/Shield_bar/shield_P2.get_modulate()[0] >= 0.8 and !shield_modulate2:
					shield_modulate_value2 -= 5 * delta
					if shield_modulate_value2 <= 0.8:
						shield_modulate2 = not shield_modulate2
				$Global/Shield_bar/shield_P2.set_modulate(Color(shield_modulate_value1,shield_modulate_value1,shield_modulate_value2,1))
			else :
				$Global/Shield_bar/shield_P2.set_modulate(Color(1,1,1,1))

func player_blocking(p_player, p_shield, delta):
	match p_player:
		1:
			#$Global/Shield_bar/shield_P1.value -= snapped(p_shield * delta,0.01)
			$Global/Shield_bar/shield_P1.value -= p_shield * delta
		2:
			#$Global/Shield_bar/shield_P2.value -= snapped(p_shield * delta,0.01)
			$Global/Shield_bar/shield_P2.value -= p_shield * delta

func shield_regen(p_player,p_shield_regen, delta):
	match p_player:
		1:
			#$Global/Shield_bar/shield_P1.value += snapped(delta * p_shield_regen,0.01)
			$Global/Shield_bar/shield_P1.value += delta * p_shield_regen
		2:
			#$Global/Shield_bar/shield_P2.value += snapped(delta * p_shield_regen,0.01)
			$Global/Shield_bar/shield_P2.value += delta * p_shield_regen

func shield_break(p_player):
	match p_player:
		1:
			if $Global/Shield_bar/shield_P1.value <= 0:
				print("Shield P1 Break ! (not blocking)")
				can_block_P1 = false
				blocking_P1 = false
				shield_break_P1 = true
				$Global/Shield_bar/Timer_shield_P1.wait_time = shield_reset_P1
				$Global/Shield_bar/Timer_shield_P1.start()
				$Global/Shield_bar/shield_P1.set_modulate(Color(1,1,1,1))
				shield_modulate1 = true
				shield_modulate_value1 = 1.0
		2:
			if $Global/Shield_bar/shield_P2.value <= 0:
				shield_break_P2 = true

func shield_reset(p_player,delta):
	match p_player:
		1:
			#P1:
			if $Global/Shield_bar/shield_P1.get_modulate()[0] <= 1.0 and shield_modulate1:
				shield_modulate_value1 += 1 * delta
				if shield_modulate_value1 >= 1.0:
					shield_modulate1 = not shield_modulate1
			elif $Global/Shield_bar/shield_P1.get_modulate()[0] >= 0.2 and !shield_modulate1:
				shield_modulate_value1 -= 1 * delta
				if shield_modulate_value1 <= 0.2:
					shield_modulate1 = not shield_modulate1
			$Global/Shield_bar/shield_P1.set_modulate(Color(shield_modulate_value1,shield_modulate_value1,shield_modulate_value1,1))


func _on_timer_p_2_timeout() -> void:
	#juicy_update = true
	$Global/Life_bar/juice_life_P2.value = $Global/Life_bar/juice_life_P2/Life_P2.value


func _on_timer_p_1_timeout() -> void:
	#juicy_update = true
	$Global/Life_bar/juice_life_P1.value = 	$Global/Life_bar/juice_life_P1/Life_P1.value


func _on_timer_shield_p_1_timeout() -> void:
	shield_break_P1 = false
	can_block_P1 = true
	$Global/Shield_bar/shield_P1.value = $Global/Shield_bar/shield_P1.max_value
	$Global/Shield_bar/shield_P1.set_modulate(Color(1,1,1,1))
