import 'package:catering_plus/core/models/employee_model.dart';
import 'package:catering_plus/core/models/place_model.dart';
import 'package:catering_plus/core/provider/place_provider.dart';
import 'package:catering_plus/ui/view/clerk/clerk_ini.dart';
import 'package:flutter/material.dart';

class AddPlace extends StatefulWidget {
  final Employee emp;
  const AddPlace({Key? key, required this.emp}) : super(key: key);

  @override
  State<AddPlace> createState() => _AddPlaceState();
}

class _AddPlaceState extends State<AddPlace> {
  late Employee emp;
  late TextEditingController nameController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  late TextEditingController phoneController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    emp = widget.emp;
    nameController = TextEditingController(text: '');
    latitudeController = TextEditingController(text: '');
    longitudeController = TextEditingController(text: '');
    phoneController = TextEditingController(text: '');
  }

  @override
  void dispose() {
    nameController.dispose();
    latitudeController.dispose();
    longitudeController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese un nombre';
    }
    if (value.length > 50) {
      return 'El nombre debe tener como máximo 50 caracteres';
    }
    return null;
  }

  String? _validateCoordinate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese una coordenada';
    }
    final coordinate = double.tryParse(value);
    if (coordinate == null) {
      return 'Ingrese un valor numérico válido';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Ingrese un número de teléfono';
    }
    if (value.length != 9) {
      return 'El número de teléfono debe tener 9 dígitos';
    }
    final phone = int.tryParse(value);
    if (phone == null) {
      return 'Ingrese un número de teléfono válido';
    }
    return null;
  }

  void _savePlace() {
    if (_formKey.currentState!.validate()) {
      Place place = Place(
        name: nameController.text,
        idCatering: emp.idCatering,
        address: '${latitudeController.text},${longitudeController.text}',
        phone: int.parse(phoneController.text),
      );
      addPlace(place);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => Clerk(emp: emp),
        ),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Añadir Lugar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                ),
                validator: _validateName,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: latitudeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Latitud',
                  border: OutlineInputBorder(),
                ),
                validator: _validateCoordinate,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: longitudeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Longitud',
                  border: OutlineInputBorder(),
                ),
                validator: _validateCoordinate,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(),
                ),
                validator: _validatePhone,
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _savePlace,
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
