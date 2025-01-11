extends Control

var hit_effect = preload("res://hit_effect.tscn")

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

#charge_node
@onready var charge_front_1 = get_node("/root/Game/front_effect/front_effect_sprite_P1") 
@onready var charge_front_2 = get_node("/root/Game/front_effect/front_effect_sprite_P2") 
@onready var charge_back_1 = get_node("/root/Game/back_effect/back_effect_sprite_P2") 
@onready var charge_back_2 = get_node("/root/Game/back_effect/back_effect_sprite_P2") 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Global/Life_bar/Timer_P1.wait_time = life_timer
	$Global/Life_bar/Timer_P2.wait_time = life_timer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("test_1"):
		var random_player = randi()%2+1
		var random_attack = randi()%3+1
		player_get_hit(random_player, random_attack)
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

func start_charge(p_player):
	match p_player:
		1:
			charge_front_1.visible = true
			charge_back_1.visible = true
		2: 
			charge_front_2.visible = true
			charge_back_2.visible = true

func upgrade_charge(p_player):
	match p_player:
		1: 
			if charge_front_1.animation == "level_0":
				charge_front_1.play("level_1")
				charge_back_1.play("level_1")
			elif charge_front_1.animation == "level_1":
				charge_front_1.play("level_2")
				charge_back_1.play("level_2")
		2:
			if charge_front_2.animation == "level_0":
				charge_front_2.play("level_1")
				charge_back_2.play("level_1")
			elif charge_front_2.animation == "level_1":
				charge_front_2.play("level_2")
				charge_back_2.play("level_2")

func stop_charge(p_player):
	match p_player:
		1: 
			charge_front_1.visible = false
			charge_back_1.visible = false
			charge_front_1.play("level_0")
			charge_back_1.play("level_0")
		2: 
			charge_front_2.visible = false
			charge_back_2.visible = false
			charge_front_2.play("level_0")
			charge_back_2.play("level_0")

func player_get_hit(p_player,p_attack):
	var new_hit = hit_effect.instantiate()
	# x : 25 to 30
	# y : 20 to 30
	var random_pos_x = 25 + randi()%5+1
	if p_player == 2:
		random_pos_x += 20
	var random_pos_y = 20 + randi()%10+1
	new_hit.position.x = random_pos_x
	new_hit.position.y = random_pos_y
	match p_attack:
		1:
			new_hit.init("hit_light")
		2:
			new_hit.init("hit_medium")
		3:
			new_hit.init("hit_strong")
	get_node("/root/Game/front_effect/hit_display").add_child(new_hit)

func player_parade_successfull(p_player):
	var new_hit = hit_effect.instantiate()
	# x : 25 to 30
	# y : 20 to 30
	var random_pos_x = 25 + randi()%5+1
	if p_player == 2:
		random_pos_x += 20
	var random_pos_y = 20 + randi()%10+1
	new_hit.position.x = random_pos_x
	new_hit.position.y = random_pos_y
	new_hit.init("hit_parade")
	get_node("/root/Game/front_effect/hit_display").add_child(new_hit)

func player_block_successfull(p_player):
	var new_hit = hit_effect.instantiate()
	# x : 25 to 30
	# y : 20 to 30
	var random_pos_x = 25 + randi()%5+1
	if p_player == 2:
		random_pos_x += 20
	var random_pos_y = 20 + randi()%10+1
	new_hit.position.x = random_pos_x
	new_hit.position.y = random_pos_y
	new_hit.init("hit_block")
	get_node("/root/Game/front_effect/hit_display").add_child(new_hit)
