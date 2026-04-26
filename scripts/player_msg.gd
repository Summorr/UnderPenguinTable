extends Control

func _process(delta: float) -> void:
	$namenlv.text = G.Name + " LV" + str(G.LV)
	$HPBar.position.x = $namenlv.position.x + $namenlv.size.x + 50
	$HPBar.size.x = G.HP_max
	$HPBar.max_value = G.HP_max
	$HPBar.value = G.HP
	$HPBar/HPtxt.position.x = $HPBar.size.x + 15
	$HPBar/HPtxt.text = str(G.HP) + '/' + str(G.HP_max)
