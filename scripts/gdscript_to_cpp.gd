extends VBoxContainer

class_name GDScriptToCPP

var filename:String

var cppfilestring:String

var script_select:FileDialog = FileDialog.new()

var root:AppRoot

var number:int = 4

func _on_input_pressed():
	parse_gdscript_func(ProjectSettings.globalize_path("res://scripts/var_type.gd"))

func parse_gdscript_func(stir:String):
	if FileAccess.file_exists(stir):
		var the_script:Script = load(stir)
		root.current_class_name = the_script.get_global_name()
		if root.current_class_name.is_empty():
			root.current_class_name = the_script.get_instance_base_type() + "AnonymousSub"
		root.class_inherits = the_script.get_instance_base_type()
		
		print("Properties \n")
		for values:Dictionary in the_script.get_script_property_list():
			print(values)
			print("\n")
		
		print("Functions \n")
		for values:Dictionary in the_script.get_script_method_list():
			printt(values)
			print("\n")

func big_write(data:CppFunctionTemplate):
	pass

func write_class(data:CppFunctionTemplate):
	pass
