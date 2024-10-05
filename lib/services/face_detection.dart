import 'package:google_ml_kit/google_ml_kit.dart';

class FaceDetection {
  late FaceDetector _faceDetector;

  FaceDetection() {
    _faceDetector = GoogleMlKit.vision.faceDetector();
  }

  Future<List<Face>> processImage(InputImage inputImage) async {
    return await _faceDetector.processImage(inputImage);
  }
}
