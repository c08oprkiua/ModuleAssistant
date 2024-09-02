# ModuleAssistant

### USE THIS AT YOUR (CODE'S) OWN RISK!!!

Helper tool for making engine modules in Godot 4 and 3. 



This is a little thingamabob I initially made in an evening to automate all the set, get, and bind functions needed to register variables in Godot C++ modules. I figured this would be a one-and-done project, yet I keep returning to it to add things I want/need as I work on modules, so we'll see where it goes in the future.



## Features

* Generates set, get, and binding functions for variables

* Can generate several different types of variables at once (when using static typing)

## Usage

To use the variable code generator, list your variables, separating them by commas.

* Any spaces will be deleted (ex: "My var 1, my  var  2" will translate to `Myvar1` and `myvar2`)

* You can type your variables with GDScript/Python syntax (ex: `my_float:float`), and that will be used instead of the default type. 

* If no default type is set, it will default to "Variant". If no class is specified, it will give an error and not generate. 

* There are not and will not be validity checks on types, so if you make a typo, that's on you. Luckily, you can always fix it and re-run the generator :P



When the C++ code is generated, it will show up in the preview windows on the right side. Here, you can make any necessary edits that you may see fit to do. If you want to export that text to a file, click the save button. Then, press the button for opening the output folder, and the folder where the saved files are written to will be opened in your file explorer, defaulting to the user directory of Godot.


## Issues

##### Note: I may or *may not* address these

* No dedicated function binding generator.
* The GDScript to C++ converter is currently not done. Even when it eventually is, what it will output will probably have to be manually tweaked/added to before it is proper, usable code.
