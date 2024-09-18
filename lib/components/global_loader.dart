import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class GlobalLoader extends StatelessWidget {
  const GlobalLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: LoadingAnimationWidget.twoRotatingArc(
        color: colorScheme.primary,
        size: 60,
      ),
    );
  }
}
