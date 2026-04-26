extends Node2D

@onready var ssl: Sprite2D = $sl_soul
@export var slmode :bool= false
@export var xe :bool= true
@export var selection : int = 0
@export var enhp: Array = []#敌人hp，史山，不可用ene[n].hp代替，ene[n].hp是配置血量，不是实时血量
@export var enhm: Array = []#敌人血量上限，史山，可用ene[n].hpm代替
@export var enx: Array = []#敌人x坐标，史山，可用ene[n].position.x代替
@export var ene: Array = []#敌人列表，别动
@export var enlf: Array = []#敌人是否存活，别动
@export var got_exp : int = 0
@export var got_gold : int = 0
@export var win:bool = false
@export var wave : int = 0
@export var board_ls: int  = 0 #0=square,1=long
#自定义关卡区块
@export var enemies : Array = ["res://scenes/enemies/enemy.tscn", "res://scenes/enemies/cry_birdie.tscn", "res://scenes/enemies/enemy.tscn"]
@export_file_path("*tscn") var winto : String = "res://scenes/bagpack.tscn"#你赢了去的地方
@export var escape:bool = true
@export var random :bool= true
@export var waves : Dictionary= {
	0 : ["","* 海绵宝宝会吃人你知道吗",1],
	1 : ["res://scenes/danmu/sponge_eat.tscn","* 第一回合弹幕结束",7, Vector2(82,125)],
	2 : ["res://scenes/danmu/flower_danmu.tscn","* 第三回合弹幕预备",5, Vector2(320,110)],
	3 : ["res://scenes/danmu/two_flowers.tscn","* 鹅鹅鹅",3, Vector2(320,110)],
	4 : ["res://scenes/danmu/four_nf.tscn","* 1225",10,],
	5 : ["res://scenes/danmu/four_nf2.tscn","* Bilibili关注航空企鹅喵~",7.5],
	6 : ["res://scenes/danmu/normal_flower.tscn","* 牛逼",5, Vector2(320,310)],
	7 : ["res://scenes/danmu/sleeppls.tscn","* 诶呦卧槽循环了",5, ]
	}
var talking :bool= false
var guys: int  = 0
var comp_guys:Array = []

func _ready() -> void:
	print(enemies)
	var enzi = len(enemies)
	for i in enemies:
		enzi -= 1
		var en = load(i).instantiate()
		enhp.append(en.hp)
		enhm.append(en.hpm)
		en.z_index = enzi
		$enemies.add_child(en)
	ene = $enemies.get_children()
	await get_tree().create_timer(0).timeout
	for i in ene:
		enlf.append(true)
		enx.append(i.position.x)

func _process(delta: float) -> void:
	if talking and guys == 0:
		talking = false
		true_enemy_turn()
	if talking:
		var prsd = 0
		if not guys == len(comp_guys):
			for i in range(len(ene)):
				if ene[i].cantalk and ene[i].bub.t.completed and (i not in comp_guys):
					comp_guys.append(i)
					print("ok")
		if guys == len(comp_guys):
			await get_tree().create_timer(0.1).timeout
			if Input.is_action_just_pressed("z") and prsd <= 0:
				prsd += 1
				pass#我这里加个pass就不会产生出现两次执行了鹅鹅鹅饿鹅鹅鹅鹅饿鹅
				talking = false
				print("yyyyyy")
				for i in range(len(ene)):
					if ene[i].cantalk and ene[i].bub.t.completed:
						ene[i].bub.queue_free()
				true_enemy_turn()
	if win:
		$CharacterBody2D.hide()
		if $board/msg_txt.completed:
			await get_tree().create_timer(0.5).timeout
			get_tree().change_scene_to_file(winto)
	enmanager()
	if not G.battle:
		if board_ls == 0:
			board_ls = 1
			$AP.play("long_board")
			if random:
				$board/msg_txt.type(waves[randi_range(0,len(waves)-1)][1])
			else:
				$board/msg_txt.type(waves[wave][1])
		slection()
		if slmode:
			$board/msg_txt.hide()
		else:
			$board/msg_txt.show()
	else:
		if win:
			$board/msg_txt.show()
			$CharacterBody2D.hide()
		else:
			$board/msg_txt.hide()
