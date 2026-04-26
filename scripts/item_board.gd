extends NinePatchRect

@onready var B: Node2D = $".."
@export var page = 0
@export var sel = Vector2(0,0)
#序列计算sel.x+sel.y*2+page*4
var sl = sel.x+sel.y*2+page*4#被sll()取代了

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sel = Vector2(0,0)
	page = 0#初始化一下防崩


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sl = sll()
	if B.slmode and B.selection == 2:
		show()
		if B.xe:
			$iname1.show()
			$iname2.show()
			$iname3.show()
			$iname4.show()
			$page.show()
			$sl_soul.show()
			$msg.hide()
		else:
			$iname1.hide()
			$iname2.hide()
			$iname3.hide()
			$iname4.hide()
			$page.hide()
			$sl_soul.hide()
			$msg.show()
	else:
		hide()
	if len(G.bag) <= 4:
		page = 0
	if B.slmode and B.selection == 2:
		if B.xe:
			if Input.is_action_just_pressed("ui_down"):
				G.play("res://sounds/choose.wav")
				sel.y += 1
				if sel.y > 1 or len(G.bag)-1 < sll():
					sel.y = 0
			if Input.is_action_just_pressed("ui_up"):
				G.play("res://sounds/choose.wav")
				sel.y -= 1
				if sel.y < 0:
					sel.y = 1
					if len(G.bag)-1 < sll():
						sel.y = 0
			if Input.is_action_just_pressed("ui_right"):
				G.play("res://sounds/choose.wav")
				sel.x += 1
				if sel.x > 1 or len(G.bag)-1 < sll():
					sel.x = 0
					if page == 0 and len(G.bag) > 4:
						page = 1
					else:
						page = 0
					if len(G.bag)-1 < sll():
						sel.y = 0
			if Input.is_action_just_pressed("ui_left"):
				G.play("res://sounds/choose.wav")
				sel.x -= 1
				if sel.x < 0:
					sel.x = 1
					if page == 0 and len(G.bag) > 4:
						page = 1
					else:
						page = 0
					if len(G.bag)-1 < sll():
						sel.x = 0
			if Input.is_action_just_pressed("z"):
				B.xe = false
				$msg.text = ""
				await get_tree().create_timer(0.01).timeout
				G.play("res://sounds/confirm.wav")
				use()
		else:
			if $msg.completed:
				if Input.is_action_just_pressed("z"):
					B.xe = true
					B.slmode = false
					B.enemy_turn()
			else:
				if Input.is_action_just_pressed("x"):
					$msg.visible_characters = -1
					$msg.completed = true
	if sel == Vector2(0,0):
		$sl_soul.position = $iname1.position + Vector2(-35,25)
	if sel == Vector2(1,0):
		$sl_soul.position = $iname2.position + Vector2(-35,25)
	if sel == Vector2(0,1):
		$sl_soul.position = $iname3.position + Vector2(-35,25)
	if sel == Vector2(1,1):
		$sl_soul.position = $iname4.position + Vector2(-35,25)
	if page == 0:
		$page.text = "第一页"
		if	len(G.bag) >= 1:
			$iname1.text = "* "+G.itemmsg[G.bag[0]][0]
		else:
			$iname1.text = " "
		if	len(G.bag) >= 2:
			$iname2.text = "* "+G.itemmsg[G.bag[1]][0]
		else:
			$iname2.text = " "
		if	len(G.bag) >= 3:
			$iname3.text = "* "+G.itemmsg[G.bag[2]][0]
		else:
			$iname3.text = " "
		if	len(G.bag) >= 4:
			$iname4.text = "* "+G.itemmsg[G.bag[3]][0]
		else:
			$iname4.text = " "
	if page == 1:
		$page.text = "第二页"
		if	len(G.bag) >= 5:
			$iname1.text = "* "+G.itemmsg[G.bag[4]][0]
		else:
			$iname1.text = " "
		if	len(G.bag) >= 6:
			$iname2.text = "* "+G.itemmsg[G.bag[5]][0]
		else:
			$iname2.text = " "
		if	len(G.bag) >= 7:
			$iname3.text = "* "+G.itemmsg[G.bag[6]][0]
		else:
			$iname3.text = " "
		if	len(G.bag) >= 8:
			$iname4.text = "* "+G.itemmsg[G.bag[7]][0]
		else:
			$iname4.text = " "
	

func sll():
	return sel.x+sel.y*2+page*4
func use():
	$msg.completed = false
	if sll() <= len(G.bag)-1:
		if G.itemmsg[G.bag[sll()]][2] == 0:#摆设输出文本
			putput(G.itemmsg[G.bag[sll()]][4])
		if G.itemmsg[G.bag[sll()]][2] == 1:#吃食	
			G.play2("res://sounds/heal.wav")
			if G.HP + G.itemmsg[G.bag[sll()]][3] >= G.HP_max:
				G.HP = G.HP_max
			else:
				G.HP += G.itemmsg[G.bag[sll()]][3]
			putput(G.itemmsg[G.bag[sll()]][4])
			G.bag.remove_at(sll())
		sel = Vector2.ZERO
func putput(txt):
	$msg.type(txt)
