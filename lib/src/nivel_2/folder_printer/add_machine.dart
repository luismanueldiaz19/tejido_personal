import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/nivel_2/folder_printer/model_printer/printer_machine.dart';

// import 'package:tejidos/src/datebase/methond.dart';
// import 'package:tejidos/src/datebase/url.dart';

class AddMachinePrinter extends StatefulWidget {
  const AddMachinePrinter({super.key});

  @override
  State<AddMachinePrinter> createState() => _AddMachinePrinterState();
}

class _AddMachinePrinterState extends State<AddMachinePrinter> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController fabricanteController = TextEditingController();
  TextEditingController modeloController = TextEditingController();
  TextEditingController numMachineController = TextEditingController();
  TextEditingController serialController = TextEditingController();
  TextEditingController tipoController = TextEditingController();
  late MachinePrinter machinePrint;

  Future sendMachine() async {
    if (_formKey.currentState!.validate()) {
      //insert_printer_machine

      // Aquí puedes enviar los datos a un servidor
      String fabricante = fabricanteController.text;
      String modelo = modeloController.text;
      String numeroMaquina = numMachineController.text;
      String serial = serialController.text;
      String tipo = tipoController.text;

      Random numn = Random();
      // id_machine, number_machine, serial, modelo, tipo, fabricante
      var data = {
        'id_machine': numn.nextInt(99999).toString(),
        'number_machine': numeroMaquina,
        'serial': serial,
        'modelo': modelo,
        'tipo': tipo,
        'fabricante': fabricante,
      };
      insertMachineData(data);

      Navigator.of(context).pop();
    }
  }

  Future insertMachineData(data) async {
    // select_printer_machine
    String insertPrinterMachine =
        "http://$ipLocal/settingmat/admin/insert/insert_printer_machine.php";
    final res = await httpRequestDatabase(insertPrinterMachine, data);
    // print(res.body);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Agregar Máquina'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: fabricanteController,
                decoration: const InputDecoration(labelText: 'Fabricante'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa el fabricante';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: modeloController,
                decoration: const InputDecoration(labelText: 'Modelo'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa el modelo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: numMachineController,
                decoration:
                    const InputDecoration(labelText: 'Número de Máquina'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa el número de máquina';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: serialController,
                decoration: const InputDecoration(labelText: 'Serial'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa el serial';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: tipoController,
                decoration: const InputDecoration(labelText: 'Tipo'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa el tipo';
                  }
                  return null;
                },
              ),
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
          onPressed: () => sendMachine(),
        ),
      ],
    );
  }
}
