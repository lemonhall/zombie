extends Node2D

# 预加载僵尸场景
@export var zombie_scene: PackedScene = preload("res://zombie_character.tscn") # 确保路径正确

@export var spawn_interval: float = 2.0  # 每隔多少秒生成一个僵尸
@export var spawn_area_width: float = 800.0 # 僵尸生成的水平范围

# 预加载背景音乐
@export var bgm_stream: AudioStream = preload("res://music/zombie.mp3")

var time_since_last_spawn: float = 0.0

@onready var zombie_container: Node2D = $ZombieContainer # 获取 ZombieContainer 节点
@onready var bgm_player: AudioStreamPlayer = $BGMPlayer # 获取 BGMPlayer 节点

func _ready():
	# 初始化随机数生成器
	randomize()
	if zombie_container == null:
		printerr("Node2D 节点 'ZombieContainer' 未找到！请在场景编辑器中添加它作为当前节点的子节点，并确保命名正确。")

	# 配置并播放背景音乐
	if bgm_player and bgm_stream:
		bgm_player.stream = bgm_stream
		# 确保音乐循环播放 (除了在导入设置中勾选 Loop，也可以在代码中强制)
		# 对于 AudioStreamMP3，导入设置中的 Loop 是关键。
		# bgm_player.stream.loop_mode = AudioStreamMP3.LOOP_MODE_FORWARD # Godot 4.x specific for some stream types if needed, but import setting is primary for MP3
		bgm_player.play()
	elif not bgm_player:
		printerr("AudioStreamPlayer 节点 'BGMPlayer' 未在 node_2d.tscn 中找到或正确命名！")

func _process(delta: float):
	time_since_last_spawn += delta

	if time_since_last_spawn >= spawn_interval:
		time_since_last_spawn = 0.0
		spawn_zombie()

func spawn_zombie():
	if zombie_scene == null:
		printerr("僵尸场景未设置!")
		return
	
	if zombie_container == null: # 再次检查
		printerr("无法生成僵尸：Node2D 节点 'ZombieContainer' 未找到!")
		return

	var new_zombie = zombie_scene.instantiate()
	
	# 设置僵尸的初始位置
	# X 轴位置在 spawn_area_width 内随机，Y 轴在屏幕顶端稍上方
	var spawn_x = randf_range(0, spawn_area_width) 
	# 可以根据需要调整初始Y坐标，例如 -50 确保僵尸从屏幕外开始
	var spawn_y = -50 
	
	new_zombie.global_position = Vector2(spawn_x, spawn_y)
	
	# 可以给新生成的僵尸一个唯一的名字，方便调试
	new_zombie.name = "Zombie_" + str(Time.get_ticks_msec())

	# 将新僵尸添加到 ZombieContainer 节点中
	zombie_container.add_child(new_zombie)
	print("生成新僵尸: %s at %s and added to ZombieContainer" % [new_zombie.name, new_zombie.global_position])
