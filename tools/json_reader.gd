extends RefCounted
class_name JsonReader

var _json_data

func _init(path: String):
	_json_data = _load_json(path)
	
func data():
	return _json_data
	
func _load_json(path: String):
	var f := FileAccess.open(path, FileAccess.READ)
	if f:
		var json_text = f.get_as_text()
		return JSON.parse_string(json_text)
	return null
	
