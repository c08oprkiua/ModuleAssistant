extends Resource
class_name VarType

static var num_increment:int = 0

const var_default:String = "{var_type}_{num}"

#The variable type of a function/variable
var var_type:String
#The name of the variable
var var_name:String = var_default
#The actual data that the variable holds
var data = null
#If this variable will be public (bound to GDScript)
var is_export:bool = false
#If this variable is on_ready
var is_onready:bool = false #Does this apply to C++???

func _init(name:String = "",value:Variant = null):
	if name != "":
		var_name = name
	if value != null:
		var_type = type_string(typeof(value))
		data = value
		


func stringify_setgets(class_name_is:String):
	pass

func stringify_bindings(class_name_is:String):
	pass
