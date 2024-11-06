import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/drawer/drawer_menu_custom.dart';
import 'package:tejidos/src/widgets/nivel_widgets.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Future getGlobalDateTime() async {
    dateActual = DateTime.now();
  }

  @override
  void initState() {
    super.initState();
    getGlobalDateTime();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final style = Theme.of(context).textTheme;
    return size.width <= 800
        ? Scaffold(
            drawer: const DrawerMenuCustom(),
            appBar: AppBar(title: const Text(nameApp)),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: Text('Departments',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.grey)),
                ),
                const Expanded(child: NivelWidgets())
              ],
            ),
          )
        : Scaffold(
            key: _scaffoldKey,
            drawer: const DrawerMenuCustom(),
            body: const Expanded(
              child: Row(
                children: [DrawerMenuCustom(), Expanded(child: NivelWidgets())],
              ),
            ),
          );
  }
}
