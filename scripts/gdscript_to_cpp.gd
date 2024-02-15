extends VBoxContainer

var filename:String
var classname:String
var class_inherits:String

var cppfilestring:String

class var_type: 
	extends Resource
	var type
	var name:String = ""
	var data = null
	
	func _init(value:Variant):
		type = type_string(typeof(value))
		data = value

func _on_input_pressed():
	pass # Replace with function body.

func handle_variable():
	var thevar:var_type

func parse_gdscript_func():
	pass

func _on_output_pressed():
	pass # Replace with function body.
