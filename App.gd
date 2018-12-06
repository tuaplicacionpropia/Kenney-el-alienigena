extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var wndLevels = null
var wndLevel = null
var selectedLevel = null

var levels = null
var worlds = null
var world = null

var bgMusicName = null
var bgMusicPos = 0.00

var checkpoint = null

var appData = null

const MAX_LIFES = 3
var lifes = MAX_LIFES

const SOUND_CLICK = preload("res://assets/sounds/click.ogg")
const SOUND_START = preload("res://assets/sounds/start.ogg")
const SOUND_LOSE = preload("res://assets/sounds/lose.ogg")
const SOUND_CHECKPOINT = preload("res://assets/sounds/checkpoint.ogg")
const SOUND_WIN = preload("res://assets/sounds/win.ogg")

const THEME_INTROBG = preload("res://assets/sounds/introbg.ogg")

const FILE_SAVE_GAME = "user://levels.save"

const UNLOCK_ALL_LEVELS = true



func _ready():
	var data = {}
	data.nombre = "Hola"
	data.cantidad = 4
	data[data.nombre] = "Adios"
	print(str(data))
	#self.inspectDir("res://worlds/world1")
	self.worlds = self.loadWorlds()
	self.appData = self.load_game()
	#print(str(self.appData))
	#self.loadLevels()
	self.fnShowHome(null)
	#self.fnShowLevels(null)

func inspectDir (path):
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
			if not dir.current_is_dir() and file_name.ends_with(".tscn"):
				print("WORLD file: " + file_name)
				var worldPrefix = file_name.substr(0, file_name.length() - 5)
				print("WORLD NAME: " + worldPrefix)
				var worldLabel = worldPrefix.substr(5, worldPrefix.length() - 5)
				print("WORLD IDX: " + worldLabel)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")	

func save_game():
	var save_game = File.new()
	save_game.open(FILE_SAVE_GAME, File.WRITE)
	#save_game.store_line(to_json(self.appData))
	save_game.store_var(self.appData)
	save_game.close()

func load_game():
	var result = null
	var save_game = File.new()
	if save_game.file_exists(FILE_SAVE_GAME):
		save_game.open(FILE_SAVE_GAME, File.READ)
		#result = parse_json(save_game.get_line())
		result = save_game.get_var()
	else:
		result = {}
		#result = {
		#	"maxScore" : -1
		#}

	if not result.has("levels"):
		result['levels'] = {}
	var levels = result['levels']
	var WWorldsSize = self.worlds.size()
	print("WWorldsSize = " + str(WWorldsSize))
	for i in range(0, WWorldsSize):
		var world = self.worlds[i]
		var worldPath = world.path
		if not levels.has(worldPath):
			var lockWorld = false if i == 0 else true
			levels[worldPath] = {"numStars": -1, "lock": lockWorld}
		world.data = levels[worldPath]
		if UNLOCK_ALL_LEVELS:
			world.data.lock = false
		var wLevels = world.levels
		var wLevelsSize = wLevels.size()
		print("WLevelsSize = " + str(wLevelsSize))
		for j in range(0, wLevelsSize):
			var level = wLevels[j]
			level['world'] = self.worlds[i].path
			level['previousLevel'] = null
			level['nextLevel'] = null
			level['previousWorld'] = null
			level['nextWorld'] = null
			if i > 0:
				level['previousWorld'] = self.worlds[i - 1].path
			if i < (WWorldsSize-1):
				level['nextWorld'] = self.worlds[i + 1].path
			
			if j > 0:
				level['previousLevel'] = wLevels[j - 1].path
			elif i > 0:
				var prevLevels = self.worlds[i - 1].levels
				level['previousLevel'] = prevLevels[prevLevels.size() - 1].path
				
			if j < (wLevelsSize-1):
				level['nextLevel'] = wLevels[j + 1].path
			elif i < (WWorldsSize - 1):
				var nextLevels = self.worlds[i + 1].levels
				level['nextLevel'] = nextLevels[0].path
				
			var levelPath = level.path
			if not levels.has(levelPath):
				var lockLevel = false if i == 0 and j == 0 else true
				levels[levelPath] = {"maxScore": -1, "numStars": -1, "lock": lockLevel }
			level.data = levels[levelPath]
			if UNLOCK_ALL_LEVELS:
				level.data.lock = false
			print(str(levelPath))
	
	save_game.close()
	return result


			#if not levels.has(levelPath):
			#	levels[levelPath] = {"maxScore": -1, "numStars": -1, "lock": true }

