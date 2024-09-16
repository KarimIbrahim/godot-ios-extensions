import SwiftGodot
import CoreLocation

@Godot(.tool)
public class Location: RefCounted {

    var isListeningForLocationUpdates = false

    var locationDelegate: LocationDelegate?

    public var locationManager: CLLocationManager?

    #signal("location_update", arguments: ["location_dictionary": GDictionary.self])

    required init(){
        super.init()
        locationDelegate = LocationDelegate(locationPlugin: self)
        locationManager = CLLocationManager()
        locationManager?.delegate = locationDelegate!
    }

    required init(nativeHandle: UnsafeRawPointer){
        super.init(nativeHandle: nativeHandle)
        locationDelegate = LocationDelegate(locationPlugin: self)
        locationManager = CLLocationManager()
        locationManager?.delegate = locationDelegate
    }

    public func emitLocationUpdate(locationDictionary: GDictionary) {
        isListeningForLocationUpdates = true
        emit(signal: Location.locationUpdate, locationDictionary)
    }
    
    @Callable
    public func ping() -> String {
        "Location-0.1"
    }
    
    @Callable
    public func hasLocationPermission() -> Bool {
        let status = locationManager!.authorizationStatus
        switch status {
            case .authorizedWhenInUse, .authorizedAlways:
                return true
            default:
                return false
        }
    }
    
    @Callable
    public func requestLocationPermission() {
        locationManager!.requestWhenInUseAuthorization()
    }
    
    @Callable
    public func isListeningForGeolocationUpdates() -> Bool {
        isListeningForLocationUpdates
    }
    
    @Callable
    public func startGeolocationListener(askForAlwaysPermission: Bool = false) -> Bool {
        if (!isListeningForLocationUpdates) {
            locationDelegate!.askForAlwaysPermission = true
            locationManager!.startUpdatingLocation()
        }

        return isListeningForLocationUpdates
    }
    
    @Callable
    public func stopGeolocationListener() {
        if (isListeningForLocationUpdates) {
            locationManager!.stopUpdatingLocation() 
            isListeningForLocationUpdates = false
        }
    }

}

public class LocationDelegate: NSObject, CLLocationManagerDelegate {

    let locationPlugin: Location

    public var askForAlwaysPermission: Bool = false

    init(locationPlugin: Location) {
        self.locationPlugin = locationPlugin
    }

     public override var description: String {
        return "Godot location delegate"
    }

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .restricted:
            GD.print("Location permission: restricted.")
        case .denied:
            GD.print("Location permission: denied.")
        case .authorizedWhenInUse:
            if(askForAlwaysPermission) {
                locationPlugin.locationManager!.requestAlwaysAuthorization()
            }
            GD.print("Location permission: granted WhenInUse.")
        case .authorizedAlways:
            GD.print("Location permission: granted Always.")
        default:
            GD.print("Location permission: unknown.")
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let locationDictionary = GDictionary()
        locationDictionary["latitude"] = Variant(location.coordinate.latitude)
        locationDictionary["longitude"] = Variant(location.coordinate.longitude)
        locationPlugin.emitLocationUpdate(locationDictionary: locationDictionary)
    }
}

public let godotTypes: [Wrapped.Type] = [
    Location.self
]

#initSwiftExtension(cdecl: "swift_entry_point", types: godotTypes)
