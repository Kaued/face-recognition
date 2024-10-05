import 'package:face_recognition/modules/register_user/register_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:validatorless/validatorless.dart';

class RegisterUserPage extends StatelessWidget {
  const RegisterUserPage({super.key, required this.controller});

  final RegisterUserController controller;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Container(
            width: size.width,
            height: size.height * 0.98,
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            child: SingleChildScrollView(
              child: SizedBox(
                height: size.height * 0.90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            width: double.infinity,
                            child: Text(
                              "Preencha os campos para fazer o registro",
                              style: textTheme.titleLarge,
                            ),
                          ),
                          TextFormField(
                            controller: controller.nameController,
                            validator: Validatorless.multiple([
                              Validatorless.required("Campo obrigatório"),
                            ]),
                            decoration: const InputDecoration(
                              hintText: "Nome",
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.registerUser,
                        child: const Text("Prosseguir"),
                      ),
                    )
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
