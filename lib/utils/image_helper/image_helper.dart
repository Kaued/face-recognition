import 'dart:typed_data';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart';

class ImageHelper {
  Image convertN21ToImage(CameraImage image) {
    final int width = image.width;
    final int height = image.height;

    // O plano NV21 contém todos os dados em um único bloco
    final Uint8List nv21 = image.planes[0].bytes;

    // Criação de uma nova imagem RGB
    Image rgbImage = Image(width: width, height: height);

    int yIndex = 0;
    int uvIndex = width * height; // UV começa após os dados Y

    for (int i = 0; i < height; i++) {
      for (int j = 0; j < width; j++) {
        // Dados Y
        int y = nv21[yIndex] & 0xFF;

        // Verifique se o cálculo de uvOffset não ultrapassa os limites
        if (uvIndex < nv21.length - 1) {
          // Para cada par de pixels (em NV21, UV compartilham dados a cada dois pixels)
          int u = nv21[uvIndex + (j & ~1) + 1] &
              0xFF; // U está sempre após o V no NV21
          int v = nv21[uvIndex + (j & ~1)] & 0xFF; // V precede o U

          // Conversão YUV para RGB
          int r = (y + 1.370705 * (v - 128)).toInt();
          int g = (y - 0.337633 * (u - 128) - 0.698001 * (v - 128)).toInt();
          int b = (y + 1.732446 * (u - 128)).toInt();

          // Limitação para valores válidos de 0 a 255
          r = r.clamp(0, 255);
          g = g.clamp(0, 255);
          b = b.clamp(0, 255);

          // Definir pixel na imagem RGB
          rgbImage.setPixel(j, i, rgbImage.getColor(r, g, b));
        }

        yIndex++;
      }

      // A cada linha par, avança para a próxima linha UV (já que UV é amostrado 2x2 em NV21)
      if (i % 2 == 0) {
        uvIndex += width;
      }
    }

    return rgbImage;
  }

  InputImage? processCameraImage(CameraImage image, CameraDescription camera) {
    final WriteBuffer allBytes = WriteBuffer();

    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }

    final Uint8List bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize =
        Size(image.width.toDouble(), image.height.toDouble());

    final InputImageRotation? imageRotation =
        InputImageRotationValue.fromRawValue(camera.sensorOrientation);

    final InputImageFormat? inputImageFormat =
        InputImageFormatValue.fromRawValue(image.format.raw);

    if (inputImageFormat == null) {
      return null;
    }

    if (imageRotation == null) {
      return null;
    }

    print(image.format.group.name);

    final int bytesPerRow = image.planes[0].bytesPerRow;

    // Criando o InputImage a partir dos dados da imagem YUV420
    final InputImage inputImage = InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: imageSize,
        rotation: imageRotation,
        format: inputImageFormat,
        bytesPerRow: bytesPerRow,
      ),
    );

    return inputImage;
  }

  Uint8List imageToByteListFloat32(
      Image image, int inputSize, double mean, double std) {
    // Criar um buffer para a imagem normalizada (valores entre -1 e 1)
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (var i = 0; i < inputSize; i++) {
      for (var j = 0; j < inputSize; j++) {
        buffer[pixelIndex++] =
            (image.getPixelCubic(j, i).getChannel(Channel.red) - mean) / std;
        buffer[pixelIndex++] =
            (image.getPixelCubic(j, i).getChannel(Channel.green) - mean) / std;
        buffer[pixelIndex++] =
            (image.getPixelCubic(j, i).getChannel(Channel.blue) - mean) / std;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }
}
