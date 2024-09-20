// insert_printer_work_main

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/nivel_2/folder_printer/model_printer/printer_machine.dart';

// import 'package:tejidos/src/datebase/methond.dart';
// import 'package:tejidos/src/datebase/url.dart';

class AddMainPrinterWork extends StatefulWidget {
  const AddMainPrinterWork({super.key, this.idMachinePrinter});
  final MachinePrinter? idMachinePrinter;

  @override
  State<AddMainPrinterWork> createState() => _AddMainPrinterWorkState();
}

class _AddMainPrinterWorkState extends State<AddMainPrinterWork> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController dimensionCmController = TextEditingController();
  String idPrinter = '';

  Future sendMainPrinter(context) async {
    // if (typeWorked.isEmpty) {
    //   return utilShowMesenger(context, 'tipo de trabajo no selecionado');
    // }
    if (_formKey.currentState!.validate()) {
      //insert_printer_machine

      // $id_machine = $_POST['id_machine'];
      // $id_work_printer = $_POST['id_work_printer'];
      // $dimension_cm = $_POST['dimension_cm'];
      Random num = Random();
      var data = {
        'id_machine': widget.idMachinePrinter?.idPrinterMachine,
        'id_work_printer': num.nextInt(999999999).toString(),
        'dimension_cm': dimensionCmController.text,
        'first_date': DateTime.now().toString().substring(0, 19),
        'is_finished': 'f'
      };

      // print(data);
      insertData(data);

      Navigator.of(context).pop(true);
    }
  }

  Future insertData(data) async {
    // select_printer_machine
    String insertPrinterWorkMain =
        "http://$ipLocal/settingmat/admin/insert/insert_printer_work_main.php";
    final res = await httpRequestDatabase(insertPrinterWorkMain, data);
    print(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar Dimención Papel'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'Printer : ${widget.idMachinePrinter?.numberMachine}'),
                      Text('modelo : ${widget.idMachinePrinter?.modelo}'),
                      Text('Serie : ${widget.idMachinePrinter?.serial}'),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: dimensionCmController,
                decoration:
                    const InputDecoration(labelText: 'Dimención papel cm'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa la dimención papel';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          child: const Text('Guardar'),
          onPressed: () => sendMainPrinter(context),
        ),
      ],
    );
  }
}
