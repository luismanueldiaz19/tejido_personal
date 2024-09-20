import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tejidos/src/datebase/current_data.dart';
import '../datebase/methond.dart';
import '../datebase/url.dart';
import '../widgets/picked_date_widget.dart';
import 'model/for_paid.dart';

class AddCuentaPorCobrar extends StatefulWidget {
  const AddCuentaPorCobrar({super.key});

  @override
  State<AddCuentaPorCobrar> createState() => _AddCuentaPorCobrarState();
}

class _AddCuentaPorCobrarState extends State<AddCuentaPorCobrar> {
  List<List<dynamic>?> _dataTable = [];

  String? firstDate = DateTime.now().toString().substring(0, 10);

  List<ForPaid> produccionList = [];

  Future<void> openFilePicker() async {
    produccionList.clear();
    // produccionListOriginal.clear();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'xls'],
    );

    if (result != null) {
      var bytes = File(result.files.first.path!).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      var table = excel.tables[excel.tables.keys.first];
      _dataTable = table!.rows.toList();

      int index = 0;
      for (var row in _dataTable) {
        if (row != _dataTable.first) {
          // f_documento	f_nombre	f_monto	f_balance	f_direccion	f_telefono	f_fecha	f_fecha_vencimiento	dias

          Data? fDocumento = row![0];
          Data? fNombre = row[1];
          Data? fMonto = row[2];
          Data? fBalance = row[3];
          Data? fDireccion = row[4];
          Data? fTelefono = row[5];
          Data? fFecha = row[6];
          Data? fFechaVencimiento = row[7];
          Data? dias = row[8];

          Random num = Random();

          produccionList.add(ForPaid(
              idPorPagarInter: "valor",
              fKeyInter: num.nextInt(999999999).toString(),
              interFecha: firstDate,
              interHora: firstDate,
              interRegited: currentUsers?.fullName ?? 'N/A',
              interComent: "N/A",
              interStatu: "valor",
              idPorPagar: "valor",
              fDocumento: '${fDocumento?.value ?? 'N/A'}',
              fNombre: '${fNombre?.value ?? 'N/A'}',
              fMonto: '${fMonto?.value ?? '0'}',
              fBalance: '${fBalance?.value ?? '0'}',
              fDireccion: '${fDireccion?.value ?? '0'}',
              fTelefono: '${fTelefono?.value ?? '0'}',
              numInter: "valor",
              statuPaid: "valor",
              aproved: "valor",
              fFechaVencimiento: '${fFechaVencimiento?.value ?? '0'}',
              fFecha: '${fFecha?.value ?? '0'}',
              fecha: firstDate,
              dias: '${dias?.value ?? '0'}'));

          if (index < 3) {
            print(' producionData Value - ${fDocumento?.value} - $firstDate');

            print('---------- -- -');
          }
          index++;
        }
      }
      setState(() {});
    }

