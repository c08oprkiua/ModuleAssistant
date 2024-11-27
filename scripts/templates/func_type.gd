extends Resource
class_name CppFunctionTemplate

##The name of the function
var func_name:String
##The parameters for a function
var func_params:Array[VariableInfo]
##The function's return variable
var return_type:VariableInfo
##The [MethodFlags] for the function
var usage_flags:int

func _init(function:Dictionary = {}) -> void:
	from_dictionary(function)

func from_dictionary(function:Dictionary) -> void:
	func_name = function.get("name", "")
	var args:Array = function.get("args", [])
	if args:
		func_params.resize(args.size())
		for arg:Dictionary in args:
			func_params.append(VariableInfo.new(arg))
	
	args = function.get("default_args", [])
	if args.size() >= 1:
		printt("Default arguments:")
		for arg in args:
			if type_string(typeof(arg)) == "Dictionary":
				VariableInfo.new(arg)
	
	usage_flags = function.get("flags", 0)
	return_type = VariableInfo.new(function.get("return", {}))
	
	print_info()

func from_callable(function:Callable) -> void:
	func_params.resize(function.get_argument_count())
	
	pass

func print_info() -> void:
	printt("Function name:", func_name)
	if not func_params.is_empty():
		printt("Arguments:")
		for args:VariableInfo in func_params:
			pass
	
	printt("Flags:", String.num_uint64(usage_flags, 2))
	printt("Return value: ", return_type.var_type)

func get_cpp_declaration() -> String:
	var dec_parts:PackedStringArray
	dec_parts.resize(2 + func_params.size())
	var dec_string:String = ""
	if return_type.type_index_val == 0:
		dec_string[0] = "void"
	else:
		dec_string[0] = return_type.var_type
	dec_string[1] = func_name + "("
	if not func_params.is_empty():
		for params:int in func_params.size():
			dec_string[2 + params] = func_params[params].get_cpp_declaration()
	
	return " ".join(dec_parts) + ")"

func get_cpp_definition() -> String:
	return get_cpp_declaration() + "{\n}\n"
