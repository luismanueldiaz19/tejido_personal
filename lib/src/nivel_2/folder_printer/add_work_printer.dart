import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';
import 'package:tejidos/src/nivel_2/folder_printer/model_printer/main_work_printer.dart';
import 'package:tejidos/src/nivel_2/folder_printer/model_printer/model_tipe_work.dart';
import 'package:tejidos/src/util/show_mesenger.dart';

// import 'package:tejidos/src/datebase/methond.dart';
// import 'package:tejidos/src/datebase/url.dart';

class AddWorkPrinter extends StatefulWidget {
  const AddWorkPrinter({super.key, this.listTypeWork, this.mainWork});
  final List<TypeWorkPrinter>? listTypeWork;
  final MainWorkPrint? mainWork;

  @override
  State<AddWorkPrinter> createState() => _AddWorkPrinterState();
}

class _AddWorkPrinterState extends State<AddWorkPrinter> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController numOrdenController = TextEditingController();
  TextEditingController fichaController = TextEditingController();
  TextEditingController logoController = TextEditingController();

  String typeWorked = '';
  String idTypeWork = '';

  Future sendMachine(context) async {
    if (typeWorked.isEmpty) {
      return utilShowMesenger(context, 'tipo de trabajo no selecionado');
    }
    if (_formKey.currentState!.validate()) {
      //insert_printer_machine

      var data = {
        'id_machine': widget.mainWork?.idMachine,
        'user_registed': currentUsers?.fullName,
        'id_work_printer': widget.mainWork?.idWorkPrinter,
        'id_type_work': idTypeWork,
        'ficha': fichaController.text,
        'logo': logoController.text,
        'num_orden': numOrdenController.text,
        'date_start': DateTime.now().toString().substring(0, 19),
      };

      //   print(data);
      insertOrdenesToPrinter(data);

      Navigator.of(context).pop();
    }
  }

  Future insertOrdenesToPrinter(data) async {
    // select_printer_machine
    String insertPrinterWork =
        "http://$ipLocal/settingmat/admin/insert/insert_printer_work.php";
    final res = await httpRequestDatabase(insertPrinterWork, data);

    print(res.body);
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
                controller: numOrdenController,
                decoration: const InputDecoration(labelText: 'Num Orden'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa el fabricante';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: fichaController,
                decoration: const InputDecoration(labelText: 'Ficha'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, ingresa el modelo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: logoController,
                decoration: const InputDecoration(labelText: 'LOGO'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, LOGO';
                  }
                  return null;
                },
              ),
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                    labelText: typeWorked, hintText: 'Tipo de trabajo'),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 75,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: widget.listTypeWork!
                        .map((item) => TextButton(
                            onPressed: () {
                              setState(() {
                                typeWorked =
                                    item.tipeWorkPrinter!.toUpperCase();
                                idTypeWork = item.id.toString();
                                print({
                                  'name_work': typeWorked,
                                  'idTypeWork': idTypeWork
                                });
                              });
                            },
                            child: Text(item.tipeWorkPrinter ?? 'N/A')))
                        .toList(),
                  ),
                ),
              )
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
          onPressed: () => sendMachine(context),
        ),
      ],
    );
  }
}
