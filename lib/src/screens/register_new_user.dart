import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/services/api_services.dart';
import 'package:tejidos/src/util/helps.dart';

class RegisterNewUser extends StatefulWidget {
  const RegisterNewUser({super.key});

  @override
  State<RegisterNewUser> createState() => _RegisterNewUserState();
}

class _RegisterNewUserState extends State<RegisterNewUser> {
  // Controladores para los campos del formulario
  TextEditingController fullNameController = TextEditingController();
  TextEditingController usuarioController = TextEditingController();
  TextEditingController ocupacionController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController typeAccesoController = TextEditingController();

  TextEditingController idRolleController = TextEditingController();
  ApiService apiService = ApiService();
  // Función para registrar un nuevo usuario
  Future<void> registerUser(context) async {
    String apiUrl =
        'http://$ipLocal/tejido_personal/admin/insert/insert_new_usuario.php'; // Cambia la URL por la tuya
    try {
      final body = {
        'full_name': fullNameController.text,
        'usuario': usuarioController.text,
        'ocupacion': ocupacionController.text,
        'password': passwordController.text,
        'id_rolle': idRolleController.text,
        'type_access': typeAccesoController.text,
      };
      print(body);
      final response = await apiService.postRequest(apiUrl, body);

      print(response);
      var data = json.decode(response);

      if (data['success']) {
        print(data['message']);
        // Mostrar mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(data['message']), backgroundColor: Colors.green));
      } else {
        print(data['message']);
        // Mostrar mensaje de error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${data['message']}')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar nuevo usuario'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(width: double.infinity),
            buildTextField('Nombre completo', fullNameController),
            buildTextField('Usuario', usuarioController),
            buildTextField('Ocupación', ocupacionController),
            buildTextField('Contraseña', passwordController, obscureText: true),
            buildTextField('Acceso', typeAccesoController),
            buildTextField('ID del Rol', idRolleController,
                keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (fullNameController.text.isNotEmpty &&
                    usuarioController.text.isNotEmpty &&
                    ocupacionController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty &&
                    idRolleController.text.isNotEmpty &&
                    typeAccesoController.text.isNotEmpty) {
                  registerUser(
                      context); // Llama a la función para registrar al usuario
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Por favor, complete todos los campos')),
                  );
                }
              },
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }


}