func loadWorlds ():
	var result = []
	var dir = Directory.new()
	var path = "res://worlds"
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if dir.current_is_dir():
				var worldPath = path + "/" + file_name
				if file_name != "." and file_name != "..":
					print("world path = " + worldPath)
					var world = loadWorld(worldPath)
					if world != null:
						result.append(world)
				#print("Found directory: " + file_name)
			file_name = dir.get_next()
	return result

func loadWorld (path):
	var result = {}
	result.path = path
	result.logo = path + "/" + "logo.png"
	result.lock = false
	result.numStars = -1
	result.levels = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while (file_name != ""):
			if not dir.current_is_dir() and file_name.ends_with(".tscn"):
				var level = {}
				level.path = path + "/" + file_name
				level.lock = false
				var worldLabel = file_name.substr(0, file_name.length() - 5)
				worldLabel = worldLabel.substr(5, worldLabel.length() - 5)
				level.labelName = worldLabel
				level.numStars = -1
				result.levels.append(level)
			file_name = dir.get_next()
	if result.levels.size() <= 0:
		result = null
	return result

func loadLevels ():
	var levels = []
	levels.append({"lock": false, "labelName": "1", "numStars": 2})
	levels.append({"lock": false, "labelName": "2", "numStars": 3})
	levels.append({"lock": false, "labelName": "3", "numStars": 2})
	levels.append({"lock": false, "labelName": "4", "numStars": 1})
	levels.append({"lock": false, "labelName": "5", "numStars": 0})
	levels.append({"lock": false, "labelName": "R5", "numStars": -1})
	levels.append({"lock": false, "labelName": "R6", "numStars": 2})
	levels.append({"lock": false, "labelName": "R7", "numStars": 2})
	levels.append({"lock": false, "labelName": "R8", "numStars": 2})
	levels.append({"lock": false, "labelName": "R9", "numStars": 2})
	levels.append({"lock": true, "labelName": "S1", "numStars": 2})
	levels.append({"lock": false, "labelName": "S2", "numStars": 2})
	levels.append({"lock": false, "labelName": "S3", "numStars": 2})
	levels.append({"lock": false, "labelName": "S4", "numStars": 2})
	levels.append({"lock": false, "labelName": "S5", "numStars": 2})
	levels.append({"lock": false, "labelName": "S6", "numStars": 2})
	levels.append({"lock": false, "labelName": "S7", "numStars": 2})
	levels.append({"lock": false, "labelName": "S8", "numStars": 2})
	levels.append({"lock": false, "labelName": "S9", "numStars": 2})
	levels.append({"lock": false, "labelName": "T1", "numStars": 2})
	levels.append({"lock": false, "labelName": "T2", "numStars": 2})
	levels.append({"lock": false, "labelName": "T3", "numStars": 2})
	levels.append({"lock": false, "labelName": "T4", "numStars": 2})
	levels.append({"lock": false, "labelName": "T5", "numStars": 2})
	levels.append({"lock": false, "labelName": "T6", "numStars": 2})
	levels.append({"lock": false, "labelName": "T7", "numStars": 2})
	levels.append({"lock": false, "labelName": "T8", "numStars": 2})
	levels.append({"lock": false, "labelName": "T9", "numStars": 2})
	levels.append({"lock": false, "labelName": "U1", "numStars": 2})
	levels.append({"lock": false, "labelName": "U2", "numStars": 2})
	levels.append({"lock": false, "labelName": "U3", "numStars": 2})
	
	self.levels = levels
	

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func fnMainPlay (node):
	print("CLICK PLAY MAIN")
	self.fnShowWorlds(node)
	#if numWorlds == 1:
	#self.fnShowLevels(node)
	node.get_parent().remove_child(node)
	#self.playSound("click")
	self.playSound(SOUND_CLICK)
	self.lifes = MAX_LIFES
	

