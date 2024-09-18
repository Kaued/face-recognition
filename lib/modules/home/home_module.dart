import 'package:face_recognition/modules/home/home_controller.dart';
import 'package:face_recognition/modules/home/home_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  void binds(Injector i) {}

  @override
  void routes(RouteManager r) {
    r.child("/",
        child: (context) =>
            HomePage(controller: Modular.get<HomeController>()));
  }
}
