extends AnimatedSprite2D

@export var move_speed: float = 25.0  # 默认移动速度，与您之前设置的一致

func _ready():
	# 确保动画自动播放
	if not is_playing():
		play("default") # 假设动画名称是 "default"

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
		print("僵尸 %s 已移出屏幕，进行销毁" % name)
		queue_free() 
