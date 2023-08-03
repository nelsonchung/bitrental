import UIKit
import Flutter
import Firebase
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if TARGET_OS_SIMULATOR == 1 {
      // Running in iOS Simulator, do not configure Firebase
    } else {
      // Running on a physical device, configure Firebase
      FirebaseApp.configure()
    }
    GMSServices.provideAPIKey("AIzaSyDytY4IBiZ-xfVU5vV49kdRKodl7XFG5fg")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
