extends MVCCommand

# override
func _on_execute(e: MVCEvent):
	# 从磁盘读取存档文件
	var save_data = JsonReader.new("user://GameData.save")
	if save_data.data() == null:
		return
	
	# 加载存档
	var gd: GameData = get_proxy("GameData")
	gd.load(save_data.data())
	
