# Godot iOS/macOS Location Plugin
An iOS/macOS plugin for Godot to listen for the geolocation updates. The plugin is using the new Godot 4 plugin system. The plugin uses the iOS `CLLocationManager`.
The implementation is kept simple to maintain a small and lightweight footprint. However, it can easily be extended to support other use cases. Contributions are welcome, please feel free to submit feedback, pull requests, or fork the project as needed.

The plugin is using the [`SwiftGodot`](https://github.com/migueldeicaza/SwiftGodot) library and is inspired by some of the work of [`rktprof`](https://github.com/rktprof/godot-ios-extensions).

## Contents
* The Swift project for the iOS/macOS plugin: [`Location`](../Location)
* A wrapper/helper class to work with the plugin in GDScript: [`demo/ios_location_plugin.gd`](../demo/ios_location_plugin.gd)
* A demo project to test the plugin: [`demo`](../demo)

## Release
You can find the latest binaries in the [`releases page`](https://github.com/KarimIbrahim/godot-ios-extensions/releases).

## Usage
1. Copy the plugin directory (from the release page) under the `addons` directory in your Godot project (e.g. my_godot_project/addons/ios/Location). 
2. Make sure the paths in the `Location/Location.gdextension` file are correct and matching your directory setup
3. Copy [`demo/ios_location_plugin.gd`](../demo/ios_location_plugin.gd) into your scripts directory in your Godot project
4. Create a `Node` in your scene and call it `iOSLocationPlugin`
5. Attach the `ios_location_plugin.gd` to the `iOSLocationPlugin` node 
6. Reference the `iOSLocationPlugin` in your GDScripts either by path, or through an export e.g. `@export var ios_plugin: iOSLocationPlugin`
7. Connect the `iOSLocationPlugin` node with your exported variable
8. Create a listener for the geolocation updates in your script:
  ```gdscript
  func _on_location_update(location_dictionary: Dictionary) -> void:
	  var latitude: float = location_dictionary["latitude"]
	  var longitude: float = location_dictionary["longitude"]
	  log_label.text = str('Location Update: Latitude[', latitude, '], Longitude[', longitude, ']')
  ```
9. Connect the location update signal with the listener you just created in the `_ready()` method:
  ```gdscript
  func _ready():
	  ios_plugin.ios_location_updated.connect(self._on_location_update)
  ```
10. Export your project using the iOS template. Don't forget to add these 2 permissions under `Export window -> Options tab -> Additional Plist Content`:
  ```
<key>NSLocationWhenInUseUsageDescription</key>
<string>some description</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>some description</string>
  ```
11. Have fun!!

### Building the plugin
- You don't technically need to build the plugin, unless you need to modify the Swift project. The pre-built binaries are included in the [`releases page`](https://github.com/KarimIbrahim/godot-ios-extensions/releases)
- In a terminal window, navigate to the project's root directory ([`godot-ios-extensions`](..//)) and run the following command:
```
$ chmod a+x build.sh
$ ./build.sh Location all debug
```
- You can use the following to show the help message:
```
$ ./build.sh

Syntax: build [-f] <project> <platform?> <config?>

-f force copy SwiftGodot library even if it exists
        Useful if you have updated the SwiftGodot version
<project> is the project folder to build. eg Location
<platform> is the platform to build for
        Options: ios, macos & all. (Default: all)
<config> is the configuration to use
        Options: debug & release. (Default: release)

```
- On successful completion of the build, the output files can be found in [`demo/addons/ios/Location/bin`](../demo/addons/ios/Location/bin)

### Testing the plugin
You can use the included [demo](../demo/project.godot) to test the built iOS plugin

- Open the demo in Godot (4.2 or higher)
- Install the Godot iOS build template by clicking on `Project` -> `Install iOS Build Template...`
- Open [`demo/main.gd`](../demo/main.gd) and update the logic as needed 
- Connect an iOS device to your machine and run the demo on it
- **Note**: Running the plugin from Godot on macOS will not work. The app won't have the right permissions to read the location. You have to export the project to Xcode first. Once exported, you can run the app from Xcode either on an iOS device, or on your macOS and the location permissions should work.
