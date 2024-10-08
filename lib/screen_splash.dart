import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:tejidos/src/screens/sign_in_login.dart';

import 'screen_update.dart';
import 'src/datebase/current_data.dart';
import 'src/datebase/methond.dart';
import 'src/datebase/url.dart';
import 'src/widgets/loading.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  // final Future<Map<String, dynamic>> updateInfo = checkForUpdates();

  // static Future<Map<String, dynamic>> checkForUpdates() async {
  //   await Future.delayed(const Duration(seconds: 2));
  //   try {
  //     final response =
  //         await httpRequestDatabase(selectUpdateApp, {'view': 'view'});
  //     // print(response.body);
  //     return jsonDecode(response.body);
  //   } catch (e) {
  //     // print("Error al verificar actualizaciones: $e");
  //   }

  //   return {};
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('_zoomAnimation ${_zoomAnimation?.value}');
    return const Scaffold(body: SignInLogin());
  }
}
