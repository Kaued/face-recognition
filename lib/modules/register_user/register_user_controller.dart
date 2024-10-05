import 'package:face_recognition/utils/toast/toastification_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class RegisterUserController {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();

  void registerUser() {
    if (formKey.currentState!.validate()) {
      final String name = nameController.text;

      Modular.to.pushNamed("/register/face/", arguments: name);

      return;
    }

    ToastificationHelper.showError(
      message: "Verifique se todos os campos foram preenchidos corretamente",
      title: "Campos inválidos",
    );
  }
}
