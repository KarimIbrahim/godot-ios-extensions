# Godot iOS/macOS Plugins
A collection of iOS/macOS plugins for Godot using [`SwiftGodot`](https://github.com/migueldeicaza/SwiftGodot).

## Contents
* The Swift projects for the iOS/macOS plugins
* A demo project to test the plugins: [`demo`](demo)

## Release
You can find the latest binaries in the [`releases page`](https://github.com/KarimIbrahim/godot-ios-extensions/releases).

### Building the plugins
- In a terminal window, navigate to the project's root directory ([`godot-ios-extensions`](/)) and run the following command:
```
$ chmod a+x build.sh
$ ./build.sh {plugin_name} all debug
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
- On successful completion of the build, the output files can be found in `demo/addons/ios/{plugin_name}/bin`

### Testing the plugin
You can use the included [demo](demo/project.godot) to test the built iOS plugin

- Open the demo in Godot (4.2 or higher)
- Install the Godot iOS build template by clicking on `Project` -> `Install iOS Build Template...`
- Open [`demo/main.gd`](demo/main.gd) and update the logic as needed 
- Connect an iOS device to your machine and run the demo on it
