import 'dart:io';

import 'package:catering_plus/core/models/employee_model.dart';
import 'package:catering_plus/core/provider/employee_provider.dart';
import 'package:catering_plus/ui/view/admin/admin_ini.dart';
import 'package:flutter/material.dart';

class UpdateEmployee extends StatefulWidget {
  final Employee employee;
  final Employee emp;

  const UpdateEmployee({Key? key, required this.employee, required this.emp})
      : super(key: key);

  @override
  State<UpdateEmployee> createState() => _UpdateEmployeeState();
}

class _UpdateEmployeeState extends State<UpdateEmployee> {
  late Employee _employee;
  late Employee _emp;
  late TextEditingController _nameController;
  late TextEditingController _familyNameController;
  late TextEditingController _phoneController;
  late TextEditingController _ssController;
  late bool _isClerk;
  late bool _isFormValid;
  late String _nameError;
  late String _familyNameError;
  late String _phoneError;
  late String _ssError;

  @override
  void initState() {
    super.initState();
    _employee = widget.employee;
    _emp = widget.emp;
    _nameController = TextEditingController(text: _employee.name);
    _familyNameController = TextEditingController(text: _employee.familyName);
    _phoneController = TextEditingController(text: _employee.phone.toString());
    _ssController = TextEditingController(text: _employee.ss.toString());
    _isClerk = _employee.clerk == 0 ? false : true;
    _isFormValid = true;
    _nameError = '';
    _familyNameError = '';
    _phoneError = '';
    _ssError = '';
  }

  @override
  void dispose() {
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
        title: const Text("Datos del Empleado"),
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
                        children: [
                          Icon(
                            Icons.person,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: Platform.isAndroid || Platform.isIOS
                                ? MediaQuery.of(context).size.width * 0.7
                                : MediaQuery.of(context).size.width * 0.15,
                            child: TextField(
                              controller: _nameController,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
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
                        children: [
                          Icon(
                            Icons.person,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: Platform.isAndroid || Platform.isIOS
                                ? MediaQuery.of(context).size.width * 0.7
                                : MediaQuery.of(context).size.width * 0.15,
                            child: TextField(
                              controller: _familyNameController,
                              style: const TextStyle(
                                fontSize: 18,
                              ),
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
                      Text(
                        "DNI: ${_employee.dni}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
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
                          style: const TextStyle(
                            fontSize: 18,
                          ),
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
                          style: const TextStyle(
                            fontSize: 18,
                          ),
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
                        children: [
                          Icon(
                            Icons.work,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Gestor",
                            style: TextStyle(
                              fontSize: 18,
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
                        _employee.name = _nameController.text;
                        _employee.familyName = _familyNameController.text;
                        _employee.phone = int.parse(_phoneController.text);
                        _employee.ss = int.parse(_ssController.text);
                        _employee.clerk = _isClerk ? 1 : 0;
                        updateEmployee(_employee);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Admin(emp: _emp)),
                            (route) => false);
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

      _nameError = '';
      _familyNameError = '';
      _phoneError = '';
      _ssError = '';

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
