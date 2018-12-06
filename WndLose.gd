extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

signal home
signal reload
signal menu

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_btnHome_pressed():
	print("home")
	emit_signal("home", self)


func _on_btnReload_pressed():
	print("reload")
	emit_signal("reload", self)


func _on_btnMenu_pressed():
	print("menu")
	emit_signal("menu", self)
