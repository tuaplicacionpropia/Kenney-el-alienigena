extends Area2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	var timer = Timer.new()
	timer.connect("timeout", self, "startSpin", [timer])
	timer.set_wait_time(randf())
	timer.start()
	self.add_child(timer)
	#startSpin()
	pass

func startSpin (timer):
	$anim.play("spin")
	self.remove_child(timer)
	#autoplay = "spin"
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
	

func _on_Star_body_entered(body):
	if body.get_name() == 'Player':
		body.collectStar(self)
		#$audio.play()
		#self.destroyCoin()
		#queue_free()
