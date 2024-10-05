#if os(macOS)

import SwiftGodot
import Foundation
import IOKit.ps

@Godot(.tool)
public class Battery: RefCounted {

    #signal("battery_level", arguments: ["level": Int.self])
    #signal("battery_state", arguments: ["state": Int.self])

    private var timer: Foundation.Timer?

    required init(){
        super.init()
        initializeTimer()
    }

    required init(nativeHandle: UnsafeRawPointer){
        super.init(nativeHandle: nativeHandle)
        initializeTimer()
   }

    private func initializeTimer(pollIntervalSeconds: Double = 10) {
        timer = Timer.scheduledTimer(timeInterval: pollIntervalSeconds, target: self, selector: #selector(publishBatteryStatus), userInfo: nil, repeats: true)
    }

    @Callable
    public func ping() -> String {
        "Battery-0.1"
    }

    @objc private func publishBatteryStatus() {
        emit(signal: Battery.batteryLevel, getBatteryLevel())
        emit(signal: Battery.batteryState, getBatteryState())
    }

    @Callable
    func getBatteryLevel() -> Int {
        guard let batteryInfo = fetchBatteryInfo(),
                let currentCapacity = batteryInfo[kIOPSCurrentCapacityKey] as? Int,
                let maxCapacity = batteryInfo[kIOPSMaxCapacityKey] as? Int else {
        
            GD.print("Couldn't get battery info. Returning battery level = 0")
            return 0
        }
        let batteryLevel = Float(currentCapacity) / Float(maxCapacity) * 100
        let batteryLevelInt = Int(batteryLevel)
        GD.print("Battery level (macos): \(batteryLevelInt)")
        return batteryLevelInt
    }

    @Callable
    func getBatteryState() -> Int {
        let isCharging = isCharging() 
        GD.print("Is charging (macos): \(isCharging)")
        return if isCharging {
            1 
        } else {
            0
        }
    }

    func isCharging() -> Bool {
         return IOPSCopyExternalPowerAdapterDetails()?.takeRetainedValue() != nil
    }

    private func fetchBatteryInfo() -> [String: Any]? {
        guard let snapshot = IOPSCopyPowerSourcesInfo()?.takeRetainedValue(),
                let sources = IOPSCopyPowerSourcesList(snapshot)?.takeRetainedValue() as? [CFTypeRef], !sources.isEmpty,
                let powerSource = sources.first,
                let description = IOPSGetPowerSourceDescription(snapshot, powerSource)?.takeUnretainedValue() as? [String: Any] else {
            return nil
        }
        return description
    }

    deinit {
        timer?.invalidate()
    }

}

#endif
