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

var divX = 2
var divY = 2

func destroyCoin ():
	var reg = $Sprite.get_region_rect()
	var tex = $Sprite.get_texture()
	var tamX = reg.size.x / divX
	var tamY = reg.size.y / divY
	print(reg)
	print(tex)
	for a in range(divY):
		for l in range(divX):
			var rec = Rect2(reg.position.x + (tamX * l), reg.position.y + (tamY * a), tamX, tamY)
			var spr = Sprite.new()
			spr.set_texture(tex)
			spr.set_region(true)
			spr.set_region_rect(rec)
			spr.set_centered(false)
			spr.global_position = $Sprite.global_position + Vector2((tamX * l), (tamY * a))
			var rig = RigidBody2D.new()
			rig.add_child(spr)
			rig.apply_impulse(Vector2(), Vector2(rand_range(-50,50), rand_range(-50, -100)))
			get_parent().add_child(rig)
	

func _on_Coin_body_entered(body):
	if body.get_name() == 'Player':
		body.collectCoin(self)
		#$audio.play()
		#self.destroyCoin()
		#queue_free()
