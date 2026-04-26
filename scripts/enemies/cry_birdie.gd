extends Control

@export var ename : String = "Crird"#Cry+bird
@export var hp = 20
@export var hpm = 20
@export var df = 1
@export var mer = 0
@export var act = [1,2,3,4]
@export var gold = 1
@export var atk = "?"
@export var exp = 4
@export var merdf = 1
@export var fakedf = "?"
@export var info : String = "悲伤又欢乐的小鸟"
var mery = false
var died = false
@export var randlg = [1,3]
@export var dlg = {
	1 : "鹅鹅鹅",
	2 : "..."
}
## 是否支持对话
@export var cantalk :bool = false
var sinx = 0
var siny = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	sinx += 2 * delta
	siny += 0.5 * delta
	position.y = 50*sin(siny)-75
	position.x = 200*sin(sinx)+200
	if mer >= 100:
		$Sprite2D.texture = load("res://images/enemies/bird/happy.png")
		df = -hpm + merdf
