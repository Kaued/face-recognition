import 'package:asyncstate/asyncstate.dart';
import 'package:face_recognition/components/global_loader.dart';
import 'package:face_recognition/utils/gloabalContext/global_context.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:toastification/toastification.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    Modular.setNavigatorKey(GlobalContext.navigatorKey);

    return AsyncStateBuilder(
      builder: (navigationObserver) {
        Modular.setObservers([navigationObserver]);

        return ToastificationWrapper(
          child: MaterialApp.router(
            title: "Face Recognition",
            routerConfig: Modular.routerConfig,
          ),
        );
      },
      customLoader: const GlobalLoader(),
    );
  }
}
