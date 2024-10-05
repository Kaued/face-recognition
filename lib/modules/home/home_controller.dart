import 'package:flutter_modular/flutter_modular.dart';

class HomeController {
  navigateToRegisterUser() {
    Modular.to.pushNamed('/register');
  }
}