    // plusProducion();
  }

  void enviarReport(context) async {
    final dataList = produccionList.map((item) {
      item.fecha = firstDate;
      return item.toJson();
    }).toList();
    var jsonData = jsonEncode(dataList);
    // print(jsonData);
    String insertPorPagar =
        "http://$ipLocal/settingmat/admin/insert/insert_por_pagar.php";

    final mjs = await httpEnviaMap(insertPorPagar, jsonData);

    if (!mounted) {
      return;
    }
    setState(() {
      produccionList.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mjs)));
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final style = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Cuenta Por Cobrar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(width: double.infinity),
            Text('FORMATO A SUBIR EL ARCHIVO ES',
                style: style.bodySmall?.copyWith(
                    color: Colors.blueAccent, fontWeight: FontWeight.bold)),
            const Text(
                'fDocumento - fNombre - fMonto - fBalance - fDireccion - fTelefono - fFecha - fFechaVencimiento - dias'),
            const Divider(),
            const SizedBox(height: 15),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Image.asset('assets/formato.png', scale: 2)),
            const SizedBox(height: 15),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                  onPressed: () async {
                    final date = await showDatePickerCustom(context: context);
                    if (date != null) {
                      setState(() {
                        firstDate = date;
                      });
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(firstDate ?? 'N/A'),
                      const SizedBox(width: 15),
                      Text('Fecha Creación', style: style.bodySmall),
                    ],
                  )),
            ),
            produccionList.isNotEmpty
                ? _dataTable.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Container(
                          width: 350,
                          height: 30,
                          color: Colors.green.shade300,
                          child: TextButton(
                            style: ButtonStyle(
                                shape: MaterialStateProperty.resolveWith(
                                    (states) => const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero))),
                            onPressed: () async {
                              if (_dataTable.isNotEmpty) {
                                enviarReport(context);
                              }
                            },
                            child: const Text('Hacer Reporte',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      )
                    : const SizedBox(height: 25)
                : const SizedBox(),
            const SizedBox(height: 10),
            produccionList.isNotEmpty
                ? Expanded(
                    child: SizedBox(
                      width: size.width * 0.65,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        padding: const EdgeInsets.only(bottom: 15),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            dataRowMaxHeight: 20,
                            dataRowMinHeight: 10,
                            horizontalMargin: 10.0,
                            columnSpacing: 15,
                            dataTextStyle: style.bodySmall,
                            headingTextStyle: style.labelSmall,
                            headingRowHeight: 20,
                            headingRowColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.blue.shade100),
                            dataRowColor: MaterialStateProperty.resolveWith(
                                (states) => Colors.white54),
                            columns: const [
                              DataColumn(label: Text('ID_KEY_UNIQUE')),
                              DataColumn(label: Text('DOCUMENTO')),
                              DataColumn(label: Text('NOMBRE')),
                              DataColumn(label: Text('MONTO')),
                              DataColumn(label: Text('BALANCE')),
                              DataColumn(label: Text('DIRECCION')),
                              DataColumn(label: Text('TELEFONO')),
                              DataColumn(label: Text('CREADO')),
                              DataColumn(label: Text('VENCE')),
                              DataColumn(label: Text('DIAS')),
                              DataColumn(label: Text('REGISTED')),
                            ],
                            rows: produccionList
                                .map(
                                  (item) => DataRow(cells: [
                                    DataCell(Text(item.fKeyInter ?? 'N/A')),
                                    DataCell(Text(item.fDocumento ?? 'N/A')),
                                    DataCell(Text(item.fNombre ?? 'N/A')),
                                    DataCell(
                                        Text('\$ ${item.fMonto ?? 'N/A'}')),
                                    DataCell(
                                        Text('\$ ${item.fBalance ?? 'N/A'}')),
                                    DataCell(Text(item.fDireccion ?? 'N/A')),
                                    DataCell(Text(item.fTelefono ?? 'N/A')),
                                    DataCell(Text(item.fFecha ?? 'N/A')),
                                    DataCell(
                                        Text(item.fFechaVencimiento ?? 'N/A')),
                                    DataCell(Text(item.dias ?? 'N/A')),
                                    DataCell(Text(item.interRegited ?? 'N/A')),
                                  ]),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(child: Text('No Hay Datos Para Enviar')),
            const SizedBox(height: 10),
            Container(
              width: 250,
              color: Colors.blue.shade50,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              alignment: Alignment.center,
              child: TextButton(
                onPressed: () => openFilePicker(),
                child: Text('Buscar Archivo', style: style.titleMedium),
              ),
            ),
            const SizedBox(height: 10),
            produccionList.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(bottom: 25, top: 1),
                    child: Bounce(
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith(
                                      (states) => Colors.red)),
                          onPressed: () {
                            setState(() {
                              produccionList.clear();
                            });
                          },
                          child: Text('ELIMINAR  (${produccionList.length})',
                              style: const TextStyle(color: Colors.white))),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
