import UIKit
import Flutter
import CoreLocation

@main
@objc class AppDelegate: FlutterAppDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, CLLocationManagerDelegate {
  var flutterResult: FlutterResult?
  var imagePicker: UIImagePickerController?
  var flutterViewController: FlutterViewController?

  // Compass
  var locationManager: CLLocationManager!
  var currentHeading: CLLocationDirection = 0

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller = window?.rootViewController as! FlutterViewController
    flutterViewController = controller

    // Immage channel
    let imageChannel = FlutterMethodChannel(name: "com.pokedex.image", binaryMessenger: controller.binaryMessenger)
    imageChannel.setMethodCallHandler { [weak self] call, result in
      self?.flutterResult = result

      switch call.method {
      case "openCamera":
        self?.openImagePicker(source: .camera)
      case "openGallery":
        self?.openImagePicker(source: .photoLibrary)
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    // compass channel
    let compassChannel = FlutterMethodChannel(name: "com.pokedex.compass", binaryMessenger: controller.binaryMessenger)
    compassChannel.setMethodCallHandler { [weak self] call, result in
      if call.method == "getAzimuth" {
        result(self?.currentHeading ?? 0)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    // compass setup
    locationManager = CLLocationManager()
    locationManager.delegate = self
    locationManager.headingFilter = 1
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingHeading()

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // MARK: - Image Picker

  func openImagePicker(source: UIImagePickerController.SourceType) {
    guard UIImagePickerController.isSourceTypeAvailable(source) else {
      flutterResult?("Source not available")
      return
    }

    let picker = UIImagePickerController()
    picker.sourceType = source
    picker.delegate = self
    flutterViewController?.present(picker, animated: true, completion: nil)
    imagePicker = picker
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    picker.dismiss(animated: true, completion: nil)

    if let imageUrl = info[.imageURL] as? URL {
      flutterResult?(imageUrl.path)
    } else if let image = info[.originalImage] as? UIImage {
      let data = image.jpegData(compressionQuality: 0.8)
      let filename = UUID().uuidString + ".jpg"
      let filePath = NSTemporaryDirectory().appending(filename)
      if let data = data {
        FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil)
        flutterResult?(filePath)
      } else {
        flutterResult?("Failed to save image")
      }
    } else {
      flutterResult?("No image found")
    }
  }

  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
    flutterResult?(nil)
  }

  // MARK: - Compass

  func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    currentHeading = newHeading.magneticHeading
  }
}
