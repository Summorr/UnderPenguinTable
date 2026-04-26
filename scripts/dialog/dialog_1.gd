extends Control

@onready var t: RichTextLabel = $msg_txt

func talk(txt):
	$msg_txt.type(txt)