func slection():
	if not win:
		if not slmode:
			$sl_soul.show()
			if Input.is_action_just_pressed("ui_right"):
				G.play("res://sounds/choose.wav")
				selection += 1
				if selection >= 4:
					selection = 0
			if Input.is_action_just_pressed("ui_left"):
				G.play("res://sounds/choose.wav")
				selection -= 1
				if selection < 0:
					selection = 3
		else:
			$sl_soul.hide()
			if Input.is_action_just_pressed("x") and xe:
				G.play("res://sounds/confirm.wav")
				slmode = false
			
		if selection == 0:
			$sl_soul.position.x = $selections/fight.position.x - 40
			$selections/fight/AnimatedSprite2D.play("1")
			$selections/act/AnimatedSprite2D.play("0")
			$selections/item/AnimatedSprite2D.play('0')
			$selections/mercy/AnimatedSprite2D.play("0")
		if selection == 1:
			$sl_soul.position.x = $selections/act.position.x - 40
			$selections/fight/AnimatedSprite2D.play("0")
			$selections/act/AnimatedSprite2D.play("1")
			$selections/item/AnimatedSprite2D.play('0')
			$selections/mercy/AnimatedSprite2D.play("0")
		if selection == 2:
			$sl_soul.position.x = $selections/item.position.x - 40
			$selections/fight/AnimatedSprite2D.play("0")
			$selections/act/AnimatedSprite2D.play("0")
			$selections/item/AnimatedSprite2D.play('1')
			$selections/mercy/AnimatedSprite2D.play("0")
		if selection == 3:
			$sl_soul.position.x = $selections/mercy.position.x - 40
			$selections/fight/AnimatedSprite2D.play("0")
			$selections/act/AnimatedSprite2D.play("0")
			$selections/item/AnimatedSprite2D.play('0')
			$selections/mercy/AnimatedSprite2D.play("1")
		if Input.is_action_just_pressed("z") and not slmode:
			G.play2("res://sounds/confirm.wav")
			await get_tree().create_timer(0).timeout
			slmode = true
	
func true_enemy_turn():
	talking = false
	guys = 0
	comp_guys = []
	if enlf.count(true) > 0:
		if random:
			wave = randi_range(0,len(waves)-1)
		else:
			wave += 1
		#G.battle = true
		board_ls = 0
		if wave >= len(waves):
			wave = 1
		#$AP.play("square_board")
		$sl_soul.hide()
		$Timer.wait_time = waves[wave][2]
		$Timer.start()
		if waves[wave][0]:
			var danmu = load(waves[wave][0]).instantiate()
			danmu.z_index = 2
			if len(waves[wave]) <= 3:
				danmu.position = Vector2(320,310)
			elif waves[wave][3] == null:
				danmu.position = Vector2(320,310)
				
			else:
				danmu.position = waves[wave][3]
			danmu.add_to_group("danmu")
			add_child(danmu)
	else:
		mvp()
		
func enemy_turn():#先说话先。
	$selections/fight/AnimatedSprite2D.play("0")
	$selections/act/AnimatedSprite2D.play("0")
	$selections/item/AnimatedSprite2D.play('0')
	$selections/mercy/AnimatedSprite2D.play("0")
	$CharacterBody2D.position = Vector2(320,310)
	for i in range(len(ene)):
		if enlf[i] and ene[i].cantalk:	
			guys += 1
	print("说话的怪数",guys)
	for i in ene:
		if i.cantalk :
			i.talk(i.dlg[randi_range(i.randlg[0],i.randlg[1])])
	G.battle = true
	$AP.play("square_board")
	talking = true

