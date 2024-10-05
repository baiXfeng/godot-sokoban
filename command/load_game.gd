extends mvc_command

# override
func _on_execute(e: mvc_event):
	# 从磁盘读取存档文件
	var save_data = JsonReader.new("user://game_data.save")
	if save_data.data() == null:
		return
	
	# 加载存档
	var gd: game_data = app().get_proxy("game_data")
	gd.load(save_data.data())
	
