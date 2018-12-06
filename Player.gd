extends KinematicBody2D

const UP = Vector2(0, -1)
var motion = Vector2()
#var jumping = false

const GRAVITY = 30
const ACCELERATION = 5
const MAX_SPEED = 600
const JUMP_HEIGHT = -900
const FRICTION_FLOOR = 0.1
const FRICTION_JUMP = 0.01

const SOUND_BELL = preload("res://assets/sounds/bell.ogg")
const SOUND_HURT = preload("res://assets/sounds/hurt.ogg")
const SOUND_HIT = preload("res://assets/sounds/hit2.ogg")
const SOUND_DEADPLAYER = preload("res://assets/sounds/deadPlayer.ogg")
const SOUND_COLLECT_COIN = preload("res://assets/sounds/collectCoin.ogg")
const SOUND_COLLECT_STAR = preload("res://assets/sounds/collectStar.ogg")


var previousParent = null

export var lifes = 3 setget set_lifes, get_lifes

var dead = false

signal hurt

func set_lifes(newValue):
	lifes = newValue

func get_lifes():
	return lifes


#signal move

func _ready ():
	self.dead = false

func _physics_process(delta):
	motion.y += GRAVITY
	#print(motion)
	#if not self.jumping: 
	#	motion.y += 10*GRAVITY
	
	#if Input.is_action_just_pressed("ui_page_up"):
	#	get_tree().reload_current_scene()
	
	if not self.dead:
		var friction = false
	
		if Input.is_action_pressed("ui_right"):
			motion.x = lerp(motion.x, 0, FRICTION_FLOOR) if motion.x < 0 else motion.x
			motion.x = min(motion.x+ACCELERATION, MAX_SPEED)
			$Sprite.flip_h = false
			$feet.set_scale(Vector2(1, 1))
			$damage.set_scale(Vector2(1, 1))
			$Sprite.play("Walk")
		elif Input.is_action_pressed("ui_left"):
			motion.x = lerp(motion.x, 0, FRICTION_FLOOR) if motion.x > 0 else motion.x
			motion.x = max(motion.x-ACCELERATION, -MAX_SPEED)
			$Sprite.flip_h = true
			$feet.set_scale(Vector2(-1, 1))
			$damage.set_scale(Vector2(-1, 1))
			$Sprite.play("Walk")
		else:
			$Sprite.play("Idle")
			friction = true
		
		if is_on_floor():
			if Input.is_action_just_pressed("ui_up"):
				motion.y = JUMP_HEIGHT
				#self.jumping = true
			if friction:
				motion.x = lerp(motion.x, 0, FRICTION_FLOOR)
	
			if self.previousParent == null:
				var collidersCount = self.get_slide_count()
				for idx in range(collidersCount):
					var collision = self.get_slide_collision(idx)
					if collision != null:
						#print("collision = " + str(collision.collider.get_name()))
						#print("normal = " + str(collision.normal))
						#print("groups = " + str(collision.collider.get_groups()))
						if collision.collider.is_in_group("plataforma") and collision.normal.y < 0:
							print("reparenting")
							self.previousParent = self.get_parent()
							print("new parent = " + collision.collider.get_parent().get_name())
							#self.get_parent().remove_child(self)
							
							self.change_parent(self, collision.collider.get_parent())
							#var tmp = get_global_transform().xform(self.position)
							#self.get_parent().remove_child( self )
							#collision.collider.get_parent().add_child(self)
							#self.position = get_global_transform().xform_inv(tmp)
							
							#print("collision = " + str(collision.collider.get_name()))
							#print("normal = " + str(collision.normal))
							#print("collider_velocity = " + str(collision.collider_velocity))
							#motion.x += collision.remainder.x
							#motion.y += collision.remainder.y
		else:
			if self.previousParent != null:
				print("reset parent")
				self.change_parent(self, self.previousParent)
				#var tmp = get_global_transform().xform(self.position)
				#self.get_parent().remove_child(self)
				#self.previousParent.add_child(self)
				#self.position = get_global_transform().xform_inv(tmp)
				self.previousParent = null
			#print("pre move = " + str(motion))
			#self.jumping = false
			if motion.y < 0:
				$Sprite.play("Jump")
			elif motion.y > (4*GRAVITY):
				$Sprite.play("Fall")
			if friction:
				motion.x = lerp(motion.x, 0, FRICTION_JUMP)
	else:
		$Sprite.play("Idle")

	motion = move_and_slide(motion, UP)
#	if motion.x != 0 and motion.y != 0:
#		emit_signal("move", self)

