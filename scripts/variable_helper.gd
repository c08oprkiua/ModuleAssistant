extends VBoxContainer

class_name VariableGenerator
#Yeah, all the variable names get confusing. Sorry in advance.

enum FileType {
	HEADER = 1,
	CODE,
	BINDING,
	SETGET
}

class GenPreFab:
	extends Resource
	var file_type:FileType
	##The file being saved to
	var file_name:String
	##The name of the variable
	var var_name:String
	##The type of the variable, eg. "int", "Node3D", etc.
	var var_type:String
	##The templates to be formatted and written to a file
	var text_arr:PackedStringArray
	
	var valuedict: Dictionary = {
		"variable": "",
		"class": "",
		"defvar": "",
		"var_enum" : ""
	}
	var arguments:Dictionary = {
		
	}

@onready var text_box:TextEdit = $values

var root:AppRoot

var default_var:String

var variable_array:Array[GenPreFab] = []

func _ready() -> void:
	root = get_tree().current_scene

func _on_class_text_changed(new_text:String):
	root.current_class_name = new_text.validate_filename()

func _on_def_var_text_changed(new_text:String):
	default_var = new_text

func _on_visibility_changed() -> void:
	if visible:
		root.process_context = generate
	else:
		pass

func generate():
	variable_array.clear()
	if default_var.is_empty():
		default_var = "Variant"
	if root.current_class_name.is_empty():
		OS.alert("You haven't set a class for your variables!", "No class set")
		return
	parse_values()
	for fabs in variable_array:
		#Bindings
		fabs.file_type = FileType.BINDING
		fabs.text_arr.append("    ClassDB::bind_method(D_METHOD(\"get_{variable}\"), &{class}::get_{variable});\n")
		fabs.text_arr.append("    ClassDB::bind_method(D_METHOD(\"set_{variable}\", \"{variable}\"), &{class}::set_{variable});\n\n")
		fabs.text_arr.append("    ADD_PROPERTY(PropertyInfo(Variant::{var_enum}, \"{variable}\"), \"set_{variable}\", \"get_{variable}\");\n\n")
		write(fabs)
		#set_gets
		fabs.text_arr.clear()
		fabs.file_type = FileType.SETGET
		fabs.text_arr.append("{defvar} {class}::get_{variable}(){\n    return {variable};\n}\n\n")
		fabs.text_arr.append("void {class}::set_{variable}({defvar} new_{variable}){\n    {variable} = new_{variable};\n}\n\n")
		write(fabs)
		#function class definition
		fabs.text_arr.clear()
		fabs.file_type = FileType.HEADER
		fabs.text_arr.append("    {defvar} {variable};\n")
		fabs.text_arr.append("    {defvar} get_{variable}();\n")
		fabs.text_arr.append("    void set_{variable}({defvar} new_{variable}); \n\n")
		write(fabs)




func parse_values():
	var unspaced_values:String = text_box.text.replacen(" ", "")
	
	#cheap way to detect if any functions are being bound
	if unspaced_values.contains("("):
		pass
	else: #variables only, use old parser
		var var_array:PackedStringArray = unspaced_values.split(",", false)
		
		for variables:String in var_array:
			var fab:GenPreFab = GenPreFab.new()
			var fab_2:VariableInfo = VariableInfo.new()
			var split:PackedStringArray = variables.split(":", false)
			if split.size() > 1: #Variable is typed, and ":" being present was not a false positive
				fab.var_name = split[0]
				fab_2.var_name = split[0]
				fab.var_type = split[1]
				fab_2.var_type = split[1]
			else: #Variable is assumed to be untyped; use default var
				fab.var_name = variables
				fab_2.var_name = variables
				fab.var_type = default_var
				fab_2.var_type = default_var
			variable_array.append(fab)

func write(prefab:GenPreFab):
	var code_box:CodeEdit
	match prefab.file_type:
		FileType.HEADER:
			code_box = root.cpp_header
		FileType.BINDING:
			code_box = root.cpp_binding
		FileType.SETGET:
			code_box = root.cpp_setgets
		_:
			push_error("Huh.")
	
	var valuedict: Dictionary = {
		"variable": "",
		"class": root.current_class_name,
		"defvar": default_var,
		"var_enum" : root.format_variant_enum(default_var)
	}
	for entries in variable_array:
		if entries.var_type != default_var:
		#Also done, just in case, because Dictionaries are weird
			valuedict["defvar"] = entries.var_type
			valuedict["var_enum"] = root.format_variant_enum(entries.var_type)
		
		valuedict["class"] = root.current_class_name
		valuedict["variable"] = entries.var_name
		for string_templates in prefab.text_arr:
			code_box.text += string_templates.format(valuedict)
