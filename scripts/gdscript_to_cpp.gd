extends VBoxContainer

var filename:String
var classname:String
var class_inherits:String

var cppfilestring:String

func _on_input_pressed():
	parse_gdscript_func("res://scripts/var_type.gd")

func parse_gdscript_func(stir:String):
	OS.delay_usec(1)

func _on_output_pressed():
	pass # Replace with function body.

func big_write(data:CppFunctionTemplate):
	pass

func write_class(data:CppFunctionTemplate):
	pass

func write_variable(data:CppVarTemplate):
	pass

