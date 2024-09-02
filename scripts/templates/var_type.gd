extends Resource
class_name VariableInfo

static var num_increment:int = 0

const var_default:String = "{var_type}_{num}"

#The numeric Variant.Type enum value
var var_type:String
##The name of the variable
var var_name:String = var_default
##The data the variable is assigned at initialization, if any
var init_value:String
##If this variable will be public (bound to GDScript)
var is_export:bool = false
##If this variable is on_ready
var is_onready:bool = false #Does this apply to C++???
##The type of the variable, eg. "int", "Node3D", etc.
var type_string:String

var type_enum_string:String

var hint_type:int

var hint_string:String

var usage_bitfield:int

func _init(info:Dictionary = {}) -> void:
	num_increment += 1
	var_type = type_string(info.get("type", 0))
