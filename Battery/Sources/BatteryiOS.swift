#if os(iOS)

import SwiftGodot
import UIKit

@Godot(.tool)
public class Battery: RefCounted {

    #signal("battery_level", arguments: ["level": Int.self])
    #signal("battery_state", arguments: ["state": Int.self])

    required init(){
        super.init()
        initializeBattery()
    }

    required init(nativeHandle: UnsafeRawPointer){
        super.init(nativeHandle: nativeHandle)
        initializeBattery()
   }

    private func initializeBattery() {
        UIDevice.current.isBatteryMonitoringEnabled = true
        NotificationCenter.default.addObserver(self, selector: #selector(batteryLevelDidChange(_:)), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateDidChange(_:)), name: UIDevice.batteryStateDidChangeNotification, object: nil)
    }

    @Callable
    public func ping() -> String {
        "Battery-0.1"
    }

    @Callable
    public func getBatteryLevel() -> Int {
        let level = UIDevice.current.batteryLevel * 100
        let levelInt = Int(level)
        GD.print("Battery level (ios): \(levelInt)")
        return levelInt
    }

    @Callable
    public func getBatteryState() -> Int {
        let state = switch UIDevice.current.batteryState {
            case .unknown:
                -1
            case .unplugged:
                0
            case .charging:
                1
            case .full:
                2
            @unknown default:
                -1
        }
        GD.print("Battery state (ios): \(state)")
        return state
    }

    @objc func batteryStateDidChange(_ notification: Notification) {
        emit(signal: Battery.batteryState, getBatteryState())
    }
    
    @objc func batteryLevelDidChange(_ notification: Notification) {
        emit(signal: Battery.batteryLevel, getBatteryLevel())
    }

    deinit {
        UIDevice.current.isBatteryMonitoringEnabled = false
        NotificationCenter.default.removeObserver(self)
    }
}

#endif