func fnShowWorlds (node):
	self.fnShowWorldsIdx(node, 0)

func fnShowWorldsIdx (node, idx):
	var wnd = load("res://WndWorlds.tscn").instance()
	
	wnd.options = self.worlds
	wnd.pageIdx = idx
	
	#self.add_child(wnd)
	$center.add_child(wnd)
	
	wnd.showPage()
	
	wnd.connect("click", self, "openWorld")
	wnd.connect("home", self, "fnShowHome")



func fnShowLevels (node):
	var wndLevels = load("res://WndLevels.tscn").instance()
	
	wndLevels.options = self.levels
	wndLevels.pageIdx = 0
	
	#self.add_child(wndLevels)
	$center.add_child(wndLevels)
	
	wndLevels.connect("openLevel", self, "openLevel")
	wndLevels.connect("home", self, "fnShowHome")
	self.wndLevels = wndLevels

func fnShowHome (wnd):
	print(">>HOME<<")
	if wnd != null:
		wnd.get_parent().remove_child(wnd)
	var wndHome = load("res://WndMain.tscn").instance()
	wndHome.connect("play", self, "fnMainPlay")
	$center.add_child(wndHome)
	self.playDefaultBgSound()

func openLevel (option, ui):
	self.lifes = MAX_LIFES
	self.stopBgSound()
	self.selectedLevel = option
	print("OPENING LEVEL = " + str(option.labelName))
	#var wndLevel = load("res://World" + option.labelName + ".tscn").instance()
	var wndLevel = load(option.path).instance()
	#wndLevel.set_focus_mode(Control.FOCUS_ALL)
	self.add_child(wndLevel)
	wndLevel.set_lifes(self.lifes)
	wndLevel.connect("pause", self, "fnPauseLevel")
	wndLevel.connect("finishLevel", self, "fnFinishLevel")
	wndLevel.connect("checkpoint", self, "fnCheckpointLevel")
	wndLevel.connect("fallPlayer", self, "fnFallPlayer")
	wndLevel.connect("updateLifes", self, "fnUpdateLifes")
	if self.wndLevels != null:
		self.wndLevels.get_parent().remove_child(self.wndLevels)
		self.wndLevels = null
	#get_tree().change_scene("res://World" + option.labelName + ".tscn")
	#self.playSound("start")
	self.playSound(SOUND_START)
	if self.checkpoint != null:
		wndLevel.get_node("Player").set_position(Vector2(self.checkpoint.x, self.checkpoint.y - 100))
	self.checkpoint = null


func openWorld (world, wnd):
	self.world = world
	#print("OPENING WORLD = " + str(world.path))
	self.levels = world.levels
	self.fnShowLevels(wnd)
	self.checkpoint = null
	self.playDefaultBgSound()
	
	wnd.get_parent().remove_child(wnd)

func fnUpdateLifes (wndLevel, player):
	self.lifes = wndLevel.get_lifes()

func fnFallPlayer (player, wndLevel):
	self.lifes = MAX_LIFES	
	player.dead(self)
	self.playDefaultBgSound()
	#self.playSound("lose")
	self.playSound(SOUND_LOSE)
	
	var wndLose = load("res://WndLose.tscn").instance()
	wndLose.connect("home", self, "fnFinishHomeLose")
	wndLose.connect("reload", self, "fnReloadLevel")
	wndLose.connect("menu", self, "fnFinishMenuLose")
	$center.add_child(wndLose)
	wndLevel.get_parent().remove_child(wndLevel)
	#self.fnReloadLevel(wndLevel)
	

