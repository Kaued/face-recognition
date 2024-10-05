import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FacePreview extends StatelessWidget {
  const FacePreview({
    super.key,
    required this.controller,
    required this.width,
    required this.height,
    this.decoration,
    this.insideDecoration,
    this.clipBehavior = Clip.none,
  });

  final CameraController? controller;
  final double width;
  final double height;
  final BoxDecoration? decoration;
  final Clip clipBehavior;
  final BoxDecoration? insideDecoration;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      width: width,
      height: height,
      clipBehavior: clipBehavior,
      decoration: decoration,
      child: controller != null
          ? CameraPreview(
              controller!,
              child: Container(
                decoration: insideDecoration,
                width: width,
                height: height,
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
