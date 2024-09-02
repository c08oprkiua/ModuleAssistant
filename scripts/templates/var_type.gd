extends Resource
class_name VariableInfo

static var num_increment:int = 0

const var_default:String = "{var_type}_{num}"

##The variable type of a function/variable
var var_type:String
##The name of the variable
var var_name:String = var_default
##The data the variable is assigned at initialization, if any
var init_value:String
##If this variable will be public (bound to GDScript)
var is_export:bool = false
#If this variable is on_ready
var is_onready:bool = false #Does this apply to C++???

func _init(name:String = "", value:String = ""):
	if not name.is_empty():
		var_name = name
	if not value.is_empty():
		init_value = value
