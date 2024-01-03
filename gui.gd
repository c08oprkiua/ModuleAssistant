extends Control

var my_values:PackedStringArray #value

var classname:String
var default_var: String

class GenPreFab:
	var file_name:String
	var set_text:String
	var get_text:String

func _on_class_text_changed(new_text):
	classname = new_text

func _on_def_var_text_changed(new_text):
	default_var = new_text

func _on_generate_pressed():
	parse_values()
	var myfab:GenPreFab = GenPreFab.new()
	#Bindings
	myfab.file_name = ("{class}_bindings.cpp".format({"class": classname}))
	myfab.get_text = "    ClassDB::bind_method(D_METHOD(\"get_{variable}\"), {class}::get_{variable});\n"
	myfab.set_text = "    ClassDB::bind_method(D_METHOD(\"set_{variable}\", \"{variable}\"), {class}::set_{variable});\n"
	write(myfab)
	#set_gets
	myfab.file_name = "{class}_set_gets.cpp".format({"class": classname})
	myfab.get_text = "{defvar} {class}::get_{variable}(){\n    return {variable};\n}\n"
	myfab.set_text = "void {class}::set_{variable}({defvar} new_{variable}){\n    {variable} = new_{variable};\n}\n"
	write(myfab)
	#function class definitions
	myfab.file_name = "{class}.cpp".format({"class": classname})
	myfab.get_text = "    {defvar} get_{variable}();\n"
	myfab.set_text = "    void set_{variable}({defvar} new_{variable}); \n"
	write(myfab)

func _on_output_pressed():
	OS.shell_open(ProjectSettings.globalize_path("user://"))

func parse_values():
	var rawvalues: String = $"HBoxContainer/values".text
	my_values = rawvalues.split(",", false)

func write(prefab:GenPreFab):
	var dump_text:FileAccess = FileAccess.open("user://"+prefab.file_name, FileAccess.WRITE)
	var currentvar: String
	var valuedict: Dictionary = {
		"variable": currentvar,
		"class": classname,
		"defvar": default_var
	}
	for entries in my_values:
		currentvar = entries
		#Also done, just in case, because Dictionaries are weird
		valuedict["variable"] = entries
		valuedict["class"] = classname
		valuedict["defvar"]= default_var
		dump_text.store_string(prefab.set_text.format(valuedict))
		dump_text.store_string(prefab.get_text.format(valuedict))
