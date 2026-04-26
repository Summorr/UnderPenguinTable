extends RichTextLabel

@export var txt = "NULL"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = txt
	var tween = create_tween()
	tween.tween_property(self, "position", Vector2(position.x, position.y-15), 0.25).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", Vector2(position.x, position.y+15), 0.5).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_callback(self.queue_free)
