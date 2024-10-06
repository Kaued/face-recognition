import 'dart:typed_data';

import 'package:face_recognition/utils/image_helper/image_helper.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class FaceRecognition {
  final ImageHelper imageHelper = Modular.get<ImageHelper>();
  late final Future<Interpreter> interpreter;

  FaceRecognition() {
    final GpuDelegateV2 gpuDelegateV2 = GpuDelegateV2(
      options: GpuDelegateOptionsV2(),
    );

    final InterpreterOptions options = InterpreterOptions()
      ..addDelegate(gpuDelegateV2);

    interpreter = Interpreter.fromAsset('model.tflite', options: options);
  }

  Future<List> recognizeFace(Image image) async {
    image = copyResize(image, width: 128, height: 128);

    final Uint8List convertedImageList =
        imageHelper.imageToByteListFloat32(image, 112, 128, 128);

    final List<dynamic> input = convertedImageList.reshape([1, 112, 112, 3]);

    List<dynamic> output =
        List.filled(1 * 192, null, growable: false).reshape([1, 192]);

    final Interpreter model = await interpreter;

    model.run(input, output);

    output = output.reshape([192]);
    final List<dynamic> result = List.from(output);

    return result;
  }
}
