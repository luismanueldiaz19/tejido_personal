import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import 'package:tejidos/src/datebase/methond.dart';
import 'package:tejidos/src/datebase/url.dart';

import 'model_printer/detail_print_orden.dart';

class DialogUpdateDetails extends StatefulWidget {
  const DialogUpdateDetails({super.key, required this.item});
  final DetailPrinterOrden item;

  @override
  State<DialogUpdateDetails> createState() => _DialogUpdateDetailsState();
}

class _DialogUpdateDetailsState extends State<DialogUpdateDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController pFullController = TextEditingController();
  TextEditingController pktController = TextEditingController();
  TextEditingController cantImprController = TextEditingController();

  @override
  void dispose() {
    pFullController.dispose();
    pktController.dispose();
    cantImprController.dispose();
    super.dispose();
  }

  void _submitForm(context) {
    if (_formKey.currentState!.validate()) {
      //Aquí puedes enviar los datos a tu base de datos
      String pFull = pFullController.text;
      String pkt = pktController.text;
      String cantImpr = cantImprController.text;

      var data = {
        'cant_impr': cantImpr,
        'pkt': pkt,
        'p_full': pFull,
        'date_end': DateTime.now().toString().substring(0, 19),
        'id': widget.item.id.toString(),
        'comment':
            '${widget.item.comment} - ${currentUsers?.fullName} ha reportado los sigt cant_impr $cantImpr - Pieza Full $pFull , pieza pkt $pkt a la ${DateTime.now().toString().substring(0, 19)}',
      };
      // print(data);
      updateData(data);
    }
  }

  Future updateData(data) async {
    // update_printer_work

    // select_printer_machine
    String updatePrinterWork =
        "http://$ipLocal/settingmat/admin/update/update_printer_work.php";
    await httpRequestDatabase(updatePrinterWork, data);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enviar Datos'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: cantImprController,
              decoration:
                  const InputDecoration(labelText: 'Cantidad de Impresiones'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa la cantidad de impresiones';
                }
                return null;
              },
            ),
            TextFormField(
              controller: pFullController,
              decoration: const InputDecoration(labelText: 'P Full'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa el P Full';
                }
                return null;
              },
            ),
            TextFormField(
              controller: pktController,
              decoration: const InputDecoration(labelText: 'Pkt'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor, ingresa el Pkt';
                }
                return null;
              },
            ),
          ],
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
          child: const Text('Enviar'),
          onPressed: () {
            _submitForm(context);
          },
        ),
      ],
    );
  }
}
