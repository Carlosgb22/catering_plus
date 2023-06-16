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
                        String dni = dniController.text.trim();
                        String password = passwordController.text;

                        if (!validateDNIFormat(dni)) {
                          // Mostrar mensaje de error indicando que el formato del DNI es incorrecto
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                  'El formato del DNI es incorrecto.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Aceptar'),
                                ),
                              ],
                            ),
                          );
                          return;
                        }

                        if (await login(dni, password)) {
                          Employee emp = await getEmployee(dni);
                          redirectLogin(emp, context);
                        } else {
                          // Mostrar mensaje indicando que las credenciales son incorrectas
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Error'),
                              content: const Text(
                                  'Las credenciales son incorrectas.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Aceptar'),
                                ),
                              ],
                            ),
                          );
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

bool validateDNIFormat(String dni) {
  // Verificar que la longitud sea de 9 caracteres (8 dígitos + 1 letra)
  if (dni.length != 9) {
    return false;
  }

  // Verificar que los primeros 8 caracteres sean dígitos numéricos
  String dniNumbers = dni.substring(0, 8);
  if (!RegExp(r'^\d{8}$').hasMatch(dniNumbers)) {
    return false;
  }

  // Verificar que el último caracter sea una letra (mayúscula o minúscula)
  String dniLetter = dni.substring(8).toUpperCase();
  if (!RegExp(r'^[A-Z]$').hasMatch(dniLetter)) {
    return false;
  }

  return true;
}
