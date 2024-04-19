extends HBoxContainer

#Yeah, all the variable names get confusing. Sorry in advance.

#var base_directory:String = OS.get_executable_path().get_base_dir() + "/"
var base_directory:String = OS.get_user_data_dir()

var className:String
var default_var:String

class GenPreFab:
	extends Resource
	##The file being saved to
	var file_name:String
	##The name of the varaible
	var var_name:String
	##The type of the variable, eg. "int", "Node3D", etc.
	var var_type:String
	##The templates to be formatted and written to a file
	var text_arr:PackedStringArray

var variable_array:Array[GenPreFab] = []

func _on_class_text_changed(new_text:String):
	className = new_text.validate_filename()

func _on_def_var_text_changed(new_text:String):
	default_var = new_text

func _on_generate_pressed():
	variable_array.clear()
	if default_var == "":
		default_var = "Variant"
	if className == "":
		OS.alert("You haven't set a class for your variables!", "No class set")
		return
	parse_values()
	for fabs in variable_array:
		#Bindings
		fabs.file_name = "{class}_bindings.cpp".format({"class": className})
		fabs.text_arr.append("    ClassDB::bind_method(D_METHOD(\"get_{variable}\"), {class}::get_{variable});\n")
		fabs.text_arr.append("    ClassDB::bind_method(D_METHOD(\"set_{variable}\", \"{variable}\"), {class}::set_{variable});\n\n")
		fabs.text_arr.append("    ADD_PROPERTY(PropertyInfo(Variant::{defvar}, \"{variable}\"), \"set_{variable}\", \"get_{variable}\");\n\n")
		write(fabs)
		#set_gets
		fabs.text_arr.clear()
		fabs.file_name = "{class}_set_gets.cpp".format({"class": className})
		fabs.text_arr.append("{defvar} {class}::get_{variable}(){\n    return {variable};\n}\n\n")
		fabs.text_arr.append("void {class}::set_{variable}({defvar} new_{variable}){\n    {variable} = new_{variable};\n}\n\n")
		write(fabs)
		#function class definition
		fabs.text_arr.clear()
		fabs.file_name = "{class}.h".format({"class": className})
		fabs.text_arr.append("    {defvar} {variable};\n")
		fabs.text_arr.append("    {defvar} get_{variable}();\n")
		fabs.text_arr.append("    void set_{variable}({defvar} new_{variable}); \n\n")
		write(fabs)

func _on_output_pressed():
	OS.shell_open(base_directory)

func parse_values():
	var unspaced_values:String = $"values".text.replacen(" ", "")
	var var_array:PackedStringArray = unspaced_values.split(",", false)
	
	for variables in var_array:
		var fab:GenPreFab = GenPreFab.new()
		var split:PackedStringArray = variables.split(":", false)
		if split.size() > 1: #Variable is typed, and ":" being present was not a false positive
			fab.var_name = split[0]
			fab.var_type = split[1]
		else: #Variable is assumed to be untyped; use default var
			fab.var_name = variables
			fab.var_type = default_var
		variable_array.append(fab)

func write(prefab:GenPreFab):
	var dump_text:FileAccess = FileAccess.open(base_directory + "/" + prefab.file_name, FileAccess.WRITE)
	var valuedict: Dictionary = {
		"variable": "",
		"class": className,
		"defvar": default_var
	}
	for entries in variable_array:
		if entries.var_type != default_var:
		#Also done, just in case, because Dictionaries are weird
			valuedict["defvar"] = entries.var_type
		else:
			valuedict["defvar"] = default_var
		valuedict["class"] = className
		valuedict["variable"] = entries.var_name
		for string_templates in prefab.text_arr:
			dump_text.store_string(string_templates.format(valuedict))
