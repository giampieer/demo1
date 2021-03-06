import UIKit
import Flutter
import Foundation

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

    override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        let controller = window?.rootViewController as! FlutterViewController

        let channel = FlutterMethodChannel(name: "battery", binaryMessenger: controller as! FlutterBinaryMessenger)
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            guard call.method == "getBattery" else {
                result(FlutterMethodNotImplemented)
                return
            }
            self.receiveBatteryLevel(result: result)
        })
        
        let channel2 = FlutterMethodChannel(name: "date", binaryMessenger: controller as! FlutterBinaryMessenger)
        channel2.setMethodCallHandler({
            (call: FlutterMethodCall, result: FlutterResult) -> Void in
            guard call.method == "getDate" else {
                result(FlutterMethodNotImplemented)
                return
            }
            self.receiveDate(result: result);

        })

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    private func receiveDate(result: FlutterResult) {
           let formatter = DateFormatter()
            formatter.timeStyle = .full
            let dateString = formatter.string(from:Date())
            result(dateString)
        }

    private func receiveBatteryLevel(result: FlutterResult) {
        let device = UIDevice.current
        device.isBatteryMonitoringEnabled = true
        if device.batteryState == UIDevice.BatteryState.unknown {
            result(FlutterError(code: "Unavailable", message: "Battery info unavailable", details: nil))
        } else {
            result(Int(device.batteryLevel * 100))
        }
    }

}
