import 'package:camera/camera.dart';
import 'package:face_recognition/services/face_detection.dart';
import 'package:face_recognition/utils/image_helper/image_helper.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:signals/signals.dart';

class RegisterFaceController {
  final ImageHelper imageHelper = Modular.get<ImageHelper>();
  final FaceDetection faceDetection = Modular.get<FaceDetection>();

  final String name = Modular.args.data as String;
  List<CameraDescription> cameras = [];
  final Signal<CameraController?> cameraController =
      Signal<CameraController?>(null);
  final Signal<bool> hasFace = Signal<bool>(false);

  bool isDetecting = false;

  RegisterFaceController() {
    __startCamera();
  }

  Future<void> __startCamera() async {
    cameras = await availableCameras();

    CameraDescription firstCamera =
        cameras.length >= 2 ? cameras[1] : cameras[0];

    final CameraController newController = CameraController(
      firstCamera,
      ResolutionPreset.max,
    );

    newController.initialize().then((_) {
      cameraController.value = newController;

      cameraController.value!.startImageStream((CameraImage image) async {
        if (!isDetecting) {
          isDetecting = true;
          __processImage(image, firstCamera);
        }
      });
    }).catchError(
      (Object e) {
        if (e is CameraException) {
          switch (e.code) {
            case 'CameraAccessDenied':
              // Handle access errors here.
              break;
            default:
              // Handle other errors here.
              break;
          }
        }
      },
    );
  }

  Future<void> __processImage(
      CameraImage image, CameraDescription camera) async {
    try {
      InputImage inputImage = imageHelper.processCameraImage(image, camera);

      List<Face> faces = await faceDetection.processImage(inputImage);

      print(faces);
      hasFace.value = faces.isNotEmpty;
    } catch (e, strace) {
      print(e);
      print(strace);
    } finally {
      isDetecting = false;
    }
  }
}
