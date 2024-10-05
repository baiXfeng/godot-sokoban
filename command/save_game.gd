extends mvc_command

# override
func _on_execute(e: mvc_event):
	# 获取存档数据
	var gd: game_data = app().get_proxy("game_data")
	var data: Dictionary
	gd.load(data)
	
	# 数据写入磁盘
	if not JsonWriter.new(data, "user://game_data.save").successed():
		print("存档写入失败!")
	
