extends AnimatedSprite2D

@export var move_speed: float = 25.0  # 默认移动速度，与您之前设置的一致

# 预加载嘶吼音效资源数组
@export var groan_sounds: Array[AudioStream] = [
	preload("res://sound/454830__misterkidx__zombie_die_1.wav"),
	preload("res://sound/316233__littlerobotsoundfactory__zombie_49.wav")
]

# 获取音效播放器节点
@onready var sound_player: AudioStreamPlayer2D = $GroanPlayer # 修改这里以匹配您场景中的节点名

func _ready():
	# 确保动画自动播放
	if not is_playing():
		play("default") # 假设动画名称是 "default"

	# 播放随机嘶吼音效
	if sound_player and not groan_sounds.is_empty():
		# 从数组中随机选择一个音效
		var random_groan_sound = groan_sounds.pick_random()
		if random_groan_sound:
			sound_player.stream = random_groan_sound
			sound_player.play()
	elif not sound_player:
		printerr("AudioStreamPlayer2D 节点 'GroanPlayer' 未在 zombie_character.tscn 中找到！") # 更新错误信息中的节点名

func _process(delta: float):
	# 向下移动
	position.y += move_speed * delta
	
	# 检查是否移出屏幕底部
	var screen_height = get_viewport_rect().size.y
	
	# 获取当前帧的纹理
	var current_frame_texture = sprite_frames.get_frame_texture(animation, frame)
	var zombie_height = 0.0
	if current_frame_texture:
		zombie_height = current_frame_texture.get_height() * scale.y
	
	# 如果僵尸的上边缘超出了屏幕底部加上自身高度的一个小缓冲，则销毁它
	if global_position.y - zombie_height / 2 > screen_height:
		# print("僵尸 %s 已移出屏幕，进行销毁" % name) # 可以取消注释这行来调试
		queue_free() # 直接销毁，不再播放特定死亡音效
