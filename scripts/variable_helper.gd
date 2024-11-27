extends VBoxContainer

class_name VariableGenerator
#Yeah, all the variable names get confusing. Sorry in advance.

enum FileType {
	HEADER = 1,
	CODE,
	BINDING,
	SETGET
}

@onready var text_box:TextEdit = $values

var root:AppRoot

var default_var:String

var variable_array:Array[VariableInfo] = []

func _ready() -> void:
	root = get_tree().current_scene
	print("dfjkshksf")

func _on_class_text_changed(new_text:String):
	root.current_class_name = new_text.validate_filename()

func _on_def_var_text_changed(new_text:String):
	default_var = new_text

func _on_visibility_changed() -> void:
	#if visible:
		#root.process_context = generate
	#else:
		#pass
	pass

func generate():
	parse_values()
	
	root.cpp_header.text += root.class_declaration.format({"class_name": root.current_class_name, "inherits": root.class_inherits})
	for fabs:VariableInfo in variable_array:
		var value_dict: Dictionary = {
			"variable": fabs.var_name,
			"class": root.current_class_name,
			"inherits": root.class_inherits,
			"defvar": fabs.var_type,
			"var_enum" : fabs.type_enum_string,
			"init_value": fabs.init_value
		}
		
		var templates:PackedStringArray
		
		#Bindings
		templates.append("    ClassDB::bind_method(D_METHOD(\"get_{variable}\"), &{class}::get_{variable});\n")
		templates.append("    ClassDB::bind_method(D_METHOD(\"set_{variable}\", \"{variable}\"), &{class}::set_{variable});\n\n")
		templates.append("    ADD_PROPERTY(PropertyInfo(Variant::{var_enum}, \"{variable}\"), \"set_{variable}\", \"get_{variable}\");\n\n")
		for each_template:String in templates:
			root.cpp_binding.text += each_template.format(value_dict)
		templates.clear()
		
		#set_gets
		templates.append("{defvar} {class}::get_{variable}(){\n    return {variable};\n}\n\n")
		templates.append("void {class}::set_{variable}({defvar} new_{variable}){\n    {variable} = new_{variable};\n}\n\n")
		for each_template:String in templates:
			root.cpp_setgets.text += each_template.format(value_dict)
		templates.clear()
		
		#function class definition
		if fabs.init_value:
			templates.append("    {defvar} {variable} = {init_value};\n")
		else:
			templates.append("    {defvar} {variable};\n")
		templates.append("    {defvar} get_{variable}();\n")
		templates.append("    void set_{variable}({defvar} new_{variable}); \n\n")
		
		for each_template:String in templates:
			root.cpp_header.text += each_template.format(value_dict)
		templates.clear()
	root.cpp_header.text += "}\n\n"

func parse_values():
	variable_array.clear()
	
	var unspaced_values:String = text_box.text.replacen(" ", "")
	
	if default_var.is_empty():
		default_var = "Variant"
	if root.current_class_name.is_empty():
		OS.alert("You haven't set a class for your variables!", "No class set")
		return
	
	var var_array:PackedStringArray = unspaced_values.split(",", false)
	
	for variables:String in var_array:
		var var_info:VariableInfo = VariableInfo.new()
		
		#static type detection
		var split:PackedStringArray = variables.split(":", false)
		if split.size() > 1: #Variable is typed
			var_info.var_name = split[0]
			
			if split[1].contains("="): #init value detected
				var subsplit:PackedStringArray = split[1].split("=")
				var_info.var_type = subsplit[0]
				var_info.init_value = subsplit[1]
			else:
				var_info.var_type = split[1]
		else: #Variable is assumed to be untyped; use default var
			var_info.var_name = variables
			var_info.var_type = default_var
		
		var_info.type_enum_string = root.format_variant_enum(var_info.var_type)
		
		variable_array.append(var_info)
