import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
  var flutterResult: FlutterResult?
  var imagePicker: UIImagePickerController?
  var flutterViewController: FlutterViewController?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller = window?.rootViewController as! FlutterViewController
    flutterViewController = controller

    let channel = FlutterMethodChannel(name: "com.pokedex.image", binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler { [weak self] call, result in
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

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

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
}
