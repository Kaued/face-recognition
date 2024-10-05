import 'package:face_recognition/modules/app.dart';
import 'package:face_recognition/modules/app_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ModularApp(
      module: AppModule(),
      child: const App(),
    ),
  );
}
