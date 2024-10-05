extends RefCounted
class_name JsonWriter

var _success: bool

func _init(data, path: String) -> void:
	var f = FileAccess.open(path, FileAccess.WRITE)
	if f:
		f.store_string( JSON.stringify(data) )
		f.flush()
		_success = true
		return
	
	_success = false
	
func successed() -> bool:
	return _success
	
