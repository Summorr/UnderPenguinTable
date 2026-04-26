extends Node

@export var HP = 1000
@export var HP_max = 67
@export var LV = 1
@export var Name = "Summor"
@export var invincible = 0.25
@export var battle = false
@export var atk = 1000
@export var bag = [1,3,2,1,2,3,0]
@export var itemmsg = {
0:["null","*[color='ref']诡异[/color]",1,-11,"*[color='red']null[/color]"],
1:["苹果","*这是苹果[br]回复[b][color='green']1[/color]HP[/b]",1,1,"* apple,yum[br]* 你恢复了1HP"],
2:["梨子","*不如香梨[br]回复[b][color='red']不能[/color]吃[/b]",0,0,"* 不好吃"],
3:["橘子","*颜色像橙子[br]回复[b][color='green']10[/color]HP[/b]",1,10,"* 吃起来像橙子[br]* 你恢复了10HP"]}
@export var actmsg = {#["行动名",饶恕值,"对话反馈"]
0:["占位行动",1,"* [color='red']null[/color]"],
1:["查看",0,""],#特例。这个外部程序会处理的
2:["喂食梨子",50,"* 你觉得不好吃[br]* 但它觉得好吃"],
3:["感人星光",100,"* 哇塞太美丽了[br]* 它立马对你好感度升到了100！"],
4:["喂食苹果",10,"* 它不太喜欢苹果你知道吗"],
5:["攻略",100,"* 一键攻略[br]* 它立马对你好感度升到了100！"],
}

func play(path):
	$ASP.stream = load(path)
	$ASP.play()

func play2(path):
	$ASP2.stream = load(path)
	$ASP2.play()

func play3(path):#打字专用通道
	$ASP3.stream = load(path)
	$ASP3.play()
