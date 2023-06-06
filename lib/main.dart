import 'package:catering_plus/ui/view/login.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "Catering+",
    theme: ThemeData(
      brightness: Brightness.light,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
            return const Color(0xff434a52);
          }),
        ),
      ),
      primarySwatch: Colors.blueGrey,
      primaryColor: const Color(0xff434a52),
      primaryColorLight: const Color(0xff434a52),
      primaryColorDark: const Color(0xff434a52),
      shadowColor: const Color(0xff434a52),
    ),
    initialRoute: "/login",
    routes: {
      "/login": (context) => const Start(),
    },
  ));
}

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _InicioState();
}

class _InicioState extends State<Start> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Catering+"),
        ),
        body: const Login());
  }
}
