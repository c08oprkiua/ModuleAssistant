extends Resource

class_name AppSettings
##If the generators should generate Godot 3 code instead of Godot 4 code.
@export var godot_3_mode:bool = false
##The directory that files output to
@export var output_directory:String = ProjectSettings.globalize_path(OS.get_user_data_dir())