func playSound (name):
	$effect.set_stream(name)
	$effect.play()


func playSoundOld (name):
	var audio_file = "res://assets/sounds/" + name + ".ogg"
	if File.new().file_exists(audio_file):
		var sfx = load(audio_file)
		sfx.set_loop(false)
		$effect.set_stream(sfx)
		$effect.play()

func playDefaultBgSound ():
	#self.playBgSound("introbg")
	self.playBgSound(THEME_INTROBG)
	#self.playBgSound("theme1")

func playBgSound (name):
	if self.bgMusicName != name || not $bgMusic.is_playing():
		if self.bgMusicName != name:
			$bgMusic.set_stream(name)
			self.bgMusicName = name
		var position = 0.0 if self.bgMusicName != name else self.bgMusicPos
		$bgMusic.play(position)

func playBgSoundOld (name):
	if self.bgMusicName != name || not $bgMusic.is_playing():
		if self.bgMusicName != name:
			var audio_file = "res://assets/sounds/" + name + ".ogg"
			if File.new().file_exists(audio_file):
				var sfx = load(audio_file)
				sfx.set_loop(true)
				$bgMusic.set_stream(sfx)
				self.bgMusicName = name
		var position = 0.0 if self.bgMusicName != name else self.bgMusicPos
		$bgMusic.play(position)

func stopBgSound ():
	if $bgMusic.is_playing():
		self.bgMusicPos = $bgMusic.get_playback_position()
	else:
		self.bgMusicPos = 0.0
	$bgMusic.stop()

func fnCheckpointLevel (wnd, flag):
	self.checkpoint = flag.position
	#self.playSound("checkpoint")
	self.playSound(SOUND_CHECKPOINT)
	print("CHECKPOINT = " + str(self.selectedLevel))
	print("CHECK POSITION " + str(flag.position))

func fnFinishLevel (wnd, flag):
	self.checkpoint = null
	print("ALELUYA, se termina nivel = " + str(self.selectedLevel))
	#selectedLevel.path = res://worlds/world1/World2.tscn
	self.playDefaultBgSound()
	#self.playSound("win")
	self.playSound(SOUND_WIN)
	
	var score = wnd.get_score()
	print("APP DATA")
	var dataLevel = self.appData['levels'][self.selectedLevel.path]
	print(str(dataLevel))
	var save = false
	
	var numStars = 0
	if false:
		numStars = 1 if score >= 10 and score <= 19 else numStars
		numStars = 2 if score >= 20 and score <= 29 else numStars
		numStars = 3 if score >= 30 else numStars
	else:
		numStars = wnd.get_stars()
	
	if score > dataLevel['maxScore']:
		dataLevel['maxScore'] = score
		save = true
	
	if numStars > dataLevel['numStars']:
		dataLevel['numStars'] = numStars
		save = true
	
	if self.selectedLevel.has('nextLevel') and self.selectedLevel.nextLevel != null:
		var nextDataLevel = self.appData['levels'][self.selectedLevel.nextLevel]
		if nextDataLevel.lock:
			nextDataLevel.lock = false
			save = true
		var dataSelectedLevel = self.selectedLevel
		var nextLevel = self._getLevelFromPath(self.selectedLevel.nextLevel)
		if nextLevel.world != dataSelectedLevel.world:
			var nextDataWorld = self.appData['levels'][nextLevel.world]
			if nextDataWorld.lock:
				nextDataWorld.lock = false
				save = true
	
	if save:
		self.save_game()
	
	#self.selectedLevel = null
	var wndWin = load("res://WndWin.tscn").instance()
	wndWin.score = score
	wndWin.bestScore = dataLevel['maxScore']
	wndWin.numStars = numStars
	wndWin.connect("home", self, "fnFinishHome")
	wndWin.connect("nextLevel", self, "fnFinishNextLevel")
	wndWin.connect("menu", self, "fnFinishMenu")
	$center.add_child(wndWin)
	wnd.get_parent().remove_child(wnd)

