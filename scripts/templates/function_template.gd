extends Resource
class_name CppFunctionTemplate

#The name of the class
var cpp_class_name:String
#The name of the function
var func_name:String
#The parameters for a function
var func_params:PackedStringArray

#literally 4 spaces
const a_tab:String = "    "

#Class things
const class_filename:String = "{class_name_}.cpp"
const class_declaration:String = "class {class_name_}: public {inherits}{"
const class_var_get:String = "    {var_type} get_{var_name}();\n"
const class_var_set:String = "    void set_{var_name}({var_type} new_{var_name}); \n"

#Variable setgets
const var_setget_filename:String = "{class_name_}_set_gets.cpp"
const var_setget_get:String = "{var_type} {class_name_}::get_{var_name}(){\n    return {var_name};\n}\n"
const var_setget_set:String = "void {class_name_}::set_{var_name}({var_type} new_{var_name}){\n    {var_name} = new_{var_name};\n}\n"

#Variable bindings
const var_bind_get:String = "    ClassDB::bind_method(D_METHOD(\"get_{var_name}\"), &{class_name_}::get_{var_name});\n"
const var_bind_set:String = "    ClassDB::bind_method(D_METHOD(\"set_{var_name}\", \"{var_name}\"), &{class_name_}::set_{var_name});\n"
const var_bind_filename:String = "{class_name_}_bindings.cpp"

#Functions
const func_declaration:String = "    {var_type} {func_name}({func_params});\n"
const func_param:String = "{var_type} {var_name}"
const func_binding:String = ""