func _on_timer_timeout() -> void:
	var bullets = get_tree().get_nodes_in_group("danmu")
	for child in bullets:
		child.queue_free()
	G.battle = false
	slmode = false
	slection()
	
func enmanager():
	if len(ene) >= 1:
		if enhp[0] <= 0 and enlf[0]:
			got_exp += ene[0].exp
			got_gold += ene[0].gold
			enlf[0] = false
			ene[0].died = true
			await get_tree().create_timer(0.5).timeout
			var tween = get_tree().create_tween()
			tween.tween_property(ene[0], "modulate", Color(0,0,0,0), 0.5)
			$fightboard/VBoxContainer/ename.modulate = Color(1,1,1,0.5)
			$actboard/VBoxContainer/ename.modulate = Color(1,1,1,0.5)
		if ene[0].mer >= 100:
			if enlf[0]:
				$fightboard/VBoxContainer/ename.modulate = Color(1, 1, 0.0, 1.0)
				$actboard/VBoxContainer/ename.modulate = Color(1, 1, 0.0, 1.0)
			else:
				$fightboard/VBoxContainer/ename.modulate = Color(1,1,1,0.5)
				$actboard/VBoxContainer/ename.modulate = Color(1,1,1,0.5)
	if len(ene) >= 2:
		if enhp[1] <= 0 and enlf[1]:
			got_exp += ene[1].exp
			got_gold += ene[1].gold
			enlf[1] = false
			ene[1].died = true
			await get_tree().create_timer(0.5).timeout
			var tween2 = get_tree().create_tween()
			tween2.tween_property(ene[1], "modulate", Color(0,0,0,0), 0.5)
			$fightboard/VBoxContainer/ename2.modulate = Color(1,1,1,0.5)
			$actboard/VBoxContainer/ename2.modulate = Color(1,1,1,0.5)
		if ene[1].mer >= 100:
			if enlf[1]:
				$fightboard/VBoxContainer/ename2.modulate = Color(1, 1, 0.0, 1.0)
				$actboard/VBoxContainer/ename2.modulate = Color(1, 1, 0.0, 1.0)
			else:
				$fightboard/VBoxContainer/ename2.modulate = Color(1,1,1,0.5)
				$actboard/VBoxContainer/ename2.modulate = Color(1,1,1,0.5)
	if len(ene) >= 3:
		if enhp[2] <= 0 and enlf[2]:
			got_exp += ene[2].exp
			got_gold += ene[2].gold
			enlf[2] = false
			ene[2].died = true
			await get_tree().create_timer(0.5).timeout
			var tween3 = get_tree().create_tween()
			tween3.tween_property(ene[2], "modulate", Color(0,0,0,0), 0.5)
			$fightboard/VBoxContainer/ename3.modulate = Color(1,1,1,0.5)
			$actboard/VBoxContainer/ename3.modulate = Color(1,1,1,0.5)
		if ene[2].mer >= 100:
			if enlf[2]:
				$fightboard/VBoxContainer/ename3.modulate = Color(1, 1, 0.0, 1.0)
				$actboard/VBoxContainer/ename3.modulate = Color(1, 1, 0.0, 1.0)
			else:
				$fightboard/VBoxContainer/ename3.modulate = Color(1,1,1,0.5)
				$actboard/VBoxContainer/ename3.modulate = Color(1,1,1,0.5)
	
func mvp():#mvp结算，你就说这函数名合理不？
	win = true
	$selections/fight/AnimatedSprite2D.play("0")
	$selections/act/AnimatedSprite2D.play("0")
	$selections/item/AnimatedSprite2D.play('0')
	$selections/mercy/AnimatedSprite2D.play("0")
	$AP.play("long_board")
	$board/msg_txt.show()
	$board/msg_txt.type("* 你胜利了[br]* 你获得了 "+str(got_exp)+" XP和 "+str(got_gold)+" 金钱。")