func above_platform (target):
	self.change_parent(self, target)
	self.change_parent(self.get_node("camera"), target)

func change_parent (node, target):
	var tmp = get_global_transform().xform(node.position)
	node.get_parent().remove_child(node)
	target.add_child(node)
	node.position = get_global_transform().xform_inv(tmp)

func change_parent2 (target):
	call_deferred("reparent", target)

func reparent(target):
	self.get_parent().remove_child(self)
	target.add_child(self)

func playSound (name):
	$audio.set_stream(name)
	$audio.play()

func playSoundOld (name):
	#var speech_player = AudioStreamPlayer.new()
	var audioIdx = randi() % 2
	var audio_file = "res://assets/sounds/bell.ogg" if audioIdx == 0 else "res://assets/sounds/collect.ogg"
	audio_file = "res://assets/sounds/bell.ogg"
	if File.new().file_exists(audio_file):
		var sfx = load(audio_file)
		sfx.set_loop(false)
		$audio.stream = sfx
	$audio.play()

func updateScore (incScore):
	var node = self
	while not ('World' in node.get_name()):
		node = node.get_parent()
	var score = node.get_score()
	score += incScore
	node.set_score(score)
	
func updateStars (incStars):
	var node = self
	while not ('World' in node.get_name()):
		node = node.get_parent()
	var stars = node.get_stars()
	stars += incStars
	node.set_stars(stars)
	
func collectCoin (coin):
	#var speech_player = AudioStreamPlayer.new()
	self.playSound(SOUND_COLLECT_COIN)
	
	self.updateScore(2)
	
	coin.queue_free()

func collectStar (star):
	#var speech_player = AudioStreamPlayer.new()
	self.playSound(SOUND_COLLECT_STAR)
	
	self.updateScore(25)
	self.updateStars(1)
	
	star.queue_free()

#func finishLevel (finish):
#	print("FIN DEL NIVEL " + str(get_tree().get_current_scene()))
#	get_tree().change_scene("res://World3.tscn")


func hitEnemy (enemy):
	enemy.queue_free()
	#Tween para movimiento suave
	#self.get_parent().get_node("Walls/Wall66").translate(Vector2(0, -464))
	#self.get_parent().get_node("Walls/Wall67").translate(Vector2(0, -464))


func _on_feet_body_entered(body):
	if motion.y >= 0:
		var hit = body.hit()
		if hit:
			motion.y = JUMP_HEIGHT
			self.hitSound()
			self.updateScore(10)
		
		#body.queue_free()
	pass # replace with function body


func _on_damage_body_entered(body):
	if not body.dead:
		print("DAMAGE")
		self.lifes -= 1
		self.hitPlayer()

func hitPlayer ():
	emit_signal("hurt", self)
	if self.lifes <= 0:
		self.dead = true
		self.dead(null)
		self.motion = Vector2(0, 0)
		$anim.play("dead")
	else:
		self.dead = false
		self.motion = Vector2(-1*motion.x, -1*motion.y)
		$anim.play("hit")
		self.hurtSound()
	$damage/shape.set_disabled(true)
	

func endHitPlayer ():
	if self.lifes <= 0:
		$damage/shape.set_disabled(true)
		self.deadPlayer()
	else:
		$damage/shape.set_disabled(false)

func deadPlayer ():
	var node = self
	while node != null:
		if 'World' in node.name:
			break
		node = node.get_parent()
	if node != null:
		node.emit_signal("fallPlayer", self, node)

func hurtSound ():
	self.playSound(SOUND_HURT)

func hurtSoundOld ():
	var audio_file = "res://assets/sounds/hurt.ogg"
	if File.new().file_exists(audio_file):
		var sfx = load(audio_file)
		sfx.set_loop(false)
		$audio.stream = sfx
		$audio.play()


func hitSound ():
	self.playSound(SOUND_HIT)


func hitSoundOld ():
	var audio_file = "res://assets/sounds/hit2.ogg"
	if File.new().file_exists(audio_file):
		var sfx = load(audio_file)
		sfx.set_loop(false)
		$audio.stream = sfx
		$audio.play()

func dead (killer):
	self.playSound(SOUND_DEADPLAYER)

func deadOld (killer):
	var audio_file = "res://assets/sounds/deadPlayer.ogg"
	if File.new().file_exists(audio_file):
		var sfx = load(audio_file)
		sfx.set_loop(false)
		$audio.stream = sfx
		$audio.play()
	#get_tree().reload_current_scene()
