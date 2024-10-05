import 'package:face_recognition/components/face_preview.dart';
import 'package:face_recognition/modules/register_face/register_face_controller.dart';
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';

class RegisterFacePage extends StatelessWidget {
  const RegisterFacePage({super.key, required this.controller});

  final RegisterFaceController controller;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: size.width,
          height: size.height * 0.90,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Watch((context) {
                return FacePreview(
                  controller: controller.cameraController.value,
                  width: controller.hasFace.value
                      ? size.width * 0.53
                      : size.width * 0.70,
                  height: controller.hasFace.value
                      ? size.height * 0.36
                      : size.height * 0.45,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                  ),
                  insideDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(200),
                    border: Border.all(
                      color: colorScheme.primary,
                      width: 5,
                    ),
                  ),
                );
              }),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Watch(
                  (context) => Text(controller.hasFace.value
                      ? "Rosto detectado"
                      : "Detectando rosto..."),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
