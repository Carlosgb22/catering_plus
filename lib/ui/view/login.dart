// ignore_for_file: use_build_context_synchronously

import 'package:catering_plus/core/provider/employee_provider.dart';
import 'package:flutter/material.dart';

import '../../core/models/employee_model.dart';
import '../../core/provider/login_provider.dart';
import '../../core/provider/session_provider.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final dniController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    checkSession(context);
    super.initState();
  }

  @override
  void dispose() {
    dniController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/fondo.png"),
          repeat: ImageRepeat.repeat,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Image(
              image: AssetImage('assets/images/logo.png'),
              width: 400,
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 0,
              shape: const RoundedRectangleBorder(
                side: BorderSide(color: Color(0xff434a52)),
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Column(
                children: [
                  const SizedBox(width: 300),
                  SizedBox(
                    width: 250,
                    child: TextField(
                      controller: dniController,
                      decoration: const InputDecoration(
                        hintText: "DNI",
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 250,
                    child: TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        hintText: "Contraseña",
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (await login(
                            dniController.text, passwordController.text)) {
                          Employee emp = await getEmployee(dniController.text);
                          redirectLogin(emp, context);
                        }
                      },
                      child: const Text("Entrar"),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Información de contacto"),
                      content: const Text(
                        "Póngase en contacto con nosotros para más información"
                        " sobre cómo registrar su empresa de catering.\n\n"
                        "developer@catering_plus.es",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cerrar"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text(
                "¿Tienes una empresa de catering?",
                style: TextStyle(
                    fontSize: 12, backgroundColor: Colors.grey.shade200),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
