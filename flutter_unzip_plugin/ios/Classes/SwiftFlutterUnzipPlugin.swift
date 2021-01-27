import Flutter
import UIKit
import SSZipArchive

public class SwiftFlutterUnzipPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_unzip_plugin", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterUnzipPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    //result("iOS " + UIDevice.current.systemVersion)
    guard call.method == "unzip" else{
        result(FlutterMethodNotImplemented)
        return
    }
    myUnZip(call: call, result: result)
  }
    
    public func myUnZip(call : FlutterMethodCall, result : @escaping FlutterResult){
        DispatchQueue.global(qos: .userInitiated).async {
            
            guard let args = call.arguments as? [String: Any] else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
                return
            }
            
            guard let zipFile = args["zipPath"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Argument 'zipPath' is missing",details: nil))
                return
            }
            
            
            guard let destinationDir = args["extractPath"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Argument 'extractPath' is missing", details: nil))
                return
            }
            
            print("starting...")
            let success = SSZipArchive.unzipFile(atPath: zipFile, toDestination: destinationDir)
        
            if(success){
                print("success")
            }else{
                print("fail")
            }
            print("Ended");
            result(success)
        }
    }
}
