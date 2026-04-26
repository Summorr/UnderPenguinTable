extends Node2D
@export var speed : float = 1
@export var dt = 0.1
@export var sscale = Vector2(0.1,0.1)
@export var ro = PI/16
@export_file_path("*tscn") var bullet_path = "res://scenes/danmu/evil_gd.tscn"
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	$Timer.wait_time = dt
func _process(delta: float) -> void:
	if $EvilGD == null:
		queue_free()
	else:
		$EvilGD.scale = Vector2(0.25,0.25)

func _on_timer_timeout() -> void:
	if $EvilGD == null:
		queue_free()
	$EvilGD.rotate(ro)
	await get_tree().create_timer(0.1).timeout
	var a = load(bullet_path).instantiate()
	a.rotation = $EvilGD.rotation
	a.dir = Vector2.from_angle($EvilGD.rotation)
	a.speed =  speed
	a.position = $EvilGD.position
	a.scale = sscale
	var b = load(bullet_path).instantiate()
	b.rotation = $EvilGD.rotation
	b.dir = -Vector2.from_angle($EvilGD.rotation)
	b.speed = speed
	b.position = $EvilGD.position
	b.scale = sscale
	var c = load(bullet_path).instantiate()
	c.rotation = $EvilGD.rotation
	c.dir = Vector2.from_angle($EvilGD.rotation)+Vector2.from_angle(PI/4)
	c.speed = speed
	c.position = $EvilGD.position
	c.scale = sscale
	var d = load(bullet_path).instantiate()
	d.rotation = $EvilGD.rotation
	d.dir = -Vector2.from_angle($EvilGD.rotation)-Vector2.from_angle(PI/4)
	d.speed = speed
	d.position = $EvilGD.position
	d.scale = sscale
	add_child(a)
	add_child(b)
	add_child(c)
	add_child(d)
