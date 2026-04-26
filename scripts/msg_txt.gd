extends RichTextLabel

## 每个字的间隔速度
@export var dt = 0.05
var ltxt = 0#111
var completed = false
var tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	type(text)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if ltxt < visible_characters and not completed:
		G.play3("res://sounds/uifont.wav")
		ltxt += 1

func comp():
	ltxt = 0
	completed = true
	if tween and tween.is_valid():
		tween.kill() # 杀死补间。
	visible_characters = len(text)
	
func type(txt):
	text = txt
	completed = false
	visible_characters = 0
	tween = create_tween()
	tween.tween_property(self, "visible_characters", len(text), dt * len(text)).set_trans(Tween.TRANS_SINE)
	tween.tween_callback(comp)
	
