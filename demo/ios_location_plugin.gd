extends Node

# A wrapper/helper class for the  iOS Location Plugin.
# The wrapper will start the geolocation listener which will automatically 
# ask the user for permissions if they haven't rejected it previously.
#
# Please note that location permission on iOS is not always on demand.
# iOS will not always show the permission popup. This happens when the user doesn't 
# grant permission for the first time the popup shows up. This seems to be a safeguard from 
# iOS to prevent apps from spamming the user when they reject the location permissions.
# In this particular case, you can use the  _has_location_permission method to detect this 
# corner case and show a message in your game to ask the user to manually change the permission 
# from the iOS settings.
#
# The wrapper exposes the following signal:
# ios_location_updated: Emitted periodically with the updated geolocation.
class_name iOSLocationPlugin

var plugin: Location = Location.new()
var _is_supported_platform: bool = false

# Emitted periodically with the updated geolocation.
# The location_dictionary will contain either:
# 1. 2 keys: "latitude" and "longitude". Both keys have float values.
# 2. No keys: Failed to retrieve the location.
signal ios_location_updated(location_dictionary: Dictionary)

func _ready():
	print('Running in ', OS.get_name())
	if OS.get_name() in ['iOS', 'macOS']:
		_is_supported_platform = true
		plugin.connect("location_update", self.on_location_update)

		_start_geolocation_listener()
	else:
		printerr('iOSLocationPlugin: Unsupported platform')


# Pings the plugin and returns its name and version.
func _ping() -> String:
	if _is_supported_platform:
		return plugin.ping()
	else:
		return "Couldn't find iOSLoationPlugin"


# Returns true if location permissions are granted.
# Returns false otherwise.
func _has_location_permission() -> bool:
	if _is_supported_platform:
		return plugin.hasLocationPermission()
	else:
		return false


# Returns true if the geolocation listener is running.
func _is_listening_for_geolocation_updates() -> bool:
	if _is_supported_platform:
		return plugin.isListeningForGeolocationUpdates()
	else:
		return false


# Starts the geolocation listener if it is not running.
# ask_for_always_permission: Will ask the user to give "Always" location permission.
# Returns true if the listener is running successfully.
# Returns false if the listener failed to start.
func _start_geolocation_listener(ask_for_always_permission: bool = false) -> bool:
	if _is_supported_platform:
		return plugin.startGeolocationListener(ask_for_always_permission)
	else:
		return false


# Stops the geolocation listener.
func _stop_geolocation_listener() -> void:
	if _is_supported_platform:
		plugin.stopGeolocationListener()


func on_location_update(location_dictionary: Dictionary) -> void:
	ios_location_updated.emit(location_dictionary)
