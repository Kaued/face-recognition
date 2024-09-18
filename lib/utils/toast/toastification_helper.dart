import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastificationHelper {
  static final Toastification _toast = Toastification();

  static void showSuccess({
    required String message,
    required String title,
  }) {
    _toast.show(
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text(title),
      description: Text(message),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
    );
  }

  static void showError({
    required String message,
    required String title,
  }) {
    _toast.show(
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text(title),
      description: Text(message),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
    );
  }

  static void showInfo({
    required String message,
    required String title,
  }) {
    _toast.show(
      type: ToastificationType.info,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text(title),
      description: Text(message),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
    );
  }

  static void showWarning({
    required String message,
    required String title,
  }) {
    _toast.show(
      type: ToastificationType.warning,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text(title),
      description: Text(message),
      alignment: Alignment.topRight,
      direction: TextDirection.ltr,
    );
  }
}
