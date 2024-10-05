import 'package:face_recognition/modules/register_face/register_face_module.dart';
import 'package:face_recognition/modules/register_user/register_user_controller.dart';
import 'package:face_recognition/modules/register_user/register_user_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RegisterUserModule extends Module {
  @override
  void binds(Injector i) {
    i.add(RegisterUserController.new);
  }

  @override
  void routes(RouteManager r) {
    r.child(
      "/",
      child: (context) => RegisterUserPage(
        controller: Modular.get<RegisterUserController>(),
      ),
    );
    r.module("/face", module: RegisterFaceModule());
  }
}
