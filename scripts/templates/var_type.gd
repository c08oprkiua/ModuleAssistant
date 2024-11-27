extends Resource
class_name VariableInfo

static var num_increment:int = 0

##The type of the variable, eg. "int", "Node3D", etc.
var var_type:String = "void"
##The name of the variable
var var_name:String
##The data the variable is assigned at initialization, if any
var init_value:String
##If this variable will be public (bound to GDScript)
var is_export:bool = false
##If this variable is on_ready
var is_onready:bool = false #Does this apply to C++???
##If this variable extends Reference/RefCounted
var ref_counted:bool = false
##The numeric Variant.Type enum value
var type_index_val:int

var hint_bitfield:int

var hint_string:String
##The [PropertyUsageFlags]s for this var
var usage_bitfield:int

func from_var(the_var) -> void:
	type_index_val = typeof(the_var)
	var_type = type_string(type_index_val)

func _init(info:Dictionary = {}) -> void:
	from_dictionary(info)

func from_dictionary(info:Dictionary) -> void:
	var_name = info.get("name", "")
	type_index_val = info.get("type", 0)
	
	usage_bitfield = info.get("usage", 0)
	
	if info.get("class_name"):
		var_type = info.get("class_name", "")
		#TODO: Test for inheritance of RefCounted
	elif type_index_val:
		var_type = type_string(type_index_val)
	
	if info.get("hint"):
		printt("Hint:", info.get("hint"))
	if info.get("hint_string"):
		hint_string = info.get("hint_string", "")
	
	print_info()

func print_info() -> void:
	printt("C++ declaration:", get_cpp_declaration())
	
	printt("Hint string:", hint_string)
	printt("Usage flags:", String.num_uint64(usage_bitfield, 2))


func get_cpp_declaration() -> String:
	if type_index_val != 0 and not var_name.is_empty():
		##TODO: Format as Ref<{0}> if RefCounted inheriting
		return "{0} {1}".format([var_type, var_name])
	else:
		return ""
