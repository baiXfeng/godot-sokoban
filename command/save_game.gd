extends MVCCommand

# override
func _on_execute(e: MVCEvent):
	# 获取存档数据
	var gd: GameData = get_proxy("GameData")
	var data: Dictionary
	gd.save(data)
	
	# 数据写入磁盘
	if not JsonWriter.new(data, "user://GameData.save").successed():
		print("存档写入失败!")
	
