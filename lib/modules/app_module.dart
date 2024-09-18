import 'package:face_recognition/modules/home/home_module.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    i.add(SharedPreferences.getInstance);
  }

  @override
  void routes(RouteManager r) {
    r.module("/", module: HomeModule());
  }
}
