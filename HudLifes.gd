tool
extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

export var amount = 3 setget set_amount, get_amount

const TEXTURE_EMPTY = preload("res://assets/hud/hudHeart_empty.png")
const TEXTURE_HALF = preload("res://assets/hud/hudHeart_half.png")
const TEXTURE_FULL = preload("res://assets/hud/hudHeart_full.png")

func set_amount(newValue):
	amount = newValue
	self.updateWidget()

func get_amount():
	return amount



func updateWidget ():
	if get_node("sprite1") != null:
		if self.amount == 0:
			$sprite1.set_texture(TEXTURE_EMPTY)
			$sprite2.set_texture(TEXTURE_EMPTY)
			$sprite3.set_texture(TEXTURE_EMPTY)
		elif self.amount == 1:
			$sprite1.set_texture(TEXTURE_FULL)
			$sprite2.set_texture(TEXTURE_EMPTY)
			$sprite3.set_texture(TEXTURE_EMPTY)
		elif self.amount == 2:
			$sprite1.set_texture(TEXTURE_FULL)
			$sprite2.set_texture(TEXTURE_FULL)
			$sprite3.set_texture(TEXTURE_EMPTY)
		elif self.amount == 3:
			$sprite1.set_texture(TEXTURE_FULL)
			$sprite2.set_texture(TEXTURE_FULL)
			$sprite3.set_texture(TEXTURE_FULL)
	pass

func _ready():
	self.updateWidget()
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