func _getLevelFromPath (path):
	var result = null
	for world in self.worlds:
		var levels = world.levels
		for level in levels:
			if level.path == path:
				result = level
				break
	return result

func saveScore (level, score, numStars):
	pass

func loadScore (level):
	pass

func fnFinishHome (wnd):
	self.playDefaultBgSound()
	wnd.get_parent().remove_child(wnd)
	self.fnShowHome(null)
	#self.playSound("click")
	self.playSound(SOUND_CLICK)

func fnFinishHomeLose (wnd):
	self.checkpoint = null
	self.fnFinishHome(wnd)

func fnFinishNextLevel (wnd):
	wnd.get_parent().remove_child(wnd)
	var idx = self.levels.find(self.selectedLevel)
	print("IDX = " + str(idx))
	if idx < (self.levels.size() - 1):
		var nextLevel = self.levels[idx + 1]
		print("nextLevel = " + str(nextLevel))
		self.openLevel(nextLevel, null)
	else:
		var worldIdx = self._getWorldIdx(self.selectedLevel.world)
		if worldIdx < (self.worlds.size() - 1):
			self.fnShowWorldsIdx(null, worldIdx + 1)
		else:
			self.fnShowLevels(null)

func _getWorldIdx (path):
	var result = null
	var idx = -1
	for world in self.worlds:
		idx = idx + 1
		if path == world.path:
			result = idx
			break
	return result

func fnFinishMenu (wnd):
	self.playDefaultBgSound()
	wnd.get_parent().remove_child(wnd)
	self.fnShowLevels(null)
	#self.playSound("click")
	self.playSound(SOUND_CLICK)

func fnFinishMenuLose (wnd):
	self.checkpoint = null
	self.fnFinishMenu(wnd)

func fnPauseLevel (wnd):
	self.playDefaultBgSound()
	self.wndLevel = wnd
	wnd.get_tree().paused = true
	#wnd.set_focus_mode(Control.FOCUS_NONE)
	#self.remove_child(wnd)
	wnd.get_node("theme").stop()
	var wndPause = load("res://WndPause.tscn").instance()
	wndPause.set_pause_mode(Node.PAUSE_MODE_PROCESS)
	wnd.get_node("CanvasLayer/center").add_child(wndPause)
	#wndPause.set_focus_mode(Control.FOCUS_ALL)
	wndPause.connect("reload", self, "fnReloadLevel")
	wndPause.connect("play", self, "fnPlayLevel")
	wndPause.connect("menu", self, "fnMenuLevel")
	#self.playSound("click")
	self.playSound(SOUND_CLICK)

func fnReloadLevel (wnd):
	print("reload")
	wnd.get_parent().remove_child(wnd)
	if self.wndLevel != null:
		self.wndLevel.get_parent().remove_child(self.wndLevel)
	self.wndLevel = null
	self.get_tree().paused = false
	self.openLevel(self.selectedLevel, null)
	#self.playSound("click")
	self.playSound(SOUND_CLICK)


func fnPlayLevel (wnd):
	print("play")
	wnd.get_parent().remove_child(wnd)
	self.wndLevel.get_tree().paused = false
	self.wndLevel.get_node("theme").play()
	self.wndLevel = null
	self.stopBgSound()
	#self.playSound("click")
	self.playSound(SOUND_CLICK)

func fnMenuLevel (wnd):
	self.playDefaultBgSound()
	print("menu")
	wnd.get_parent().remove_child(wnd)
	self.get_tree().paused = false
	self.wndLevel.get_parent().remove_child(self.wndLevel)
	self.wndLevel = null
	self.selectedLevel = null
	self.fnShowLevels(wnd)
	#self.playSound("click")
	self.playSound(SOUND_CLICK)
