import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:face_recognition/services/face_detection.dart';
import 'package:face_recognition/services/face_recognition.dart';
import 'package:face_recognition/services/user_service.dart';
import 'package:face_recognition/utils/image_helper/image_helper.dart';
import 'package:face_recognition/utils/toast/toastification_helper.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart';
import 'package:signals/signals.dart';

class RegisterFaceController implements Disposable {
  final ImageHelper imageHelper = Modular.get<ImageHelper>();
  final FaceDetection faceDetection = Modular.get<FaceDetection>();
  final FaceRecognition _faceRecognition = Modular.get<FaceRecognition>();
  final UserService userService = Modular.get<UserService>();

  final String name = Modular.args.data as String;
  List<CameraDescription> cameras = [];
  final Signal<CameraController?> cameraController =
      Signal<CameraController?>(null);
  final Signal<bool> hasFace = Signal<bool>(false);
  final Signal<String> message = Signal<String>('Nenhum rosto detectado');
  final Signal<bool> takePicture = Signal<bool>(false);

  Timer? timerToTakePicture;
  int timerCount = 5;

  bool isDetecting = false;

  RegisterFaceController() {
    _startCamera();
  }

  @override
  void dispose() {
    cameraController.value?.dispose();
  }

  Future<void> _startCamera() async {
    cameras = await availableCameras();

    CameraDescription firstCamera =
        cameras.length >= 2 ? cameras[1] : cameras[0];

    final CameraController newController = CameraController(
      firstCamera,
      ResolutionPreset.max,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
      enableAudio: false,
    );

    newController.initialize().then((_) {
      cameraController.value = newController;

      cameraController.value!.startImageStream((CameraImage image) async {
        if (!isDetecting && takePicture.value == false) {
          isDetecting = true;
          _processImage(image, firstCamera);
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

  Future<void> _processImage(
      CameraImage image, CameraDescription camera) async {
    try {
      InputImage? inputImage = imageHelper.processCameraImage(image, camera);

      if (inputImage == null) {
        return;
      }

      List<Face> faces = await faceDetection.processImage(inputImage);

      if (faces.isNotEmpty) {
        hasFace.value = true;

        if (faces.length > 1) {
          message.value = 'Mais de um rosto detectado';
          _cancelTime();

          return;
        }
        final Face face = faces[0];

        if ((face.headEulerAngleY == null || face.headEulerAngleZ == null) ||
            (face.headEulerAngleY!.abs() > 10 ||
                face.headEulerAngleZ!.abs() > 10)) {
          message.value = 'Posicione o rosto reto';
          _cancelTime();

          return;
        }

        final centerX = inputImage.metadata!.size.width / 2;
        final centerY = inputImage.metadata!.size.height / 2;

        final faceCenterX = face.boundingBox.center.dx;
        final faceCenterY = face.boundingBox.center.dy;

        final double rangeWidth = inputImage.metadata!.size.width * 0.1;
        final double rangeHeight = inputImage.metadata!.size.height * 0.1;

        if (faceCenterX < centerX - rangeWidth &&
            faceCenterX > centerX - (rangeWidth * 2)) {
          message.value = "Mova o rosto para a esquerda";
          _cancelTime();

          return;
        }

        if (faceCenterX < centerX + rangeWidth &&
            faceCenterX > centerX + (rangeWidth * 2)) {
          message.value = "Mova o rosto para a direita";
          _cancelTime();

          return;
        }

        if (faceCenterY > centerY - rangeHeight &&
            faceCenterY < centerY - (rangeHeight * 2)) {
          message.value = 'Mova o rosto para baixo';
          _cancelTime();

          return;
        }

        if (faceCenterY < centerY + rangeHeight &&
            faceCenterY > centerY + (rangeHeight * 2)) {
          message.value = "Mova o rosto para cima";
          _cancelTime();

          return;
        }

        if (face.boundingBox.width < 600) {
          message.value = 'Aproxime o rosto da câmera';
          _cancelTime();

          return;
        }

        if (timerToTakePicture != null) {
          return;
        }

        message.value = "Sucesso";

        timerToTakePicture =
            Timer.periodic(const Duration(seconds: 1), (timer) async {
          message.value = "Tirando foto em $timerCount";
          timerCount--;

          if (timerCount == 0) {
            timerToTakePicture?.cancel();
            takePicture.value = true;
            timerToTakePicture = null;
            timerCount = 5;
            message.value = "Verificando foto";
            await _registerUser(image, face);
          }
        });

        return;
      }

      hasFace.value = false;
      message.value = 'Nenhum rosto detectado';

      _cancelTime();
    } finally {
      isDetecting = false;
    }
  }

  void _cancelTime() {
    timerToTakePicture?.cancel();
    timerToTakePicture = null;
    timerCount = 5;
    takePicture.value = false;
  }

  Future<void> _registerUser(CameraImage camera, Face face) async {
    final Image image = imageHelper.convertN21ToImage(camera);

    final double x = face.boundingBox.left.toDouble() - 10;
    final double y = face.boundingBox.top.toDouble() - 10;
    final double width = face.boundingBox.width.toDouble() + 10;
    final double height = face.boundingBox.height.toDouble() + 10;

    Image croppedImage = copyCrop(
      image,
      x: x.toInt(),
      y: y.toInt(),
      width: width.toInt(),
      height: height.toInt(),
    );

    croppedImage = copyResizeCropSquare(croppedImage, size: 112);

    final List result = await _faceRecognition.recognizeFace(croppedImage);

    try {
      await userService.createUser(name, result);
      ToastificationHelper.showSuccess(
          message: "O usuário $name foi cadastrado com sucesso",
          title: "Sucesso");
      Modular.to.navigate("/");
    } catch (e) {
      ToastificationHelper.showError(
          message: "Erro ao cadastrar o usuário $name", title: "Erro");

      message.value = "Erro ao cadastrar o usuário";
      takePicture.value = false;
    }
  }
}
