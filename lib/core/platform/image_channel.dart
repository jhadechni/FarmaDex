import 'package:flutter/services.dart';
import 'package:loggy/loggy.dart';

class ImageChannel {
  static const MethodChannel _channel = MethodChannel('custom_image_channel');

  static Future<String?> openCamera() async {
    try {
      final String? imagePath = await _channel.invokeMethod('openCamera');
      return imagePath;
    } on PlatformException catch (e) {
      logError("Failed to open camera: ${e.message}");
      return null;
    }
  }

  static Future<String?> openGallery() async {
    try {
      final String? imagePath = await _channel.invokeMethod('openGallery');
      return imagePath;
    } on PlatformException catch (e) {
      logError("Failed to open gallery: ${e.message}");
      return null;
    }
  }
}
