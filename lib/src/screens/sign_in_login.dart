import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/home.dart';
import 'package:tejidos/src/util/commo_pallete.dart';

import '../datebase/url.dart';
import '../model/new_usuario.dart';
import '../services/api_services.dart';
import '../util/helps.dart';

class SignInLogin extends StatefulWidget {
  const SignInLogin({super.key});

  @override
  State<SignInLogin> createState() => _SignInLoginState();
}

class _SignInLoginState extends State<SignInLogin> {
  TextEditingController usuarioController = TextEditingController(text: '1995');
  TextEditingController passwordController =
      TextEditingController(text: 'tygatyga');

  ApiService apiService = ApiService();

  bool isLoading1 = false;
  Future signIn(context) async {
    if (usuarioController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      String apiUrl =
          'http://$ipLocal/tejido_personal/admin/select/login.php'; // Cambia la URL por la tuya
      try {
        final body = {
          'usuario': usuarioController.text,
          'password': passwordController.text
        };
        // print(body);
        final response = await apiService.postRequest(apiUrl, body);
        // print(response);
        var data = json.decode(response);
        if (data['success']) {
          print('data json : ${data}');

          userLogged = newUsersFromJson(response);

          print('usuario de la class :${userLogged.usuario?.toJson()}');
          print('Total de Permiso :${userLogged.permisos?.length}');
          // Mostrar mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(data['message']), backgroundColor: Colors.green));

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
              (route) => false);
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
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos')),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    usuarioController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(width: size.width, height: kToolbarHeight),
            SizedBox(
                height: size.height * 0.30,
                child: Lottie.asset('animation/login_long.json',
                    repeat: true, reverse: true, fit: BoxFit.cover)),
            SlideInLeft(
              child: buildTextField('Usuario', usuarioController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
            ),
            SlideInRight(
              child: buildTextField('Contraseña', passwordController,
                  obscureText: true),
            ),
            const SizedBox(height: 10),
            BounceInUp(
              child: SizedBox(
                width: 250,
                child: ElevatedButton(
                  // style: styleButton,
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => colorsBlueTurquesa),
                      shape: MaterialStateProperty.resolveWith((states) =>
                          const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero))),
                  onPressed: () => signIn(context),
                  child: const Text('Iniciar Sección',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            identy(context),
            const SizedBox(),
          ],
        ),
      ),
    );
  }
}
