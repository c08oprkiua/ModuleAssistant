extends VBoxContainer

var filename:String
var classname:String
var class_inherits:String

var cppfilestring:String

const class_template:String = "class {class}: public {inherits}{"

class var_type: 
	extends Resource
	var type
	var name:String = ""
	var data = null
	
	func _init(value:Variant = null):
		if value == null:
			return
		else:
			type = type_string(typeof(value))
			data = value

func _on_input_pressed():
	var filein:FileDialog = FileDialog.new()
	filein.access = FileDialog.ACCESS_FILESYSTEM
	filein.add_filter("*.gd", "GDScript files")
	filein.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	filein.use_native_dialog = true
	add_child(filein)

func handle_variable():
	var thevar:var_type

func parse_gdscript_func():
	pass

func _on_output_pressed():
	pass # Replace with function body.
