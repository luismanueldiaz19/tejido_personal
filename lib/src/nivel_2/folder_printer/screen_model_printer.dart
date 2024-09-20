import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/model/department.dart';
import 'package:tejidos/src/nivel_2/folder_printer/add_machine.dart';
import 'package:tejidos/src/nivel_2/folder_printer/add_type_work_printer.dart';
import 'package:tejidos/src/nivel_2/folder_printer/screen_printer.dart';
import 'package:tejidos/src/widgets/custom_app_bar.dart';

import '../../util/font_style.dart';
import 'printer_record/screen_record_desperdicios.dart';
import 'printer_record/screen_record_printer.dart';

class ScreenModelPrinter extends StatefulWidget {
  const ScreenModelPrinter({Key? key, this.current}) : super(key: key);
  final Department? current;

  @override
  State<ScreenModelPrinter> createState() => _ScreenModelPrinterState();
}

class _ScreenModelPrinterState extends State<ScreenModelPrinter> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          const AppBarCustom(title: 'Printer Department'),
          const SizedBox(height: 50),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(
                  bottom: size.height * 0.30, left: 50, right: 50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'printer',
                    child: Container(
                      width: 200,
                      height: 200,
                      color: Colors.brown,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const ScreenPrinter()));
                                  },
                                  icon: const Icon(Icons.print,
                                      size: 100, color: Colors.white)),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                'Trabajos Actuales',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: fontBalooPaaji),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Hero(
                    tag: '9585',
                    child: Container(
                      width: 200,
                      height: 200,
                      color: Colors.brown,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Historial',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontFamily: fontBalooPaaji),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ScreenRecordPrinter()));
                              },
                              child: const Icon(Icons.calendar_month,
                                  size: 100, color: Colors.white)),
                          Material(
                            color: Colors.transparent,
                            child: Text(
                              'Trabajos',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: fontBalooPaaji),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Hero(
                    tag: 'Despedicios',
                    child: Container(
                      width: 200,
                      height: 200,
                      color: Colors.red.shade500,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Material(
                              color: Colors.transparent,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const ScreenDesperdicios()));
                                },
                                icon: const Icon(Icons.border_bottom,
                                    size: 100, color: Colors.white),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                'Despedicios',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: fontBalooPaaji),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  currentUsers?.occupation == OptionAdmin.admin.name ||
                          currentUsers?.occupation == OptionAdmin.master.name ||
                          currentUsers?.occupation == OptionAdmin.boss.name
                      ? Container(
                          width: 200,
                          height: 200,
                          color: Colors.black,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const AddMachinePrinter();
                                      },
                                    );
                                  },
                                  child: const Icon(Icons.add_box_outlined,
                                      size: 100, color: Colors.white)),
                              Text(
                                'Agregar Printer',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: fontBalooPaaji),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(width: 20),
                  currentUsers?.occupation == OptionAdmin.admin.name ||
                          currentUsers?.occupation == OptionAdmin.master.name ||
                          currentUsers?.occupation == OptionAdmin.boss.name
                      ? Container(
                          width: 200,
                          height: 200,
                          color: Colors.blue,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const AddTypeWorkPrinter();
                                      },
                                    );
                                  },
                                  child: const Icon(Icons.add_box_outlined,
                                      size: 100, color: Colors.white)),
                              Text(
                                'Agregar Type Work',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontFamily: fontBalooPaaji),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
