import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/home.dart';
import 'package:tejidos/src/model/users.dart';
import 'package:tejidos/src/util/commo_pallete.dart';

import 'package:tejidos/src/util/show_mesenger.dart';

class SignInLogin extends StatefulWidget {
  const SignInLogin({super.key});

  @override
  State<SignInLogin> createState() => _SignInLoginState();
}

class _SignInLoginState extends State<SignInLogin> {
  final TextEditingController code = TextEditingController();
  bool isLoading1 = false;
  Future signIn() async {
    if (code.text.isNotEmpty) {
      setState(() {
        isLoading1 = true;
      });
      final res =
          await httpRequestDatabase(selectUserLogin, {'code': code.text});
      // print('usuario Correspondiente ${res.body}');
      List<Users> list = usersFromJson(res.body);
      await Future.delayed(const Duration(seconds: 2));
      if (list.isNotEmpty) {
        currentUsers = list[0];
        if (mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
              (route) => false);
        }
      } else {
        if (mounted) utilShowMesenger(context, 'Usuario no existes');
      }

      setState(() {
        isLoading1 = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    code.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading1
          ? ZoomIn(
              child: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.50,
                      width: size.height * 0.50,
                      child: Lottie.asset('animation/login.json',
                          repeat: true, reverse: true, fit: BoxFit.cover),
                    ),
                  ],
                ),
              ),
            )
          : SingleChildScrollView(
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
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1.0)),
                      width: 250,
                      child: TextField(
                        controller: code,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        onEditingComplete: () => signIn(),
                        decoration: const InputDecoration(
                          hintText: 'Codigo',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(left: 15),
                        ),
                      ),
                    ),
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
                        onPressed: () => signIn(),
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
