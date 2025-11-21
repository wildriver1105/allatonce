import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Google Maps API Key 초기화
    // TODO: YOUR_GOOGLE_MAPS_API_KEY를 실제 API 키로 교체하세요
    GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
