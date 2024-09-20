import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';

class AddTypeWorkPrinter extends StatefulWidget {
  const AddTypeWorkPrinter({super.key});

  @override
  State<AddTypeWorkPrinter> createState() => _AddTypeWorkPrinterState();
}

class _AddTypeWorkPrinterState extends State<AddTypeWorkPrinter> {
  TextEditingController jobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Escribir tipo de trabajo'),
      content: TextField(
        onEditingComplete: () {
          if (jobController.text.isNotEmpty) {
            _sendJobToServer(jobController.text);
            Navigator.of(context).pop();
          }
        },
        controller: jobController,
        decoration: const InputDecoration(hintText: 'Tipo de trabajo'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (jobController.text.isNotEmpty) {
              _sendJobToServer(jobController.text);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Enviar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
      ],
    );
  }

  void _sendJobToServer(String job) async {
    // print(job);
    String insertPrinterTypeWork =
        "http://$ipLocal/settingmat/admin/insert/insert_printer_type_work.php";

    var data = {'tipe_work_printer': job.toUpperCase()};
    final res = await httpRequestDatabase(insertPrinterTypeWork, data);
    print(res.body);
  }
}
