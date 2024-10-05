# Godot iOS/macOS Battery Plugin
An iOS/macOS plugin for Godot to retrieve the battery status. The plugin is using the new Godot 4 plugin system.

## Usage
1. Copy the plugin directory (from the release page) under the `addons` directory in your Godot project (e.g. my_godot_project/addons/ios/Battery). 
2. Make sure the paths in the `Battery/Battery.gdextension` file are correct and matching your directory setup
8. Create a listener for the battery status updates in your script:
  ```gdscript
	func _on_battery_level(level: int) -> void:
		battery_level_label.text = 'Battery level: %d' % level

	func _on_battery_state(state: int) -> void:
		var state_string = 'Unknown'
		match state:
			0: 
				state_string = 'Unplugged'
			1: 
				state_string = 'Charging'
			2:
				state_string = 'Full'
			_: 
				state_string = 'Unknown'
		battery_state_label.text = 'Battery state: %s' % state_string
  ```
9. Connect the battery update signals with the listener you just created in the `_ready()` method:
  ```gdscript
  var battery: Battery = Battery.new()

  func _ready():
	battery.connect("battery_level", self._on_battery_level)
	battery.connect("battery_state", self._on_battery_state)
  ```
10. Export your project using the iOS template
11. iOS plugin will publish a signal whenever the battery state/level actually change, on the other hand, the macOS plugin will publish a signal every 10 seconds with the current battery state/level regardless of any changes. This is due to limitations in the macOS available APIs.
12. Have fun!!

### Building the plugin
- You don't technically need to build the plugin, unless you need to modify the Swift project. The pre-built binaries are included in the [`releases page`](https://github.com/KarimIbrahim/godot-ios-extensions/releases)
- In a terminal window, navigate to the project's root directory ([`godot-ios-extensions`](/)) and run the following command:
```
$ chmod a+x build.sh
$ ./build.sh Battery all debug
```
- You can use the following to show the help message:
```
$ ./build.sh

Syntax: build [-f] <project> <platform?> <config?>

-f force copy SwiftGodot library even if it exists
        Useful if you have updated the SwiftGodot version
<project> is the project folder to build. eg Battery
<platform> is the platform to build for
        Options: ios, macos & all. (Default: all)
<config> is the configuration to use
        Options: debug & release. (Default: release)

```
- On successful completion of the build, the output files can be found in [`demo/addons/ios/Battery/bin`](demo/addons/ios/Battery/bin)

### Testing the plugin
You can use the included [demo](demo/project.godot) to test the built iOS plugin

- Open the demo in Godot (4.2 or higher)
- Install the Godot iOS build template by clicking on `Project` -> `Install iOS Build Template...`
- Open [`demo/main.gd`](demo/main.gd) and update the logic as needed 
- Connect an iOS device to your machine and run the demo on it
