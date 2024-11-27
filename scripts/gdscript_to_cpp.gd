extends VBoxContainer

class_name GDScriptToCPP

var filename:String

var cppfilestring:String

var script_select:FileDialog = FileDialog.new()

var root:AppRoot

var number:int = 4

var script_object:Object

func _ready() -> void:
	add_child(script_select)
	script_select.hide()
	script_select.access = FileDialog.ACCESS_FILESYSTEM
	script_select.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	script_select.use_native_dialog = true
	script_select.add_filter("*.gd", "GDScript Scripts")
	script_select.current_dir = OS.get_executable_path()

func _on_input_pressed():
	script_select.show()
	
	if not script_select.is_connected(&"file_selected", parse_gdscript_object):
		script_select.connect(&"file_selected", parse_gdscript_object, CONNECT_ONE_SHOT)
	
	parse_gdscript_func(ProjectSettings.globalize_path("res://scripts/var_type.gd"))

func parse_gdscript_object(path:String) -> void:
	if FileAccess.file_exists(path):
		var the_script:GDScript = load(path)
		script_object = the_script.new()
		prints("class", the_script.get_global_name(), ":", "public", the_script.get_instance_base_type())
		
		print("Properties")
		for values:Dictionary in the_script.get_script_property_list():
			VariableInfo.new(values)
		
		print("Functions")
		for values:Dictionary in the_script.get_script_method_list():
			CppFunctionTemplate.new(values)

func parse_gdscript_func(stir:String):
	if FileAccess.file_exists(stir):
		var the_script:GDScript = load(stir)
		script_object = the_script.new()
		root.current_class_name = the_script.get_global_name()
		if root.current_class_name.is_empty():
			root.current_class_name = the_script.get_instance_base_type() + "AnonymousSub"
		root.class_inherits = the_script.get_instance_base_type()

func big_write(data:CppFunctionTemplate):
	pass

func write_class(data:CppFunctionTemplate):
	pass
