import 'package:face_recognition/modules/register_face/register_face_controller.dart';
import 'package:face_recognition/modules/register_face/register_face_page.dart';
import 'package:face_recognition/services/face_detection.dart';
import 'package:face_recognition/utils/image_helper/image_helper.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RegisterFaceModule extends Module {
  @override
  void binds(Injector i) {
    i.add(ImageHelper.new);
    i.add(FaceDetection.new);
    i.add(RegisterFaceController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      "/",
      child: (context) => RegisterFacePage(
        controller: Modular.get<RegisterFaceController>(),
      ),
    );
  }
}
