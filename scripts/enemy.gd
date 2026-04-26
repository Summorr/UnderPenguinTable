extends Control
## 角色昵称
@export var ename : String = "Godot"
## 血量
@export var hp = 20
## 血量最大值
@export var hpm = 20
## 防御减伤
@export var df = 1
## 饶恕值
@export var mer = 0
## action行动界面的选项(选项自定义请见global节点)
@export var act = [1,0,5]
## 掉落的金钱
@export var gold = 1
## 仅供查看用的攻击
@export var atk = "1"
## 查看用的防御
@export var fakedf = "1"
## 击杀掉落经验
@export var exp = 1
## 仁慈后抵消背叛杀的防御值
@export var merdf = 0
## 介绍
@export var info : String = "只是个敌人示例项目而已"
var mery = false
var died = false
## 是否支持对话
@export var cantalk :bool = true
## 敌人的对话框
@export_file_path("*tscn") var bubble = "res://scenes/dialog/dialog_1.tscn"
## 冒泡偏移
@export var bub_p :Vector2 = Vector2(50,-50)
## 敌人的随机对话
@export var randlg = [1,3]
## 敌人的语录
@export var dlg = {
	1 : "福瑞刺客🤔你不要过来😱",
	2 : "福瑞刺客🤫你不可饶恕😡",
	3 : "你不要过来😨😨😨"
}
var bub

func _process(delta: float) -> void:
	if mer >= 100:
		df = -hpm + merdf
	if modulate == Color(0,0,0,0) or modulate == Color(1.0, 1.0, 1.0, 0.25) or mery:
		cantalk = false
	if (mery or died) and bub != null:
		bub.hide()

func talk(txt):
	if not mery or not died:
		bub = load(bubble).instantiate()
		bub.position = $Sprite2D.position + bub_p
		add_child(bub)
		bub.talk(txt)
