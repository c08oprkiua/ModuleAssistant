extends Control

class_name AppRoot

#literally 4 spaces
const a_tab:String = "    "

#Class things
const class_declaration:String = "class {class_name_}: public {inherits}{"
const class_var_get:String = "    {var_type} get_{var_name}();\n"
const class_var_set:String = "    void set_{var_name}({var_type} new_{var_name}); \n"

#Variable setgets
const var_setget_get:String = "{var_type} {class_name_}::get_{var_name}(){\n    return {var_name};\n}\n"
const var_setget_set:String = "void {class_name_}::set_{var_name}({var_type} new_{var_name}){\n    {var_name} = new_{var_name};\n}\n"

#Variable bindings
const var_bind_get:String = "    ClassDB::bind_method(D_METHOD(\"get_{var_name}\"), &{class_name_}::get_{var_name});\n"
const var_bind_set:String = "    ClassDB::bind_method(D_METHOD(\"set_{var_name}\", \"{var_name}\"), &{class_name_}::set_{var_name});\n"

#Functions
const func_declaration:String = "    {var_type} {func_name}({func_params});\n"
const func_param:String = "{var_type} {var_name}"
const func_bind_args:String = "    ClassDB::bind_method(D_METHOD(\"{function_name}\", \"{func_args}\"), &{class_name_}::{function_name});\n"
const func_bind_no_arg:String =  "    ClassDB::bind_method(D_METHOD(\"{function_name}\"), &{class_name_}::{function_name});\n"

const variant_enum_strings_commmon:Dictionary = {
	"bool": "BOOL",
	"int": "INT",
	"float": "REAL",
	"String": "STRING",
	"Color": "COLOR",
	"NodePath": "NODE_PATH",
	"Vector2": "VECTOR2",
	"Vector3": "VECTOR3",
}

const variant_enum_strings_4:Dictionary = {
	"StringName": "STRING_NAME",
	"Vector2i": "VECTOR2I",
	
	"PackedByteArray": "PACKED_BYTE_ARRAY",
	"PackedInt32Array": "PACKED_INT32_ARRAY",
	"PackedFloat32Array": "PACKED_FLOAT32_ARRAY",
}

const variant_enum_strings_3:Dictionary = {
	"StringName": "STRING",
	"Vector2i": "VECTOR2",
	
	"PackedByteArray": "POOL_BYTE_ARRAY",
	"PackedInt32Array": "POOL_INT_ARRAY",
	"PackedFloat32Array": "POOL_REAL_ARRAY",
	
	
}

@onready var cpp_header:CodeEdit = $"VBoxContainer/Main/C++Column/C++Tabs/Header"
@onready var cpp_code:CodeEdit = $"VBoxContainer/Main/C++Column/C++Tabs/Code"
@onready var cpp_binding:CodeEdit = $"VBoxContainer/Main/C++Column/C++Tabs/ClassDB Binding"
@onready var cpp_setgets:CodeEdit = $"VBoxContainer/Main/C++Column/C++Tabs/Set-Gets"

var settings:AppSettings = AppSettings.new()

#meta info about the currently parsed file
var current_class_name:String
var class_inherits:String

var process_context:Callable
var input_load_context:Callable

func _ready() -> void:
	pass

func _on_load_input_pressed() -> void:
	if not input_load_context.is_null():
		input_load_context.call()

func _on_save_output_pressed() -> void:
	var format_dict:Dictionary = {
		"class_name": current_class_name.to_snake_case()
	}
	
	write_to_file("{class_name}.hpp".format(format_dict), cpp_header.text)
	write_to_file("{class_name}.cpp".format(format_dict), cpp_code.text)
	write_to_file("{class_name}_set_gets.cpp".format(format_dict), cpp_setgets.text)
	write_to_file("{class_name}_bindings.cpp".format(format_dict), cpp_binding.text)


func _on_open_output_pressed() -> void:
	OS.shell_open(settings.output_directory)

func _on_process_input_pressed() -> void:
	if not process_context.is_null():
		process_context.call()

func _on_open_settings_pressed() -> void:
	pass # Replace with function body.

func clear_data() -> void:
	current_class_name = ""
	process_context = Callable()
	input_load_context = Callable()

func write_to_file(file_name:String, data:String) -> void:
	var file:FileAccess = FileAccess.open(settings.output_directory.path_join(file_name), FileAccess.WRITE)
	if FileAccess.get_open_error() == OK and not data.is_empty():
		file.store_string(data)
		file.close()

func generate_version_specific_var_enums() -> void:
	if settings.godot_3_mode:
		pass
	else:
		pass

func format_variant_enum(input:String) -> String:
	if variant_enum_strings_commmon.has(input):
		return variant_enum_strings_commmon.get(input)
	elif settings.godot_3_mode:
		return variant_enum_strings_3.get(input, "OBJECT")
	else:
		return variant_enum_strings_4.get(input, "OBJECT")
