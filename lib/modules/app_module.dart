import 'package:face_recognition/modules/home/home_module.dart';
import 'package:face_recognition/modules/register_user/register_user_module.dart';
import 'package:face_recognition/utils/database/database_helper.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppModule extends Module {
  @override
  void binds(Injector i) {
    i.add(SharedPreferences.getInstance);
    i.add(DatabaseHelper.new);
  }

  @override
  void routes(RouteManager r) {
    r.module("/", module: HomeModule());
    r.module("/register", module: RegisterUserModule());
  }
}
