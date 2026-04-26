extends Control
var bag = [1,3,2,3]
var itemstring = {0:"*[color='red']null[/color]",1:"*apple,yum",2:"*不好吃",3:"*吃起来像橙子"}
@export var itemmsg = {
0:["null","*[color='ref']诡异[/color]",1,-11,"*[color='red']null[/color]"],
1:["苹果","*这是苹果[br]回复[b][color='green']1[/color]HP[/b]",1,1,"*apple,yum"],
2:["梨子","*不如香梨[br]回复[b][color='red']不能[/color]吃[/b]",0,0,"*不好吃"],
3:["橘子","*颜色像橙子[br]回复[b][color='green']10[/color]HP[/b]",1,10,"*吃起来像橙子"]}
#id:[0name,1info,2group,3value,4string]
var select = 0
@onready var hp_txt: Label = $ProgressBar/HPtxt
var HP = 20
@onready var iinput: RichTextLabel = $input
@onready var sl: ColorRect = $ColorRect
@onready var sls = [
	$VBoxContainer/Label1,
	$VBoxContainer/Label2,
	$VBoxContainer/Label3,
	$VBoxContainer/Label4,
	$VBoxContainer/Label5,
	$VBoxContainer/Label6,
	$VBoxContainer/Label7
]
func _process(delta: float) -> void:
	hp_txt.text = str(HP)+"/20"
	if Input.is_action_just_pressed("ui_up") and select > 0:
		select -= 1
	if Input.is_action_just_pressed("ui_down") and select < len(bag)-1:
		select += 1
	sl.position.y = sls[select].position.y
	for i in range(7):
		sls[i].text = "物品"
	for i in range(len(bag)):
		sls[i].text = itemmsg[bag[i]][0]

func putput(a):#模拟游戏中的信息输出
	iinput.text = a


func _on_add_pressed() -> void:
	if len(bag) < 7:
		bag.append(randi_range(0,3))

func _on_drop_pressed() -> void:
	bag.remove_at(select)
	select = 0

func _on_info_pressed() -> void:
	if select <= len(bag)-1:
		putput(itemmsg[bag[select]][1])

func _on_use_pressed() -> void:
	if select <= len(bag)-1:
		if itemmsg[bag[select]][2] == 0:#摆设输出文本
			putput(itemmsg[bag[select]][4])
		if itemmsg[bag[select]][2] == 1:#吃食	
			if HP + itemmsg[bag[select]][3] >= 20:
				HP = 20
			else:
				HP += itemmsg[bag[select]][3]
			putput(itemmsg[bag[select]][4])
			bag.remove_at(select)
		select = 0
