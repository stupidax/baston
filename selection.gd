extends Node2D

var P1_pos = 0
var P2_pos = 2
var P1_valid = false
var P2_valid = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_perso_P1(P1_pos)
	set_perso_P2(P2_pos)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event.is_action_pressed("p1_attack") and !P1_valid:
		P1_pos += 1
		if P1_pos > 2:
			P1_pos = 0
		set_perso_P1(P1_pos)
	elif event.is_action_pressed("p1_parade"):
		valid_P1(P1_pos)
	if event.is_action_pressed("p2_attack") and !P2_valid:
		P2_pos += 1
		if P2_pos > 2:
			P2_pos = 0
		set_perso_P2(P2_pos)
	elif event.is_action_pressed("p2_parade"):
		valid_P2(P2_pos)
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func set_perso_P1(p_select):
	for i in 3:
		reset_carousel_P1(i)
	P1_portrait(p_select)
	get_node("carousel_"+str(p_select)+"/select1_bg").visible = true
	get_node("carousel_"+str(p_select)+"/player1_select").visible = true

func reset_carousel_P1(p_num):
	get_node("carousel_"+str(p_num)+"/select1_bg").visible = false
	get_node("carousel_"+str(p_num)+"/player1_select").visible = false

func set_perso_P2(p_select):
	for i in 3:
		reset_carousel_P2(i)
	P2_portrait(p_select)
	get_node("carousel_"+str(p_select)+"/select2_bg").visible = true
	get_node("carousel_"+str(p_select)+"/player2_select").visible = true

func reset_carousel_P2(p_num):
	get_node("carousel_"+str(p_num)+"/select2_bg").visible = false
	get_node("carousel_"+str(p_num)+"/player2_select").visible = false

func valid_P1(p_select):
	if P1_valid:
		P1_valid = false
		get_node("carousel_"+str(p_select)+"/select1_bg").play("idle")
		get_node("carousel_"+str(p_select)+"/player1_select").play("idle")
	else:
		get_node("carousel_"+str(p_select)+"/select1_bg").play("valid")
		get_node("carousel_"+str(p_select)+"/player1_select").play("valid")
		P1_valid = true

func valid_P2(p_select):
	if P2_valid:
		P2_valid = false
		get_node("carousel_"+str(p_select)+"/select2_bg").play("idle")
		get_node("carousel_"+str(p_select)+"/player2_select").play("idle")
	else:
		get_node("carousel_"+str(p_select)+"/select2_bg").play("valid")
		get_node("carousel_"+str(p_select)+"/player2_select").play("valid")
		P2_valid = true

func P1_portrait(p_select):
	match p_select:
		0:
			$P1.play("Katana")
		1:
			$P1.play("Dagger")
		2:
			$P1.play("Axe")

func P2_portrait(p_select):
	match p_select:
		0:
			$P2.play("Katana")
		1:
			$P2.play("Dagger")
		2:
			$P2.play("Axe")
