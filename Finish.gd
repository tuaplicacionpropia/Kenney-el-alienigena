extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

#signal finishLevel


func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Finish_body_entered(body):
	if body.get_name() == 'Player':
		print("FINISH")
		var node = self
		while node != null:
			if 'World' in node.name:
				break
			#print("finish = " + node.name)
			node = node.get_parent()
		if node != null:
			print("EMIT FINISH")
			node.emit_signal("finishLevel", node, self)
		#body.finishLevel(self)
