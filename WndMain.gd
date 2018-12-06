extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

signal play

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_play_pressed():
	emit_signal("play", self)
	#get_tree().change_scene("res://World3.tscn")
