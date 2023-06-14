import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/models/employee_model.dart';
import '../../../core/provider/employee_provider.dart';
import 'admin_ini.dart';

class AddEmployee extends StatefulWidget {
  final Employee emp;
  const AddEmployee({Key? key, required this.emp}) : super(key: key);

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  late Employee _emp;
  late final TextEditingController _dniController = TextEditingController();
  late final TextEditingController _nameController = TextEditingController();
  late final TextEditingController _familyNameController =
      TextEditingController();
  late final TextEditingController _phoneController = TextEditingController();
  late final TextEditingController _ssController = TextEditingController();
  late bool _isClerk = false;

  bool _isFormValid = false;
  String _dniError = '';
  String _nameError = '';
  String _familyNameError = '';
  String _phoneError = '';
  String _ssError = '';

  @override
  void initState() {
    _emp = widget.emp;
    super.initState();
  }

  @override
  void dispose() {
    _dniController.dispose();
    _nameController.dispose();
    _familyNameController.dispose();
    _phoneController.dispose();
    _ssController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Añadir Empleado"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //DATOS
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        "Información del Empleado",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person,
                              color: Theme.of(context).primaryColor),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: Platform.isAndroid || Platform.isIOS
                                ? MediaQuery.of(context).size.width * 0.7
                                : MediaQuery.of(context).size.width * 0.15,
                            child: TextField(
                              controller: _nameController,
                              style: const TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                labelText: "Nombre",
                                errorText:
                                    _nameError.isNotEmpty ? _nameError : null,
                              ),
                              onChanged: (_) => _validateForm(),
                              maxLength: 50,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person,
                              color: Theme.of(context).primaryColor),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: Platform.isAndroid || Platform.isIOS
                                ? MediaQuery.of(context).size.width * 0.7
                                : MediaQuery.of(context).size.width * 0.15,
                            child: TextField(
                              controller: _familyNameController,
                              style: const TextStyle(fontSize: 20),
                              decoration: InputDecoration(
                                labelText: "Apellidos",
                                errorText: _familyNameError.isNotEmpty
                                    ? _familyNameError
                                    : null,
                              ),
                              onChanged: (_) => _validateForm(),
                              maxLength: 50,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: Platform.isAndroid || Platform.isIOS
                            ? MediaQuery.of(context).size.width * 0.8
                            : MediaQuery.of(context).size.width * 0.15,
                        child: TextField(
                          controller: _dniController,
                          style: const TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                            labelText: "DNI",
                            errorText: _dniError.isNotEmpty ? _dniError : null,
                          ),
                          onChanged: (_) => _validateForm(),
                          maxLength: 9,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: Platform.isAndroid || Platform.isIOS
                            ? MediaQuery.of(context).size.width * 0.8
                            : MediaQuery.of(context).size.width * 0.15,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _phoneController,
                          style: const TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            labelText: "Telefono",
                            errorText:
                                _phoneError.isNotEmpty ? _phoneError : null,
                          ),
                          onChanged: (_) => _validateForm(),
                          maxLength: 9,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: Platform.isAndroid || Platform.isIOS
                            ? MediaQuery.of(context).size.width * 0.8
                            : MediaQuery.of(context).size.width * 0.15,
                        child: TextField(
                          keyboardType: TextInputType.number,
                          controller: _ssController,
                          style: const TextStyle(fontSize: 18),
                          decoration: InputDecoration(
                            labelText: "SS",
                            errorText: _ssError.isNotEmpty ? _ssError : null,
                          ),
                          onChanged: (_) => _validateForm(),
                          maxLength: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.work,
                              color: Theme.of(context).primaryColor),
                          const SizedBox(width: 8),
                          const Text(
                            "Gestor",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Checkbox(
                            value: _isClerk,
                            onChanged: (bool? value) {
                              setState(() {
                                _isClerk = value ?? false;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              //BOTON
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                ),
                onPressed: _isFormValid
                    ? () {
                        Employee employee = Employee(
                            dni: _dniController.text,
                            idCatering: 1,
                            name: _nameController.text,
                            familyName: _familyNameController.text,
                            phone: int.parse(_phoneController.text),
                            ss: int.parse(_ssController.text),
                            clerk: _isClerk ? 1 : 0,
                            admin: 0);
                        addEmployee(employee);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Admin(emp: _emp),
                          ),
                        );
                      }
                    : null,
                child: const Text(
                  "Guardar datos",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validateForm() {
    setState(() {
      _isFormValid = true;

      _dniError = '';
      _nameError = '';
      _familyNameError = '';
      _phoneError = '';
      _ssError = '';

      final dniRegExp = RegExp(r'^\d{8}[A-Z]$');
      if (!dniRegExp.hasMatch(_dniController.text)) {
        _isFormValid = false;
        _dniError = 'DNI inválido';
      }

      if (_nameController.text.length > 50) {
        _isFormValid = false;
        _nameError = 'Nombre demasiado largo';
      }

      if (_familyNameController.text.length > 50) {
        _isFormValid = false;
        _familyNameError = 'Apellidos demasiado largos';
      }

      final phoneRegExp = RegExp(r'^\d{9}$');
      if (!phoneRegExp.hasMatch(_phoneController.text)) {
        _isFormValid = false;
        _phoneError = 'Teléfono inválido';
      }

      final ssRegExp = RegExp(r'^\d{12}$');
      if (!ssRegExp.hasMatch(_ssController.text)) {
        _isFormValid = false;
        _ssError = 'SS inválido';
      }
    });
  }
}

class CharacterLimitTextField extends TextField {
  @override
  // ignore: overridden_fields
  final int maxLength;

  CharacterLimitTextField({
    Key? key,
    required TextEditingController controller,
    this.maxLength = 50,
    InputDecoration? decoration,
    TextStyle? style,
    ValueChanged<String>? onChanged,
  }) : super(
          key: key,
          controller: controller,
          decoration: decoration,
          style: style,
          onChanged: onChanged,
          maxLength: maxLength,
          buildCounter: (BuildContext context,
                  {required int currentLength,
                  required bool isFocused,
                  required int? maxLength}) =>
              isFocused
                  ? null
                  : Text(
                      '$currentLength/$maxLength',
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
        );
}
